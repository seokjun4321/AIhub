-- Guide 21: ChatGPT 시장 조사 & 경쟁사 분석 완벽 가이드
-- Date: 2026-01-11

BEGIN;

DO $migration$
DECLARE
    v_guide_id BIGINT := 21;
    v_category_id INTEGER;
    v_model_id INTEGER;
BEGIN
    -- 1. Get IDs
    SELECT id INTO v_category_id FROM public.categories WHERE name = '창업 & 비즈니스' LIMIT 1;
    IF v_category_id IS NULL THEN
        INSERT INTO public.categories (name, description)
        VALUES ('창업 & 비즈니스', '사업 아이디어 검증, 시장 조사, 비즈니스 모델링 등 창업가를 위한 가이드')
        RETURNING id INTO v_category_id;
    END IF;

    SELECT id INTO v_model_id FROM public.ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1;
    IF v_model_id IS NULL THEN
        SELECT id INTO v_model_id FROM public.ai_models LIMIT 1;
    END IF;

    -- 2. Cleanup
    DELETE FROM public.guide_sections WHERE guide_id = v_guide_id;
    DELETE FROM public.guide_prompts WHERE step_id IN (SELECT id FROM public.guide_steps WHERE guide_id = v_guide_id);
    DELETE FROM public.guide_steps WHERE guide_id = v_guide_id;
    DELETE FROM public.guide_categories WHERE guide_id = v_guide_id;

    -- 3. Insert Guide
    INSERT INTO public.guides (
        id, title, category_id, ai_model_id, difficulty_level, estimated_time, description, tags, image_url
    )
    OVERRIDING SYSTEM VALUE
    VALUES (
        v_guide_id,
        'ChatGPT 시장 조사 & 경쟁사 분석 완벽 가이드',
        v_category_id,
        v_model_id,
        'intermediate',
        '2~3시간',
        'ChatGPT를 활용해 기존 6개월 걸리던 시장조사를 단 3시간으로 단축하세요. 경쟁사 분석부터 시장 규모 추정, 고객 페르소나 작성까지 실전 프롬프트와 함께 제공합니다.',
        ARRAY['창업&비즈니스', '시장조사', '경쟁사분석', 'TAM/SAM/SOM', 'SWOT분석', '고객페르소나', '데이터분석', '프롬프트엔지니어링'],
        'https://images.unsplash.com/photo-1553484771-371af27278d4?q=80&w=2000&auto=format&fit=crop'
    )
    ON CONFLICT (id) DO UPDATE SET
        title = EXCLUDED.title,
        category_id = EXCLUDED.category_id,
        ai_model_id = EXCLUDED.ai_model_id,
        difficulty_level = EXCLUDED.difficulty_level,
        estimated_time = EXCLUDED.estimated_time,
        description = EXCLUDED.description,
        tags = EXCLUDED.tags,
        image_url = EXCLUDED.image_url;

    -- 4. Link Category
    INSERT INTO public.guide_categories (guide_id, category_id, is_primary)
    VALUES (v_guide_id, v_category_id, true)
    ON CONFLICT (guide_id, category_id) DO UPDATE SET is_primary = true;

    -- 5. Overview Cards
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, content)
    VALUES (
        v_guide_id, 1, 'summary', '한 줄 요약',
        'ChatGPT로 2000만원 들던 시장조사를 무료로 완성하는 법'
    );

    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 2, 'target_audience', '이런 분께 추천',
        '["창업 준비 중이지만 시장조사 비용이 부담되는 예비 창업자", "경쟁사가 누군지 정확히 모르는 신규 사업 담당자", "투자 피칭 자료에 시장 규모(TAM/SAM/SOM)를 넣어야 하는 스타트업 대표", "고객이 진짜 원하는 게 뭔지 데이터로 확인하고 싶은 PM/마케터"]'::jsonb
    );

    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 3, 'preparation', '준비물',
        '["ChatGPT 무료 계정 (GPT-4o 추천, 무료 버전도 가능)", "분석하고 싶은 사업 아이디어 또는 제품명", "구글 시트 또는 엑셀 (결과 정리용)", "(선택) Claude 또는 Gemini 계정 (교차 검증용)", "(선택) 소셜 리스닝 무료 체험판 (Brand24, Awario 등)"]'::jsonb
    );

    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 4, 'core_principles', '핵심 사용 원칙',
        '["검증 우선: AI 결과는 반드시 최소 2개 이상 소스로 교차 검증하세요", "구체적 질문: \"경쟁사 알려줘\" 대신 \"한국 시장에서 20대 여성 대상 비건 화장품 경쟁사 10개, 매출 순으로\"처럼 구체화", "대화 이어가기: 한 번의 프롬프트로 끝내지 말고, \"더 자세히\", \"예시 들어줘\" 등으로 심화", "데이터 근거 요구: ChatGPT에게 \"이 정보의 출처는?\" \"몇 년도 기준이야?\" 반드시 물어보기", "포맷 지정: \"표로 정리해줘\", \"엑셀에 복사할 수 있게 CSV 형식으로\" 등 출력 형태 명시"]'::jsonb
    );

    -- 6. Steps
    -- I'll create a template that can be expanded - showing Step 1 fully structured
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 1,
        '시장조사 목표 설정 및 프레임워크 선택',
        '이번 시장조사에서 무엇을 알아내야 하는지 명확히 정의합니다.',
        $$- 조사 목적을 한 문장으로 작성
