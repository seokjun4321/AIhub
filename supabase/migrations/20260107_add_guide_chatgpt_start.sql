-- Migration to add "ChatGPT Start" Guide (Guide ID 2)
-- Corrected Schema: using 'estimated_time' (text), 'category_id' (int), 'difficulty', 'tags', and removing 'image_url' (not in schema)

-- 1. Ensure "AI 기초 입문" Category Exists
INSERT INTO categories (name, description)
VALUES ('AI 기초 입문', 'AI 활용의 첫걸음을 떼는 입문자를 위한 가이드 카테고리')
ON CONFLICT (name) DO NOTHING;

-- 1.5. Ensure "ChatGPT" Model Exists (for ai_model_id)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ai_models WHERE name ILIKE '%ChatGPT%') THEN
        INSERT INTO ai_models (name, provider, website_url, description, model_type)
        VALUES ('ChatGPT', 'OpenAI', 'https://chat.openai.com', 'OpenAI가 개발한 가장 인기 있는 대화형 AI 모델', 'Chat');
    END IF;
END $$;

-- 2. Insert Guide Metadata
-- Using subquery for category_id
-- Removed 'image_url' as it does not exist in schema
-- Changed 'duration' to 'estimated_time'
INSERT INTO guides (id, title, description, estimated_time, category_id, ai_model_id, difficulty, tags)
OVERRIDING SYSTEM VALUE
VALUES (
    2,
    $$ChatGPT 완전 처음 시작하기$$,
    $$회원가입부터 실전 프롬프트 작성까지, 대학생을 위한 ChatGPT 완벽 입문 가이드. 무료 버전만으로도 학업·창업·취업 준비에 AI를 전략적으로 활용하는 법을 배웁니다.$$,
    $$45분$$,
    (SELECT id FROM categories WHERE name = 'AI 기초 입문' LIMIT 1),
    (SELECT id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
    $$Beginner$$, -- '초급'
    ARRAY['AI 기초 입문', '계정 생성', '무료 기능 활용', '프롬프트 작성법', '대학생 실전 활용', 'CO-STAR 프레임워크', '학습 도구']
)
ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    estimated_time = EXCLUDED.estimated_time,
    category_id = EXCLUDED.category_id,
    ai_model_id = EXCLUDED.ai_model_id,
    difficulty = EXCLUDED.difficulty,
    tags = EXCLUDED.tags;

-- 3. Clear existing steps/prompts for this guide to ensure clean slate
DELETE FROM guide_steps WHERE guide_id = 2;
-- guide_prompts are cascaded from guide_steps, so no need to delete them manually if step is deleted. 
-- BUT, we need to clear guide_sections (for prompt_pack)
DELETE FROM guide_sections WHERE guide_id = 2 AND section_type = 'prompt_pack';
DELETE FROM guide_sections WHERE guide_id = 2 AND section_type IN ('summary', 'target_audience', 'preparation', 'core_principles');

-- 3.5 Insert Guide Overview Sections (4 Cards)
INSERT INTO guide_sections (guide_id, section_type, section_order, title, content, data)
VALUES
(
    2,
    'summary',
    0,
    '한 줄 요약',
    $$ChatGPT는 OpenAI가 만든 AI 대화형 도구로, 무료 가입 후 즉시 과제 도움·아이디어 브레인스토밍·코딩 보조·글쓰기를 받을 수 있습니다.
2026년 현재 GPT-5.2 모델을 무제한 제공하며, 당신의 창업 준비와 학업을 2배 빠르게 만들 가장 접근성 높은 AI입니다.$$,
    NULL
),
(
    2,
    'target_audience',
    1,
    '이런 분께 추천',
    NULL,
    $$[
        "AI 창업을 준비하는데 기초 경험부터 쌓고 싶은 대학생",
        "과제·리포트를 더 효율적으로 처리하고 싶은 분",
        "코딩·영어·글쓰기 등 다양한 영역에서 AI 조력자가 필요한 분",
        "\"어떻게 질문해야 할지\" 감을 못 잡아서 답답했던 분",
        "무료로 시작하되 나중에 유료 전환도 고려 중인 분"
    ]$$::jsonb
),
(
    2,
    'preparation',
    2,
    '준비물',
    NULL,
    $$[
        "인터넷 연결 (Wi-Fi 또는 모바일 데이터)",
        "이메일 계정 (Gmail, Naver 등) 또는 Google/Microsoft 계정",
        "웹 브라우저 (Chrome, Safari, Edge 등)",
        "휴대폰 번호 (SMS 인증용)"
    ]$$::jsonb
),
(
    2,
    'core_principles',
    3,
    '핵심 사용 원칙',
    NULL,
    $$[
        { "title": "구체성이 답이다", "description": "\"창업 아이디어 줘\" ❌ → \"물리학 배경, 한국 B2B 시장, 2026년 시작 가능한 AI 스타트업 아이디어 3개를 시장성·경쟁사 분석과 함께\" ✅" },
        { "title": "대화로 다듬기", "description": "한 번에 완벽한 답을 기대하지 말고, 질문 → 답변 → 피드백 → 수정 순으로 점진적 개선" },
        { "title": "역할 부여하기", "description": "\"마케팅 전문가처럼\", \"논문 리뷰어처럼\" 등으로 답변 품질 10배 향상" },
        { "title": "형식 지정하기", "description": "\"표로 정리\", \"3단계로 나눠서\", \"1,000자 이내\" 등 명확한 지시" }
    ]$$::jsonb
);

-- 4. Insert Steps

-- Step 1
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 1, $$공식 사이트 접속 & 계정 생성 방식 선택$$,
    $$ChatGPT 공식 사이트에 안전하게 접속하고, 가입 방식(이메일 vs 소셜 계정)을 선택한다.$$,
    $$- https://chat.openai.com 에 정확히 접속했음
- "Sign up" 버튼을 클릭해 가입 팝업이 나타남$$,
    $$#### Why This Matters
ChatGPT는 전 세계적으로 인기가 높아 **피싱 사이트**가 많습니다. 반드시 공식 사이트에서 시작해야 개인정보 보호와 정상 서비스를 받을 수 있습니다. 가입 방식은 두 가지: ① Google/Microsoft 계정 연동(추천, 30초), ② 이메일 직접 입력(약 3분). 대학생이라면 학교 Google 계정이 있으므로 ①번이 가장 빠릅니다.

#### (B) Actions
1. 웹 브라우저 주소창에 `https://chat.openai.com` 입력 후 엔터
2. 페이지 로드 대기 (3~5초)
3. 화면 우측 상단 "Sign up" 버튼 클릭
4. 팝업창에서 다음 중 선택:
   - "Continue with Google" (추천)
   - "Continue with Microsoft"
   - "Continue with email" (이메일 직접 입력)

#### (C) Copy Block
```
https://chat.openai.com
```
위 주소를 브라우저 주소창에 그대로 붙여넣으세요. Google 검색 결과의 광고 링크는 클릭하지 마세요.$$,
    $$- (X) 실수: "ChatGPT" 검색해서 나온 광고 링크 클릭 → 피싱 위험
- (X) 실수: "chatgpt.com"이 아닌 "chat.openai.com"을 헷갈림
- (V) 팁: 주소를 북마크에 저장해두면 다음부터 1초 접속
- (V) 팁: 모바일도 동일 주소로 웹 접속 가능 (앱은 나중 설치)$$,
    $$- [ ] 주소창에 "chat.openai.com"이 정확히 표시되는가?
- [ ] "Sign up" 또는 "Log in" 버튼이 보이는가?$$
);

