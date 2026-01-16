-- Insert Research Paper Outline Generator Prompt Template
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
  '학술 논문 전체 아웃라인 생성기 (Structure + Argument Flow)',
  'Intermediate',
  '연구주제만 입력하면 서론→문헌리뷰→방법론→결과→토론→결론 전체 구조를 논리적 흐름으로 설계',
  '20년 경력 학술글쓰기 코치처럼 행동하며, 각 섹션의 목적·주요 논점·예상 내용·전환 문장까지 포함한 완전한 논문 아웃라인을 생성합니다. 서론에서는 연구 질문의 중요성, 문헌리뷰에서는 핵심 논쟁·공백, 방법론에서는 윤리적 연구설계를 강조합니다.',
  ARRAY['논문구조', '아웃라인', '연구설계', '학술글쓰기', '논리전개'],
  '[{"text": "중급", "color": "blue"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'{전공분야}에서 20년 이상의 전문 경력을 가진 숙련된 학술 작가(역할)로서, {연구주제}에 대한 연구 논문 개요(outline)를 작성해줘(과업). 개요는 서론, 문헌고찰, 방법론, 결과, 논의, 결론 섹션을 포함하도록 구조화해줘(액션).\n\n서론에서는 연구 질문과 그 중요성을 명확히 제시해줘. 문헌고찰에서는 현재 지식을 종합하고, 핵심 논쟁과 공백(gap)을 식별해줘. 방법론 섹션에서는 잠재적 편향을 다루고 참여자 프라이버시를 보호하는 윤리적인 연구 설계를 제안해줘. 결과 섹션에는 정량 및 정성 데이터 분석 모두를 위한 공간을 확보할 수 있도록 결과용 플레이스홀더를 포함해줘. 논의 섹션에서는 기존 문헌 및 사회적 함의의 맥락에서 결과를 해석해줘. 결론에서는 핵심 요점을 요약하고 향후 연구 및 정책 제안을 포함해 마무리해줘.\n\n각 섹션마다 다음을 제공해줘:\n\n- 섹션 목적(1문장)\n- 포함할 핵심 주장(3-5개 불릿)\n- 권장 문단 구조\n- 다음 섹션으로 넘어가는 전환 문장\n- 예상 단어 수\n\n전체 논문 분량: {목표분량}\n연구 접근법: {연구방법}',
  E'As an experienced academic writer with 20+ years of specialized experience in {전공분야} (Role), create an outline for a research paper on {연구주제} (Task). Structure the outline to include an introduction, literature review, methodology, results, discussion, and conclusion sections (Action).\n\nIn the introduction, clearly state the research question and its significance. For the literature review, synthesize current knowledge, identifying key debates and gaps. In the methodology section, propose an ethical research design that addresses potential biases and protects participant privacy. Include placeholders for results, ensuring space for both quantitative and qualitative data analysis. In the discussion section, interpret findings in the context of existing literature and societal implications. Conclude with a summary of key points and suggestions for future research and policy.\n\nFor each section, provide:\n- Section purpose (1 sentence)\n- Key arguments to include (3-5 bullet points)\n- Suggested paragraph structure\n- Transition sentence to next section\n- Estimated word count\n\nTotal paper length: {목표분량}\nResearch approach: {연구방법}',
  '[
    {"name": "전공분야", "placeholder": "예: adolescent psychology and digital media", "example": "adolescent psychology and digital media"},
    {"name": "연구주제", "placeholder": "예: 소셜미디어의 청소년 정신건강 영향", "example": "소셜미디어의 청소년 정신건강 영향"},
    {"name": "연구방법", "placeholder": "예: longitudinal quantitative study", "example": "longitudinal quantitative study"},
    {"name": "목표분량", "placeholder": "예: 8,000 words (선택)", "example": "8,000 words"}
  ]'::jsonb,
  '{"input": "주제: 소셜미디어와 청소년 정신건강", "output": "I. Introduction: Hook(소셜미디어 사용률 93%) → Context(정신건강 악화 통계) → Gap(인과관계 불명확) → Research Question(장기 영향은?) → Thesis(6개월 추적으로 인과성 입증) → II. Lit Review: 3개 하위주제..."}'::jsonb,
  ARRAY[
    '논문 작성 첫 단계에서 활용 (구조 잡기)',
    '각 섹션별 예상 분량(단어수) 추가 요청 가능',
    '"quantitative/qualitative/mixed methods" 명시 필수',
    '출력 후 각 섹션을 개별 프롬프트로 확장 가능',
    '지도교수 미팅 전 사전 구조 점검용으로 최적'
  ]
);
