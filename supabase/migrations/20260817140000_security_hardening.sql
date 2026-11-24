-- ============================================================
-- AdityaPrabhaGram — Security Hardening Migration
-- Timestamp: 20260817140000
-- Depends on: 20260817120000_apg_full_schema.sql
--
-- WHAT THIS MIGRATION DOES:
--   1. Makes survey_status_history tamper-resistant:
--      - Adds SECURITY DEFINER trigger on surveys that auto-writes a
--        history record whenever surveys.status changes.
--      - Removes the open WITH CHECK (true) INSERT policy so normal
--        authenticated users cannot insert arbitrary history records.
--      - Preserves all existing role-based SELECT policies.
--   2. Makes audit_log tamper-resistant:
--      - Adds SECURITY DEFINER audit trigger functions on critical tables
--        (surveys, households, user_profiles, cluster_heads,
--         field_agent_cluster_assignments, household_agent_assignments).
--      - Removes the open WITH CHECK (true) INSERT policy so no
--        authenticated user can fabricate audit records.
--      - Preserves ADMIN-only SELECT access.
--   3. Password change behaviour:
--      - Changes must_change_password DEFAULT to false so no forced
--        first-login password change is imposed.
--      - Users (Cluster Head, Field Agent, Household) can voluntarily
--        change their password after login via supabase.auth.updateUser().
-- ============================================================

-- ============================================================
-- SECTION 1: SURVEY STATUS HISTORY — TAMPER-RESISTANT TRIGGER
-- ============================================================

-- Function: auto-write a survey_status_history row whenever
-- surveys.status changes. Runs as SECURITY DEFINER so it can
-- INSERT into survey_status_history regardless of the caller's
-- RLS context, while normal users lose direct INSERT access.
CREATE OR REPLACE FUNCTION public.trg_fn_record_survey_status_change()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
BEGIN
    -- Only fire when status actually changes
    IF NEW.status IS DISTINCT FROM OLD.status THEN
        INSERT INTO public.survey_status_history (
            id,
            survey_id,
            from_status,
            to_status,
            changed_by,
            changed_at,
            notes
        ) VALUES (
            gen_random_uuid(),
            NEW.id,
            OLD.status,
            NEW.status,
            auth.uid(),
            now(),
            NULL
        );
    END IF;
    RETURN NEW;
END;
$func$;

-- Attach trigger to surveys table
DROP TRIGGER IF EXISTS trg_survey_status_history ON public.surveys;
CREATE TRIGGER trg_survey_status_history
    AFTER UPDATE ON public.surveys
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_record_survey_status_change();

-- Remove the open INSERT policy — history is now written exclusively
-- by the SECURITY DEFINER trigger above.
DROP POLICY IF EXISTS "ssh_insert_auth" ON public.survey_status_history;

-- ============================================================
-- SECTION 2: AUDIT LOG — TAMPER-RESISTANT TRIGGER FUNCTIONS
-- ============================================================

