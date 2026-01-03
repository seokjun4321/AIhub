-- Guide 10 Step 1 Update with 'Tips' markers (X) and (V)
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, content, goal, done_when, why_matters, tips, checklist)
VALUES (
  10,
  1,
  'ChatGPT란 무엇인가요? (소개 및 핵심 특징)',
  'ChatGPT의 기본 개념과 작동 원리를 이해합니다.',
  'ChatGPT는 OpenAI가 개발한 대화형 인공지능 모델입니다. 이 단계에서는 ChatGPT의 기본 개념과 어떻게 작동하는지 알아봅니다.', 
  'Cursor를 설치하고 기본 설정을 완료하여 AI 기능을 사용할 준비를 마칩니다.',
  'Cursor에서 Chat 기능이 정상 동작하고, 첫 번째 AI 응답을 받았을 때',
  '올바른 초기 설정은 이후 모든 작업의 효율성을 결정합니다. API 키 설정, 모델 선택, 기본 단축키 숙지가 핵심입니다.',
  '- (X) 너무 짧거나 애매한 지시: ''PPT 만들어줘'', ''보고서 써줘''
- (X) 맥락 없이 작업만 요구: AI는 당신의 상황을 모릅니다
- (V) 구체적인 역할, 맥락, 형식을 명시하세요
- (V) 원하는 결과물의 예시를 함께 제공하면 더욱 좋습니다',
  '- [ ] Cmd+L로 Chat 열기 성공
- [ ] @file 멘션 사용해보기
- [ ] 실제 코드에 대해 질문하고 답변 받기'
)
ON CONFLICT (guide_id, step_order)
DO UPDATE SET
  goal = EXCLUDED.goal,
  tips = EXCLUDED.tips,
  checklist = EXCLUDED.checklist,
  why_matters = EXCLUDED.why_matters,
  done_when = EXCLUDED.done_when;
