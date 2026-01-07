-- Migration to add "AI 개인 맞춤 설정" Guide
-- Using correct schema: 'estimated_time' (text), 'category_id' (int), 'difficulty', 'tags', JSONB for data fields

-- 1. Ensure "생산성" Category Exists
DO $cat$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM categories WHERE name = '생산성') THEN
        INSERT INTO categories (name, description)
        VALUES ('생산성', 'AI를 활용한 업무 효율화 및 자동화 가이드');
    END IF;
END $cat$;

-- 1.5. Ensure AI Models Exist
DO $models$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ai_models WHERE name ILIKE '%ChatGPT%') THEN
        INSERT INTO ai_models (name, provider, website_url, description, model_type)
        VALUES ('ChatGPT', 'OpenAI', 'https://chat.openai.com', 'OpenAI가 개발한 가장 인기 있는 대화형 AI 모델', 'Chat');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM ai_models WHERE name ILIKE '%Perplexity%') THEN
        INSERT INTO ai_models (name, provider, website_url, description, model_type)
        VALUES ('Perplexity', 'Perplexity AI', 'https://www.perplexity.ai', 'AI 기반 검색 엔진', 'Search');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM ai_models WHERE name ILIKE '%Gemini%') THEN
        INSERT INTO ai_models (name, provider, website_url, description, model_type)
        VALUES ('Gemini', 'Google', 'https://gemini.google.com', 'Google의 차세대 AI 모델', 'Chat');
    END IF;
END $models$;