-- Step 2
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 2, $$30초 가입 완료 - Google 계정 연동$$,
    $$Google 계정으로 ChatGPT 계정을 생성하고, 이름과 생년월일을 입력한다.$$,
    $$- Google 계정 선택 완료
- 이름·생년월일 입력 후 다음 단계로 진행$$,
    $$#### (B) Actions
1. "Continue with Google" 버튼 클릭
2. 로그인된 Google 계정 목록이 나타남
3. 사용할 계정 선택 (대학 Gmail 또는 개인 Gmail)
4. OpenAI 권한 요청 팝업에서 "계속" 또는 "Continue" 클릭
5. 이름 입력 (실명 또는 닉네임)
6. 생년월일 입력 (YYYY-MM-DD 형식)
7. "Continue" 클릭

#### (E) Branch
**이메일로 가입하는 경우**
Google 계정이 없거나 별도 이메일로 가입하고 싶다면:
1. "Continue with email" 선택
2. 이메일 주소 입력 후 "Continue"
3. 비밀번호 설정 (8자 이상, 대소문자+숫자 권장)
4. 입력한 이메일로 **인증 메일** 수신 (5분 내)
5. 메일 열어서 "Verify email address" 클릭
6. 다시 ChatGPT 탭으로 돌아와 이름·생년월일 입력$$,
    $$- (X) 실수: Google 계정이 있는데 모르고 이메일로 새로 만들기 → 불필요한 중복
