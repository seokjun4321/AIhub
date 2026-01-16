-- Insert Essay Feedback (3-Layer Analysis) Prompt Template
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
  '학술 에세이 구조·논리·증거 피드백 (3-Layer Analysis)',
  'Intermediate',
  '에세이 초안을 Layer 1(구조), Layer 2(논리), Layer 3(증거) 3단계로 분석 후 개선 로드맵 제공',
  '업로드한 에세이를 (1)구조 진단(서론-본론-결론 균형, 전환 문장) (2)논리 진단(논증 타당성, 인과관계 오류) (3)증거 진단(출처 신뢰도, 인용 적절성) 순서로 분석하고, 각 Layer마다 구체적 개선 지시+추가 자료 추천을 제공합니다.',
  ARRAY['에세이피드백', '구조분석', '논리점검', '증거평가', '학술글쓰기'],
  '[{"text": "중급", "color": "blue"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'{에세이주제}에 대한 내 에세이를 검토하고, 3-Layer 분석 프레임워크를 사용해 자세하고 건설적인 피드백을 제공해줘.\n\n## Layer 1: 구조 분석 (Structure Analysis)\n1. 서론의 질 (Hook → Context → Thesis)\n    - 훅이 흥미를 끄는가?\n    - 맥락이 논리적으로 논제로 이어지는가?\n    - 논제 명확성 점수 (1-10)\n2. 본문 단락 구성\n    - 주제문 명확성\n    - 근거→분석 비율 (이상적: 40/60)\n    - 단락 간 전환의 질\n    - 단락 길이의 균형\n3. 결론의 강점\n    - 논제 재진술 (복사-붙여넣기 금지)\n    - 핵심 요점 종합\n    - 더 넓은 함의가 언급되었는가?\n\n## Layer 2: 논리 분석 (Logic Analysis)\n1. 논증 타당성\n    - 논리적 오류(있다면) 식별:\n        - 잘못된 인과(False cause) (상관관계 ≠ 인과관계)\n        - 성급한 일반화(Hasty generalization)\n        - 거짓 양분(False dichotomy)\n        - 허수아비 논증(Straw man)\n2. 일관성 점검\n    - 각 단락이 논제를 지지하는가?\n    - 반론이 다뤄졌는가?\n    - 내부 모순이 있는가?\n\n## Layer 3: 근거 분석 (Evidence Analysis)\n1. 출처의 질\n    - 학술·동료심사 논문: X개 출처\n    - 신뢰할 만한 뉴스/보고서: X개 출처\n    - 의심스러운 출처: X개 출처 (이것들은 표시해줘!)\n2. 인용 정확성 ({인용형식} 형식)\n    - 본문 내 인용 오류: 수정안과 함께 목록으로 제시\n    - 참고문헌 목록의 완전성\n3. 근거-주장 비율\n    - 근거 없는 주장: 해당 단락 목록화\n    - 단일 출처 과의존: 표시\n\n## 출력 형식\n**Executive Summary(요약):**\n- 전체 등급 예측: [Score]/100\n- 상위 강점 3가지\n- 개선이 필요한 영역 3가지\n\n**레이어별 상세 피드백:**\n- Layer 1: [발견사항] + [실행 과제]\n- Layer 2: [발견사항] + [실행 과제]\n- Layer 3: [발견사항] + [실행 과제]\n\n**개선 로드맵 (우선순위 순):**\n1. [높은 우선순위] [X단락]의 [구체적 문제] 수정\n2. [중간 우선순위] [주장]을 뒷받침할 [근거 유형] 추가\n3. [낮은 우선순위] [구간] 사이의 [전환] 개선\n\n**추가로 추천할 자료:**\n- [취약한 논증]을 강화할 동료심사 논문 3편\n- [추상적 개념]을 설명할 실제 사례\n\n[업로드: {초안파일}]\n\nContext:\n- 목표 등급: {목표등급}\n- 집중 영역(있다면): {집중항목}\n- 인용 스타일: {인용형식}\n- 목표 분량: {목표분량}',
  E'Review my essay on {에세이주제} and provide detailed, constructive feedback using a 3-Layer Analysis Framework.\n\n## Layer 1: Structure Analysis\n1. Introduction Quality (Hook → Context → Thesis)\n   - Is the hook engaging?\n   - Does context flow logically to thesis?\n   - Thesis clarity score (1-10)\n2. Body Paragraph Organization\n   - Topic sentence clarity\n   - Evidence→Analysis ratio (ideal: 40/60)\n   - Transition quality between paragraphs\n   - Paragraph length balance\n3. Conclusion Strength\n   - Thesis restatement (not copy-paste)\n   - Synthesis of key points\n   - Broader implications mentioned?\n\n## Layer 2: Logic Analysis\n1. Argument Validity\n   - Identify logical fallacies (if any):\n     * False cause (correlation ≠ causation)\n     * Hasty generalization\n     * False dichotomy\n     * Straw man\n2. Coherence Check\n   - Does each paragraph support the thesis?\n   - Are counterarguments addressed?\n   - Internal contradictions?\n\n## Layer 3: Evidence Analysis\n1. Source Quality\n   - Academic peer-reviewed: X sources\n   - Credible news/reports: X sources\n   - Questionable sources: X sources (flag these!)\n2. Citation Accuracy ({인용형식} format)\n   - In-text citation errors: List with corrections\n   - Reference list completeness\n3. Evidence-to-Claim Ratio\n   - Unsupported claims: List paragraphs\n   - Over-reliance on single source: Flag\n\n## Output Format\n**Executive Summary:**\n- Overall grade prediction: [Score]/100\n- Top 3 strengths\n- Top 3 areas for improvement\n\n**Detailed Feedback by Layer:**\n- Layer 1: [Findings] + [Action Items]\n- Layer 2: [Findings] + [Action Items]\n- Layer 3: [Findings] + [Action Items]\n\n**Improvement Roadmap (Priority Order):**\n1. [High Priority] Fix [specific issue] in [paragraph X]\n2. [Medium Priority] Add [type of evidence] to support [claim]\n3. [Low Priority] Improve [transition] between [sections]\n\n**Recommended Additional Resources:**\n- 3 peer-reviewed articles to strengthen [weak argument]\n- Real-world examples for [abstract concept]\n\n[Upload: {초안파일}]\n\nContext:\n- Target grade: {목표등급}\n- Focus area (if any): {집중항목}\n- Citation style: {인용형식}\n- Word count target: {목표분량}',
  '[
    {"name": "에세이주제", "placeholder": "예: 기후변화와 경제정책", "example": "기후변화와 경제정책"},
    {"name": "초안파일", "placeholder": "예: essay_draft.docx (텍스트 붙여넣기)", "example": "essay_draft.docx"},
    {"name": "목표등급", "placeholder": "예: A등급 (90점 이상) (선택)", "example": "A등급 (90점 이상)"},
    {"name": "집중항목", "placeholder": "예: 논리 흐름만 집중 (선택)", "example": "논리 흐름만 집중"},
    {"name": "인용형식", "placeholder": "예: APA 7th (선택)", "example": "APA 7th"},
    {"name": "목표분량", "placeholder": "예: 2000단어 (선택)", "example": "2000단어"}
  ]'::jsonb,
  '{"input": "주제: 기본소득, 초안: ...", "output": "Layer 1(구조): 서론 15%, 본론 70%, 결론 15% 균형 양호... Layer 2(논리): 상관관계 vs 인과관계 오류 발견..."}'::jsonb,
  ARRAY[
    '초안 70-80% 완성 시 활용',
    '특정 Layer만 집중 피드백 요청 가능',
    '인용 형식(APA/MLA/Chicago) 체크 함께 요청',
    '개선 후 "개선본 재평가" 반복 가능',
    '최종 제출 48시간 전 활용 권장'
  ]
);