-- 2. Insert Guide Metadata
DO $guide$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기') THEN
        INSERT INTO guides (title, description, estimated_time, category_id, ai_model_id, difficulty, tags)
        VALUES (
            $$15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기$$,
            $$대부분은 AI를 "기본값"으로 써서 손해 봅니다. 이 가이드대로 개인 맞춤 설정 + 마스터 프롬프트 + 시스템 프롬프트만 잡아두면, 같은 질문을 해도 결과 퀄리티가 달라집니다.$$,
            $$10~60분$$,
            (SELECT id FROM categories WHERE name = '생산성' LIMIT 1),
            (SELECT id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
            $$초급$$,
            ARRAY['개인맞춤설정', '커스텀인스트럭션', '마스터프롬프트', '시스템프롬프트', '프롬프트엔지니어링', '생산성', 'ChatGPT', 'Perplexity', 'Gemini', '워크플로우']
        );
    ELSE
        UPDATE guides SET
            description = $$대부분은 AI를 "기본값"으로 써서 손해 봅니다. 이 가이드대로 개인 맞춤 설정 + 마스터 프롬프트 + 시스템 프롬프트만 잡아두면, 같은 질문을 해도 결과 퀄리티가 달라집니다.$$,
            estimated_time = $$10~60분$$,
            category_id = (SELECT id FROM categories WHERE name = '생산성' LIMIT 1),
            ai_model_id = (SELECT id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1),
            difficulty = $$초급$$,
            tags = ARRAY['개인맞춤설정', '커스텀인스트럭션', '마스터프롬프트', '시스템프롬프트', '프롬프트엔지니어링', '생산성', 'ChatGPT', 'Perplexity', 'Gemini', '워크플로우']
        WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기';
    END IF;
END $guide$;

-- 3. Clear existing steps/sections for this guide to ensure clean slate
DELETE FROM guide_steps WHERE guide_id = (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1);
DELETE FROM guide_sections WHERE guide_id = (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1);

-- 3.5 Insert Guide Overview Sections (4 Cards)
INSERT INTO guide_sections (guide_id, section_type, section_order, title, content, data)
VALUES
(
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    'summary',
    0,
    '한 줄 요약',
    $$기본값으로 쓰면 AI가 "낯선 사람"처럼 답합니다. **내 정보(마스터 프롬프트)** + **답변 방식(맞춤 지침)**을 고정하세요. 잘 나온 결과를 "역추적"해 **시스템 프롬프트**로 저장하면 반복 작업이 자동화됩니다.$$,
    NULL
),
(
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    'target_audience',
    1,
    '이런 분께 추천',
    NULL,
    $$[
        "매번 \"말투/형식/길이\"를 다시 요구하는 분",
        "과제/리서치/기획서를 AI로 뽑는데 퀄리티가 들쭉날쭉한 분",
        "팀/프로젝트 단위로 AI를 \"일관되게\" 쓰고 싶은 분"
    ]$$::jsonb
),
(
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    'preparation',
    2,
    '준비물',
    NULL,
    $$[
        "PC(설정 화면 확인이 더 쉬움)",
        "메모장/노션/구글독스(마스터 프롬프트 저장용)",
        "내가 자주 하는 작업 3가지 목록(예: 리서치, 글쓰기, 기획)"
    ]$$::jsonb
),
(
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    'core_principles',
    3,
    '핵심 사용 원칙',
    NULL,
    $$[
        { "title": "\"정보(나)\"와 \"행동(답변 방식)\" 분리", "description": "내 배경/목표는 마스터 프롬프트에, 답변 형식/톤은 설정에 각각 저장합니다." },
        { "title": "2단 구조: 짧은 설정 + 긴 문서", "description": "설정 칸에는 10줄 이내 규칙만, 자세한 맥락은 별도 마스터 프롬프트 문서로 관리합니다." },
        { "title": "역설계: 좋은 결과 → 규칙 추출", "description": "최고의 출력이 나오면 그걸 만든 과정을 시스템 프롬프트로 고정합니다." }
    ]$$::jsonb
);

-- 4. Insert Steps (총 5개)

-- Step 1
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    1,
    $$내 "마스터 프롬프트"를 만들 질문지를 AI로 뽑기$$,
    $$나에 대한 정보를 AI가 정확히 묻도록 "인터뷰 질문 리스트" 생성$$,
    $$- 10~25개 질문 리스트 확보(업무/목표/말투/제약 포함)$$,
    $$#### Why This Matters
핵심은? AI가 좋은 답을 하려면 **맥락(Context)**이 필요합니다. 근데 대부분은 "내가 뭘 원하는 사람인지"를 AI에게 한 번도 정리해준 적이 없어요. 그래서 먼저 AI가 나를 인터뷰하게 만들면, 빠르게 '내 설명서'를 만들 수 있습니다.

#### (B) Actions
1. 내가 자주 하는 작업 3가지를 적기(예: 리서치/글/기획)
2. "내가 싫어하는 출력" 3가지 적기(예: 장황함/이모지 과다/근거 없음)
3. 아래 프롬프트로 질문 리스트 생성
4. 질문에 답을 달기(라이트 10분 / 딥 30~45분)

#### (C) Copy Block
```markdown
너는 나의 '마스터 프롬프트'를 만들기 위한 인터뷰어다.

목표: 내가 AI에게 원하는 기본 맥락(내 배경/역할/목표/제약/선호)을 수집해,
최종적으로 "마스터 프롬프트(1~2페이지)"를 만들 수 있게 질문해줘.

요구사항:
- 질문은 15~25개
- 4개 섹션으로 나눠줘: (1) 나/배경 (2) 목표/성과지표 (3) 선호하는 출력 스타일 (4) 금지/제약/리스크
- 각 질문은 짧고 구체적으로
- 마지막에 "답변 예시" 1개만 보여줘
시작해줘.
```

#### (E) Branch
**Case A (7~10분 라이트):** "나/목표/선호"만 답하고, 민감한 숫자(돈/개인정보)는 생략

**Case B (30~60분 딥):** 반복 업무/의사결정 기준/실패 패턴까지 답해서 "실전용"으로 만들기$$,
    $$- (X) 실수: 질문에 대충 답해서 마스터 프롬프트가 추상적으로 됨
- (V) 팁: "예시 1개"를 꼭 붙이면 AI가 정확히 따라옵니다$$,
    $$- [ ] 목표가 숫자/기한/우선순위 중 1개 이상으로 표현됨
- [ ] 싫어하는 출력이 최소 3개 적혀 있음
- [ ] 반복 작업 3개가 명확함$$
);

-- Step 2
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    2,
    $$마스터 프롬프트(내 설명서) 1~2페이지로 확정하기$$,
    $$어떤 AI 툴에서도 재사용 가능한 "내 기본 맥락 문서" 완성$$,
    $$- 복붙 가능한 마스터 프롬프트 본문 + 버전명(v1.0)$$,
    $$#### (B) Actions
1. Step 1 답변을 한 덩어리로 정리
2. 아래 템플릿에 맞춰 AI에게 "마스터 프롬프트 v1.0" 생성 요청
3. 노션/구글독스/메모장에 저장(파일명: `MasterPrompt_v1.0`)

#### (C) Copy Block
```markdown
아래 내 답변을 바탕으로, 재사용 가능한 "마스터 프롬프트 v1.0"을 만들어줘.

형식:
1) 한 문단 요약(3~5줄)
2) 나의 역할/배경
3) 목표 & 우선순위
4) 자주 하는 작업 TOP3 (각각: 원하는 결과물/주의점)
5) 선호하는 답변 스타일(길이/구조/톤/근거 방식)
6) 금지사항 & 제약(환각 금지, 모르면 모른다고, 추측은 표시 등)
7) 확인 질문 규칙(필요할 때만 1~3개 질문)

추가 요구:
- 너무 길면 1~2페이지로 압축
- 복사-붙여넣기 쉬운 Markdown으로
- 맨 위에 버전과 날짜 표기

[내 답변]
(여기에 Step 1에서 답한 내용 붙여넣기)
```

