-- Migration to add "Prompt Upgrader AI Tutor" Guide
-- Using correct schema: 'estimated_time' (text), 'category_id' (int), 'difficulty', 'tags', JSONB for data fields

-- 1. Ensure "학습" Category Exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM categories WHERE name = '학습') THEN
        INSERT INTO categories (name, description)
        VALUES ('학습', 'AI를 활용한 학습 효율 향상 가이드');
    END IF;
END $$;

-- 1.5. Ensure "ChatGPT" Model Exists (for ai_model_id)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ai_models WHERE name ILIKE '%ChatGPT%') THEN
        INSERT INTO ai_models (name, provider, website_url, description, model_type)
        VALUES ('ChatGPT', 'OpenAI', 'https://chat.openai.com', 'OpenAI가 개발한 가장 인기 있는 대화형 AI 모델', 'Chat');
    END IF;
END $$;

-- 2. Insert Guide Metadata
DO $do$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기') THEN
        INSERT INTO guides (title, description, estimated_time, category_id, ai_model_id, difficulty, tags)
        VALUES (
            $$Prompt Upgrader로 과목별 AI 튜터 만들기$$,
            $$Prompt Upgrader 프로젝트에서 '교수급 튜터 프롬프트'를 자동 생성하고, 그 결과를 과목 프로젝트에 이식해 내 자료 기반 튜터를 만드는 2-프로젝트 워크플로우입니다.$$,
            $$30~50분$$,
            (SELECT id FROM categories WHERE name = '학습' LIMIT 1),
            (SELECT id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
            $$초급~중급$$,
            ARRAY['학습', '프롬프트엔지니어링', 'ChatGPT Projects', '파일기반튜터', '시험대비', '생산성']
        );
    ELSE
        UPDATE guides SET
            description = $$Prompt Upgrader 프로젝트에서 '교수급 튜터 프롬프트'를 자동 생성하고, 그 결과를 과목 프로젝트에 이식해 내 자료 기반 튜터를 만드는 2-프로젝트 워크플로우입니다.$$,
            estimated_time = $$30~50분$$,
            category_id = (SELECT id FROM categories WHERE name = '학습' LIMIT 1),
            ai_model_id = (SELECT id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
            difficulty = $$초급~중급$$,
            tags = ARRAY['학습', '프롬프트엔지니어링', 'ChatGPT Projects', '파일기반튜터', '시험대비', '생산성']
        WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기';
    END IF;
END $do$;

-- 3. Clear existing steps/sections for this guide to ensure clean slate
DELETE FROM guide_steps WHERE guide_id = (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1);
DELETE FROM guide_sections WHERE guide_id = (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1);

-- 3.5 Insert Guide Overview Sections (4 Cards)
INSERT INTO guide_sections (guide_id, section_type, section_order, title, content, data)
VALUES
(
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    'summary',
    0,
    '한 줄 요약',
    $$Prompt Upgrader 프로젝트에 "프롬프트 엔지니어 GPT" 지침을 넣어 과목별 튜터 프롬프트를 자동 생성하고, 생성된 프롬프트를 과목 프로젝트에 이식해 내 자료 기반 튜터로 만들어 개념/문제풀이/요약 3모드로 복습 루프를 돌립니다.$$,
    NULL
),
(
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    'target_audience',
    1,
    '이런 분께 추천',
    NULL,
    $$[
        "과목마다 AI 튜터를 만들고 싶은데, 매번 프롬프트 짜기 귀찮은 사람",
        "내 강의자료/전공서 기준으로 설명하게 만들고 싶은 사람",
        "답변에 페이지/챕터 근거를 붙여 신뢰도를 올리고 싶은 사람",
        "문제풀이에서 정답보다 힌트 기반 코칭이 필요한 사람"
    ]$$::jsonb
),
(
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    'preparation',
    2,
    '준비물',
    NULL,
    $$[
        "ChatGPT (Projects 사용 가능)",
        "업로드할 PDF 자료 3~10개 (강의노트/전공서/기출/과제)",
        "파일명 정리 (과목/범위/종류가 드러나게)",
        "(선택) 문제 사진 또는 텍스트"
    ]$$::jsonb
),
(
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    'core_principles',
    3,
    '핵심 사용 원칙',
    NULL,
    $$[
        { "title": "메타 프로젝트와 실행 프로젝트 분리", "description": "Upgrader는 프롬프트 제조기, 과목 프로젝트는 학습장으로 역할을 명확히 구분합니다." },
        { "title": "자료 우선 + 근거 표기", "description": "업로드한 자료를 최우선 근거로 사용하고, 파일명/페이지/챕터를 답변에 포함하도록 설계합니다." },
        { "title": "모드 전환 기본 설계", "description": "개념/문제풀이/요약 3가지 모드를 기본 기능으로 포함해 다양한 학습 상황에 대응합니다." },
        { "title": "힌트 루프 강제", "description": "정답을 바로 주지 않고 내 시도 → 힌트 → 피드백 루프를 통해 실력을 향상시킵니다." }
    ]$$::jsonb
);

-- 4. Insert Steps (총 5개)

-- Step 1: "Prompt Upgrader" 프로젝트를 만든다
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    1,
    $$"Prompt Upgrader" 프로젝트를 만든다$$,
    $$어떤 과목이 와도 튜터 프롬프트를 자동으로 뽑아주는 메타 엔진을 세팅$$,
    $$- Prompt Upgrader 프로젝트가 생성되고, 지침에 "Prompt-Creator System v1.0"이 들어감$$,
    $$#### Why This Matters
Upgrader는 **템플릿 엔진**이므로 지침을 100% 통째로 넣는 것이 안정적입니다. 일부만 넣으면 모듈(ROLE/FORMAT/MODES)이 빠져 결과가 허술해집니다.

#### (B) Actions
1. ChatGPT에서 **새 프로젝트 생성**: `Prompt Upgrader`
2. 프로젝트 **지침/시스템**에 아래 내용을 그대로 붙여넣기
   - ✅ "**# 🧩 프롬프트 엔지니어 GPT (Prompt-Creator System v1.0)**" 전체 내용
3. 지침 저장 확인$$,
    $$- (X) 실수: Upgrader 지침을 일부만 넣어 모듈(ROLE/FORMAT/MODES)이 빠짐 → 결과가 허술해짐
- (V) 팁: Upgrader는 "템플릿 엔진"이므로 지침을 100% 통째로 넣는 게 안정적
- (V) 팁: 출력이 항상 코드박스로 나오게 설정되어 있는지 확인$$,
    $$- [ ] Upgrader 프로젝트 지침이 저장됐나?
- [ ] 출력이 항상 코드박스로 나오게 되어 있나?$$
);

-- Step 2: Upgrader에게 "과목 튜터 프롬프트"를 만들게 시킨다
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    2,
    $$Upgrader에게 "과목 튜터 프롬프트"를 만들게 시킨다$$,
    $$특정 과목에 최적화된 "교수급 튜터 프롬프트"를 자동 생성$$,
    $$- 과목 튜터용 "완성형 코드박스 프롬프트"를 확보함$$,
    $$#### Why This Matters
파일명을 프롬프트 안에 박아두면, 이후 대화에서도 **출처 표기가 안정적**입니다. 파일명을 빠뜨리면 일반 튜터가 되어버립니다.

#### (B) Actions
1. **Prompt Upgrader 프로젝트** 채팅창 열기
2. 아래 **요청문을 그대로 붙여넣기** (과목명/파일명만 수정)
3. 생성된 코드박스 프롬프트를 복사해두기

#### (C) Copy Block
```markdown
프롬프트를 짜줘: {과목명} 교수급 AI 튜터

필수 조건:
1) 내가 업로드할 자료 파일명은 아래와 같아. 이 자료를 '최우선 근거'로 답해.
- {file_1.pdf}
- {file_2.pdf}
- {file_3.pdf}

2) 답변에는 가능한 경우 "파일명 + 페이지/챕터" 근거를 표기해.
3) 모드 전환을 반드시 제공해:
   - 개념 질문 모드(고등학생도 이해할 설명 → 전공 수준 심화)
   - 문제풀이 코치 모드(정답 금지, 힌트→내 시도→피드백)
   - 강의자료 기반 요약 모드(범위 지정 시 요약+퀴즈)
4) 자료에 없으면 일반 지식을 쓰되 "자료 외 일반지식"이라고 라벨링하고, 확인 키워드를 같이 줘.
5) 사용자가 자주 하는 요청 3종(개념 질문/문제 사진·텍스트/자료 기반 요약)을 START SENTENCE에 넣어줘.
```
**이 템플릿을 복사해서 과목명/파일명만 바꿔 Upgrader에 입력하세요.**$$,
    $$- (X) 실수: 파일명을 안 넣어서 "일반 튜터"가 되어버림
- (V) 팁: 파일명은 프롬프트 안에 그대로 박아두면, 이후 대화에서도 출처 표기가 안정적$$,
    $$- [ ] 생성된 프롬프트에 모드 전환이 들어갔나?
- [ ] 근거 표기 규칙(파일명/페이지)이 포함됐나?$$
);

