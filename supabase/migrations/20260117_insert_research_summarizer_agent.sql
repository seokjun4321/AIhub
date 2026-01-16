-- Insert Research Paper Summarizer Agent with Bilingual Support
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
  'Research Paper Summarizer',
  '복잡한 논문을 핵심 요약, 방법론, 결과로 구조화하여 분석',
  '읽어야 할 논문이 많을 때 시간을 절약해줍니다. 논문 텍스트를 입력하면 연구 목적, 사용된 방법론, 주요 결과, 그리고 한계점까지 일목요연하게 정리해줍니다.',
  'Saves time when you have many papers to read. Input the paper text, and it structures the analysis into research objectives, methodology, key findings, and limitations.',
  'Claude',
  'Anthropic Prompt Library (Academic Researcher)',
  ARRAY['논문요약', '대학원생', '리서치', '과제', '빠른독해'],
  ARRAY['이 논문의 핵심 결론이 뭐야?', '연구 방법론을 간단히 요약해줘.', '이 연구의 한계점은 무엇인가?'],
  '#',
  ARRAY[
    '다음 연구 논문 텍스트를 요약해 주세요.',
    '요약은 아래 섹션 구조를 따라 작성하세요:',
    '1. **제목 및 저자:**',
    '2. **연구 질문/문제:** 이 논문이 해결하려는 문제는 무엇인가?',
    '3. **방법론:** 연구가 어떻게 수행되었는지 간략히 설명.',
    '4. **주요 발견:** 가장 중요한 결과를 불릿 포인트로 정리.',
    '5. **결론 및 시사점:** 이 연구가 해당 분야에 의미하는 바.',
    '6. **비판:** 텍스트에 언급된 한계점이나 잠재적 편향을 식별.',
    '텍스트:',
    '[PASTE PAPER TEXT HERE]'
  ],
  ARRAY[
    'Please summarize the following research paper text.',
    'Structure the summary into the following sections:',
    '1. **Title & Authors:**',
    '2. **Research Question/Problem:** What is the paper trying to solve?',
    '3. **Methodology:** Briefly explain how the study was conducted.',
    '4. **Key Findings:** Bullet points of the most important results.',
    '5. **Conclusion & Implications:** What does this mean for the field?',
    '6. **Critique:** Identify any limitations or potential biases mentioned in the text.',
    'Text:',
    '[PASTE PAPER TEXT HERE]'
  ],
  ARRAY['논문 텍스트 전체 혹은 초록(Abstract) 복사 후 붙여넣기'],
  '[
    {"role": "user", "content": "텍스트: (논문 내용 붙여넣기...)"},
    {"role": "assistant", "content": "1. **제목 및 저자:** Attention Is All You Need (Vaswani et al.)\n\n2. **연구 질문/문제:** 기존의 RNN/CNN 기반 시퀀스 모델의 병렬 처리 한계와 긴 학습 시간을 해결하고자 함.\n\n3. **방법론:** 재귀(Recurrence)를 완전히 배제하고 Attention 메커니즘만으로 구성된 Transformer 아키텍처 제안..."}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Text: (Paste paper content...)"},
    {"role": "assistant", "content": "1. **Title & Authors:** Attention Is All You Need (Vaswani et al.)\n\n2. **Research Question/Problem:** Addressing the limitations of parallelization and training time in existing RNN/CNN sequence models.\n\n3. **Methodology:** Proposing the Transformer architecture, based solely on attention mechanisms, discarding recurrence..."}
  ]'::jsonb
);
