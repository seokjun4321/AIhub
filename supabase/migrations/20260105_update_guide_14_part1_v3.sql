-- Guide 14 Update Part 1 (v3 FINAL): Schema Fixes & Metadata
-- Fixed 'section_order' null error and missing columns.

-- 1. Schema Fixes (Guides Table)
-- Ensure columns exist and have correct types
ALTER TABLE guides ALTER COLUMN estimated_time TYPE TEXT USING estimated_time::text;
ALTER TABLE guides ADD COLUMN IF NOT EXISTS difficulty TEXT;
ALTER TABLE guides ADD COLUMN IF NOT EXISTS one_line_summary TEXT;
ALTER TABLE guides ADD COLUMN IF NOT EXISTS tags TEXT[];

-- 2. Schema Fixes (Guide Steps Table)
-- Ensure columns exist for structured step content
ALTER TABLE guide_steps ADD COLUMN IF NOT EXISTS goal TEXT;
ALTER TABLE guide_steps ADD COLUMN IF NOT EXISTS done_when TEXT;
ALTER TABLE guide_steps ADD COLUMN IF NOT EXISTS why_matters TEXT;
ALTER TABLE guide_steps ADD COLUMN IF NOT EXISTS tips TEXT;
ALTER TABLE guide_steps ADD COLUMN IF NOT EXISTS checklist TEXT;

-- 3. Metadata Update
UPDATE guides
SET 
  title = 'ChatGPT 프롬프트 엔지니어링으로 AI 영상 제작하기',
  description = 'ChatGPT로 프롬프트를 설계하고 무료 AI 도구에서 실행해 영화 같은 영상을 만드는 완전 실전 가이드입니다. 복잡한 편집 스킬 없이도 하루 만에 첫 AI 영상을 완성할 수 있습니다.',
  one_line_summary = 'ChatGPT로 영상 프롬프트를 설계하고, 무료 AI 도구(Kling, Hailuo, Pika)에 붙여넣어, 당신의 아이디어를 영화 같은 영상으로 만드는 실전 가이드',
  estimated_time = '2~3시간',
  difficulty = '초급~중급',
  tags = ARRAY['AI 콘텐츠 제작', '프롬프트 엔지니어링', 'AI 영상 생성', '무료 AI 도구', 'ChatGPT 활용', 'Text-to-Video', '콘텐츠 크리에이터', '초보자 친화', '실전 워크플로우']
WHERE id = 14;

-- 4. Sections Update (Recommendations, etc.)
-- Now including 'section_order' to avoid NOT NULL violation
DELETE FROM guide_sections WHERE guide_id = 14;

INSERT INTO guide_sections (guide_id, section_type, section_order, title, data) VALUES
(14, 'target_audience', 1, '이런 분께 추천', '["ChatGPT는 써봤는데 AI 영상은 처음인 대학생·직장인", "영상 편집 없이 콘텐츠를 빠르게 만들고 싶은 크리에이터", "무료 도구로 매일 연습하며 실력을 쌓고 싶은 분", "스타트업이나 마케팅에서 빠른 영상 프로토타입이 필요한 분", "AI 트렌드에 맞춰 새로운 창작 스킬을 익히고 싶은 분"]'::jsonb),
(14, 'requirements', 2, '준비물', '["ChatGPT 계정 (무료 버전도 OK, GPT-4 권장)", "Kling AI 계정 (무료 일일 크레딧 제공)", "Hailuo AI 계정 (무료, 가입 간편)", "인터넷 브라우저 (Chrome, Edge 등)", "만들고 싶은 영상 아이디어 1개 이상"]'::jsonb),
(14, 'core_principles', 3, '핵심 사용 원칙', '["프롬프트는 간결하게, 구조는 명확하게: 핵심 5요소만 담기", "한 번에 완벽 추구 금지: 8~12개 변형 생성 후 최고 선택", "매일 연습, 무료 크레딧 활용: Kling 일일 무료 크레딧으로 실력 쌓기", "ChatGPT는 보조 엔진: 프롬프트 생성·개선·변형에 적극 활용", "외부 도구 조합: AI 도구 → 업스케일러 → 편집 순서로 품질 끌어올리기"]'::jsonb);
