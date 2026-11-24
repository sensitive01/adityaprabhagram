-- ============================================================
-- AdityaPrabhaGram — Full Schema Migration
-- Timestamp: 20260817120000
-- Supersedes: 20260817000001_fieldops_auth_roles.sql
-- 
-- WHAT THIS MIGRATION DOES:
--   1. Extends user_role enum to add ADMIN and CLUSTER_HEAD
--   2. Extends user_profiles with new columns (username, phone, is_active,
--      must_change_password, created_by)
--   3. Extends households: adds UUID-based hh_id, full address fields,
--      updated_at, created_by (keeps TEXT PK for backward compat)
--   4. Extends surveys: adds template_id, reviewed_by, submitted_at,
--      reviewed_at, approved_at
--   5. Creates all new tables: clusters, cluster_heads,
--      field_agent_cluster_assignments, household_agent_assignments,
--      household_members, 19 household data tables,
--      survey_templates, survey_sections, survey_questions,
--      survey_question_options, survey_answers, survey_status_history,
--      bulletins, household_questions, question_answers, audit_log
--   6. Creates partial unique indexes enforcing all 4 hard business rules
--   7. Creates all helper functions
--   8. Applies RLS policies for all 4 roles
--   9. Creates immutability triggers (hh_id, username, role self-elevation)
-- ============================================================

-- ============================================================
-- SECTION 1: EXTEND ENUMS
-- ============================================================

-- Extend user_role to add ADMIN and CLUSTER_HEAD
-- ALTER TYPE ADD VALUE is idempotent-safe with IF NOT EXISTS (Postgres 9.6+)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_enum
        WHERE enumlabel = 'ADMIN'
        AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')
    ) THEN
        ALTER TYPE public.user_role ADD VALUE 'ADMIN';
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_enum
        WHERE enumlabel = 'CLUSTER_HEAD'
        AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'user_role')
    ) THEN
        ALTER TYPE public.user_role ADD VALUE 'CLUSTER_HEAD';
    END IF;
END $$;

-- question_type enum (new)
DROP TYPE IF EXISTS public.question_type CASCADE;
CREATE TYPE public.question_type AS ENUM (
    'text', 'number', 'yes_no', 'single_choice',
    'multiple_choice', 'date', 'photo', 'gps'
);

-- ============================================================
-- SECTION 2: EXTEND EXISTING TABLES
-- ============================================================

-- ── user_profiles: add new columns ──────────────────────────
ALTER TABLE public.user_profiles
    ADD COLUMN IF NOT EXISTS username TEXT,
    ADD COLUMN IF NOT EXISTS phone TEXT,
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN IF NOT EXISTS must_change_password BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS created_by UUID;

-- Unique constraint on username (skip if already exists)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'user_profiles_username_key'
        AND conrelid = 'public.user_profiles'::regclass
    ) THEN
        ALTER TABLE public.user_profiles ADD CONSTRAINT user_profiles_username_key UNIQUE (username);
    END IF;
END $$;

-- ── households: add new columns (keep TEXT PK for backward compat) ──
ALTER TABLE public.households
    ADD COLUMN IF NOT EXISTS hh_id TEXT,
    ADD COLUMN IF NOT EXISTS respondent_name TEXT,
    ADD COLUMN IF NOT EXISTS household_head TEXT,
    ADD COLUMN IF NOT EXISTS contact_number TEXT,
    ADD COLUMN IF NOT EXISTS block TEXT,
    ADD COLUMN IF NOT EXISTS state TEXT DEFAULT 'Manipur',
    ADD COLUMN IF NOT EXISTS family_size INTEGER,
    ADD COLUMN IF NOT EXISTS tribe_community TEXT,
    ADD COLUMN IF NOT EXISTS household_type TEXT,
    ADD COLUMN IF NOT EXISTS house_type TEXT,
    ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION,
    ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION,
    ADD COLUMN IF NOT EXISTS enumerator_name TEXT,
    ADD COLUMN IF NOT EXISTS survey_date DATE,
    ADD COLUMN IF NOT EXISTS remarks TEXT,
    ADD COLUMN IF NOT EXISTS created_by UUID,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

-- Unique constraint on hh_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'households_hh_id_key'
        AND conrelid = 'public.households'::regclass
    ) THEN
        ALTER TABLE public.households ADD CONSTRAINT households_hh_id_key UNIQUE (hh_id);
    END IF;
END $$;

-- ── surveys: add new columns ─────────────────────────────────
ALTER TABLE public.surveys
    ADD COLUMN IF NOT EXISTS template_id UUID,
    ADD COLUMN IF NOT EXISTS reviewed_by UUID,
    ADD COLUMN IF NOT EXISTS submitted_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ;

-- ============================================================
-- SECTION 3: NEW CORE TABLES
-- ============================================================

-- ── clusters ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.clusters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cluster_code TEXT NOT NULL,
    cluster_name TEXT NOT NULL,
    district TEXT,
    state TEXT DEFAULT 'Manipur',
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'clusters_cluster_code_key'
        AND conrelid = 'public.clusters'::regclass
    ) THEN
        ALTER TABLE public.clusters ADD CONSTRAINT clusters_cluster_code_key UNIQUE (cluster_code);
    END IF;
END $$;

-- ── cluster_heads ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cluster_heads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cluster_id UUID NOT NULL REFERENCES public.clusters(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    deactivated_at TIMESTAMPTZ,
    deactivated_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    notes TEXT
);

-- HARD RULE 1a: One active Cluster Head per Cluster
CREATE UNIQUE INDEX IF NOT EXISTS uq_cluster_heads_one_active_per_cluster
    ON public.cluster_heads (cluster_id)
    WHERE (is_active = true);

-- HARD RULE 1b: One active Cluster per Cluster Head
CREATE UNIQUE INDEX IF NOT EXISTS uq_cluster_heads_one_active_per_user
    ON public.cluster_heads (user_id)
    WHERE (is_active = true);

-- ── field_agent_cluster_assignments ──────────────────────────
CREATE TABLE IF NOT EXISTS public.field_agent_cluster_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE RESTRICT,
    cluster_id UUID NOT NULL REFERENCES public.clusters(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    deactivated_at TIMESTAMPTZ,
    deactivated_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    notes TEXT
);

-- HARD RULE 2: One active Cluster per Field Agent
CREATE UNIQUE INDEX IF NOT EXISTS uq_fa_cluster_one_active_per_agent
    ON public.field_agent_cluster_assignments (agent_id)
    WHERE (is_active = true);

-- ── household_agent_assignments ───────────────────────────────
CREATE TABLE IF NOT EXISTS public.household_agent_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE RESTRICT,
    agent_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    deactivated_at TIMESTAMPTZ,
    deactivated_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    notes TEXT
);

-- HARD RULE 3: One active Field Agent per Household
CREATE UNIQUE INDEX IF NOT EXISTS uq_hh_agent_one_active_per_household
    ON public.household_agent_assignments (household_id)
    WHERE (is_active = true);

