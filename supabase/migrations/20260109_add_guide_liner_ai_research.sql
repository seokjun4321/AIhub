-- Migration: Add Guide "Liner AI로 논문 읽는 법" (Full Content)
-- Date: 2026-01-09

BEGIN;

-- 1. Ensure "Liner AI" Model Exists
DO $migration$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.ai_models WHERE name ILIKE '%Liner AI%') THEN
        INSERT INTO public.ai_models (name, provider, website_url, description)
        VALUES ('Liner AI', 'Liner', 'https://liner.com', '학술 논문 검색 및 요약에 특화된 AI 검색 엔진');
    END IF;
END $migration$;

-- 2. Insert Guide and Update Metadata
DO $migration$
DECLARE
    v_category_id INTEGER;
    v_model_id INTEGER;
    v_guide_id INTEGER := 18;
BEGIN
    -- Get Category: Assuming '연구 & 학습' based on context (or 'AI 학습 도구' if mapped)
    -- User said 'AI 학습 도구' is top category, but DB categories might be '연구 & 학습' etc.
    -- Let's stick to '연구 & 학습' as it fits best.
    SELECT id INTO v_category_id FROM public.categories WHERE name = '연구 & 학습' LIMIT 1;
    SELECT id INTO v_model_id FROM public.ai_models WHERE name ILIKE '%Liner AI%' LIMIT 1;

    INSERT INTO public.guides (id, title, description, estimated_time, difficulty_level, category_id, ai_model_id, tags)
    OVERRIDING SYSTEM VALUE
    VALUES (
        v_guide_id,
        'Liner AI로 논문 읽는 법 (Updated)',
        '100페이지 논문을 5분 만에 핵심만 파악하고, 그 논문이 정말 신뢰할 만한지 출처까지 확인하는 완벽한 논문 읽기 전략입니다.',
        '1~2시간 (전체 프로세스 이해 + 실습)',
        'intermediate', -- 초급~중급
        v_category_id,
        v_model_id,
        ARRAY['Liner AI', '논문 읽기', '학술 검색', '논문 요약', 'PDF 분석', '출처 확인', '연구 방법', '문헌 조사']
    )
    ON CONFLICT (id) DO UPDATE SET
        title = EXCLUDED.title,
        description = EXCLUDED.description,
        estimated_time = EXCLUDED.estimated_time,
        difficulty_level = EXCLUDED.difficulty_level,
        category_id = EXCLUDED.category_id,
        ai_model_id = EXCLUDED.ai_model_id,
        tags = EXCLUDED.tags;

    -- Many-to-Many Category
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    VALUES (v_guide_id, v_category_id, true)
    ON CONFLICT (guide_id, category_id) DO NOTHING;

    -- 3. Guide Sections (Overview Cards)
    DELETE FROM public.guide_sections WHERE guide_id = v_guide_id;

    INSERT INTO public.guide_sections (guide_id, section_type, section_order, title, content, data)
    VALUES
    (v_guide_id, 'summary', 0, '한 줄 요약', 'Liner AI는 AI 검색 엔진으로, 긴 논문을 자동 요약하고 모든 정보가 어디서 왔는지 출처까지 보여줍니다.', NULL),
    (v_guide_id, 'target_audience', 1, '이런 분께 추천', NULL, $$[
        "대학원 진학하거나 학위논문을 쓰려고 논문을 많이 읽어야 하는 학생",
        "리포트/에세이를 쓰는데 신뢰할 만한 출처를 찾고 싶은 사람",
        "영어 논문은 읽기 싫지만 핵심만 빠르게 알고 싶은 사람",
        "\"구글 검색\"처럼 아무거나 나오는 걸 싫어하고 학술 자료만 원하는 연구자",
        "시장조사, 직무보고서 등 업무에서 신뢰할 수 있는 근거가 필요한 직장인"
    ]$$::jsonb),
    (v_guide_id, 'preparation', 2, '준비물', NULL, $$[
        "Liner AI 무료 계정 (회원가입만 하면 OK)",
        "읽고 싶은 논문 PDF 또는 주제",
        "웹 브라우저 (Chrome, Safari 등)",
        "논문을 읽을 때 사용할 메모장 또는 Notion (선택사항)"
    ]$$::jsonb),
    (v_guide_id, 'core_principles', 3, '핵심 사용 원칙', NULL, $$[
        { "title": "\"출처\"를 항상 확인하기", "description": "Liner가 무조건 맞다고 믿지 말고 line-by-line citation 확인" },
        { "title": "Scholar Mode 활용", "description": "\"일반 검색\"과 \"학술 검색\"을 용도에 맞게 구분" },
        { "title": "PDF 업로드로 번역+요약 동시에", "description": "영어 논문은 업로드 후 AI 번역 + 요약으로 1/10 시간 단축" },
        { "title": "Deep Research로 \"맥락 파악\"", "description": "개별 논문이 아니라 그 분야 전체 흐름을 먼저 이해" },
        { "title": "비판적 읽기", "description": "AI 요약 + 직접 논문 스캔 → 2회독 전략으로 실력 2배 상승" }
    ]$$::jsonb);

    -- 4. Guide Steps
    -- Ensure no stray prompts exist for this guide (delete by step association)
    DELETE FROM public.guide_prompts WHERE step_id IN (SELECT id FROM public.guide_steps WHERE guide_id = v_guide_id);
    DELETE FROM public.guide_steps WHERE guide_id = v_guide_id;

    -- Step 1
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 1, 'Liner AI 가입하고 첫 로그인하기 (3분)',
        'Liner AI 계정을 만들고, 로그인해서 홈 화면까지 본다.',
        $$- liner.com에서 회원가입 완료
