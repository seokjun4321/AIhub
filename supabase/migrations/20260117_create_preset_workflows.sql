-- Create preset_workflows table (Korean only)
CREATE TABLE IF NOT EXISTS preset_workflows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  one_liner TEXT NOT NULL,
  description TEXT NOT NULL,
  complexity TEXT CHECK (complexity IN ('Simple', 'Medium', 'Complex')),
  duration TEXT NOT NULL,
  apps JSONB DEFAULT '[]'::jsonb, -- Array of { name: string }
  author TEXT,
  diagram_url TEXT,
  download_url TEXT, -- Added for file download button
  steps JSONB DEFAULT '[]'::jsonb, -- Array of { title: string, description: string }
  requirements TEXT[] DEFAULT '{}',
  credentials TEXT[] DEFAULT '{}',
  warnings TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE preset_workflows ENABLE ROW LEVEL SECURITY;

-- Policy for reading
CREATE POLICY "Public workflows are viewable by everyone" ON preset_workflows
  FOR SELECT USING (true);


-- Insert Mock Data (Korean Only)

-- 1. Blog Auto-Publishing (블로그 자동 발행)
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '블로그 자동 발행 시스템',
  'Notion에 글만 쓰세요. 발행은 자동으로 됩니다.',
  'Notion에서 글 작성 → 자동으로 WordPress 블로그에 포스팅됩니다. 이미지 업로드와 태그 설정까지 한 번에 처리하세요.',
  'Medium',
  '약 30분',
  '[{"name": "Notion"}, {"name": "Make"}, {"name": "WordPress"}]'::jsonb,
  'AutomationPro',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1000',
  '#', -- Placeholder download URL
  '[
    {"title": "Notion 데이터베이스 설정", "description": "''발행 상태'' 속성을 가진 데이터베이스를 준비합니다."},
    {"title": "Make 시나리오 생성", "description": "Notion ''Watch Database items'' 모듈을 연결합니다."},
    {"title": "WordPress 연결", "description": "Create a Post 모듈을 연결하여 제목과 본문을 매핑합니다."},
    {"title": "테스트 및 활성화", "description": "글을 작성하고 ''Ready'' 상태로 변경하여 테스트합니다."}
  ]'::jsonb,
  ARRAY['Notion API Key', 'WordPress Admin 계정'],
  ARRAY['Make.com 계정']
);

-- 2. Email Auto-Classification (이메일 자동 분류)
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '이메일 자동 분류 및 알림',
  '중요한 메일만 슬랙으로 받아보세요.',
  '중요 이메일을 자동으로 분류하고 슬랙으로 전송합니다. 송신자, 제목 키워드를 기반으로 필터링하여 업무 집중도를 높여줍니다.',
  'Simple',
  '약 15분',
  '[{"name": "Gmail"}, {"name": "Zapier"}, {"name": "Slack"}]'::jsonb,
  'ProductivityGuru',
  'https://images.unsplash.com/photo-1512758017271-d7b84c2113f1?auto=format&fit=crop&q=80&w=1000',
  '#', -- Placeholder download URL
  '[
    {"title": "Gmail 필터 설정", "description": "중요한 메일의 조건을 설정합니다."},
    {"title": "Zapier 트리거", "description": "New Email Matching Search 트리거를 사용합니다."},
    {"title": "Slack 메시지 포맷팅", "description": "보낸 사람과 제목, 요약을 슬랙 채널로 보냅니다."}
  ]'::jsonb,
  ARRAY['Gmail 계정'],
  ARRAY['Zapier Free Plan 이상', 'Slack 워크스페이스']
);