- (V) 팁: 생년월일은 실명 인증이 아니므로 정확하지 않아도 가입 가능 (단, 기억할 것)
- (V) 팁: 학교 Gmail 사용 시 나중에 "교육 할인" 혜택 받을 가능성 있음$$,
    $$- [ ] Google 계정 연동 또는 이메일 인증이 완료되었는가?
- [ ] 이름과 생년월일을 입력했는가?$$
);

-- Step 3
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 3, $$휴대폰 인증 & 가입 최종 완료$$,
    $$휴대폰 SMS 인증을 완료하고, ChatGPT 메인 대화창에 접속한다.$$,
    $$- 휴대폰으로 6자리 인증 코드를 받고 입력 완료
- ChatGPT 대화 인터페이스(입력창)가 화면에 나타남$$,
    $$#### (B) Actions
1. "휴대폰 번호 입력" 화면 도달
2. 국가 코드 "+82" (대한민국) 확인
3. 휴대폰 번호 입력 (010-xxxx-xxxx 형식, "-" 제외하고 입력 가능)
4. "Send code" 또는 "인증 코드 받기" 클릭
5. SMS 수신 대기 (보통 30초 이내)
6. 받은 6자리 코드를 입력창에 붙여넣기
7. "Verify" 또는 "확인" 클릭
8. ChatGPT 메인 화면 로드 (검은색 배경 + 입력창)

#### (D) Example
**인증 과정 시나리오:**
| 단계 | 입력/행동 | 결과 |
|------|----------|------|
| 1 | 휴대폰 번호: 01012345678 입력 | "Send code" 버튼 활성화 |
| 2 | "Send code" 클릭 | SMS 발송 (30초 내 도착) |
| 3 | SMS 내용: "OpenAI 인증 코드: 123456" | 6자리 코드 확인 |
| 4 | 코드 123456 입력 후 "Verify" | 계정 인증 완료 → 메인 화면 |$$,
    $$- (X) 실수: SMS가 안 와서 계속 기다림 → 1분 지나도 안 오면 "Resend code" 클릭
- (X) 실수: 다른 사람 번호 입력 → 본인 번호만 가능
- (V) 팁: 인증 코드 유효 시간은 약 5분 → 서두르지 말고 차분히 입력
- (V) 팁: "Resend code"는 3~5회까지 가능$$,
    $$- [ ] SMS로 6자리 코드를 받았는가?
- [ ] 코드 입력 후 ChatGPT 메인 화면(대화창)이 보이는가?$$
);

-- Step 4
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 4, $$한국어 설정 & 인터페이스 이해하기$$,
    $$ChatGPT 언어를 한국어로 설정하고, 화면 구성(입력창, 사이드바, 설정 등)을 파악한다.$$,
    $$- 화면이 한국어로 표시됨
- 좌측 사이드바·입력창·설정 아이콘 위치를 확인함$$,
    $$#### (B) Actions
1. 화면 우측 하단 **프로필 아이콘**(동그란 원) 또는 **설정 아이콘**(⚙️) 클릭
2. "Settings" 또는 "설정" 메뉴 클릭
3. "Language" 또는 "언어" 찾기
4. "Korean" 또는 "한국어" 선택
5. (선택사항) 테마 변경: "Dark mode" / "Light mode"
6. 설정 창 닫기
7. 페이지 새로고침 (F5) 한 번 → 한국어 완전 적용

#### (C) Copy Block
```
안녕? 너는 지금 한국어로 대답할 수 있어?

**이 템플릿을 ChatGP에 붙여넣어 보세요**
```$$,
    $$- (V) 팁: 한국어 설정 후 새로고침(F5) 한 번 하면 UI가 깔끔하게 바뀜
