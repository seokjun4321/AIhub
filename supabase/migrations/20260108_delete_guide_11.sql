-- Migration: Delete Guide 11
-- Date: 2026-01-08

BEGIN;

-- 1. Delete from related tables
DELETE FROM public.guide_categories WHERE guide_id = 11;

-- 2. Delete from guides table
DELETE FROM public.guides WHERE id = 11;

COMMIT;
