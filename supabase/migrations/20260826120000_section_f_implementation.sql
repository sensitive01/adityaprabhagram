-- ─────────────────────────────────────────────────────────────────────────────
-- Section F Implementation Migration
-- Adds F.1 (Livestock Pest) and F.2 (Livestock Disease) marker questions,
-- replaces F3-01/F3-02 with correct definitions, adds F3-03/F3-04/F3-05.
-- Does NOT modify Section E, RLS, or database schema.
-- Self-sufficient: creates SEC-F / SEC-F3 sections if they don't exist yet.
-- ─────────────────────────────────────────────────────────────────────────────

DO $$
DECLARE
    v_template_id   uuid;
    v_sec_f         uuid;
    v_sec_f3        uuid;
    v_q_f_pest      uuid;
    v_q_f_disease   uuid;
    v_q_f3_01       uuid;
    v_q_f3_02       uuid;
    v_q_f3_03       uuid;
    v_q_f3_04       uuid;
    v_q_f3_05       uuid;
BEGIN

    -- ── Resolve or create the active survey template ──────────────────────
    SELECT id INTO v_template_id
    FROM public.survey_templates
    WHERE is_active = true
    ORDER BY created_at ASC
    LIMIT 1;

    IF v_template_id IS NULL THEN
        v_template_id := gen_random_uuid();
        INSERT INTO public.survey_templates (id, name, version, description, is_active)
        VALUES (
            v_template_id,
            'APG Baseline Survey v1',
            1,
            'AdityaPrabhaGram Socio-Economics Baseline Survey — complete questionnaire',
            true
        );
    END IF;

    -- ── Resolve SEC-F section ID (create if missing) ──────────────────────
    SELECT id INTO v_sec_f
    FROM public.survey_sections
    WHERE section_code = 'SEC-F'
    LIMIT 1;

    IF v_sec_f IS NULL THEN
        v_sec_f := gen_random_uuid();
        INSERT INTO public.survey_sections
            (id, template_id, section_code, section_title, display_order, is_active)
        VALUES
            (v_sec_f, v_template_id, 'SEC-F', 'F: Livestock Pest & Disease', 9, true);
    END IF;

    -- ── Resolve SEC-F3 section ID (create if missing) ─────────────────────
    SELECT id INTO v_sec_f3
    FROM public.survey_sections
    WHERE section_code = 'SEC-F3'
    LIMIT 1;

    IF v_sec_f3 IS NULL THEN
        v_sec_f3 := gen_random_uuid();
        INSERT INTO public.survey_sections
            (id, template_id, section_code, section_title, display_order, is_active)
        VALUES
            (v_sec_f3, v_template_id, 'SEC-F3', 'F3: Weed Management', 10, true);
    END IF;

    -- ── Resolve existing F3-01 and F3-02 question IDs ─────────────────────
    SELECT id INTO v_q_f3_01
    FROM public.survey_questions
    WHERE question_code = 'F3-01'
    LIMIT 1;

    SELECT id INTO v_q_f3_02
    FROM public.survey_questions
    WHERE question_code = 'F3-02'
    LIMIT 1;

    -- ── F.1 Marker: F-LIVESTOCK-PEST ──────────────────────────────────────
    -- Check if already exists; insert only if missing
    IF NOT EXISTS (
        SELECT 1 FROM public.survey_questions
        WHERE question_code = 'F-LIVESTOCK-PEST'
    ) THEN
        v_q_f_pest := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f_pest, v_sec_f, 'F-LIVESTOCK-PEST',
             'F.1 Livestock Pest Incidence',
             'text'::public.question_type,
             false, 1, 'Structured livestock pest records', true);
    END IF;

    -- ── F.2 Marker: F-LIVESTOCK-DISEASE ───────────────────────────────────
    IF NOT EXISTS (
        SELECT 1 FROM public.survey_questions
        WHERE question_code = 'F-LIVESTOCK-DISEASE'
    ) THEN
        v_q_f_disease := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f_disease, v_sec_f, 'F-LIVESTOCK-DISEASE',
             'F.2 Livestock Disease Incidence',
             'text'::public.question_type,
             false, 2, 'Structured livestock disease records', true);
    END IF;

    -- ── F3-01: Replace with correct definition ────────────────────────────
    -- Confirmed: no existing survey_answers for F3-01 or F3-02
    IF v_q_f3_01 IS NOT NULL THEN
        -- Delete old options first
        DELETE FROM public.survey_question_options
        WHERE question_id = v_q_f3_01;

        -- Update question definition
        UPDATE public.survey_questions
        SET question_text  = 'Name of Major weeds with Crop',
            question_type  = 'text'::public.question_type,
            display_order  = 1,
            help_text      = 'List the major weeds observed with each crop',
            is_active      = true
        WHERE id = v_q_f3_01;
    ELSE
        -- Insert fresh if somehow missing
        v_q_f3_01 := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f3_01, v_sec_f3, 'F3-01',
             'Name of Major weeds with Crop',
             'text'::public.question_type,
             false, 1, 'List the major weeds observed with each crop', true);
    END IF;

    -- ── F3-02: Replace with correct definition ────────────────────────────
    IF v_q_f3_02 IS NOT NULL THEN
        -- Delete old options first
        DELETE FROM public.survey_question_options
        WHERE question_id = v_q_f3_02;

        -- Update question definition
        UPDATE public.survey_questions
        SET question_text  = 'How do you manage weeds in your crop?',
            question_type  = 'multiple_choice'::public.question_type,
            display_order  = 2,
            help_text      = 'Select all methods used',
            is_active      = true
        WHERE id = v_q_f3_02;

        -- Insert correct options
        INSERT INTO public.survey_question_options
            (id, question_id, option_text, option_value, display_order, is_active)
        VALUES
            (gen_random_uuid(), v_q_f3_02, 'Manual weeding',       'manual_weeding',   1, true),
            (gen_random_uuid(), v_q_f3_02, 'Mulching',             'mulching',         2, true),
            (gen_random_uuid(), v_q_f3_02, 'Chemical weedicides',  'chemical',         3, true),
            (gen_random_uuid(), v_q_f3_02, 'No control',           'no_control',       4, true);
    ELSE
        v_q_f3_02 := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f3_02, v_sec_f3, 'F3-02',
             'How do you manage weeds in your crop?',
             'multiple_choice'::public.question_type,
             false, 2, 'Select all methods used', true);

        INSERT INTO public.survey_question_options
            (id, question_id, option_text, option_value, display_order, is_active)
        VALUES
            (gen_random_uuid(), v_q_f3_02, 'Manual weeding',       'manual_weeding',   1, true),
            (gen_random_uuid(), v_q_f3_02, 'Mulching',             'mulching',         2, true),
            (gen_random_uuid(), v_q_f3_02, 'Chemical weedicides',  'chemical',         3, true),
            (gen_random_uuid(), v_q_f3_02, 'No control',           'no_control',       4, true);
    END IF;

    -- ── F3-03: Any indigenous method used for weeding? ────────────────────
    IF NOT EXISTS (
        SELECT 1 FROM public.survey_questions
        WHERE question_code = 'F3-03'
    ) THEN
        v_q_f3_03 := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f3_03, v_sec_f3, 'F3-03',
             'Any indigenous method used for weeding?',
             'text'::public.question_type,
             false, 3,
             'Describe any traditional weed control practices used', true);
    END IF;

    -- ── F3-04: Tools/methods for intercultural operations ─────────────────
    IF NOT EXISTS (
        SELECT 1 FROM public.survey_questions
        WHERE question_code = 'F3-04'
    ) THEN
        v_q_f3_04 := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f3_04, v_sec_f3, 'F3-04',
             'What tools/methods do you use for intercultural operations?',
             'multiple_choice'::public.question_type,
             false, 4, 'Select all that apply', true);

        INSERT INTO public.survey_question_options
            (id, question_id, option_text, option_value, display_order, is_active)
        VALUES
            (gen_random_uuid(), v_q_f3_04, 'Manual',       'manual',       1, true),
            (gen_random_uuid(), v_q_f3_04, 'Hand tools',   'hand_tools',   2, true),
            (gen_random_uuid(), v_q_f3_04, 'Mechanical',   'mechanical',   3, true),
            (gen_random_uuid(), v_q_f3_04, 'Others',       'others',       4, true);
    END IF;

    -- ── F3-05: Who does manual weeding? ───────────────────────────────────
    IF NOT EXISTS (
        SELECT 1 FROM public.survey_questions
        WHERE question_code = 'F3-05'
    ) THEN
        v_q_f3_05 := gen_random_uuid();
        INSERT INTO public.survey_questions
            (id, section_id, question_code, question_text, question_type,
             required, display_order, help_text, is_active)
        VALUES
            (v_q_f3_05, v_sec_f3, 'F3-05',
             'Who does manual weeding?',
             'multiple_choice'::public.question_type,
             false, 5, 'Select all that apply', true);

        INSERT INTO public.survey_question_options
            (id, question_id, option_text, option_value, display_order, is_active)
        VALUES
            (gen_random_uuid(), v_q_f3_05, 'Men (from family)',    'men_family',    1, true),
            (gen_random_uuid(), v_q_f3_05, 'Women (from family)',  'women_family',  2, true),
            (gen_random_uuid(), v_q_f3_05, 'Hired labour',         'hired_labour',  3, true),
            (gen_random_uuid(), v_q_f3_05, 'Others',               'others',        4, true);
    END IF;

END $$;