- 이메일 또는 구글 계정으로 로그인됨
- Liner AI 홈 화면이 보임$$,
        $$#### (A) 왜 이 단계가 필요한가
Liner AI는 **한국에서 만들었지만 전 세계 연구자들이 쓰는 AI 검색 엔진**입니다. 학생·연구자·직장인들이 논문을 빠르게 정리하기 위해 쓰는 필수 도구예요.
특히 **학술 자료에 신뢰도가 중요한 분야**(대학원, 연구소, 기업 R&D 등)에서 최신 연구를 5분 만에 파악하는 데 강력합니다.

#### (B) 해야 할 일
1. 웹 브라우저 열기 (Chrome, Safari, Edge 뭐든 OK)
2. 주소창에 `liner.com` 또는 `getliner.com` 입력
3. 오른쪽 상단 "Sign Up" 또는 "Get Started" 클릭
4. 로그인 방법 선택:
   - 구글 계정으로 (가장 빠름)
   - 또는 이메일 + 비밀번호
5. 이메일 인증 (받은 메일에서 확인 링크 클릭)
6. 로그인 완료 → Liner AI 메인 화면 진입

#### (D) 예시: 가입 후 화면
정상적으로 가입되면 화면에 보이는 것:
```
상단 좌측: Liner 로고
상단 우측: 프로필 아이콘 + Settings
중앙: 검색창 (Search for anything)
하단: Scholar Mode / General Mode 토글
```
✅ 위 화면이 보이면 **가입 완료!**

#### (D) 예시: 가입 방법
**구글 계정으로 가입:**
1. liner.com 접속
2. "Sign up with Google" 클릭
3. 구글 로그인
4. 완료!

**이메일로 가입:**
1. liner.com 접속
2. 이메일 입력 → 비밀번호 설정
3. 회원가입 메일 확인
4. 완료!
$$,
        E'- (X) 실수: 구글 계정과 이메일 계정을 동시에 만듦 (헷갈림)\n- (V) 팁: **하나만 선택**하세요. 구글 계정이 가장 편합니다\n- (X) 실수: 가입 후 메일함을 안 확인\n- (V) 팁: 확인 메일이 안 오면 **스팸 폴더** 확인\n- (X) 실수: 무료 버전인 줄 모르고 유료 플랜 구독\n- (V) 팁: 일단 무료로 충분히 써본 후 필요하면 업그레이드',
        $$[{"id": "q1", "text": "liner.com에 접속됨"}, {"id": "q2", "text": "회원가입 또는 로그인 완료"}, {"id": "q3", "text": "Liner AI 메인 화면이 보임 (검색창 + Scholar Mode 토글)"}, {"id": "q4", "text": "프로필 아이콘 클릭해서 Settings에 들어갈 수 있음"}]$$::jsonb
    );

    -- Step 2
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 2, 'Scholar Mode와 General Mode의 차이 이해하기 (5분)',
        '"학술 검색"과 "일반 검색"의 차이를 알고, 어떨 때 뭘 쓸지 판단한다.',
        $$- Scholar Mode = 학술 논문 중심 검색 을 이해함
- General Mode = 일반 웹 검색 을 이해함
- 자신의 상황에 맞게 선택할 수 있음$$,
        $$#### (A) 왜 이 단계가 필요한가
Liner AI의 가장 큰 강점은 **"뭘 검색할지 고를 수 있다"**는 것입니다.
- **Scholar Mode**: Google Scholar처럼 **논문, 학술자료만** 나옴 (신뢰도 높음)
- **General Mode**: 뉴스, 블로그, 위키백과 등 **일반 웹 자료도** 포함 (범위 넓음)

#### (CMP) Scholar Mode vs General Mode 비교
| 항목 | Scholar Mode (학술 모드) | General Mode (일반 모드) |
| :--- | :--- | :--- |
| **검색 대상** | 학술 논문, 학술지 | 뉴스, 블로그, SNS, 논문 |
| **신뢰도** | ⭐⭐⭐⭐⭐ (높음) | ⭐⭐⭐ (중간) |
| **최신성** | 느림 (논문 출판 지연) | 빠름 (실시간 뉴스) |
| **사용 시기** | 논문, 리포트, 연구 | 일반 정보, 트렌드 |
| **예시 쿼리** | "Climate change strategy" | "기후변화 최신 뉴스" |

