-- Refactor Guide 14 Content (Steps 1-11) - FINAL VERSION
-- Based on User's provided "ChatGPT 프롬프트 엔지니어링으로 AI 영상 제작하기" full text
-- Implements dynamic examples:
-- Step 1: Input/Output (2-col)
-- Step 3: Input/Process/Output (3-col)
-- Others: General Example (Standard Markdown)

-- Step 1
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
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
```

#### (E) 분기
없음 (이 단계는 분기 없음)

#### 스텝 하단 고정 코멘트
(이 부분은 tips와 checklist 컬럼으로 분리되어 저장됨)$$,
  tips = $$- (X) 실수: 프롬프트에 "professional, 4K, high quality" 같은 무의미한 단어 나열
- (V) 팁: 이런 단어는 AI가 무시함. 대신 **구체적 장면 묘사**에 집중
- (X) 실수: 100자 넘는 긴 프롬프트 작성
- (V) 팁: AI는 **간결한 지시**를 더 잘 이해함
- (X) 실수: ChatGPT 출력을 그대로 사용하지 않고 손으로 다시 씀
- (V) 팁: ChatGPT 결과를 **복사-붙여넣기**로 그대로 활용$$,
  checklist = $$- [ ] 프롬프트에 5대 요소(피사체, 액션, 환경, 카메라, 조명)가 모두 들어갔는가?
- [ ] 한 문장이 100자 이내로 간결한가?
- [ ] 영어로 작성되어 있는가? (대부분 AI 도구는 영어 프롬프트가 더 정확)
- [ ] 저장했는가? (이후 변형 생성에 재사용)$$
WHERE guide_id = 14 AND step_order = 1;

-- Step 2
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
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
- 두 도구 결과물 비교 후 더 나은 것 선택$$,
  tips = $$- (X) 실수: 한 번 생성 후 "이게 다야?"라고 실망
- (V) 팁: AI 영상은 **확률 게임**. 같은 프롬프트도 3~5번 돌리면 그중 1~2개는 대박
- (X) 실수: 무료 크레딧 아껴쓰려고 생성 안 함
- (V) 팁: Kling은 **매일 크레딧이 리필**됨. 오늘 안 쓰면 내일 사라지니 매일 연습!
- (X) 실수: 생성 중 탭을 닫음
- (V) 팁: 생성 중에도 **탭을 열어두거나 "My Creations"에서 확인** 가능$$,
  checklist = $$- [ ] 계정 가입 완료
- [ ] 프롬프트 입력 후 "Generate" 클릭 확인
- [ ] 생성된 영상이 5초 길이로 정상 출력되었는가?
- [ ] 다운로드 파일이 로컬 폴더에 저장되었는가?$$
WHERE guide_id = 14 AND step_order = 2;

-- Step 3
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
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
**입력 (개선 전 프롬프트):**
```
Wide shot: A panda walking in a bamboo forest. Morning light.
```

**과정 (피드백 전달):**
- 판다가 너무 작게 보임
- 배경이 단조로움
- 요청: "카메라를 더 가까이(Close-up), 배경에 안개(Mist) 추가해줘"

**출력 (개선 후 프롬프트):**
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
- 직접 프롬프트 수정 (ChatGPT 없이)$$,
  tips = $$- (X) 실수: 프롬프트를 완전히 새로 쓰기
- (V) 팁: **기존 프롬프트의 일부만 수정**해야 변화를 정확히 파악 가능
- (X) 실수: 여러 요소를 한 번에 다 바꿈
- (V) 팁: **한 번에 1~2개 요소만** 변경해야 무엇이 효과 있었는지 알 수 있음
- (X) 실수: 실패한 프롬프트를 버림
- (V) 팁: 실패도 **학습 데이터**. 어떤 표현이 안 통하는지 기록해두기$$,
  checklist = $$- [ ] 최소 3가지 변형 프롬프트 생성했는가?
- [ ] 각 변형마다 "무엇을 바꿨는지" 명확히 기록했는가?
- [ ] 그중 1개 이상 만족스러운 결과를 얻었는가?
- [ ] 개선 전후 영상을 비교해 차이를 이해했는가?$$
WHERE guide_id = 14 AND step_order = 3;

-- Step 4
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
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

**1단계 (이미지 생성 프롬프트 - Midjourney 등에 입력):**
```
A young woman in a white blouse sitting at a modern office desk, holding a coffee cup, looking at a laptop. Warm afternoon sunlight through large windows, cinematic lighting, realistic style. --ar 16:9
```

**2단계 (Image-to-Video 프롬프트 - Kling AI에 입력):**
```
She lifts the coffee cup to her lips and takes a sip, then returns the cup to the desk. Subtle laptop screen glow.
```

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
SET content = $$#### (B) 해야 할 일
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

#### (D) 예시

**테스트 결과 (실제 사용자 경험 기반):**

| 항목 | Kling AI | Hailuo AI | Pika Labs |
|------|----------|-----------|-----------|
| 생성 속도 | 180초 (느림) | 90초 (빠름) | 120초 (중간) |
| 화질 | 4.5점 (최고) | 4점 (좋음) | 3점 (보통) |
| 프롬프트 반영도 | 4점 | 5점 (가장 정확) | 3점 |
| 부자연스러운 모핑 | 거의 없음 | 약간 있음 | 자주 발생 |
| 스타일 | 리얼리즘 강함 | 리얼리즘+빠른 생성 | 아트/스타일화 |
| 무료 크레딧 | 매일 66 | 매일 100 | 월 5개 |

**핵심:** Hailuo는 속도와 프롬프트 반영도가 최고, Kling은 화질과 일관성이 뛰어남, Pika는 창의적 효과에 강함

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
SET content = $$#### (B) 해야 할 일
- 아래 카메라/조명 키워드 리스트 복사해 메모장에 저장
- 기존 프롬프트 1개 선택
- 카메라 워크만 3가지로 바꿔서 생성 (예: Wide → Close-up → Drone shot)
- 조명만 3가지로 바꿔서 생성 (예: Golden hour → Neon light → Silhouette)
- 총 6개 변형 중 가장 인상적인 것 선정

#### (C) 복붙 블록: 카메라 워크 & 조명 키워드 사전

**카메라 앵글/샷 타입:**
- `Wide shot` / `Establishing shot`: 전경, 전체 장면
- `Medium shot`: 허리 위 중간 샷
- `Close-up`: 얼굴/물체 클로즈업
- `Extreme close-up`: 눈/손 등 초근접
- `Low angle`: 아래에서 위로 (웅장함)
- `High angle` / `Bird's eye view`: 위에서 아래로 (작고 약해 보임)
- `Over-the-shoulder`: 어깨 너머 샷
- `POV (Point of View)`: 1인칭 시점