- (V) 팁: Dark mode가 눈 편하면 먼저 설정 권장 (장시간 사용 시)
- (V) 팁: 좌측 사이드바가 안 보이면 좌측 상단 **햄버거 메뉴**(三) 클릭$$,
    $$- [ ] 화면이 한국어로 표시되는가?
- [ ] 좌측 "지난 대화" 목록과 하단 입력창이 명확히 보이는가?$$
);

-- Step 5
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 5, $$첫 대화 시작 - "좋은 프롬프트" 3가지 원칙 체험$$,
    $$ChatGPT에 첫 질문을 하고, "구체성·역할 부여·형식 지정"의 3가지 원칙을 실습한다.$$,
    $$- 입력창에 질문을 입력하고 전송 버튼을 눌렀을 때 답변이 나타남
- 답변이 실시간으로 생성되는 과정(타이핑 효과)을 관찰함$$,
    $$#### (D) Example
**좋은 프롬프트 3가지 원칙:**
| 원칙 | 나쁜 예 ❌ | 좋은 예 ✅ |
|------|-----------|-----------|
| **1. 구체적으로** | "AI 창업" | "물리학과 대학생으로, 한국 B2B 시장에서 2026년 시작 가능한 AI 스타트업 아이디어..." |
| **2. 역할 부여** | "논문 쓰는 거 도와줘" | "너는 SCI 논문 리뷰 전문가야. 내가 제시하는 물리학 논문 초록을 읽고..." |
| **3. 형식 지정** | "ChatGPT 무료 vs 유료 차이" | "표로 정리해 줄래? 행은 기능, 속도, 가격..." |

#### (B) Actions
1. 화면 하단 **입력창** 클릭
2. 아래 **복붙 블록 중 1개** 선택해 붙여넣기
3. **전송 버튼**(➤ 또는 ↑) 클릭 또는 엔터
4. ChatGPT가 답변 생성하는 과정 관찰 (5~30초)
5. 전체 답변이 완성될 때까지 대기

#### (C) Copy Block
```
너는 AI 스타트업 전문 벤처캐피탈 파트너야.

나는:
- 23살 물리학과 대학생
- AI 중심 창업 준비 중
- 한국 시장 타겟
- B2B SaaS에 관심

이 조건에서 "2026년 대학생이 시작할 수 있는 AI 스타트업 아이디어" 3개를 제안해 줘.

각 아이디어마다:
1) 서비스 개요 (1줄)
2) 타겟 고객
3) 주요 경쟁사
4) 시작하기 위한 첫 스텝

을 표로 정리해 줄래?

**이 템플릿을 ChatGPT에 붙여넣어 보세요**
```$$,
    $$- (X) 실수: "아이디어 줘" 한 줄 질문 → 답변이 너무 피상적
- (X) 실수: 한 번에 10개 요청 → 각 항목이 얕아짐
- (V) 팁: 답변이 마음에 안 들면 **"다시 해줄래?"** 또는 **"2번 아이디어만 더 자세히"** 요청 가능
- (V) 팁: 입력창 아래 "Stop generating" 버튼으로 답변 중단 가능$$,
    $$- [ ] 질문을 입력하고 전송했을 때 답변이 나타났는가?
- [ ] 답변이 질문 내용과 관련이 있는가?
- [ ] 문장이 자연스럽고 이해 가능한가?$$
);

-- Step 6
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 6, $$"대화의 기술" - 3단계 질문법으로 답변 품질 10배 높이기$$,
    $$ChatGPT와 1회성 질문이 아니라 "대화"를 나누고, 후속 질문으로 답변을 점진적으로 개선한다.$$,
    $$- Step 5의 답변을 읽고 부족한 부분을 확인함
- 후속 질문 1개 이상을 입력해 답변을 개선해봤음
- "같은 대화창 내"에서 2회 이상 왕복 대화를 경험함$$,
    $$#### Why This Matters
ChatGPT의 진정한 힘은 "한 번에 완벽한 답"이 아니라, **대화를 통한 점진적 개선**에 있습니다. 마치 좋은 교수님과 상담하듯, **질문 → 답변 → 피드백 → 수정 → 최종 답변** 사이클을 경험하세요.

#### (D) Example
**3단계 대화 기법 - 실전 시나리오:**
**[1단계] 아이디어 수집 (넓게)**
질문: "한국 B2B AI 스타트업 아이디어 5개 제안해줘."
답변: 1) 채용, 2) 안전, 3) 의료... (나열식)

