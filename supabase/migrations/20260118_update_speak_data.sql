-- Update Speak Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '실리콘밸리의 AI 음성 기술을 활용해, 원어민 없이도 24시간 영어회화 프리토킹과 발음 교정이 가능한 AI 튜터 앱.',
    website_url = 'https://www.speak.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["iOS", "Android"],
        "target_audience": "영어 말문이 막히는 초보자부터, 자유로운 프리토킹을 원하는 고급 학습자까지"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Subscription (구독형)',
    free_tier_note = '7일 무료 체험 제공, 이후 유료 전환 (완전 무료 플랜 없음)',
    pricing_plans = '[
        {
            "plan": "Premium",
            "price": "약 12,400원/월",
            "target": "일반 학습자",
            "features": "정규 코스 무제한, AI 튜터(프리톡) 크레딧 제한"
        },
        {
            "plan": "Premium Plus",
            "price": "약 23,200원/월",
            "target": "열공족",
            "features": "AI 튜터/프리톡 무제한, 맞춤형 레슨 생성, 심층 리뷰"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적인 발화량: 눈으로 보는 인강이 아니라, 20분 수업 동안 사용자가 100문장 이상을 입으로 뱉게 만듭니다.',
        '프리톡(AI 튜터): 특정 상황(공항 입국 심사, 햄버거 주문 등)을 설정하면 AI와 실제 사람처럼 대화하며 롤플레잉할 수 있습니다.',
        '실시간 피드백: 내가 말한 문장의 문법 오류나 더 자연스러운 표현을 즉시 고쳐줍니다.',
        '비주얼 모드(최신): 2025년 업데이트로 AI 튜터와 대화할 때 상황에 맞는 시각적 요소가 강화되어 몰입감이 높아졌습니다.'
    ],
    cons = ARRAY[
        '유료 전용: 완전 무료 플랜이 없어, 체험 기간이 끝나면 무조건 결제해야 합니다.',
        '크레딧 제한(Premium): 기본 Premium 플랜은 자유 대화(AI 튜터) 사용량에 일일 제한(불꽃/크레딧)이 있어 헤비 유저는 Premium Plus가 필요합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "영어 울렁증",
                "badge": "Confidence",
                "reason": "외국인 앞에서는 입이 얼어버리는 분 (AI라 부끄럽지 않음)"
            },
            {
                "target": "오픽/토스 준비",
                "badge": "Speaking Test",
                "reason": "다양한 주제로 끊임없이 말하는 연습이 필요한 수험생"
            },
            {
                "target": "중급 이상",
                "badge": "Advanced",
                "reason": "기본적인 문법은 알지만 원어민스러운 뉘앙스와 표현을 배우고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "문법/독해 위주",
                "reason": "수능 영어나 토익 RC 점수가 목표인 분에게는 맞지 않습니다(말하기 특화)"
            },
            {
                "target": "완전 무료 앱 선호",
                "reason": "돈을 전혀 쓰고 싶지 않다면 Duolingo(듀오링고)가 대안일 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "단계별 코스",
            "description": "왕초보부터 비즈니스까지 체계적인 스피킹 커리큘럼"
        },
        {
            "name": "AI 롤플레잉",
            "description": "여행, 비즈니스, 일상 등 수백 가지 상황극 대화"
        },
        {
            "name": "발음 교정",
            "description": "음성 인식으로 내 발음의 정확도를 점수로 매겨줌"
        },
        {
            "name": "스마트 리뷰",
            "description": "틀린 문장이나 잘 안 외워지는 표현을 반복 학습"
        },
        {
            "name": "Just Ask",
            "description": "궁금한 영어 표현이나 단어를 물어보면 즉답해주는 AI Q&A"
        },
        {
            "name": "나만의 레슨(Plus)",
            "description": "관심사를 입력하면 AI가 맞춤형 수업을 즉석 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '자동 결제 주의: 7일 무료 체험 후 자동으로 1년치(약 10~20만 원)가 결제되니, 계속 쓸 생각이 없다면 미리 구독 취소하세요.',
        '플랜 선택: \"매일 30분 이상 프리토킹을 하겠다\"면 Premium Plus가 필수지만, 정규 코스 위주로 하루 20분만 한다면 Premium으로 충분합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_usage": "발음 분석 및 서비스 개선을 위해 사용되나, 계정 삭제 시 함께 파기됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Duolingo",
            "description": "게임처럼 가볍게 배우는 무료 언어 학습 앱 (말하기 비중은 낮음)"
        },
        {
            "name": "Cake",
            "description": "유튜브 영상 클립으로 배우는 실생활 영어 표현"
        },
        {
            "name": "HelloTalk",
            "description": "실제 외국인 친구와 언어 교환을 하고 싶다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Speak: The Ultimate AI English Tutor",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Speak%' OR name ILIKE '%스픽%';
