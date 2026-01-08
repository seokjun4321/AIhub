-- Migration: Refactor Guide Categories System
-- Date: 2026-01-08
-- Purpose: 
--   1. 8개 카테고리 체계 확정
--   2. 다중 카테고리 지원을 위한 중간 테이블 생성
--   3. 기존 가이드들을 새 카테고리 체계에 매핑

-- ============================================================
-- STEP 1: 다중 카테고리 지원을 위한 중간 테이블 생성
-- ============================================================

-- guide_categories 중간 테이블 생성 (Many-to-Many 관계)
CREATE TABLE IF NOT EXISTS public.guide_categories (
    id SERIAL PRIMARY KEY,
    guide_id INTEGER NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES public.categories(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE, -- 주 카테고리 여부
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, category_id) -- 같은 가이드-카테고리 조합 중복 방지
);

-- 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_guide_categories_guide_id ON public.guide_categories(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_categories_category_id ON public.guide_categories(category_id);
CREATE INDEX IF NOT EXISTS idx_guide_categories_primary ON public.guide_categories(is_primary) WHERE is_primary = TRUE;

-- RLS 활성화
ALTER TABLE public.guide_categories ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 모든 사용자가 읽기 가능
CREATE POLICY "Guide categories are viewable by everyone" 
    ON public.guide_categories 
    FOR SELECT 
    USING (true);

-- RLS 정책: 가이드 작성자만 수정 가능
CREATE POLICY "Authors can manage guide categories" 
    ON public.guide_categories 
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM public.guides 
            WHERE guides.id = guide_categories.guide_id 
            AND guides.author_id = auth.uid()
        )
    );

-- ============================================================
-- STEP 2: 8개 카테고리 확정 및 삽입
-- ============================================================

-- 기존 categories 테이블 데이터 정리 및 8개 카테고리 확정
-- 중복 방지를 위해 ON CONFLICT 사용

INSERT INTO public.categories (name, description)
VALUES 
    ('AI 기초 입문', 'AI 활용의 첫걸음을 떼는 입문자를 위한 가이드. ChatGPT, Claude 등 AI 툴 시작하기'),
    ('콘텐츠 제작', 'AI로 영상, 이미지, 블로그, 소셜미디어 콘텐츠 만들기'),
    ('개발 & 코딩', '코드 작성, 디버깅, 기술 개념 설명, 프로그래밍 학습'),
    ('글쓰기 & 교정', '에세이, 리포트, 성찰문, 발표 스크립트를 AI로 작성 및 개선'),
    ('취업 준비', '이력서, 자기소개서, 포트폴리오, 면접 준비 가이드'),
    ('연구 & 학습', '개념 이해, 노트 정리, 연습 문제 생성, 학습 효율화'),
    ('업무 자동화', 'n8n, Zapier 등을 활용한 워크플로우 자동화'),
    ('창업 & 비즈니스', '사업 계획, 시장 분석, 피칭 자료, 스타트업 운영')
ON CONFLICT (name) DO UPDATE SET
    description = EXCLUDED.description;

-- ============================================================
-- STEP 3: 기존 가이드들을 새 카테고리 체계에 매핑
-- ============================================================

-- 기존 guides 테이블의 category_id 데이터를 guide_categories 중간 테이블로 마이그레이션
-- 1) 먼저 기존 category_id가 있는 가이드들을 guide_categories에 복사

DO $$
DECLARE
    guide_record RECORD;
BEGIN
    -- 기존 guides의 category_id를 guide_categories로 복사
    FOR guide_record IN 
        SELECT id, category_id 
        FROM public.guides 
        WHERE category_id IS NOT NULL
    LOOP
        -- 중복 방지를 위해 이미 존재하는지 확인 후 삽입
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
        VALUES (guide_record.id, guide_record.category_id, TRUE)
        ON CONFLICT (guide_id, category_id) DO NOTHING;
    END LOOP;
END $$;

-- ============================================================
-- STEP 4: 특정 가이드의 카테고리 명시적으로 설정
-- ============================================================

-- Guide 2: ChatGPT 완전 처음 시작하기 → AI 기초 입문
DO $$
DECLARE
    v_guide_id INTEGER := 2;
    v_category_id INTEGER;
BEGIN
    SELECT id INTO v_category_id FROM public.categories WHERE name = 'AI 기초 입문' LIMIT 1;
    
    IF v_category_id IS NOT NULL AND EXISTS (SELECT 1 FROM public.guides WHERE id = v_guide_id) THEN
        -- 기존 매핑 삭제 후 재설정
        DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;
        
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
        VALUES (v_guide_id, v_category_id, TRUE)
        ON CONFLICT (guide_id, category_id) DO UPDATE SET is_primary = TRUE;
        
        -- guides 테이블의 category_id도 업데이트
        UPDATE public.guides SET category_id = v_category_id WHERE id = v_guide_id;
    END IF;
END $$;

-- Prompt Upgrader 가이드 → AI 기초 입문 (가이드 ID는 실제 DB 확인 필요)
DO $$
DECLARE
    v_guide_id INTEGER;
    v_category_id INTEGER;