**카메라 움직임:**
- `Static shot`: 고정 카메라
- `Tracking shot` / `Dolly shot`: 피사체를 따라 이동
- `Pan left/right`: 좌우 회전
- `Tilt up/down`: 상하 회전
- `Zoom in/out`: 줌인/줌아웃
- `Crane shot`: 크레인 샷 (상승/하강)
- `Drone shot` / `Aerial shot`: 드론 공중 촬영
- `Orbit around`: 피사체 주변을 회전

**조명 스타일:**
- `Golden hour`: 일몰/일출의 따뜻한 빛
- `Soft lighting`: 부드러운 확산광
- `Hard lighting`: 강한 그림자가 있는 극적 조명
- `Backlight` / `Rim light`: 역광, 윤곽선 강조
- `Silhouette`: 실루엣 (역광으로 어둡게)
- `Neon light`: 네온 조명 (사이버펑크 느낌)
- `Cinematic lighting`: 영화 같은 조명 (전반적)
- `Natural light`: 자연광
- `Studio lighting`: 스튜디오 인공 조명

#### (D) 예시

**기본 프롬프트:**
```
A panda walking in a bamboo forest.
```

**변형 1 (카메라: Wide → Close-up):**
```
Close-up shot: A panda's face as it walks through a bamboo forest, golden hour lighting.
```

**변형 2 (카메라: Wide → Drone):**
```
Aerial drone shot: A panda walking through a vast bamboo forest, cinematic wide angle.
```

**변형 3 (조명: Golden hour → Neon):**
```
Wide shot: A panda walking in a bamboo forest, neon blue and pink lighting, cyberpunk aesthetic.
```

**변형 4 (조명: Golden hour → Silhouette):**
```
Wide shot: A panda walking in a bamboo forest, backlit silhouette, dramatic sunset.
```

#### (E) 분기: 스타일 선택