**[2단계] 선택한 아이디어 상세 분석 (깊게)**
후속 질문: "1번 채용 플랫폼에 대해 더 알고 싶어. 경쟁사와 차별점을 표로 정리해줘."
답변: 경쟁사 분석표 제시, 타겟 시장 분석.

**[3단계] 실행 계획 구체화 (행동으로)**
후속 질문: "이걸 시작하려면 MVP로 당장 뭘 만들어야 해? 첫 3개월 계획 짜줘."
답변: 1개월차 프로토타입, 2개월차 테스트... (구체적 액션)

#### (B) Actions
1. Step 5에서 받은 답변을 **정확히 읽고**, 마음에 들지 않는 부분 메모
2. 다음 중 1가지 후속 질문 형식 선택:
   - "더 자세히 설명해 줄래?"
   - "[특정 부분]이 이해 안 가는데, 예시 들어 줄래?"
   - "3개 방법 중 1번만 더 구체화해 줄래? (액션 스텝 포함)"
3. 후속 질문 입력 후 전송
4. 답변 비교: "아, 1회차와 달라지네" 경험$$,
    $$- (X) 실수: 첫 답변 받고 만족해서 더 이상 질문 안 함 → 표면적 이해만 남음
- (X) 실수: 새로운 주제로 자꾸 바뀌는 질문 → 대화 맥락 끊김
- (V) 팁: **같은 대화창 내에서 계속 질문하세요** (좌측 목록에서 같은 제목 유지)
- (V) 팁: 좋은 답변은 **메모장 또는 노션에 복사**해두면 나중에 다시 읽을 수 있음$$,
    $$- [ ] 첫 답변을 읽고 부족한 부분을 찾았는가?
- [ ] 후속 질문 후 답변이 달라졌는가?
- [ ] 같은 대화창에서 2회 이상 왕복 대화를 했는가?$$
);

-- Step 7
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 7, $$프롬프트 프레임워크 - CO-STAR 마스터하기$$,
    $$전 세계적으로 가장 많이 쓰이는 프롬프트 작성 공식 **CO-STAR**를 배우고, 실전에 적용한다.$$,
    $$- CO-STAR 6가지 요소를 이해함
- 아래 템플릿으로 프롬프트 1개를 직접 작성해봤음$$,
    $$#### Why This Matters
지금까지는 "감"으로 질문했다면, 이제부터는 **공식**으로 질문합니다. CO-STAR는 스탠포드·MIT 등에서 AI 교육 시 가르치는 표준 프레임워크로, **답변 품질을 200% 높이는** 검증된 방법입니다.

#### (D) Example
**CO-STAR 프레임워크 (6가지 요소):**
| 요소 | 의미 | 예시 |
|------|------|------|
| **C** (Context) | **맥락** | "나는 물리학과 대학생이고..." |
| **O** (Objective) | **목표** | "투자자용 1페이지 사업 요약..." |
| **S** (Style) | **스타일** | "표로 정리", "불릿 포인트" |
| **T** (Tone) | **어조** | "전문적이고 차분하게" |
| **A** (Audience) | **독자** | "투자자", "교수님" |
| **R** (Response) | **형식** | "1,000자 이내", "5개 항목" |

**적용 전 ❌:**
"AI 창업 아이디어 줘" (막연함)

**적용 후 ✅ (CO-STAR):**
[C] 나는 23살 물리학과 대학생...
[O] 2026년 한국 AI 스타트업 아이디어 3개...
[S] 표 형식으로...
[T] 전문적인 톤으로...
[R] 각 아이디어 경쟁사 포함...

#### (C) Copy Block
```
[C] Context (맥락):
나는 [직업/전공/상황]이고, [배경 설명 1-2줄].

[O] Objective (목표):
[원하는 결과물]을 만들고 싶어.

[S] Style (스타일):
[표 / 리스트 / 단계별 / 비교 분석] 형식으로 작성해 줘.

[T] Tone (어조):
[전문적 / 캐주얼 / 설득적 / 교육적] 톤으로.

[A] Audience (독자):
[투자자 / 교수님 / 초보자 / 동료] 수준에 맞춰.

[R] Response (응답 형식):
[글자 수 / 항목 개수 / 장단점 구분] 조건을 지켜 줘.

**이 템플릿을 복사해서 상황을 채워넣으세요**
```$$,
    $$- (X) 실수: 6가지 요소를 억지로 다 채우려고 함 → 필수는 C+O+S, 나머지는 선택
