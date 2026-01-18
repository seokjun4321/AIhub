-- Update Naver CLOVA X Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '한국의 언어와 문화, 법률, 시사 정보를 가장 잘 이해하는 네이버의 초대규모 AI ''하이퍼클로바X'' 기반 대화형 에이전트.',
    website_url = 'https://clova-x.naver.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "한국형 정보 검색, 자소서 작성, 국내 마케팅 문구 작성이 필요한 모든 사용자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Free (Beta) / Enterprise Paid',
    free_tier_note = 'CLOVA X (대화형 에이전트) 서비스는 현재 무료(Beta)로 제공 (단, 3시간당 대화 턴 수 제한 등이 있을 수 있음)',
    pricing_plans = '[
        {
            "plan": "Beta (Free)",
            "price": "무료",
            "target": "일반 사용자",
            "features": "HyperCLOVA X 모델 대화, 최신 정보 검색(네이버 연동)"
        },
        {
            "plan": "Enterprise",
            "price": "별도 문의",
            "target": "기업",
            "features": "전용 클라우드, 보안 강화, API 사용 (CLOVA Studio)"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '한국 문화 이해: "국밥집 리뷰 써줘"라거나 "추석 인사말 추천해줘" 같은 한국적 맥락이 필요한 요청에서 ChatGPT보다 훨씬 자연스럽습니다.',
        '네이버 검색 연동: 네이버 여행, 쇼핑, 뉴스 정보를 실시간으로 검색해 답변에 반영하므로 최신 국내 정보(맛집, 날씨 등)에 강합니다.',
        '문서 요약: PDF나 HWP(한글) 파일을 업로드하면 내용을 요약하고 질문에 답변해 줍니다. (한국 공공기관 문서 처리에 유리)'
    ],
    cons = ARRAY[
        '스킬(Skill) 축소: 쏘카, 배달의민족 등 외부 앱을 연동하던 ''스킬'' 기능이 2026년 1월부로 종료되어 확장성이 다소 줄었습니다.',
        '코딩/수학: 복잡한 코딩이나 수학적 추론 능력은 GPT-4나 Claude 3.5 대비 다소 떨어질 수 있습니다.',
        '속도: 답변 생성 속도가 경쟁 모델 대비 가끔 느리게 느껴질 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "자소서/글쓰기",
                "badge": "Korean Writing",
                "reason": "한국어 존댓말, 문체 보정, 자연스러운 마케팅 카피 작성이 필요한 분"
            },
            {
                "target": "국내 정보 검색",
                "badge": "Local Info",
                "reason": "\"부산 2박 3일 여행 코스 짜줘\"처럼 국내 로컬 정보가 필요한 분"
            },
            {
                "target": "HWP 문서 분석",
                "badge": "HWP Support",
                "reason": "한글 파일 내용을 복사하지 않고 통째로 올려서 분석하고 싶은 직장인/공무원"
            }
        ],
        "not_recommended": [
            {
                "target": "전문 코딩",
                "reason": "복잡한 파이썬 코드 생성이나 디버깅이 주 목적이라면 GitHub Copilot이나 ChatGPT가 낫습니다"
            },
            {
                "target": "영어 작문",
                "reason": "영작도 가능하지만, DeepL이나 ChatGPT의 뉘앙스가 더 세련될 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "HyperCLOVA X",
            "description": "한국어 특화 초거대 언어 모델"
        },
        {
            "name": "네이버 검색 연동",
            "description": "실시간 뉴스, 블로그, 쇼핑 정보 반영"
        },
        {
            "name": "문서 업로드(Connector)",
            "description": "PDF, TXT, CSV, HWP 파일 기반 대화"
        },
        {
            "name": "글쓰기 도우미",
            "description": "블로그 포스팅, 이메일 초안, 보고서 목차 생성"
        },
        {
            "name": "논리적 추론",
            "description": "(업데이트) 계획 수립 및 추론 능력 고도화"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '스킬 종료: 2026년 1월 14일부터 외부 앱 연동(스킬) 기능이 종료되었으므로, 예전 블로그 글을 보고 "쏘카 예약해줘"라고 해도 작동하지 않습니다.',
        '환각(Hallucination): 네이버 검색 결과를 가져오더라도 가끔 틀린 정보를 섞어 말할 수 있으니 출처를 꼭 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "opt_out": "기본 설정에서 데이터 활용 동의(선택)를 끄면 내 대화가 모델 학습에 쓰이지 않습니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Wrtn",
            "description": "GPT-4와 Claude를 무료로 쓰면서 한국어 검색까지 원할 때"
        },
        {
            "name": "ChatGPT",
            "description": "가장 범용적이고 추론 능력이 뛰어난 글로벌 표준"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "HyperCLOVA X: 네이버의 새로운 AI",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%CLOVA X%' OR name ILIKE '%클로바X%';
