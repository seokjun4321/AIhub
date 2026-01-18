-- Update Jasper Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '단순한 글쓰기를 넘어, 우리 브랜드의 목소리(Tone & Manner)를 학습해 마케팅 캠페인 전반을 자동화하는 기업용 AI 마케팅 코파일럿.',
    website_url = 'https://www.jasper.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Chrome Extension", "API"],
        "target_audience": "기업 마케팅팀, 전문 카피라이터, 브랜드 매니저"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Subscription (구독형)',
    free_tier_note = '7일 무료 체험(Trial) 가능. 이후 자동 결제. (완전 무료 플랜은 없음).',
    pricing_plans = '[
        {
            "plan": "Creator",
            "price": "$39/월",
            "target": "개인 마케터",
            "features": "1인 사용, 브랜드 보이스 1개, SEO 모드 지원"
        },
        {
            "plan": "Pro",
            "price": "$59/인/월",
            "target": "소규모 팀",
            "features": "3인까지, 브랜드 보이스 3개, 아트(이미지) 생성 포함"
        },
        {
            "plan": "Business",
            "price": "별도 문의",
            "target": "기업",
            "features": "무제한 브랜드 보이스, API, 엔터프라이즈 보안"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Brand Voice: 우리 회사의 기존 블로그 글이나 소개서를 업로드하면, AI가 그 말투와 스타일을 분석해 "우리 회사 직원처럼" 글을 씁니다. (가장 큰 강점)',
        'Campaigns: "신제품 출시"라는 주제 하나만 던지면 블로그, 이메일, SNS, 보도자료까지 마케팅 풀 패키지를 한 번에 생성합니다.',
        'Jasper Art: 글쓰기 도구 안에서 저작권 걱정 없는 고퀄리티 마케팅용 이미지를 바로 생성해 삽입할 수 있습니다.',
        'SEO 최적화: SurferSEO 등과 연동되어, 검색 상위 노출을 위한 키워드 점수를 실시간으로 체크하며 글을 쓸 수 있습니다.'
    ],
    cons = ARRAY[
        '비싼 가격: 개인용 플랜도 월 $39(약 5만 원)부터 시작해, ChatGPT Plus($20)보다 비쌉니다. (철저히 B2B 타겟).',
        '짧은 글 비추: 단순한 이메일 한 통 쓰기에는 기능이 너무 방대하고 무겁습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "브랜드 마케터",
                "badge": "Brand",
                "reason": "여러 채널에 일관된 톤앤매너로 글을 써야 하는 담당자"
            },
            {
                "target": "콘텐츠 팀",
                "badge": "Team",
                "reason": "블로그, 뉴스레터, 인스타를 동시에 운영하며 생산성을 10배 높여야 하는 팀"
            },
            {
                "target": "SEO 작가",
                "badge": "SEO",
                "reason": "구글 노출을 노리는 긴 호흡의 아티클을 써야 하는 분"
            }
        ],
        "not_recommended": [
            {
                "target": "일반 작문",
                "reason": "학생 에세이나 일상적인 글쓰기 용도라면 ChatGPT나 Wrtn이 훨씬 가성비가 좋습니다"
            },
            {
                "target": "무료 선호",
                "reason": "무료로 찍먹해보고 싶다면 Copy.ai가 낫습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Brand Voice",
            "description": "기업 고유의 어조 학습 및 적용"
        },
        {
            "name": "Campaigns",
            "description": "하나의 브리핑으로 멀티채널 콘텐츠 일괄 생성"
        },
        {
            "name": "Jasper Art",
            "description": "텍스트 투 이미지 생성 기능 내장"
        },
        {
            "name": "Jasper Chat",
            "description": "대화형 인터페이스로 자료 조사 및 아이디어 도출"
        },
        {
            "name": "Browser Extension",
            "description": "구글 독스, 워드프레스, 메일 등 어디서나 Jasper 호출"
        },
        {
            "name": "SEO Mode",
            "description": "검색 엔진 최적화 점수 분석 및 개선 제안"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '체험판 취소: 7일 무료 체험을 신청했다면, 결제일 전에 취소해야 $39(또는 $59) 결제를 막을 수 있습니다.',
        '크레딧: 과거에는 단어 수 제한(Credit)이 있었으나, 최신 플랜은 대부분 무제한 생성을 지원합니다. (단, 공정 사용 정책 적용).'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "security": "Business 플랜은 데이터가 모델 학습에 사용되지 않으며, SOC2 인증을 받은 엔터프라이즈급 보안을 제공합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Copy.ai",
            "description": "좀 더 저렴하고 무료 플랜이 있는 마케팅 글쓰기 도구"
        },
        {
            "name": "ChatGPT Team",
            "description": "범용적인 업무 자동화가 목적이라면"
        },
        {
            "name": "Writesonic",
            "description": "SEO 글쓰기에 특화된 또 다른 가성비 도구"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Meet Jasper: The AI Copilot for Enterprise Marketing Teams",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Jasper%' OR name ILIKE '%재스퍼%';