- (V) 팁: 처음엔 CO-STAR 템플릿을 노션에 저장해두고, 필요할 때마다 복사해서 사용
- (V) 팁: "Tone"을 바꾸면 같은 내용도 완전히 다른 느낌의 답변이 나옴$$,
    $$- [ ] CO-STAR 6가지 요소를 이해했는가?
- [ ] 템플릿에 자신의 상황을 채워넣어 프롬프트 1개를 만들었는가?$$
);

-- Step 8
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 8, $$무료 vs 유료 이해 & 전환 시점 판단$$,
    $$ChatGPT 무료 버전의 한계를 이해하고, 향후 유료(Plus) 전환 시점을 스스로 판단할 수 있다.$$,
    $$- 무료 버전으로 할 수 있는 것과 없는 것을 구분함
- "지금 나는 무료면 충분한가?"를 판단함$$,
    $$#### (D) Example
**무료 vs 유료 비교 (대학생 기준):**
| 기능 | 무료 (Free) | 유료 (Plus) | 영향도 |
|------|-----------|-----------|-------|
| **GPT-5.2** | 제한적 | 무제한 | ⭐⭐⭐ |
| **기본 대화** | 무제한 | 무제한 | ⭐ |
| **파일 업로드** | 10개 | 더 빠름 | ⭐⭐ |
| **이미지 생성** | ❌ 불가 | ✅ 가능 | ⭐⭐ |
| **Custom GPT** | ❌ 불가 | ✅ 가능 | ⭐⭐⭐ (창업 필수) |

#### (C) Copy Block
```
[체크리스트 B] 유료 전환 고려해야 할 경우
다음 중 2개 이상 해당하면 유료 고려:
☐ 프로그래밍 프로젝트 (디버깅·성능 중요)
☐ 복잡한 데이터 분석 (PDF/CSV 자주 업로드)
☐ 발표자료 (이미지 생성 필요)
☐ AI 창업 프로젝트 (Custom GPT 제작 필수) ⭐⭐⭐
☐ 하루 10회 이상 사용 (GPT-5.2 무제한 필요)
☐ 학위논문·연구 (높은 정확도 필수)

**이 체크리스트로 본인의 상황을 점검하세요**
```$$,
    $$- (X) 실수: "유료는 비싸"라고 생각 → 월 27,000원은 매우 저렴 (Netflix와 유사)
- (X) 실수: 무료 제한에 걸려도 ChatGPT가 "완전히 안 된다" 생각 → 24시간 후 복구
- (V) 팁: **학생 할인** 가능 여부 확인 (일부 지역/대학)
- (V) 팁: 유료 전환 시 **언제든 취소 가능** (다음 결제일까지 사용 가능)$$,
    $$- [ ] 현재 자신의 요금제(무료)를 확인했는가?
- [ ] 체크리스트로 자신의 상황을 판단했는가?$$
);

-- Step 9
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    2, 9, $$최종 산출물 정리 & Next Steps$$,
    $$지금까지의 학습을 정리하고, 앞으로 ChatGPT를 어떻게 활용할지 구체적인 행동 계획을 세운다.$$,
    $$- Step 5 또는 Step 6에서 받은 답변 1개를 노션/메모장에 저장함
- "다음 주에 ChatGPT로 할 일" 1가지 이상을 적었음$$,
    $$#### (D) Example
**Basic Prompt (Next Steps):**
앞으로의 행동 계획 (자신에게 맞는 것 1개 선택)

**Option 1 (학업 활용):**
목표: ChatGPT를 공부 비서로 만들기
다음 주 액션: 가장 어려운 과목 개념 1개 CO-STAR로 설명 받기

**Option 2 (창업 준비):**
목표: AI 창업 분석 도구로 만들기
다음 주 액션: 아이디어 5개 수집 및 1개 심층 분석

**Option 3 (코딩 활용):**
목표: 코딩 어시스턴트
다음 주 액션: Python 오류 해결하거나 작은 기능 구현하기

