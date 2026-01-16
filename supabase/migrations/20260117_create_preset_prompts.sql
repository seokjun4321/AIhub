-- Create preset_prompts table
create table if not exists preset_prompts (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  one_liner text,
  description text,
  badges jsonb, -- Array of {text, color}
  difficulty text check (difficulty in ('Beginner', 'Intermediate', 'Advanced')),
  tags text[],
  author text,
  created_at timestamptz default now(),
  compatible_tools text[],
  prompt text,
  prompt_en text,
  variables jsonb, -- Array of {name, placeholder, example}
  example_io jsonb, -- {input, output}
  tips text[]
);

-- Enable Row Level Security
alter table preset_prompts enable row level security;

-- Create policy for public read access
create policy "Allow public read access" on preset_prompts
  for select using (true);

-- Insert initial mock data
insert into preset_prompts (
  title, 
  one_liner, 
  description, 
  badges, 
  difficulty, 
  tags, 
  author, 
  created_at, 
  compatible_tools, 
  prompt, 
  prompt_en, 
  variables, 
  example_io, 
  tips
) values 
(
  '블로그 포스트 생성기',
  '키워드만 넣으면 SEO 최적화된 블로그 글이 완성됩니다.',
  'SEO 최적화된 블로그 글을 자동으로 작성합니다. 제목, 소제목, 본문 구성을 논리적으로 구조화하여 가독성 높은 글을 만들어줍니다.',
  '[{"text": "초급", "color": "green"}]'::jsonb,
  'Beginner',
  ARRAY['콘텐츠', '블로그', 'SEO'],
  '김작가',
  '2024-01-15 00:00:00+00',
  ARRAY['ChatGPT', 'Claude'],
  '당신은 전문 블로그 작가입니다. 다음 주제에 대해 SEO에 최적화된 블로그 포스트를 작성해주세요.\n\n주제: {topic}\n타겟 독자: {target_audience}\n키워드: {keywords}\n\n글의 구조:\n1. 독자의 흥미를 끄는 도입부\n2. 3~4개의 소제목을 포함한 본문\n3. 결론 및 행동 유도(CTA)\n\n톤앤매너: {tone}',
  'You are a professional blog writer. Please write an SEO-optimized blog post on the following topic.\n\nTopic: {topic}\nTarget Audience: {target_audience}\nKeywords: {keywords}\n\nStructure:\n1. Introduction that hooks the reader\n2. Body with 3-4 subheadings\n3. Conclusion and Call to Action (CTA)\n\nTone & Manner: {tone}',
  '[
    {"name": "topic", "placeholder": "예: 재택근무의 장단점", "example": "재택근무의 효율성을 높이는 방법"},
    {"name": "target_audience", "placeholder": "예: 직장인", "example": "30대 직장인"},
    {"name": "keywords", "placeholder": "예: 재택근무, 생산성", "example": "재택근무, 시간관리, 생산성 도구"},
    {"name": "tone", "placeholder": "예: 친근한, 전문적인", "example": "전문적이면서도 이해하기 쉬운"}
  ]'::jsonb,
  '{"input": "주제: 재택근무\\n타겟: 직장인", "output": "# 재택근무, 더 똑똑하게 하는 법\\n\\n안녕하세요! 재택근무가 일상이 된 요즘..."}'::jsonb,
  ARRAY['구체적인 타겟 독자를 설정하면 더 공감 가는 글이 나옵니다.', '키워드는 3개 이상 입력하는 것이 좋습니다.', '톤앤매너를 브랜드 보이스에 맞춰 조정하세요.']
),
(
  '이메일 답장 도우미',
  '무례하지 않으면서 단호한 거절, 비즈니스 이메일의 정석.',
  '상황에 맞는 프로페셔널한 이메일 답장을 생성합니다. 정중한 거절, 일정 조율, 감사 인사 등 다양한 상황에 대응할 수 있습니다.',
  '[{"text": "초급", "color": "green"}]'::jsonb,
  'Beginner',
  ARRAY['비즈니스', '이메일', '커뮤니케이션'],
  '박대리',
  '2024-01-14 00:00:00+00',
  ARRAY['ChatGPT', 'Gemini'],
  '받은 이메일 내용에 대해 {attitude} 태도로 답장을 작성해주세요.\n\n받은 이메일:\n{email_content}\n\n답장 포인트:\n{key_points}',
  'Please draft a reply to the received email with a {attitude} attitude.\n\nReceived Email:\n{email_content}\n\nReply Points:\n{key_points}',
  '[
    {"name": "attitude", "placeholder": "예: 정중한, 친근한", "example": "정중하고 비즈니스적인"},
    {"name": "email_content", "placeholder": "받은 메일 붙여넣기", "example": "프로젝트 마감 기한 연장 요청 메일..."},
    {"name": "key_points", "placeholder": "답장에 포함할 핵심 내용", "example": "1일 연장 가능, 그 이상은 불가능함"}
  ]'::jsonb,
  '{"input": "요청: 마감 연장\\n태도: 정중함", "output": "안녕하세요, 000님.\\n\\n요청주신 마감 기한 연장에 대해 내부적으로 논의해보았습니다..."}'::jsonb,
  ARRAY['받은 이메일의 전체 내용을 넣으면 문맥 파악이 더 정확해집니다.', '거절 메일의 경우 대안을 제시하는 포인트를 추가해보세요.']
);