BEGIN
    -- 'Prompt Upgrader'로 시작하는 가이드 찾기
    SELECT id INTO v_guide_id FROM public.guides WHERE title ILIKE '%Prompt Upgrader%' LIMIT 1;
    SELECT id INTO v_category_id FROM public.categories WHERE name = 'AI 기초 입문' LIMIT 1;
    
    IF v_guide_id IS NOT NULL AND v_category_id IS NOT NULL THEN
        DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;
        
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
        VALUES (v_guide_id, v_category_id, TRUE)
        ON CONFLICT (guide_id, category_id) DO UPDATE SET is_primary = TRUE;
        
        UPDATE public.guides SET category_id = v_category_id WHERE id = v_guide_id;
    END IF;
END $$;

-- AI Personalization 가이드 → AI 기초 입문
DO $$
DECLARE
    v_guide_id INTEGER;
    v_category_id INTEGER;
BEGIN
    SELECT id INTO v_guide_id FROM public.guides WHERE title ILIKE '%AI%개인화%' OR title ILIKE '%AI%personalization%' LIMIT 1;
    SELECT id INTO v_category_id FROM public.categories WHERE name = 'AI 기초 입문' LIMIT 1;
    
    IF v_guide_id IS NOT NULL AND v_category_id IS NOT NULL THEN
        DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;
        
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
        VALUES (v_guide_id, v_category_id, TRUE)
        ON CONFLICT (guide_id, category_id) DO UPDATE SET is_primary = TRUE;
        
        UPDATE public.guides SET category_id = v_category_id WHERE id = v_guide_id;
    END IF;
END $$;

-- ============================================================
-- STEP 5: 헬퍼 함수 생성 (선택사항)
-- ============================================================

-- 가이드에 여러 카테고리를 쉽게 추가하는 함수
CREATE OR REPLACE FUNCTION add_guide_to_category(
    p_guide_id INTEGER,
    p_category_name TEXT,
    p_is_primary BOOLEAN DEFAULT FALSE
)
RETURNS VOID AS $$
DECLARE
    v_category_id INTEGER;
BEGIN
    -- 카테고리 ID 조회
    SELECT id INTO v_category_id 
    FROM public.categories 
    WHERE name = p_category_name 
    LIMIT 1;
    
    IF v_category_id IS NULL THEN
        RAISE EXCEPTION 'Category not found: %', p_category_name;
    END IF;
    
    -- guide_categories에 삽입
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    VALUES (p_guide_id, v_category_id, p_is_primary)
    ON CONFLICT (guide_id, category_id) 
    DO UPDATE SET is_primary = EXCLUDED.is_primary;
    
    -- 주 카테고리인 경우 guides 테이블도 업데이트
    IF p_is_primary THEN
        UPDATE public.guides 
        SET category_id = v_category_id 
        WHERE id = p_guide_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- STEP 6: 데이터 검증 쿼리 (마이그레이션 후 확인용)
-- ============================================================

-- 다음 쿼리들을 SQL Editor에서 실행하여 결과 확인:

-- 1. 모든 카테고리 목록 확인
-- SELECT id, name, description FROM public.categories ORDER BY name;

-- 2. 각 카테고리별 가이드 개수 확인
-- SELECT 
--     c.name AS category_name,
--     COUNT(DISTINCT gc.guide_id) AS guide_count
-- FROM public.categories c
-- LEFT JOIN public.guide_categories gc ON c.id = gc.category_id
-- GROUP BY c.id, c.name
-- ORDER BY guide_count DESC, c.name;

-- 3. 각 가이드의 카테고리 매핑 확인
-- SELECT 
--     g.id,
--     g.title,
--     c.name AS category_name,
--     gc.is_primary
-- FROM public.guides g
-- LEFT JOIN public.guide_categories gc ON g.id = gc.guide_id
-- LEFT JOIN public.categories c ON gc.category_id = c.id
-- ORDER BY g.id, gc.is_primary DESC;

-- 4. 여러 카테고리에 속한 가이드 확인
-- SELECT 
--     g.id,
--     g.title,
--     COUNT(gc.category_id) AS category_count,
--     STRING_AGG(c.name, ', ' ORDER BY gc.is_primary DESC, c.name) AS categories
-- FROM public.guides g
-- LEFT JOIN public.guide_categories gc ON g.id = gc.guide_id
-- LEFT JOIN public.categories c ON gc.category_id = c.id
-- GROUP BY g.id, g.title
-- HAVING COUNT(gc.category_id) > 1
-- ORDER BY category_count DESC;

-- ============================================================
-- 완료!
-- ============================================================
-- 이제 다음을 확인하세요:
-- 1. categories 테이블에 8개 카테고리가 올바르게 들어갔는지
-- 2. guide_categories 중간 테이블에 기존 매핑이 복사되었는지
-- 3. 특정 가이드(ChatGPT, Prompt Upgrader 등)가 올바른 카테고리에 매핑되었는지
--
-- 사용 예시:
-- SELECT add_guide_to_category(2, '연구 & 학습', FALSE); -- Guide 2를 "연구 & 학습"에도 추가
