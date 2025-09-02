-- 프롬프트 공유 카테고리 추가
INSERT INTO post_categories (name, color, icon, description, created_at, updated_at)
VALUES (
  '프롬프트 공유',
  '#8B5CF6', -- 보라색
  '💡',
  '효과적인 AI 프롬프트 템플릿과 활용법을 공유하는 카테고리입니다.',
  NOW(),
  NOW()
);

-- 카테고리 순서 업데이트 (중요도 순으로 재정렬)
-- 기존 카테고리들의 순서를 조정하여 프롬프트 공유가 적절한 위치에 오도록 함
UPDATE post_categories 
SET updated_at = NOW()
WHERE name IN ('질문', '정보공유', '프롬프트 공유', '토론', '리뷰', '뉴스', '프로젝트', '유머', '기타');
