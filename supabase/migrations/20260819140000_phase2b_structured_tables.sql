-- ============================================================
-- AdityaPrabhaGram — Phase 2B Structured Data Model Migration
-- Timestamp: 20260819140000
-- Depends on: 20260817120000_apg_full_schema.sql
--
-- WHAT THIS MIGRATION DOES:
--   1. Adds survey_id (nullable, ON DELETE RESTRICT) to all
--      survey-captured structured tables
--   2. Adds age_at_survey to household_member_survey_data
--   3. Adds new columns to existing tables (livestock, crops,
--      pests_diseases, income, gender_decision_making,
--      training_needs, observations)
--   4. Creates household_member_survey_data table
--   5. Creates 4 new structured tables:
--      employment_seasonality, community_interventions,
--      seed_production, priority_needs
--   6. Creates household_assets table
--   7. Creates 3 replacement tables for climate_change_organic_itk:
--      climate_observations, organic_farming_practices, itk_practices
--   8. Applies RLS to all new tables following existing pattern
--
-- DESIGN DECISIONS:
--   - survey_id is NULLABLE on all structured tables (backward compat)
--   - survey_id uses ON DELETE RESTRICT (per approved clarification #1)
--   - age_at_survey in household_member_survey_data (clarification #2)
--   - household_members remains master roster (no survey_id)
--   - land_assets remains master data (no survey_id)
-- ============================================================

-- ============================================================
-- SECTION 1: ADD survey_id TO EXISTING SURVEY-CAPTURED TABLES
-- ============================================================

-- livestock
ALTER TABLE public.livestock
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_livestock_survey_id ON public.livestock(survey_id);

-- crops
ALTER TABLE public.crops
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_crops_survey_id ON public.crops(survey_id);

-- pests_diseases
ALTER TABLE public.pests_diseases
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_pests_diseases_survey_id ON public.pests_diseases(survey_id);

-- income
ALTER TABLE public.income
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_income_survey_id ON public.income(survey_id);

-- marketing
ALTER TABLE public.marketing
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_marketing_survey_id ON public.marketing(survey_id);

-- money_circulation
ALTER TABLE public.money_circulation
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_money_circulation_survey_id ON public.money_circulation(survey_id);

-- schemes
ALTER TABLE public.schemes
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_schemes_survey_id ON public.schemes(survey_id);

-- extension_services
ALTER TABLE public.extension_services
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_extension_services_survey_id ON public.extension_services(survey_id);

-- training_needs
ALTER TABLE public.training_needs
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_training_needs_survey_id ON public.training_needs(survey_id);

-- gender_decision_making
ALTER TABLE public.gender_decision_making
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_gender_decision_making_survey_id ON public.gender_decision_making(survey_id);

-- expenditure
ALTER TABLE public.expenditure
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_expenditure_survey_id ON public.expenditure(survey_id);

-- gender_work_distribution
ALTER TABLE public.gender_work_distribution
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_gender_work_distribution_survey_id ON public.gender_work_distribution(survey_id);

-- food_security_nutrition
ALTER TABLE public.food_security_nutrition
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_food_security_nutrition_survey_id ON public.food_security_nutrition(survey_id);

-- skill_based_need_assessment
ALTER TABLE public.skill_based_need_assessment
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_skill_based_need_assessment_survey_id ON public.skill_based_need_assessment(survey_id);

-- border_specific_constraints
ALTER TABLE public.border_specific_constraints
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_border_specific_constraints_survey_id ON public.border_specific_constraints(survey_id);

-- observations
ALTER TABLE public.observations
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_observations_survey_id ON public.observations(survey_id);

-- climate_change_organic_itk (legacy table — keep survey_id for backward compat)
ALTER TABLE public.climate_change_organic_itk
    ADD COLUMN IF NOT EXISTS survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_climate_change_organic_itk_survey_id ON public.climate_change_organic_itk(survey_id);

-- ============================================================
-- SECTION 2: ADD NEW COLUMNS TO EXISTING TABLES
-- ============================================================

-- livestock: enterprise economics (Section C10)
ALTER TABLE public.livestock
    ADD COLUMN IF NOT EXISTS feed_cost DECIMAL,
    ADD COLUMN IF NOT EXISTS vet_cost DECIMAL,
    ADD COLUMN IF NOT EXISTS labour_days DECIMAL,
    ADD COLUMN IF NOT EXISTS enterprise_type TEXT;

-- crops: additional agricultural information (Section D)
ALTER TABLE public.crops
    ADD COLUMN IF NOT EXISTS input_type TEXT,
    ADD COLUMN IF NOT EXISTS water_source TEXT,
    ADD COLUMN IF NOT EXISTS intercrop_name TEXT,
    ADD COLUMN IF NOT EXISTS storage_method TEXT,
    ADD COLUMN IF NOT EXISTS labour_days DECIMAL;

-- pests_diseases: discriminator + type-specific fields (Sections E, F)
ALTER TABLE public.pests_diseases
    ADD COLUMN IF NOT EXISTS incident_type TEXT,
    ADD COLUMN IF NOT EXISTS animal_type TEXT,
    ADD COLUMN IF NOT EXISTS treatment_given TEXT,
    ADD COLUMN IF NOT EXISTS area_affected_acres DECIMAL;

-- income: type and duration (Section K)
ALTER TABLE public.income
    ADD COLUMN IF NOT EXISTS income_type TEXT,
    ADD COLUMN IF NOT EXISTS months_active INTEGER;

-- gender_decision_making: matrix columns (Section R)
ALTER TABLE public.gender_decision_making
    ADD COLUMN IF NOT EXISTS male_role TEXT,
    ADD COLUMN IF NOT EXISTS female_role TEXT,
    ADD COLUMN IF NOT EXISTS joint_decision BOOLEAN;

-- training_needs: priority ranking (Section P)
ALTER TABLE public.training_needs
    ADD COLUMN IF NOT EXISTS ranking INTEGER;

-- observations: enumerator quality fields (Section Z)
ALTER TABLE public.observations
    ADD COLUMN IF NOT EXISTS overall_impression TEXT,
    ADD COLUMN IF NOT EXISTS data_quality_rating INTEGER;

-- ============================================================
-- SECTION 3: household_member_survey_data TABLE
-- Captures survey-specific member attributes while keeping
-- household_members as the master roster.
-- age_at_survey preserves the member's age at the time of
-- the survey so historical surveys remain analytically correct.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.household_member_survey_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES public.household_members(id) ON DELETE CASCADE,
    survey_id UUID NOT NULL REFERENCES public.surveys(id) ON DELETE RESTRICT,
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    -- age_at_survey: preserves the member's age at the time of this survey.
    -- This ensures historical surveys remain analytically correct and do not
    -- show a member's current age against an older survey record.
    age_at_survey INTEGER,
    occupation TEXT,
    days_employed_year INTEGER,
    wage_rate DECIMAL,
    disability TEXT,
    special_skill TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- One snapshot per member per survey
CREATE UNIQUE INDEX IF NOT EXISTS uq_hmsd_member_survey
    ON public.household_member_survey_data (member_id, survey_id);

CREATE INDEX IF NOT EXISTS idx_hmsd_survey_id ON public.household_member_survey_data(survey_id);
CREATE INDEX IF NOT EXISTS idx_hmsd_household_id ON public.household_member_survey_data(household_id);
CREATE INDEX IF NOT EXISTS idx_hmsd_member_id ON public.household_member_survey_data(member_id);

-- ============================================================
-- SECTION 4: household_assets TABLE (Section C)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.household_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    asset_type TEXT,
    asset_name TEXT NOT NULL,
    ownership_status TEXT,
    quantity INTEGER,
    is_hired BOOLEAN DEFAULT false,
    hire_cost DECIMAL,
    hire_cost_unit TEXT,
    hiring_source TEXT,
    asset_condition TEXT,
    year_acquired INTEGER,
    estimated_value DECIMAL,
    remarks TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_household_assets_household_id ON public.household_assets(household_id);
CREATE INDEX IF NOT EXISTS idx_household_assets_survey_id ON public.household_assets(survey_id);

-- ============================================================
-- SECTION 5: employment_seasonality TABLE (Section L)
-- Month-column design: one row per activity, 12 month columns.
-- Household-level (not member-level) per questionnaire design.
-- ============================================================

CREATE TABLE IF NOT EXISTS public.employment_seasonality (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    activity TEXT NOT NULL,
    activity_type TEXT,
    jan_male_days DECIMAL,
    jan_female_days DECIMAL,
    feb_male_days DECIMAL,
    feb_female_days DECIMAL,
    mar_male_days DECIMAL,
    mar_female_days DECIMAL,
    apr_male_days DECIMAL,
    apr_female_days DECIMAL,
    may_male_days DECIMAL,
    may_female_days DECIMAL,
    jun_male_days DECIMAL,
    jun_female_days DECIMAL,
    jul_male_days DECIMAL,
    jul_female_days DECIMAL,
    aug_male_days DECIMAL,
    aug_female_days DECIMAL,
    sep_male_days DECIMAL,
    sep_female_days DECIMAL,
    oct_male_days DECIMAL,
    oct_female_days DECIMAL,
    nov_male_days DECIMAL,
    nov_female_days DECIMAL,
    dec_male_days DECIMAL,
    dec_female_days DECIMAL,
    wage_rate DECIMAL,
    wage_unit TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_employment_seasonality_household_id ON public.employment_seasonality(household_id);
CREATE INDEX IF NOT EXISTS idx_employment_seasonality_survey_id ON public.employment_seasonality(survey_id);

-- ============================================================
-- SECTION 6: community_interventions TABLE (Section M2)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.community_interventions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    program_name TEXT NOT NULL,
    program_type TEXT,
    role TEXT,
    year_joined INTEGER,
    benefit_received TEXT,
    is_active_member BOOLEAN DEFAULT true,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_community_interventions_household_id ON public.community_interventions(household_id);
CREATE INDEX IF NOT EXISTS idx_community_interventions_survey_id ON public.community_interventions(survey_id);

-- ============================================================
-- SECTION 7: seed_production TABLE (Section N)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.seed_production (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    crop_name TEXT NOT NULL,
    variety TEXT,
    area_acres DECIMAL,
    quantity_produced_kg DECIMAL,
    quantity_sold_kg DECIMAL,
    quantity_retained_kg DECIMAL,
    sale_price_per_kg DECIMAL,
    certification_status TEXT,
    season TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_seed_production_household_id ON public.seed_production(household_id);
CREATE INDEX IF NOT EXISTS idx_seed_production_survey_id ON public.seed_production(survey_id);

-- ============================================================
-- SECTION 8: priority_needs TABLE (Sections U, Y)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.priority_needs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    need_category TEXT NOT NULL,
    need_description TEXT NOT NULL,
    priority_rank INTEGER NOT NULL,
    suggested_intervention TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Prevent duplicate ranks per household per survey
CREATE UNIQUE INDEX IF NOT EXISTS uq_priority_needs_rank
    ON public.priority_needs (household_id, survey_id, priority_rank)
    WHERE survey_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_priority_needs_household_id ON public.priority_needs(household_id);
CREATE INDEX IF NOT EXISTS idx_priority_needs_survey_id ON public.priority_needs(survey_id);

-- ============================================================
-- SECTION 9: SPLIT TABLES FOR climate_change_organic_itk
-- Three semantically distinct tables replacing the merged table.
-- The original table is preserved for backward compatibility.
-- ============================================================

-- climate_observations (Section G)
CREATE TABLE IF NOT EXISTS public.climate_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    change_type TEXT,
    description TEXT,
    year_first_noticed INTEGER,
    adaptation_measure TEXT,
    adaptation_outcome TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_climate_observations_household_id ON public.climate_observations(household_id);
CREATE INDEX IF NOT EXISTS idx_climate_observations_survey_id ON public.climate_observations(survey_id);

-- organic_farming_practices (Section H)
CREATE TABLE IF NOT EXISTS public.organic_farming_practices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    practice_name TEXT,
    crop_applicable TEXT,
    input_used TEXT,
    year_started INTEGER,
    certification_status TEXT,
    outcome TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_organic_farming_practices_household_id ON public.organic_farming_practices(household_id);
CREATE INDEX IF NOT EXISTS idx_organic_farming_practices_survey_id ON public.organic_farming_practices(survey_id);

-- itk_practices (Section I)
CREATE TABLE IF NOT EXISTS public.itk_practices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    survey_id UUID REFERENCES public.surveys(id) ON DELETE RESTRICT,
    practice_name TEXT,
    applicable_to TEXT,
    crop_or_animal TEXT,
    description TEXT,
    knowledge_source TEXT,
    year_started INTEGER,
    outcome TEXT,
    created_by UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_itk_practices_household_id ON public.itk_practices(household_id);
CREATE INDEX IF NOT EXISTS idx_itk_practices_survey_id ON public.itk_practices(survey_id);

-- ============================================================
-- SECTION 10: ENABLE RLS ON ALL NEW TABLES
-- ============================================================

ALTER TABLE public.household_member_survey_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employment_seasonality ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_interventions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.seed_production ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.priority_needs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.climate_observations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organic_farming_practices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.itk_practices ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SECTION 11: RLS POLICIES FOR NEW TABLES
-- Pattern: ADMIN=all, CLUSTER_HEAD=cluster households,
--          FIELD_AGENT=assigned households, HOUSEHOLD=own
-- ============================================================

-- ── household_member_survey_data ─────────────────────────────
DROP POLICY IF EXISTS "hmsd_select_admin" ON public.household_member_survey_data;
CREATE POLICY "hmsd_select_admin" ON public.household_member_survey_data FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "hmsd_select_ch" ON public.household_member_survey_data;
CREATE POLICY "hmsd_select_ch" ON public.household_member_survey_data FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "hmsd_select_fa" ON public.household_member_survey_data;
CREATE POLICY "hmsd_select_fa" ON public.household_member_survey_data FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "hmsd_select_hh" ON public.household_member_survey_data;
CREATE POLICY "hmsd_select_hh" ON public.household_member_survey_data FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "hmsd_write_admin" ON public.household_member_survey_data;
CREATE POLICY "hmsd_write_admin" ON public.household_member_survey_data FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "hmsd_write_fa" ON public.household_member_survey_data;
CREATE POLICY "hmsd_write_fa" ON public.household_member_survey_data FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── household_assets ─────────────────────────────────────────
DROP POLICY IF EXISTS "ha_select_admin" ON public.household_assets;
CREATE POLICY "ha_select_admin" ON public.household_assets FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "ha_select_ch" ON public.household_assets;
CREATE POLICY "ha_select_ch" ON public.household_assets FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "ha_select_fa" ON public.household_assets;
CREATE POLICY "ha_select_fa" ON public.household_assets FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "ha_select_hh" ON public.household_assets;
CREATE POLICY "ha_select_hh" ON public.household_assets FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "ha_write_admin" ON public.household_assets;
CREATE POLICY "ha_write_admin" ON public.household_assets FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "ha_write_fa" ON public.household_assets;
CREATE POLICY "ha_write_fa" ON public.household_assets FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── employment_seasonality ────────────────────────────────────
DROP POLICY IF EXISTS "es_select_admin" ON public.employment_seasonality;
CREATE POLICY "es_select_admin" ON public.employment_seasonality FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "es_select_ch" ON public.employment_seasonality;
CREATE POLICY "es_select_ch" ON public.employment_seasonality FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "es_select_fa" ON public.employment_seasonality;
CREATE POLICY "es_select_fa" ON public.employment_seasonality FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "es_select_hh" ON public.employment_seasonality;
CREATE POLICY "es_select_hh" ON public.employment_seasonality FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "es_write_admin" ON public.employment_seasonality;
CREATE POLICY "es_write_admin" ON public.employment_seasonality FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "es_write_fa" ON public.employment_seasonality;
CREATE POLICY "es_write_fa" ON public.employment_seasonality FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── community_interventions ───────────────────────────────────
DROP POLICY IF EXISTS "ci_select_admin" ON public.community_interventions;
CREATE POLICY "ci_select_admin" ON public.community_interventions FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "ci_select_ch" ON public.community_interventions;
CREATE POLICY "ci_select_ch" ON public.community_interventions FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "ci_select_fa" ON public.community_interventions;
CREATE POLICY "ci_select_fa" ON public.community_interventions FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "ci_select_hh" ON public.community_interventions;
CREATE POLICY "ci_select_hh" ON public.community_interventions FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "ci_write_admin" ON public.community_interventions;
CREATE POLICY "ci_write_admin" ON public.community_interventions FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "ci_write_fa" ON public.community_interventions;
CREATE POLICY "ci_write_fa" ON public.community_interventions FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── seed_production ───────────────────────────────────────────
DROP POLICY IF EXISTS "sp_select_admin" ON public.seed_production;
CREATE POLICY "sp_select_admin" ON public.seed_production FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "sp_select_ch" ON public.seed_production;
CREATE POLICY "sp_select_ch" ON public.seed_production FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "sp_select_fa" ON public.seed_production;
CREATE POLICY "sp_select_fa" ON public.seed_production FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "sp_select_hh" ON public.seed_production;
CREATE POLICY "sp_select_hh" ON public.seed_production FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "sp_write_admin" ON public.seed_production;
CREATE POLICY "sp_write_admin" ON public.seed_production FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "sp_write_fa" ON public.seed_production;
CREATE POLICY "sp_write_fa" ON public.seed_production FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── priority_needs ────────────────────────────────────────────
DROP POLICY IF EXISTS "pn_select_admin" ON public.priority_needs;
CREATE POLICY "pn_select_admin" ON public.priority_needs FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "pn_select_ch" ON public.priority_needs;
CREATE POLICY "pn_select_ch" ON public.priority_needs FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "pn_select_fa" ON public.priority_needs;
CREATE POLICY "pn_select_fa" ON public.priority_needs FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "pn_select_hh" ON public.priority_needs;
CREATE POLICY "pn_select_hh" ON public.priority_needs FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "pn_write_admin" ON public.priority_needs;
CREATE POLICY "pn_write_admin" ON public.priority_needs FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "pn_write_fa" ON public.priority_needs;
CREATE POLICY "pn_write_fa" ON public.priority_needs FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── climate_observations ──────────────────────────────────────
DROP POLICY IF EXISTS "co_select_admin" ON public.climate_observations;
CREATE POLICY "co_select_admin" ON public.climate_observations FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "co_select_ch" ON public.climate_observations;
CREATE POLICY "co_select_ch" ON public.climate_observations FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "co_select_fa" ON public.climate_observations;
CREATE POLICY "co_select_fa" ON public.climate_observations FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "co_select_hh" ON public.climate_observations;
CREATE POLICY "co_select_hh" ON public.climate_observations FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "co_write_admin" ON public.climate_observations;
CREATE POLICY "co_write_admin" ON public.climate_observations FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "co_write_fa" ON public.climate_observations;
CREATE POLICY "co_write_fa" ON public.climate_observations FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── organic_farming_practices ─────────────────────────────────
DROP POLICY IF EXISTS "ofp_select_admin" ON public.organic_farming_practices;
CREATE POLICY "ofp_select_admin" ON public.organic_farming_practices FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "ofp_select_ch" ON public.organic_farming_practices;
CREATE POLICY "ofp_select_ch" ON public.organic_farming_practices FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "ofp_select_fa" ON public.organic_farming_practices;
CREATE POLICY "ofp_select_fa" ON public.organic_farming_practices FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "ofp_select_hh" ON public.organic_farming_practices;
CREATE POLICY "ofp_select_hh" ON public.organic_farming_practices FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "ofp_write_admin" ON public.organic_farming_practices;
CREATE POLICY "ofp_write_admin" ON public.organic_farming_practices FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "ofp_write_fa" ON public.organic_farming_practices;
CREATE POLICY "ofp_write_fa" ON public.organic_farming_practices FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- ── itk_practices ─────────────────────────────────────────────
DROP POLICY IF EXISTS "itk_select_admin" ON public.itk_practices;
CREATE POLICY "itk_select_admin" ON public.itk_practices FOR SELECT TO authenticated USING (public.is_admin());
DROP POLICY IF EXISTS "itk_select_ch" ON public.itk_practices;
CREATE POLICY "itk_select_ch" ON public.itk_practices FOR SELECT TO authenticated USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));
DROP POLICY IF EXISTS "itk_select_fa" ON public.itk_practices;
CREATE POLICY "itk_select_fa" ON public.itk_practices FOR SELECT TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));
DROP POLICY IF EXISTS "itk_select_hh" ON public.itk_practices;
CREATE POLICY "itk_select_hh" ON public.itk_practices FOR SELECT TO authenticated USING (public.is_household_user() AND public.is_my_household(household_id));
DROP POLICY IF EXISTS "itk_write_admin" ON public.itk_practices;
CREATE POLICY "itk_write_admin" ON public.itk_practices FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "itk_write_fa" ON public.itk_practices;
CREATE POLICY "itk_write_fa" ON public.itk_practices FOR ALL TO authenticated USING (public.is_field_agent() AND public.is_my_assigned_household(household_id)) WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));
