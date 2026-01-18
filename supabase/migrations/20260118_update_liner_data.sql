-- Update Liner Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '웹페이지와 PDF의 중요 내용을 형광펜으로 칠하고, AI가 신뢰할 수 있는 출처를 기반으로 답변해 주는 ''초개인화 AI 검색 엔진''.',
    website_url = 'https://getliner.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Chrome Extension", "iOS", "Android"],
        "target_audience": "대학생(과제 리서치), 연구원(논문 분석), 정보 수집이 많은 마케터"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '웹/PDF 하이라이팅 무제한, 기본 AI 검색(General Model) 사용 가능. (GPT-4o 등 고급 모델은 제한적)',
    pricing_plans = '[
        {
            "plan": "Basic (Free)",
            "price": "무료",
            "target": "일반 리서치",
            "features": "하이라이팅, 기본 AI 검색, 광고 포함"
        },
        {
            "plan": "Pro",
            "price": "$11.67/월",
            "target": "논문/심층 연구",
            "features": "GPT-4o/Claude 3.5 모델 선택, PDF 무제한 분석, 출처 필터링"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '신뢰할 수 있는 출처: AI가 아무 말이나 지어내는 게 아니라, 학술 논문이나 공신력 있는 웹페이지 등 출처가 명확한 정보만 골라서 답변해 줍니다.',
        '웹 형광펜: 인터넷 기사를 읽다가 중요한 부분에 밑줄(하이라이트)을 그으면, 나중에 내 서재에서 모아볼 수 있습니다. (리서치 효율 극대화)',
        'Deep Research (최신): 2025년 도입된 ''심층 리서치'' 기능은 복잡한 질문에 대해 여러 단계의 추론을 거쳐 깊이 있는 보고서를 써줍니다.',
        '확장 프로그램: 크롬에 설치해두면 구글 검색 결과 우측에 Liner AI의 요약 답변을 바로 띄워주어 검색 시간을 줄여줍니다.'
    ],
    cons = ARRAY[
        '무료 모델 제한: 무료 버전에서는 최신 고성능 모델(GPT-4o 등) 사용 횟수가 제한되어 복잡한 추론에는 한계가 있습니다.',
        '알림 빈도: 브라우저 확장 프로그램 특성상 원치 않는 상황에서도 AI 팝업이 뜰 수 있어 설정 조절이 필요합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "과제/논문",
                "badge": "Research",
                "reason": "\"위키백과 말고 진짜 믿을 수 있는 자료 찾아줘\"라고 해야 하는 대학생"
            },
            {
                "target": "자료 스크랩",
                "badge": "Highlight",
                "reason": "여러 사이트의 정보를 한곳에 밑줄 그어 저장하고 요약하고 싶은 분"
            },
            {
                "target": "빠른 정보 습득",
                "badge": "Summary",
                "reason": "긴 유튜브 영상이나 구글 검색 결과를 3줄 요약으로 먼저 보고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "창작/소설",
                "reason": "팩트 기반 정보 수집이 아닌, 소설 쓰기나 창의적 글쓰기가 주 목적이라면 ChatGPT가 낫습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI Workspace",
            "description": "수집한 정보 기반으로 글쓰기 및 제안"
        },
        {
            "name": "Web/PDF Highlight",
            "description": "웹페이지 및 PDF 문서 형광펜 및 메모"
        },
        {
            "name": "AI Search",
            "description": "출처(학술/뉴스) 기반의 할루시네이션 적은 검색"
        },
        {
            "name": "Youtube Summary",
            "description": "영상 타임라인별 핵심 내용 요약"
        },
        {
            "name": "Deep Research",
            "description": "복합 질문에 대한 심층 분석 에이전트"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        'Pro 결제: 월 결제($19.99 수준)와 연 결제($11.67 수준) 가격 차이가 크니, 장기 사용 시 연 결제가 유리합니다.',
        '출처 확인: AI 답변에 달린 각주 번호를 클릭해 원본 사이트가 정말 존재하는지 확인하는 습관을 들이세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "personalization": "사용자가 하이라이트한 데이터를 기반으로 추천 알고리즘이 작동하여 검색 결과가 점점 개인화됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Perplexity",
            "description": "글로벌 검색과 빠른 답변에 더 집중된 도구"
        },
        {
            "name": "Scite.ai",
            "description": "논문의 인용 지수나 신뢰도를 더 전문적으로 파고든다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Liner AI: The Future of Search",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Liner%' OR name ILIKE '%라이너%';
