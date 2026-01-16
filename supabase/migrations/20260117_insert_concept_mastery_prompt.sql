-- Insert Concept Mastery Architect Prompt Template
INSERT INTO preset_prompt_templates (
  title,
  difficulty,
  one_liner,
  description,
  tags,
  badges,
  author,
  compatible_tools,
  prompt,
  prompt_en,
  variables,
  example_io,
  tips
) VALUES (
  '심화 개념 학습 아키텍트 (4-Step Mastery Framework)',
  'Intermediate',
  '어려운 개념을 ''문제→해결책→구현→연습'' 4단계로 분해해 실전 적용까지 완성',
  '개념이 해결하는 실제 문제부터 시작해, 그 개념이 왜 필요한지 이해하고, 3단계 구현 방법을 배우며, 난이도별 연습문제(하/중/상)를 풀면서 완전히 체득하는 구조입니다. 각 단계마다 실무 사례와 체크리스트 포함.',
  ARRAY['개념학습', '문제해결', '실전적용', '4단계학습', '연습문제'],
  '[{"text": "중급", "color": "blue"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'문제 해결 관점(problem-solving lens)으로 {주제}를 나에게 교육해줘. 각 핵심 개념마다 아래 내용을 제공해줘:\n\n1. 현실적인 문제 또는 도전 과제\n    - 이 개념이 필요한 실제 상황을 설명\n    - 전통적인 접근이 왜 실패하는지 설명\n\n2. 이 개념이 해결책이 되는 방식 설명\n    - 핵심 원리를 쉬운 말로 설명\n    - 대안보다 더 잘 작동하는 이유\n    - 역사적 맥락(누가, 언제 개발했는지)\n\n3. 구현을 위한 단계별 방법\n    - Step 1: [상세 지침]\n    - Step 2: [상세 지침]\n    - Step 3: [상세 지침]\n    - 각 단계에서 피해야 할 흔한 실수\n\n4. 상세한 해설이 포함된 연습 문제 3개\n    - Easy: [기본 적용]\n    - Medium: [여러 단계가 필요한 문제]\n    - Hard: [현실의 복잡한 시나리오]\n    - 추론을 포함한 전체 풀이 제공\n\n5. 숙달을 위한 실행 가능한 체크리스트\n    - 이해도를 검증할 항목 5개\n    - 추가 연습을 위한 리소스\n\n각 주요 개념마다 이 과정을 반복한 뒤, 모든 개념이 어떻게 연결되는지 보여주는 시각적 개념도(concept map)로 요약해줘.\n\n추가 맥락:\n- 내 현재 수준: {난이도}\n- 응용 분야: {응용분야}\n- 선호 비유 도메인: {선호비유}',
  E'Educate me about {주제} through a problem-solving lens. For each key concept, provide:\n\n1. A realistic problem or challenge\n   - Describe a real-world scenario where this concept is needed\n   - Explain why traditional approaches fail\n\n2. An explanation of how the concept serves as the solution\n   - Core principle in simple terms\n   - Why it works better than alternatives\n   - Historical context (who developed it, when)\n\n3. A step-by-step method for implementation\n   - Step 1: [Detailed instruction]\n   - Step 2: [Detailed instruction]\n   - Step 3: [Detailed instruction]\n   - Common mistakes to avoid at each step\n\n4. Three practice problems with detailed explanations\n   - Easy: [Basic application]\n   - Medium: [Multi-step problem]\n   - Hard: [Real-world complex scenario]\n   - Include full solutions with reasoning\n\n5. Actionable checklist for mastery\n   - 5 items to verify understanding\n   - Resources for further practice\n\nRepeat this process for each major concept, then summarize with a visual concept map showing how all concepts connect.\n\nAdditional Context:\n- My current level: {난이도}\n- Application area: {응용분야}\n- Preferred analogy domain: {선호비유}',
  '[
    {"name": "주제", "placeholder": "예: 통계학 샘플링 기법", "example": "통계학 샘플링 기법"},
    {"name": "난이도", "placeholder": "예: 학부 2학년", "example": "학부 2학년"},
    {"name": "응용분야", "placeholder": "예: 마케팅 리서치 (선택)", "example": "마케팅 리서치"},
    {"name": "선호비유", "placeholder": "예: 스포츠/요리/일상생활 (선택)", "example": "요리"}
  ]'::jsonb,
  '{"input": "주제: 데이터 샘플링", "output": "문제: 1000개 데이터 전수조사 불가능 → 해결책: 샘플링 기법 도입 → 구현: ①모집단 정의 ②무작위추출 ③대표성 검증 → 연습문제(하): 100명 중 10명 샘플링..."}'::jsonb,
  ARRAY[
    '새 챕터 시작 시 개념 예습용으로 최적',
    '연습문제는 "해설 포함" 옵션 추가 권장',
    '실무 사례를 본인 관심 분야로 지정 가능',
    '각 단계별 예상 학습시간 요청 가능',
    '프로젝트 기반 학습(PBL) 수업에 응용 가능'
  ]
);
