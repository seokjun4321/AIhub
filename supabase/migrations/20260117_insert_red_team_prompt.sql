-- Insert Red Team Debate Prep Prompt Template
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
  '압박 테스트 + 반론 방어 전략 (Red Team Debate Prep)',
  'Advanced',
  '논문·발표 논지를 악마의 변호인 관점에서 공격해 허점 발견→반박 전략 3가지 제공',
  '비판적 검토자(Red Team)로 행동하며, 업로드한 논지문·초안을 (1)반대 논점 3가지 (2)논리적 취약지점 (3)반박전략(근거 유형 포함) 순서로 분석합니다. 발표·디펜스 전 사전 시뮬레이션으로 최적화.',
  ARRAY['논지검증', '반론대비', 'RedTeam', '토론준비', '비판적분석'],
  '[{"text": "고급", "color": "red"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'이 논지/가설을 압박 테스트(Red Team Review)해 줘.\n\n## 역할 (Your Role)\n{학문분야} 분야의 비판적 동료 검토자이자 "악마의 변호인(devil''s advocate)" 역할을 맡아줘. 너의 목표는 적대적인 검토자나 청중이 공격할 수 있는 약점을 찾아 논증을 강도 높게 테스트하는 것이다.\n\n## 과업 (Your Task)\n1. 대표 반대논점 3개 (근거 포함)\n   - 각 논점마다: 반론자의 입장 + 인용 가능한 반대 문헌/데이터 + 반론 강도(상/중/하)\n   \n2. 내 논리의 취약지점 분석 (Vulnerability Analysis)\n   - 샘플링 편향\n   - 인과관계 vs 상관관계 혼동\n   - 대안 설명(alternative explanation) 가능성\n   - 용어 정의 모호성\n   - 일반화 가능성(generalizability) 한계\n   \n3. 반박전략 (3가지 방어 시나리오)\n   - Scenario A: 직접 반박 (추가 근거 제시)\n   - Scenario B: 한계 인정 + 연구 의의 강조\n   - Scenario C: 재정의(reframe) 전략\n   \n4. 추가 근거 제안\n   - 신뢰 가능한 1차 자료 유형 (예: 종단연구, 메타분석)\n   - 인용 가능한 최신 논문 3편 추천\n   \n5. 예상 질문 Top 10\n   - 난이도 표시 (★☆☆ ~ ★★★)\n   - 각 질문별 2문장 답변 예시\n\n출력 형식: 마크다운 표 + 불릿포인트\n\n[업로드: {논지파일}]\n\nContext:\n- 예상 청중: {예상청중}\n- 발표 형식: {발표형식}',
  E'Conduct a Red Team Review (stress test) on this thesis/hypothesis.\n\n## Your Role\nAct as a critical peer reviewer and "devil''s advocate" for {학문분야}. Your goal is to stress-test the argument by identifying weaknesses that hostile reviewers or audience members might exploit.\n\n## Your Task\n1. 3 Major Counter-Arguments (with evidence)\n   - For each point: Opponent''s stance + Citable contrary literature/data + Strength of counter-argument (High/Medium/Low)\n   \n2. Vulnerability Analysis of My Logic\n   - Sampling bias\n   - Confusion between correlation vs. causation\n   - Possibility of alternative explanations\n   - Ambiguity in definitions\n   - Generalizability limits\n   \n3. Rebuttal Strategies (3 Defense Scenarios)\n   - Scenario A: Direct Rebuttal (Provide additional evidence)\n   - Scenario B: Acknowledge Limitations + Emphasize Significance\n   - Scenario C: Reframe Strategy\n   \n4. Suggestions for Additional Evidence\n   - Types of reliable primary sources (e.g., longitudinal studies, meta-analyses)\n   - Recommend 3 citeable recent papers\n   \n5. Top 10 Expected Questions\n   - Difficulty rating (★☆☆ ~ ★★★)\n   - 2-sentence example answer for each question\n\nOutput Format: Markdown Table + Bullet Points\n\n[Upload: {논지파일}]\n\nContext:\n- Expected audience: {예상청중}\n- Presentation format: {발표형식}',
  '[
    {"name": "논지파일", "placeholder": "예: thesis_statement.pdf (텍스트 붙여넣기)", "example": "thesis_statement.pdf"},
    {"name": "학문분야", "placeholder": "예: 사회학 (선택)", "example": "사회학"},
    {"name": "예상청중", "placeholder": "예: 학회 전문가 (선택)", "example": "학회 전문가"},
    {"name": "발표형식", "placeholder": "예: 구두발표, 포스터, 논문디펜스 (선택)", "example": "구두발표"}
  ]'::jsonb,
  '{"input": "논지: 소득 주도 성장은 경제 활성화에 효과적이다.", "output": "반대논점 1: 기업 비용 증가로 인한 고용 감소 (반론자: 신고전학파) → 취약점: 단기 효과와 장기 효과의 혼재 → 반박전략: 소비 성향이 높은 저소득층의 소득 증가가 내수 활성화로 이어지는 경로 강조..."}'::jsonb,
  ARRAY[
    '발표 3일 전 최종 리허설용',
    '지도교수 미팅 전 사전 방어 준비',
    '동료 리뷰 전 자가 점검',
    '예상 질문 리스트 10개 추가 요청 가능',
    '반박 전략을 스크립트로 작성 요청 가능'
  ]
);