-- Step 3: "과목 프로젝트"를 만들고, 생성된 튜터 프롬프트를 이식한다
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    3,
    $$"과목 프로젝트"를 만들고, 생성된 튜터 프롬프트를 이식한다$$,
    $$실제로 공부에 쓰는 실행용 튜터 방을 만든다$$,
    $$- 과목 프로젝트 지침에 튜터 프롬프트가 들어가고 자료 업로드까지 완료됨$$,
    $$#### Why This Matters
Upgrader는 "프롬프트 제조기", 과목 프로젝트는 "학습장"으로 **분리 유지**하는 것이 중요합니다. Upgrader 프로젝트에서 계속 공부하려고 하면 역할이 섞여서 답변 톤이 흔들립니다.

#### (B) Actions
1. ChatGPT에서 **새 프로젝트 생성**: `{과목명} AI 튜터`
2. **지침/시스템**에 Step 2에서 생성된 "완성형 코드박스 프롬프트"를 붙여넣기
3. **자료 PDF 업로드** (같은 파일명 유지)

#### (D) Example
**프로젝트명**: `일반역학 AI 튜터`

**업로드 자료**:
- `Dynamics_LectureNotes_2025.pdf`
- `ProblemSet_1-6.pdf`
- `Textbook_Ch10-13.pdf`$$,
    $$- (X) 실수: Upgrader 프로젝트에서 계속 공부하려고 함 → 역할이 섞여서 답변 톤이 흔들림
