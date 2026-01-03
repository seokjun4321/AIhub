-- Update Guide 10, Step 1 with test data for new columns
UPDATE public.guide_steps
SET
  goal = 'Cursor를 설치하고 기본 설정을 완료하여 AI 기능을 사용할 준비를 마칩니다.',
  done_when = 'Cursor에서 Chat 기능이 정상 동작하고, 첫 번째 AI 응답을 받았을 때',
  why_matters = '올바른 초기 설정은 이후 모든 작업의 효율성을 결정합니다. API 키 설정, 모델 선택, 기본 단축키 숙지가 핵심입니다.',
  tips = '- @file, @folder, @codebase 멘션을 적극 활용하면 정확도 향상
- 긴 대화보다 새 Chat 세션을 자주 시작하는 것이 효율적',
  checklist = '- [ ] Cmd+L로 Chat 열기 성공
- [ ] @file 멘션 사용해보기
- [ ] 실제 코드에 대해 질문하고 답변 받기'
WHERE guide_id = 10 AND step_order = 1;