#### (D) Example

> [!WARNING]
> **❌ 나쁜 예**
> 
> 입력: "창업 준비 도와줘"
> 
> 문제: 너무 추상적, 맥락 부족 → AI가 일반적인 답변만 제공

> [!TIP]
> **✅ 좋은 예**
> 
> 입력: "23살 물리학과 대학생, 창업 준비 중, 표/체크리스트 선호, 과장 싫어함"
> 
> 결과: 내 상황에 맞춘 요약 → 단계별 실행 → 리스크/대안 제시 (맞춤형 스타일 고정)$$,
    $$- (X) 실수: 마스터 프롬프트에 '해야 할 일(작업)'이 안 들어감
- (V) 팁: "TOP3 반복 작업"이 들어가야 체감 성능이 확 올라갑니다$$,
    $$- [ ] 1~2페이지 분량으로 압축됨
- [ ] 작업 TOP3마다 "원하는 결과물"이 있음
- [ ] 금지/제약(환각/추측 표기)이 명시됨$$
);

-- Step 3
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    3,
    $$개인 맞춤 설정을 3대 툴에 "짧게" 이식하기$$,
    $$매 대화마다 기본 말투/형식이 자동 적용되게 설정$$,
    $$- ChatGPT/Perplexity/Gemini 중 최소 1개에 "출력 스타일" 저장 완료$$,
    $$#### Why This Matters
핵심은? **긴 문서(마스터 프롬프트)**는 필요할 때 올리고, **짧은 설정(프로필/지침)**은 "기본값"으로 박아두는 겁니다. 그러면 매번 "표로 정리해줘" 같은 말을 반복하지 않아도 돼요.

#### (B) Actions
1. 내 마스터 프롬프트에서 "출력 스타일/금지사항"만 5~10줄로 요약
2. 아래 요약문을 각 툴의 개인화 설정 칸에 붙여넣기
3. 테스트 질문 1개로 결과 확인

#### (C) Copy Block
```markdown
[기본 출력 규칙]
- 결론 먼저, 그 다음 근거/절차
- 가능하면 불릿/체크리스트/표로 정리
- 과장 금지, 모르면 모른다고 말하고 확인 질문 1~3개만
- 추측은 '추측'이라고 표시
- 실행 가능한 다음 행동(Next step) 2~3개 포함
```

#### (E) Branch
**ChatGPT:** 설정 → "Personalization(개인 맞춤)" → 커스텀 지침

**Perplexity:** Settings → Profile → Preferred formatting / Communication style

**Gemini:** "Saved info(저장된 정보)" → 내 선호/상황 저장$$,
    $$- (X) 실수: 마스터 프롬프트 전체를 설정 칸에 그대로 넣어서 지저분해짐
- (V) 팁: 설정 칸에는 **"출력 규칙"만 짧게**, 자세한 건 마스터 프롬프트로 분리$$,
    $$- [ ] 10줄 안쪽으로 요약됨
- [ ] "모르면 확인 질문" 규칙이 있음
- [ ] 테스트 질문에서 형식(불릿/표)이 자동 적용됨$$
);

-- Step 4
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    4,
    $$최고의 결과물을 "시스템 프롬프트"로 역설계해 저장하기$$,
    $$내가 원하는 결과물을 "한 번에" 뽑는 시스템 프롬프트 확보$$,
    $$- 시스템 프롬프트 1개 이상을 라이브러리에 저장$$,
    $$#### Why This Matters
핵심은? AI 결과가 들쭉날쭉한 이유는 대부분 **요구사항이 매번 달라지기 때문**입니다. 그래서 "좋은 결과"가 나올 때까지 조금씩 다듬고, 최종본이 나오면 그걸 만든 규칙을 **시스템 프롬프트로 고정**하면 됩니다.

#### (B) Actions
1. 이메일/기획서/광고문 등 "반복 산출물 1개" 선택
2. AI 출력 → 내가 원하는 방향으로 3~5번 수정 지시
3. (가능하면) Canvas 같은 편집 화면에서 문장을 직접 다듬기
4. 최종본이 나오면 아래 프롬프트로 "시스템 프롬프트" 추출

