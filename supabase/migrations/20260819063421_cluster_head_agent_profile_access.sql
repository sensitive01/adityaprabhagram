-- ============================================================
-- AdityaPrabhaGram — Cluster Head Field Agent Profile Access
-- Timestamp: 20260819063421
-- Depends on: 20260817120000_apg_full_schema.sql
--             20260817140000_security_hardening.sql
--
-- WHAT THIS MIGRATION DOES:
--   Adds a tightly scoped RLS SELECT policy on public.user_profiles
--   that allows a Cluster Head to read the profile of a Field Agent
--   IF AND ONLY IF that Field Agent has an active assignment in the
--   Cluster Head's cluster (via field_agent_cluster_assignments).
--
--   Existing policies preserved:
--     - up_select_own  : users read their own row
--     - up_select_admin: ADMIN reads all rows
--
--   New policy added:
--     - up_select_cluster_head_agents: CLUSTER_HEAD reads profiles of
--       Field Agents in their cluster only
-- ============================================================

-- ============================================================
-- SECTION 1: HELPER FUNCTION
-- ============================================================
-- This SECURITY DEFINER function checks whether a given profile UUID
-- belongs to a Field Agent who is actively assigned to the calling
-- Cluster Head's cluster.
--
-- SECURITY DEFINER is required so the function can query
-- field_agent_cluster_assignments without being blocked by its own
-- RLS context, and to avoid any circular dependency on user_profiles.
--
-- The function NEVER queries user_profiles itself, so there is
-- no risk of infinite recursion.
-- ============================================================

CREATE OR REPLACE FUNCTION public.is_agent_in_my_cluster(p_profile_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.field_agent_cluster_assignments faca
        WHERE faca.agent_id    = p_profile_id
          AND faca.cluster_id  = public.get_my_cluster_id()
          AND faca.is_active   = true
    );
$$;

-- ============================================================
-- SECTION 2: RLS POLICY
-- ============================================================
-- Drop any prior version of this policy (idempotent).
DROP POLICY IF EXISTS "up_select_cluster_head_agents" ON public.user_profiles;

-- SELECT: CLUSTER_HEAD may read profiles of Field Agents in their cluster.
-- Scope is strictly limited:
--   1. Caller must be a CLUSTER_HEAD (is_cluster_head()).
--   2. The target row must belong to a Field Agent actively assigned
--      to the Cluster Head's cluster (is_agent_in_my_cluster(id)).
-- This does NOT grant unrestricted access to user_profiles.
CREATE POLICY "up_select_cluster_head_agents"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (
    public.is_cluster_head()
    AND public.is_agent_in_my_cluster(id)
);

-- ============================================================
-- END OF MIGRATION
-- ============================================================
