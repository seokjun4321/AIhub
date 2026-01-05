-- Guide 14 Update Part 3 (v6 FINAL): Steps 6-11 & Prompts
-- Fixed text formatting and Icons:
-- 1. Uses actual newlines ($$ strings) for lists.
-- 2. Uses (X) and (V) prefixes for Tips to trigger correct UI icons (XCircle/CheckCircle).
-- 3. Ensures Checklists are formatted correctly.
-- 4. Handles JSON escaping properly.

DELETE FROM guide_steps WHERE guide_id = 14 AND step_order >= 6;

INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, why_matters, tips, checklist, content) VALUES
(14, 6, 'Step 6: 카메라 워크와 조명 키워드로 시네마틱 품질 끌어올리기',
 '전문 영화 용어(카메라 앵글, 조명 스타일)를 프롬프트에 추가해 영상 퀄리티를 극적으로 향상시킨다.',
 $$- 카메라 워크 키워드 10개 이상 암기
- 조명 키워드 5개 이상 암기
- 동일 장면에 카메라/조명만 바꿔 3가지 변형 생성
- 변형 간 분위기 차이를 명확히 체감$$,
 '초보자 프롬프트와 프로 프롬프트의 **결정적 차이는 카메라/조명 용어** 사용입니다.\n\n"판다가 걷는다" vs "Wide tracking shot: A panda walking, golden hour backlight, shallow depth of field" — 같은 장면이지만 후자는 영화 같은 느낌을 줍니다.\n\n이 단계를 마스터하면 여러분의 영상이 "유튜브 숏츠" 레벨에서 "넷플릭스 오프닝" 레벨로 진화합니다.',
 $$- (X) 실수: 카메라 용어를 한꺼번에 너무 많이 넣음 (예: "Wide tracking dolly crane shot")
- (V) 팁: **1개 앵글 + 1개 움직임**만 사용 (예: "Wide tracking shot")
- (X) 실수: 한국어로 카메라 용어 입력 (예: "클로즈업")
- (V) 팁: 반드시 **영어 원어** 사용
- (X) 실수: 조명 키워드를 빼먹음
- (V) 팁: 조명이 분위기의 80%. **항상 조명 키워드 1개 이상** 추가$$,
 $$- [ ] 카메라 워크 키워드 5개 이상 암기했는가?
- [ ] 조명 키워드 3개 이상 암기했는가?
- [ ] 동일 장면에 카메라/조명만 바꿔 최소 3개 변형 생성했는가?
- [ ] 변형 간 분위기 차이를 명확히 느꼈는가?$$,
 $$#### (B) 해야 할 일
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
- `Neon light`, `Extreme close-up`, `Dutch angle`$$
),
(14, 7, 'Step 7: 영상 품질 향상 - 업스케일과 편집 마무리',
 'AI 도구에서 생성된 720p/1080p 영상을 4K로 업스케일하고, 간단한 편집으로 완성도를 높인다.',
 $$- AI 업스케일 도구로 영상을 4K로 변환
- 자막, 배경음악, 트랜지션 중 1가지 이상 추가
- 최종 영상을 원하는 플랫폼(YouTube, Instagram 등) 포맷으로 내보내기$$,
 'AI 영상 도구가 생성하는 기본 해상도는 **720p~1080p**입니다. 유튜브나 포트폴리오에서는 4K가 표준이 되어가고 있고, 업스케일 없이 올리면 "저품질"로 인식될 수 있습니다.\n\n또한 AI가 만든 영상은 "날것" 그대로여서 자막, 음악, 인트로/아웃트로가 없습니다. 마지막 편집 단계에서 이를 추가하면 **아마추어 vs 프로의 차이**가 확연히 드러납니다.',
 $$- (X) 실수: 업스케일 없이 720p 그대로 업로드
- (V) 팁: 유튜브/인스타는 **최소 1080p** 필수. 4K면 알고리즘 우대 받음
- (X) 실수: 배경음악에 저작권 음원 사용
- (V) 팁: YouTube Audio Library, Epidemic Sound 등 **저작권 프리** 음원만 사용
- (X) 실수: 자막을 너무 많이, 길게 넣음
- (V) 팁: 자막은 **핵심 1~2문장**만. 너무 많으면 산만함$$,
 $$- [ ] 영상이 1080p 이상 해상도인가?
- [ ] 자막이 가독성 있게 배치되었는가?
- [ ] 배경음악이 영상 분위기와 잘 어울리는가?
- [ ] 플랫폼 맞춤 포맷(16:9 또는 9:16)이 정확한가?$$,
 $$#### (B) 해야 할 일
- Step 6까지 만든 최고의 영상 1개 선택
- AI 업스케일 도구(Topaz Video AI, AVCLabs 등)에 업로드
- 2x 또는 4K 업스케일 선택 후 처리 (5~10분 소요)
- CapCut, DaVinci Resolve 등 무료 편집 툴에서 자막/음악 추가
- 플랫폼 맞춤 포맷(16:9, 9:16 등) 설정 후 내보내기

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
- Clipchamp (웹 기반)

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
- 코덱: H.264$$
),
(14, 8, 'Step 8: 프롬프트 라이브러리 구축과 반복 사용 시스템 만들기',
 '성공한 프롬프트를 체계적으로 저장하고, 템플릿화해 빠르게 재사용할 수 있는 시스템을 구축한다.',
 $$- Notion, Obsidian, 메모장 등에 프롬프트 라이브러리 생성
- 최소 10개 프롬프트를 카테고리별로 정리
- 1개 이상의 템플릿(브라켓 플레이스홀더 활용)을 만들어 테스트$$,
 'AI 영상 제작의 핵심은 **"반복 가능한 시스템"**입니다. 매번 처음부터 프롬프트를 고민하면 시간이 무한히 소요됩니다.\n\n성공한 프롬프트를 모아두고 템플릿화하면, 새 프로젝트에서 **80% 시간 절약**이 가능합니다. 이는 프로들이 주당 20개 이상 영상을 만드는 비결이기도 합니다.',
 $$- (X) 실수: 프롬프트를 저장하지 않고 매번 새로 작성
- (V) 팁: **성공한 건 즉시 저장**. 나중에 찾으려면 기억 안 남
- (X) 실수: 프롬프트만 저장하고 메타데이터(도구, 성공률) 누락
- (V) 팁: **"어느 도구에서 잘 됐는지"** 메모 필수
- (X) 실수: 템플릿을 너무 복잡하게 만듦
- (V) 팁: 템플릿은 **3개 이하 변수**만. 단순할수록 재사용 쉬움$$,
 $$- [ ] 프롬프트 라이브러리 페이지를 만들었는가?
- [ ] 최소 10개 프롬프트가 카테고리별로 정리되어 있는가?
- [ ] 각 프롬프트에 도구명, 성공률, 용도가 기록되었는가?
- [ ] 템플릿 1개 이상을 만들어 실제로 사용해 봤는가?$$,
 $$#### (B) 해야 할 일
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
- Airtable (API 연동 가능)$$
),
(14, 9, 'Step 9: 실전 프로젝트 완주 - 15초 스토리텔링 영상 만들기',
 '3~5개의 AI 영상 클립을 연결해 하나의 완결된 15초 스토리 영상을 제작한다.',
 $$- 시작-중간-끝 구조를 가진 스토리보드 작성
- 각 구간별 AI 영상 클립 생성 (최소 3개)
- 편집 도구로 클립 연결 + 자막/음악 추가
- 최종 15초 영상을 유튜브 숏츠 또는 인스타그램 릴스 포맷으로 완성$$,
 '단일 5초 클립은 "기술 데모"에 불과**합니다. 진짜 콘텐츠는 여러 클립을 연결한 **"스토리"**입니다.\n\n이 단계에서 여러분은 AI 영상 생성자에서 **"AI 영상 감독"**으로 진화합니다. 클립 간 일관성 유지, 전환(transition) 설계, 리듬감 조절 등 실전 스킬을 체득하게 됩니다.',
 $$- (X) 실수: 각 클립의 스타일(조명, 색감)이 제각각
- (V) 팁: 모든 프롬프트에 **같은 조명 키워드** 사용 (예: 전부 "golden hour")
- (X) 실수: 트랜지션을 너무 많이, 화려하게 사용
- (V) 팁: 트랜지션은 **최소화**. 자연스러운 Cut이 가장 프로페셔널
- (X) 실수: 음악 볼륨이 너무 크거나 작음
- (V) 팁: 음악은 **배경**이 목적. 영상보다 조용하게 (-10dB)$$,
 $$- [ ] 스토리보드에 시작-중간-끝 구조가 명확한가?
- [ ] 모든 클립의 스타일(조명, 색감)이 일관성 있는가?
- [ ] 편집 후 15초 이내로 타이트하게 완성되었는가?
- [ ] 자막과 음악이 자연스럽게 통합되었는가?$$,
 $$#### (B) 해야 할 일
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

---

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
- 트랜지션 + 이펙트 + 색보정 통일$$
),
(14, 10, 'Step 10: 배치 생성 전략으로 생산성 10배 끌어올리기',
 '한 번에 10~20개 프롬프트를 일괄 생성하고, 결과물 중 베스트만 선별하는 프로 워크플로우를 구축한다.',
 $$- ChatGPT로 1개 아이디어를 10가지 변형 프롬프트로 확장
- Kling/Hailuo에서 1시간 이내 10개 영상 생성 (동시 대기열 활용)
- 10개 중 상위 2~3개 선정
- 선정 기준(체크리스트) 문서화$$,
 '초보자는 "1개 완벽한 프롬프트"를 찾으려 합니다. 프로는 "10개 괜찮은 프롬프트"를 만들고 최고를 고릅니다.\n\nAI 영상은 확률 게임이므로 **"생성 → 선별" 시스템**이 핵심입니다. 이 전략을 익히면 콘텐츠 제작 속도가 10배 이상 빨라지고, 품질도 안정적으로 유지됩니다.',
 $$- (X) 실수: 10개를 하나씩 생성하고 기다림
- (V) 팁: **대기열에 한꺼번에 쌓아두고** 다른 작업 병행
- (X) 실수: 모든 결과물을 다운로드
- (V) 팁: **미리보기에서 1차 선별** 후 베스트만 다운로드 (저장공간 절약)
- (X) 실수: 왜 좋은지/나쁜지 기록 안 함
- (V) 팁: 선정 이유를 간단히 메모 (나중에 패턴 파악 가능)$$,
 $$- [ ] ChatGPT로 10개 변형 프롬프트를 생성했는가?
- [ ] Kling/Hailuo 대기열에 10개를 한 번에 입력했는가?
- [ ] 10개 중 상위 2~3개를 선정했는가?
- [ ] 선정 기준(예: 일관성, 프롬프트 반영도, 시네마틱)을 문서화했는가?$$,
 $$#### (B) 해야 할 일
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
- 상위 20개 선정 → 편집$$
),
(14, 11, 'Step 11: 최종 산출물 점검 및 배포 전략',
 '완성된 영상의 품질을 최종 점검하고, 플랫폼별 최적화 전략을 수립해 배포한다.',
 $$- 최종 영상이 플랫폼 권장 사양(해상도, 길이, 포맷)을 충족
- SEO 최적화(제목, 설명, 태그) 완료
- 1개 이상 플랫폼에 실제 업로드 또는 예약 게시
- 다음 프로젝트 아이디어 리스트 작성$$,
 '훌륭한 영상을 만들어도 배포 전략이 없으면 아무도 보지 않습니다. 플랫폼마다 알고리즘과 선호 포맷이 다르므로, 같은 영상도 제목/썸네일/설명을 다르게 최적화해야 합니다.\n\n또한 이 단계에서 **성과 추적 시스템**을 세우면, 어떤 스타일의 영상이 반응이 좋은지 데이터로 파악해 다음 프로젝트를 개선할 수 있습니다.',
 $$- (X) 실수: 같은 제목/설명을 모든 플랫폼에 복붙
- (V) 팁: 플랫폼마다 **문화와 용어**가 다름. 맞춤 최적화 필수
- (X) 실수: 업로드 후 방치
- (V) 팁: **첫 1시간이 골든타임**. 댓글 적극 답변 → 알고리즘 부스트
- (X) 실수: 실패한 영상을 삭제
- (V) 팁: 실패도 데이터. **왜 안 됐는지 분석** 후 다음에 반영$$,
 $$- [ ] 영상이 플랫폼 권장 사양을 충족하는가?
- [ ] 제목/설명에 SEO 키워드가 포함되어 있는가?
- [ ] 썸네일이 클릭을 유도할 만큼 임팩트 있는가?
- [ ] 게시 후 성과를 추적할 시스템이 준비되었는가?$$,
 $$#### (B) 해야 할 일
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
- 월 1회 상세 리포트 작성$$
);

