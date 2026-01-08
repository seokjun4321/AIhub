-- Migration: Cleanup Categories to fixed 8 types
-- Date: 2026-01-08

BEGIN;

-- 1. Clear references to categories from all related tables
-- This prevents Foreign Key violation errors when deleting categories.

-- 1.1 guide_categories (Junction table) -> Delete records
DELETE FROM public.guide_categories;

-- 1.2 guides -> Set category_id to NULL
UPDATE public.guides SET category_id = NULL;

-- 1.3 tool_proposals -> Set category_id to NULL (Check existence)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'tool_proposals' AND column_name = 'category_id') THEN
        UPDATE public.tool_proposals SET category_id = NULL;
    END IF;
END $$;

-- 1.4 posts -> Set category_id to NULL (Check existence)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'posts' AND column_name = 'category_id') THEN
        UPDATE public.posts SET category_id = NULL;
    END IF;
END $$;

-- 1.5 prompts -> Set category_id to NULL (Check existence)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'prompts' AND column_name = 'category_id') THEN
        UPDATE public.prompts SET category_id = NULL;
    END IF;
END $$;


-- 2. Delete all existing categories
DELETE FROM public.categories;


-- 3. Insert standardized 8 categories
INSERT INTO public.categories (name, description)
VALUES 
    ('AI 기초 입문', 'AI 활용의 첫걸음을 떼는 입문자를 위한 가이드. ChatGPT, Claude 등 AI 툴 시작하기'),
    ('콘텐츠 제작', 'AI로 영상, 이미지, 블로그, 소셜미디어 콘텐츠 만들기'),
    ('개발 & 코딩', '코드 작성, 디버깅, 기술 개념 설명, 프로그래밍 학습'),
    ('글쓰기 & 교정', '에세이, 리포트, 성찰문, 발표 스크립트를 AI로 작성 및 개선'),
    ('취업 준비', '이력서, 자기소개서, 포트폴리오, 면접 준비 가이드'),
    ('연구 & 학습', '개념 이해, 노트 정리, 연습 문제 생성, 학습 효율화'),
    ('업무 자동화', 'n8n, Zapier 등을 활용한 워크플로우 자동화'),
    ('창업 & 비즈니스', '사업 계획, 시장 분석, 피칭 자료, 스타트업 운영');


-- 4. Re-assign guides to appropriate categories

DO $$
DECLARE
    v_cat_intro_id INTEGER;
    v_cat_study_id INTEGER;
    v_cat_coding_id INTEGER;
BEGIN
    -- Get Category IDs
    SELECT id INTO v_cat_intro_id FROM public.categories WHERE name = 'AI 기초 입문';
    SELECT id INTO v_cat_study_id FROM public.categories WHERE name = '연구 & 학습';
    SELECT id INTO v_cat_coding_id FROM public.categories WHERE name = '개발 & 코딩';

    -- 4.1 "ChatGPT 완전 처음 시작하기" (Guide ID 2) -> AI 기초 입문
    UPDATE public.guides 
    SET category_id = v_cat_intro_id 
    WHERE id = 2;

    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    VALUES (2, v_cat_intro_id, true)
    ON CONFLICT (guide_id, category_id) DO NOTHING;

    -- 4.2 "Prompt Upgrader" -> AI 기초 입문
    UPDATE public.guides 
    SET category_id = v_cat_intro_id 
    WHERE title ILIKE '%Prompt Upgrader%';

    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    SELECT id, v_cat_intro_id, true 
    FROM public.guides 
    WHERE title ILIKE '%Prompt Upgrader%'
    ON CONFLICT (guide_id, category_id) DO NOTHING;

    -- 4.3 "AI Personalization" -> AI 기초 입문
    UPDATE public.guides 
    SET category_id = v_cat_intro_id 
    WHERE title ILIKE '%AI%개인화%' OR title ILIKE '%AI%personalization%';

    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    SELECT id, v_cat_intro_id, true 
    FROM public.guides 
    WHERE title ILIKE '%AI%개인화%' OR title ILIKE '%AI%personalization%'
    ON CONFLICT (guide_id, category_id) DO NOTHING;

    -- 4.4 나머지 가이드 매핑 (이미지 기반)
    
    -- Guide 10: ChatGPT 완벽 활용 가이드 -> AI 기초 입문
    UPDATE public.guides SET category_id = v_cat_intro_id WHERE id = 10;
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (10, v_cat_intro_id, true) ON CONFLICT DO NOTHING;

    -- Guide 11: Google Gemini 시작하기 -> AI 기초 입문
    UPDATE public.guides SET category_id = v_cat_intro_id WHERE id = 11;
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (11, v_cat_intro_id, true) ON CONFLICT DO NOTHING;

    -- Guide 13: 에세이 작성 가이드북 -> 글쓰기 & 교정
    DECLARE
        v_cat_writing_id INTEGER;
    BEGIN
        SELECT id INTO v_cat_writing_id FROM public.categories WHERE name = '글쓰기 & 교정';
        
        UPDATE public.guides SET category_id = v_cat_writing_id WHERE id = 13;
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (13, v_cat_writing_id, true) ON CONFLICT DO NOTHING;
    END;

    -- Guide 14: AI 영상 제작 (Guide 14 확인 필요, 제목에 '영상' 포함) -> 콘텐츠 제작
    DECLARE
        v_cat_content_id INTEGER;
    BEGIN
        SELECT id INTO v_cat_content_id FROM public.categories WHERE name = '콘텐츠 제작';
        
        -- ID 14번 매핑
        UPDATE public.guides SET category_id = v_cat_content_id WHERE id = 14;
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (14, v_cat_content_id, true) ON CONFLICT DO NOTHING;
    END;

    -- Guide 15: 프롬프트 엔지니어링 기초 -> 연구 & 학습
    UPDATE public.guides SET category_id = v_cat_study_id WHERE id = 15;
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (15, v_cat_study_id, true) ON CONFLICT DO NOTHING;

    -- Guide 17: AI 개인 맞춤 설정 (15분 만에 끝내는...) -> AI 기초 입문
    UPDATE public.guides SET category_id = v_cat_intro_id WHERE id = 17;
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary) VALUES (17, v_cat_intro_id, true) ON CONFLICT DO NOTHING;

END $$;

COMMIT;