**리얼리즘 (다큐멘터리/비즈니스 영상):**
- `Natural light`, `Static shot`, `Medium shot`

**시네마틱 (뮤직비디오/단편영화):**
- `Golden hour`, `Tracking shot`, `Cinematic lighting`

**아트/실험적 (인스타그램/포트폴리오):**
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

-- Step 7
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- Step 6까지 만든 최고의 영상 1개 선택
- AI 업스케일 도구(Topaz Video AI, AVCLabs 등)에 업로드
- 2x 또는 4K 업스케일 선택 후 처리 (5~10분 소요)
- CapCut, DaVinci Resolve 등 무료 편집 툴에서 자막/음악 추가
- 플랫폼 맞춤 포맷(16:9, 9:16 등) 설정 후 내보내기

#### (C) 복붙 블록: 편집 체크리스트

```
[ ] 업스케일 완료 (720p → 1080p 또는 4K)
[ ] 인트로 추가 (3초 이내, 브랜드/타이틀)
[ ] 자막 추가 (핵심 메시지 1~2문장)
[ ] 배경음악 추가 (저작권 프리 음원)
[ ] 색보정 (밝기/대비/채도 조정)
[ ] 아웃트로 추가 (CTA: "구독", "팔로우" 등)
[ ] 플랫폼 맞춤 포맷 설정
  - YouTube: 16:9, 1080p 이상
  - Instagram Reels: 9:16, 1080x1920
  - TikTok: 9:16, 1080x1920
[ ] 최종 내보내기 (H.264 코덱, MP4 포맷)
```

#### (D) 예시

**시나리오:** 5초 판다 영상을 유튜브 숏츠용 완성본으로 만들기

**1단계: 업스케일**
- Topaz Video AI에서 720p → 4K (3840x2160)
- 모델: "Proteus HQ" 선택
- 처리 시간: 약 5분

**2단계: 편집 (CapCut 사용)**
- 자막 추가: "Giant Pandas in the Wild 🐼"
- 배경음악: YouTube Audio Library에서 "Cinematic Ambient" 선택
- 아웃트로: "Subscribe for more!" 텍스트 1초

**3단계: 내보내기**
- 해상도: 1080x1920 (9:16, 숏츠 포맷)
- 프레임레이트: 30fps
- 코덱: H.264

#### (E) 분기: 무료 vs 유료 도구

**무료 업스케일 도구:**
- AVCLabs Online Video Upscaler (무료 크레딧)
- Video2X (오픈소스, 로컬 설치)
- Vmake AI (온라인, 4K까지 무료)

**유료 업스케일 도구 (최고 품질):**
- Topaz Video AI ($299, 평생 라이센스)
- UniFab Video Upscaler AI (30일 무료 체험)

**무료 편집 도구:**
- CapCut (초보자 친화)
- DaVinci Resolve (전문가급, 무료 버전 강력)
- Clipchamp (웹 기반)$$,
  tips = $$- (X) 실수: 업스케일 없이 720p 그대로 업로드
- (V) 팁: 유튜브/인스타는 **최소 1080p** 필수. 4K면 알고리즘 우대 받음
- (X) 실수: 배경음악에 저작권 음원 사용
- (V) 팁: YouTube Audio Library, Epidemic Sound 등 **저작권 프리** 음원만 사용
- (X) 실수: 자막을 너무 많이, 길게 넣음
- (V) 팁: 자막은 **핵심 1~2문장**만. 너무 많으면 산만함$$,
  checklist = $$- [ ] 영상이 1080p 이상 해상도인가?
- [ ] 자막이 가독성 있게 배치되었는가?
- [ ] 배경음악이 영상 분위기와 잘 어울리는가?
- [ ] 플랫폼 맞춤 포맷(16:9 또는 9:16)이 정확한가?$$
WHERE guide_id = 14 AND step_order = 7;

-- Step 8
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- Notion, Google Docs, Obsidian 등 도구 선택
- "AI 영상 프롬프트 라이브러리" 페이지 생성
- 카테고리 설정 (예: 인물/풍경/제품/동물/아트)
- Step 1~7에서 만든 프롬프트 중 성공작 10개 선택
- 각 프롬프트에 메타데이터 추가 (도구명, 성공률, 용도)
- 템플릿 1개 만들기 (브라켓 플레이스홀더 활용)

