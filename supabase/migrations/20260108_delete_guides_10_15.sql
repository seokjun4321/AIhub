-- Migration: Delete Guides 10 and 15
-- Date: 2026-01-08

BEGIN;

-- 1. Delete from related tables (if no CASCADE constraint exists, manual deletion is safer)

-- guide_categories
DELETE FROM public.guide_categories WHERE guide_id IN (10, 15);

-- guide_steps (usually have CASCADE, but ensuring cleanup)
-- DELETE FROM public.guide_steps WHERE guide_id IN (10, 15);

-- guide_prompts
-- DELETE FROM public.guide_prompts WHERE guide_id IN (10, 15);


-- 2. Delete from guides table
DELETE FROM public.guides WHERE id IN (10, 15);

COMMIT;