- (V) 팁: Upgrader는 "프롬프트 제조기", 과목 프로젝트는 "학습장"으로 분리 유지$$,
    $$- [ ] 과목 프로젝트 지침이 들어갔나?
- [ ] 자료 업로드가 완료됐나?$$
);

-- Step 4: 과목 프로젝트에서 3가지 모드로 학습 루프를 돌린다
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    4,
    $$과목 프로젝트에서 3가지 모드로 학습 루프를 돌린다$$,
    $$너의 실제 루틴(개념 질문 / 문제풀이 / 자료 기반 요약)을 자동화$$,
    $$- 3모드를 각각 1번 이상 실행해보고, 내 루틴으로 정착$$,
    $$#### Why This Matters
AI가 풀어준 풀이를 "읽기만" 하고 넘어가면 실력이 안 늡니다. 코치 모드에서는 **내 시도 먼저**가 실력 상승의 핵심입니다.

#### (B) Actions
**추천 루틴**:
1. **개념 질문 10분**
2. **문제 1개 코치 모드**
3. **범위 요약 + 퀴즈**
4. **오답 복습**

#### (E) Branch
**상황별 선택**:
- **개념이 약함** → 개념 모드
- **문제에서 막힘** → 코치 모드
- **시험 범위 압축** → 요약 모드

#### (D) Example
**1) 개념 질문 모드**
- 직관적 설명 → 전공 수준 정의 → 확인 질문
- 근거: 파일명 + 페이지/챕터