- TAM/SAM/SOM, 경쟁사 분석, 고객 페르소나 중 최소 2개 이상 목표 체크$$,
        $$#### (A) 왜 이 단계가 필요한가

많은 창업자가 "일단 ChatGPT에 물어보면 되겠지"라고 생각하다가 막연한 질문만 던지고 실망합니다. 시장조사는 **목적이 명확할수록 결과물의 품질이 기하급수적으로 올라갑니다**.

2026년 기준 AI 시장조사는 기존 6개월 프로세스를 2~3시간으로 단축할 수 있지만, 이는 "무엇을 물어야 하는지"를 정확히 아는 사람에게만 해당됩니다. 컨설팅 회사가 2000만원을 받는 이유는 데이터 수집보다 **"무엇을 조사해야 하는가"를 설계하는 능력** 때문입니다.

#### (B) 해야 할 일

1. **사업 아이디어 정리**
   - 사업 아이디어를 한 문장으로 적기

2. **핵심 질문 도출**
   - 이번 조사에서 반드시 답해야 할 질문 3개 적기 (예: 경쟁사는? 시장 규모는? 고객은 누구?)

3. **프레임워크 선택**
   - 아래 프레임워크 중 필요한 것 2~3개 선택:
     - **TAM/SAM/SOM**: 시장 규모를 숫자로 알고 싶다면
     - **SWOT 분석**: 경쟁사 대비 우리 포지션을 알고 싶다면
     - **고객 페르소나**: 타겟 고객의 구체적 특성을 알고 싶다면
     - **갭 분석**: 경쟁사가 놓친 기회를 찾고 싶다면

4. **활용처 정의**
   - 조사 결과를 어디에 쓸 건지 정하기 (투자 피칭? 마케팅 전략? 제품 개발?)

#### (E) Branch: 분기

**⏱ 시간 부족 (1시간 이내)**
→ 경쟁사 리스트 + 간단한 SWOT만 실행 (Step 2, 3, 6만)
→ 목표: "경쟁 구도 스냅샷" 확보

**⏱ 보통 (2~3시간)**
→ 전체 프로세스 따라가기 (Step 1~9)
→ 목표: 투자 피칭에 쓸 수 있는 리포트 완성

**⏱ 시간 여유 (4시간 이상)**
→ 전체 프로세스 + 소셜 리스닝 툴 연동 + 고객 인터뷰까지
→ 목표: 전문가급 시장 분석 리포트$$,
        $$- (X) "ChatGPT로 시장조사해줘" 같은 막연한 질문
- (V) "서울 강남 비건 카페 시장 경쟁 구도 파악" 같은 구체적 목적
- (V) 조사 목표를 "투자자용/내부용" 구분하면 포맷 잡기가 쉽습니다$$,
        $$[{"id":"s1_c1","text":"조사 목적이 구체적인가?"},{"id":"s1_c2","text":"프레임워크가 목적과 일치하는가?"},{"id":"s1_c3","text":"결과물을 누구에게 보여줄지 정했는가?"}]$$::jsonb
    );

    -- Step 2
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 2,
        'ChatGPT로 경쟁사 리스트 발굴',
        '직접/간접 경쟁사 10~15개 리스트를 확보하고 기본 정보를 표로정리합니다.',
        $$- 경쟁사 10개 이상 리스트 확보
