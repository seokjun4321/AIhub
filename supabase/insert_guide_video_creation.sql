-- Ensure ChatGPT model exists to avoid FK error
INSERT INTO public.ai_models (name, description, provider)
SELECT 'ChatGPT', 'OpenAI ChatGPT', 'OpenAI'
WHERE NOT EXISTS (SELECT 1 FROM public.ai_models WHERE name ILIKE '%ChatGPT%');

INSERT INTO public.guides (id, title, description, one_line_summary, ai_model_id, author_id, requirements, core_principles)
OVERRIDING SYSTEM VALUE
VALUES (
  14,
  'ChatGPT 프롬프트 엔지니어링으로 AI 영상 제작하기',
  'ChatGPT로 프롬프트를 설계하고 무료 AI 도구에서 실행해 영화 같은 영상을 만드는 완전 실전 가이드입니다. 복잡한 편집 스킬 없이도 하루 만에 첫 AI 영상을 완성할 수 있습니다.',
  'ChatGPT와 무료 AI 도구(Kling, Hailuo)로 영화 같은 영상을 만드는 실전 가이드',
  (SELECT id FROM public.ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
  NULL, -- System guide, no specific author
  '["ChatGPT 계정", "Kling AI 계정 (무료)", "Hailuo AI 계정 (무료)", "영상 편집 프로그램 (CapCut 등)"]'::jsonb,
  '["AI는 도구일 뿐, 감독은 나다", "프롬프트는 한 번에 완벽할 수 없다 (반복 개선)", "기술보다 스토리가 중요하다"]'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  one_line_summary = EXCLUDED.one_line_summary,
  requirements = EXCLUDED.requirements,
  core_principles = EXCLUDED.core_principles;

-- Steps Insertion

-- Step 1
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  1,
  'ChatGPT로 첫 영상 프롬프트 설계하기',
  'ChatGPT를 활용해 AI 영상 생성에 최적화된 프롬프트를 작성합니다.',
  'ChatGPT를 활용해 AI 영상 생성에 최적화된 구조적 프롬프트를 만든다.',
  'ChatGPT가 생성한 프롬프트가 5대 핵심 요소(주요 피사체, 액션, 환경, 카메라, 조명)를 모두 포함하고, 한 문장 100자 이내로 간결하게 정리됨',
  'AI 영상 도구는 "마법의 버튼"이 아닙니다. **프롬프트가 곧 설계도**입니다. 막연히 "멋진 영상 만들어줘"라고 입력하면 엉뚱한 결과가 나오거나 시간과 크레딧을 낭비하게 됩니다. ChatGPT는 자연어를 이해하고 구조화하는 데 뛰어나므로, 여러분의 아이디어를 AI 영상 도구가 이해할 수 있는 "영화 감독의 지시서"로 변환해 줍니다.',
  '#### (B) 해야 할 일

- ChatGPT에 접속해 새 대화 시작
- 아래 템플릿을 복사해 ChatGPT에 붙여넣기
- 여러분의 아이디어를 간단히 설명(예: "숲 속을 걷는 판다")
- ChatGPT가 생성한 프롬프트를 복사해 메모장에 저장

#### (C) 복붙 블록: ChatGPT 프롬프트 생성 템플릿

```
너는 AI 영상 생성 전문 프롬프트 엔지니어야.
나는 [여기에 아이디어 입력: 예 - 숲 속을 걷는 판다] 영상을 만들고 싶어.

아래 5가지 요소를 반드시 포함해서 100자 이내로 간결한 영어 프롬프트를 만들어줘:
1. 주요 피사체 (Subject): 누가/무엇이
2. 액션/움직임 (Action): 무엇을 하는지
3. 환경/배경 (Environment): 어디서
4. 카메라 움직임 (Camera): 어떤 앵글/샷
5. 조명/분위기 (Lighting): 어떤 느낌

출력 형식:
[카메라 움직임]: [주요 피사체] + [액션], [환경]. [조명/분위기]

예시:
"Wide tracking shot: A giant panda wearing glasses, slowly walking through a bamboo forest. Soft morning sunlight, cinematic color palette."

이제 내 아이디어로 만들어줘.
```

**이 템플릿을 Kling AI, Hailuo AI, Runway Gen-3 등 어디든 붙여넣을 수 있습니다.**

#### (D) 예시

**입력 (ChatGPT에 전달):**
"사무실에서 커피를 마시며 노트북으로 일하는 여성"

**출력 (ChatGPT 생성):**
```
Close-up dolly-in: A young woman in a white blouse, sipping coffee while typing on a laptop in a modern office. Warm afternoon light through windows, professional cinematic tone.
```',
  '- (X) 프롬프트에 "professional, 4K, high quality" 같은 무의미한 단어 나열
- (V) 이런 단어는 AI가 무시함. 대신 **구체적 장면 묘사**에 집중
- (X) 100자 넘는 긴 프롬프트 작성
- (V) AI는 **간결한 지시**를 더 잘 이해함
- (X) ChatGPT 출력을 그대로 사용하지 않고 손으로 다시 씀
- (V) ChatGPT 결과를 **복사-붙여넣기**로 그대로 활용',
  '- [ ] 프롬프트에 5대 요소(피사체, 액션, 환경, 카메라, 조명)가 모두 들어갔는가?
- [ ] 한 문장이 100자 이내로 간결한가?
- [ ] 영어로 작성되어 있는가? (대부분 AI 도구는 영어 프롬프트가 더 정확)
- [ ] 저장했는가? (이후 변형 생성에 재사용)'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET
  title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 2
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  2,
  '무료 AI 도구 계정 만들고 첫 영상 생성하기',
  'Kling AI 계정을 만들고 첫 영상을 생성합니다.',
  'Kling AI 계정을 만들고 Step 1에서 만든 프롬프트로 첫 영상을 생성한다.',
  'Kling AI 계정 생성 완료, 첫 영상 생성 클릭 후 대기열에 등록됨, 생성된 영상 1개 이상 다운로드 완료',
  '프롬프트만 잘 만들어도 반은 성공이지만, **실제 도구에 입력해야 결과**가 나옵니다. Kling AI는 무료 크레딧을 매일 제공하므로 돈 쓰지 않고 매일 연습할 수 있어 초보자에게 최적입니다.',
  '#### (B) 해야 할 일

- Kling AI 공식 사이트(klingai.com) 접속
- 회원가입 (구글/이메일 계정 연동)
- 메인 화면에서 "Create Video" 또는 "Text to Video" 선택
- Step 1에서 만든 프롬프트 붙여넣기
- 설정 확인: 5초 / Standard 모드 (무료는 Professional 모드 불가)
- "Generate" 클릭 후 대기 (보통 2~5분 소요)
- 생성된 영상 미리보기 후 다운로드

#### (E) 분기: 시간 부족 vs 보통

**시간 부족 (15분 이내):**
- Kling AI만 사용
- 5초 영상 1개만 생성
- 다운로드 후 Step 3으로 바로 이동

**보통 (30분~1시간):**
- Kling AI에서 3~5개 변형 생성 (프롬프트 일부 수정)
- Hailuo AI 계정도 만들어 같은 프롬프트로 비교 생성
- 두 도구 결과물 비교 후 더 나은 것 선택',
  '- (X) 한 번 생성 후 "이게 다야?"라고 실망
- (V) AI 영상은 **확률 게임**. 같은 프롬프트도 3~5번 돌리면 그중 1~2개는 대박
- (X) 무료 크레딧 아껴쓰려고 생성 안 함
- (V) Kling은 **매일 크레딧이 리필**됨. 오늘 안 쓰면 내일 사라지니 매일 연습!
- (X) 생성 중 탭을 닫음
- (V) 생성 중에도 **탭을 열어두거나 "My Creations"에서 확인** 가능',
  '- [ ] 계정 가입 완료
- [ ] 프롬프트 입력 후 "Generate" 클릭 확인
- [ ] 생성된 영상이 5초 길이로 정상 출력되었는가?
- [ ] 다운로드 파일이 로컬 폴더에 저장되었는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 3
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  3,
  '프롬프트 반복 개선으로 원하는 결과 얻기',
  '프롬프트를 수정하고 반복 생성하여 최상의 결과를 얻습니다.',
  '첫 결과물을 보고 프롬프트를 개선해 더 나은 영상을 생성한다.',
  '동일 아이디어로 최소 3가지 변형 프롬프트 작성, 그중 1개 이상 "이거다!" 싶은 만족스러운 결과 획득',
  'AI 영상 생성에서 **한 방에 완벽한 결과를 얻는 확률은 10% 이하**입니다. 프로들도 8~12개 변형을 생성해 그중 1~2개를 선택합니다. 프롬프트 개선은 시행착오가 아니라 **전략적 실험**입니다.',
  '#### (B) 해야 할 일

- Step 2 결과물 관찰: 무엇이 마음에 들고 안 드는가?
- 개선 방향 정하기 (카메라/조명/액션 중 1가지 변경)
- ChatGPT에 피드백 전달 후 개선된 프롬프트 생성
- Kling AI에서 다시 생성
- 3~5번 반복해 최고 결과물 선정

#### (C) 복붙 블록: ChatGPT 프롬프트 개선 템플릿

```
이전에 만들어준 프롬프트:
"[여기에 이전 프롬프트 붙여넣기]"

생성된 결과물에서 이런 부분이 아쉬웠어:
- [예: 카메라가 너무 멀었음 / 조명이 어두웠음 / 배경이 단조로웠음]

아래 개선 방향을 반영해서 새로운 프롬프트를 만들어줘:
- [예: 카메라를 더 가까이 클로즈업 / 따뜻한 골든아워 조명 / 배경에 디테일 추가]

동일한 출력 형식으로 부탁해.
```

#### (D) 예시

**개선 전 프롬프트:**
```
Wide shot: A panda walking in a bamboo forest. Morning light.
```

**피드백:**
- 판다가 너무 작게 보임
- 배경이 단조로움

**개선 후 프롬프트:**
```
Medium close-up tracking shot: A giant panda wearing round glasses, slowly walking through a dense bamboo forest with mist. Soft golden morning sunlight filtering through leaves, cinematic depth of field.
```

#### (E) 분기: 초급 vs 중급

**초급 사용자:**
- 한 번에 1가지 요소만 변경 (예: 카메라 앵글만 바꾸기)
- 3가지 변형만 생성
- ChatGPT에 의존해 개선

**중급 사용자:**
- 2가지 요소 동시 변경 (예: 카메라 + 조명)
- 5~8가지 변형 생성
- 직접 프롬프트 수정 (ChatGPT 없이)',
  '- (X) 프롬프트를 완전히 새로 쓰기
- (V) **기존 프롬프트의 일부만 수정**해야 변화를 정확히 파악 가능
- (X) 여러 요소를 한 번에 다 바꿈
- (V) **한 번에 1~2개 요소만** 변경해야 무엇이 효과 있었는지 알 수 있음
- (X) 실패한 프롬프트를 버림
- (V) 실패도 **학습 데이터**. 어떤 표현이 안 통하는지 기록해두기',
  '- [ ] 최소 3가지 변형 프롬프트 생성했는가?
- [ ] 각 변형마다 "무엇을 바꿨는지" 명확히 기록했는가?
- [ ] 그중 1개 이상 만족스러운 결과를 얻었는가?
- [ ] 개선 전후 영상을 비교해 차이를 이해했는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 4
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  4,
  'Image-to-Video로 정밀 제어하기',
  '이미지 생성 도구와 결합하여 결과물의 일관성을 높입니다.',
  'AI 이미지 도구로 정확한 첫 프레임을 만든 후, 이를 영상으로 변환해 일관성을 높인다.',
  'Midjourney 등에서 정밀한 이미지 1장 생성, Kling AI의 Image-to-Video 기능에 입력, 이미지가 정확히 반영된 5초 영상 생성',
  'Text-to-Video는 자유도가 높지만 **예측 불가능**합니다. 반면 **Image-to-Video는 출발점(이미지)을 고정**하므로 일관성과 제어력이 급상승합니다.',
  '#### (B) 해야 할 일

- Midjourney, Leonardo AI, DALL-E 등에서 원하는 장면 이미지 생성
- 이미지 다운로드 (1080p 이상 권장)
- Kling AI에서 "Image to Video" 모드 선택
- 이미지 업로드 후 **움직임만 설명하는 간결한 프롬프트** 입력
- 생성 후 이미지와 영상 비교

#### (C) 복붙 블록: Image-to-Video 프롬프트 공식

**공식:**
```
[피사체] + [움직임 동사], [배경 변화 설명]
```

**예시:**
```
The panda slowly blinks and tilts its head to the left, bamboo leaves gently sway in the background.
```

**주의:** 이미지에 없는 요소를 추가하려 하지 마세요. **이미지 속 요소의 움직임만 설명**하세요.

#### (D) 예시

**시나리오:** 사무실에서 커피를 마시는 여성 이미지를 영상으로 만들기

**1단계 (이미지 생성 프롬프트):**
```
A young woman in a white blouse sitting at a modern office desk, holding a coffee cup, looking at a laptop. Warm afternoon sunlight through large windows, cinematic lighting, realistic style. --ar 16:9
```

**2단계 (Image-to-Video 프롬프트):**
```
She lifts the coffee cup to her lips and takes a sip, then returns the cup to the desk. Subtle laptop screen glow.
```',
  '- (X) 이미지에 없는 새로운 요소를 프롬프트에 추가
- (V) **이미지 속 요소만 움직이게** 하세요. 없는 걸 만들려 하면 실패율 급증
- (X) 저해상도(720p 이하) 이미지 사용
- (V) **1080p 이상** 이미지를 사용해야 영상 품질 유지
- (X) 복잡한 움직임 프롬프트 (예: "걷다가 뛰다가 점프")
- (V) **한 가지 단순한 액션**만 지정 (예: "천천히 고개 끄덕이기")',
  '- [ ] 이미지가 1080p 이상 해상도인가?
- [ ] 프롬프트가 "이미지 속 요소의 움직임"만 설명하는가?
- [ ] 생성된 영상이 이미지와 일관성을 유지하는가?
- [ ] 부자연스러운 모핑(morphing)이 없는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 5
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  5,
  '여러 AI 도구 비교하고 최적 도구 찾기',
  '다양한 AI 영상 도구의 특성을 비교하고 최적의 도구를 선택합니다.',
  'Kling, Hailuo, Pika 3가지 도구에 같은 프롬프트를 입력해 결과를 비교하고, 자신에게 맞는 도구를 선택한다.',
  '동일 프롬프트로 3가지 도구에서 각 1개 이상 영상 생성, 비교표 작성, 자신이 주로 사용할 도구 1개 결정',
  '**AI 영상 도구마다 강점이 다릅니다.** Kling은 리얼리즘, Hailuo는 속도, Pika는 스타일 효과가 강합니다. 한 가지 도구만 쓰면 그 도구의 한계에 갇히게 됩니다.',
  '#### (B) 해야 할 일

- Step 3에서 만든 최고의 프롬프트 1개 선택
- Kling AI, Hailuo AI, Pika Labs에 순서대로 입력
- 각 도구에서 생성된 영상 다운로드 (같은 폴더에 저장)
- 영상을 나란히 재생하며 비교
- 비교 메모 작성

#### (C) 복붙 블록: 도구 비교 템플릿

```
테스트 프롬프트:
"[여기에 프롬프트 입력]"

| 항목 | Kling AI | Hailuo AI | Pika Labs |
|------|----------|-----------|-----------|
| 생성 속도 | [예: 180초] | [예: 90초] | [예: 120초] |
| 화질 | [예: 4점] | [예: 3점] | [예: 4점] |
| 프롬프트 반영도 | [예: 4점] | [예: 5점] | [예: 3점] |
| 부자연스러운 모핑 | [예: 없음] | [예: 약간] | [예: 있음] |
| 스타일 | [예: 리얼] | [예: 리얼] | [예: 아트] |
```',
  '- (X) 한 도구만 써보고 "AI 영상은 이 정도구나" 판단
- (V) **최소 3가지 도구 비교** 필수. 같은 프롬프트도 도구마다 결과 천차만별
- (X) 무료 크레딧 다 쓰고 포기
- (V) Kling/Hailuo는 **매일 크레딧 리필**. 내일 다시 와서 연습하세요
- (X) 최신 모델 업데이트를 놓침
- (V) 2025년은 AI 영상 전쟁 중. **분기마다 새 모델 출시**되니 뉴스 체크',
  '- [ ] 3가지 도구에서 모두 영상 생성 완료했는가?
- [ ] 비교표를 작성해 각 도구의 강약점을 정리했는가?
- [ ] 자신의 주요 용도에 맞는 도구를 선택했는가?
- [ ] 각 도구의 무료 크레딧 리필 주기를 파악했는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 6
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  6,
  '카메라 워크와 조명 키워드로 시네마틱 품질 끌어올리기',
  '전문 영화 용어를 활용해 영상의 품질을 극적으로 향상시킵니다.',
  '전문 영화 용어(카메라 앵글, 조명 스타일)를 프롬프트에 추가해 영상 퀄리티를 극적으로 향상시킨다.',
  '카메라 워크 키워드 10개 이상 암기, 조명 키워드 5개 이상 암기, 동일 장면에 카메라/조명만 바꿔 3가지 변형 생성',
  '초보자 프롬프트와 프로 프롬프트의 **결정적 차이는 카메라/조명 용어** 사용입니다. 이 단계를 마스터하면 여러분의 영상이 "유튜브 숏츠" 레벨에서 "넷플릭스 오프닝" 레벨로 진화합니다.',
  '#### (B) 해야 할 일

- 아래 카메라/조명 키워드 리스트 복사해 메모장에 저장
- 기존 프롬프트 1개 선택
- 카메라 워크만 3가지로 바꿔서 생성
- 조명만 3가지로 바꿔서 생성
- 총 6개 변형 중 가장 인상적인 것 선정

#### (C) 복붙 블록: 카메라 워크 & 조명 키워드 사전

**카메라 앵글/샷 타입:**
- `Wide shot`, `Close-up`, `Low angle`, `High angle`, `Drone shot`

**카메라 움직임:**
- `Static shot`, `Tracking shot`, `Pan left/right`, `Zoom in/out`, `Orbit around`

**조명 스타일:**
- `Golden hour`, `Soft lighting`, `Backlight`, `Silhouette`, `Neon light`, `Cinematic lighting`',
  '- (X) 카메라 용어를 한꺼번에 너무 많이 넣음 (예: "Wide tracking dolly crane shot")
- (V) **1개 앵글 + 1개 움직임**만 사용 (예: "Wide tracking shot")
- (X) 한국어로 카메라 용어 입력
- (V) 반드시 **영어 원어** 사용
- (X) 조명 키워드를 빼먹음
- (V) 조명이 분위기의 80%. **항상 조명 키워드 1개 이상** 추가',
  '- [ ] 카메라 워크 키워드 5개 이상 암기했는가?
- [ ] 조명 키워드 3개 이상 암기했는가?
- [ ] 동일 장면에 카메라/조명만 바꿔 최소 3개 변형 생성했는가?
- [ ] 변형 간 분위기 차이를 명확히 느꼈는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 7
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  7,
  '영상 품질 향상 - 업스케일과 편집 마무리',
  '생성된 영상을 4K로 업스케일하고 편집하여 완성도를 높입니다.',
  'AI 도구에서 생성된 720p/1080p 영상을 4K로 업스케일하고, 간단한 편집으로 완성도를 높인다.',
  'AI 업스케일 도구로 영상을 4K로 변환, 자막/배경음악/트랜지션 중 1가지 이상 추가, 최종 영상 내보내기',
  'AI 영상 도구가 생성하는 기본 해상도는 **720p~1080p**입니다. 유튜브나 포트폴리오에서는 4K가 표준이 되어가고 있고, 업스케일 없이 올리면 "저품질"로 인식될 수 있습니다. 또한 편집은 **아마추어 vs 프로의 차이**를 만듭니다.',
  '#### (B) 해야 할 일

- Step 6까지 만든 최고의 영상 1개 선택
- AI 업스케일 도구(Topaz Video AI, AVCLabs 등)에 업로드 및 4K 변환
- CapCut, DaVinci Resolve 등에서 자막/음악 추가
- 플랫폼 맞춤 포맷 설정 후 내보내기

#### (C) 복붙 블록: 편집 체크리스트

```
[ ] 업스케일 완료 (720p → 1080p 또는 4K)
[ ] 인트로 추가 (3초 이내)
[ ] 자막 추가 (핵심 메시지 1~2문장)
[ ] 배경음악 추가 (저작권 프리 음원)
[ ] 색보정 (밝기/대비/채도 조정)
[ ] 아웃트로 추가 (CTA)
[ ] 플랫폼 맞춤 포맷 설정 (Shorts: 9:16)
[ ] 최종 내보내기 (H.264, MP4)
```',
  '- (X) 업스케일 없이 720p 그대로 업로드
- (V) 유튜브/인스타는 **최소 1080p** 필수. 4K면 알고리즘 우대 받음
- (X) 배경음악에 저작권 음원 사용
- (V) YouTube Audio Library 등 **저작권 프리** 음원만 사용
- (X) 자막을 너무 많이, 길게 넣음
- (V) 자막은 **핵심 1~2문장**만. 너무 많으면 산만함',
  '- [ ] 영상이 1080p 이상 해상도인가?
- [ ] 자막이 가독성 있게 배치되었는가?
- [ ] 배경음악이 영상 분위기와 잘 어울리는가?
- [ ] 플랫폼 맞춤 포맷(16:9 또는 9:16)이 정확한가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 8
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  8,
  '프롬프트 라이브러리 구축과 반복 사용 시스템 만들기',
  '성공한 프롬프트를 체계적으로 정리하여 재사용 가능한 시스템을 만듭니다.',
  '성공한 프롬프트를 체계적으로 저장하고, 템플릿화해 빠르게 재사용할 수 있는 시스템을 구축한다.',
  '프롬프트 라이브러리 생성, 성공작 10개 카테고리별 정리, 1개 이상의 템플릿 테스트',
  'AI 영상 제작의 핵심은 **"반복 가능한 시스템"**입니다. 성공한 프롬프트를 모아두고 템플릿화하면, 새 프로젝트에서 **80% 시간 절약**이 가능합니다.',
  '#### (B) 해야 할 일

- Notion, Google Docs 등 선택하여 "프롬프트 라이브러리" 생성
- 성공 프롬프트 10개 메타데이터와 함께 저장
- 템플릿 1개 만들기 (브라켓 플레이스홀더 활용)

#### (C) 복붙 블록: 프롬프트 라이브러리 템플릿

```
# AI 영상 프롬프트 라이브러리

## 템플릿 (재사용 가능)

### 템플릿 #1: 제품 쇼케이스
**구조:**
"[카메라 앵글]: A [제품명] placed on [표면], [조명] lighting, [카메라 움직임] to reveal [디테일]."

**사용법:**
1. [제품명], [표면], [디테일]만 교체
2. Kling AI 권장
```',
  '- (X) 프롬프트를 저장하지 않고 매번 새로 작성
- (V) **성공한 건 즉시 저장**. 나중에 찾으려면 기억 안 남
- (X) 프롬프트만 저장하고 메타데이터(도구, 성공률) 누락
- (V) **"어느 도구에서 잘 됐는지"** 메모 필수
- (X) 템플릿을 너무 복잡하게 만듦
- (V) 템플릿은 **3개 이하 변수**만. 단순할수록 재사용 쉬움',
  '- [ ] 프롬프트 라이브러리 페이지를 만들었는가?
- [ ] 최소 10개 프롬프트가 카테고리별로 정리되어 있는가?
- [ ] 각 프롬프트에 도구명, 성공률, 용도가 기록되었는가?
- [ ] 템플릿 1개 이상을 만들어 실제로 사용해 봤는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 9
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  9,
  '실전 프로젝트 완주 - 15초 스토리텔링 영상 만들기',
  '여러 클립을 연결하여 하나의 완결된 스토리를 만듭니다.',
  '3~5개의 AI 영상 클립을 연결해 하나의 완결된 15초 스토리 영상을 제작한다.',
  '스토리보드 작성, 각 구간별 영상 생성, 편집 도구로 연결 및 자막/음악 추가, 최종 15초 영상 완성',
  '**단일 5초 클립은 "기술 데모"에 불과**합니다. 진짜 콘텐츠는 여러 클립을 연결한 **"스토리"**입니다. 이 단계에서 "AI 영상 감독"으로 진화합니다.',
  '#### (B) 해야 할 일

- 15초 스토리 아이디어 구상
- 3~5개 장면으로 나눈 스토리보드 작성
- 각 장면마다 프롬프트 설계 및 생성
- 클립 연결 및 편집

#### (C) 복붙 블록: 15초 스토리보드 템플릿

```
# 프로젝트: [제목 입력]
### Scene 1 (0~3초) - 시작/훅
**프롬프트:** "[카메라]: [피사체], [액션], [환경]. [조명]"

### Scene 2 (3~8초) - 중간/전개
**프롬프트:** "[카메라]: [피사체], [이어지는 액션], [같은 환경]. [같은 조명]"

### Scene 3 (8~12초) - 클라이맥스
**프롬프트:** "[카메라]: [피사체], [마지막 액션], [환경]. [같은 조명]"
```',
  '- (X) 각 클립의 스타일(조명, 색감)이 제각각
- (V) 모든 프롬프트에 **같은 조명 키워드** 사용 (예: 전부 "golden hour")
- (X) 트랜지션을 너무 많이, 화려하게 사용
- (V) 트랜지션은 **최소화**. 자연스러운 Cut이 가장 프로페셔널
- (X) 음악 볼륨이 너무 크거나 작음
- (V) 음악은 **배경**이 목적. 영상보다 조용하게 (-10dB)',
  '- [ ] 스토리보드에 시작-중간-끝 구조가 명확한가?
- [ ] 모든 클립의 스타일(조명, 색감)이 일관성 있는가?
- [ ] 편집 후 15초 이내로 타이트하게 완성되었는가?
- [ ] 자막과 음악이 자연스럽게 통합되었는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 10
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  10,
  '배치 생성 전략으로 생산성 10배 끌어올리기',
  '대량 생성 및 선별 프로세스를 통해 작업 효율을 극대화합니다.',
  '한 번에 10~20개 프롬프트를 일괄 생성하고, 결과물 중 베스트만 선별하는 프로 워크플로우를 구축한다.',
  'ChatGPT로 10가지 변형 확장, Kling/Hailuo에서 1시간 이내 10개 생성, 상위 2~3개 선정 및 기준 문서화',
  '**초보자는 "1개 완벽한 프롬프트"를 찾으려 합니다. 프로는 "10개 괜찮은 프롬프트"를 만들고 최고를 고릅니다.** 이 전략을 익히면 콘텐츠 제작 속도가 10배 이상 빨라집니다.',
  '#### (B) 해야 할 일

- ChatGPT에 "10가지 변형 생성" 요청
- Kling AI에서 10개 프롬프트 순차 입력 (대기열 쌓기)
- 10개 결과물 미리보기 후 즉석 평가
- 4점 이상만 다운로드

#### (C) 복붙 블록: 배치 생성 ChatGPT 프롬프트

```
**기본 템플릿:**
"[카메라]: A [피사체] [액션] in [환경]. [조명]"

**변형 규칙:**
1. 피사체는 유지하되 액션을 다양화
2. 카메라 앵글을 5가지 이상 섞기
3. 환경을 3가지 이상 다르게
4. 조명을 3가지 이상

10가지 다양한 변형 프롬프트를 만들어줘.
```',
  '- (X) 10개를 하나씩 생성하고 기다림
- (V) **대기열에 한꺼번에 쌓아두고** 다른 작업 병행
- (X) 모든 결과물을 다운로드
- (V) **미리보기에서 1차 선별** 후 베스트만 다운로드
- (X) 왜 좋은지/나쁜지 기록 안 함
- (V) 선정 이유를 간단히 메모',
  '- [ ] ChatGPT로 10개 변형 프롬프트를 생성했는가?
- [ ] Kling/Hailuo 대기열에 10개를 한 번에 입력했는가?
- [ ] 10개 중 상위 2~3개를 선정했는가?
- [ ] 선정 기준을 문서화했는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Step 11
INSERT INTO public.guide_steps (guide_id, step_order, title, summary, goal, done_when, why_matters, content, tips, checklist)
VALUES (
  14,
  11,
  '최종 산출물 점검 및 배포 전략',
  '완성된 영상을 최적화하여 플랫폼에 배포하고 성과를 분석합니다.',
  '완성된 영상의 품질을 최종 점검하고, 플랫폼별 최적화 전략을 수립해 배포한다.',
  '최종 영상 스펙 확인, SEO 최적화, 1개 이상 플랫폼 업로드, 다음 프로젝트 아이디어 작성',
  '**훌륭한 영상을 만들어도 배포 전략이 없으면 아무도 보지 않습니다.** 플랫폼마다 최적화 전략이 다릅니다. 성과 추적을 통해 다음 프로젝트를 개선할 수 있습니다.',
  '#### (B) 해야 할 일

- 제목/설명/태그 작성 (SEO)
- 썸네일 제작
- 업로드 또는 예약 게시
- 성과 추적 시트 생성

#### (C) 복붙 블록: 플랫폼별 최적화 체크리스트

```
## YouTube Shorts / Instagram Reels / TikTok
- [ ] 해상도: 1080x1920 (9:16)
- [ ] 자막 내장, 워터마크 최소화
- [ ] 업로드 시간 준수 (트래픽 피크)
```',
  '- (X) 같은 제목/설명을 모든 플랫폼에 복붙
- (V) 플랫폼마다 **문화와 용어**가 다름. 맞춤 최적화 필수
- (X) 업로드 후 방치
- (V) **첫 1시간이 골든타임**. 댓글 적극 답변
- (X) 실패한 영상을 삭제
- (V) 실패도 데이터. **왜 안 됐는지 분석** 후 다음에 반영',
  '- [ ] 영상이 플랫폼 권장 사양을 충족하는가?
- [ ] 제목/설명에 SEO 키워드가 포함되어 있는가?
- [ ] 썸네일이 클릭을 유도할 만큼 임팩트 있는가?
- [ ] 게시 후 성과를 추적할 시스템이 준비되었는가?'
) ON CONFLICT (guide_id, step_order) DO UPDATE SET title = EXCLUDED.title, content = EXCLUDED.content, goal = EXCLUDED.goal, done_when = EXCLUDED.done_when, why_matters = EXCLUDED.why_matters, tips = EXCLUDED.tips, checklist = EXCLUDED.checklist;

-- Prompts Insertion (Prompt Pack)
-- We'll attach prompts to all relevant steps

-- Prompt #1: Basic Text-to-Video (Step 1, 2, 3)
-- All guide_prompts have been moved to guide_sections (prompt_pack).
-- See: guide_prompts were deleted and migrated to guide_sections for Guide 14.