#### (B) 해야 할 일
1. Liner AI 메인 화면에서 우측 상단 토글 확인
2. 토글이 "Scholar Mode"로 되어 있는지, "General Mode"인지 확인
3. 각 모드에서 같은 질문을 검색해보기
4. 결과 차이 관찰하기

#### (D) 예시: 같은 질문을 두 모드로 검색
**질문:** "인공지능의 윤리적 문제는?"

**Scholar Mode 결과:**
- "Ethics of Artificial Intelligence: A Systematic Review" (논문)
- 출처: Nature, IEEE, ACM 등 학술지

**General Mode 결과:**
- "AI 챗봇 편향 논란" (뉴스)
- "전문가가 말하는 AI 윤리 이슈" (블로그)
- 출처: 뉴스사, 블로그, 일반 웹사이트 등

👉 **"학술적 근거"가 필요하면 Scholar Mode, "최신 소식"이 필요하면 General Mode**

#### (E) 분기: 어떤 모드를 주로 쓸까?
**학술 연구/학위논문 작성:**
- 문헌 조사: Scholar Mode
- 이론적 배경: Scholar Mode

**직무 보고서/시장 조사:**
- 기술 검증: Scholar Mode
- 산업 동향: General Mode

**개인 학습:**
- 깊이 있는 이해: Scholar Mode
- 빠른 개요 파악: General Mode
$$,
        E'- (X) 실수: Scholar Mode만 쓰다가 최신 정보를 놓침\n- (V) 팁: **둘 다 병행**하세요. Scholar는 깊이, General은 너비\n- (X) 실수: General Mode에서 모든 정보를 믿음\n- (V) 팁: General Mode는 **출처 검증이 필수**\n- (X) 실수: 모드를 계속 헷갈려서 왔다갔다 함\n- (V) 팁: 처음엔 Scholar로만 쓰고, 익숙해지면 상황에 맞게 전환',
        $$[{"id": "q1", "text": "Liner 메인 화면에서 Scholar Mode / General Mode 토글을 찾을 수 있는가?"}, {"id": "q2", "text": "두 모드의 차이를 설명할 수 있는가?"}, {"id": "q3", "text": "논문을 조사하면 Scholar Mode를 쓸 거야라고 결정했는가?"}, {"id": "q4", "text": "최신 뉴스도 필요하면 General Mode를 쓸 거야라고 이해했는가?"}]$$::jsonb
    );

    -- Step 3
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 3, '첫 검색 실행하기 - 간단한 학술 질문부터 (5분)',
        '실제로 Liner AI에서 학술 검색을 해보고, 결과가 어떻게 나오는지 경험한다.',
        $$- Scholar Mode에서 검색 시도
- 검색 결과 페이지를 봤는데, "오, 논문들이 나오네"라고 느낌
- 출처 링크를 최소 1개 클릭해봤음$$,
        $$#### (A) 왜 이 단계가 필요한가
**이론만으로는 감을 못 잡습니다.** 직접 검색해봐야 "아, 이게 이렇게 작동하는구나"를 느껴요.
Step 3은 "**검색하면 정말 논문이 나오나?**"라는 의심을 확실히 없애주는 단계입니다.

#### (B) 해야 할 일
1. Liner AI 홈페이지 메인에서 검색창 찾기
2. Scholar Mode가 켜져 있는지 확인 (토글 확인)
3. 간단한 학술 질문 입력 ("기후 변화 대응 전략", "AI와 의료" 등)
4. 검색 결과 페이지 관찰
5. 결과 중 1~2개 출처 클릭해서 내용 확인

#### (C) 과학 분야 예시
"Quantum computing applications"
"CRISPR gene editing ethics"
"Dark matter detection methods"

#### (C) 의학 분야 예시
"mRNA vaccine development"
"Cancer immunotherapy research"
"Mental health AI interventions"

#### (C) 사회과학 분야 예시
"Remote work productivity studies"
"Digital transformation in education"
"Social media impact on democracy"

#### (C) 공학 분야 예시
"Battery technology advances"
"5G network architecture"
"Autonomous vehicle safety"

#### (C) 경제/경영 분야 예시
"Cryptocurrency market analysis"
"ESG investment strategies"
"Supply chain resilience"

#### (D) 예시: 검색 후 화면
**입력:**
```
"Renewable energy storage solutions"
```

**Liner가 반환:**
```
1. Paper: "Grid-Scale Battery Storage: Economics"
   Journal: Nature Energy, 2024
   
2. Paper: "Hydrogen as Energy Storage"
   Journal: Energy Reviews, 2023

3. 요약: "재생에너지 저장 기술은 배터리와 수소 저장이..."
```
👉 **이런 식으로 논문들이 출처와 함께 정렬되어 나옵니다.**

