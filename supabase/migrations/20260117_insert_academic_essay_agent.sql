-- Insert Academic Essay Polisher Agent with Bilingual Support
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Academic Essay Polisher',
  '에세이의 논리적 흐름을 개선하고 학문적 어조로 다듬어주는 편집자',
  '작성한 초안을 붙여넣으면 문법 교정뿐만 아니라, 논리적 비약이나 어색한 문장을 지적하고 더 학술적인 표현(Academic Tone)으로 개선 제안을 해주는 프롬프트입니다. 단순 교정보다 ''글쓰기 실력 향상''에 초점을 둡니다.',
  'An editor that improves logical flow and refines the tone of your essay to be more academic.',
  'GPT',
  'GitHub (f/awesome-chatgpt-prompts 변형)',
  ARRAY['대학생', '에세이', '논문작성', '영어글쓰기', '교정'],
  ARRAY['내 에세이 초안을 학술적인 어조로 교정해줘.', '문법 오류와 어색한 표현을 지적해줘.', '논리적 흐름을 개선할 방법을 알려줘.'],
  '#',
  ARRAY[
    '당신은 학술 편집자 역할을 수행해 주세요. 저는 에세이 또는 논문의 초안을 제공할 것입니다. 당신의 목표는 글의 명확성, 일관성, 그리고 학문적 어조를 개선하는 것입니다.',
    '다음 단계를 따라 주세요:',
    '1. 모든 문법 및 문장부호 오류를 수정합니다.',
    '2. 구어체를 피하고 더 공식적이고 학술적인 어휘로 개선할 수 있는 제안을 합니다.',
    '3. 논리적 흐름이 부족한 문장이나 단락을 식별하고, 적절한 전환을 제안합니다.',
    '4. 에세이를 처음부터 다시 쓰지 마세요. 대신, 단락별로 수정된 버전을 제공하고 마지막에 변경 사항을 설명한 목록을 포함하세요.',
    '여기 제 초안이 있습니다:',
    '[PASTE YOUR DRAFT HERE]'
  ],
  ARRAY[
    'I want you to act as an academic editor. I will provide you with a draft of my essay or paper. Your goal is to improve the clarity, coherence, and academic tone of the writing.',
    'Please follow these steps:',
    '1. Correct any grammatical and punctuation errors.',
    '2. Suggest vocabulary improvements to make the text sound more formal and academic (avoiding colloquialisms).',
    '3. Identify sentences or paragraphs that lack logical flow and suggest transitions.',
    '4. Do NOT rewrite the entire essay from scratch; instead, provide the revised version paragraph by paragraph with a list of changes explained at the end.',
    'Here is my draft:',
    '[PASTE YOUR DRAFT HERE]'
  ],
  ARRAY['텍스트 복사 후 ChatGPT/Claude에 붙여넣어 사용'],
  '[
    {"role": "user", "content": "여기 제 초안이 있습니다: ... (내용) ..."},
    {"role": "assistant", "content": "명확성과 어조를 개선한 수정본입니다:\n\n[수정된 단락 1]\n...\n\n변경 사항 목록:\n- 격식 있는 표현을 위해 ''get''을 ''acquire''로 변경했습니다.\n- 흐름을 자연스럽게 하기 위해 접속사 ''However''를 추가했습니다."}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Here is my draft: ... (content) ..."},
    {"role": "assistant", "content": "Here is the revised version with improvements in clarity and tone:\n\n[Revised Paragraph 1]\n...\n\nList of Changes:\n- Replaced ''get'' with ''acquire'' for more formal tone.\n- Added transition ''However'' to improve flow."}
  ]'::jsonb
);
