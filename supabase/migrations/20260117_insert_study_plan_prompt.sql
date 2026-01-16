-- Insert Adaptive Study Plan Generator Prompt Template
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
  '적응형 학습 계획 생성기 (Spaced Repetition + Weakness Focus)',
  'Intermediate',
  '시험 범위·성적 데이터 기반으로 약점 단원 집중+공간 반복 학습 스케줄 자동 생성',
  '업로드한 실라버스·성적표를 분석해 시험까지 남은 기간을 최적 배분하고, 약점 단원은 복습 빈도를 높이며(D-1, D-3, D-7, D-14), 강점 단원은 1회 복습으로 시간 절약하는 적응형 계획을 생성합니다. Anki식 간격 반복 알고리즘 적용.',
  ARRAY['학습계획', 'SpacedRepetition', '적응형학습', '약점집중', '시간최적화'],
  '[{"text": "중급", "color": "blue"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'다가오는 {과목명} 시험을 위한 개인 맞춤형, 적응형 학습 계획을 만들어줘. 내 최근 성과 데이터와 실라버스(강의계획서) 세부 내용을 반영해줘.\n\n## 분석 단계 (Analysis Phase)\n\n1. 업로드된 실라버스를 검토하고 모든 주제/챕터를 식별\n2. 내 성과 데이터(퀴즈 점수, 중간고사 성적) 분석\n3. 주제를 다음과 같이 분류:\n    - 강점 (90%+ 점수): 최소 복습만 필요\n    - 보통 (70-89%): 표준 복습\n    - 약점 (<70%): 간격 반복(spaced repetition)을 포함한 집중 복습\n\n## 계획 단계 (Planning Phase)\n\n1. 시험까지 남은 총 가용 학습 시간 계산 ({가용시간} × D-Day)\n2. 약점 수준에 따라 시간 배분:\n    - 강점 단원: 시간의 10%\n    - 보통 단원: 시간의 30%\n    - 약점 단원: 시간의 60%\n3. 간격 반복(Spaced Repetition) 적용:\n    - 약점 단원: D-14, D-7, D-3, D-1에 복습\n    - 보통 단원: D-7, D-1에 복습\n    - 강점 단원: D-1에만 복습\n\n## 출력 형식 (Output Format)\n\n**주차별 구성(Week-by-Week Breakdown):**\n\n- Week 1: [Topics] | [Hours] | [Review Dates] | [Practice Problems #]\n- Week 2: [Topics] | [Hours] | [Review Dates] | [Practice Problems #]\n- Week 3: [Topics] | [Hours] | [Review Dates] | [Mock Exams #]\n\n**일일 스케줄(Daily Schedule):**\n\n- Mon: [8:00-9:00] Ch3 복습 (2nd rep) | [9:00-10:00] Ch5 연습문제 풀이\n- Tue: ...\n\n**진도 추적(Progress Tracking):**\n\n- 마일스톤(주간 점검)\n- 조정 트리거(연습 점수 <80%일 경우)\n\n**필요 리소스(Resources Needed):**\n\n- 연습문제 세트: [실라버스에서 목록]\n- 복습 자료: [교과서 챕터, 강의 슬라이드]\n\n포함할 것:\n\n- 시간 배분\n- 타깃 연습문제(난이도 수준 명시)\n- 플래시카드 추천을 포함한 복습 세션\n- 모의고사 일정(마지막 주에 전 범위 2-3회)\n\n진도와 어려운 영역에 따라 계획을 동적으로 조정하되, 모든 핵심 주제를 빠짐없이 커버하도록 보장해줘.\n\n[업로드: {첨부파일}]\n\nContext:\n\n- 시험일: {시험일}\n- 약점 단원: {약점단원}\n- 강점 단원: {강점단원}\n- 하루 가용시간: {가용시간}',
  E'Create a personalized, adaptive study plan for my upcoming exams in {과목명}. Incorporate my recent performance data and syllabus details.\n\n## Analysis Phase\n1. Review uploaded syllabus and identify all topics/chapters\n2. Analyze my performance data (quiz scores, midterm grades)\n3. Categorize topics:\n   - Strong (90%+ scores): Minimal review needed\n   - Moderate (70-89%): Standard review\n   - Weak (<70%): Intensive review with spaced repetition\n\n## Planning Phase\n4. Calculate total available study hours until exam({가용시간} × D-Day)\n5. Allocate time based on weakness:\n   - Strong topics: 10% of time\n   - Moderate topics: 30% of time\n   - Weak topics: 60% of time\n6. Apply Spaced Repetition:\n   - Weak topics: Review on D-14, D-7, D-3, D-1\n   - Moderate topics: Review on D-7, D-1\n   - Strong topics: Review on D-1 only\n\n## Output Format\n**Week-by-Week Breakdown:**\n- Week 1: [Topics] | [Hours] | [Review Dates] | [Practice Problems #]\n- Week 2: [Topics] | [Hours] | [Review Dates] | [Practice Problems #]\n- Week 3: [Topics] | [Hours] | [Review Dates] | [Mock Exams #]\n\n**Daily Schedule:**\n- Mon: [8:00-9:00] Ch3 Review (2nd rep) | [9:00-10:00] Ch5 Practice Problems\n- Tue: ...\n\n**Progress Tracking:**\n- Milestones (weekly check-ins)\n- Adjustment triggers (if score <80% on practice)\n\n**Resources Needed:**\n- Practice problem sets: [List from syllabus]\n- Review materials: [Textbook chapters, lecture slides]\n\nInclude:\n- Time allocations\n- Targeted practice problems (specify difficulty levels)\n- Review sessions with flashcard recommendations\n- Mock exam schedule (2-3 full-length tests in final week)\n\nAdjust the plan dynamically based on progress and areas of difficulty, ensuring coverage of all key topics.\n\n[Upload: {첨부파일}]\n\nContext:\n- Exam date: {시험일}\n- Weak topics: {약점단원}\n- Strong topics: {강점단원}\n- Daily available time: {가용시간}',
  '[
    {"name": "과목명", "placeholder": "예: 유기화학", "example": "유기화학"},
    {"name": "시험일", "placeholder": "예: 3주 후 (2026-02-03)", "example": "3주 후 (2026-02-03)"},
    {"name": "가용시간", "placeholder": "예: 하루 3시간", "example": "하루 3시간"},
    {"name": "약점단원", "placeholder": "예: Ch5 반응메커니즘 (선택)", "example": "Ch5 반응메커니즘"},
    {"name": "강점단원", "placeholder": "예: Ch1-2 기초 화학 (선택)", "example": "Ch1-2 기초 화학"},
    {"name": "첨부파일", "placeholder": "예: 실라버스, 성적표 (텍스트 붙여넣기)", "example": "실라버스 내용..."}
  ]'::jsonb,
  '{"input": "과목: 유기화학, 시험: 2주 후", "output": "Week 1: Ch1-2(이해도 90%) 총 2시간(D-7, D-1 복습) → Week 2: Ch3-4(이해도 40%) 총 8시간..."}'::jsonb,
  ARRAY[
    '시험 2주 이상 남았을 때 활용 (1주일 미만은 비효율)',
    '실라버스와 최근 퀴즈·중간고사 점수 첨부 필수',
    '일일 가용 시간(예: 하루 3시간) 명시',
    '출력된 계획을 Google Calendar로 내보내기 요청 가능',
    '주간 점검 후 "진도 70% 달성, 계획 재조정" 요청'
  ]
);