#### (C) Copy Block
```
ChatGPT 입문 완주 기준:

기본 완주:
☑ 계정 생성 완료 (로그인 가능)
☑ 첫 질문 → 답변 경험함
☑ 무료/유료 차이 이해함

완전 완주:
☑ 위 3개 + Step 6 (대화 경험) 완료
☑ 향후 사용 계획 1가지 이상 세움

마스터 완주:
☑ 위 모든 것 + CO-STAR 프레임워크 사용
☑ 이 가이드의 프롬프트 3개 이상 직접 사용
☑ "ChatGPT와 대화하는 게 뭔지" 완벽히 이해함

**이 체크리스트를 복사해서 달성 여부를 체크하세요**
```$$,
    $$- (V) 팁: **이 가이드를 북마크**해두고, 프롬프트 템플릿 필요할 때마다 돌아오세요
- (V) 팁: 좋은 질문이 떠올랐을 때 **노션/메모 앱**에 저장 → ChatGPT 사용 시 복사
- (V) 팁: 1개월마다 **"지난달 ChatGPT 사용 회고"** → 다음 달 더 잘 활용$$,
    $$- [ ] Next Steps 중 "다음 주에 할 1가지"를 정했는가?
- [ ] 그것을 실행하는 데 필요한 프롬프트를 준비했는가?$$
);