#### (C) 복붙 블록: 프롬프트 라이브러리 템플릿

```
# AI 영상 프롬프트 라이브러리

## 카테고리 1: 인물 영상

### 프롬프트 #1: 사무실 일하는 여성
**프롬프트:**
"Close-up dolly-in: A young woman in a [색상] blouse, [액션] while [작업] in a modern office. Warm afternoon light through windows, professional cinematic tone."

**사용 도구:** Kling AI
**성공률:** 80% (10개 중 8개 만족)
**용도:** 비즈니스/튜토리얼 영상
**메모:** "색상"과 "액션"만 바꾸면 다양한 시나리오 생성 가능

### 프롬프트 #2: 운동하는 남성
**프롬프트:**
"Wide tracking shot: A man in sportswear, running on a [장소], morning golden hour light, dynamic motion."

**사용 도구:** Hailuo AI
**성공률:** 70%
**용도:** 피트니스/광고 영상
**메모:** Hailuo가 동작 처리 더 빠름

---

## 카테고리 2: 풍경/환경

### 프롬프트 #3: 도시 야경
**프롬프트:**
"Drone aerial shot: A [도시명] skyline at night, neon lights reflecting on water, cinematic wide angle."

**사용 도구:** Runway Gen-3
**성공률:** 90% (품질 최고)
**용도:** 인트로/배경 영상
**메모:** 유료지만 품질 보장

---

## 템플릿 (재사용 가능)

### 템플릿 #1: 제품 쇼케이스
**구조:**
"[카메라 앵글]: A [제품명] placed on [표면], [조명] lighting, [카메라 움직임] to reveal [디테일]."

**예시:**
"Close-up rotating shot: A luxury watch placed on black velvet, soft studio lighting, camera slowly orbits to reveal diamond details."

**사용법:**
1. [제품명], [표면], [디테일]만 교체
2. Kling AI 권장
3. Image-to-Video 조합하면 성공률 95%
```

#### (D) 예시: 실제 프로 사용 사례

**주간 영상 제작 워크플로우 (20개 영상/주):**
- 월요일: 라이브러리에서 템플릿 10개 선택
- 화요일: 템플릿 변형 20개 생성 (배치 작업)
- 수요일: 결과물 중 Best 20개 선택
- 목요일: 업스케일 + 편집
- 금요일: 배포 + 성공 프롬프트 라이브러리 추가

**결과:** 평균 제작 시간 영상당 40분 → 15분으로 단축

#### (E) 분기: 도구 선택

**간단한 정리 (개인 사용):**
- 메모장 / Google Keep

**체계적 정리 (팀/프로젝트):**
- Notion (데이터베이스 기능 강력)
- Obsidian (로컬 저장, 빠름)

**자동화 필요 시:**
- Airtable (API 연동 가능)$$,
  tips = $$- (X) 실수: 프롬프트를 저장하지 않고 매번 새로 작성
- (V) 팁: **성공한 건 즉시 저장**. 나중에 찾으려면 기억 안 남
- (X) 실수: 프롬프트만 저장하고 메타데이터(도구, 성공률) 누락
- (V) 팁: **"어느 도구에서 잘 됐는지"** 메모 필수
- (X) 실수: 템플릿을 너무 복잡하게 만듦
- (V) 팁: 템플릿은 **3개 이하 변수**만. 단순할수록 재사용 쉬움$$,
  checklist = $$- [ ] 프롬프트 라이브러리 페이지를 만들었는가?
- [ ] 최소 10개 프롬프트가 카테고리별로 정리되어 있는가?
- [ ] 각 프롬프트에 도구명, 성공률, 용도가 기록되었는가?
- [ ] 템플릿 1개 이상을 만들어 실제로 사용해 봤는가?$$
WHERE guide_id = 14 AND step_order = 8;

-- Step 9
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- 15초 스토리 아이디어 구상 (예: "판다의 하루")
- 3~5개 장면으로 나눈 스토리보드 작성
- 각 장면마다 프롬프트 설계 (Step 1 활용)
- Kling/Hailuo에서 각 장면 생성 (총 15~20개 변형 생성 권장)
- 최고 클립 3~5개 선택
- CapCut/DaVinci Resolve에서 연결
- 트랜지션, 자막, 음악 추가
- 15초 이내로 타이트하게 편집

#### (C) 복붙 블록: 15초 스토리보드 템플릿

