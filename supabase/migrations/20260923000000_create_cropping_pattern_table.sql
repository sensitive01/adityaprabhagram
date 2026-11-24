-- ============================================================
-- AdityaPrabhaGram — Create cropping_pattern table
-- Timestamp: 20260923000000
-- Depends on: 20260819140000_phase2b_structured_tables.sql
--
-- WHAT THIS MIGRATION DOES:
--   Creates the public.cropping_pattern table required by
--   Q9 (Section D) of the APG Field Agent survey.
--   Applies RLS following the same pattern as household_assets,
--   employment_seasonality, and other structured survey tables.
-- ============================================================

-- ── Table ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cropping_pattern (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    survey_id    UUID        NOT NULL REFERENCES public.surveys(id) ON DELETE RESTRICT,
    household_id TEXT        NOT NULL REFERENCES public.households(id) ON DELETE RESTRICT,
    category     TEXT        NOT NULL,
    kharif       TEXT,
    rabi         TEXT,
    zaid         TEXT,
    created_by   UUID        REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT cropping_pattern_survey_category_unique UNIQUE (survey_id, category)
);

-- ── Indexes ──────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_cropping_pattern_survey_id
    ON public.cropping_pattern(survey_id);

CREATE INDEX IF NOT EXISTS idx_cropping_pattern_household_id
    ON public.cropping_pattern(household_id);

-- ── RLS ──────────────────────────────────────────────────────
ALTER TABLE public.cropping_pattern ENABLE ROW LEVEL SECURITY;

-- Admin: full select
DROP POLICY IF EXISTS "cp_select_admin" ON public.cropping_pattern;
CREATE POLICY "cp_select_admin" ON public.cropping_pattern
    FOR SELECT TO authenticated
    USING (public.is_admin());

-- Cluster head: select households in their cluster
DROP POLICY IF EXISTS "cp_select_ch" ON public.cropping_pattern;
CREATE POLICY "cp_select_ch" ON public.cropping_pattern
    FOR SELECT TO authenticated
    USING (public.is_cluster_head() AND public.is_household_in_my_cluster(household_id));

-- Field agent: select their assigned households
DROP POLICY IF EXISTS "cp_select_fa" ON public.cropping_pattern;
CREATE POLICY "cp_select_fa" ON public.cropping_pattern
    FOR SELECT TO authenticated
    USING (public.is_field_agent() AND public.is_my_assigned_household(household_id));

-- Household user: select their own household
DROP POLICY IF EXISTS "cp_select_hh" ON public.cropping_pattern;
CREATE POLICY "cp_select_hh" ON public.cropping_pattern
    FOR SELECT TO authenticated
    USING (public.is_household_user() AND public.is_my_household(household_id));

-- Admin: full write
DROP POLICY IF EXISTS "cp_write_admin" ON public.cropping_pattern;
CREATE POLICY "cp_write_admin" ON public.cropping_pattern
    FOR ALL TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());

-- Field agent: write for their assigned households
DROP POLICY IF EXISTS "cp_write_fa" ON public.cropping_pattern;
CREATE POLICY "cp_write_fa" ON public.cropping_pattern
    FOR ALL TO authenticated
    USING (public.is_field_agent() AND public.is_my_assigned_household(household_id))
    WITH CHECK (public.is_field_agent() AND public.is_my_assigned_household(household_id));