#### (E) 분기: 결과가 없으면?
**이건 정상입니다.**
- 너무 좁은 주제면 논문이 없을 수 있음 ("한국 수원시 태양광")
- 해결: 주제를 조금 더 일반화해서 다시 검색 ("태양광 발전 효율")
$$,
        E'- (X) 실수: "이 결과가 정말 정확한가?"라고 의심만 하고 링크 안 봄\n- (V) 팁: **그냥 클릭해봐요.** 출처가 Nature, IEEE 같으니 신뢰도 높습니다\n- (X) 실수: 한국어로만 검색하려고 함\n- (V) 팁: 영어로 검색하면 **훨씬 많은 논문** 나옵니다\n- (X) 실수: 첫 검색 결과에서 깊게 파고들려고 함\n- (V) 팁: 일단 표면만 훑어보세요. 다음 스텝에서 깊게 읽습니다',
        $$[{"id": "q1", "text": "Scholar Mode가 켜져 있는가?"}, {"id": "q2", "text": "검색창에 질문을 입력했는가?"}, {"id": "q3", "text": "검색 결과가 논문 형식으로 나왔는가?"}, {"id": "q4", "text": "출처 링크를 최소 1개 클릭해봤는가?"}]$$::jsonb
    );

    -- Step 4
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 4, 'PDF 업로드로 논문 한 번에 분석하기 (10분)',
        '논문 PDF를 Liner AI에 업로드해서 자동으로 요약, 번역, 분석을 받는다.',
        $$- 논문 PDF 1개를 Liner에 업로드
- AI가 자동으로 요약을 생성함
- "오, 이 논문이 이런 내용이구나"를 5초 만에 파악$$,
        $$#### (A) 왜 이 단계가 필요한가
**논문 1개를 읽는 데 평균 1~2시간이 걸립니다.**
하지만 Liner AI에 PDF를 업로드하면:
- ✅ 30초: AI가 자동 요약
- ✅ 1분: 핵심 내용 파악
- ✅ 2분: "이 논문을 읽어야 하나?" 판단
**즉, 1~2시간 → 5분으로 단축**되는 거예요.

#### (B) 해야 할 일
1. Liner AI 메인 페이지에서 "Upload" 또는 "Create" 버튼 찾기
2. "Upload PDF" 또는 "Upload Document" 선택
3. 컴퓨터에서 PDF 파일 선택
4. 업로드 완료 (자동으로 분석 시작)
5. 요약 결과 대기 (10초~1분)
6. AI가 만든 요약 읽기

#### (C) 프롬프트: PDF 업로드 후 요청
```text
"이 논문의 핵심 결론을 3줄로 정리해줄래?"
"이 논문이 기존 연구와 어떻게 다른가?"
"이 논문의 한계점은 뭐야?"
"영어 논문인데 한글로 번역해줄 수 있어?"
"이 논문에서 가장 중요한 그림/차트는 뭐야?"
```

#### (D) 예시: 실제 사용 과정
**시나리오:**
1. Google Scholar에서 "Deep Learning for Medical Diagnosis" PDF 다운로드
2. Liner AI에 업로드

**Liner AI가 반환 (20초 안):**
```
[자동 요약]
제목: Deep Learning for Medical Diagnosis
주요 내용:
- 딥러닝의 의료 진단 적용 현황 정리
- CNN, RNN, Transformer 모델 비교
- 주요 질병(암, 심장병) 탐지 정확도 향상

핵심 기여도: ⭐⭐⭐⭐ (중요한 리뷰 논문)
읽을 가치: 높음
```
👉 **50페이지 논문이 5문장으로 정리됩니다.**

#### (E) 분기: 무료 vs Pro 버전
**무료 버전:**
- 기본 요약 가능, 월 사용량 제한
**Pro 버전:**
- 더 상세한 요약, 무제한 사용
→ **일단 무료로 충분합니다.**
$$,
        E'- (X) 실수: 300페이지 논문을 다 업로드해서 요약 안 됨\n- (V) 팁: **처음엔 10~30페이지 논문**으로 시작하세요\n- (X) 실수: AI 요약만 믿고 논문을 안 봄\n- (V) 팁: AI 요약으로 "읽을 가치"만 판단하고, 깊은 내용은 직접 읽기\n- (X) 실수: 영어 논문을 업로드한 후 "한글로 설명해줘"라고 따로 요청\n- (V) 팁: **Pro 버전**에서는 자동 번역도 가능',
        $$[{"id": "q1", "text": "PDF 파일을 Liner AI에 업로드할 수 있는가?"}, {"id": "q2", "text": "AI가 자동으로 요약을 생성했는가?"}, {"id": "q3", "text": "요약을 읽고 내용을 느꼈는가?"}, {"id": "q4", "text": "추가로 이 논문의 한계점은? 이라고 질문해봤는가?"}]$$::jsonb
    );

    -- Step 5
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 5, 'Line-by-Line Citation으로 출처 검증하기 (10분)',
        'Liner AI가 제시한 정보가 정말 어디서 왔는지 추적하고, "신뢰도 검증"을 한다.',
        $$- Liner AI의 답변에서 1개 이상의 citation을 클릭