```
# 프로젝트: [제목 입력]
## 타겟 플랫폼: [YouTube Shorts / Instagram Reels / TikTok]
## 총 길이: 15초

### Scene 1 (0~3초) - 시작/훅
**목적:** 시선 끌기
**프롬프트:**
"[카메라]: [피사체], [액션], [환경]. [조명]"

**생성 도구:** [Kling / Hailuo / Pika]
**예상 클립 수:** 5개 생성 → 1개 선택

---

### Scene 2 (3~8초) - 중간/전개
**목적:** 스토리 전달
**프롬프트:**
"[카메라]: [피사체], [액션], [환경]. [조명]"

**생성 도구:** [Kling / Hailuo / Pika]
**예상 클립 수:** 5개 생성 → 1개 선택

---

### Scene 3 (8~12초) - 클라이맥스
**목적:** 감정 고조
**프롬프트:**
"[카메라]: [피사체], [액션], [환경]. [조명]"

**생성 도구:** [Kling / Hailuo / Pika]
**예상 클립 수:** 5개 생성 → 1개 선택

---

### Scene 4 (12~15초) - 마무리
**목적:** 여운/CTA
**프롬프트:**
"[카메라]: [피사체], [액션], [환경]. [조명]"

**생성 도구:** [Kling / Hailuo / Pika]
**예상 클립 수:** 3개 생성 → 1개 선택

## 편집 플랜
- 트랜지션: [Fade / Cut / Zoom / Dissolve]
- 자막: [메인 메시지 1문장]
- 배경음악: [장르/분위기]
- 색보정: [통일감 유지]
```

#### (D) 예시: "판다의 하루" 15초 스토리

**Scene 1 (0~3초):**
- 프롬프트: "Wide drone shot: A giant panda waking up in a bamboo forest, morning mist, soft sunlight."
- 도구: Kling AI
- 메시지: 평화로운 아침

**Scene 2 (3~8초):**
- 프롬프트: "Medium tracking shot: A panda eating bamboo, close-up of face, crunching sounds."
- 도구: Hailuo AI (빠른 생성)
- 메시지: 귀여운 식사

**Scene 3 (8~12초):**
- 프롬프트: "Low angle shot: A panda cub playfully rolling down a grassy hill, joyful mood."
- 도구: Kling AI
- 메시지: 재미있는 놀이

**Scene 4 (12~15초):**
- 프롬프트: "Close-up: A panda curled up sleeping under a tree, golden sunset light, peaceful ending."
- 도구: Kling AI
- 메시지: 하루의 끝

**편집:**
- 트랜지션: 자연스러운 Dissolve
- 자막: "A Day in the Life of a Panda 🐼"
- 음악: Calm Acoustic (YouTube Audio Library)

#### (E) 분기: 난이도 선택

**초급 (3개 클립):**
- 시작-중간-끝 구조만
- 트랜지션: 단순 Cut
- 길이: 10~12초

**중급 (5개 클립):**
- 훅-전개-클라이맥스-반전-마무리
- 트랜지션: Fade + Zoom
- 길이: 15초 풀

**고급 (7~10개 클립):**
- 복잡한 스토리 아크
- 다중 캐릭터 또는 장소
- 트랜지션 + 이펙트 + 색보정 통일$$,
  tips = $$- (X) 실수: 각 클립의 스타일(조명, 색감)이 제각각
- (V) 팁: 모든 프롬프트에 **같은 조명 키워드** 사용 (예: 전부 "golden hour")
- (X) 실수: 트랜지션을 너무 많이, 화려하게 사용
- (V) 팁: 트랜지션은 **최소화**. 자연스러운 Cut이 가장 프로페셔널
- (X) 실수: 음악 볼륨이 너무 크거나 작음
- (V) 팁: 음악은 **배경**이 목적. 영상보다 조용하게 (-10dB)$$,
  checklist = $$- [ ] 스토리보드에 시작-중간-끝 구조가 명확한가?
- [ ] 모든 클립의 스타일(조명, 색감)이 일관성 있는가?
- [ ] 편집 후 15초 이내로 타이트하게 완성되었는가?
- [ ] 자막과 음악이 자연스럽게 통합되었는가?$$
WHERE guide_id = 14 AND step_order = 9;