- 각 경쟁사별 웹사이트 URL, 주요 제품/서비스, 예상 매출 규모 정리$$,
        $$#### (A) 해야 할 일

1. **경쟁사 발굴 프롬프트 실행**
   - 프롬프트 팩의 "경쟁사 발굴 올인원" 사용
   - 업종, 타겟, 지역, 매출 규모를 내 사업에 맞게 수정

2. **결과 정리 및 검증**
   - 결과를 구글 시트에 복사
   - 각 경쟁사 웹사이트를 직접 방문하여 정보 교차 검증
   - 누락된 경쟁사가 있다면 "OO 빠진 것 같은데, 추가로 3개 더 찾아줘"라고 질문

#### (D) 예시: 경쟁사 리스트 정리

**입력:**
[업종]: 비건 화장품
[타겟 고객]: 20~30대 여성
[지역]: 한국 시장
[사업 규모]: 연매출 10억 이상

**출력 (예상):**
| 회사명 | URL | 주요 제품 | 예상 연매출 | 주요 고객층 | 차별화 포인트 |
|---|---|---|---|---|---|
| 멜릭서 | melixir.com | 비건 스킨케어 | 500억 (2024 추정) | 20~30대 여성 | 백화점 입점 + 프리미엄 |
| 아로마티카 | aromatica.co.kr | 천연 화장품 | 300억 (2024 추정) | 20~40대 여성 | 제로웨이스트 패키징 |$$,
        $$- (X) ChatGPT 리스트를 검증 없이 그대로 사용 (환각 주의)
- (V) 상위 5개 경쟁사는 반드시 직접 사이트 방문/검색으로 실존 여부 확인
- (V) "스타트업 또는 중소기업 위주로", "D2C 브랜드 중심으로" 조건 추가
- (V) 경쟁사 리스트에 "왜 경쟁자인가?" 메모해두면 SWOT 분석 때 유용$$,
        $$[{"id":"s2_c1","text":"직접 경쟁사와 간접 경쟁사가 적절히 섞여 있는가?"},{"id":"s2_c2","text":"각 경쟁사의 웹사이트 URL이 실제로 작동하는가?"},{"id":"s2_c3","text":"최소 3개 이상 경쟁사는 직접 검색으로 교차 검증했는가?"}]$$::jsonb
    );

    -- Step 3
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 3,
        '경쟁사별 SWOT 분석 실행',
        '상위 3~5개 경쟁사의 강점, 약점, 기회, 위협을 분석하여 우리가 승산 있는 영역을 찾습니다.',
        $$- 최소 3개 경쟁사의 SWOT 분석표 완성
- 경쟁사가 "못하는 것" 또는 "고객이 불만인 부분" 최소 5개 발굴$$,
        $$#### (A) 왜 이 단계가 필요한가

SWOT 분석은 "우리가 싸워서 이길 수 있는 전장을 찾는 도구"입니다. 2026년 기준 AI를 활용한 SWOT 분석은 실제 고객 리뷰, 뉴스, 소셜 데이터를 패턴화하여 분석해줍니다.

#### (B) 해야 할 일

1. **상위 경쟁사 선정**
   - 앞 단계에서 찾은 리스트 중 3~5개 선정

2. **SWOT 분석 실행**
   - 프롬프트 팩의 "SWOT 분석 자동 생성" 사용
   - 경쟁사 정보를 넣고 실행

3. **결과 분석**
   - ChatGPT가 제시한 근거를 직접 검색으로 확인 (Fact Check)
   - Weaknesses 중 "우리가 해결할 수 있는 것" 형광펜 표시
   - 추가 질문: "이 중 가장 공략하기 쉬운 약점은?"

#### (F) 예시: 실제 SWOT 결과

**경쟁사 A: 멜릭서**
| 항목 | 내용 | 근거 |
|---|---|---|
| Strengths | - 백화점 입점으로 고급 이미지<br>- 연예인 협찬 많음 | - 2025 현대백화점 뷰티 매출 5위<br>- 인스타 해시태그 12만 건 |
| Weaknesses | - 높은 가격대 (20대 진입장벽)<br>- 온라인몰 UX 불편 | - 평균가 4만원 이상<br>- "결제 오류" 리뷰 다수 |
| Opportunities | - 저가 라인 출시 시 20대 흡수 가능 | - 20대 소득 감소 트렌드 |
| Threats | - 올리브영 PB 저가 공세 | - 올리브영 PB 30% 저렴 |$$,
        $$- (X) "좋은 것/나쁜 것" 나열로만 끝냄