- 원본 논문/자료를 직접 확인
- "아, Liner가 이 논문의 이 문장에서 가져온 거구나"를 확인$$,
        $$#### (A) 왜 이 단계가 필요한가
**AI는 틀릴 수 있습니다.** Liner의 강점은 **"모든 정보에 line-by-line citation이 있다"**는 것입니다.
Liner가 말한 각 문장이 **정확히 어느 논문의 어느 페이지에서 왔는지** 추적할 수 있어요.
이건 Google 검색이나 ChatGPT와는 **완전히 다른 수준의 투명성**입니다.

#### (B) 해야 할 일
1. Liner AI에서 검색 또는 질문 입력
2. 답변 받기
3. 답변 중 하이라이트 부분 클릭
4. 오른쪽 패널에서 "출처" 항목 확인
5. 출처 링크 클릭해서 **원본 논문의 해당 부분** 직접 확인

#### (D) 예시: Citation 확인
**Liner AI의 답변:**
"CRISPR-Cas9 기술은 2012년 Doudna와 Charpentier에 의해..." [1]

**링크 클릭 후 보는 것:**
- 원본 논문: "A Programmable Dual-RNA-Guided..."
- 해당 인용: "We propose an alternative methodology..."
- 페이지: 816, Science

#### (D) 예시: 실제 검증 과정
**시나리오:** "태양광 발전의 평균 효율은?"
**Liner 답변:** "평균 15-22% 수준이며, 실험실에서는 47%까지 도달[1][2]."

**검증:**
1. 링크 클릭 → Nature Energy 논문 확인[1]
2. 링크 클릭 → Science 논문 확인[2]
3. "오, 이 데이터를 내 논문에 인용해도 되겠네" 납득

#### (E) 분기: Citation이 없으면?
**위험 신호입니다.**
해결: "출처를 보여줄 수 있어?"라고 다시 요청하거나, Scholar Mode로 전환
$$,
        E'- (X) 실수: "Liner가 citation을 줬으니까 100% 맞다"고 믿음\n- (V) 팁: Citation은 "투명성"일 뿐, **최종 판단은 본인**이 해야 합니다\n- (X) 실수: Citation을 클릭하는 데 시간이 오래 걸려서 포기\n- (V) 팁: 처음엔 시간 걸리지만, 익숙해지면 10초 안에 가능',
        $$[{"id": "q1", "text": "Liner AI의 답변에서 citation(파란 링크)을 찾을 수 있는가?"}, {"id": "q2", "text": "그 링크를 클릭했을 때 원본 논문이 열렸는가?"}, {"id": "q3", "text": "원본 논문에서 Liner가 이 부분을 인용했구나라고 확인했는가?"}, {"id": "q4", "text": "이 출처가 신뢰할 만한가를 판단할 수 있는가?"}]$$::jsonb
    );

    -- Step 6
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 6, 'Deep Research로 한 분야 전체 맥락 파악하기 (15분)',
        '개별 논문이 아니라 "한 분야 전체의 흐름"을 한 번에 파악하는 Deep Research 기능을 써본다.',
        $$- Liner의 "Deep Research" 기능을 실행
- 1개의 학술 분야에 대해 360도 종합 리포트 받기
- "오, 이 분야가 이렇게 발전했구나"를 깨달음$$,
        $$#### (A) 왜 이 단계가 필요한가
**"이 분야의 최신 동향이 뭐지?" → 논문 10개를 읽어야 함 (2시간)**
**vs Liner AI의 Deep Research → 자동 요약 (3분)**
학위논문의 "Literature Review"나 시장조사를 할 때 가장 강력한 무기입니다.

#### (B) 해야 할 일
1. Liner AI 메인 페이지에서 "Deep Research" 찾기
2. 연구 질문 입력 ("기후변화 대응 기술 동향", "디지털 헬스케어 발전" 등)
3. 리서치 시작 클릭
4. 결과 대기 (2~5분)
5. 자동 생성된 종합 리포트 읽기

#### (D) 예시: Deep Research 추천 쿼리
**과학기술:**
```text
"What are the latest advances in quantum computing 
and their practical applications as of 2025?"
```

**의료:**
```text
"How is AI being applied to drug discovery 
and what are the success rates?"
```

**환경/에너지:**
```text
"Current state of carbon capture technologies 
and their economic feasibility"
```

**사회과학:**
```text
"Impact of remote work on organizational productivity: 
recent research findings"
```

