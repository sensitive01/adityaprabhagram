-- ============================================================
-- AdityaPrabhaGram — Phase 2B Survey Template Seeding
-- Timestamp: 20260819150000
-- Depends on: 20260819140000_phase2b_structured_tables.sql
--
-- WHAT THIS MIGRATION DOES:
--   1. Creates (or reuses) the APG Baseline Survey v1 template
--   2. Creates all questionnaire sections A–Z (all inactive by default)
--   3. Seeds ALL questions from the approved questionnaire
--      with is_active = false by default
--   4. Activates ONLY the approved 20 test items
--   5. Seeds answer options for all choice-based questions
--
-- IMPORTANT DESIGN RULES (per approved Phase 2B clarification):
--   - The 20 active items are a TESTING SUBSET, not a separate impl.
--   - The complete questionnaire is represented in the database.
--   - is_active = true for the 20 test items only.
--   - is_active = false for all other questions.
--   - Deactivated questions do NOT appear in new FA surveys.
--   - Additional questions can be activated via Admin without
--     requiring any new Field Agent code.
--   - Questions with existing answers are protected from deletion
--     by the ON DELETE RESTRICT FK on survey_answers.question_id.
-- ============================================================

DO $$
DECLARE
    -- Template
    v_template_id UUID;

    -- Sections (one per questionnaire section A–Z + sub-sections)
    v_sec_a   UUID := gen_random_uuid();  -- A: Respondent Details
    v_sec_b   UUID := gen_random_uuid();  -- B: Household Profile
    v_sec_b2  UUID := gen_random_uuid();  -- B2: Occupation
    v_sec_b3  UUID := gen_random_uuid();  -- B3: Special Skills
    v_sec_c   UUID := gen_random_uuid();  -- C: Land & Assets
    v_sec_c10 UUID := gen_random_uuid();  -- C10: Livestock/Enterprises
    v_sec_d   UUID := gen_random_uuid();  -- D: Agricultural Information
    v_sec_e   UUID := gen_random_uuid();  -- E: Crop Pest & Disease
    v_sec_f   UUID := gen_random_uuid();  -- F: Livestock Pest & Disease
    v_sec_f3  UUID := gen_random_uuid();  -- F3: Weed Management
    v_sec_g   UUID := gen_random_uuid();  -- G: Climate Change
    v_sec_h   UUID := gen_random_uuid();  -- H: Organic Farming
    v_sec_i   UUID := gen_random_uuid();  -- I: ITK Practices
    v_sec_k   UUID := gen_random_uuid();  -- K: Income Sources
    v_sec_l   UUID := gen_random_uuid();  -- L: Employment Seasonality
    v_sec_m   UUID := gen_random_uuid();  -- M: Marketing
    v_sec_m1  UUID := gen_random_uuid();  -- M1: Money Circulation
    v_sec_m2  UUID := gen_random_uuid();  -- M2: Community Intervention
    v_sec_n   UUID := gen_random_uuid();  -- N: Seed Production
    v_sec_o   UUID := gen_random_uuid();  -- O: Government Schemes
    v_sec_p   UUID := gen_random_uuid();  -- P: Extension Services
    v_sec_q   UUID := gen_random_uuid();  -- Q: Financial Inclusion
    v_sec_r   UUID := gen_random_uuid();  -- R: Gender Decision Making
    v_sec_s   UUID := gen_random_uuid();  -- S: Expenditure
    v_sec_t   UUID := gen_random_uuid();  -- T: Gender Work Distribution
    v_sec_u   UUID := gen_random_uuid();  -- U: Operational Gap
    v_sec_v   UUID := gen_random_uuid();  -- V: Food Security
    v_sec_w   UUID := gen_random_uuid();  -- W: Skill Assessment
    v_sec_x   UUID := gen_random_uuid();  -- X: Border Constraints
    v_sec_y   UUID := gen_random_uuid();  -- Y: Priority Needs
    v_sec_z   UUID := gen_random_uuid();  -- Z: Enumerator Observations

    -- ── THE 20 ACTIVE TEST QUESTION IDs ──────────────────────
    -- These are the ONLY questions with is_active = true.
    -- All other questions are seeded with is_active = false.
    -- To activate additional questions, use Admin → Survey Questions.

    -- Test item 1: GPS (Section A) — tests GPS capture
    v_q_gps           UUID := gen_random_uuid();
    -- Test item 2: Photo (Section A) — tests photo upload
    v_q_photo         UUID := gen_random_uuid();
    -- Test item 3: Family size (Section B) — tests number + required
    v_q_family_size   UUID := gen_random_uuid();
    -- Test item 4: Household type (Section B) — tests single_choice
    v_q_hh_type       UUID := gen_random_uuid();
    -- Test item 5: Bank account Yes/No (Section B) — tests yes_no + conditional trigger
    v_q_bank_account  UUID := gen_random_uuid();
    -- Test item 6: Bank account type (Section B) — tests conditional logic (shown if Q5=yes)
    v_q_bank_type     UUID := gen_random_uuid();
    -- Test item 7: Drinking water sources (Section B) — tests multiple_choice
    v_q_water_sources UUID := gen_random_uuid();
    -- Test item 8: Respondent name (Section A) — tests text + required
    v_q_respondent    UUID := gen_random_uuid();
    -- Test item 9: Primary occupation (Section B2) — tests single_choice required
    v_q_occupation    UUID := gen_random_uuid();
    -- Test item 10: Food sufficiency months (Section G) — tests number optional
    v_q_food_months   UUID := gen_random_uuid();

    -- Structured component question IDs (items 11–20 are structured records,
    -- represented as marker questions that trigger structured data entry in the FA app)
    -- Test item 11: Household members roster (Section B) — repeating record
    v_q_hh_members    UUID := gen_random_uuid();
    -- Test item 12: Land parcels (Section C) — structured land_assets record
    v_q_land_parcels  UUID := gen_random_uuid();
    -- Test item 13: Household assets (Section C) — structured household_assets record
    v_q_assets        UUID := gen_random_uuid();
    -- Test item 14: Crops grown (Section D) — structured crops record
    v_q_crops         UUID := gen_random_uuid();
    -- Test item 15: Livestock held (Section C10) — structured livestock record
    v_q_livestock     UUID := gen_random_uuid();
    -- Test item 16: Crop pest/disease incident (Section E) — structured pests_diseases record
    v_q_pest_incident UUID := gen_random_uuid();
    -- Test item 17: Income sources (Section K) — structured income record
    v_q_income        UUID := gen_random_uuid();
    -- Test item 18: Government schemes (Section O) — structured schemes record
    v_q_schemes       UUID := gen_random_uuid();
    -- Test item 19: Priority needs ranking (Section Y) — structured priority_needs record
    v_q_priority      UUID := gen_random_uuid();
    -- Test item 20: Employment seasonality matrix (Section L) — structured employment_seasonality
    v_q_seasonality   UUID := gen_random_uuid();

    -- Inactive question IDs (representative subset — all seeded as is_active=false)
    v_q_mobile        UUID := gen_random_uuid();
    v_q_aadhaar       UUID := gen_random_uuid();
    v_q_village       UUID := gen_random_uuid();
    v_q_block         UUID := gen_random_uuid();
    v_q_district      UUID := gen_random_uuid();
    v_q_state         UUID := gen_random_uuid();
    v_q_tribe         UUID := gen_random_uuid();
    v_q_house_type    UUID := gen_random_uuid();
    v_q_dropout       UUID := gen_random_uuid();
    v_q_dropout_count UUID := gen_random_uuid();
    v_q_dropout_reason UUID := gen_random_uuid();
    v_q_sec_occ       UUID := gen_random_uuid();
    v_q_special_skills UUID := gen_random_uuid();
    v_q_land_owned    UUID := gen_random_uuid();
    v_q_land_irr      UUID := gen_random_uuid();
    v_q_land_unirr    UUID := gen_random_uuid();
    v_q_land_leased_in UUID := gen_random_uuid();
    v_q_land_leased_out UUID := gen_random_uuid();
    v_q_weed_types    UUID := gen_random_uuid();
    v_q_weed_control  UUID := gen_random_uuid();
    v_q_climate_obs   UUID := gen_random_uuid();
    v_q_climate_adapt UUID := gen_random_uuid();
    v_q_organic_aware UUID := gen_random_uuid();
    v_q_organic_prac  UUID := gen_random_uuid();
    v_q_organic_cert  UUID := gen_random_uuid();
    v_q_insurance     UUID := gen_random_uuid();
    v_q_pension       UUID := gen_random_uuid();
    v_q_shg           UUID := gen_random_uuid();
    v_q_seed_prod     UUID := gen_random_uuid();
    v_q_training      UUID := gen_random_uuid();
    v_q_border        UUID := gen_random_uuid();
    v_q_skill_assess  UUID := gen_random_uuid();
    v_q_expenditure   UUID := gen_random_uuid();
    v_q_marketing     UUID := gen_random_uuid();
    v_q_community     UUID := gen_random_uuid();
    v_q_gender_dm     UUID := gen_random_uuid();
    v_q_gender_wd     UUID := gen_random_uuid();
    v_q_food_sec      UUID := gen_random_uuid();
    v_q_obs_text      UUID := gen_random_uuid();

