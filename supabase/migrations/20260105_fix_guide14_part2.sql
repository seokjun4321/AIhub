-- Part 2: Steps 4-6
-- Guide 14 Content Update - FIXED with dollar-quoted strings

-- Step 4
UPDATE guide_steps
SET
  title = 'Image-to-Video로 정밀 제어하기',
  goal = $$AI 이미지 도구로 정확한 첫 프레임을 만든 후, 이를 영상으로 변환해 일관성을 높인다.$$,
  done_when = $$- Midjourney, Leonardo AI 등에서 정밀한 이미지 1장 생성
- 해당 이미지를 Kling AI의 Image-to-Video 기능에 입력
- 이미지가 정확히 반영된 5초 영상 생성$$,
  why_matters = $$Text-to-Video는 자유도가 높지만 **예측 불가능**합니다. 캐릭터 얼굴이 매번 다르거나, 원하는 구도가 안 나올 수 있죠.

반면 **Image-to-Video는 출발점(이미지)을 고정**하므로 일관성과 제어력이 급상승합니다. 특히 브랜딩이 중요한 비즈니스 영상이나 캐릭터 중심 스토리를 만들 때 필수 기법입니다.$$,
  content = $$#### (B) 해야 할 일
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
`A young woman in a white blouse sitting at a modern office desk, holding a coffee cup, looking at a laptop. Warm afternoon sunlight through large windows, cinematic lighting, realistic style. --ar 16:9`

**2단계 (Image-to-Video 프롬프트):**
`She lifts the coffee cup to her lips and takes a sip, then returns the cup to the desk. Subtle laptop screen glow.`

#### (E) 분기: 도구 선택
**무료 이미지 생성 도구:**
- Leonardo AI (무료 일일 크레딧)
- Bing Image Creator (DALL-E 3 기반)

**프리미엄 도구 (최고 품질):**
- Midjourney (월 $10)
- DALL-E 3 (ChatGPT Plus)$$,
  tips = $$- (X) 실수: 이미지에 없는 새로운 요소를 프롬프트에 추가
- (V) 팁: **이미지 속 요소만 움직이게** 하세요. 없는 걸 만들려 하면 실패율 급증
- (X) 실수: 저해상도(720p 이하) 이미지 사용
- (V) 팁: **1080p 이상** 이미지를 사용해야 영상 품질 유지
- (X) 실수: 복잡한 움직임 프롬프트 (예: "걷다가 뛰다가 점프")
- (V) 팁: **한 가지 단순한 액션**만 지정 (예: "천천히 고개 끄덕이기")$$,
  checklist = $$- [ ] 이미지가 1080p 이상 해상도인가?
- [ ] 프롬프트가 "이미지 속 요소의 움직임"만 설명하는가?
- [ ] 생성된 영상이 이미지와 일관성을 유지하는가?
- [ ] 부자연스러운 모핑(morphing)이 없는가?$$
WHERE guide_id = 14 AND step_order = 4;

-- Step 5
UPDATE guide_steps
SET
  title = '여러 AI 도구 비교하고 최적 도구 찾기',
  goal = $$Kling, Hailuo, Pika 3가지 도구에 같은 프롬프트를 입력해 결과를 비교하고, 자신에게 맞는 도구를 선택한다.$$,
  done_when = $$- 동일 프롬프트로 3가지 도구에서 각 1개 이상 영상 생성
- 비교표 작성 (속도, 품질, 스타일, 일관성 평가)
- 자신이 주로 사용할 도구 1개 결정$$,
  why_matters = $$**AI 영상 도구마다 강점이 다릅니다.** Kling은 리얼리즘, Hailuo는 속도, Pika는 스타일 효과가 강합니다.

한 가지 도구만 쓰면 그 도구의 한계에 갇히게 됩니다. 여러 도구를 비교 실험해 보면 "어떤 프로젝트에 어떤 도구가 적합한지" 감이 생기고, 프로젝트별로 도구를 전략적으로 선택할 수 있습니다.$$,
  content = $$#### (B) 해야 할 일
- Step 3에서 만든 최고의 프롬프트 1개 선택
- Kling AI, Hailuo AI, Pika Labs에 순서대로 입력
- 각 도구에서 생성된 영상 다운로드 (같은 폴더에 저장)
- 영상을 나란히 재생하며 비교
- 비교 메모 작성 (아래 템플릿 활용)

#### (C) 복붙 블록: 도구 비교 템플릿
```
테스트 프롬프트:
"[여기에 프롬프트 입력]"

| 항목 | Kling AI | Hailuo AI | Pika Labs |
|------|----------|-----------|-----------|
| 생성 속도 (초) | [예: 180초] | [예: 90초] | [예: 120초] |
| 화질 (1~5점) | [예: 4점] | [예: 3점] | [예: 4점] |
| 프롬프트 반영도 (1~5점) | [예: 4점] | [예: 5점] | [예: 3점] |
| 부자연스러운 모핑 (있음/없음) | [예: 없음] | [예: 약간] | [예: 있음] |
| 스타일 (리얼/아트/시네마틱) | [예: 리얼] | [예: 리얼] | [예: 아트] |
| 무료 크레딧 (일일) | [예: 66크레딧] | [예: 100크레딧] | [예: 5개] |
| 종합 점수 (1~5점) | [ ] | [ ] | [ ] |

선택 도구: [  ]
선택 이유: [  ]
```

#### (E) 분기: 프로젝트 유형별 도구 추천
**빠른 프로토타입/소셜 미디어 콘텐츠:**
- Hailuo AI (속도 우선)