#### (D) 예시: Deep Research 결과
**입력:** "Current trends in renewable energy storage"
**결과:**
```
[Comprehensive Report]
1. Overview: 재생에너지 저장 기술 현황
2. Major Technologies: 리튬이온(주류), 고체전해질(차세대)
3. Technical Challenges: 에너지 밀도, 비용, 수명 (논문 40개 분석)
4. Market Analysis: Tesla, LGES, CATL 등 시장 동향
5. Future Outlook: 2025-2030 예상 발전
[출처 30~50개 제시]
```
👉 **"한 분야 전체의 지형도"를 단숨에 파악.**

#### (E) 분기: 무료 vs Pro
**무료:** 시간이 좀 더 걸림 (5~10분)
**Pro:** 더 빠름 (2~3분), 더 많은 출처
→ **일단 무료로 충분합니다.**
$$,
        E'- (X) 실수: Deep Research 결과를 그대로 논문에 복붙\n- (V) 팁: **Deep Research는 "개요 파악용"**, 정확한 내용은 출처 논문 직접 읽기\n- (X) 실수: 계속 기다림\n- (V) 팁: **백그라운드 처리**되니 다른 일 하세요\n- (X) 실수: 조사 끝\n- (V) 팁: Deep Research는 **"출발점"**입니다.',
        $$[{"id": "q1", "text": "Liner의 Deep Research 기능을 찾을 수 있는가?"}, {"id": "q2", "text": "연구 질문을 입력하고 시작했는가?"}, {"id": "q3", "text": "자동 생성된 리포트를 받았는가?"}, {"id": "q4", "text": "그 리포트의 출처를 최소 3개 클릭해봤는가?"}]$$::jsonb
    );

    -- Step 7
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 7, '논문 리딩 완벽 프로세스 (전체 통합) (20분)',
        'Step 1~6을 모두 통합해서, 실제로 논문 1개를 읽고 정리하는 완벽한 리딩 프로세스를 실행한다.',
        $$- 1개의 학술 논문을 처음부터 끝까지 읽음
- AI 도움 + 직접 읽기를 통해 이해도 95% 이상 도달
- 핵심 정보를 노트에 정리 완료$$,
        $$#### (A) 왜 이 단계가 필요한가
지금까지 배운 기능들을 **"실전에서 어떻게 조합할 것인가"**가 중요합니다.
이 단계는 앞으로 **매번 반복할 "논문 읽기 루틴"**을 만드는 것입니다.

#### (B) 해야 할 일
1. **논문 선택 (3분)**: 관심 논문 1개 선택
2. **다운로드 및 업로드 (2분)**: PDF를 Liner에 업로드
3. **AI 요약으로 가치 판단 (3분)**: "깊게 읽어야 하나?" 결정
4. **선택적 번역 (2분)**: 필요시 한글 요약
5. **직접 스캔 읽기 (5~10분)**: Abstract, Intro, Conclusion
6. **중요 부분 깊게 읽기 (5~10분)**: Method, Results (Liner에 질문하며)
7. **Citation 검증 (3분)**: 주요 주장 1~2개 확인
8. **노트 정리 (5분)**: 핵심 내용, 의의 메모

#### (C) 템플릿: 논문 읽기 체크리스트
```text
- [ ] 논문 선택 및 다운로드
- [ ] Liner AI에 PDF 업로드
- [ ] AI 자동 요약 확인
- [ ] "이 논문을 읽어야 하나?" 판단 완료
- [ ] (영어면) 한글 요약 요청
- [ ] Abstract + Introduction 읽기
- [ ] Method 섹션 이해 (모르면 Liner에 질문)
- [ ] Results 섹션 그래프/차트 해석
- [ ] Conclusion 읽기
- [ ] AI 요약과 내 이해 비교
- [ ] Citation 3개 이상 검증
- [ ] 핵심 내용을 내 노트에 정리
```

#### (D) 예시: 실제 논문 읽기 과정
**주제:** 기후변화와 농업 생산성
**Step 0-1:** 검색 후 PDF 업로드 (Nature Climate Change)
**Step 2:** AI 요약 "온도 1도 상승 시 생산성 7% 감소"
**Step 3:** "중요한 데이터네. 깊게 읽자."
**Step 4-5:** Method에서 "Panel regression" 모름 -> Liner 질문
**Step 6:** "7% 감소" 출처 확인 -> Table 3 확인
**Step 7:** 노트에 정리 (핵심, 의의, 한계, 다음 할 일)

