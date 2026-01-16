-- Insert Thesis Statement Refiner Prompt Template
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
  'Thesis Statement 정교화 엔진 (Academic Rigor Maximizer)',
  'Intermediate',
  '초안 논지문을 입력하면 명확성·구체성·학술적 엄격성 기준으로 비평하고 개선안 3가지 제시',
  '논문 지도교수처럼 행동하며, 초안 논지문의 강약점을 진단하고 (1)더 간결하게 (2)더 초점화되게 (3)더 논쟁적으로 만드는 구체적 수정안을 제공합니다. 명확한 입장·의미 있는 연구 질문·잠재적 함의까지 포함하도록 유도합니다.',
  ARRAY['논지문', 'Thesis', '논문지도', '논리강화', '학술글쓰기'],
  '[{"text": "중급", "color": "blue"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'학술 글쓰기(academic writing)를 전문으로 하는 논문 지도교수 역할을 맡아줘. 너의 과제는 학생의 학술 논문을 위한 논지문(thesis statement)을 다듬고 강화하는 것이다. 학생이 제공한 논지문은 다음과 같다: "{초안논지문}."\n\n목표는 이 초기 논지문을 명확성, 구체성, 학문적 엄밀성 측면에서 비평하는 것이다. 논지문을 더 간결하고, 초점을 명확히 하며, 논증적(argumentative)으로 만들기 위한 건설적인 피드백을 제공해줘. 또한 명확한 입장, 중요한 연구 질문, 연구의 잠재적 함의를 포함하도록 개선하는 방법을 제안해줘. 최종적으로 다듬어진 논지문은 정의가 분명하고, 논쟁 가능하며(debatable), 학술 논문에서 흥미로운 논증을 위한 탄탄한 기반이 되도록 해줘.\n\n출력 구조:\n\n1. 현재 논지문 분석\n    - 강점 (2-3개)\n    - 약점 (예시 포함 3-4개)\n2. 다듬어진 버전 3가지\n    - Version A: [명확성에 초점]\n    - Version B: [구체성에 초점]\n    - Version C: [논쟁 가능성에 초점]\n3. 각 버전에 대한 근거 (2-3문장)\n4. 추천 버전과 그 정당화\n\nContext:\n- 논문 주제: {논문주제}\n- 타겟 청중: {타겟청중}\n- 학술 수준: {학술수준}',
  E'Assume the role of a thesis advisor with a specialization in academic writing. Your task is to refine and enhance a student''s thesis statement for their academic paper. The thesis statement provided by the student is: "{초안논지문}."\n\nYour goal is to critique this initial thesis statement for clarity, specificity, and academic rigor. Provide constructive feedback on how to make the thesis more concise, focused, and argumentative. Suggest ways to incorporate a clear stance, significant research questions, and the potential implications of the research. Ensure the refined thesis statement is well-defined, debatable, and sets a solid foundation for an interesting argument in their academic paper.\n\nOutput Structure:\n1. Current Thesis Analysis\n   - Strengths (2-3 points)\n   - Weaknesses (3-4 points with examples)\n2. Three Refined Versions\n   - Version A: [Emphasis on clarity]\n   - Version B: [Emphasis on specificity]\n   - Version C: [Emphasis on debatability]\n3. Rationale for Each Version (2-3 sentences)\n4. Recommended Version with Justification\n\nContext:\n- Paper topic: {논문주제}\n- Target audience: {타겟청중}\n- Academic level: {학술수준}',
  '[
    {"name": "초안논지문", "placeholder": "예: 소셜미디어는 청소년에게 부정적 영향을 준다", "example": "소셜미디어는 청소년에게 부정적 영향을 준다"},
    {"name": "논문주제", "placeholder": "예: 청소년 정신건강", "example": "청소년 정신건강"},
    {"name": "타겟청중", "placeholder": "예: 학부생 / 전문가 / 일반대중", "example": "전문가"},
    {"name": "학술수준", "placeholder": "예: 학부 / 석사 / 박사", "example": "석사"}
  ]'::jsonb,
  '{"input": "초안: 소셜미디어는 나쁘다", "output": "개선안 1: 하루 3시간 이상 소셜미디어 사용은 청소년의 우울증 위험을 2배 증가시킨다(Smith 2023)."}'::jsonb,
  ARRAY[
    '논문/에세이 작성 초기(5% 완성 시점)에 활용',
    '초안은 1-2문장으로 간결하게 입력',
    '"debatable, testable, specific" 3요소 충족 여부 체크',
    '개선안 3가지 중 지도교수와 상의 후 선택',
    '최종 선택 후 "이 논지문으로 아웃라인 생성" 연계 가능'
  ]
);
