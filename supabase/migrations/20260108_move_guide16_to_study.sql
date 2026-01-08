-- Migration: Move Guide 16 (Prompt Upgrader) to '연구 & 학습' category
-- Date: 2026-01-08

DO $$
DECLARE
    v_guide_id INTEGER := 16;
    v_new_category_id INTEGER;
BEGIN
    -- '연구 & 학습' 카테고리 ID 조회
    SELECT id INTO v_new_category_id FROM public.categories WHERE name = '연구 & 학습' LIMIT 1;
    
    IF v_new_category_id IS NOT NULL THEN
        -- 1. guides 테이블 업데이트
        UPDATE public.guides 
        SET category_id = v_new_category_id 
        WHERE id = v_guide_id;

        -- 2. guide_categories 중간 테이블 업데이트
        -- 기존 매핑 삭제 후 새로 추가 (가장 깔끔함)
        DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;
        
        INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
        VALUES (v_guide_id, v_new_category_id, true);
        
        RAISE NOTICE 'Guide 16 moved to 연구 & 학습';
    ELSE
        RAISE NOTICE 'Category 연구 & 학습 not found';
    END IF;
END $$;