- (V) 반드시 "So What?" 질문하기 (약점이 배송이 느리다? → 우리는 익일 배송하자!)
- (V) Opportunities는 시장 트렌드가 아니라 "경쟁사의 공백"을 적으세요
- (V) 경쟁사 약점은 네이버/쿠팡 리뷰를 "직접" 읽으면 더 확실합니다$$,
        $$[{"id":"s3_c1","text":"각 SWOT 항목이 구체적 숫자/사례를 포함하는가?"},{"id":"s3_c2","text":"Weaknesses에서 최소 2개는 우리가 해결 가능한 것인가?"},{"id":"s3_c3","text":"최소 3개 항목은 직접 검색으로 사실 확인했는가?"}]$$::jsonb
    );

    -- Step 4
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 4,
        '고객 페르소나 생성 및 가상 인터뷰',
        '타겟 고객의 구체적인 프로필을 만들고, ChatGPT 롤플레이로 고객이 원하는 것을 발굴합니다.',
        $$- 최소 2~3개의 고객 페르소나 완성 (이름, 나이, 직업, 고민, 구매 결정 요인 포함)
- 각 페르소나당 최소 5개의 가상 인터뷰 Q&A 확보$$,
        $$#### (A) 왜 이 단계가 필요한가

"20대 여성"이라는 막연한 타겟으로는 제품을 만들 수 없습니다. **"26세, 마케터, 비건 뷰티 관심 있지만 가격 부담 느낌"** 처럼 구체화해야 전략이 나옵니다.

AI의 "롤플레이" 기능을 쓰면 실제 고객 인터뷰(비용 건당 5~10만원)를 **무료로 무제한** 진행하며 깊은 속마음을 캐낼 수 있습니다.

#### (B) 해야 할 일

1. **페르소나 생성**
   - 프롬프트 팩의 "고객 페르소나 & 가상 인터뷰" 사용
   - 우리 제품에 맞게 정보 입력

2. **페르소나 선택**
   - 생성된 3개 중 우리 제품에 가장 적합한 1명 선택

3. **가상 인터뷰 진행**
   - 선택한 페르소나와 ChatGPT 롤플레이
   - 답변에서 "진짜 원하는 것(Needs)" 키워드 추출

#### (G) 예시: 페르소나 결과

**이름: 김지연 (26세, 마케터)**
- 월 소득: 250만원
- 핵심 고민: "비건 화장품 쓰고 싶은데 다들 너무 비싸요. 피부 트러블 때문에 성분은 봐야겠고..."
- 결정 요인: 1) 가성비(3만원 이하) 2) 리뷰 평점 3) 배송 속도
- 쇼핑: 쿠팡, 네이버$$,
        $$- (X) 페르소나를 평균값(25~35세)으로 만듦
- (V) 한 명의 구체적 인물(28세, 홍대 거주)로 설정해야 감정이입이 됩니다
- (V) "왜?", "어떤 상황에서?" 등 심층 질문을 던져 스토리를 끌어내세요
- (V) 페르소나를 만들고 끝내지 말고, 이후 기획 회의 때 계속 자문하세요$$,
        $$[{"id":"s4_c1","text":"페르소나가 실존 인물처럼 구체적인가?"},{"id":"s4_c2","text":"핵심 고민이 명확하게 정의되었는가?"},{"id":"s4_c3","text":"가상 인터뷰에서 3개 이상의 행동 가능한 인사이트를 얻었는가?"}]$$::jsonb
    );

    -- Step 5
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 5,
        '시장 규모 계산 (TAM/SAM/SOM)',
        '투자자를 위해 우리가 공략할 수 있는 시장이 얼마나 크고, 현실적으로 얼마를 벌 수 있는지 숫자로 계산합니다.',
        $$- TAM(전체 시장), SAM(공략 가능 시장), SOM(현실적 목표) 각각 계산 완료
- 계산 과정, 근거, 가정이 포함된 표 작성$$,
        $$#### (A) 왜 이 단계가 필요한가

투자자는 "시장이 얼마나 큽니까?"를 반드시 묻습니다. "크다"는 말은 통하지 않습니다.

**"전체 5000억 시장 중 20대 여성 온라인 시장 1200억을 타겟하며, 3년 내 3%인 36억 달성이 목표입니다."** 처럼 말해야 신뢰를 얻습니다.

