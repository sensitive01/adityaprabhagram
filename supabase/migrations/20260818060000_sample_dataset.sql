-- ============================================================
-- AdityaPrabhaGram — Sample Dataset Migration
-- Timestamp: 20260818060000
-- Depends on: 20260817140000_security_hardening.sql
--
-- WHAT THIS MIGRATION DOES:
--   Creates a realistic sample dataset for application testing:
--   - 1 Admin user (auth + user_profiles)
--   - 2 Clusters
--   - 2 Cluster Head users (auth + user_profiles) + cluster_heads assignments
--   - 4 Field Agent users (auth + user_profiles) + field_agent_cluster_assignments
--   - 12 Households (3 per Field Agent) + household_agent_assignments
--   - 28 Household Members (2-4 per household)
--   - Survey template sections + questions (using existing template)
--   - 5 Surveys with varied statuses (draft, submitted, correction_required, approved)
--   - Survey answers for submitted/approved surveys
--   - 2 Bulletins
--   - 3 Household Questions with different answer states
-- ============================================================

DO $$
DECLARE
    -- Admin
    v_admin_id          UUID := gen_random_uuid();

    -- Cluster Head 1 (Cluster Alpha)
    v_ch1_id            UUID := gen_random_uuid();
    -- Cluster Head 2 (Cluster Beta)
    v_ch2_id            UUID := gen_random_uuid();

    -- Field Agents under Cluster Alpha
    v_fa1_id            UUID := gen_random_uuid();
    v_fa2_id            UUID := gen_random_uuid();

    -- Field Agents under Cluster Beta
    v_fa3_id            UUID := gen_random_uuid();
    v_fa4_id            UUID := gen_random_uuid();

    -- Clusters
    v_cluster_alpha_id  UUID := gen_random_uuid();
    v_cluster_beta_id   UUID := gen_random_uuid();

    -- Cluster head assignment rows
    v_ch1_assign_id     UUID := gen_random_uuid();
    v_ch2_assign_id     UUID := gen_random_uuid();

    -- Households (FA1: 3, FA2: 3, FA3: 3, FA4: 3)
    v_hh1_id  TEXT := 'HH-ALPHA-001';
    v_hh2_id  TEXT := 'HH-ALPHA-002';
    v_hh3_id  TEXT := 'HH-ALPHA-003';
    v_hh4_id  TEXT := 'HH-ALPHA-004';
    v_hh5_id  TEXT := 'HH-ALPHA-005';
    v_hh6_id  TEXT := 'HH-ALPHA-006';
    v_hh7_id  TEXT := 'HH-BETA-001';
    v_hh8_id  TEXT := 'HH-BETA-002';
    v_hh9_id  TEXT := 'HH-BETA-003';
    v_hh10_id TEXT := 'HH-BETA-004';
    v_hh11_id TEXT := 'HH-BETA-005';
    v_hh12_id TEXT := 'HH-BETA-006';

    -- Survey template (existing)
    v_template_id       UUID;

    -- Survey sections
    v_sec_basic_id      UUID := gen_random_uuid();
    v_sec_land_id       UUID := gen_random_uuid();
    v_sec_crop_id       UUID := gen_random_uuid();

    -- Survey questions
    v_q_family_size_id  UUID := gen_random_uuid();
    v_q_tribe_id        UUID := gen_random_uuid();
    v_q_land_area_id    UUID := gen_random_uuid();
    v_q_irrigation_id   UUID := gen_random_uuid();
    v_q_crop_name_id    UUID := gen_random_uuid();
    v_q_crop_season_id  UUID := gen_random_uuid();

    -- Surveys
    v_survey1_id        UUID := gen_random_uuid();
    v_survey2_id        UUID := gen_random_uuid();
    v_survey3_id        UUID := gen_random_uuid();
    v_survey4_id        UUID := gen_random_uuid();
    v_survey5_id        UUID := gen_random_uuid();

    -- Bulletins
    v_bulletin1_id      UUID := gen_random_uuid();
    v_bulletin2_id      UUID := gen_random_uuid();

    -- Household questions
    v_hq1_id            UUID := gen_random_uuid();
    v_hq2_id            UUID := gen_random_uuid();
    v_hq3_id            UUID := gen_random_uuid();

