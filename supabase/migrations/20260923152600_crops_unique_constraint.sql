-- Migration: Add unique constraint on crops(survey_id, category, crop_rank)
-- This supports D-10 Crop Details where identity = survey_id + category + crop_rank

-- Add unique index to prevent duplicate crop entries per survey+category+rank
CREATE UNIQUE INDEX IF NOT EXISTS uq_crops_survey_category_rank
    ON public.crops (survey_id, category, crop_rank)
    WHERE survey_id IS NOT NULL
      AND category IS NOT NULL
      AND crop_rank IS NOT NULL;
