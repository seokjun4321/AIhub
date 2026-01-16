-- Insert Socratic Critical Thinking Booster Prompt Template
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
  '소크라테스식 심화 인터뷰 (Critical Thinking Booster)',
  'Advanced',
  'AI가 답을 알려주지 않고 개방형 질문으로 스스로 사고하게 유도→10점 평가→심화질문 루프',
  '업로드한 강의노트 기반으로 개방형 질문을 한 번에 하나씩 제시하고, 학생이 답변하면 10점 만점 평가(강점·보완점 명시) 후 논리를 심화시키는 후속 질문을 이어갑니다. 암기가 아닌 이해·적용·분석 능력을 강화합니다.',
  ARRAY['소크라테스식', '비판적사고', '개방형질문', '자기주도학습', '심화질문'],
  '[{"text": "고급", "color": "red"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'업로드한 노트/슬라이드로부터 시작해, 이해·적용·분석을 유도하는 개방형 질문을 한 번에 하나씩 해 줘.\n\nInstructions:\n1. 첫 질문은 핵심 개념의 "왜"에 초점\n2. 내가 답하면:\n   - {평가기준} 척도로 평가 (이유 명시)\n   - 강점 2가지 구체적으로 언급\n   - 보완점 1-2가지 + 보완 방향 제시\n   - 심화 질문 1개 추가 (논리 확장 또는 반례 제시)\n3. 질문 유형 다양화:\n   - "어떻게 적용할까?" (적용)\n   - "왜 그렇게 생각해?" (분석)\n   - "반대 사례는?" (평가)\n4. 총 {질문개수} 질문 진행\n5. 마지막에 전체 강약점 요약 + 추가 학습 추천\n\nTone: 격려적이되 엄격한 교수 스타일\nRestrictions:\n- 절대 정답 바로 알려주지 마라\n- "좋아요", "맞아요" 같은 빈말 금지\n- 답변이 틀려도 힌트만 제공\n\n[업로드: {강의자료파일}]',
  E'Start from the uploaded notes/slides and ask open-ended questions one by one to induce understanding, application, and analysis.\n\nInstructions:\n1. Focus the first question on the "why" of the core concept.\n2. When I answer:\n   - Evaluate on a scale of {평가기준} (specify reasons).\n   - Mention 2 specific strengths.\n   - Mention 1-2 areas for improvement + direction for improvement.\n   - Add 1 deepening question (expand logic or present a counterexample).\n3. Diversify question types:\n   - "How would you apply this?" (Application)\n   - "Why do you think that?" (Analysis)\n   - "What about a counterexample?" (Evaluation)\n4. Proceed with a total of {질문개수} questions.\n5. Summarize overall strengths/weaknesses and recommend additional learning at the end.\n\nTone: Encouraging but strict professor style\nRestrictions:\n- Never give the answer immediately.\n- No empty words like "Good job", "Correct".\n- Provide only hints if the answer is wrong.\n\n[Upload: {강의자료파일}]',
  '[
    {"name": "강의자료파일", "placeholder": "예: lecture_notes.pdf", "example": "lecture_notes.pdf"},
    {"name": "질문개수", "placeholder": "예: 5개 (선택)", "example": "5개"},
    {"name": "평가기준", "placeholder": "예: 10점 만점 (선택)", "example": "10점 만점"}
  ]'::jsonb,
  '{"input": "답변: RNA 간섭은 유전자 발현을 억제하는 과정입니다...", "output": "평가: 8/10. 강점: 메커니즘 정확. 보완: 전달체계 한계 언급 필요. → Q2: 나노입자 전달체가 이 문제를 어떻게 해결할까요?"}'::jsonb,
  ARRAY[
    '시험 1주일 전 개념 심화 점검용',
    '답변 시간 제한(1분) 설정 가능 ("60초 타이머 작동")',
    '토론·발표 리허설로 활용 시 최고 효과',
    '답변 기록을 누적해 "나만의 FAQ" 생성 가능',
    '교수 질문 예상 시뮬레이션으로도 활용'
  ]
);