BEGIN

    -- ============================================================
    -- STEP 1: CREATE AUTH USERS
    -- ============================================================

    -- Admin
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_admin_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'admin@apg.test',
        crypt('Admin@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'APG Administrator', 'role', 'ADMIN'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Cluster Head 1
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_ch1_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'ch.alpha@apg.test',
        crypt('ClusterHead@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Ranjit Singh', 'role', 'CLUSTER_HEAD'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Cluster Head 2
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_ch2_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'ch.beta@apg.test',
        crypt('ClusterHead@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Sunita Devi', 'role', 'CLUSTER_HEAD'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Field Agent 1 (Alpha)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_fa1_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'fa1.alpha@apg.test',
        crypt('FieldAgent@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Mohan Sharma', 'role', 'FIELD_AGENT'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Field Agent 2 (Alpha)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_fa2_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'fa2.alpha@apg.test',
        crypt('FieldAgent@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Priya Kumari', 'role', 'FIELD_AGENT'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Field Agent 3 (Beta)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_fa3_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'fa1.beta@apg.test',
        crypt('FieldAgent@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Arun Thapa', 'role', 'FIELD_AGENT'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- Field Agent 4 (Beta)
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous,
        confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at,
        email_change_token_new, email_change, email_change_sent_at,
        email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at,
        phone, phone_change, phone_change_token, phone_change_sent_at
    ) VALUES (
        v_fa4_id, '00000000-0000-0000-0000-000000000000',
        'authenticated', 'authenticated',
        'fa2.beta@apg.test',
        crypt('FieldAgent@1234', gen_salt('bf', 10)),
        now(), now(), now(),
        jsonb_build_object('full_name', 'Lalita Devi', 'role', 'FIELD_AGENT'),
        jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
        false, false, '', null, '', null, '', '', null, '', 0, '', null,
        null, '', '', null
    ) ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 2: UPSERT user_profiles (trigger may have already created them)
    -- ============================================================

    INSERT INTO public.user_profiles (id, email, full_name, role, phone, is_active, username)
    VALUES
        (v_admin_id, 'admin@apg.test', 'APG Administrator', 'ADMIN'::public.user_role, '+91-9800000001', true, 'admin.apg'),
        (v_ch1_id,   'ch.alpha@apg.test', 'Ranjit Singh',   'CLUSTER_HEAD'::public.user_role, '+91-9800000002', true, 'ch.ranjit'),
        (v_ch2_id,   'ch.beta@apg.test',  'Sunita Devi',    'CLUSTER_HEAD'::public.user_role, '+91-9800000003', true, 'ch.sunita'),
        (v_fa1_id,   'fa1.alpha@apg.test','Mohan Sharma',   'FIELD_AGENT'::public.user_role,  '+91-9800000004', true, 'fa.mohan'),
        (v_fa2_id,   'fa2.alpha@apg.test','Priya Kumari',   'FIELD_AGENT'::public.user_role,  '+91-9800000005', true, 'fa.priya'),
        (v_fa3_id,   'fa1.beta@apg.test', 'Arun Thapa',     'FIELD_AGENT'::public.user_role,  '+91-9800000006', true, 'fa.arun'),
        (v_fa4_id,   'fa2.beta@apg.test', 'Lalita Devi',    'FIELD_AGENT'::public.user_role,  '+91-9800000007', true, 'fa.lalita')
    ON CONFLICT (id) DO UPDATE
        SET full_name  = EXCLUDED.full_name,
            role       = EXCLUDED.role,
            phone      = EXCLUDED.phone,
            is_active  = EXCLUDED.is_active;

    -- ============================================================
    -- STEP 3: CLUSTERS
    -- ============================================================

    INSERT INTO public.clusters (id, cluster_code, cluster_name, district, state, description, is_active, created_by)
    VALUES
        (v_cluster_alpha_id, 'CLU-ALPHA', 'Cluster Alpha', 'Churachandpur', 'Manipur',
         'Northern cluster covering Churachandpur district villages', true, v_admin_id),
        (v_cluster_beta_id,  'CLU-BETA',  'Cluster Beta',  'Bishnupur',     'Manipur',
         'Southern cluster covering Bishnupur district villages', true, v_admin_id)
    ON CONFLICT (cluster_code) DO NOTHING;

    -- ============================================================
    -- STEP 4: CLUSTER HEADS
    -- ============================================================

    INSERT INTO public.cluster_heads (id, cluster_id, user_id, assigned_at, assigned_by, is_active, notes)
    VALUES
        (v_ch1_assign_id, v_cluster_alpha_id, v_ch1_id, now(), v_admin_id, true,
         'Assigned as Cluster Head for Alpha cluster'),
        (v_ch2_assign_id, v_cluster_beta_id,  v_ch2_id, now(), v_admin_id, true,
         'Assigned as Cluster Head for Beta cluster')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 5: FIELD AGENT CLUSTER ASSIGNMENTS
    -- ============================================================

    INSERT INTO public.field_agent_cluster_assignments (id, agent_id, cluster_id, assigned_at, assigned_by, is_active, notes)
    VALUES
        (gen_random_uuid(), v_fa1_id, v_cluster_alpha_id, now(), v_admin_id, true, 'FA1 assigned to Alpha cluster'),
        (gen_random_uuid(), v_fa2_id, v_cluster_alpha_id, now(), v_admin_id, true, 'FA2 assigned to Alpha cluster'),
        (gen_random_uuid(), v_fa3_id, v_cluster_beta_id,  now(), v_admin_id, true, 'FA3 assigned to Beta cluster'),
        (gen_random_uuid(), v_fa4_id, v_cluster_beta_id,  now(), v_admin_id, true, 'FA4 assigned to Beta cluster')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 6: HOUSEHOLDS
    -- ============================================================

    -- FA1 households (Alpha cluster)
    INSERT INTO public.households (
        id, hh_id, name, head_name, village, cluster, district, state, block,
        members_count, family_size, tribe_community, household_type, house_type,
        contact_number, respondent_name, household_head,
        lat, lng, latitude, longitude,
        assigned_agent_id, created_by, survey_date
    ) VALUES
        (v_hh1_id, v_hh1_id, 'Sharma Household', 'Ramesh Sharma',
         'Tuibong', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Tuibong Block',
         3, 3, 'Meitei', 'Nuclear', 'Pucca',
         '+91-9700000001', 'Ramesh Sharma', 'Ramesh Sharma',
         24.3333, 93.6667, 24.3333, 93.6667,
         v_fa1_id, v_fa1_id, '2026-08-01'),

        (v_hh2_id, v_hh2_id, 'Devi Household', 'Kamala Devi',
         'Tuibong', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Tuibong Block',
         4, 4, 'Kuki', 'Joint', 'Semi-Pucca',
         '+91-9700000002', 'Kamala Devi', 'Kamala Devi',
         24.3350, 93.6680, 24.3350, 93.6680,
         v_fa1_id, v_fa1_id, '2026-08-02'),

        (v_hh3_id, v_hh3_id, 'Singh Household', 'Bikram Singh',
         'Lamka', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Lamka Block',
         2, 2, 'Naga', 'Nuclear', 'Kutcha',
         '+91-9700000003', 'Bikram Singh', 'Bikram Singh',
         24.3400, 93.6700, 24.3400, 93.6700,
         v_fa1_id, v_fa1_id, '2026-08-03')
    ON CONFLICT (id) DO NOTHING;

    -- FA2 households (Alpha cluster)
    INSERT INTO public.households (
        id, hh_id, name, head_name, village, cluster, district, state, block,
        members_count, family_size, tribe_community, household_type, house_type,
        contact_number, respondent_name, household_head,
        lat, lng, latitude, longitude,
        assigned_agent_id, created_by, survey_date
    ) VALUES
        (v_hh4_id, v_hh4_id, 'Kumari Household', 'Sita Kumari',
         'Henglep', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Henglep Block',
         4, 4, 'Meitei', 'Joint', 'Pucca',
         '+91-9700000004', 'Sita Kumari', 'Sita Kumari',
         24.3500, 93.6800, 24.3500, 93.6800,
         v_fa2_id, v_fa2_id, '2026-08-04'),

        (v_hh5_id, v_hh5_id, 'Thapa Household', 'Gopal Thapa',
         'Henglep', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Henglep Block',
         3, 3, 'Kuki', 'Nuclear', 'Semi-Pucca',
         '+91-9700000005', 'Gopal Thapa', 'Gopal Thapa',
         24.3520, 93.6820, 24.3520, 93.6820,
         v_fa2_id, v_fa2_id, '2026-08-05'),

        (v_hh6_id, v_hh6_id, 'Rai Household', 'Meena Rai',
         'Singngat', 'Cluster Alpha', 'Churachandpur', 'Manipur', 'Singngat Block',
         2, 2, 'Naga', 'Nuclear', 'Kutcha',
         '+91-9700000006', 'Meena Rai', 'Meena Rai',
         24.3600, 93.6900, 24.3600, 93.6900,
         v_fa2_id, v_fa2_id, '2026-08-06')
    ON CONFLICT (id) DO NOTHING;

    -- FA3 households (Beta cluster)
    INSERT INTO public.households (
        id, hh_id, name, head_name, village, cluster, district, state, block,
        members_count, family_size, tribe_community, household_type, house_type,
        contact_number, respondent_name, household_head,
        lat, lng, latitude, longitude,
        assigned_agent_id, created_by, survey_date
    ) VALUES
        (v_hh7_id, v_hh7_id, 'Meitei Household', 'Ibohal Meitei',
         'Moirang', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Moirang Block',
         4, 4, 'Meitei', 'Joint', 'Pucca',
         '+91-9700000007', 'Ibohal Meitei', 'Ibohal Meitei',
         24.5000, 93.7500, 24.5000, 93.7500,
         v_fa3_id, v_fa3_id, '2026-08-07'),

        (v_hh8_id, v_hh8_id, 'Laishram Household', 'Bimola Laishram',
         'Moirang', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Moirang Block',
         3, 3, 'Meitei', 'Nuclear', 'Semi-Pucca',
         '+91-9700000008', 'Bimola Laishram', 'Bimola Laishram',
         24.5020, 93.7520, 24.5020, 93.7520,
         v_fa3_id, v_fa3_id, '2026-08-08'),

        (v_hh9_id, v_hh9_id, 'Yumnam Household', 'Thoibi Yumnam',
         'Nambol', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Nambol Block',
         2, 2, 'Meitei', 'Nuclear', 'Kutcha',
         '+91-9700000009', 'Thoibi Yumnam', 'Thoibi Yumnam',
         24.5100, 93.7600, 24.5100, 93.7600,
         v_fa3_id, v_fa3_id, '2026-08-09')
    ON CONFLICT (id) DO NOTHING;

    -- FA4 households (Beta cluster)
    INSERT INTO public.households (
        id, hh_id, name, head_name, village, cluster, district, state, block,
        members_count, family_size, tribe_community, household_type, house_type,
        contact_number, respondent_name, household_head,
        lat, lng, latitude, longitude,
        assigned_agent_id, created_by, survey_date
    ) VALUES
        (v_hh10_id, v_hh10_id, 'Konthoujam Household', 'Somorjit Konthoujam',
         'Bishnupur', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Bishnupur Block',
         4, 4, 'Meitei', 'Joint', 'Pucca',
         '+91-9700000010', 'Somorjit Konthoujam', 'Somorjit Konthoujam',
         24.6200, 93.7700, 24.6200, 93.7700,
         v_fa4_id, v_fa4_id, '2026-08-10'),

        (v_hh11_id, v_hh11_id, 'Wangkhem Household', 'Rani Wangkhem',
         'Bishnupur', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Bishnupur Block',
         3, 3, 'Meitei', 'Nuclear', 'Semi-Pucca',
         '+91-9700000011', 'Rani Wangkhem', 'Rani Wangkhem',
         24.6220, 93.7720, 24.6220, 93.7720,
         v_fa4_id, v_fa4_id, '2026-08-11'),

        (v_hh12_id, v_hh12_id, 'Ngangbam Household', 'Tomba Ngangbam',
         'Thoubal', 'Cluster Beta', 'Bishnupur', 'Manipur', 'Thoubal Block',
         2, 2, 'Meitei', 'Nuclear', 'Kutcha',
         '+91-9700000012', 'Tomba Ngangbam', 'Tomba Ngangbam',
         24.6300, 93.7800, 24.6300, 93.7800,
         v_fa4_id, v_fa4_id, '2026-08-12')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 7: HOUSEHOLD AGENT ASSIGNMENTS
    -- ============================================================

    INSERT INTO public.household_agent_assignments (id, household_id, agent_id, assigned_at, assigned_by, is_active)
    VALUES
        (gen_random_uuid(), v_hh1_id,  v_fa1_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh2_id,  v_fa1_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh3_id,  v_fa1_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh4_id,  v_fa2_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh5_id,  v_fa2_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh6_id,  v_fa2_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh7_id,  v_fa3_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh8_id,  v_fa3_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh9_id,  v_fa3_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh10_id, v_fa4_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh11_id, v_fa4_id, now(), v_admin_id, true),
        (gen_random_uuid(), v_hh12_id, v_fa4_id, now(), v_admin_id, true)
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 8: HOUSEHOLD MEMBERS (2-4 per household)
    -- ============================================================

    -- HH1 (3 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh1_id, 'Ramesh Sharma',   45, 'Male',   'Head',   'Secondary',    'Farmer',          'Married'),
        (gen_random_uuid(), v_hh1_id, 'Sunita Sharma',   40, 'Female', 'Spouse', 'Primary',      'Homemaker',       'Married'),
        (gen_random_uuid(), v_hh1_id, 'Ravi Sharma',     18, 'Male',   'Son',    'Higher Secondary', 'Student',     'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH2 (4 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh2_id, 'Kamala Devi',     50, 'Female', 'Head',        'Primary',      'Farmer',    'Widowed'),
        (gen_random_uuid(), v_hh2_id, 'Suresh Kumar',    25, 'Male',   'Son',         'Secondary',    'Farmer',    'Married'),
        (gen_random_uuid(), v_hh2_id, 'Anita Devi',      22, 'Female', 'Daughter-in-law', 'Secondary','Homemaker', 'Married'),
        (gen_random_uuid(), v_hh2_id, 'Ritu Devi',       16, 'Female', 'Daughter',    'Secondary',    'Student',   'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH3 (2 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh3_id, 'Bikram Singh',    38, 'Male',   'Head',   'Graduate',     'Farmer',          'Married'),
        (gen_random_uuid(), v_hh3_id, 'Puja Singh',      34, 'Female', 'Spouse', 'Secondary',    'Homemaker',       'Married')
    ON CONFLICT (id) DO NOTHING;

    -- HH4 (4 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh4_id, 'Sita Kumari',     42, 'Female', 'Head',   'Primary',      'Farmer',          'Married'),
        (gen_random_uuid(), v_hh4_id, 'Dinesh Kumar',    45, 'Male',   'Spouse', 'Secondary',    'Daily Labourer',  'Married'),
        (gen_random_uuid(), v_hh4_id, 'Pooja Kumari',    20, 'Female', 'Daughter','Higher Secondary','Student',     'Unmarried'),
        (gen_random_uuid(), v_hh4_id, 'Rohit Kumar',     14, 'Male',   'Son',    'Secondary',    'Student',         'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH5 (3 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh5_id, 'Gopal Thapa',     55, 'Male',   'Head',   'Primary',      'Farmer',          'Married'),
        (gen_random_uuid(), v_hh5_id, 'Gita Thapa',      50, 'Female', 'Spouse', 'Illiterate',   'Homemaker',       'Married'),
        (gen_random_uuid(), v_hh5_id, 'Hari Thapa',      28, 'Male',   'Son',    'Graduate',     'Govt Employee',   'Married')
    ON CONFLICT (id) DO NOTHING;

    -- HH6 (2 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh6_id, 'Meena Rai',       35, 'Female', 'Head',   'Secondary',    'Farmer',          'Married'),
        (gen_random_uuid(), v_hh6_id, 'Deepak Rai',      38, 'Male',   'Spouse', 'Secondary',    'Farmer',          'Married')
    ON CONFLICT (id) DO NOTHING;

    -- HH7 (4 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh7_id, 'Ibohal Meitei',   48, 'Male',   'Head',   'Graduate',     'Farmer',          'Married'),
        (gen_random_uuid(), v_hh7_id, 'Thoibi Meitei',   44, 'Female', 'Spouse', 'Secondary',    'Homemaker',       'Married'),
        (gen_random_uuid(), v_hh7_id, 'Roshan Meitei',   22, 'Male',   'Son',    'Graduate',     'Student',         'Unmarried'),
        (gen_random_uuid(), v_hh7_id, 'Sonia Meitei',    18, 'Female', 'Daughter','Higher Secondary','Student',     'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH8 (3 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh8_id, 'Bimola Laishram', 40, 'Female', 'Head',   'Secondary',    'Farmer',          'Married'),
        (gen_random_uuid(), v_hh8_id, 'Tomcha Laishram', 43, 'Male',   'Spouse', 'Primary',      'Farmer',          'Married'),
        (gen_random_uuid(), v_hh8_id, 'Priya Laishram',  15, 'Female', 'Daughter','Secondary',   'Student',         'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH9 (2 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh9_id, 'Thoibi Yumnam',   32, 'Female', 'Head',   'Graduate',     'Farmer',          'Married'),
        (gen_random_uuid(), v_hh9_id, 'Romen Yumnam',    35, 'Male',   'Spouse', 'Graduate',     'Farmer',          'Married')
    ON CONFLICT (id) DO NOTHING;

    -- HH10 (4 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh10_id, 'Somorjit Konthoujam', 52, 'Male',   'Head',   'Secondary', 'Farmer',        'Married'),
        (gen_random_uuid(), v_hh10_id, 'Ibemhal Konthoujam',  48, 'Female', 'Spouse', 'Primary',   'Homemaker',     'Married'),
        (gen_random_uuid(), v_hh10_id, 'Nongthombam Konthoujam', 24, 'Male','Son',    'Graduate',  'Daily Labourer','Married'),
        (gen_random_uuid(), v_hh10_id, 'Sanatombi Konthoujam', 19, 'Female','Daughter','Higher Secondary','Student', 'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH11 (3 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh11_id, 'Rani Wangkhem',   38, 'Female', 'Head',   'Secondary',    'Farmer',          'Married'),
        (gen_random_uuid(), v_hh11_id, 'Bobo Wangkhem',   42, 'Male',   'Spouse', 'Primary',      'Farmer',          'Married'),
        (gen_random_uuid(), v_hh11_id, 'Lata Wangkhem',   16, 'Female', 'Daughter','Secondary',   'Student',         'Unmarried')
    ON CONFLICT (id) DO NOTHING;

    -- HH12 (2 members)
    INSERT INTO public.household_members (id, household_id, member_name, age, gender, relation_to_head, education_level, occupation, marital_status)
    VALUES
        (gen_random_uuid(), v_hh12_id, 'Tomba Ngangbam',  60, 'Male',   'Head',   'Illiterate',   'Farmer',          'Married'),
        (gen_random_uuid(), v_hh12_id, 'Ongbi Ngangbam',  55, 'Female', 'Spouse', 'Illiterate',   'Homemaker',       'Married')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 9: SURVEY TEMPLATE SECTIONS & QUESTIONS
    -- ============================================================

    -- Get the existing survey template id
    SELECT id INTO v_template_id FROM public.survey_templates WHERE is_active = true LIMIT 1;

    IF v_template_id IS NULL THEN
        -- Create a template if none exists
        v_template_id := gen_random_uuid();
        INSERT INTO public.survey_templates (id, name, version, description, is_active, created_by)
        VALUES (v_template_id, 'APG Household Survey v1', 1, 'Standard household survey template', true, v_admin_id)
        ON CONFLICT (id) DO NOTHING;
    END IF;

    -- Survey Sections
    INSERT INTO public.survey_sections (id, template_id, section_code, section_title, display_order, is_active)
    VALUES
        (v_sec_basic_id, v_template_id, 'SEC-BASIC', 'Basic Household Information', 1, true),
        (v_sec_land_id,  v_template_id, 'SEC-LAND',  'Land and Assets',             2, true),
        (v_sec_crop_id,  v_template_id, 'SEC-CROP',  'Crop and Farming Details',    3, true)
    ON CONFLICT (id) DO NOTHING;

    -- Survey Questions
    INSERT INTO public.survey_questions (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_family_size_id, v_sec_basic_id, 'Q-BASIC-01', 'What is the total family size?',
         'number'::public.question_type, true, 1, 'Enter total number of family members', true),

        (v_q_tribe_id, v_sec_basic_id, 'Q-BASIC-02', 'What is the tribe or community of the household?',
         'text'::public.question_type, true, 2, 'E.g. Meitei, Kuki, Naga, etc.', true),

        (v_q_land_area_id, v_sec_land_id, 'Q-LAND-01', 'What is the total land area owned (in acres)?',
         'number'::public.question_type, true, 1, 'Enter total land area in acres', true),

        (v_q_irrigation_id, v_sec_land_id, 'Q-LAND-02', 'What is the primary irrigation source?',
         'single_choice'::public.question_type, false, 2, 'Select the main irrigation method', true),

        (v_q_crop_name_id, v_sec_crop_id, 'Q-CROP-01', 'What is the primary crop grown?',
         'text'::public.question_type, true, 1, 'Name the main crop cultivated', true),

        (v_q_crop_season_id, v_sec_crop_id, 'Q-CROP-02', 'In which season is the primary crop grown?',
         'single_choice'::public.question_type, false, 2, 'Select the main cultivation season', true)
    ON CONFLICT (id) DO NOTHING;

    -- Question options for irrigation
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_irrigation_id, 'Rain-fed',      'rain_fed',    1, true),
        (gen_random_uuid(), v_q_irrigation_id, 'Canal',         'canal',       2, true),
        (gen_random_uuid(), v_q_irrigation_id, 'Borewell',      'borewell',    3, true),
        (gen_random_uuid(), v_q_irrigation_id, 'River/Stream',  'river',       4, true)
    ON CONFLICT (id) DO NOTHING;

    -- Question options for crop season
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_crop_season_id, 'Kharif (Monsoon)', 'kharif',  1, true),
        (gen_random_uuid(), v_q_crop_season_id, 'Rabi (Winter)',    'rabi',    2, true),
        (gen_random_uuid(), v_q_crop_season_id, 'Zaid (Summer)',    'zaid',    3, true),
        (gen_random_uuid(), v_q_crop_season_id, 'Year-round',       'yearround',4, true)
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 10: SURVEYS WITH VARIED STATUSES
    -- ============================================================

    -- Survey 1: APPROVED (HH1, FA1)
    INSERT INTO public.surveys (id, household_id, agent_id, template_id, status, last_survey_date, submitted_at, reviewed_at, approved_at, reviewed_by,
        responses)
    VALUES (
        v_survey1_id, v_hh1_id, v_fa1_id, v_template_id,
        'approved'::public.survey_status,
        '2026-08-01',
        now() - interval '5 days',
        now() - interval '3 days',
        now() - interval '2 days',
        v_ch1_id,
        jsonb_build_object(
            v_q_family_size_id::text, '3',
            v_q_tribe_id::text, 'Meitei',
            v_q_land_area_id::text, '2.5',
            v_q_irrigation_id::text, 'rain_fed',
            v_q_crop_name_id::text, 'Paddy',
            v_q_crop_season_id::text, 'kharif'
        )
    ) ON CONFLICT (id) DO NOTHING;

    -- Survey 2: SUBMITTED (HH2, FA1)
    INSERT INTO public.surveys (id, household_id, agent_id, template_id, status, last_survey_date, submitted_at,
        responses)
    VALUES (
        v_survey2_id, v_hh2_id, v_fa1_id, v_template_id,
        'submitted'::public.survey_status,
        '2026-08-02',
        now() - interval '1 day',
        jsonb_build_object(
            v_q_family_size_id::text, '4',
            v_q_tribe_id::text, 'Kuki',
            v_q_land_area_id::text, '1.5',
            v_q_irrigation_id::text, 'canal',
            v_q_crop_name_id::text, 'Maize',
            v_q_crop_season_id::text, 'kharif'
        )
    ) ON CONFLICT (id) DO NOTHING;

    -- Survey 3: CORRECTION_REQUIRED (HH4, FA2)
    INSERT INTO public.surveys (id, household_id, agent_id, template_id, status, last_survey_date, submitted_at, reviewed_at, reviewed_by, rejection_reason,
        responses)
    VALUES (
        v_survey3_id, v_hh4_id, v_fa2_id, v_template_id,
        'correction_required'::public.survey_status,
        '2026-08-04',
        now() - interval '4 days',
        now() - interval '2 days',
        v_ch1_id,
        'Land area figure appears incorrect. Please verify and resubmit.',
        jsonb_build_object(
            v_q_family_size_id::text, '4',
            v_q_tribe_id::text, 'Meitei',
            v_q_land_area_id::text, '0',
            v_q_irrigation_id::text, 'borewell',
            v_q_crop_name_id::text, 'Vegetables',
            v_q_crop_season_id::text, 'yearround'
        )
    ) ON CONFLICT (id) DO NOTHING;

    -- Survey 4: DRAFT (HH7, FA3)
    INSERT INTO public.surveys (id, household_id, agent_id, template_id, status, last_survey_date,
        responses)
    VALUES (
        v_survey4_id, v_hh7_id, v_fa3_id, v_template_id,
        'draft'::public.survey_status,
        'Not started',
        jsonb_build_object(
            v_q_family_size_id::text, '4',
            v_q_tribe_id::text, 'Meitei'
        )
    ) ON CONFLICT (id) DO NOTHING;

    -- Survey 5: APPROVED (HH10, FA4)
    INSERT INTO public.surveys (id, household_id, agent_id, template_id, status, last_survey_date, submitted_at, reviewed_at, approved_at, reviewed_by,
        responses)
    VALUES (
        v_survey5_id, v_hh10_id, v_fa4_id, v_template_id,
        'approved'::public.survey_status,
        '2026-08-10',
        now() - interval '6 days',
        now() - interval '4 days',
        now() - interval '3 days',
        v_ch2_id,
        jsonb_build_object(
            v_q_family_size_id::text, '4',
            v_q_tribe_id::text, 'Meitei',
            v_q_land_area_id::text, '3.0',
            v_q_irrigation_id::text, 'river',
            v_q_crop_name_id::text, 'Paddy',
            v_q_crop_season_id::text, 'kharif'
        )
    ) ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 11: SURVEY ANSWERS (for approved/submitted surveys)
    -- ============================================================

    -- Answers for Survey 1 (approved)
    INSERT INTO public.survey_answers (id, survey_id, question_id, answer_text)
    VALUES
        (gen_random_uuid(), v_survey1_id, v_q_family_size_id, '3'),
        (gen_random_uuid(), v_survey1_id, v_q_tribe_id,       'Meitei'),
        (gen_random_uuid(), v_survey1_id, v_q_land_area_id,   '2.5'),
        (gen_random_uuid(), v_survey1_id, v_q_irrigation_id,  'rain_fed'),
        (gen_random_uuid(), v_survey1_id, v_q_crop_name_id,   'Paddy'),
        (gen_random_uuid(), v_survey1_id, v_q_crop_season_id, 'kharif')
    ON CONFLICT (id) DO NOTHING;

    -- Answers for Survey 2 (submitted)
    INSERT INTO public.survey_answers (id, survey_id, question_id, answer_text)
    VALUES
        (gen_random_uuid(), v_survey2_id, v_q_family_size_id, '4'),
        (gen_random_uuid(), v_survey2_id, v_q_tribe_id,       'Kuki'),
        (gen_random_uuid(), v_survey2_id, v_q_land_area_id,   '1.5'),
        (gen_random_uuid(), v_survey2_id, v_q_irrigation_id,  'canal'),
        (gen_random_uuid(), v_survey2_id, v_q_crop_name_id,   'Maize'),
        (gen_random_uuid(), v_survey2_id, v_q_crop_season_id, 'kharif')
    ON CONFLICT (id) DO NOTHING;

    -- Answers for Survey 5 (approved)
    INSERT INTO public.survey_answers (id, survey_id, question_id, answer_text)
    VALUES
        (gen_random_uuid(), v_survey5_id, v_q_family_size_id, '4'),
        (gen_random_uuid(), v_survey5_id, v_q_tribe_id,       'Meitei'),
        (gen_random_uuid(), v_survey5_id, v_q_land_area_id,   '3.0'),
        (gen_random_uuid(), v_survey5_id, v_q_irrigation_id,  'river'),
        (gen_random_uuid(), v_survey5_id, v_q_crop_name_id,   'Paddy'),
        (gen_random_uuid(), v_survey5_id, v_q_crop_season_id, 'kharif')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 12: BULLETINS
    -- ============================================================

    INSERT INTO public.bulletins (id, title, body, published_by, target_cluster_id, is_active, published_at)
    VALUES
        (v_bulletin1_id,
         'Kharif Season Advisory 2026',
         'Dear Field Agents and Households, the Kharif season is approaching. Please ensure paddy seeds are procured from certified sources. Recommended varieties: RCM-10, Phourel. Sowing window: 15 June to 15 July. Contact your Cluster Head for seed subsidy forms. Proper land preparation and timely transplanting are critical for good yield this season.',
         v_admin_id,
         v_cluster_alpha_id,
         true,
         now() - interval '10 days'),

        (v_bulletin2_id,
         'Pest Alert: Brown Plant Hopper Outbreak',
         'Attention all Field Agents in Cluster Beta: A brown plant hopper (BPH) outbreak has been reported in Bishnupur district. Affected households should immediately apply recommended pesticides (Imidacloprid 17.8 SL @ 125 ml/ha). Do not apply urea at this stage. Report affected households to your Cluster Head within 48 hours. APG will arrange emergency pesticide kits for severely affected families.',
         v_admin_id,
         v_cluster_beta_id,
         true,
         now() - interval '3 days')
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 13: HOUSEHOLD QUESTIONS (3 with different states)
    -- ============================================================

    -- Q1: Answered (HH1)
    INSERT INTO public.household_questions (id, household_id, asked_by, question_text, is_answered)
    VALUES (
        v_hq1_id, v_hh1_id, v_fa1_id,
        'What is the recommended dosage of DAP fertilizer for paddy cultivation on 2 acres of rain-fed land?',
        true
    ) ON CONFLICT (id) DO NOTHING;

    -- Answer for Q1
    INSERT INTO public.question_answers (id, question_id, answered_by, answer_text)
    VALUES (
        gen_random_uuid(), v_hq1_id, v_ch1_id,
        'For 2 acres of rain-fed paddy, apply DAP at 50 kg/acre (100 kg total) as basal dose at transplanting. Split the remaining nitrogen requirement using urea: 25 kg/acre at tillering stage and 25 kg/acre at panicle initiation. Ensure proper water management for optimal nutrient uptake.'
    ) ON CONFLICT (id) DO NOTHING;

    -- Q2: Unanswered (HH7)
    INSERT INTO public.household_questions (id, household_id, asked_by, question_text, is_answered)
    VALUES (
        v_hq2_id, v_hh7_id, v_fa3_id,
        'Our maize crop is showing yellowing of lower leaves and stunted growth. What could be the cause and how should we treat it?',
        false
    ) ON CONFLICT (id) DO NOTHING;

    -- Q3: Answered (HH10)
    INSERT INTO public.household_questions (id, household_id, asked_by, question_text, is_answered)
    VALUES (
        v_hq3_id, v_hh10_id, v_fa4_id,
        'Is there any government scheme available for drip irrigation installation for vegetable farming in Bishnupur district?',
        true
    ) ON CONFLICT (id) DO NOTHING;

    -- Answer for Q3
    INSERT INTO public.question_answers (id, question_id, answered_by, answer_text)
    VALUES (
        gen_random_uuid(), v_hq3_id, v_ch2_id,
        'Yes, the Pradhan Mantri Krishi Sinchayee Yojana (PMKSY) - Per Drop More Crop component provides 55% subsidy for drip irrigation to small and marginal farmers and 45% to other farmers. Apply through the Horticulture Department, Bishnupur. Documents required: land records, Aadhaar, bank passbook. Contact your Field Agent to initiate the application process.'
    ) ON CONFLICT (id) DO NOTHING;

    RAISE NOTICE 'Sample dataset inserted successfully.';
    RAISE NOTICE 'Admin: admin@apg.test / Admin@1234';
    RAISE NOTICE 'Cluster Head Alpha: ch.alpha@apg.test / ClusterHead@1234';
    RAISE NOTICE 'Cluster Head Beta: ch.beta@apg.test / ClusterHead@1234';
    RAISE NOTICE 'Field Agent FA1 (Alpha): fa1.alpha@apg.test / FieldAgent@1234';
    RAISE NOTICE 'Field Agent FA2 (Alpha): fa2.alpha@apg.test / FieldAgent@1234';
    RAISE NOTICE 'Field Agent FA3 (Beta): fa1.beta@apg.test / FieldAgent@1234';
    RAISE NOTICE 'Field Agent FA4 (Beta): fa2.beta@apg.test / FieldAgent@1234';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Sample dataset insertion failed: %', SQLERRM;
        RAISE;
END $$;