-- Step 10
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- Step 8 라이브러리에서 템플릿 1개 선택
- ChatGPT에 "10가지 변형 생성" 요청
- Kling AI에서 10개 프롬프트를 순차 입력 (대기열 쌓기)
- 생성 대기 시간 동안 다른 작업 (스토리보드 작성 등)
- 10개 결과물 미리보기 후 즉석 평가 (별 5점 척도)
- 4점 이상만 다운로드
- 선정 기준 문서화

#### (C) 복붙 블록: 배치 생성 ChatGPT 프롬프트

```
너는 AI 영상 프롬프트 배치 생성 전문가야.

아래 템플릿을 기반으로 10가지 다양한 변형 프롬프트를 만들어줘:

**기본 템플릿:**
"[카메라]: A [피사체] [액션] in [환경]. [조명]"

**변형 규칙:**
1. 피사체는 유지하되 액션을 다양화 (예: 걷기 → 뛰기 → 앉기 → 서 있기)
2. 카메라 앵글을 5가지 이상 섞기 (Wide, Close-up, Drone 등)
3. 환경을 3가지 이상 다르게 (실내/실외/도시/자연)
4. 조명을 3가지 이상 (Golden hour, Neon, Soft light)

**출력 형식:**
각 프롬프트에 번호를 매기고, 한 줄로 정리해줘.

예시:
1. Wide shot: A panda walking in a bamboo forest. Golden hour light.
2. Close-up: A panda eating bamboo, focus on face. Soft natural light.
3. Drone shot: A panda playing in a meadow. Bright midday sun.
...

이제 [여기에 피사체 입력: 예 - 로봇]으로 10개 만들어줘.
```

#### (D) 예시: "로봇" 10가지 변형

**ChatGPT 출력:**
1. Wide shot: A humanoid robot walking through a futuristic city. Neon lights at night.
2. Close-up: A robot's face with glowing blue eyes, tilting head. Soft studio light.
3. Drone shot: A robot standing on a rooftop overlooking the city. Golden hour sunset.
4. Low angle: A giant robot towering over buildings. Dramatic backlight.
5. Medium shot: A robot repairing machinery in a workshop. Warm industrial lighting.
6. POV shot: A robot's hand reaching toward the camera. Bright daylight.
7. Tracking shot: A robot running through a sci-fi corridor. Flickering fluorescent lights.
8. Extreme close-up: A robot's eye lens focusing. High-contrast lighting.
9. Over-the-shoulder: A robot looking at a holographic screen. Blue ambient light.
10. Static shot: A robot sitting on a bench in a park. Soft morning light.

**생성 전략:**
- Kling AI에 1~10번 순차 입력 (대기열 10개 쌓임)
- 총 생성 시간: 약 30~40분
- 대기하며 Step 9 스토리보드 작성

#### (E) 분기: 시간 관리 전략

**빠른 프로토타입 (30분):**
- 5개 변형만 생성
- 즉석 선별 (미리보기만)
- 1개 다운로드

**표준 워크플로우 (1시간):**
- 10개 변형 생성
- 전체 다운로드 후 비교
- 상위 3개 선정

**프로 배치 시스템 (3시간, 주 1회):**
- 5개 아이디어 × 10개 변형 = 50개 생성
- 자동화 도구 활용 (OpenArt 같은 올인원 플랫폼)
- 상위 20개 선정 → 편집$$,
  tips = $$- (X) 실수: 10개를 하나씩 생성하고 기다림
- (V) 팁: **대기열에 한꺼번에 쌓아두고** 다른 작업 병행
- (X) 실수: 모든 결과물을 다운로드
- (V) 팁: **미리보기에서 1차 선별** 후 베스트만 다운로드 (저장공간 절약)
- (X) 실수: 왜 좋은지/나쁜지 기록 안 함
- (V) 팁: 선정 이유를 간단히 메모 (나중에 패턴 파악 가능)$$,
  checklist = $$- [ ] ChatGPT로 10개 변형 프롬프트를 생성했는가?
- [ ] Kling/Hailuo 대기열에 10개를 한 번에 입력했는가?
- [ ] 10개 중 상위 2~3개를 선정했는가?
- [ ] 선정 기준(예: 일관성, 프롬프트 반영도, 시네마틱)을 문서화했는가?$$
WHERE guide_id = 14 AND step_order = 10;

