-- AI Models Table Schema Update
-- Adding new columns to support detailed tool information (badges, pricing models, pros/cons, features, etc.)
-- This is a non-destructive update. Existing columns are preserved.

-- 1. Meta Info (JSONB) for badges and chips (Platform, Korean Support, Login Required)
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS meta_info jsonb DEFAULT '{}'::jsonb;

-- 2. Pricing Info Detailed
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS pricing_model text, -- e.g. "Freemium"
ADD COLUMN IF NOT EXISTS free_tier_note text; -- e.g. "GPT-5.1 Instant limited availability"

-- 3. Pros and Cons (Text Arrays)
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS pros text[] DEFAULT '{}'::text[],
ADD COLUMN IF NOT EXISTS cons text[] DEFAULT '{}'::text[];

-- 4. Key Features (JSONB) for detailed feature checklist
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS key_features jsonb DEFAULT '[]'::jsonb;

-- 5. Recommendations (JSONB) for "Recommended for / Not recommended for"
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS recommendations jsonb DEFAULT '{}'::jsonb;

-- 6. Usage Tips (Text Array) for "Mistake Prevention"
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS usage_tips text[] DEFAULT '{}'::text[];

-- 7. Privacy Info (JSONB)
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS privacy_info jsonb DEFAULT '{}'::jsonb;

-- 8. Alternatives (JSONB) for "Recommended Alternatives"
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS alternatives jsonb DEFAULT '[]'::jsonb;

-- 9. Media Info (JSONB) for official videos
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS media_info jsonb DEFAULT '[]'::jsonb;

-- Comments for documentation
COMMENT ON COLUMN public.ai_models.meta_info IS 'Badges and chips data (e.g. platforms, korean_support)';
COMMENT ON COLUMN public.ai_models.pricing_model IS 'Short summary of pricing model (e.g. Freemium)';
COMMENT ON COLUMN public.ai_models.pros IS 'List of advantages';
COMMENT ON COLUMN public.ai_models.cons IS 'List of disadvantages or limitations';
COMMENT ON COLUMN public.ai_models.key_features IS 'Structured list of key features with descriptions';
COMMENT ON COLUMN public.ai_models.recommendations IS 'Target audience recommendations (recommended/not_recommended)';
COMMENT ON COLUMN public.ai_models.usage_tips IS 'Tips for avoiding common mistakes';
