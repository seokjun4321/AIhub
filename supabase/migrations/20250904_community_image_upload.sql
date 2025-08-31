-- 게시글 이미지 업로드 기능을 위한 마이그레이션

-- posts 테이블에 이미지 관련 컬럼 추가
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS images TEXT[] DEFAULT '{}';

-- 댓글에도 이미지 업로드 기능 추가
ALTER TABLE public.comments 
ADD COLUMN IF NOT EXISTS images TEXT[] DEFAULT '{}';

-- 카테고리 순서 개선 (중요도 순으로 재정렬)
UPDATE public.post_categories SET 
  name = CASE 
    WHEN name = '질문' THEN '질문'
    WHEN name = '정보공유' THEN '정보공유'
    WHEN name = '토론' THEN '토론'
    WHEN name = '리뷰' THEN '리뷰'
    WHEN name = '뉴스' THEN '뉴스'
    WHEN name = '프로젝트' THEN '프로젝트'
    WHEN name = '유머' THEN '유머'
    WHEN name = '기타' THEN '기타'
  END,
  color = CASE 
    WHEN name = '질문' THEN '#10B981'
    WHEN name = '정보공유' THEN '#3B82F6'
    WHEN name = '토론' THEN '#8B5CF6'
    WHEN name = '리뷰' THEN '#EF4444'
    WHEN name = '뉴스' THEN '#06B6D4'
    WHEN name = '프로젝트' THEN '#EC4899'
    WHEN name = '유머' THEN '#F59E0B'
    WHEN name = '기타' THEN '#6B7280'
  END;

-- 이미지 업로드를 위한 스토리지 버킷 생성 (RPC 호출)
-- 실제 스토리지 버킷은 Supabase 대시보드에서 생성해야 합니다
-- 여기서는 참고용으로 주석 처리

-- 이미지 URL 검증을 위한 함수
CREATE OR REPLACE FUNCTION public.validate_image_url(url TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  -- 기본적인 URL 형식 검증
  RETURN url ~ '^https?://.*\.(jpg|jpeg|png|gif|webp)(\?.*)?$';
END;
$$ LANGUAGE plpgsql;

-- 이미지 배열 검증을 위한 함수
CREATE OR REPLACE FUNCTION public.validate_images_array(images TEXT[])
RETURNS BOOLEAN AS $$
DECLARE
  img TEXT;
BEGIN
  IF images IS NULL OR array_length(images, 1) IS NULL THEN
    RETURN TRUE;
  END IF;
  
  FOREACH img IN ARRAY images
  LOOP
    IF NOT public.validate_image_url(img) THEN
      RETURN FALSE;
    END IF;
  END LOOP;
  
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- 게시글 이미지 검증을 위한 체크 제약조건
ALTER TABLE public.posts 
ADD CONSTRAINT check_valid_images 
CHECK (public.validate_images_array(images));

-- 댓글 이미지 검증을 위한 체크 제약조건
ALTER TABLE public.comments 
ADD CONSTRAINT check_valid_comment_images 
CHECK (public.validate_images_array(images));