#### (E) 분기: 시간이 부족하면?
**빠른 읽기 (5분):** AI 요약 + 판단
**표준 읽기 (15분):** 위 프로세스 핵심
**깊은 읽기 (30분+):** 표준 + 추가 자료
$$,
        E'- (X) 실수: "AI 요약을 받았으니까 논문 읽을 필요 없다"\n- (V) 팁: **AI 요약은 "게이트웨이"**, 깊은 이해는 직접 읽기\n- (X) 실수: 모든 논문을 Step 0-7까지 다 함\n- (V) 팁: **상황에 맞게 깊이 조절**하세요\n- (X) 실수: 혼자 조용히 읽음\n- (V) 팁: **Liner와 "대화하면서"** 읽으세요.',
        $$[{"id": "q1", "text": "실제 논문 1개를 선택했는가?"}, {"id": "q2", "text": "Liner에 업로드하고 요약을 받았는가?"}, {"id": "q3", "text": "직접 Abstract와 Conclusion을 읽었는가?"}, {"id": "q4", "text": "Liner에 2개 이상의 질문을 했는가?"}, {"id": "q5", "text": "노트에 정리했는가?"}]$$::jsonb
    );

    -- Step 8
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 8, 'Scholar Alerts 설정 - 관심 분야 자동 추적 (5분)',
        'Liner AI를 지속적인 학습 도구로 만든다. 구독 설정으로 최신 논문을 자동으로 받기.',
        $$- "Alerts" 또는 "Subscriptions" 기능 활용
- 관심 분야 2~3개를 등록
- "새 논문이 나오면 자동으로 알림 받겠네"라고 느낌$$,
        $$#### (A) 왜 이 단계가 필요한가
**"논문을 찾아서 읽는" 주도적 학습**에서, **"새 논문이 나오면 추천받는" 수동적 학습**으로 확장합니다.
매주 "새로운 논문이 몇 개나 나왔는가?"를 자동으로 알 수 있습니다.

#### (B) 해야 할 일
1. Liner AI 홈페이지에서 "Alerts" 찾기
2. "Create Alert" 클릭
3. 관심 분야 입력 ("AI in healthcare" 등)
4. 알림 빈도 설정 (매일/매주)
5. 저장

#### (D) 예시: 추천 추적 분야
**과학기술:**
```text
"Quantum computing applications"
"CRISPR gene editing advances"
"Battery technology research"
```

**의료/보건:**
```text
"AI diagnostics and medical imaging"
"Precision medicine and genomics"
```

**환경/에너지:**
```text
"Climate change mitigation"
"Renewable energy efficiency"
```

#### (D) 예시: 알림 설정 후
**설정:** "Climate change adaptation" - 매주 알림
**매주 월요일 아침 이메일:**
```
🔔 Liner Weekly Alert
최신 논문 3개:
1. "Machine Learning for Climate Prediction" (2026-01-05)
2. "Urban Heat Island Mitigation" (2026-01-04)
[1-click으로 읽기 가능]
```
👉 **놓치는 논문이 없어집니다.**
$$,
        E'- (X) 실수: 너무 많은 분야 등록\n- (V) 팁: **3개 정도**만 등록하세요\n- (X) 실수: 매일 알림 켜서 노이즈가 많음\n- (V) 팁: **매주 1회**로 충분합니다\n- (X) 실수: 알림 받고 안 읽음\n- (V) 팁: 제목만이라도 **매주 스캔**해보세요',
        $$[{"id": "q1", "text": "Liner의 Alerts 기능을 찾을 수 있는가?"}, {"id": "q2", "text": "관심 분야 2~3개를 등록했는가?"}, {"id": "q3", "text": "알림 빈도를 설정했는가?"}]$$::jsonb
    );

    -- Step 9
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 9, '최종 정리 - Liner AI를 연구 무기로 만들기 (5분)',
        'Step 1~8을 모두 완료한 후 이제 할 수 있는 것들과, "다음 단계"를 정리한다.',
        $$- "이제 나는 Liner AI를 제대로 쓸 수 있다"는 자신감 확보
- 앞으로 "이 도구를 어떻게 활용할지" 명확한 이해$$,
        $$#### (A) 왜 이 단계가 필요한가
Liner AI는 **논문 읽기 시간을 80% 단축**해줄 수 있는 도구입니다.
그 가치를 **정확히 인식**하고, 앞으로 매번 활용하는 루틴을 만들 시간입니다.

#### (B) 해야 할 일
아래 체크리스트를 읽고, 할 수 있는 것들을 확인해보세요.

#### (B) 이제 할 수 있는 것
- [x] 관심 논문을 5분 만에 요약 파악하기
- [x] 학술 논문을 검색해서 신뢰할 만한 출처만 보기
- [x] 영어 논문을 한글로 번역 + 요약 받기
- [x] PDF 파일을 업로드해서 자동 분석하기
- [x] 한 분야 전체의 흐름을 Deep Research로 파악하기
- [x] 개별 정보의 출처를 Line-by-Line Citation으로 검증하기
- [x] 논문의 "이 부분이 뭐야?"를 Liner와 대화하며 배우기
- [x] 최신 논문을 매주 자동으로 받기

