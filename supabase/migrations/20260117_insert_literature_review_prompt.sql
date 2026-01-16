-- Insert Literature Review Generator Prompt Template
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
  '종합 문헌 리뷰 (Literature Review Generator with Gap Analysis)',
  'Advanced', -- changed from 'Start' to 'Advanced' to match check constraint
  '연구주제 입력 시 최근 X년간 논문을 체계적으로 분석·종합하고 연구 공백(gap)까지 제시',
  '특정 분야 전문 연구자처럼 행동하며, 현재 연구 동향 개요→주요 발견 종합→방법론 강약점 평가→연구 공백 식별→미래 연구방향 제안 순서로 포괄적인 문헌 리뷰를 생성합니다. 주제별/연대기적 구성 선택 가능.\n\n추천 대상: 학위논문 문헌리뷰 작성 중인 대학원생, 연구제안서 준비 학생',
  ARRAY['문헌리뷰', '연구공백분석', '체계적리뷰', '학술조사', '연구동향'],
  '[{"text": "중급", "color": "blue"}, {"text": "고급", "color": "orange"}]'::jsonb,
  'AIHub',
  ARRAY['Perplexity AI', 'ChatGPT'],
  E'{전공분야}를 전문으로 하는 숙련된 연구자(역할)로서, {연구주제}에 대한 포괄적인 문헌고찰(literature review)을 수행해줘(과업). 먼저 이 분야의 현재 연구 현황에 대한 개요를 제공해줘(맥락). 그다음, 최근 {기간} 동안 출판된 동료심사(peer-reviewed) 연구들을 기반으로 결과를 체계적으로 분석하고 종합해줘(액션).\n\n문헌에서 나타나는 핵심 트렌드, 상충되는 결과, 그리고 연구 공백(gap)을 식별해줘(정보). 가장 영향력 있는 연구들의 방법론적 강점과 약점을 평가해줘. 마지막으로, 향후 연구를 위한 유망한 방향과 {추가요청}을(를) 해결하기 위한 잠재적 개입(interventions)을 제안해줘.\n\n출력 형식:\n\n1. Executive Summary (200단어)\n2. 현재 연구 현황 개요 (3문단)\n3. 주제(Theme)별 핵심 발견 (인용 포함 불릿 포인트)\n4. 방법론 분석 (표 형식)\n5. 식별된 연구 공백 (번호 매기기 목록)\n6. 향후 방향 (근거 포함 5개 추천)',
  E'As an experienced researcher specializing in {전공분야} (Role), conduct a comprehensive literature review on {연구주제} (Task). Begin by providing an overview of the current state of research in this field (Context). Then, systematically analyze and synthesize findings from peer-reviewed studies published in the last {기간} (Action).\n\nIdentify key trends, conflicting results, and gaps in the literature (Information). Evaluate the methodological strengths and weaknesses of the most influential studies. Finally, suggest promising directions for future research and potential interventions to address {추가요청}.\n\nOutput Format:\n1. Executive Summary (200 words)\n2. Current State Overview (3 paragraphs)\n3. Key Findings by Theme (bullet points with citations)\n4. Methodological Analysis (table format)\n5. Identified Research Gaps (numbered list)\n6. Future Directions (5 recommendations with rationale)',
  '[
    {"name": "전공분야", "placeholder": "예: adolescent psychology and digital media", "example": "adolescent psychology and digital media"},
    {"name": "연구주제", "placeholder": "예: 소셜미디어가 청소년 정신건강에 미치는 영향", "example": "소셜미디어가 청소년 정신건강에 미치는 영향"},
    {"name": "기간", "placeholder": "예: 최근 5년 또는 2020-2025", "example": "최근 5년"},
    {"name": "추가요청", "placeholder": "예: 개발도상국 데이터 중심으로 (선택)", "example": "개발도상국 데이터 중심으로"}
  ]'::jsonb,
  '{"input": "주제: 소셜미디어와 청소년 정신건강", "output": "Current State: 최근 5년간 소셜미디어-청소년 정신건강 연구 142편 분석 → Key Trends: 우울증 연구 62%, 불안장애 31% → Gaps: 장기 종단연구 부족(5편만 존재) → Future Directions: 6개월 이상 추적연구 필요"}'::jsonb,
  ARRAY[
    'Perplexity AI에서 사용 시 최고 효과 (웹 검색 자동)',
    '연도 범위를 "최근 5년"보다 구체적으로(2020-2025) 명시',
    '"Role-Task-Context-Action" 구조 유지',
    '후속 질문으로 "모순된 결과 3가지 추출" 등 심화 가능',
    '출력 후 주요 논문 DOI 요청하면 직접 확인 가능'
  ]
);
