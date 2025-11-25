-- 1. AI 모델 테이블 수정 (Trending Tools용)
ALTER TABLE ai_models ADD COLUMN IF NOT EXISTS growth_rate integer DEFAULT 0;

-- 2. 가이드 테이블 수정 (Guidebook용)
ALTER TABLE guides ADD COLUMN IF NOT EXISTS level text DEFAULT '초급';
ALTER TABLE guides ADD COLUMN IF NOT EXISTS view_count integer DEFAULT 0;
ALTER TABLE guides ADD COLUMN IF NOT EXISTS key_points text[] DEFAULT '{}';

-- 3. 프리셋 테이블 생성 (Preset Store용)
CREATE TABLE IF NOT EXISTS presets (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  title text NOT NULL,
  description text,
  price integer DEFAULT 0,
  image_url text,
  category text,
  tags text[],
  rating numeric DEFAULT 0,
  review_count integer DEFAULT 0,
  author_id uuid REFERENCES profiles(id),
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 4. 프로필 테이블 수정 (Creator Grid용)
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_creator boolean DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS sales_count integer DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS creator_rating numeric DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS creator_tags text[] DEFAULT '{}';
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS representative_product text;

-- 5. 샘플 데이터 삽입

-- AI 모델이 하나도 없을 경우 기본 모델 추가 (guides의 외래키 제약조건 만족을 위해)
INSERT INTO ai_models (name, description, average_rating, rating_count)
SELECT 'ChatGPT', 'OpenAI의 대화형 AI 모델', 4.8, 1250
WHERE NOT EXISTS (SELECT 1 FROM ai_models);

-- AI 모델 샘플 데이터 업데이트 (성장률)
UPDATE ai_models SET growth_rate = 245 WHERE name = 'ChatGPT';
UPDATE ai_models SET growth_rate = 180 WHERE name = 'Midjourney';
UPDATE ai_models SET growth_rate = 120 WHERE name = 'Notion AI';

-- 가이드 샘플 데이터 (ai_model_id 추가됨)
INSERT INTO guides (title, description, level, view_count, key_points, image_url, category_id, author_id, ai_model_id)
SELECT 
  '프롬프트 엔지니어링 기초', 
  'AI와 효과적으로 대화하는 핵심 기법을 5분 만에 배워보세요.', 
  '초급', 
  1250, 
  ARRAY['명확한 지시어 사용', '맥락 제공하기', '예시 활용하기'], 
  'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=800&q=80',
  (SELECT id FROM categories LIMIT 1),
  (SELECT id FROM profiles LIMIT 1),
  (SELECT id FROM ai_models LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM guides WHERE title = '프롬프트 엔지니어링 기초');

-- 프리셋 샘플 데이터
INSERT INTO presets (title, description, price, category, tags, rating, review_count, author_id, image_url)
SELECT
  '사업계획서 자동 생성 프롬프트 세트',
  '스타트업 IR 자료 작성을 위한 단계별 프롬프트 모음입니다.',
  29000,
  '비즈니스',
  ARRAY['프롬프트', '비즈니스'],
  4.8,
  124,
  (SELECT id FROM profiles LIMIT 1),
  'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80'
WHERE NOT EXISTS (SELECT 1 FROM presets WHERE title = '사업계획서 자동 생성 프롬프트 세트');

INSERT INTO presets (title, description, price, category, tags, rating, review_count, author_id, image_url)
SELECT
  'Midjourney 캐릭터 프롬프트 팩',
  '일관된 스타일의 캐릭터를 생성하는 미드저니 프롬프트입니다.',
  35000,
  '크리에이티브',
  ARRAY['디자인', 'Midjourney'],
  4.9,
  312,
  (SELECT id FROM profiles LIMIT 1),
  'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&q=80'
WHERE NOT EXISTS (SELECT 1 FROM presets WHERE title = 'Midjourney 캐릭터 프롬프트 팩');

-- 크리에이터 프로필 샘플 데이터 업데이트
UPDATE profiles 
SET 
  is_creator = true,
  sales_count = 1250,
  creator_rating = 4.9,
  creator_tags = ARRAY['프롬프트', '자동화'],
  representative_product = '사업계획서 자동 생성 프롬프트 세트'
WHERE id = (SELECT id FROM profiles LIMIT 1);