-- ============================================================
-- SECTION 4: HOUSEHOLD MEMBER TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS public.household_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    member_name TEXT,
    age INTEGER,
    gender TEXT,
    relation_to_head TEXT,
    education_level TEXT,
    occupation TEXT,
    marital_status TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECTION 5: 19 REPEATABLE HOUSEHOLD DATA TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.land_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    land_type TEXT,
    area_acres DECIMAL,
    irrigation_type TEXT,
    soil_type TEXT,
    land_use TEXT,
    ownership_document TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.livestock (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    animal_type TEXT,
    breed TEXT,
    count INTEGER,
    purpose TEXT,
    annual_income DECIMAL,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.crops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    crop_name TEXT,
    season TEXT,
    area_acres DECIMAL,
    variety TEXT,
    yield_kg DECIMAL,
    input_cost DECIMAL,
    sale_price DECIMAL,
    market_sold_at TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.pests_diseases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    crop_name TEXT,
    pest_disease_name TEXT,
    severity TEXT,
    control_method TEXT,
    chemical_used TEXT,
    loss_percentage DECIMAL,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.climate_change_organic_itk (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    observation_type TEXT,
    description TEXT,
    practice_adopted TEXT,
    year_started INTEGER,
    outcome TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.income (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    source TEXT,
    season TEXT,
    amount DECIMAL,
    frequency TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.marketing (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    product TEXT,
    market_name TEXT,
    distance_km DECIMAL,
    transport_mode TEXT,
    price_per_unit DECIMAL,
    quantity_sold DECIMAL,
    buyer_type TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.money_circulation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    transaction_type TEXT,
    source TEXT,
    amount DECIMAL,
    purpose TEXT,
    repayment_status TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.schemes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    scheme_name TEXT,
    scheme_type TEXT,
    benefit_received TEXT,
    year INTEGER,
    amount DECIMAL,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.extension_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    service_type TEXT,
    provider TEXT,
    frequency TEXT,
    usefulness_rating INTEGER,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.training_needs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    enterprise TEXT,
    topic TEXT,
    priority_level TEXT,
    preferred_mode TEXT,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.gender_decision_making (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    activity TEXT,
    decision_maker TEXT,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.expenditure (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    category TEXT,
    amount DECIMAL,
    frequency TEXT,
    season TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.gender_work_distribution (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    activity TEXT,
    male_days DECIMAL,
    female_days DECIMAL,
    season TEXT,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.food_security_nutrition (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    food_item TEXT,
    source TEXT,
    months_available INTEGER,
    deficit_months TEXT,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.skill_based_need_assessment (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    skill_area TEXT,
    current_level TEXT,
    desired_level TEXT,
    training_preferred TEXT,
    remarks TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.border_specific_constraints (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    constraint_type TEXT,
    description TEXT,
    severity TEXT,
    suggested_solution TEXT,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    observation_by TEXT,
    observation_text TEXT,
    photo_url TEXT,
    gps_lat DOUBLE PRECISION,
    gps_lng DOUBLE PRECISION,
    created_by UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECTION 6: SURVEY CONFIGURATION TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.survey_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.survey_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    template_id UUID NOT NULL REFERENCES public.survey_templates(id) ON DELETE CASCADE,
    section_code TEXT,
    section_title TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.survey_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    section_id UUID NOT NULL REFERENCES public.survey_sections(id) ON DELETE CASCADE,
    question_code TEXT,
    question_text TEXT NOT NULL,
    question_type public.question_type NOT NULL DEFAULT 'text'::public.question_type,
    required BOOLEAN NOT NULL DEFAULT false,
    display_order INTEGER NOT NULL DEFAULT 0,
    help_text TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    conditional_on_question_id UUID REFERENCES public.survey_questions(id) ON DELETE SET NULL,
    conditional_on_value TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.survey_question_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES public.survey_questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    option_value TEXT NOT NULL,
    display_order INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true
);

-- ============================================================
-- SECTION 7: SURVEY EXECUTION TABLES
-- ============================================================

-- survey_answers (new canonical answer store)
CREATE TABLE IF NOT EXISTS public.survey_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id UUID NOT NULL REFERENCES public.surveys(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.survey_questions(id) ON DELETE RESTRICT,
    answer_text TEXT,
    answer_options TEXT[],
    photo_url TEXT,
    gps_lat DOUBLE PRECISION,
    gps_lng DOUBLE PRECISION,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- One answer per question per survey
CREATE UNIQUE INDEX IF NOT EXISTS uq_survey_answers_survey_question
    ON public.survey_answers (survey_id, question_id);

-- survey_status_history (immutable audit trail)
CREATE TABLE IF NOT EXISTS public.survey_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id UUID NOT NULL REFERENCES public.surveys(id) ON DELETE CASCADE,
    from_status public.survey_status,
    to_status public.survey_status NOT NULL,
    changed_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    notes TEXT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECTION 8: COMMUNICATION TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS public.bulletins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    body TEXT,
    attachment_url TEXT,
    published_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    target_cluster_id UUID REFERENCES public.clusters(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.household_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    asked_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    question_text TEXT,
    voice_note_url TEXT,
    pdf_url TEXT,
    image_url TEXT,
    is_answered BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public.question_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES public.household_questions(id) ON DELETE CASCADE,
    answered_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    answer_text TEXT,
    voice_note_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECTION 9: AUDIT LOG
-- ============================================================

CREATE TABLE IF NOT EXISTS public.audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name TEXT NOT NULL,
    record_id TEXT,
    action TEXT NOT NULL,
    performed_by UUID,
    old_data JSONB,
    new_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SECTION 10: INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_clusters_is_active ON public.clusters(is_active);
CREATE INDEX IF NOT EXISTS idx_cluster_heads_cluster_id ON public.cluster_heads(cluster_id);
CREATE INDEX IF NOT EXISTS idx_cluster_heads_user_id ON public.cluster_heads(user_id);
CREATE INDEX IF NOT EXISTS idx_fa_cluster_agent_id ON public.field_agent_cluster_assignments(agent_id);
CREATE INDEX IF NOT EXISTS idx_fa_cluster_cluster_id ON public.field_agent_cluster_assignments(cluster_id);
CREATE INDEX IF NOT EXISTS idx_hh_agent_household_id ON public.household_agent_assignments(household_id);
CREATE INDEX IF NOT EXISTS idx_hh_agent_agent_id ON public.household_agent_assignments(agent_id);
CREATE INDEX IF NOT EXISTS idx_household_members_household_id ON public.household_members(household_id);
CREATE INDEX IF NOT EXISTS idx_land_assets_household_id ON public.land_assets(household_id);
CREATE INDEX IF NOT EXISTS idx_livestock_household_id ON public.livestock(household_id);
CREATE INDEX IF NOT EXISTS idx_crops_household_id ON public.crops(household_id);
CREATE INDEX IF NOT EXISTS idx_pests_diseases_household_id ON public.pests_diseases(household_id);
CREATE INDEX IF NOT EXISTS idx_income_household_id ON public.income(household_id);
CREATE INDEX IF NOT EXISTS idx_marketing_household_id ON public.marketing(household_id);
CREATE INDEX IF NOT EXISTS idx_money_circulation_household_id ON public.money_circulation(household_id);
CREATE INDEX IF NOT EXISTS idx_schemes_household_id ON public.schemes(household_id);
CREATE INDEX IF NOT EXISTS idx_extension_services_household_id ON public.extension_services(household_id);
CREATE INDEX IF NOT EXISTS idx_training_needs_household_id ON public.training_needs(household_id);
CREATE INDEX IF NOT EXISTS idx_gender_decision_household_id ON public.gender_decision_making(household_id);
CREATE INDEX IF NOT EXISTS idx_expenditure_household_id ON public.expenditure(household_id);
CREATE INDEX IF NOT EXISTS idx_gender_work_household_id ON public.gender_work_distribution(household_id);
CREATE INDEX IF NOT EXISTS idx_food_security_household_id ON public.food_security_nutrition(household_id);
CREATE INDEX IF NOT EXISTS idx_skill_assessment_household_id ON public.skill_based_need_assessment(household_id);
CREATE INDEX IF NOT EXISTS idx_border_constraints_household_id ON public.border_specific_constraints(household_id);
CREATE INDEX IF NOT EXISTS idx_observations_household_id ON public.observations(household_id);
CREATE INDEX IF NOT EXISTS idx_survey_templates_is_active ON public.survey_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_survey_sections_template_id ON public.survey_sections(template_id);
CREATE INDEX IF NOT EXISTS idx_survey_questions_section_id ON public.survey_questions(section_id);
CREATE INDEX IF NOT EXISTS idx_survey_question_options_question_id ON public.survey_question_options(question_id);
CREATE INDEX IF NOT EXISTS idx_survey_answers_survey_id ON public.survey_answers(survey_id);
CREATE INDEX IF NOT EXISTS idx_survey_status_history_survey_id ON public.survey_status_history(survey_id);
CREATE INDEX IF NOT EXISTS idx_bulletins_target_cluster_id ON public.bulletins(target_cluster_id);
CREATE INDEX IF NOT EXISTS idx_household_questions_household_id ON public.household_questions(household_id);
CREATE INDEX IF NOT EXISTS idx_question_answers_question_id ON public.question_answers(question_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_table_name ON public.audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_performed_by ON public.audit_log(performed_by);

-- ============================================================
-- SECTION 11: HELPER FUNCTIONS (must be before RLS policies)
-- ============================================================

-- get_my_role: returns current user's role as TEXT
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT role::TEXT FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$;

-- is_admin: checks if current user is ADMIN
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role::TEXT = 'ADMIN'
    );
$$;

-- is_cluster_head: checks if current user is CLUSTER_HEAD
CREATE OR REPLACE FUNCTION public.is_cluster_head()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role::TEXT = 'CLUSTER_HEAD'
    );
$$;

-- is_field_agent: checks if current user is FIELD_AGENT
CREATE OR REPLACE FUNCTION public.is_field_agent()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role::TEXT = 'FIELD_AGENT'
    );
$$;

-- is_household_user: checks if current user is HOUSEHOLD
CREATE OR REPLACE FUNCTION public.is_household_user()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role::TEXT = 'HOUSEHOLD'
    );
$$;

-- get_my_cluster_id: returns the cluster_id for the current CLUSTER_HEAD
CREATE OR REPLACE FUNCTION public.get_my_cluster_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT cluster_id FROM public.cluster_heads
    WHERE user_id = auth.uid() AND is_active = true
    LIMIT 1;
$$;

-- get_my_agent_cluster_id: returns the cluster_id for the current FIELD_AGENT
CREATE OR REPLACE FUNCTION public.get_my_agent_cluster_id()
RETURNS UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT cluster_id FROM public.field_agent_cluster_assignments
    WHERE agent_id = auth.uid() AND is_active = true
    LIMIT 1;
$$;

-- is_my_assigned_household: checks if a household is assigned to the current FIELD_AGENT
CREATE OR REPLACE FUNCTION public.is_my_assigned_household(hh_id_param TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.household_agent_assignments
        WHERE household_id = hh_id_param
        AND agent_id = auth.uid()
        AND is_active = true
    );
$$;

-- is_my_household: checks if a household belongs to the current HOUSEHOLD user
CREATE OR REPLACE FUNCTION public.is_my_household(hh_id_param TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.households
        WHERE id = hh_id_param
        AND household_user_id = auth.uid()
    );
$$;

-- is_household_in_my_cluster: checks if a household is in the current CLUSTER_HEAD's cluster
-- (via field agent assignment chain)
CREATE OR REPLACE FUNCTION public.is_household_in_my_cluster(hh_id_param TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.household_agent_assignments haa
        JOIN public.field_agent_cluster_assignments faca
            ON haa.agent_id = faca.agent_id AND faca.is_active = true
        WHERE haa.household_id = hh_id_param
        AND haa.is_active = true
        AND faca.cluster_id = public.get_my_cluster_id()
    );
$$;

-- handle_new_user: auto-creates user_profile on auth signup (updated to include new columns)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, role, avatar_url, username, is_active, must_change_password)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        (COALESCE(NEW.raw_user_meta_data->>'role', 'HOUSEHOLD'))::public.user_role,
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', ''),
        COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
        true,
        COALESCE((NEW.raw_user_meta_data->>'must_change_password')::BOOLEAN, false)
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$;

-- ============================================================
-- SECTION 12: IMMUTABILITY TRIGGER FUNCTIONS
-- ============================================================

-- Enforce immutable fields on user_profiles
CREATE OR REPLACE FUNCTION public.enforce_user_profiles_immutable_fields()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_acting_role TEXT;
BEGIN
    SELECT role::TEXT INTO v_acting_role
    FROM public.user_profiles
    WHERE id = auth.uid()
    LIMIT 1;

    -- id is always immutable
    IF NEW.id <> OLD.id THEN
        RAISE EXCEPTION 'user_profiles.id is immutable and cannot be changed';
    END IF;

    -- username is immutable for ALL users
    IF NEW.username IS DISTINCT FROM OLD.username THEN
        RAISE EXCEPTION 'username is immutable and cannot be changed after creation';
    END IF;

    -- created_by is immutable
    IF NEW.created_by IS DISTINCT FROM OLD.created_by THEN
        RAISE EXCEPTION 'user_profiles.created_by is immutable and cannot be changed';
    END IF;

    -- role: no user can change their OWN role
    IF NEW.role <> OLD.role THEN
        IF OLD.id = auth.uid() THEN
            RAISE EXCEPTION 'A user cannot change their own role. Role changes are ADMIN-only operations on other accounts.';
        END IF;
        IF v_acting_role <> 'ADMIN' THEN
            RAISE EXCEPTION 'Only ADMIN can change user roles. Denied for role: %', v_acting_role;
        END IF;
    END IF;

    -- is_active: no user can change their own is_active
    IF NEW.is_active <> OLD.is_active THEN
        IF OLD.id = auth.uid() THEN
            RAISE EXCEPTION 'A user cannot change their own is_active status.';
        END IF;
        IF v_acting_role <> 'ADMIN' THEN
            RAISE EXCEPTION 'Only ADMIN can activate or deactivate user accounts.';
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

-- Enforce hh_id immutability on households
CREATE OR REPLACE FUNCTION public.enforce_hh_id_immutable()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    IF NEW.hh_id IS DISTINCT FROM OLD.hh_id AND OLD.hh_id IS NOT NULL THEN
        RAISE EXCEPTION 'households.hh_id is immutable. The government-issued Household ID cannot be changed after creation.';
    END IF;
    RETURN NEW;
END;
$$;

-- ============================================================
-- SECTION 13: ENABLE RLS ON ALL NEW TABLES
-- ============================================================

ALTER TABLE public.clusters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cluster_heads ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.field_agent_cluster_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_agent_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.land_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.livestock ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pests_diseases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.climate_change_organic_itk ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.income ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.marketing ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.money_circulation ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.schemes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.extension_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.training_needs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gender_decision_making ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenditure ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gender_work_distribution ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_security_nutrition ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skill_based_need_assessment ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.border_specific_constraints ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_question_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.survey_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bulletins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 14: RLS POLICIES
-- ============================================================

-- ── user_profiles ────────────────────────────────────────────
-- Drop existing policy from old migration
DROP POLICY IF EXISTS "users_manage_own_profile" ON public.user_profiles;

-- SELECT: own row
DROP POLICY IF EXISTS "up_select_own" ON public.user_profiles;
CREATE POLICY "up_select_own"
ON public.user_profiles FOR SELECT
TO authenticated
USING (id = auth.uid());

-- SELECT: ADMIN sees all
DROP POLICY IF EXISTS "up_select_admin" ON public.user_profiles;
CREATE POLICY "up_select_admin"
ON public.user_profiles FOR SELECT
TO authenticated
USING (public.is_admin());

-- UPDATE: own row (trigger enforces immutable fields)
DROP POLICY IF EXISTS "up_update_own" ON public.user_profiles;
CREATE POLICY "up_update_own"
ON public.user_profiles FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- UPDATE: ADMIN updates other users
DROP POLICY IF EXISTS "up_update_admin_others" ON public.user_profiles;
CREATE POLICY "up_update_admin_others"
ON public.user_profiles FOR UPDATE
TO authenticated
USING (public.is_admin() AND id <> auth.uid())
WITH CHECK (public.is_admin() AND id <> auth.uid());

-- INSERT: ADMIN only
DROP POLICY IF EXISTS "up_insert_admin" ON public.user_profiles;
CREATE POLICY "up_insert_admin"
ON public.user_profiles FOR INSERT
TO authenticated
WITH CHECK (public.is_admin());

-- DELETE: ADMIN only
DROP POLICY IF EXISTS "up_delete_admin" ON public.user_profiles;
CREATE POLICY "up_delete_admin"
ON public.user_profiles FOR DELETE
TO authenticated
USING (public.is_admin());

-- ── clusters ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "clusters_select_admin" ON public.clusters;
CREATE POLICY "clusters_select_admin"
ON public.clusters FOR SELECT TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "clusters_select_cluster_head" ON public.clusters;
CREATE POLICY "clusters_select_cluster_head"
ON public.clusters FOR SELECT TO authenticated
USING (public.is_cluster_head() AND id = public.get_my_cluster_id());

DROP POLICY IF EXISTS "clusters_select_field_agent" ON public.clusters;
CREATE POLICY "clusters_select_field_agent"
ON public.clusters FOR SELECT TO authenticated
USING (public.is_field_agent() AND id = public.get_my_agent_cluster_id());

DROP POLICY IF EXISTS "clusters_all_admin" ON public.clusters;
CREATE POLICY "clusters_all_admin"
ON public.clusters FOR ALL TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- ── cluster_heads ─────────────────────────────────────────────
DROP POLICY IF EXISTS "ch_select_admin" ON public.cluster_heads;
CREATE POLICY "ch_select_admin"
ON public.cluster_heads FOR SELECT TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "ch_select_own" ON public.cluster_heads;
CREATE POLICY "ch_select_own"
ON public.cluster_heads FOR SELECT TO authenticated
USING (public.is_cluster_head() AND user_id = auth.uid());

DROP POLICY IF EXISTS "ch_all_admin" ON public.cluster_heads;
CREATE POLICY "ch_all_admin"
ON public.cluster_heads FOR ALL TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- ── field_agent_cluster_assignments ──────────────────────────
DROP POLICY IF EXISTS "faca_select_admin" ON public.field_agent_cluster_assignments;
CREATE POLICY "faca_select_admin"
ON public.field_agent_cluster_assignments FOR SELECT TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "faca_select_cluster_head" ON public.field_agent_cluster_assignments;
CREATE POLICY "faca_select_cluster_head"
ON public.field_agent_cluster_assignments FOR SELECT TO authenticated
USING (public.is_cluster_head() AND cluster_id = public.get_my_cluster_id());

DROP POLICY IF EXISTS "faca_select_own_agent" ON public.field_agent_cluster_assignments;
CREATE POLICY "faca_select_own_agent"
ON public.field_agent_cluster_assignments FOR SELECT TO authenticated
USING (public.is_field_agent() AND agent_id = auth.uid());

DROP POLICY IF EXISTS "faca_all_admin" ON public.field_agent_cluster_assignments;
CREATE POLICY "faca_all_admin"
ON public.field_agent_cluster_assignments FOR ALL TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- ── households ────────────────────────────────────────────────
DROP POLICY IF EXISTS "field_agent_view_assigned_households" ON public.households;

DROP POLICY IF EXISTS "hh_select_admin" ON public.households;
CREATE POLICY "hh_select_admin"
ON public.households FOR SELECT TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "hh_select_cluster_head" ON public.households;
CREATE POLICY "hh_select_cluster_head"
ON public.households FOR SELECT TO authenticated
USING (public.is_cluster_head() AND public.is_household_in_my_cluster(id));

DROP POLICY IF EXISTS "hh_select_field_agent" ON public.households;
CREATE POLICY "hh_select_field_agent"
ON public.households FOR SELECT TO authenticated
USING (public.is_field_agent() AND public.is_my_assigned_household(id));

DROP POLICY IF EXISTS "hh_select_household_user" ON public.households;
CREATE POLICY "hh_select_household_user"
ON public.households FOR SELECT TO authenticated
USING (public.is_household_user() AND household_user_id = auth.uid());

DROP POLICY IF EXISTS "hh_insert_admin" ON public.households;
CREATE POLICY "hh_insert_admin"
ON public.households FOR INSERT TO authenticated
WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "hh_insert_field_agent" ON public.households;
CREATE POLICY "hh_insert_field_agent"
ON public.households FOR INSERT TO authenticated
WITH CHECK (public.is_field_agent());

DROP POLICY IF EXISTS "hh_update_admin" ON public.households;
CREATE POLICY "hh_update_admin"
ON public.households FOR UPDATE TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "hh_update_field_agent" ON public.households;
CREATE POLICY "hh_update_field_agent"
ON public.households FOR UPDATE TO authenticated
USING (public.is_field_agent() AND public.is_my_assigned_household(id))
WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(id));

DROP POLICY IF EXISTS "hh_delete_admin" ON public.households;
CREATE POLICY "hh_delete_admin"
ON public.households FOR DELETE TO authenticated
USING (public.is_admin());

-- ── household_agent_assignments ───────────────────────────────
DROP POLICY IF EXISTS "haa_select_admin" ON public.household_agent_assignments;
CREATE POLICY "haa_select_admin"
ON public.household_agent_assignments FOR SELECT TO authenticated
USING (public.is_admin());

DROP POLICY IF EXISTS "haa_select_cluster_head" ON public.household_agent_assignments;
CREATE POLICY "haa_select_cluster_head"
ON public.household_agent_assignments FOR SELECT TO authenticated
USING (
    public.is_cluster_head() AND
    EXISTS (
        SELECT 1 FROM public.field_agent_cluster_assignments faca
        WHERE faca.agent_id = household_agent_assignments.agent_id
        AND faca.cluster_id = public.get_my_cluster_id()
        AND faca.is_active = true
    )
);

DROP POLICY IF EXISTS "haa_select_own_agent" ON public.household_agent_assignments;
CREATE POLICY "haa_select_own_agent"
ON public.household_agent_assignments FOR SELECT TO authenticated
USING (public.is_field_agent() AND agent_id = auth.uid());

DROP POLICY IF EXISTS "haa_all_admin" ON public.household_agent_assignments;
CREATE POLICY "haa_all_admin"
ON public.household_agent_assignments FOR ALL TO authenticated
USING (public.is_admin())
WITH CHECK (public.is_admin());

-- ── Macro: RLS for all 20 household data tables ───────────────
-- Pattern: ADMIN=all, CLUSTER_HEAD=cluster households, FIELD_AGENT=assigned, HOUSEHOLD=own

-- household_members
DROP POLICY IF EXISTS "hm_select_admin" ON public.household_members;
CREATE POLICY "hm_select_admin" ON public.household_members FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "hm_select_ch" ON public.household_members;
CREATE POLICY "hm_select_ch" ON public.household_members FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "hm_select_fa" ON public.household_members;
CREATE POLICY "hm_select_fa" ON public.household_members FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "hm_select_hh" ON public.household_members;
CREATE POLICY "hm_select_hh" ON public.household_members FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "hm_insert_admin" ON public.household_members;
CREATE POLICY "hm_insert_admin" ON public.household_members FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "hm_insert_fa" ON public.household_members;
CREATE POLICY "hm_insert_fa" ON public.household_members FOR INSERT TO authenticated WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "hm_update_admin" ON public.household_members;
CREATE POLICY "hm_update_admin" ON public.household_members FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "hm_update_fa" ON public.household_members;
CREATE POLICY "hm_update_fa" ON public.household_members FOR UPDATE TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "hm_delete_admin" ON public.household_members;
CREATE POLICY "hm_delete_admin" ON public.household_members FOR DELETE TO authenticated USING (public.is_admin());

-- land_assets
DROP POLICY IF EXISTS "la_select_admin" ON public.land_assets;
CREATE POLICY "la_select_admin" ON public.land_assets FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "la_select_ch" ON public.land_assets;
CREATE POLICY "la_select_ch" ON public.land_assets FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "la_select_fa" ON public.land_assets;
CREATE POLICY "la_select_fa" ON public.land_assets FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "la_select_hh" ON public.land_assets;
CREATE POLICY "la_select_hh" ON public.land_assets FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "la_write_admin" ON public.land_assets;
CREATE POLICY "la_write_admin" ON public.land_assets FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "la_write_fa" ON public.land_assets;
CREATE POLICY "la_write_fa" ON public.land_assets FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- livestock
DROP POLICY IF EXISTS "lv_select_admin" ON public.livestock;
CREATE POLICY "lv_select_admin" ON public.livestock FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "lv_select_ch" ON public.livestock;
CREATE POLICY "lv_select_ch" ON public.livestock FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "lv_select_fa" ON public.livestock;
CREATE POLICY "lv_select_fa" ON public.livestock FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "lv_select_hh" ON public.livestock;
CREATE POLICY "lv_select_hh" ON public.livestock FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "lv_write_admin" ON public.livestock;
CREATE POLICY "lv_write_admin" ON public.livestock FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "lv_write_fa" ON public.livestock;
CREATE POLICY "lv_write_fa" ON public.livestock FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- crops
DROP POLICY IF EXISTS "cr_select_admin" ON public.crops;
CREATE POLICY "cr_select_admin" ON public.crops FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "cr_select_ch" ON public.crops;
CREATE POLICY "cr_select_ch" ON public.crops FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "cr_select_fa" ON public.crops;
CREATE POLICY "cr_select_fa" ON public.crops FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "cr_select_hh" ON public.crops;
CREATE POLICY "cr_select_hh" ON public.crops FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "cr_write_admin" ON public.crops;
CREATE POLICY "cr_write_admin" ON public.crops FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "cr_write_fa" ON public.crops;
CREATE POLICY "cr_write_fa" ON public.crops FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- pests_diseases
DROP POLICY IF EXISTS "pd_select_admin" ON public.pests_diseases;
CREATE POLICY "pd_select_admin" ON public.pests_diseases FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "pd_select_ch" ON public.pests_diseases;
CREATE POLICY "pd_select_ch" ON public.pests_diseases FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "pd_select_fa" ON public.pests_diseases;
CREATE POLICY "pd_select_fa" ON public.pests_diseases FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "pd_select_hh" ON public.pests_diseases;
CREATE POLICY "pd_select_hh" ON public.pests_diseases FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "pd_write_admin" ON public.pests_diseases;
CREATE POLICY "pd_write_admin" ON public.pests_diseases FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "pd_write_fa" ON public.pests_diseases;
CREATE POLICY "pd_write_fa" ON public.pests_diseases FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- climate_change_organic_itk
DROP POLICY IF EXISTS "cc_select_admin" ON public.climate_change_organic_itk;
CREATE POLICY "cc_select_admin" ON public.climate_change_organic_itk FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "cc_select_ch" ON public.climate_change_organic_itk;
CREATE POLICY "cc_select_ch" ON public.climate_change_organic_itk FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "cc_select_fa" ON public.climate_change_organic_itk;
CREATE POLICY "cc_select_fa" ON public.climate_change_organic_itk FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "cc_select_hh" ON public.climate_change_organic_itk;
CREATE POLICY "cc_select_hh" ON public.climate_change_organic_itk FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "cc_write_admin" ON public.climate_change_organic_itk;
CREATE POLICY "cc_write_admin" ON public.climate_change_organic_itk FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "cc_write_fa" ON public.climate_change_organic_itk;
CREATE POLICY "cc_write_fa" ON public.climate_change_organic_itk FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- income
DROP POLICY IF EXISTS "inc_select_admin" ON public.income;
CREATE POLICY "inc_select_admin" ON public.income FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "inc_select_ch" ON public.income;
CREATE POLICY "inc_select_ch" ON public.income FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "inc_select_fa" ON public.income;
CREATE POLICY "inc_select_fa" ON public.income FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "inc_select_hh" ON public.income;
CREATE POLICY "inc_select_hh" ON public.income FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "inc_write_admin" ON public.income;
CREATE POLICY "inc_write_admin" ON public.income FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "inc_write_fa" ON public.income;
CREATE POLICY "inc_write_fa" ON public.income FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- marketing
DROP POLICY IF EXISTS "mkt_select_admin" ON public.marketing;
CREATE POLICY "mkt_select_admin" ON public.marketing FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "mkt_select_ch" ON public.marketing;
CREATE POLICY "mkt_select_ch" ON public.marketing FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "mkt_select_fa" ON public.marketing;
CREATE POLICY "mkt_select_fa" ON public.marketing FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "mkt_select_hh" ON public.marketing;
CREATE POLICY "mkt_select_hh" ON public.marketing FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "mkt_write_admin" ON public.marketing;
CREATE POLICY "mkt_write_admin" ON public.marketing FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "mkt_write_fa" ON public.marketing;
CREATE POLICY "mkt_write_fa" ON public.marketing FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- money_circulation
DROP POLICY IF EXISTS "mc_select_admin" ON public.money_circulation;
CREATE POLICY "mc_select_admin" ON public.money_circulation FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "mc_select_ch" ON public.money_circulation;
CREATE POLICY "mc_select_ch" ON public.money_circulation FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "mc_select_fa" ON public.money_circulation;
CREATE POLICY "mc_select_fa" ON public.money_circulation FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "mc_select_hh" ON public.money_circulation;
CREATE POLICY "mc_select_hh" ON public.money_circulation FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "mc_write_admin" ON public.money_circulation;
CREATE POLICY "mc_write_admin" ON public.money_circulation FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "mc_write_fa" ON public.money_circulation;
CREATE POLICY "mc_write_fa" ON public.money_circulation FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- schemes
DROP POLICY IF EXISTS "sch_select_admin" ON public.schemes;
CREATE POLICY "sch_select_admin" ON public.schemes FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "sch_select_ch" ON public.schemes;
CREATE POLICY "sch_select_ch" ON public.schemes FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "sch_select_fa" ON public.schemes;
CREATE POLICY "sch_select_fa" ON public.schemes FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "sch_select_hh" ON public.schemes;
CREATE POLICY "sch_select_hh" ON public.schemes FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "sch_write_admin" ON public.schemes;
CREATE POLICY "sch_write_admin" ON public.schemes FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "sch_write_fa" ON public.schemes;
CREATE POLICY "sch_write_fa" ON public.schemes FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- extension_services
DROP POLICY IF EXISTS "es_select_admin" ON public.extension_services;
CREATE POLICY "es_select_admin" ON public.extension_services FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "es_select_ch" ON public.extension_services;
CREATE POLICY "es_select_ch" ON public.extension_services FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "es_select_fa" ON public.extension_services;
CREATE POLICY "es_select_fa" ON public.extension_services FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "es_select_hh" ON public.extension_services;
CREATE POLICY "es_select_hh" ON public.extension_services FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "es_write_admin" ON public.extension_services;
CREATE POLICY "es_write_admin" ON public.extension_services FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "es_write_fa" ON public.extension_services;
CREATE POLICY "es_write_fa" ON public.extension_services FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- training_needs
DROP POLICY IF EXISTS "tn_select_admin" ON public.training_needs;
CREATE POLICY "tn_select_admin" ON public.training_needs FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "tn_select_ch" ON public.training_needs;
CREATE POLICY "tn_select_ch" ON public.training_needs FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "tn_select_fa" ON public.training_needs;
CREATE POLICY "tn_select_fa" ON public.training_needs FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "tn_select_hh" ON public.training_needs;
CREATE POLICY "tn_select_hh" ON public.training_needs FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "tn_write_admin" ON public.training_needs;
CREATE POLICY "tn_write_admin" ON public.training_needs FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "tn_write_fa" ON public.training_needs;
CREATE POLICY "tn_write_fa" ON public.training_needs FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- gender_decision_making
DROP POLICY IF EXISTS "gdm_select_admin" ON public.gender_decision_making;
CREATE POLICY "gdm_select_admin" ON public.gender_decision_making FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "gdm_select_ch" ON public.gender_decision_making;
CREATE POLICY "gdm_select_ch" ON public.gender_decision_making FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "gdm_select_fa" ON public.gender_decision_making;
CREATE POLICY "gdm_select_fa" ON public.gender_decision_making FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "gdm_select_hh" ON public.gender_decision_making;
CREATE POLICY "gdm_select_hh" ON public.gender_decision_making FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "gdm_write_admin" ON public.gender_decision_making;
CREATE POLICY "gdm_write_admin" ON public.gender_decision_making FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "gdm_write_fa" ON public.gender_decision_making;
CREATE POLICY "gdm_write_fa" ON public.gender_decision_making FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- expenditure
DROP POLICY IF EXISTS "exp_select_admin" ON public.expenditure;
CREATE POLICY "exp_select_admin" ON public.expenditure FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "exp_select_ch" ON public.expenditure;
CREATE POLICY "exp_select_ch" ON public.expenditure FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "exp_select_fa" ON public.expenditure;
CREATE POLICY "exp_select_fa" ON public.expenditure FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "exp_select_hh" ON public.expenditure;
CREATE POLICY "exp_select_hh" ON public.expenditure FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "exp_write_admin" ON public.expenditure;
CREATE POLICY "exp_write_admin" ON public.expenditure FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "exp_write_fa" ON public.expenditure;
CREATE POLICY "exp_write_fa" ON public.expenditure FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- gender_work_distribution
DROP POLICY IF EXISTS "gwd_select_admin" ON public.gender_work_distribution;
CREATE POLICY "gwd_select_admin" ON public.gender_work_distribution FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "gwd_select_ch" ON public.gender_work_distribution;
CREATE POLICY "gwd_select_ch" ON public.gender_work_distribution FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "gwd_select_fa" ON public.gender_work_distribution;
CREATE POLICY "gwd_select_fa" ON public.gender_work_distribution FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "gwd_select_hh" ON public.gender_work_distribution;
CREATE POLICY "gwd_select_hh" ON public.gender_work_distribution FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "gwd_write_admin" ON public.gender_work_distribution;
CREATE POLICY "gwd_write_admin" ON public.gender_work_distribution FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "gwd_write_fa" ON public.gender_work_distribution;
CREATE POLICY "gwd_write_fa" ON public.gender_work_distribution FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- food_security_nutrition
DROP POLICY IF EXISTS "fsn_select_admin" ON public.food_security_nutrition;
CREATE POLICY "fsn_select_admin" ON public.food_security_nutrition FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "fsn_select_ch" ON public.food_security_nutrition;
CREATE POLICY "fsn_select_ch" ON public.food_security_nutrition FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "fsn_select_fa" ON public.food_security_nutrition;
CREATE POLICY "fsn_select_fa" ON public.food_security_nutrition FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "fsn_select_hh" ON public.food_security_nutrition;
CREATE POLICY "fsn_select_hh" ON public.food_security_nutrition FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "fsn_write_admin" ON public.food_security_nutrition;
CREATE POLICY "fsn_write_admin" ON public.food_security_nutrition FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "fsn_write_fa" ON public.food_security_nutrition;
CREATE POLICY "fsn_write_fa" ON public.food_security_nutrition FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- skill_based_need_assessment
DROP POLICY IF EXISTS "sbna_select_admin" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_select_admin" ON public.skill_based_need_assessment FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "sbna_select_ch" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_select_ch" ON public.skill_based_need_assessment FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "sbna_select_fa" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_select_fa" ON public.skill_based_need_assessment FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "sbna_select_hh" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_select_hh" ON public.skill_based_need_assessment FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "sbna_write_admin" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_write_admin" ON public.skill_based_need_assessment FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "sbna_write_fa" ON public.skill_based_need_assessment;
CREATE POLICY "sbna_write_fa" ON public.skill_based_need_assessment FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- border_specific_constraints
DROP POLICY IF EXISTS "bsc_select_admin" ON public.border_specific_constraints;
CREATE POLICY "bsc_select_admin" ON public.border_specific_constraints FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "bsc_select_ch" ON public.border_specific_constraints;
CREATE POLICY "bsc_select_ch" ON public.border_specific_constraints FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "bsc_select_fa" ON public.border_specific_constraints;
CREATE POLICY "bsc_select_fa" ON public.border_specific_constraints FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "bsc_select_hh" ON public.border_specific_constraints;
CREATE POLICY "bsc_select_hh" ON public.border_specific_constraints FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "bsc_write_admin" ON public.border_specific_constraints;
CREATE POLICY "bsc_write_admin" ON public.border_specific_constraints FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "bsc_write_fa" ON public.border_specific_constraints;
CREATE POLICY "bsc_write_fa" ON public.border_specific_constraints FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- observations
DROP POLICY IF EXISTS "obs_select_admin" ON public.observations;
CREATE POLICY "obs_select_admin" ON public.observations FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "obs_select_ch" ON public.observations;
CREATE POLICY "obs_select_ch" ON public.observations FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "obs_select_fa" ON public.observations;
CREATE POLICY "obs_select_fa" ON public.observations FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "obs_select_hh" ON public.observations;
CREATE POLICY "obs_select_hh" ON public.observations FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "obs_write_admin" ON public.observations;
CREATE POLICY "obs_write_admin" ON public.observations FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "obs_write_fa" ON public.observations;
CREATE POLICY "obs_write_fa" ON public.observations FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── survey_templates, survey_sections, survey_questions, survey_question_options ──
-- All authenticated users can read; only ADMIN can write

DROP POLICY IF EXISTS "st_select_all" ON public.survey_templates;
CREATE POLICY "st_select_all" ON public.survey_templates FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "st_write_admin" ON public.survey_templates;
CREATE POLICY "st_write_admin" ON public.survey_templates FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "ss_select_all" ON public.survey_sections;
CREATE POLICY "ss_select_all" ON public.survey_sections FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "ss_write_admin" ON public.survey_sections;
CREATE POLICY "ss_write_admin" ON public.survey_sections FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "sq_select_all" ON public.survey_questions;
CREATE POLICY "sq_select_all" ON public.survey_questions FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "sq_write_admin" ON public.survey_questions;
CREATE POLICY "sq_write_admin" ON public.survey_questions FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "sqo_select_all" ON public.survey_question_options;
CREATE POLICY "sqo_select_all" ON public.survey_question_options FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "sqo_write_admin" ON public.survey_question_options;
CREATE POLICY "sqo_write_admin" ON public.survey_question_options FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── surveys (extend existing policies) ───────────────────────
DROP POLICY IF EXISTS "agent_manage_surveys" ON public.surveys;

DROP POLICY IF EXISTS "sv_select_admin" ON public.surveys;
CREATE POLICY "sv_select_admin" ON public.surveys FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "sv_select_ch" ON public.surveys;
CREATE POLICY "sv_select_ch" ON public.surveys FOR SELECT TO authenticated
USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));

DROP POLICY IF EXISTS "sv_select_fa" ON public.surveys;
CREATE POLICY "sv_select_fa" ON public.surveys FOR SELECT TO authenticated
USING (public.is_field_agent() AND agent_id = auth.uid());

DROP POLICY IF EXISTS "sv_select_hh" ON public.surveys;
CREATE POLICY "sv_select_hh" ON public.surveys FOR SELECT TO authenticated
USING (
    public.is_household_user() AND
    EXISTS (
        SELECT 1 FROM public.households h
        WHERE h.id = surveys.household_id AND h.household_user_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "sv_insert_admin" ON public.surveys;
CREATE POLICY "sv_insert_admin" ON public.surveys FOR INSERT TO authenticated WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "sv_insert_fa" ON public.surveys;
CREATE POLICY "sv_insert_fa" ON public.surveys FOR INSERT TO authenticated
WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

DROP POLICY IF EXISTS "sv_update_admin" ON public.surveys;
CREATE POLICY "sv_update_admin" ON public.surveys FOR UPDATE TO authenticated
USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "sv_update_fa" ON public.surveys;
CREATE POLICY "sv_update_fa" ON public.surveys FOR UPDATE TO authenticated
USING (
    public.is_field_agent() AND agent_id = auth.uid()
    AND status IN ('draft'::public.survey_status, 'correction_required'::public.survey_status)
)
WITH CHECK (
    public.is_field_agent() AND agent_id = auth.uid()
);

DROP POLICY IF EXISTS "sv_update_ch" ON public.surveys;
CREATE POLICY "sv_update_ch" ON public.surveys FOR UPDATE TO authenticated
USING (
    public.is_cluster_head() AND public.is_household_in_my_cluster(household_id)
)
WITH CHECK (
    public.is_cluster_head() AND public.is_household_in_my_cluster(household_id)
);

DROP POLICY IF EXISTS "sv_delete_admin" ON public.surveys;
CREATE POLICY "sv_delete_admin" ON public.surveys FOR DELETE TO authenticated USING (public.is_admin());

-- ── survey_answers ────────────────────────────────────────────
DROP POLICY IF EXISTS "sa_select_admin" ON public.survey_answers;
CREATE POLICY "sa_select_admin" ON public.survey_answers FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "sa_select_ch" ON public.survey_answers;
CREATE POLICY "sa_select_ch" ON public.survey_answers FOR SELECT TO authenticated
USING (
    public.is_cluster_head() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_answers.survey_id
        AND public.is_household_in_my_cluster(sv.household_id)
    )
);

DROP POLICY IF EXISTS "sa_select_fa" ON public.survey_answers;
CREATE POLICY "sa_select_fa" ON public.survey_answers FOR SELECT TO authenticated
USING (
    public.is_field_agent() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_answers.survey_id AND sv.agent_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "sa_select_hh" ON public.survey_answers;
CREATE POLICY "sa_select_hh" ON public.survey_answers FOR SELECT TO authenticated
USING (
    public.is_household_user() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        JOIN public.households h ON h.id = sv.household_id
        WHERE sv.id = survey_answers.survey_id AND h.household_user_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "sa_write_admin" ON public.survey_answers;
CREATE POLICY "sa_write_admin" ON public.survey_answers FOR ALL TO authenticated
USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "sa_write_fa" ON public.survey_answers;
CREATE POLICY "sa_write_fa" ON public.survey_answers FOR ALL TO authenticated
USING (
    public.is_field_agent() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_answers.survey_id AND sv.agent_id = auth.uid()
    )
)
WITH CHECK (
    public.is_field_agent() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_answers.survey_id AND sv.agent_id = auth.uid()
    )
);

-- ── survey_status_history ─────────────────────────────────────
DROP POLICY IF EXISTS "ssh_select_admin" ON public.survey_status_history;
CREATE POLICY "ssh_select_admin" ON public.survey_status_history FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "ssh_select_ch" ON public.survey_status_history;
CREATE POLICY "ssh_select_ch" ON public.survey_status_history FOR SELECT TO authenticated
USING (
    public.is_cluster_head() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_status_history.survey_id
        AND public.is_household_in_my_cluster(sv.household_id)
    )
);

DROP POLICY IF EXISTS "ssh_select_fa" ON public.survey_status_history;
CREATE POLICY "ssh_select_fa" ON public.survey_status_history FOR SELECT TO authenticated
USING (
    public.is_field_agent() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        WHERE sv.id = survey_status_history.survey_id AND sv.agent_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "ssh_select_hh" ON public.survey_status_history;
CREATE POLICY "ssh_select_hh" ON public.survey_status_history FOR SELECT TO authenticated
USING (
    public.is_household_user() AND
    EXISTS (
        SELECT 1 FROM public.surveys sv
        JOIN public.households h ON h.id = sv.household_id
        WHERE sv.id = survey_status_history.survey_id AND h.household_user_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "ssh_insert_auth" ON public.survey_status_history;
CREATE POLICY "ssh_insert_auth" ON public.survey_status_history FOR INSERT TO authenticated
WITH CHECK (true);

-- ── bulletins ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "bul_select_admin" ON public.bulletins;
CREATE POLICY "bul_select_admin" ON public.bulletins FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "bul_select_others" ON public.bulletins;
CREATE POLICY "bul_select_others" ON public.bulletins FOR SELECT TO authenticated
USING (
    is_active = true AND (
        target_cluster_id IS NULL
        OR (public.is_cluster_head() AND target_cluster_id = public.get_my_cluster_id())
        OR (public.is_field_agent() AND target_cluster_id = public.get_my_agent_cluster_id())
        OR (
            public.is_household_user() AND
            EXISTS (
                SELECT 1 FROM public.households h
                JOIN public.household_agent_assignments haa ON haa.household_id = h.id AND haa.is_active = true
                JOIN public.field_agent_cluster_assignments faca ON faca.agent_id = haa.agent_id AND faca.is_active = true
                WHERE h.household_user_id = auth.uid()
                AND faca.cluster_id = bulletins.target_cluster_id
            )
        )
    )
);

DROP POLICY IF EXISTS "bul_write_admin" ON public.bulletins;
CREATE POLICY "bul_write_admin" ON public.bulletins FOR ALL TO authenticated
USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── household_questions ───────────────────────────────────────
DROP POLICY IF EXISTS "hq_select_admin" ON public.household_questions;
CREATE POLICY "hq_select_admin" ON public.household_questions FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "hq_select_ch" ON public.household_questions;
CREATE POLICY "hq_select_ch" ON public.household_questions FOR SELECT TO authenticated
USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));

DROP POLICY IF EXISTS "hq_select_fa" ON public.household_questions;
CREATE POLICY "hq_select_fa" ON public.household_questions FOR SELECT TO authenticated
USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));

DROP POLICY IF EXISTS "hq_select_hh" ON public.household_questions;
CREATE POLICY "hq_select_hh" ON public.household_questions FOR SELECT TO authenticated
USING (public.is_household_user() AND public.is_my_household(household_id));

DROP POLICY IF EXISTS "hq_insert_hh" ON public.household_questions;
CREATE POLICY "hq_insert_hh" ON public.household_questions FOR INSERT TO authenticated
WITH CHECK (public.is_household_user() AND public.is_my_household(household_id));

DROP POLICY IF EXISTS "hq_write_admin" ON public.household_questions;
CREATE POLICY "hq_write_admin" ON public.household_questions FOR ALL TO authenticated
USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── question_answers ──────────────────────────────────────────
DROP POLICY IF EXISTS "qa_select_admin" ON public.question_answers;
CREATE POLICY "qa_select_admin" ON public.question_answers FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "qa_select_ch" ON public.question_answers;
CREATE POLICY "qa_select_ch" ON public.question_answers FOR SELECT TO authenticated
USING (
    public.is_cluster_head() AND
    EXISTS (
        SELECT 1 FROM public.household_questions hq
        WHERE hq.id = question_answers.question_id
        AND public.is_household_in_my_cluster(hq.household_id)
    )
);

DROP POLICY IF EXISTS "qa_select_hh" ON public.question_answers;
CREATE POLICY "qa_select_hh" ON public.question_answers FOR SELECT TO authenticated
USING (
    public.is_household_user() AND
    EXISTS (
        SELECT 1 FROM public.household_questions hq
        WHERE hq.id = question_answers.question_id
        AND public.is_my_household(hq.household_id)
    )
);

DROP POLICY IF EXISTS "qa_insert_admin" ON public.question_answers;
CREATE POLICY "qa_insert_admin" ON public.question_answers FOR INSERT TO authenticated
WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "qa_insert_ch" ON public.question_answers;
CREATE POLICY "qa_insert_ch" ON public.question_answers FOR INSERT TO authenticated
WITH CHECK (
    public.is_cluster_head() AND
    EXISTS (
        SELECT 1 FROM public.household_questions hq
        WHERE hq.id = question_answers.question_id
        AND public.is_household_in_my_cluster(hq.household_id)
    )
);

DROP POLICY IF EXISTS "qa_write_admin" ON public.question_answers;
CREATE POLICY "qa_write_admin" ON public.question_answers FOR ALL TO authenticated
USING (public.is_admin()) WITH CHECK (public.is_admin());

-- ── audit_log ─────────────────────────────────────────────────
DROP POLICY IF EXISTS "al_select_admin" ON public.audit_log;
CREATE POLICY "al_select_admin" ON public.audit_log FOR SELECT TO authenticated USING (public.is_admin());

DROP POLICY IF EXISTS "al_insert_system" ON public.audit_log;
CREATE POLICY "al_insert_system" ON public.audit_log FOR INSERT TO authenticated WITH CHECK (true);

-- ============================================================
-- SECTION 15: TRIGGERS
-- ============================================================

-- Auth user creation trigger (already exists, recreate to pick up new function)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- user_profiles immutable fields trigger
DROP TRIGGER IF EXISTS trg_enforce_user_profiles_immutable_fields ON public.user_profiles;
CREATE TRIGGER trg_enforce_user_profiles_immutable_fields
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.enforce_user_profiles_immutable_fields();

-- households hh_id immutability trigger
DROP TRIGGER IF EXISTS trg_enforce_hh_id_immutable ON public.households;
CREATE TRIGGER trg_enforce_hh_id_immutable
    BEFORE UPDATE ON public.households
    FOR EACH ROW
    EXECUTE FUNCTION public.enforce_hh_id_immutable();

-- ============================================================
-- SECTION 16: SEED DEFAULT SURVEY TEMPLATE
-- (Schema structure only — no household data)
-- ============================================================
DO $$
DECLARE
    template_uuid UUID := gen_random_uuid();
BEGIN
    INSERT INTO public.survey_templates (id, name, version, description, is_active)
    VALUES (
        template_uuid,
        'APG Baseline Survey v1',
        1,
        'AdityaPrabhaGram Baseline Household Survey — Version 1',
        true
    )
    ON CONFLICT DO NOTHING;
END $$;