-- Step 11
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- 최종 영상 기술 스펙 확인 (해상도, 비트레이트, 포맷)
- 플랫폼별 권장 사양 비교
- 제목/설명/태그 작성 (SEO 키워드 포함)
- 썸네일 제작 (영상에서 가장 임팩트 있는 장면 캡처)
- 업로드 또는 예약 게시
- 성과 추적 시트 생성 (조회수, 좋아요, 댓글 기록)
- 다음 3개 프로젝트 아이디어 브레인스토밍

#### (C) 복붙 블록: 플랫폼별 최적화 체크리스트

```
## YouTube Shorts
- [ ] 해상도: 1080x1920 (9:16)
- [ ] 길이: 15~60초
- [ ] 제목: 50자 이내, 핵심 키워드 앞쪽 배치
- [ ] 설명: 200자 이내, 해시태그 3~5개
- [ ] 썸네일: 자동 생성 또는 커스텀 (1080x1920)
- [ ] 업로드 시간: 한국 기준 저녁 7~9시 (트래픽 피크)

## Instagram Reels
- [ ] 해상도: 1080x1920 (9:16)
- [ ] 길이: 15~90초 (30초 이하 권장)
- [ ] 캡션: 125자 이내, 이모지 활용
- [ ] 해시태그: 10~15개, 인기+틈새 믹스
- [ ] 커버 이미지: 가장 눈에 띄는 장면
- [ ] 게시 시간: 평일 오전 9시, 오후 6시

## TikTok
- [ ] 해상도: 1080x1920 (9:16)
- [ ] 길이: 15~30초 (짧을수록 완주율 ↑)
- [ ] 캡션: 150자 이내, 트렌딩 해시태그 포함
- [ ] 사운드: 트렌딩 음원 활용 권장
- [ ] 게시 시간: 평일 오후 12시, 저녁 8시

## 공통 체크리스트
- [ ] 영상 포맷: MP4 (H.264 코덱)
- [ ] 비트레이트: 8~12 Mbps
- [ ] 프레임레이트: 30fps (60fps도 OK)
- [ ] 자막: 영상 내 내장 (플랫폼 자막 기능 미사용)
- [ ] 워터마크: 최소화 또는 투명도 50%
```

#### (D) 예시: "판다의 하루" 배포 전략

**YouTube Shorts:**
- 제목: "Giant Panda's Perfect Day 🐼 | AI Short Film"
- 설명: "Watch this adorable panda's daily routine in stunning AI-generated video! #Shorts #Panda #AIVideo"
- 게시 시간: 저녁 8시 (한국)

**Instagram Reels:**
- 캡션: "POV: You're a panda living your best life 🐼✨ #PandaLove #AIArt #Reels"
- 해시태그: #PandaLove #AIArt #Reels #AnimalLovers #AIGenerated #Shorts #Cute #Wildlife #Nature #Relax
- 게시 시간: 오전 9시

**TikTok:**
- 캡션: "This panda's day is better than mine 😭🐼 #PandaTikTok #AIVideo"
- 사운드: 트렌딩 Lofi 음악
- 게시 시간: 저녁 8시

#### (E) 분기: 성과 추적 전략

**간단 추적 (개인):**
- 구글 시트에 날짜/플랫폼/조회수/좋아요 기록
- 주 1회 리뷰

**전문 추적 (비즈니스):**
- 플랫폼 Analytics 연동
- Hootsuite, Buffer 등 자동화 도구 활용
- 월 1회 상세 리포트 작성$$,
  tips = $$- (X) 실수: 같은 제목/설명을 모든 플랫폼에 복붙
- (V) 팁: 플랫폼마다 **문화와 용어**가 다름. 맞춤 최적화 필수
- (X) 실수: 업로드 후 방치
- (V) 팁: **첫 1시간이 골든타임**. 댓글 적극 답변 → 알고리즘 부스트
- (X) 실수: 실패한 영상을 삭제
- (V) 팁: 실패도 데이터. **왜 안 됐는지 분석** 후 다음에 반영$$,
  checklist = $$- [ ] 영상이 플랫폼 권장 사양을 충족하는가?
- [ ] 제목/설명에 SEO 키워드가 포함되어 있는가?
- [ ] 썸네일이 클릭을 유도할 만큼 임팩트 있는가?
- [ ] 게시 후 성과를 추적할 시스템이 준비되었는가?$$
WHERE guide_id = 14 AND step_order = 11;
