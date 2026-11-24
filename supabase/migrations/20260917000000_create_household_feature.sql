-- ============================================================
-- Create Household Feature
-- Timestamp: 20260917000000
-- Adds cluster_id to households for direct cluster association
-- Adds RLS INSERT policy for CLUSTER_HEAD role
-- ============================================================

-- Add cluster_id column to households (direct cluster association)
ALTER TABLE public.households
    ADD COLUMN IF NOT EXISTS cluster_id UUID REFERENCES public.clusters(id) ON DELETE SET NULL;

-- Add RLS INSERT policy for CLUSTER_HEAD
-- Cluster Head can only insert households into their own cluster
DROP POLICY IF EXISTS "hh_insert_cluster_head" ON public.households;
CREATE POLICY "hh_insert_cluster_head"
ON public.households FOR INSERT TO authenticated
WITH CHECK (
    public.is_cluster_head()
    AND cluster_id = public.get_my_cluster_id()
);