ChatGPT를 쓰면 컨설팅 회사 프레임워크인 TAM/SAM/SOM을 30분 만에 초안 잡을 수 있습니다.

#### (B) 해야 할 일

1. **계산 프롬프트 실행**
   - 프롬프트 팩의 "TAM/SAM/SOM 시장 규모" 사용
   - 내 사업 정보를 넣고 실행

2. **숫자 검증**
   - ChatGPT가 내놓은 **TAM** 수치를 통계청/산업협회 리포트와 대조 (필수)
   - **SAM** 계산의 가정(예: 온라인 비중 60%)이 타당한지 검색

3. **SOM 조정**
   - 경쟁사 수, 마케팅 예산 고려해 1~5% 수준으로 보수적으로 잡기

#### (F) 예시: TAM/SAM/SOM 결과

| 구분 | 금액 | 근거 |
|---|---|---|
| **TAM** | 5,000억 | 한국 비건 화장품 시장 전체 (전체 화장품 20조 x 비건 비중 2.5%) |
| **SAM** | 1,200억 | TAM 5000억 x 온라인 비중 60% x 타겟연령 40% |
| **SOM** | 36억 | SAM 1200억 x 점유율 3% (3년 목표) |$$,
        $$- (X) TAM을 너무 크게 잡음 (전 세계 시장 100조 등)
- (V) 실제 판매 가능 지역(한국)으로 한정하세요
- (V) SOM을 "1년차/3년차/5년차"로 나누면 더 전문적으로 보입니다
- (V) ChatGPT 숫자가 이상하면 "출처가 어디야?"라고 묻고 직접 구글링하세요$$,
        $$[{"id":"s5_c1","text":"TAM/SAM/SOM 각각 계산식이 명확한가?"},{"id":"s5_c2","text":"최소 1개 이상의 정부/협회 통계로 검증했는가?"},{"id":"s5_c3","text":"SOM이 보수적인가? (5% 이하)"}]$$::jsonb
    );

    -- Step 6
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 6,
        '경쟁사 대비 갭 분석 (우리의 기회)',
        '경쟁사들이 못하거나 안 하는 것을 찾아서, 우리의 차별화 포인트로 전환합니다.',
        $$- 경쟁사 공통 약점 최소 3개 발굴
- 고객이 원하지만 경쟁사가 제공 안 하는 것(Unmet Needs) 2개 발견
- 차별화 전략 1문장 정리$$,
        $$#### (A) 왜 이 단계가 필요한가

시장조사의 꽃은 "그래서 우린 뭘로 싸울 건데?"를 정하는 갭 분석입니다. 고객이 "3만원 이하를 원해"라고 했는데, 경쟁사가 전부 4만원 이상이라면? 그것이 바로 우리의 기회입니다.

#### (B) 해야 할 일

1. 갭 분석 실행 (프롬프트 팩 참고)
2. "우리가 진짜 이걸 3개월 안에 할 수 있나?" 체크
3. 주변 5명에게 차별화 전략 말해주고 반응 보기$$,
        $$- (X) 우리가 "할 수 없는 것"(대기업급 R&D)을 기회로 삼음
- (V) "스타트업이 3개월 내 실행 가능한 것"으로 필터링하세요
- (V) 숫자로 구체화하세요 ("25% 저렴", "배송 2일 단축")
- (V) "왜 경쟁사가 이건 안 하지?"라고 꼭 의심해보세요$$,
        $$[{"id":"s6_c1","text":"갭이 고객 니즈와 경쟁사 약점의 교집합인가?"},{"id":"s6_c2","text":"차별화 전략이 한 문장으로 명확한가?"},{"id":"s6_c3","text":"3개월 내 실행 가능한가?"}]$$::jsonb
    );

    -- Step 7
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 7,
        '데이터 시각화 및 인사이트 정리',
        '수집한 데이터를 표, 차트, 요약본으로 정리해서 한눈에 이해되는 리포트를 만듭니다.',
        $$- 핵심 인사이트 3~5개를 포함한 1페이지 요약본 작성
- 경쟁사 비교표, 시장 규모 차트 완성$$,
        $$#### (A) 왜 이 단계가 필요한가

아무리 좋은 분석도 읽기 어려우면 쓸모없습니다. 투자자나 대표는 10초 안에 핵심을 파악하고 싶어 합니다.

#### (B) 해야 할 일