#### (C) Copy Block
```markdown
아래 [최종 결과물]을 처음부터 생성하려면,
어떤 "시스템 프롬프트(규칙/절차/톤/포맷/금지사항)"가 필요했는지 작성해줘.

요구사항:
- 역할(Role), 목표(Goal), 작업 절차(Process), 출력 포맷(Format), 금지사항(Do not)
- 환각 방지: 근거 없는 단정 금지, 불확실하면 질문하기
- 길이는 A4 1페이지 이내로 압축
- 마지막에 "재사용 방법"을 3줄로 설명

[최종 결과물]
(여기에 내가 만족한 최종 텍스트 붙여넣기)
```

#### (E) Branch
**Case A (짧게):** "내 톤/포맷"만 고정하는 라이트 시스템 프롬프트

**Case B (강하게):** "절차(리서치→구조화→검증→출력)"까지 포함한 SOP형 시스템 프롬프트$$,
    $$- (X) 실수: "좀 더 잘 써줘" 같은 추상 지시만 반복함
- (V) 팁: 수정 지시는 **구체 규칙(길이/구조/금지어/검증 방식)**으로 바꾸면 바로 좋아집니다$$,
    $$- [ ] Role/Process/Format/Do-not가 포함됨
- [ ] "불확실하면 질문" 규칙이 있음
- [ ] 같은 작업에서 2번 재사용해도 결과가 안정적임$$
);

-- Step 5
INSERT INTO guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    5,
    $$(선택) 프로젝트 폴더/커스텀 GPT·Gem으로 "버튼화"하기$$,
    $$자주 쓰는 시스템 프롬프트를 "도구"로 만들어 반복 비용 제거$$,
    $$- (택1) ChatGPT Project 1개 생성 OR 커스텀 GPT 1개 생성 OR Gemini Gem 1개 생성$$,
    $$#### (B) Actions
1. 자주 하는 주제 1개 선택(예: "리서치", "콘텐츠 제작", "사업 기획")
2. 관련 문서(마스터 프롬프트/자료)를 한 곳에 모으기
3. **ChatGPT Projects**로 컨텍스트 묶기(채팅/파일/지침을 한 폴더로)
4. 또는 **Custom GPT**로 시스템 프롬프트를 저장해 버튼처럼 쓰기
5. 또는 **Gemini Gems**로 반복 작업용 "커스텀 전문가" 만들기

#### Why This Matters
핵심은? **(1) 마스터 프롬프트 문서 1개 + (2) 개인 맞춤 설정 1개 + (3) 시스템 프롬프트 1개**이 3개가 있으면, 대부분의 반복 작업은 "한 번에" 품질이 고정됩니다.

#### (D) Example
**Next steps**
- (추천) 시스템 프롬프트를 3개로 늘리기: 리서치 / 글쓰기 / 기획서
- (추천) "프롬프트 라이브러리" 폴더를 노션에 만들고 버전 관리(v1.0→v1.1)
- (팀이면) 잘 먹힌 시스템 프롬프트를 공유해서 팀 표준으로 만들기$$,
    $$- (X) 실수: 모든 걸 한 번에 자동화하려다 포기함
- (V) 팁: "가장 자주 하는 산출물 1개"만 먼저 버튼화하세요$$,
    $$- [ ] 마스터 프롬프트 v1.0 저장됨
- [ ] 설정(프로필/저장 정보)에 출력 규칙이 들어감
- [ ] 시스템 프롬프트 1개를 재사용해도 품질이 유지됨$$
);