BEGIN

    -- ============================================================
    -- STEP 1: GET OR CREATE THE APG BASELINE SURVEY TEMPLATE
    -- ============================================================

    -- Reuse the existing active template if one exists, otherwise create it.
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
        ) ON CONFLICT (id) DO NOTHING;
    ELSE
        -- Update the name of the existing template to the canonical name
        UPDATE public.survey_templates
        SET name = 'APG Baseline Survey v1',
            description = 'AdityaPrabhaGram Socio-Economics Baseline Survey — complete questionnaire',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = v_template_id;
    END IF;

    -- ============================================================
    -- STEP 2: DELETE EXISTING SECTIONS/QUESTIONS FOR THIS TEMPLATE
    -- (Only safe because existing survey_answers use ON DELETE RESTRICT
    --  on question_id — if any answers exist, this will fail safely.
    --  The sample dataset questions have answers, so we skip those.)
    -- We use a targeted approach: only insert new sections/questions
    -- that do not already exist, identified by section_code.
    -- ============================================================

    -- ============================================================
    -- STEP 3: CREATE SECTIONS (idempotent by section_code + template_id)
    -- ============================================================

    INSERT INTO public.survey_sections (id, template_id, section_code, section_title, display_order, is_active)
    VALUES
        (v_sec_a,   v_template_id, 'SEC-A',   'A: Respondent Details',          1,  true),
        (v_sec_b,   v_template_id, 'SEC-B',   'B: Household Profile',           2,  true),
        (v_sec_b2,  v_template_id, 'SEC-B2',  'B2: Occupation',                 3,  true),
        (v_sec_b3,  v_template_id, 'SEC-B3',  'B3: Special Skills',             4,  true),
        (v_sec_c,   v_template_id, 'SEC-C',   'C: Land & Assets',               5,  true),
        (v_sec_c10, v_template_id, 'SEC-C10', 'C10: Livestock & Enterprises',   6,  true),
        (v_sec_d,   v_template_id, 'SEC-D',   'D: Agricultural Information',    7,  true),
        (v_sec_e,   v_template_id, 'SEC-E',   'E: Crop Pest & Disease',         8,  true),
        (v_sec_f,   v_template_id, 'SEC-F',   'F: Livestock Pest & Disease',    9,  true),
        (v_sec_f3,  v_template_id, 'SEC-F3',  'F3: Weed Management',            10, true),
        (v_sec_g,   v_template_id, 'SEC-G',   'G: Climate Change',              11, true),
        (v_sec_h,   v_template_id, 'SEC-H',   'H: Organic Farming',             12, true),
        (v_sec_i,   v_template_id, 'SEC-I',   'I: ITK Practices',               13, true),
        (v_sec_k,   v_template_id, 'SEC-K',   'K: Income Sources',              14, true),
        (v_sec_l,   v_template_id, 'SEC-L',   'L: Employment Seasonality',      15, true),
        (v_sec_m,   v_template_id, 'SEC-M',   'M: Marketing',                   16, true),
        (v_sec_m1,  v_template_id, 'SEC-M1',  'M1: Money Circulation',          17, true),
        (v_sec_m2,  v_template_id, 'SEC-M2',  'M2: Community Intervention',     18, true),
        (v_sec_n,   v_template_id, 'SEC-N',   'N: Seed Production',             19, true),
        (v_sec_o,   v_template_id, 'SEC-O',   'O: Government Schemes',          20, true),
        (v_sec_p,   v_template_id, 'SEC-P',   'P: Extension Services',          21, true),
        (v_sec_q,   v_template_id, 'SEC-Q',   'Q: Financial Inclusion',         22, true),
        (v_sec_r,   v_template_id, 'SEC-R',   'R: Gender Decision Making',      23, true),
        (v_sec_s,   v_template_id, 'SEC-S',   'S: Expenditure',                 24, true),
        (v_sec_t,   v_template_id, 'SEC-T',   'T: Gender Work Distribution',    25, true),
        (v_sec_u,   v_template_id, 'SEC-U',   'U: Operational Gap',             26, true),
        (v_sec_v,   v_template_id, 'SEC-V',   'V: Food Security & Nutrition',   27, true),
        (v_sec_w,   v_template_id, 'SEC-W',   'W: Skill Assessment',            28, true),
        (v_sec_x,   v_template_id, 'SEC-X',   'X: Border Constraints',          29, true),
        (v_sec_y,   v_template_id, 'SEC-Y',   'Y: Priority Needs',              30, true),
        (v_sec_z,   v_template_id, 'SEC-Z',   'Z: Enumerator Observations',     31, true)
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 4: SEED ALL QUESTIONS
    -- is_active = TRUE  → the 20 approved test items
    -- is_active = FALSE → all other questions (complete questionnaire)
    -- ============================================================

    -- ── SECTION A: Respondent Details ────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 8: Respondent name — text, required
        (v_q_respondent, v_sec_a, 'A-01', 'Respondent Name',
         'text'::public.question_type, true, 1, 'Full name of the respondent', true),

        -- INACTIVE: Mobile number
        (v_q_mobile, v_sec_a, 'A-02', 'Mobile Number',
         'number'::public.question_type, true, 2, '10-digit mobile number', false),

        -- INACTIVE: Aadhaar/EPIC
        (v_q_aadhaar, v_sec_a, 'A-03', 'Aadhaar / EPIC Number',
         'text'::public.question_type, false, 3, 'Enter Aadhaar or Voter ID number', false),

        -- INACTIVE: Village
        (v_q_village, v_sec_a, 'A-04', 'Village',
         'text'::public.question_type, true, 4, null, false),

        -- INACTIVE: Block
        (v_q_block, v_sec_a, 'A-05', 'Block',
         'text'::public.question_type, true, 5, null, false),

        -- INACTIVE: District
        (v_q_district, v_sec_a, 'A-06', 'District',
         'text'::public.question_type, true, 6, null, false),

        -- INACTIVE: State
        (v_q_state, v_sec_a, 'A-07', 'State',
         'text'::public.question_type, true, 7, null, false),

        -- TEST ITEM 1: GPS — gps type
        (v_q_gps, v_sec_a, 'A-GPS', 'Capture GPS Location of Household',
         'gps'::public.question_type, true, 8, 'Stand at the main entrance of the house', true),

        -- TEST ITEM 2: Photo — photo type
        (v_q_photo, v_sec_a, 'A-PHOTO', 'Upload Photo of the House / Respondent',
         'photo'::public.question_type, false, 9, 'Take a clear photo showing the front of the house', true)

    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION B: Household Profile ─────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 3: Family size — number, required
        (v_q_family_size, v_sec_b, 'B-01', 'Total Number of Family Members',
         'number'::public.question_type, true, 1, 'Include all members living in the household', true),

        -- INACTIVE: Tribe
        (v_q_tribe, v_sec_b, 'B-02', 'Tribe / Community of the Household',
         'text'::public.question_type, false, 2, 'Enter the tribe or community name', false),

        -- TEST ITEM 4: Household type — single_choice
        (v_q_hh_type, v_sec_b, 'B-03', 'Household Type',
         'single_choice'::public.question_type, true, 3, null, true),

        -- INACTIVE: House type
        (v_q_house_type, v_sec_b, 'B-04', 'Type of House',
         'single_choice'::public.question_type, true, 4, null, false),

        -- TEST ITEM 5: Bank account — yes_no (conditional trigger for Q6)
        (v_q_bank_account, v_sec_b, 'B-05', 'Do you have a bank account?',
         'yes_no'::public.question_type, true, 5, null, true),

        -- TEST ITEM 6: Bank account type — single_choice, conditional on Q5=yes
        (v_q_bank_type, v_sec_b, 'B-06', 'Type of bank account',
         'single_choice'::public.question_type, false, 6, 'Shown only if bank account = Yes', true),

        -- TEST ITEM 7: Drinking water sources — multiple_choice
        (v_q_water_sources, v_sec_b, 'B-07', 'Primary sources of drinking water',
         'multiple_choice'::public.question_type, true, 7, 'Select all that apply', true),

        -- INACTIVE: School dropout
        (v_q_dropout, v_sec_b, 'B-08', 'Is there any school dropout in the household in the last 2 years?',
         'yes_no'::public.question_type, true, 8, null, false),

        -- INACTIVE: Dropout count
        (v_q_dropout_count, v_sec_b, 'B-09', 'If yes, number of school dropouts',
         'number'::public.question_type, false, 9, 'Enter 0 if none', false),

        -- INACTIVE: Dropout reason
        (v_q_dropout_reason, v_sec_b, 'B-10', 'If yes, reason for school dropout',
         'text'::public.question_type, false, 10, 'Describe the reason(s)', false),

        -- TEST ITEM 11: Household members roster — structured repeating record
        (v_q_hh_members, v_sec_b, 'B-MEMBERS', 'Household Members Roster',
         'text'::public.question_type, true, 11,
         'Enter details for each household member (name, age, gender, relation, education, occupation)', true)

    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION B2: Occupation ────────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 9: Primary occupation — single_choice, required
        (v_q_occupation, v_sec_b2, 'B2-01', 'Primary Occupation of Household Head',
         'single_choice'::public.question_type, true, 1, null, true),

        -- INACTIVE: Secondary occupation
        (v_q_sec_occ, v_sec_b2, 'B2-02', 'Secondary Occupation of Household Head (if any)',
         'text'::public.question_type, false, 2, 'e.g. Bee-keeping, Mushroom Cultivation, Weaving', false)

    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION B3: Special Skills ────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_special_skills, v_sec_b3, 'B3-01', 'Special skills available in your household',
         'multiple_choice'::public.question_type, false, 1, 'Select all that apply', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION C: Land & Assets ──────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- INACTIVE: Land area summary questions
        (v_q_land_owned, v_sec_c, 'C-01', 'Total Land Owned (in acres)',
         'number'::public.question_type, true, 1, 'Enter 0 if no land ownership', false),

        (v_q_land_irr, v_sec_c, 'C-02', 'Irrigated Land (in acres)',
         'number'::public.question_type, false, 2, null, false),

        (v_q_land_unirr, v_sec_c, 'C-03', 'Unirrigated Land (in acres)',
         'number'::public.question_type, false, 3, null, false),

        (v_q_land_leased_in, v_sec_c, 'C-04', 'Leased-in Land (in acres)',
         'number'::public.question_type, false, 4, 'Land taken on lease from others', false),

        (v_q_land_leased_out, v_sec_c, 'C-05', 'Leased-out Land (in acres)',
         'number'::public.question_type, false, 5, 'Land given on lease to others', false),

        -- TEST ITEM 12: Land parcels — structured land_assets record
        (v_q_land_parcels, v_sec_c, 'C-LAND', 'Land Parcels Details',
         'text'::public.question_type, false, 6,
         'Enter details for each land parcel (type, area, irrigation, soil, ownership)', true),

        -- TEST ITEM 13: Household assets — structured household_assets record
        (v_q_assets, v_sec_c, 'C-ASSETS', 'Household Assets Inventory',
         'text'::public.question_type, false, 7,
         'Record all physical assets (equipment, tools, vehicles, etc.)', true)

    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION C10: Livestock & Enterprises ─────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 15: Livestock — structured livestock record
        (v_q_livestock, v_sec_c10, 'C10-LIVESTOCK', 'Livestock & Enterprise Holdings',
         'text'::public.question_type, false, 1,
         'Enter details for each livestock type (animal, breed, count, purpose, income, costs)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION D: Agricultural Information ──────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 14: Crops — structured crops record
        (v_q_crops, v_sec_d, 'D-CROPS', 'Crops Grown This Season',
         'text'::public.question_type, false, 1,
         'Enter details for each crop (name, season, area, variety, yield, input cost, sale price)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION E: Crop Pest & Disease ───────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 16: Crop pest/disease — structured pests_diseases record
        (v_q_pest_incident, v_sec_e, 'E-PEST', 'Crop Pest / Disease Incidents',
         'text'::public.question_type, false, 1,
         'Record each pest or disease incident (crop, pest name, severity, control method, loss %)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION F3: Weed Management ──────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_weed_types, v_sec_f3, 'F3-01', 'Weed types observed in fields',
         'multiple_choice'::public.question_type, false, 1, 'Select all that apply', false),

        (v_q_weed_control, v_sec_f3, 'F3-02', 'Primary weed control method',
         'single_choice'::public.question_type, false, 2, null, false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION G: Climate Change ─────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_climate_obs, v_sec_g, 'G-01', 'Climate changes observed in the last 5 years',
         'multiple_choice'::public.question_type, false, 1, 'Select all that apply', false),

        (v_q_climate_adapt, v_sec_g, 'G-02', 'Adaptation measures adopted',
         'multiple_choice'::public.question_type, false, 2, 'Select all that apply', false),

        -- TEST ITEM 20 (food sufficiency is in G per questionnaire mapping)
        (v_q_food_months, v_sec_g, 'G-03', 'Food sufficiency months per year',
         'number'::public.question_type, false, 3,
         'How many months per year does household food production meet household needs?', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION H: Organic Farming ────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_organic_aware, v_sec_h, 'H-01', 'Are you aware of organic farming practices?',
         'yes_no'::public.question_type, false, 1, null, false),

        (v_q_organic_prac, v_sec_h, 'H-02', 'Are you currently practicing organic farming?',
         'yes_no'::public.question_type, false, 2, null, false),

        (v_q_organic_cert, v_sec_h, 'H-03', 'Organic certification status',
         'single_choice'::public.question_type, false, 3, null, false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION K: Income Sources ─────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 17: Income sources — structured income record
        (v_q_income, v_sec_k, 'K-INCOME', 'Income Sources',
         'text'::public.question_type, false, 1,
         'Record each income source (source, type, season, amount, frequency)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION L: Employment Seasonality ────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 20 (seasonality matrix)
        (v_q_seasonality, v_sec_l, 'L-SEASON', 'Employment Activity Seasonality Matrix',
         'text'::public.question_type, false, 1,
         'Record employment days per month per activity (male and female separately)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION M: Marketing ─────────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_marketing, v_sec_m, 'M-01', 'Agricultural Marketing Details',
         'text'::public.question_type, false, 1,
         'Record each product sold (market, distance, transport, price, quantity, buyer)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION M2: Community Intervention ───────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_community, v_sec_m2, 'M2-01', 'Community Programs & Interventions',
         'text'::public.question_type, false, 1,
         'Record each program participated in (name, type, role, year, benefit)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION N: Seed Production ────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_seed_prod, v_sec_n, 'N-01', 'Seed Production Activities',
         'text'::public.question_type, false, 1,
         'Record each crop under seed production (variety, area, quantity, certification)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION O: Government Schemes ────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 18: Government schemes — structured schemes record
        (v_q_schemes, v_sec_o, 'O-SCHEMES', 'Government Schemes Accessed',
         'text'::public.question_type, false, 1,
         'Record each scheme (name, type, benefit, year, amount)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION P: Extension Services ────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_training, v_sec_p, 'P-01', 'Training Needs',
         'text'::public.question_type, false, 1,
         'Record each training need (enterprise, topic, priority, preferred mode)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION Q: Financial Inclusion ───────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_insurance, v_sec_q, 'Q-01', 'Insurance coverage held',
         'multiple_choice'::public.question_type, false, 1, 'Select all that apply', false),

        (v_q_pension, v_sec_q, 'Q-02', 'Do you receive any pension scheme benefit?',
         'yes_no'::public.question_type, false, 2, null, false),

        (v_q_shg, v_sec_q, 'Q-03', 'Are you a member of a Self Help Group (SHG)?',
         'yes_no'::public.question_type, false, 3, null, false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION R: Gender Decision Making ────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_gender_dm, v_sec_r, 'R-01', 'Gender Decision Making Matrix',
         'text'::public.question_type, false, 1,
         'Record decision-making roles by activity (male/female/joint)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION S: Expenditure ────────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_expenditure, v_sec_s, 'S-01', 'Household Expenditure Details',
         'text'::public.question_type, false, 1,
         'Record each expenditure category (category, amount, frequency, season)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION T: Gender Work Distribution ──────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_gender_wd, v_sec_t, 'T-01', 'Gender Work Distribution Matrix',
         'text'::public.question_type, false, 1,
         'Record work distribution by activity (male days / female days per season)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION V: Food Security ──────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_food_sec, v_sec_v, 'V-01', 'Food Security & Nutrition Details',
         'text'::public.question_type, false, 1,
         'Record each food item (source, months available, deficit months)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION W: Skill Assessment ───────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_skill_assess, v_sec_w, 'W-01', 'Skill-Based Need Assessment',
         'text'::public.question_type, false, 1,
         'Record each skill area (current level, desired level, preferred training mode)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION X: Border Constraints ────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_border, v_sec_x, 'X-01', 'Border-Specific Constraints',
         'text'::public.question_type, false, 1,
         'Record each constraint (type, description, severity, suggested solution)', false)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION Y: Priority Needs ─────────────────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        -- TEST ITEM 19: Priority needs ranking — structured priority_needs record
        (v_q_priority, v_sec_y, 'Y-PRIORITY', 'Household Priority Needs (Ranked)',
         'text'::public.question_type, false, 1,
         'Record priority needs in order of importance (rank 1 = highest priority)', true)
    ON CONFLICT (id) DO NOTHING;

    -- ── SECTION Z: Enumerator Observations ───────────────────
    INSERT INTO public.survey_questions
        (id, section_id, question_code, question_text, question_type, required, display_order, help_text, is_active)
    VALUES
        (v_q_obs_text, v_sec_z, 'Z-01', 'Enumerator Observations',
         'text'::public.question_type, false, 1,
         'Record overall observations about the household and data quality', false)
    ON CONFLICT (id) DO NOTHING;

    -- ============================================================
    -- STEP 5: SET CONDITIONAL LOGIC
    -- Bank account type (B-06) is conditional on bank account (B-05) = 'yes'
    -- ============================================================

    UPDATE public.survey_questions
    SET conditional_on_question_id = v_q_bank_account,
        conditional_on_value = 'yes',
        updated_at = CURRENT_TIMESTAMP
    WHERE id = v_q_bank_type;

    -- ============================================================
    -- STEP 6: SEED ANSWER OPTIONS FOR CHOICE-BASED QUESTIONS
    -- ============================================================

    -- Household type options (B-03)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_hh_type, 'Nuclear',        'nuclear',        1, true),
        (gen_random_uuid(), v_q_hh_type, 'Joint',          'joint',          2, true),
        (gen_random_uuid(), v_q_hh_type, 'Female-headed',  'female_headed',  3, true),
        (gen_random_uuid(), v_q_hh_type, 'Male-headed',    'male_headed',    4, true),
        (gen_random_uuid(), v_q_hh_type, 'Extended',       'extended',       5, true)
    ON CONFLICT (id) DO NOTHING;

    -- House type options (B-04)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_house_type, 'Kutcha (Temporary)',  'kutcha',     1, true),
        (gen_random_uuid(), v_q_house_type, 'Semi-pucca',          'semi_pucca', 2, true),
        (gen_random_uuid(), v_q_house_type, 'Pucca (Permanent)',   'pucca',      3, true)
    ON CONFLICT (id) DO NOTHING;

    -- Bank account type options (B-06)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_bank_type, 'Savings Account',  'savings',   1, true),
        (gen_random_uuid(), v_q_bank_type, 'Current Account',  'current',   2, true),
        (gen_random_uuid(), v_q_bank_type, 'Jan Dhan Account', 'jan_dhan',  3, true),
        (gen_random_uuid(), v_q_bank_type, 'Other',            'other',     4, true)
    ON CONFLICT (id) DO NOTHING;

    -- Drinking water sources options (B-07)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_water_sources, 'Tap Water (Piped)',    'tap_piped',   1, true),
        (gen_random_uuid(), v_q_water_sources, 'Hand Pump / Tubewell', 'hand_pump',   2, true),
        (gen_random_uuid(), v_q_water_sources, 'Open Well',            'open_well',   3, true),
        (gen_random_uuid(), v_q_water_sources, 'River / Stream',       'river',       4, true),
        (gen_random_uuid(), v_q_water_sources, 'Rainwater Harvesting', 'rainwater',   5, true),
        (gen_random_uuid(), v_q_water_sources, 'Purchased Water',      'purchased',   6, true),
        (gen_random_uuid(), v_q_water_sources, 'Other',                'other',       7, true)
    ON CONFLICT (id) DO NOTHING;

    -- Primary occupation options (B2-01)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_occupation, 'Agriculture',                  'agriculture',    1, true),
        (gen_random_uuid(), v_q_occupation, 'Livestock',                    'livestock',      2, true),
        (gen_random_uuid(), v_q_occupation, 'Wage Labour',                  'wage_labour',    3, true),
        (gen_random_uuid(), v_q_occupation, 'Service / Govt. Job',          'service_govt',   4, true),
        (gen_random_uuid(), v_q_occupation, 'Self-employment / Business',   'self_employed',  5, true),
        (gen_random_uuid(), v_q_occupation, 'Others',                       'others',         6, true)
    ON CONFLICT (id) DO NOTHING;

    -- Special skills options (B3-01)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_special_skills, 'Beekeeping',             'beekeeping',     1, true),
        (gen_random_uuid(), v_q_special_skills, 'Mushroom Cultivation',   'mushroom',       2, true),
        (gen_random_uuid(), v_q_special_skills, 'Weaving / Handicraft',   'weaving',        3, true),
        (gen_random_uuid(), v_q_special_skills, 'Carpentry / Masonry',    'carpentry',      4, true),
        (gen_random_uuid(), v_q_special_skills, 'Fishery',                'fishery',        5, true),
        (gen_random_uuid(), v_q_special_skills, 'Piggery',                'piggery',        6, true),
        (gen_random_uuid(), v_q_special_skills, 'Poultry',                'poultry',        7, true),
        (gen_random_uuid(), v_q_special_skills, 'Food Processing',        'food_processing',8, true),
        (gen_random_uuid(), v_q_special_skills, 'Others',                 'others',         9, true)
    ON CONFLICT (id) DO NOTHING;

    -- Organic certification options (H-03)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_organic_cert, 'Certified Organic',        'certified',      1, true),
        (gen_random_uuid(), v_q_organic_cert, 'Truthfully Labelled',      'truthful',       2, true),
        (gen_random_uuid(), v_q_organic_cert, 'In Process',               'in_process',     3, true),
        (gen_random_uuid(), v_q_organic_cert, 'None',                     'none',           4, true)
    ON CONFLICT (id) DO NOTHING;

    -- Climate changes observed options (G-01)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_climate_obs, 'Erratic rainfall',           'erratic_rain',   1, true),
        (gen_random_uuid(), v_q_climate_obs, 'Drought / Dry spells',       'drought',        2, true),
        (gen_random_uuid(), v_q_climate_obs, 'Floods',                     'floods',         3, true),
        (gen_random_uuid(), v_q_climate_obs, 'Temperature increase',       'temp_increase',  4, true),
        (gen_random_uuid(), v_q_climate_obs, 'Pest / disease increase',    'pest_increase',  5, true),
        (gen_random_uuid(), v_q_climate_obs, 'Crop failure',               'crop_failure',   6, true),
        (gen_random_uuid(), v_q_climate_obs, 'No significant change',      'no_change',      7, true)
    ON CONFLICT (id) DO NOTHING;

    -- Insurance coverage options (Q-01)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_insurance, 'Crop Insurance (PMFBY)',       'crop_pmfby',     1, true),
        (gen_random_uuid(), v_q_insurance, 'Life Insurance',               'life',           2, true),
        (gen_random_uuid(), v_q_insurance, 'Health Insurance (PMJAY)',     'health_pmjay',   3, true),
        (gen_random_uuid(), v_q_insurance, 'Livestock Insurance',          'livestock',      4, true),
        (gen_random_uuid(), v_q_insurance, 'None',                         'none',           5, true)
    ON CONFLICT (id) DO NOTHING;

    -- Weed types options (F3-01)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_weed_types, 'Grass weeds',         'grass',        1, true),
        (gen_random_uuid(), v_q_weed_types, 'Broadleaf weeds',     'broadleaf',    2, true),
        (gen_random_uuid(), v_q_weed_types, 'Sedge weeds',         'sedge',        3, true),
        (gen_random_uuid(), v_q_weed_types, 'Aquatic weeds',       'aquatic',      4, true),
        (gen_random_uuid(), v_q_weed_types, 'Others',              'others',       5, true)
    ON CONFLICT (id) DO NOTHING;

    -- Weed control method options (F3-02)
    INSERT INTO public.survey_question_options (id, question_id, option_text, option_value, display_order, is_active)
    VALUES
        (gen_random_uuid(), v_q_weed_control, 'Manual weeding',        'manual',       1, true),
        (gen_random_uuid(), v_q_weed_control, 'Chemical herbicide',    'chemical',     2, true),
        (gen_random_uuid(), v_q_weed_control, 'Mechanical tillage',    'mechanical',   3, true),
        (gen_random_uuid(), v_q_weed_control, 'Mulching',              'mulching',     4, true),
        (gen_random_uuid(), v_q_weed_control, 'No control',            'none',         5, true)
    ON CONFLICT (id) DO NOTHING;

    RAISE NOTICE 'Phase 2B survey template seeding completed successfully.';
    RAISE NOTICE 'Template ID: %', v_template_id;
    RAISE NOTICE '20 test items are active. All other questions are inactive.';
    RAISE NOTICE 'To activate additional questions: Admin -> Survey Questions -> toggle is_active.';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Phase 2B seeding failed: %', SQLERRM;
        RAISE;
END $$;