**2) 문제풀이 코치 모드**
- 정답/전체풀이 금지
- 힌트 → 내 시도 → 다음 힌트

**3) 강의자료 요약 모드**
- 10줄 핵심 요약
- 퀴즈 8개 (먼저 풀기)
- 오답노트 템플릿$$,
    $$- (X) 실수: AI가 풀어준 풀이를 "읽기만" 하고 넘어감
- (V) 팁: 코치 모드에서는 내 시도 먼저가 실력 상승의 핵심$$,
    $$- [ ] 오늘 최소 문제 1개는 "내 시도→힌트"로 풀었나?
- [ ] 요약 후 퀴즈로 이해 확인을 했나?$$
);

-- Step 5: 과목 추가는 "파일명만 바꿔서" 반복한다
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    5,
    $$과목 추가는 "파일명만 바꿔서" 반복한다$$,
    $$다른 과목도 10~15분 안에 추가$$,
    $$- 새로운 과목 프로젝트 1개가 추가 생성됨$$,
    $$#### Why This Matters
과목 추가는 매우 간단합니다. 첫 세팅만 꼼꼼히 하면, 이후에는 **파일명 수정 → 복사 → 붙여넣기**로 5분 안에 끝납니다.

#### (B) Actions
1. Step 2에서 **과목명/파일명만 바꿔** Upgrader에 다시 요청
2. 결과를 **새 과목 프로젝트 지침**에 붙여넣기
3. **자료 업로드**

#### (D) Example
**과목별 커스터마이징**:

과목마다 고정 규칙이 다르면, Upgrader 요청에 "이 과목의 고정 규칙"을 한 줄로 추가해도 됩니다.

```
프롬프트를 짜줘: 미적분학 교수급 AI 튜터
(추가 규칙: 증명 과정은 단계별로 나눠서 설명)
```$$,
    $$- (V) 팁: 과목마다 고정 규칙이 다르면, Upgrader 요청에 "이 과목의 고정 규칙"을 한 줄로 추가해도 됨$$,
    $$- [ ] 새로운 과목에서도 모드/근거 규칙이 유지되나?$$
);