-- 4. Insert Guide Prompts (The Prompt Pack)
-- Using guide_sections table (JSONB) instead of guide_prompts
INSERT INTO guide_sections (guide_id, section_type, section_order, title, data)
VALUES (
    2,
    'prompt_pack',
    1,
    '대학생을 위한 ChatGPT 필살기 팩',
    $$[
      {
        "id": "pack_1_startup",
        "title": "대학생 창업 아이디어 발굴 (CO-STAR)",
        "description": "AI 창업 아이디어를 체계적으로 찾고 싶을 때 사용합니다.",
        "prompt": "[C] Context:\n나는 [전공명] 대학생이고, [배경/경험 1-2줄].\n관심 분야는 [AI/핀테크/헬스테크 등]이고,\n타겟 시장은 [한국/글로벌/특정 산업]이야.\n\n[O] Objective:\n\"2026년 대학생이 1년 내 시작 가능한\" AI 기반 B2B 스타트업 아이디어 3개를 얻고 싶어.\n\n[S] Style:\n표 형식으로 작성해 줘.\n\n[T] Tone:\n전문적이면서도 초보 창업자가 이해 가능한 톤으로.\n\n[A] Audience:\n투자자가 아닌 \"대학생 창업자\" 수준에 맞춰.\n\n[R] Response:\n각 아이디어마다:\n1) 서비스 개요 (1줄)\n2) 타겟 고객 (구체적인 회사 타입)\n3) 주요 경쟁사 2-3개\n4) 가장 큰 진입장벽\n5) MVP 만드는 데 필요한 첫 스텝",
        "usage": "창업 경진대회 준비 / 아이디어톤 / 사이드 프로젝트 기획",
        "failurePatterns": "- ❌ 실패: \"아이디어 줘\" (너무 광범위)\n- ✅ 수정: 구체적인 상황과 제약조건(CO-STAR) 명시",
        "relatedStep": [5, 6, 7],
        "tags": ["창업", "아이디어", "CO-STAR"]
      },
      {
        "id": "pack_2_study",
        "title": "과제/공부 개념 설명 요청 (RTF)",
        "description": "어려운 과학·수학 개념을 쉽게 이해하고 싶을 때 사용합니다.",
        "prompt": "[R] Role:\n너는 [과목명] 담당 교수야.\n\n[T] Task:\n나는 \"[개념명]\"을 이해하지 못하고 있어.\n\n이 개념을:\n1) 고등학생도 이해하는 \"일상 예시\" 2-3개로 설명해 줘\n2) 그 후 \"과학적/수학적 정의\"를 덧붙여 줘\n3) 마지막으로 \"실제 활용 사례\" 1-2개\n\n[F] Format:\n최종 형식: [쉬운 예시 → 정의 → 활용]",
        "usage": "중간/기말고사 대비 / 전공 서적 독해 보조",
        "failurePatterns": "- ❌ 실패: \"양자역학이 뭐야?\" (장황한 설명)\n- ✅ 수정: \"고등학생도 이해하게 설명해 줘\" (난이도 조절)",
        "relatedStep": [5, 6, 7],
        "tags": ["학업", "개념이해", "RTF"]
      },
      {
        "id": "pack_3_report",
        "title": "논문/리포트 구조화 보조",
        "description": "리포트나 논문의 아웃라인을 잡을 때 사용합니다.",
        "prompt": "너는 학술 글쓰기 전문 편집자야.\n\n나는 다음 주제로 [보고서/논문/에세이]를 써야 해:\n\"[구체적인 주제]\"\n\n내 요구사항:\n- 분량: [2,000자]\n- 대상: [교수님]\n- 톤: [학술적]\n\n이걸 바탕으로:\n- 최적의 \"논문 구조\" (서론 → 본론 → 결론)\n- 각 섹션의 \"소제목 5-7개\"\n- 각 소제목에 들어갈 핵심 내용 1-2줄\n- \"찾아야 할 참고자료\" 주제 3-4개\n\n[형식: 마크다운 아웃라인]",
        "usage": "리포트 초안 작성 / 에세이 구조 잡기",
        "failurePatterns": "- ❌ 실패: \"써줘\" (표절 위험, AI 티 남)\n- ✅ 수정: \"구조를 잡아줘\" (아이디어만 얻기)",
        "relatedStep": [6, 7],
        "tags": ["글쓰기", "구조화", "리포트"]
      },
      {
        "id": "pack_4_interview",
        "title": "면접 준비 & 모의 면접",
        "description": "입사/대학원 면접을 대비해 예상 질문과 피드백을 받을 때 사용합니다.",
        "prompt": "너는 [회사명/대학원명] 면접관이야.\n\n[내 정보]\n- 지원 분야: [직무]\n- 내 배경: [전공/경험]\n\n1) \"예상 질문 TOP 5\"를 먼저 제시해 줘.\n2) 내가 답변을 입력하면 \"좋은 점\", \"개선할 점\"을 피드백해 줘.\n3) 마지막으로 \"최종 조언\"을 해 줘.",
        "usage": "인턴/신입 채용 면접 / 대학원 구술 면접",
        "failurePatterns": "- ❌ 실패: 자기소개서 전체 작성 요청\n- ✅ 수정: 모의 인터뷰로 실전 감각 익히기",
        "relatedStep": [7, 9],
        "tags": ["취업", "면접", "롤플레잉"]
      },
      {
        "id": "pack_5_coding",
        "title": "코딩 디버깅 & 알고리즘 설명",
        "description": "코드가 작동하지 않거나 특정 알고리즘을 이해하고 싶을 때 사용합니다.",
        "prompt": "너는 [Python] 코딩 튜터야.\n\n[문제 상황]\n- 목표: [버그 수정/기능 구현]\n- 에러 메시지/코드:\n```\n[여기에 코드]\n```\n\n1) \"문제점과 원인\" 설명\n2) \"수정된 코드\" (주석 포함)\n3) \"더 좋은 방법\" 1가지",
        "usage": "프로그래밍 과제 / 에러 해결 / 알고리즘 공부",
        "failurePatterns": "- ❌ 실패: 전체 시스템 구현 요청 (복잡도 증가)\n- ✅ 수정: 함수 단위로 쪼개서 질문",
        "relatedStep": [5, 9],
        "tags": ["코딩", "디버깅", "개발"]
      },
      {
        "id": "pack_6_planning",
        "title": "시간 관리 & 실행 계획 수립",
        "description": "복잡한 일정을 정리하고 장기 목표를 위한 로드맵을 짤 때 사용합니다.",
        "prompt": "너는 생산성 코치야.\n\n[나의 현황]\n- 고정 일정: [수업 20시간, 알바 10시간]\n- 목표: [창업 준비]\n- 부족한 것: [집중력]\n\n다음 3개월간:\n1) 주간 일정표 (시간 배분)\n2) 월별 마일스톤\n3) 핵심 습관 3가지",
        "usage": "학기 중 시간 관리 / 방학 계획 / 프로젝트 일정 관리",
        "failurePatterns": "- ❌ 실패: \"계획 짜줘\" (정보 부족)\n- ✅ 수정: 자신의 제약 조건(시간, 자원) 명시",
        "relatedStep": [6, 9],
        "tags": ["생산성", "계획", "자기관리"]
      }
    ]$$::jsonb
);