-- Prompts Update (Inserting into guide_sections for Prompt Pack)

DELETE FROM guide_sections WHERE guide_id = 14 AND section_type = 'prompt_pack';

INSERT INTO guide_sections (guide_id, section_type, section_order, title, data) VALUES
(14, 'prompt_pack', 4, 'Prompt Pack',
$$[
  {
    "label": "프롬프트 #1: 기본 Text-to-Video 마스터",
    "text": "[카메라 앵글]: A [피사체 + 구체적 묘사], [액션/움직임], in [환경 + 디테일]. [조명 스타일], [분위기 키워드].\\n\\n예시:\\nWide tracking shot: A young woman in a white blouse, walking slowly through a modern office hallway, sunlight streaming through large windows. Soft afternoon light, professional cinematic tone."
  },
  {
    "label": "프롬프트 #2: Image-to-Video 정밀 제어",
    "text": "[피사체] + [단순한 움직임 동사], [배경 변화 설명].\\n\\n예시:\\nShe slowly lifts the coffee cup to her lips and takes a sip, then places it back on the desk. Laptop screen glows softly.\n\n주의: 이미지 속 요소만 설명하세요. 없는 걸 추가하려 하지 마세요."
  },
  {
    "label": "프롬프트 #3: 시네마틱 카메라 워크 전문가",
    "text": "[전문 카메라 용어] + [전문 조명 용어]: [피사체], [액션], [환경]. [분위기].\n\n카메라 옵션: Drone shot / Low angle / Close-up dolly-in / Tracking shot / POV\n조명 옵션: Golden hour / Backlight / Silhouette / Neon light / Soft diffused light\n\n예시:\nLow angle tracking shot: A luxury sports car speeding through a neon-lit city street at night. Backlight from streetlights, cinematic motion blur, futuristic vibe."
  },
  {
    "label": "프롬프트 #4: 제품 쇼케이스 템플릿",
    "text": "Close-up rotating shot: A [제품명] placed on [표면 재질], [조명 스타일] lighting, camera slowly orbits around the product to reveal [강조할 디테일].\n\n예시:\nClose-up rotating shot: A silver smartwatch placed on black marble, soft studio lighting with subtle reflections, camera orbits to reveal the glowing OLED screen and metallic strap."
  },
  {
    "label": "프롬프트 #5: 스토리텔링 시퀀스 설계자",
    "text": "Scene 1 (훅): [카메라]: [피사체], [강렬한 액션], [환경]. [조명].\nScene 2 (전개): [카메라]: [피사체], [이어지는 액션], [같은 환경 또는 변화]. [같은 조명].\nScene 3 (마무리): [카메라]: [피사체], [마지막 액션], [환경]. [같은 조명].\n\n공통 요소: 모든 장면에 같은 조명 키워드를 사용해 일관성 유지.\n\n예시:\nScene 1: Wide shot: A robot walking through a futuristic city. Neon lights.\nScene 2: Medium shot: The robot stops and looks at a holographic screen. Neon lights.\nScene 3: Close-up: The robot's eyes glow brighter. Neon lights, dramatic music."
  },
  {
    "label": "프롬프트 #6: 트러블슈팅 & 고급 테크닉",
    "text": "문제 해결 체크리스트:\n1. 프롬프트 길이 확인: 100자 이내로 줄이기\n2. 한 번에 1개 액션만: \"걷다가 뛰다가 점프\" → \"걷기\"만\n3. 구체적 묘사: \"beautiful\" → \"wearing a red dress with white sneakers\"\n4. 도구 변경: Kling 안 되면 Hailuo 시도\n5. Image-to-Video로 전환: Text-to-Video 포기하고 이미지 먼저 만들기\n\n고급 테크닉 - Negative Prompt (Runway Gen-3):\n\"Avoid: blurry, warped hands, morphing, distorted faces, flickering.\""
  }
]$$::jsonb);