1. 데이터 통합 (구글 시트 등에 흩어진 데이터 모으기)
2. 1페이지 요약 작성 (프롬프트 팩 참고)
3. 시각화 (경쟁사 비교표, 시장 규모 그래프 만들기)$$,
        $$- (X) 모든 데이터를 다 넣어서 20페이지 만듦
- (V) 핵심만 1페이지, 나머지는 부록으로
- (V) 차트에 제목과 출처 필수
- (V) 인사이트 없이 숫자만 나열하지 말고 해석 추가$$,
        $$[{"id":"s7_c1","text":"1페이지 요약본을 5분 안에 읽을 수 있는가?"},{"id":"s7_c2","text":"모든 차트에 제목과 출처가 있는가?"},{"id":"s7_c3","text":"비전문가가 봐도 이해되는가?"}]$$::jsonb
    );

    -- Step 8
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 8,
        '소셜 리스닝으로 실시간 트렌드 보완 (선택)',
        'ChatGPT의 과거 데이터 한계를 넘어, 실제 고객이 SNS/커뮤니티에서 지금 이야기하는 내용을 확인합니다.',
        $$- 무료 소셜 리스닝 툴 1개 가입 및 키워드 모니터링
- 최근 1주일간 고객 언급 50개 이상 수집 분석$$,
        $$#### (A) 왜 이 단계가 필요한가

ChatGPT는 학습된 시점까지의 데이터만 압니다. 소셜 리스닝은 "지금 고객들의 생생한 목소리"를 듣는 청진기입니다.

#### (B) 해야 할 일

1. 도구 선택 (Brand24, Awario, Google Alerts 등)
2. 모니터링 실행 (키워드: 우리 브랜드, 경쟁사명, 제품 카테고리)
3. 분석 (긍정/부정 비율 확인, 반복 키워드 갭 분석에 추가 반영)$$,
        $$- (V) 경쟁사 브랜드명을 키워드로 넣으면 고객 불만을 실시간으로 볼 수 있습니다
