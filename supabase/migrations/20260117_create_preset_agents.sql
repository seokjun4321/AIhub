-- Create preset_agents table
CREATE TABLE IF NOT EXISTS preset_agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  one_liner TEXT NOT NULL,
  description TEXT NOT NULL,
  platform TEXT NOT NULL CHECK (platform IN ('GPT', 'Claude', 'Gemini', 'Perplexity')),
  author TEXT NOT NULL,
  tags TEXT[] DEFAULT '{}',
  example_questions TEXT[] DEFAULT '{}',
  url TEXT NOT NULL,
  instructions TEXT[] DEFAULT '{}',
  requirements TEXT[] DEFAULT '{}',
  example_conversation JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE preset_agents ENABLE ROW LEVEL SECURITY;

-- Create Policy for Public Read Access
CREATE POLICY "Enable read access for all users" ON preset_agents FOR SELECT USING (true);

-- Insert Mock Data
INSERT INTO preset_agents (title, one_liner, description, platform, author, tags, example_questions, url, instructions, requirements, example_conversation)
VALUES
(
  'Excel 마스터',
  '복잡한 함수도 말 한마디면 뚝딱! 당신의 엑셀 비서.',
  '복잡한 엑셀 함수와 매크로를 쉽게 설명해줍니다. 데이터 분석부터 시각화까지 엑셀과 관련된 모든 궁금증을 해결해드립니다.',
  'GPT',
  'SheetWizard',
  ARRAY['생산성', '오피스', '데이터'],
  ARRAY['VLOOKUP과 XLOOKUP 차이가 뭐예요?', '피벗테이블 만드는 법 알려주세요', '매크로로 자동 합계 구하는 코드 짜줘'],
  'https://chat.openai.com',
  ARRAY['사용자의 엑셀 버전을 먼저 물어보세요.', '가능한 한 단계별로 따라할 수 있게 설명하세요.', '수식은 코드 블록으로 제공하세요.'],
  ARRAY['ChatGPT Plus 구독 필요'],
  '[
    {"role": "user", "content": "A열에 있는 날짜에서 ''월''만 뽑아내고 싶어."},
    {"role": "assistant", "content": "`=MONTH(A1)` 함수를 사용하시면 됩니다! 만약 ''1월''처럼 텍스트로 보고 싶으시다면 `=TEXT(A1, \"m월\")`을 사용해보세요."}
  ]'::jsonb
),
(
  '법률 상담 도우미',
  '일상 속 법률 고민, 쉽고 빠르게 초기 가이드를 받아보세요.',
  '일상적인 법률 질문에 대해 기초 정보를 제공합니다. 임대차 계약, 근로 계약 등 생활 밀착형 법률 정보를 알기 쉽게 풀어서 설명해줍니다.',
  'Claude',
  'LawBot',
  ARRAY['전문지식', '법률', '상담'],
  ARRAY['전세 계약 시 주의할 점은?', '퇴직금 계산 방법이 궁금해요', '내용증명 작성하는 법'],
  'https://claude.ai',
  ARRAY['항상 법적 책임이 없음을 고지하세요.', '최신 판례보다는 일반적인 법리를 설명하세요.', '변호사 상담을 권유하는 문구를 포함하세요.'],
  ARRAY['Claude Pro 권장'],
  '[
    {"role": "user", "content": "전세 보증금을 못 받고 있어요."},
    {"role": "assistant", "content": "매우 난처한 상황이시군요. 우선 임차권등기명령 신청을 고려해보셔야 합니다. 이는 이사를 가더라도 대항력을 유지할 수 있는 제도입니다..."}
  ]'::jsonb
);
