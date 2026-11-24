-- ─────────────────────────────────────────────────────────────────────────────
-- Section G Activation Migration
-- Activates Q-G-02, Q-G-03, Q-G-04, Q-G-05, Q-G-06, Q-G-10
-- (Q-G-01, Q-G-08, Q-G-09 are already active or handled below)
-- Does NOT delete, recreate, or rename any question.
-- Does NOT modify Section E, F, or any other section.
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
    v_sec_g uuid;
BEGIN
    -- Resolve SEC-G section ID
    SELECT id INTO v_sec_g
    FROM public.survey_sections
    WHERE section_code = 'SEC-G'
    LIMIT 1;

    IF v_sec_g IS NULL THEN
        RAISE NOTICE 'SEC-G section not found — no changes made.';
        RETURN;
    END IF;

    -- Activate all G questions that are currently inactive and have zero answers.
    -- Q-G-01 (yes_no): activate if inactive
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-01'
      AND is_active = false;

    -- Q-G-02 (yes_no): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-02'
      AND is_active = false;

    -- Q-G-03 (multiple_choice, max 3): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-03'
      AND is_active = false;

    -- Q-G-04 (multiple_choice): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-04'
      AND is_active = false;

    -- Q-G-05 (multiple_choice): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-05'
      AND is_active = false;

    -- Q-G-06 (text): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-06'
      AND is_active = false;

    -- Q-G-08 (yes_no): activate if inactive
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-08'
      AND is_active = false;

    -- Q-G-09 (multiple_choice): activate if inactive
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-09'
      AND is_active = false;

    -- Q-G-10 (yes_no): activate
    UPDATE public.survey_questions
    SET is_active = true
    WHERE section_id = v_sec_g
      AND question_code = 'Q-G-10'
      AND is_active = false;

    RAISE NOTICE 'Section G questions activated successfully.';
END $$;