-- 5. Insert Prompt Pack (guide_sections with section_type='prompt_pack')
INSERT INTO guide_sections (guide_id, section_type, section_order, title, data)
VALUES (
    (SELECT id FROM guides WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' LIMIT 1),
    'prompt_pack',
    1,
    'AI 개인 맞춤 설정 필수 프롬프트 팩',
    $$[
      {
        "id": "pack_1_interviewer",
        "title": "마스터 프롬프트 인터뷰어",
        "description": "내 정보를 AI가 알아서 물어보게 해서, 빠르게 \"내 설명서\"를 만들고 싶을 때 사용합니다.",
        "prompt": "너는 나의 '마스터 프롬프트'를 만드는 인터뷰어다.\n15~25개의 질문을 4개 섹션(배경/목표/출력선호/제약)으로 나눠서 한 번에 제시해줘.\n질문은 짧고 구체적으로. 마지막에 답변 예시 1개만 보여줘.",
        "usage": "마스터 프롬프트 작성을 위한 인터뷰 질문 생성",
        "failurePatterns": "- ❌ 실패: 질문이 너무 포괄적임\n- ✅ 수정: \"예/아니오 + 구체 선택지\"로 바꿔달라고 요청",
        "relatedStep": [1],
        "tags": ["마스터프롬프트", "인터뷰", "질문생성"]
      },
      {
        "id": "pack_2_generator",
        "title": "마스터 프롬프트 생성기(v1.0)",
        "description": "인터뷰 답변을 1~2페이지 문서로 정리하고 싶을 때 사용합니다.",
        "prompt": "아래 내 답변을 바탕으로 \"마스터 프롬프트 v1.0\"을 작성해줘.\n포함: 요약/역할/목표/반복작업TOP3/출력스타일/금지&제약/확인질문 규칙\n형식: 복붙 쉬운 Markdown, 1~2페이지로 압축, 버전/날짜 포함.\n\n[내 답변]\n(붙여넣기)",
        "usage": "인터뷰 답변을 마스터 프롬프트 문서로 변환",
        "failurePatterns": "- ❌ 실패: 너무 김\n- ✅ 수정: \"절반 길이로 압축 + 핵심 불릿만\" 추가 요청",
        "relatedStep": [2],
        "tags": ["마스터프롬프트", "문서생성", "정리"]
      },
      {
        "id": "pack_3_settings",
        "title": "출력 스타일 \"설정용 요약문\" 생성기",
        "description": "설정 칸(프로필/저장 정보/커스텀 지침)에 넣을 짧은 규칙이 필요할 때 사용합니다.",
        "prompt": "아래 마스터 프롬프트를 읽고,\n설정 칸에 넣을 \"출력 규칙 7줄\"로 요약해줘.\n조건: 불릿 형태, 금지사항 2개 포함, '불확실하면 질문' 포함.\n\n[마스터 프롬프트]\n(붙여넣기)",
        "usage": "마스터 프롬프트를 설정용 짧은 규칙으로 압축",
        "failurePatterns": "- ❌ 실패: 너무 일반적임\n- ✅ 수정: \"내가 싫어하는 출력 3개를 반드시 반영\"이라고 추가",
        "relatedStep": [3],
        "tags": ["설정", "요약", "출력규칙"]
      },
      {
        "id": "pack_4_reverse",
        "title": "시스템 프롬프트 역설계(최종본 → 규칙 추출)",
        "description": "내가 만족한 최종 결과물을 \"한 방\"에 뽑는 규칙으로 저장하고 싶을 때 사용합니다.",
        "prompt": "아래 [최종 결과물]을 처음부터 생성하는 \"시스템 프롬프트\"를 작성해줘.\n포함: Role / Goal / Process / Output Format / Do-not / Quality checklist\n길이: A4 1페이지 이내. 불확실하면 질문하는 규칙 포함.\n\n[최종 결과물]\n(붙여넣기)",
        "usage": "좋은 결과물로부터 시스템 프롬프트 추출",
        "failurePatterns": "- ❌ 실패: 프롬프트가 장황함\n- ✅ 수정: \"핵심 규칙 10개만 남기고 압축\" 요청",
        "relatedStep": [4],
        "tags": ["시스템프롬프트", "역설계", "규칙추출"]
      },
      {
        "id": "pack_5_refactor",
        "title": "주간 프롬프트 리팩토링(버전업 루프)",
        "description": "내 프롬프트가 점점 안 먹힐 때, 주 1회 성능을 안정화할 때 사용합니다.",
        "prompt": "아래는 내가 쓰는 (1) 마스터 프롬프트, (2) 시스템 프롬프트, (3) 최근 대화 1개다.\n문제점(모호함/중복/충돌)을 찾아서,\nv1.1로 개선안을 제시해줘: 바꿀 문장(전/후), 이유, 테스트 질문 2개.\n\n[마스터 프롬프트]\n...\n[시스템 프롬프트]\n...\n[최근 대화]\n...",
        "usage": "프롬프트 버전업 및 성능 개선",
        "failurePatterns": "- ❌ 실패: 개선이 추상적임\n- ✅ 수정: \"문장 단위 전/후를 반드시 표로\"라고 요구",
        "relatedStep": [5],
        "tags": ["리팩토링", "버전관리", "개선"]
      }
    ]$$::jsonb
);

-- 6. Verify Insertion
DO $verify$
DECLARE
    v_guide_id INTEGER;
    v_step_count INTEGER;
    v_section_count INTEGER;
    v_prompt_count INTEGER;
BEGIN
    SELECT id INTO v_guide_id 
    FROM guides 
    WHERE title = '15분 만에 끝내는 AI 개인 맞춤 설정: ChatGPT·Perplexity·Gemini "내 스타일"로 고정하기' 
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
END $verify$;
