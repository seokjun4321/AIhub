-- Migration: Split Guide 18 Step 3 Copy Blocks by Field
-- Date: 2026-01-10

BEGIN;

DO $migration$
BEGIN
    -- Update Guide 18, Step 3 Content
    UPDATE public.guide_steps
    SET content = $$#### (A) 왜 이 단계가 필요한가
**이론만으로는 감을 못 잡습니다.** 직접 검색해봐야 "아, 이게 이렇게 작동하는구나"를 느껴요.
Step 3은 "**검색하면 정말 논문이 나오나?**"라는 의심을 확실히 없애주는 단계입니다.

#### (B) 해야 할 일
1. Liner AI 홈페이지 메인에서 검색창 찾기
2. Scholar Mode가 켜져 있는지 확인 (토글 확인)
3. 간단한 학술 질문 입력:
   - "기후 변화 대응 전략"
   - "인공지능과 의료"
   - "재생에너지 기술 동향"
   - 또는 관심 분야 (예: "블록체인 보안")
4. 검색 결과 페이지 관찰
5. 결과 중 1~2개 출처 클릭해서 내용 확인

#### (C) 과학 분야 추천 쿼리
"Quantum computing applications"
"CRISPR gene editing ethics"
"Dark matter detection methods"

#### (C) 의학 분야 추천 쿼리
"mRNA vaccine development"
"Cancer immunotherapy research"
"Mental health AI interventions"

#### (C) 사회과학 분야 추천 쿼리
"Remote work productivity studies"
"Digital transformation in education"
"Social media impact on democracy"

#### (C) 공학 분야 추천 쿼리
"Battery technology advances"
"5G network architecture"
"Autonomous vehicle safety"

#### (C) 경제/경영 분야 추천 쿼리
"Cryptocurrency market analysis"
"ESG investment strategies"
"Supply chain resilience"

#### (D) 예시: 검색 후 화면
**입력:**
```
"Renewable energy storage solutions"
```

**Liner가 반환 (Scholar Mode):**
```
1. Paper Title: "Grid-Scale Battery Storage: Technologies and Economics"
   Journal: Nature Energy
   Year: 2024
   [출처 링크]

2. Paper Title: "Hydrogen as Energy Storage: Current Status"
   Journal: Energy Reviews
   Year: 2023
   [출처 링크]

3. 요약: "재생에너지 저장 기술은 배터리(리튬이온, 고체전해질)와 
         수소 저장 방식으로 발전하고 있으며, 
         그리드 규모 적용에서 경제성이 개선되고 있습니다."
```
👉 **이런 식으로 논문들이 출처와 함께 정렬되어 나옵니다.**

#### (E) 분기: 결과가 없으면?
**이건 정상입니다.**
- 너무 좁은 주제면 논문이 없을 수 있음
- 예: "한국 수원시 태양광 발전" (너무 구체적)
- 해결: 주제를 조금 더 일반화해서 다시 검색 ("태양광 발전 효율")
$$
    WHERE guide_id = 18 AND step_order = 3;

END $migration$;
