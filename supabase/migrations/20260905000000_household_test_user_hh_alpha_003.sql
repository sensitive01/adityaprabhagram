-- Provision a Supabase auth user for the Singh Household (HH-ALPHA-003)
-- and link it via households.household_user_id.
-- No Dart code, survey data, RLS policies, or other households are affected.

DO $$
DECLARE
    v_user_id UUID;
    v_linked_uid UUID;
    v_profile_role TEXT;
BEGIN
    -- Check if the auth user already exists (idempotent)
    SELECT id INTO v_user_id
    FROM auth.users
    WHERE email = 'singh.household@fieldops.in'
    LIMIT 1;

    IF v_user_id IS NULL THEN
        v_user_id := gen_random_uuid();

        -- Minimal reliable INSERT — only columns that are always present
        -- in Supabase managed auth.users
        INSERT INTO auth.users (
            id,
            instance_id,
            aud,
            role,
            email,
            encrypted_password,
            email_confirmed_at,
            created_at,
            updated_at,
            raw_user_meta_data,
            raw_app_meta_data,
            is_sso_user,
            is_anonymous
        ) VALUES (
            v_user_id,
            '00000000-0000-0000-0000-000000000000',
            'authenticated',
            'authenticated',
            'singh.household@fieldops.in',
            crypt('Test@1234', gen_salt('bf', 10)),
            now(),
            now(),
            now(),
            jsonb_build_object('full_name', 'Singh Household', 'role', 'HOUSEHOLD'),
            jsonb_build_object('provider', 'email', 'providers', ARRAY['email']::TEXT[]),
            false,
            false
        );

        RAISE NOTICE 'Created auth user for singh.household@fieldops.in with id %', v_user_id;
    ELSE
        RAISE NOTICE 'Auth user singh.household@fieldops.in already exists with id %', v_user_id;
    END IF;

    -- Ensure user_profiles row exists with role HOUSEHOLD
    -- (handle_new_user trigger may have already created it)
    INSERT INTO public.user_profiles (id, email, full_name, role, avatar_url)
    VALUES (v_user_id, 'singh.household@fieldops.in', 'Singh Household', 'HOUSEHOLD'::public.user_role, '')
    ON CONFLICT (id) DO UPDATE SET role = 'HOUSEHOLD'::public.user_role;

    RAISE NOTICE 'user_profiles row ensured with role HOUSEHOLD for id %', v_user_id;

    -- Link the auth user to HH-ALPHA-003
    UPDATE public.households
    SET household_user_id = v_user_id
    WHERE id = 'HH-ALPHA-003';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'UPDATE failed: no row found in households with id = HH-ALPHA-003';
    END IF;

    RAISE NOTICE 'Set households.household_user_id = % for HH-ALPHA-003', v_user_id;

    -- ── Verification ──────────────────────────────────────────────────────────

    -- 1. Confirm household_user_id on HH-ALPHA-003 matches v_user_id
    SELECT household_user_id INTO v_linked_uid
    FROM public.households
    WHERE id = 'HH-ALPHA-003';

    IF v_linked_uid IS DISTINCT FROM v_user_id THEN
        RAISE EXCEPTION 'VERIFICATION FAILED: HH-ALPHA-003.household_user_id = % but expected %',
            v_linked_uid, v_user_id;
    END IF;

    RAISE NOTICE 'VERIFICATION OK: HH-ALPHA-003.household_user_id = % (matches singh.household auth UID)', v_linked_uid;

    -- 2. Confirm user_profiles row has role HOUSEHOLD
    SELECT role::TEXT INTO v_profile_role
    FROM public.user_profiles
    WHERE id = v_user_id;

    IF v_profile_role IS DISTINCT FROM 'HOUSEHOLD' THEN
        RAISE EXCEPTION 'VERIFICATION FAILED: user_profiles.role = % for id %, expected HOUSEHOLD',
            v_profile_role, v_user_id;
    END IF;

    RAISE NOTICE 'VERIFICATION OK: user_profiles.role = HOUSEHOLD for id %', v_user_id;
    RAISE NOTICE '── FINAL RESULT ──────────────────────────────────────────────────────────';
    RAISE NOTICE 'singh.household auth UID          : %', v_user_id;
    RAISE NOTICE 'HH-ALPHA-003.household_user_id    : %', v_linked_uid;
    RAISE NOTICE 'Match                             : %', (v_user_id = v_linked_uid);

EXCEPTION
    WHEN OTHERS THEN
        -- Re-raise so the migration fails loudly with the real error
        RAISE EXCEPTION 'Migration failed: % (SQLSTATE: %)', SQLERRM, SQLSTATE;
END $$;