-- 5. Insert Prompt Pack (guide_sections with section_type='prompt_pack')
INSERT INTO guide_sections (guide_id, section_type, section_order, title, data)
VALUES (
    (SELECT id FROM guides WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' LIMIT 1),
    'prompt_pack',
    1,
    'Prompt Upgrader AI 튜터 필수 프롬프트 팩',
    $$[
      {
        "id": "pack_1_system",
        "title": "Prompt Upgrader System v1.0 (프로젝트 지침용)",
        "description": "Prompt Upgrader 프로젝트를 처음 만들 때 지침으로 넣을 때, 업그레이더가 흐트러졌을 때 재세팅할 때 사용합니다.",
        "prompt": "# 🧩 프롬프트 엔지니어 GPT (Prompt-Creator System v1.0)\n\n## 🎓 [페르소나 정의]\n너는 **Prompt-Engineer GPT**,  \n즉 \"다른 AI가 사용할 완성형 프롬프트를 설계·구조화·시각화하는 메타-엔진\"이다.  \n너의 임무는 사용자가 \"프롬프트를 짜줘: [주제]\"라고 말하면,  \n그 주제에 맞는 **전문 페르소나 + 지식기반 + 임무 + 출력 포맷 + 어조 + 예시**를 포함한  \n**복사-붙여넣기 가능한 완전한 프롬프트 박스**를 생성하는 것이다.\n\n---\n\n## 🧭 [역할 및 작동 원리]\n1️⃣ 사용자의 요청을 분석해 **프롬프트 유형**을 분류한다.  \n   - 학습형(튜터/교수) / 분석형(리서처/전략가) / 제작형(크리에이터) / 실행형(오토메이터) / 시험형(문제풀이) 등.  \n2️⃣ 각 유형별로 **5개 기본 모듈**을 자동 채운다:\n   - ROLE (역할 정의)  \n   - KNOWLEDGE BASE (지식 기반)  \n   - TASK (핵심 임무)  \n   - FORMAT (출력 구조)  \n   - STYLE (어조와 형식)  \n3️⃣ 마지막에는 **한 박스 완성형 프롬프트**로 출력한다.\n\n---\n\n## ⚙️ [생성 규칙]\n- 결과는 반드시 **하나의 코드박스(```markdown ... ```) 안에 완성된 프롬프트**로 출력.  \n- 프롬프트 구성 순서는 다음과 같다:\n  1. 🎓 **ROLE (페르소나 정의)**  \n  2. 📚 **KNOWLEDGE BASE (지식 기반)**  \n  3. 🎯 **TASK (핵심 임무)**  \n  4. 🧩 **FORMAT (출력 구조)**  \n  5. 💬 **STYLE (어조, 문체, 예시 포함)**  \n  6. ⚙️ **ADAPTIVE MODES (모드 전환 옵션)**  \n  7. ✅ **START SENTENCE (시작 대화 문장)**  \n- \"핵심은?\" 형식을 유지하며, 키워드는 **굵게 표시**.  \n- 출력은 완전한 상태로, 바로 다른 AI 환경에 복사해 사용할 수 있어야 한다.\n\n---\n\n## 🧠 [사고 구조]\n1. 입력 문장 분석 → 주제, 목적, 대상, 활용 도구 추출  \n2. 주제별 표준 구조 템플릿 매칭  \n3. 부족한 정보는 합리적 가정으로 채움  \n4. 각 섹션을 채워넣은 뒤 최종 박스 포맷으로 출력  \n5. 내부적으로 \"Clarity > Brevity\", \"System > Question\" 원칙 유지\n\n---\n\n## ✅ STARTER REQUEST TEMPLATE\n아래 문장을 그대로 대화창에 입력해:\n\n프롬프트를 짜줘: {과목명} 교수급 AI 튜터\n\n필수 조건:\n1) 내가 업로드할 자료 파일명은 아래와 같아. 이 자료를 '최우선 근거'로 답해.\n- {file_1.pdf}\n- {file_2.pdf}\n- {file_3.pdf}\n\n2) 답변에는 가능한 경우 \"파일명 + 페이지/챕터\" 근거를 표기해.\n3) 모드 전환을 반드시 제공해:\n   - 개념 질문 모드(고등학생도 이해할 설명 → 전공 수준 심화)\n   - 문제풀이 코치 모드(정답 금지, 힌트→내 시도→피드백)\n   - 강의자료 기반 요약 모드(범위 지정 시 요약+퀴즈)\n4) 자료에 없으면 일반 지식을 쓰되 \"자료 외 일반지식\"이라고 라벨링하고, 확인 키워드를 같이 줘.\n5) 사용자가 자주 하는 요청 3종(개념 질문/문제 사진·텍스트/자료 기반 요약)을 START SENTENCE에 넣어줘.",
        "usage": "Prompt Upgrader 프로젝트를 처음 만들 때 지침으로 넣을 때 / 업그레이더가 흐트러졌을 때(출력이 코드박스로 안 나오거나 모드/근거가 빠질 때) 재세팅할 때",
        "failurePatterns": "- ❌ 실패: 업그레이더가 코드박스로 안 내줌 / 모듈이 빠짐\n- ✅ 수정: 위 System v1.0을 프로젝트 지침에 다시 붙여넣고 저장한 뒤 재시도",
        "relatedStep": [1, 2],
        "tags": ["System", "지침", "템플릿엔진"]
      },
      {
        "id": "pack_2_concept",
        "title": "개념 질문 모드 호출",
        "description": "개념이 안 잡힐 때, 직관→수식→심화까지 한 번에 받고 싶을 때 사용합니다.",
        "prompt": "[개념 모드]\n주제: {topic}\n범위: {file_name} {pages_or_chapter}\n\n요청:\n1) 쉬운 설명(비유/직관) 1개\n2) 전공 수준 정의/수식(필요한 만큼)\n3) 내가 이해했는지 확인 질문 1개\n근거는 가능한 경우 파일명+페이지/챕터로.",
        "usage": "개념이 안 잡힐 때 / 직관→수식→심화까지 한 번에 받고 싶을 때",
        "failurePatterns": "- ❌ 실패: 너무 장문\n- ✅ 수정: \"핵심 7줄 제한\" 추가",
        "relatedStep": [4],
        "tags": ["개념학습", "이해", "설명"]
      },
      {
        "id": "pack_3_coach",
        "title": "문제풀이 코치 모드 (힌트 루프)",
        "description": "문제에서 막혔을 때, 풀이 습관(내 시도→힌트)을 만들고 싶을 때 사용합니다.",
        "prompt": "[코치 모드]\n문제: {problem_text_or_image}\n\n규칙:\n- 정답/전체풀이 금지\n- 첫 답변은 (필요 개념 2개 + 시작 힌트 1개 + 함정 1개)만\n- 내가 풀이를 보내면, 다음 한 단계 힌트만\n가능하면 관련 근거(파일명/페이지).",
        "usage": "문제에서 막혔을 때 / 풀이 습관(내 시도→힌트)을 만들고 싶을 때",
        "failurePatterns": "- ❌ 실패: AI가 풀어버림\n- ✅ 수정: 맨 위에 \"정답 주면 실패\" 1줄 추가",
        "relatedStep": [4],
        "tags": ["문제풀이", "힌트", "코칭"]
      },
      {
        "id": "pack_4_summary",
        "title": "강의자료 기반 요약+퀴즈+오답템플릿",
        "description": "시험 범위 압축, 빠른 복습 루틴을 만들고 싶을 때 사용합니다.",
        "prompt": "[요약 모드]\n자료: {file_name}\n범위: {pages_or_chapter}\n\n출력:\n1) 10줄 핵심 요약(가능하면 근거 페이지 포함)\n2) 퀴즈 8개(내가 먼저 풀게, 정답은 나중에)\n3) 오답노트 템플릿(틀린 이유/재발 방지 규칙/연관 페이지)",
        "usage": "시험 범위 압축 / 빠른 복습 루틴 만들기",
        "failurePatterns": "- ❌ 실패: 퀴즈가 너무 쉬움\n- ✅ 수정: \"응용형 30% 포함\" 추가",
        "relatedStep": [4],
        "tags": ["요약", "퀴즈", "복습"]
      }
    ]$$::jsonb
);

-- 6. Verify Insertion
DO $$
DECLARE
    v_guide_id INTEGER;
    v_step_count INTEGER;
    v_section_count INTEGER;
    v_prompt_count INTEGER;
BEGIN
    SELECT id INTO v_guide_id 
    FROM guides 
    WHERE title = 'Prompt Upgrader로 과목별 AI 튜터 만들기' 
    LIMIT 1;
    
    SELECT COUNT(*) INTO v_step_count 
    FROM guide_steps 
    WHERE guide_id = v_guide_id;
    
    SELECT COUNT(*) INTO v_section_count 
    FROM guide_sections 
    WHERE guide_id = v_guide_id 
    AND section_type IN ('summary', 'target_audience', 'preparation', 'core_principles');
    
    SELECT COUNT(*) INTO v_prompt_count 
    FROM guide_sections 
    WHERE guide_id = v_guide_id 
    AND section_type = 'prompt_pack';
    
    RAISE NOTICE '=== Guide Creation Verification ===';
    RAISE NOTICE 'Guide ID: %', v_guide_id;
    RAISE NOTICE 'Steps Created: % (Expected: 5)', v_step_count;
    RAISE NOTICE 'Overview Sections: % (Expected: 4)', v_section_count;
    RAISE NOTICE 'Prompt Pack Sections: % (Expected: 1)', v_prompt_count;
    
    IF v_step_count = 5 AND v_section_count = 4 AND v_prompt_count = 1 THEN
        RAISE NOTICE 'SUCCESS: All content inserted correctly!';
    ELSE
        RAISE WARNING 'WARNING: Some content may be missing!';
    END IF;
END $$;