#### (D) 예시: 실제 활용 사례
**대학원생:**
- Liner 없이: 주당 10시간, 판단 어려움
- Liner 사용: 주당 2시간, AI 요약으로 즉시 판단

**직장인 R&D:**
- Liner 없이: 월간 보고서 20시간, 수동 검색
- Liner 사용: 월간 보고서 5시간, Alerts 자동 추적

#### (E) 다음 3가지 행동 (선택)
1. **내 연구 분야 전문가 되기**: 매주 Deep Research 1개, 논문 3개
2. **효율적 문헌 조사 시스템 구축**: Alerts 자동 추적
3. **실전 프로젝트에 바로 적용**: 매주 3~5개 논문 스캔 후 적용 평가
$$,
        E'- (X) 실수: "이제 끝"이라고 생각\n- (V) 팁: **이건 시작**입니다.\n- (X) 실수: 무료 버전만 만족\n- (V) 팁: 1주일 후 **Pro** 가치 판단\n- (X) 실수: Liner만 씀\n- (V) 팁: **다른 도구(Google Scholar 등)도 병행**',
        $$[{"id": "q1", "text": "이제 할 수 있는 것들을 확인했는가?"}, {"id": "q2", "text": "다음 3가지 선택지 중 1개를 골랐는가?"}, {"id": "q3", "text": "시간을 진짜 아낄 수 있겠네라는 느낌이 들었는가?"}]$$::jsonb
    );

    -- 5. Prompt Packs
    INSERT INTO public.guide_sections (guide_id, section_type, section_order, title, content, data)
    VALUES
    (v_guide_id, 'prompt_pack', 1, 'Liner AI 마스터 프롬프트', NULL, $$[
        {
            "title": "논문 빠른 요약",
            "when_to_use": "논문이 길 때, 5분 안에 핵심 파악하고 싶을 때",
            "prompt": "이 논문의 핵심을 한국어로 5문장 이내로 요약해줄 수 있어?\n다음을 반드시 포함해:\n- 이 논문이 뭐하는 건지 (주제)\n- 왜 중요한지 (기여도)\n- 결론이 뭔지",
            "bad_pattern": "\"이 논문 요약해줘\"",
            "related_step": "3, 4"
        },
        {
            "title": "Method 섹션 설명",
            "when_to_use": "방법론이 복잡할 때, 알고리즘 이해 안 될 때",
            "prompt": "이 논문의 Method 섹션을 설명해줄 수 있어?\n특히:\n1. 전체적으로 어떤 방식으로 문제를 풀었는지\n2. 이전 방법과 뭐가 다른지\n3. 초보자도 이해할 수 있게 비유로 설명해줄 수 있어?",
            "bad_pattern": "\"이 공식이 뭐야?\"",
            "related_step": "5, 7"
        },
        {
            "title": "논문의 한계점 찾기",
            "when_to_use": "비판적 평가, 약점 파악, 향후 연구 고민 시",
            "prompt": "이 논문의 한계점이나 약점이 뭐라고 생각해?\n특히:\n1. 이 논문의 방법이 실패할 수 있는 경우\n2. 연구 설계상의 문제점\n3. 향후 연구에서 해결해야 할 것들",
            "bad_pattern": "\"이 논문 좋아?\"",
            "related_step": "6, 7"
        },
        {
            "title": "Related Work 정리",
            "when_to_use": "기존 연구와 차이점 파악, 연구 흐름 이해",
            "prompt": "이 논문의 Related Work 섹션을 정리해줄 수 있어?\n특히:\n1. 이전 연구들이 뭘 했는지\n2. 이 논문이 그들과 뭐가 다른지\n3. 연구 발전 순서대로 표로 정리해줄 수 있어?",
            "bad_pattern": "\"기존 연구 설명해줘\"",
            "related_step": "5, 6"
        },
        {
            "title": "실용적 응용 가능성",
            "when_to_use": "실제 적용 분야 고민, 시장 가치 평가",
            "prompt": "이 논문의 기술이나 방법론을 실제로 어디에 적용할 수 있을까?\n특히:\n1. 실용적인 응용 분야 3가지\n2. 각각의 장점과 실현 가능성\n3. 예상되는 문제점은?",
            "bad_pattern": "\"이걸 어디에 쓸 수 있어?\"",
            "related_step": "7, 9"
        },
        {
            "title": "논문 비교",
            "when_to_use": "여러 논문 비교, 장단점 파악",
            "prompt": "다음 2개 논문을 비교해줄 수 있어?\n논문 1: [제목]\n논문 2: [제목]\n\n비교 항목:\n1. 풀려는 문제가 뭐가 다른가?\n2. 기술적 접근 방식의 차이\n3. 성능 비교\n4. 표로 정리해줄 수 있어?",
            "bad_pattern": "\"이 두 논문 차이가 뭐야?\"",
            "related_step": "6, 7"
        }
    ]$$::jsonb);

END $migration$;
