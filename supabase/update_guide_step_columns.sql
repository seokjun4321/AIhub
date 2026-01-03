-- Add structured columns to guide_steps table
ALTER TABLE public.guide_steps
ADD COLUMN IF NOT EXISTS goal TEXT,
ADD COLUMN IF NOT EXISTS done_when TEXT,
ADD COLUMN IF NOT EXISTS why_matters TEXT,
ADD COLUMN IF NOT EXISTS tips TEXT, -- For "Common Mistakes & Tips"
ADD COLUMN IF NOT EXISTS checklist TEXT; -- For "Mini Checklist"

-- Optional: Add comments to describe columns
COMMENT ON COLUMN public.guide_steps.goal IS 'The specific goal of this step';
COMMENT ON COLUMN public.guide_steps.done_when IS 'Condition to mark this step as done';
COMMENT ON COLUMN public.guide_steps.why_matters IS 'Explanation of why this step is important';
COMMENT ON COLUMN public.guide_steps.tips IS 'Common mistakes and tips for this step (Markdown supported)';
COMMENT ON COLUMN public.guide_steps.checklist IS 'Mini checklist items for this step (Markdown supported)';