- (V) 14일 무료 체험 기간에 과거 데이터까지 싹 긁어서 분석하고 해지하는 전략도 유효합니다$$,
        $$[{"id":"s8_c1","text":"최소 50개 이상의 실제 고객 멘션을 봤는가?"},{"id":"s8_c2","text":"긍정/부정 비율을 숫자로 파악했는가?"},{"id":"s8_c3","text":"ChatGPT 분석과 다른 최신 이슈를 찾았는가?"}]$$::jsonb
    );

    -- Step 9
    INSERT INTO public.guide_steps (guide_id, step_order, title, goal, done_when, content, tips, checklist)
    VALUES (
        v_guide_id, 9,
        '최종 리포트 완성 및 Next Steps',
        '조사 결과를 통합하고, 이 리포트를 받은 사람이 다음에 무엇을 해야 하는지(Action Plan)를 명확히 합니다.',
        $$- 최종 리포트(PDF/PPT) 완성
- Next Steps 액션 3~5개 (담당자, 기한 포함) 명시
- 최소 1명에게 피드백 받기$$,
        $$#### (A) 왜 이 단계가 필요한가

조사 자체가 목적이 아닙니다. "실행"이 목적입니다. 리포트 마지막 장에 "그래서 누가 언제 뭘 한다"가 없으면 서랍 속에 묻힙니다.

#### (B) 해야 할 일

1. 통합 리포트 작성 (Step 1~8 통합)
2. Next Steps 수립 (프롬프트 팩 참고)
3. 공유 및 피드백 (팀원/멘토에게 공유 후 피드백 반영)$$,
        $$- (V) Next Steps는 "동사"로 시작 ("○○ 실행", "△△ 확인")
- (V) 각 액션은 1주~1개월 안에 완료 가능한 것
- (V) 우선순위 "높음"은 3개 이하로 제한
- (V) 예상 비용은 구체적 숫자 (0원도 가능)$$,
        $$[{"id":"s9_c1","text":"리포트가 완성되었는가?"},{"id":"s9_c2","text":"Next Steps가 구체적인가?"},{"id":"s9_c3","text":"최소 1명에게 피드백을 받았는가?"}]$$::jsonb
    );

    -- 7. Prompt Pack
    INSERT INTO public.guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (
        v_guide_id, 5, 'prompt_pack', '프롬프트 팩',
        $$[
            {
                "id": "p1",
                "title": "경쟁사 발굴 올인원",
                "description": "- 직접/간접 경쟁사를 한 번에 찾고 기본 정보를 표로 정리\n- 업종, 타겟, 지역, 규모 조건에 맞는 경쟁사 리스트 확보\n- 각 경쟁사별 URL, 주요 서비스, 예상 매출, 차별화 포인트 포함",
                "prompt": "당신은 시장 분석 전문가입니다.\n아래 조건에 맞는 경쟁사를 찾아 표로 정리해주세요:\n\n업종: [예: 반려동물 헬스케어 앱]\n타겟 고객: [예: 30~40대 반려견 보호자]\n지역: [예: 한국]\n규모: [예: 스타트업 + 중견기업]\n\n요청:\n1. 직접 경쟁사 7개 + 간접 경쟁사 3개\n2. 각 경쟁사별: 회사명, URL, 주요 서비스, 예상 매출, 차별화 포인트, 정보 출처 연도\n3. 스타트업/중견/대기업 구분 표시\n4. 정보 불확실하면 \"추정\" 표기\n\n출력: 표 형식",
                "failurePatterns": "- ❌ 실패: \"경쟁사 알려줘\" (너무 모호)\n- ✅ 수정: 업종, 타겟, 지역, 규모 모두 명시",
                "relatedStep": [2]
            },
            {
                "id": "p2",
                "title": "SWOT 분석 자동 생성",
                "description": "- 경쟁사의 강점, 약점, 기회, 위협 분석\n- 고객 리뷰, 뉴스 기사, SNS 데이터 기반\n- 우리가 차별화할 수 있는 약점 발굴",
                "prompt": "당신은 경쟁 전략 컨설턴트입니다.\n아래 경쟁사에 대해 SWOT 분석을 실행해주세요:\n\n경쟁사: [예: 배달의민족]\n업종: [예: 음식 배달 플랫폼]\n분석 기준: 2024~2025년 뉴스, 고객 리뷰, SNS 언급\n\n각 항목별로:\n- Strengths: 3~5개 (숫자/데이터 포함)\n- Weaknesses: 3~5개 (고객 불만 우선)\n- Opportunities: 2~3개 (경쟁사가 놓친 것)\n- Threats: 2~3개 (외부 환경 변화)\n\n출력: 표 형식, 각 항목마다 근거/출처 명시\n추가: Weaknesses 중 \"우리가 차별화할 수 있는 지점\" 표시",
                "failurePatterns": "- ❌ 실패: 경쟁사명만 입력\n- ✅ 수정: 업종, 분석 기준 기간 명시",
                "relatedStep": [3]
            },
            {
                "id": "p3",
                "title": "고객 페르소나 & 가상 인터뷰",
                "description": "- 타겟 고객을 구체화하고 가상 인터뷰 진행\n- 이름, 나이, 직업, 고민, 구매 패턴 포함\n- 고객 관점에서 롤플레이 답변 받기",
                "prompt": "당신은 고객 리서치 전문가입니다.\n[제품/서비스]를 위한 고객 페르소나 3개를 만들어주세요.\n\n제품: [예: 직장인 대상 명상 앱]\n타겟: [예: 25~40세, 스트레스 많은 직장인]\n\n각 페르소나 포함 정보:\n- 이름, 나이, 직업, 월 소득\n- 라이프스타일 (하루 일과, 취미)\n- 핵심 고민 (이 제품이 해결할 문제)\n- 구매 결정 요인 Top 3\n- 정보 탐색 방법 (어디서 정보 찾는지)\n- 한 줄 요약\n\n출력: 표 형식\n\n[추가 - 가상 인터뷰]\n이제 \"[페르소나 이름]\" 역할을 해주세요.\n다음 질문에 그 사람의 관점으로 답변:\n1. 이 제품 카테고리에서 가장 중요한 게 뭔가요?\n2. 기존 제품의 불만은?\n3. 얼마까지 지불 의향?\n4. 어떤 마케팅 메시지가 끌리나요?\n\n답변은 해당 페르소나의 말투로, 구체적 상황 예시 포함",
                "failurePatterns": "- ❌ 실패: \"페르소나 만들어줘\"\n- ✅ 수정: 제품, 타겟 연령, 고민사항 구체화",
                "relatedStep": [4]
            },
            {
                "id": "p4",
                "title": "TAM/SAM/SOM 시장 규모",
                "description": "- 투자자 설득을 위한 시장 규모 계산\n- TAM(전체), SAM(공략 가능), SOM(현실적 목표)\n- 계산 근거, 출처, 가정 포함",
                "prompt": "당신은 시장 규모 분석 전문가입니다.\n아래 사업의 TAM, SAM, SOM을 계산해주세요:\n\n사업: [예: 대학생 대상 AI 과외 앱]\n타겟: [예: 한국 대학생 1~2학년]\n가격: [예: 월 2만원 구독]\n지역: [예: 한국 전국]\n\n계산 요청:\n1. TAM: 전체 시장 (한국 대학생 전체 × 과외 시장)\n2. SAM: 공략 가능 시장 (1~2학년 + 온라인 선호)\n3. SOM: 3년 목표 (SAM의 1~5%, 보수적 추정)\n\n각 항목별:\n- 금액 (억원)\n- 계산식 명시\n- 정보 출처 (정부 통계, 산업 리포트 등)\n- 확신도 (높음/중간/낮음)\n\n출력: 표 형식\n추가: 계산에 사용한 \"가정\" 모두 명시",
                "failurePatterns": "- ❌ 실패: \"시장 규모 알려줘\"\n- ✅ 수정: 사업, 타겟, 가격, 지역 모두 명시",
                "relatedStep": [5]
            },
            {
                "id": "p5",
                "title": "경쟁사 갭 분석",
                "description": "- 경쟁사 약점과 고객 니즈 연결\n- 우리만의 차별화 전략 수립\n- 3개월 내 실행 가능한 기회 발굴",
                "prompt": "당신은 전략 컨설턴트입니다.\n아래 정보를 종합해서 \"갭 분석\"을 실행해주세요:\n\n입력 1: 경쟁사 SWOT (3~5개 회사)\n[Step 3에서 만든 표 복사]\n\n입력 2: 고객 페르소나 인터뷰 결과\n[Step 4에서 추출한 \"고객이 원하는 것\" 리스트]\n\n분석 요청:\n1. 경쟁사 공통 약점 3개 이상 (반복되는 패턴)\n2. 미충족 고객 니즈 (고객은 원하는데 경쟁사가 안 주는 것)\n3. 우리의 기회 (위 1, 2의 교집합)\n4. 차별화 전략 1문장: \"우리는 [경쟁사]와 달리, [고객]에게 [이것]을 제공한다\"\n\n출력: 표 + 최종 전략 문장\n각 항목에 우선순위(높음/중간/낮음) 표시",
                "failurePatterns": "- ❌ 실패: \"차별화 전략 알려줘\"\n- ✅ 수정: SWOT와 고객 인터뷰 결과 모두 입력",
                "relatedStep": [6]
            },
            {
                "id": "p6",
                "title": "1페이지 요약 리포트",
                "description": "- A4 1페이지 요약본 작성\n- 의사결정자가 5분 안에 읽을 수 있도록\n- 핵심 발견, 시장 규모, 전략, Next Steps 포함",
                "prompt": "당신은 전략 리포트 작성 전문가입니다.\n아래 시장조사 결과를 \"A4 1페이지 요약본\"으로 만들어주세요:\n\n입력 정보:\n- 경쟁사 리스트: [Step 2 결과]\n- SWOT: [Step 3 결과]\n- 페르소나: [Step 4 결과]\n- TAM/SAM/SOM: [Step 5 결과]\n- 차별화 전략: [Step 6 결과]\n\n출력 구조:\n1. 제목: [사업명] 시장조사 요약 (2026.01 기준)\n2. 핵심 발견 3~5개 (각각 \"숫자 + 인사이트\")\n3. 시장 규모 (TAM/SAM/SOM 숫자 + 한 줄 해석)\n4. 경쟁 구도 (주요 경쟁사 3개 + 각각 약점 1줄)\n5. 타겟 고객 (대표 페르소나 1개 요약)\n6. 우리의 전략 (차별화 1문장 + 3개월 내 실행 과제 3개)\n7. Next Steps (다음 액션 3개, 담당자+기한 포함)\n\n포맷:\n- 간결한 문장 (불릿당 20자 이내)\n- 전문 용어 최소화\n- 투자자용 톤",
                "failurePatterns": "- ❌ 실패: \"요약해줘\"\n- ✅ 수정: 전체 조사 결과를 모두 입력",
                "relatedStep": [7, 9]
            }
        ]$$::jsonb
    );

END $migration$;

COMMIT;
