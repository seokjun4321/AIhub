-- Create preset_templates table
CREATE TABLE IF NOT EXISTS preset_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  one_liner TEXT NOT NULL,
  description TEXT, -- Added for consistency, though not strictly in mockData yet
  category TEXT CHECK (category IN ('Notion', 'Sheets')),
  price INTEGER DEFAULT 0,
  includes TEXT[] DEFAULT '{}',
  tags TEXT[] DEFAULT '{}',
  image_url TEXT,
  preview_images TEXT[] DEFAULT '{}',
  author TEXT,
  preview_url TEXT,
  duplicate_url TEXT,
  setup_steps TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE preset_templates ENABLE ROW LEVEL SECURITY;

-- Policy for reading
CREATE POLICY "Public templates are viewable by everyone" ON preset_templates
  FOR SELECT USING (true);


-- Insert Mock Data

-- 1. Startup OKR Dashboard
INSERT INTO preset_templates (
  title,
  one_liner,
  category,
  price,
  includes,
  image_url,
  preview_images,
  tags,
  author,
  preview_url,
  duplicate_url,
  setup_steps
) VALUES (
  '스타트업 OKR 대시보드',
  '목표 달성을 위한 가장 직관적인 OKR 관리 템플릿.',
  'Notion',
  0,
  ARRAY['대시보드 페이지', 'Objective DB', 'Key Result DB', '미팅 노트 템플릿'],
  'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=500',
  ARRAY[
    'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=1000',
    'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1000'
  ],
  ARRAY['스타트업', '목표관리', '생산성'],
  'NotionMaster',
  'https://notion.so/...', -- Placeholder
  'https://notion.so/...', -- Placeholder
  ARRAY[
    '템플릿을 본인의 워크스페이스로 복제하세요.',
    '팀원들을 초대한 후 각자의 목표를 입력하게 하세요.',
    '주간 미팅 때 진행률 바를 업데이트하세요.'
  ]
);

-- 2. Household Account Book
INSERT INTO preset_templates (
  title,
  one_liner,
  category,
  price,
  includes,
  image_url,
  preview_images,
  tags,
  author,
  preview_url,
  duplicate_url,
  setup_steps
) VALUES (
  '가계부 자동화 시트',
  '카드 내역 복붙하면 끝! 자동으로 분류되는 가계부.',
  'Sheets',
  0,
  ARRAY['수입/지출 시트', '자동 대시보드', '월별 리포트'],
  'https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&q=80&w=500',
  ARRAY[
    'https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&q=80&w=1000'
  ],
  ARRAY['재테크', '가계부', '구글시트'],
  'SheetGenius',
  'https://docs.google.com/...', -- Placeholder
  'https://docs.google.com/...', -- Placeholder
  ARRAY[
    '사본 만들기를 클릭하여 드라이브에 저장하세요.',
    '카드사에서 다운받은 엑셀 내역을 ''입력'' 시트에 붙여넣으세요.',
    '''대시보드'' 탭에서 이번 달 소비 현황을 확인하세요.'
  ]
);
