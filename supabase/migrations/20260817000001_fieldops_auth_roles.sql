-- FieldOps Auth + Role Migration
-- Creates: user_role enum, user_profiles, households, surveys tables
-- Demo users: agent.rashid@fieldops.in (FIELD_AGENT), farmer.priya@fieldops.in (HOUSEHOLD)

-- ============================================================
-- 1. TYPES
-- ============================================================
DROP TYPE IF EXISTS public.user_role CASCADE;
CREATE TYPE public.user_role AS ENUM ('FIELD_AGENT', 'HOUSEHOLD');

DROP TYPE IF EXISTS public.survey_status CASCADE;
CREATE TYPE public.survey_status AS ENUM ('draft', 'submitted', 'under_review', 'correction_required', 'approved');

-- ============================================================
-- 2. CORE TABLES
-- ============================================================

-- user_profiles: linked to auth.users, stores role
CREATE TABLE IF NOT EXISTS public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL DEFAULT '',
    role public.user_role NOT NULL DEFAULT 'HOUSEHOLD'::public.user_role,
    avatar_url TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- households: each household record
CREATE TABLE IF NOT EXISTS public.households (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    head_name TEXT NOT NULL,
    village TEXT NOT NULL DEFAULT '',
    cluster TEXT NOT NULL DEFAULT '',
    district TEXT NOT NULL DEFAULT '',
    members_count INTEGER NOT NULL DEFAULT 1,
    lat DOUBLE PRECISION DEFAULT 0,
    lng DOUBLE PRECISION DEFAULT 0,
    avatar_url TEXT DEFAULT '',
    avatar_semantic_label TEXT DEFAULT '',
    assigned_agent_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    household_user_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- surveys: one survey per household
CREATE TABLE IF NOT EXISTS public.surveys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id TEXT REFERENCES public.households(id) ON DELETE CASCADE,
    agent_id UUID REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    status public.survey_status NOT NULL DEFAULT 'draft'::public.survey_status,
    rejection_reason TEXT,
    last_survey_date TEXT DEFAULT 'Not started',
    responses JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX IF NOT EXISTS idx_households_agent ON public.households(assigned_agent_id);
CREATE INDEX IF NOT EXISTS idx_households_user ON public.households(household_user_id);
CREATE INDEX IF NOT EXISTS idx_surveys_household ON public.surveys(household_id);
CREATE INDEX IF NOT EXISTS idx_surveys_agent ON public.surveys(agent_id);

-- ============================================================
-- 4. FUNCTIONS (must be before RLS policies)
-- ============================================================

-- Auto-create user_profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, role, avatar_url)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'role', 'HOUSEHOLD')::public.user_role,
        COALESCE(NEW.raw_user_meta_data->>'avatar_url', '')
    )
    ON CONFLICT (id) DO NOTHING;
    RETURN NEW;
END;
$$;

-- Helper: get current user role (safe, no recursion)
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS TEXT
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT role::TEXT FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$;

-- Helper: check if current user is FIELD_AGENT
CREATE OR REPLACE FUNCTION public.is_field_agent()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role = 'FIELD_AGENT'::public.user_role
    );
$$;

-- ============================================================
-- 5. ENABLE RLS
-- ============================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.households ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.surveys ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 6. RLS POLICIES
-- ============================================================

-- user_profiles: users manage only their own profile
DROP POLICY IF EXISTS "users_manage_own_profile" ON public.user_profiles;
CREATE POLICY "users_manage_own_profile"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- households: FIELD_AGENT can see households assigned to them
-- HOUSEHOLD user can see only their own household
DROP POLICY IF EXISTS "field_agent_view_assigned_households" ON public.households;
CREATE POLICY "field_agent_view_assigned_households"
ON public.households
FOR SELECT
TO authenticated
USING (
    assigned_agent_id = auth.uid()
    OR household_user_id = auth.uid()
);

-- surveys: FIELD_AGENT can manage surveys for their assigned households
-- HOUSEHOLD user can view their own household survey
DROP POLICY IF EXISTS "agent_manage_surveys" ON public.surveys;
CREATE POLICY "agent_manage_surveys"
ON public.surveys
FOR ALL
TO authenticated
USING (
    agent_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM public.households h
        WHERE h.id = surveys.household_id
        AND h.household_user_id = auth.uid()
    )
)
WITH CHECK (
    agent_id = auth.uid()
);

-- ============================================================
-- 7. TRIGGERS
-- ============================================================
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- 8. DEMO SEED DATA
-- ============================================================
DO $$
DECLARE
    rashid_uuid UUID := gen_random_uuid();
    priya_uuid UUID := gen_random_uuid();
