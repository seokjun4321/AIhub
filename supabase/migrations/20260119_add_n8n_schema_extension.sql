-- Add missing columns requested by user for n8n integration
ALTER TABLE public.ai_models
ADD COLUMN IF NOT EXISTS version text,
ADD COLUMN IF NOT EXISTS best_for text[],
ADD COLUMN IF NOT EXISTS search_tags text[],
ADD COLUMN IF NOT EXISTS comparison_data jsonb DEFAULT '{}'::jsonb;

COMMENT ON COLUMN public.ai_models.version IS 'Tool version information';
COMMENT ON COLUMN public.ai_models.best_for IS 'List of ideal user targets (distinct from recommendations json)';
COMMENT ON COLUMN public.ai_models.search_tags IS 'Keywords for search optimization';
COMMENT ON COLUMN public.ai_models.comparison_data IS 'Detailed comparison data with other tools';
