-- ─────────────────────────────────────────────────────────────────────────────
-- Activate six inactive Section G questions
-- Targets: Q-G-02, Q-G-03, Q-G-04, Q-G-05, Q-G-06, Q-G-10
-- Scoped to survey_sections.section_code = 'G'
-- Idempotent: AND q.is_active = false guard prevents double-updates
-- Does NOT insert, delete, recreate, or rename any question or option.
-- Does NOT modify Section E, F, or any other section.
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
    v_sec_g uuid;
BEGIN
    -- Resolve section ID using section_code = 'G'
    SELECT id INTO v_sec_g
    FROM public.survey_sections
    WHERE section_code = 'G'
    LIMIT 1;

    IF v_sec_g IS NULL THEN
        RAISE NOTICE 'Section with section_code = ''G'' not found — no changes made.';
        RETURN;
    END IF;

    -- Q-G-02: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-02'
      AND q.is_active = false;

    -- Q-G-03: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-03'
      AND q.is_active = false;

    -- Q-G-04: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-04'
      AND q.is_active = false;

    -- Q-G-05: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-05'
      AND q.is_active = false;

    -- Q-G-06: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-06'
      AND q.is_active = false;

    -- Q-G-10: activate if currently inactive
    UPDATE public.survey_questions q
    SET is_active = true
    WHERE q.section_id = v_sec_g
      AND q.question_code = 'Q-G-10'
      AND q.is_active = false;

    RAISE NOTICE 'Section G activation complete: Q-G-02, Q-G-03, Q-G-04, Q-G-05, Q-G-06, Q-G-10 set to is_active = true (where previously false).';
END $$;