BEGIN
    -- Create Rashid (FIELD_AGENT)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES (
        rashid_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
        'agent.rashid@fieldops.in', crypt('FieldOps@2026', gen_salt('bf', 10)), now(), now(), now(),
        jsonb_build_object('full_name', 'Rashid Khan', 'role', 'FIELD_AGENT', 'avatar_url', 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=80'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null
    ) ON CONFLICT (email) DO NOTHING;

    -- Create Priya (HOUSEHOLD)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES (
        priya_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
        'farmer.priya@fieldops.in', crypt('Harvest@2026', gen_salt('bf', 10)), now(), now(), now(),
        jsonb_build_object('full_name', 'Priya Yadav', 'role', 'HOUSEHOLD', 'avatar_url', 'https://img.rocket.new/generatedImages/rocket_gen_img_14e479cba-1763300676390.png'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null
    ) ON CONFLICT (email) DO NOTHING;

    -- Re-fetch actual UUIDs (in case ON CONFLICT skipped insert)
    SELECT id INTO rashid_uuid FROM auth.users WHERE email = 'agent.rashid@fieldops.in' LIMIT 1;
    SELECT id INTO priya_uuid FROM auth.users WHERE email = 'farmer.priya@fieldops.in' LIMIT 1;

    -- Ensure user_profiles exist (trigger may have already created them)
    INSERT INTO public.user_profiles (id, email, full_name, role, avatar_url)
    VALUES (
        rashid_uuid, 'agent.rashid@fieldops.in', 'Rashid Khan', 'FIELD_AGENT'::public.user_role,
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=80'
    ) ON CONFLICT (id) DO UPDATE SET role = 'FIELD_AGENT'::public.user_role, full_name = 'Rashid Khan';

    INSERT INTO public.user_profiles (id, email, full_name, role, avatar_url)
    VALUES (
        priya_uuid, 'farmer.priya@fieldops.in', 'Priya Yadav', 'HOUSEHOLD'::public.user_role,
        'https://img.rocket.new/generatedImages/rocket_gen_img_14e479cba-1763300676390.png'
    ) ON CONFLICT (id) DO UPDATE SET role = 'HOUSEHOLD'::public.user_role, full_name = 'Priya Yadav';

    -- Seed households (assigned to Rashid, Priya linked to HH-006)
    INSERT INTO public.households (id, name, head_name, village, cluster, district, members_count, lat, lng, avatar_url, avatar_semantic_label, assigned_agent_id, household_user_id)
    VALUES
        ('HH-001', 'Patil Household', 'Ramesh Patil', 'Kolgaon', 'Cluster A', 'Nashik', 5, 20.0059, 73.7898,
         'https://img.rocket.new/generatedImages/rocket_gen_img_178fd24ab-1763293417052.png',
         'Middle-aged Indian man with grey mustache in white kurta standing in field',
         rashid_uuid, NULL),
        ('HH-002', 'Devi Household', 'Sunita Devi', 'Wani', 'Cluster A', 'Nashik', 4, 20.0112, 73.7945,
         'https://images.unsplash.com/photo-1727740443580-17399a8a7939',
         'Indian woman in orange saree with bindi smiling outdoors near crops',
         rashid_uuid, NULL),
        ('HH-003', 'Shaikh Household', 'Mohammed Shaikh', 'Ozar', 'Cluster B', 'Nashik', 6, 20.0867, 73.9421,
         'https://img.rocket.new/generatedImages/rocket_gen_img_1b0d40d12-1763293372377.png',
         'Young Indian man with short beard in blue shirt looking at camera',
         rashid_uuid, NULL),
        ('HH-004', 'Kamble Household', 'Anita Kamble', 'Kolgaon', 'Cluster A', 'Nashik', 3, 20.0063, 73.7901,
         'https://images.unsplash.com/photo-1661766361110-8fca3c1f0244',
         'Indian woman in green dupatta with warm smile in village setting',
         rashid_uuid, NULL),
        ('HH-005', 'Jadhav Household', 'Vijay Jadhav', 'Wani', 'Cluster B', 'Nashik', 7, 20.0118, 73.7952,
         'https://images.unsplash.com/photo-1674701781649-e70fda55b949',
         'Older Indian man with white beard in traditional attire standing outdoors',
         rashid_uuid, NULL),
        ('HH-006', 'Yadav Household', 'Priya Yadav', 'Ozar', 'Cluster B', 'Nashik', 4, 20.0872, 73.9428,
         'https://img.rocket.new/generatedImages/rocket_gen_img_14e479cba-1763300676390.png',
         'Young Indian woman with long dark hair smiling in casual attire',
         rashid_uuid, priya_uuid),
        ('HH-007', 'More Household', 'Santosh More', 'Kolgaon', 'Cluster A', 'Nashik', 5, 20.0065, 73.7905,
         'https://img.rocket.new/generatedImages/rocket_gen_img_1432b9929-1763293721888.png',
         'Middle-aged Indian man with glasses in casual shirt outdoors',
         rashid_uuid, NULL),
        ('HH-008', 'Bhosale Household', 'Kavita Bhosale', 'Wani', 'Cluster A', 'Nashik', 6, 20.0120, 73.7960,
         'https://images.unsplash.com/photo-1725898303854-280c1f67bdac',
         'Indian woman in purple sari with silver jewelry smiling warmly',
         rashid_uuid, NULL)
    ON CONFLICT (id) DO UPDATE SET
        assigned_agent_id = EXCLUDED.assigned_agent_id,
        household_user_id = EXCLUDED.household_user_id;

    -- Seed surveys
    INSERT INTO public.surveys (household_id, agent_id, status, rejection_reason, last_survey_date)
    VALUES
        ('HH-001', rashid_uuid, 'approved'::public.survey_status, NULL, '12 Aug 2026'),
        ('HH-002', rashid_uuid, 'correction_required'::public.survey_status,
         'GPS coordinates do not match registered address. Please re-capture location on-site.', '10 Aug 2026'),
        ('HH-003', rashid_uuid, 'draft'::public.survey_status, NULL, 'Not started'),
        ('HH-004', rashid_uuid, 'submitted'::public.survey_status, NULL, '14 Aug 2026'),
        ('HH-005', rashid_uuid, 'under_review'::public.survey_status, NULL, '13 Aug 2026'),
        ('HH-006', rashid_uuid, 'draft'::public.survey_status, NULL, 'Not started'),
        ('HH-007', rashid_uuid, 'approved'::public.survey_status, NULL, '09 Aug 2026'),
        ('HH-008', rashid_uuid, 'correction_required'::public.survey_status,
         'Section 3 (Crop Details) is incomplete. Land holding size field was left blank.', '11 Aug 2026')
    ON CONFLICT DO NOTHING;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Seed data error: %', SQLERRM;
END $$;