-- Core audit writer function: called by all audit triggers.
-- SECURITY DEFINER ensures it can always INSERT into audit_log
-- regardless of the caller's RLS context.
CREATE OR REPLACE FUNCTION public.fn_write_audit_log(
    p_table_name  TEXT,
    p_record_id   TEXT,
    p_action      TEXT,
    p_old_data    JSONB,
    p_new_data    JSONB
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
BEGIN
    INSERT INTO public.audit_log (
        id,
        table_name,
        record_id,
        action,
        performed_by,
        old_data,
        new_data,
        performed_at
    ) VALUES (
        gen_random_uuid(),
        p_table_name,
        p_record_id,
        p_action,
        auth.uid(),
        p_old_data,
        p_new_data,
        now()
    );
EXCEPTION
    WHEN OTHERS THEN
        -- Never let audit failure break the main transaction
        RAISE WARNING 'audit_log write failed for table=%: %', p_table_name, SQLERRM;
END;
$func$;

-- ── Generic trigger function used by all audited tables ──────
CREATE OR REPLACE FUNCTION public.trg_fn_audit_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
    v_record_id TEXT;
    v_old_data  JSONB;
    v_new_data  JSONB;
    v_action    TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_action    := 'INSERT';
        v_record_id := NEW.id::TEXT;
        v_old_data  := NULL;
        v_new_data  := to_jsonb(NEW);
    ELSIF TG_OP = 'UPDATE' THEN
        v_action    := 'UPDATE';
        v_record_id := NEW.id::TEXT;
        v_old_data  := to_jsonb(OLD);
        v_new_data  := to_jsonb(NEW);
    ELSIF TG_OP = 'DELETE' THEN
        v_action    := 'DELETE';
        v_record_id := OLD.id::TEXT;
        v_old_data  := to_jsonb(OLD);
        v_new_data  := NULL;
    END IF;

    PERFORM public.fn_write_audit_log(
        TG_TABLE_NAME,
        v_record_id,
        v_action,
        v_old_data,
        v_new_data
    );

    -- Return appropriate row for trigger type
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$func$;

-- ── Attach audit triggers to critical tables ─────────────────

-- surveys
DROP TRIGGER IF EXISTS trg_audit_surveys ON public.surveys;
CREATE TRIGGER trg_audit_surveys
    AFTER INSERT OR UPDATE OR DELETE ON public.surveys
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- households
DROP TRIGGER IF EXISTS trg_audit_households ON public.households;
CREATE TRIGGER trg_audit_households
    AFTER INSERT OR UPDATE OR DELETE ON public.households
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- user_profiles
DROP TRIGGER IF EXISTS trg_audit_user_profiles ON public.user_profiles;
CREATE TRIGGER trg_audit_user_profiles
    AFTER INSERT OR UPDATE OR DELETE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- cluster_heads
DROP TRIGGER IF EXISTS trg_audit_cluster_heads ON public.cluster_heads;
CREATE TRIGGER trg_audit_cluster_heads
    AFTER INSERT OR UPDATE OR DELETE ON public.cluster_heads
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- field_agent_cluster_assignments
DROP TRIGGER IF EXISTS trg_audit_fa_cluster_assignments ON public.field_agent_cluster_assignments;
CREATE TRIGGER trg_audit_fa_cluster_assignments
    AFTER INSERT OR UPDATE OR DELETE ON public.field_agent_cluster_assignments
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- household_agent_assignments
DROP TRIGGER IF EXISTS trg_audit_hh_agent_assignments ON public.household_agent_assignments;
CREATE TRIGGER trg_audit_hh_agent_assignments
    AFTER INSERT OR UPDATE OR DELETE ON public.household_agent_assignments
    FOR EACH ROW
    EXECUTE FUNCTION public.trg_fn_audit_changes();

-- Remove the open INSERT policy — audit records are now written
-- exclusively by SECURITY DEFINER trigger functions above.
-- ADMIN retains SELECT access via the existing "al_select_admin" policy.
DROP POLICY IF EXISTS "al_insert_system" ON public.audit_log;

-- ============================================================
-- SECTION 3: PASSWORD CHANGE BEHAVIOUR
-- ============================================================

-- Change must_change_password default to false.
-- No forced first-login password change is imposed.
-- Users can voluntarily change their password after login
-- via supabase.auth.updateUser() at any time.
ALTER TABLE public.user_profiles
    ALTER COLUMN must_change_password SET DEFAULT false;

-- Ensure any existing accounts created with must_change_password = true
-- (which were set by the old default) are reset to false,
-- since mandatory first-login change is no longer required.
-- NOTE: This only affects accounts where the flag was set by the system
-- default. Accounts where an admin explicitly set it to true are also
-- reset here per the requirement that forced change is not required.
UPDATE public.user_profiles
SET must_change_password = false
WHERE must_change_password = true;

-- ============================================================
-- END OF MIGRATION
-- ============================================================