**브랜딩/포트폴리오/고품질 영상:**
- Kling AI (품질 우선)

**실험적 아트/뮤직비디오:**
- Pika Labs (스타일 효과)

**비즈니스 프레젠테이션:**
- Runway Gen-3 (유료지만 전문적 제어 가능)$$,
  tips = $$- (X) 실수: 한 도구만 써보고 "AI 영상은 이 정도구나" 판단
- (V) 팁: **최소 3가지 도구 비교** 필수. 같은 프롬프트도 도구마다 결과 천차만별
- (X) 실수: 무료 크레딧 다 쓰고 포기
- (V) 팁: Kling/Hailuo는 **매일 크레딧 리필**. 내일 다시 와서 연습하세요
- (X) 실수: 최신 모델 업데이트를 놓침
- (V) 팁: 2025년은 AI 영상 전쟁 중. **분기마다 새 모델 출시**되니 뉴스 체크$$,
  checklist = $$- [ ] 3가지 도구에서 모두 영상 생성 완료했는가?
- [ ] 비교표를 작성해 각 도구의 강약점을 정리했는가?
- [ ] 자신의 주요 용도에 맞는 도구를 선택했는가?
- [ ] 각 도구의 무료 크레딧 리필 주기를 파악했는가?$$
WHERE guide_id = 14 AND step_order = 5;

-- Step 6
UPDATE guide_steps
SET
  title = '카메라 워크와 조명 키워드로 시네마틱 품질 끌어올리기',
  goal = $$전문 영화 용어(카메라 앵글, 조명 스타일)를 프롬프트에 추가해 영상 퀄리티를 극적으로 향상시킨다.$$,
  done_when = $$- 카메라 워크 키워드 10개 이상 암기
- 조명 키워드 5개 이상 암기
- 동일 장면에 카메라/조명만 바꿔 3가지 변형 생성
- 변형 간 분위기 차이를 명확히 체감$$,
  why_matters = $$초보자 프롬프트와 프로 프롬프트의 **결정적 차이는 카메라/조명 용어** 사용입니다.

"판다가 걷는다" vs "Wide tracking shot: A panda walking, golden hour backlight, shallow depth of field" — 같은 장면이지만 후자는 영화 같은 느낌을 줍니다. 이 단계를 마스터하면 여러분의 영상이 "유튜브 숏츠" 레벨에서 "넷플릭스 오프닝" 레벨로 진화합니다.$$,
  content = $$#### (B) 해야 할 일
- 아래 카메라/조명 키워드 리스트 복사해 메모장에 저장
- 기존 프롬프트 1개 선택
- 카메라 워크만 3가지로 바꿔서 생성 (예: Wide → Close-up → Drone shot)
- 조명만 3가지로 바꿔서 생성 (예: Golden hour → Neon light → Silhouette)
- 총 6개 변형 중 가장 인상적인 것 선정

#### (C) 복붙 블록: 카메라 워크 & 조명 키워드 사전
**카메라 앵글/샷 타입:**
- `Wide shot`: 전경, 전체 장면
- `Medium shot`: 허리 위 중간 샷
- `Close-up`: 얼굴/물체 클로즈업
- `Drone shot`: 드론 공중 촬영
- `POV`: 1인칭 시점

**카메라 움직임:**
- `Static shot`: 고정 카메라
- `Tracking shot`: 피사체를 따라 이동
- `Pan left/right`: 좌우 회전
- `Zoom in/out`: 줌인/줌아웃

**조명 스타일:**
- `Golden hour`: 일몰/일출의 따뜻한 빛
- `Soft lighting`: 부드러운 확산광
- `Hard lighting`: 강한 그림자, 극적
- `Silhouette`: 실루엣 (역광)
- `Neon light`: 네온 조명
- `Cinematic lighting`: 영화 같은 조명

#### (D) 예시
**변형 1 (카메라: Wide → Close-up):**
`Close-up shot: A panda's face as it walks through a bamboo forest, golden hour lighting.`

**변형 2 (조명: Golden hour → Neon):**
`Wide shot: A panda walking in a bamboo forest, neon blue and pink lighting, cyberpunk aesthetic.`

#### (E) 분기: 스타일 선택
**리얼리즘 (다큐/비즈니스):**
- `Natural light`, `Static shot`, `Medium shot`

**시네마틱 (MV/영화):**
- `Golden hour`, `Tracking shot`, `Cinematic lighting`

**아트/실험적 (SNS/포트폴리오):**
- `Neon light`, `Extreme close-up`, `Dutch angle`$$,
  tips = $$- (X) 실수: 카메라 용어를 한꺼번에 너무 많이 넣음 (예: "Wide tracking dolly crane shot")
- (V) 팁: **1개 앵글 + 1개 움직임**만 사용 (예: "Wide tracking shot")
- (X) 실수: 한국어로 카메라 용어 입력 (예: "클로즈업")
- (V) 팁: 반드시 **영어 원어** 사용
- (X) 실수: 조명 키워드를 빼먹음
- (V) 팁: 조명이 분위기의 80%. **항상 조명 키워드 1개 이상** 추가$$,
  checklist = $$- [ ] 카메라 워크 키워드 5개 이상 암기했는가?
- [ ] 조명 키워드 3개 이상 암기했는가?
- [ ] 동일 장면에 카메라/조명만 바꿔 최소 3개 변형 생성했는가?
- [ ] 변형 간 분위기 차이를 명확히 느꼈는가?$$
WHERE guide_id = 14 AND step_order = 6;
