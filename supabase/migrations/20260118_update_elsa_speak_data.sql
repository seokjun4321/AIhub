-- Update ELSA Speak Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '단순히 말하는 것을 넘어, 억양/강세/발음 정확도를 음소 단위로 쪼개서 교정해 주는 AI 영어 발음 코치.',
    website_url = 'https://elsaspeak.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["iOS", "Android"],
        "target_audience": "발음이 고민인 학습자, 오픽(OPIc) 등 말하기 시험 준비생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (체험판 + 유료 구독)',
    free_tier_note = '7일 무료 체험 제공. 체험 기간 종료 후 자동 결제되므로 주의. 무료 모드에서는 하루 5개 정도의 제한된 레슨만 가능',
    pricing_plans = '[
        {
            "plan": "Pro",
            "price": "약 $11.99/월",
            "target": "발음 교정 집중",
            "features": "5,000+ 레슨 무제한, 발음/억양 분석, AI 롤플레잉 제한"
        },
        {
            "plan": "Premium",
            "price": "약 $13.33/월",
            "target": "회화+발음",
            "features": "AI 롤플레잉 무제한, Speech Analyzer, 맞춤형 학습 경로"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '나노 단위 발음 분석: \"L과 R 발음이 구분이 안 돼요\"라고 하면 혀의 위치와 입술 모양까지 피드백해 줍니다.',
        'Speech Analyzer: 프레젠테이션이나 인터뷰 연습 녹음을 올리면, 10분짜리 긴 발화도 분석해서 예측 점수(IELTS/TOEIC 등)를 알려줍니다.',
        'AI 롤플레잉 (Roleplay): 카페 주문, 연봉 협상 등 구체적인 상황에서 AI와 프리토킹을 하고, 문법과 표현을 즉시 교정받을 수 있습니다.',
        '개인화된 코스: 사용자의 실력을 진단 테스트로 파악한 후, 약점 위주로 매일 공부할 ''Daily Coach'' 코스를 짜줍니다.'
    ],
    cons = ARRAY[
        '유료 유도: 앱을 켜자마자 결제 창이 뜨며, 무료로 쓸 수 있는 범위가 매우 적습니다.',
        '발음 위주: \"자연스러운 대화\"보다는 \"정확한 발음\"에 초점이 맞춰져 있어, 유창성(Fluency)보다는 정확성(Accuracy) 훈련에 가깝습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "발음 교정",
                "badge": "Pronunciation",
                "reason": "\"Th\" 발음이나 억양이 어색해서 자신감이 없는 분"
            },
            {
                "target": "시험 준비",
                "badge": "Score",
                "reason": "OPIc, 토익 스피킹 등에서 고득점(발음 점수)이 필요한 수험생"
            },
            {
                "target": "혼자 연습",
                "badge": "Self Study",
                "reason": "사람(튜터) 앞에서는 부끄러워서 말을 못 하는 성격인 분"
            }
        ],
        "not_recommended": [
            {
                "target": "왕초보 문법",
                "reason": "주어-동사 순서도 헷갈리는 단계라면 발음 교정보다는 기본 회화 앱(듀오링고 등)이 낫습니다"
            },
            {
                "target": "전화 영어 대체",
                "reason": "실제 사람과 감정을 교류하는 대화를 원한다면 지루할 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "발음 정밀 진단",
            "description": "음소 단위(Phoneme) 정확도 분석 및 점수화"
        },
        {
            "name": "AI Roleplay",
            "description": "시나리오 기반의 자유 대화 및 피드백"
        },
        {
            "name": "Speech Analyzer",
            "description": "긴 문장/발표 내용을 녹음하면 유창성/문법/어휘 분석"
        },
        {
            "name": "Daily Coach",
            "description": "매일 10분 분량의 맞춤형 학습 퀘스트 제공"
        },
        {
            "name": "시험 예측 점수",
            "description": "내 발음을 분석해 IELTS/OPIc 예상 등급 제공"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '구독 취소: 7일 무료 체험을 시작했다면, 결제되기 하루 전에 미리 구독 취소를 해야 요금이 나가지 않습니다.',
        '마이크 환경: 시끄러운 곳에서는 인식률이 떨어져 점수가 낮게 나올 수 있으니 조용한 곳에서 이어폰/마이크를 쓰세요.',
        'Pro vs Premium: 단순히 발음 연습만 하려면 ''Pro''도 충분하지만, AI와 대화(롤플레잉)를 무제한으로 하려면 ''Premium''을 사야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_usage": "발음 분석을 위해 서버로 전송되나, 학습 데이터 활용 동의 여부를 설정에서 확인하세요.",
        "updates": "최근(2025/26) 대규모 업데이트로 UI와 학습 방식이 변경되었습니다. 기존 데이터는 유지됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Speak",
            "description": "발음보다는 ''문장 만들기''와 ''프리토킹''에 더 강점이 있는 한국형 1타 회화 앱"
        },
        {
            "name": "Cake",
            "description": "실제 영화/미드 클립을 따라 하며 배우는 무료(광고 포함) 학습"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "ELSA AI: The Future of English Learning",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%ELSA%' OR name ILIKE '%엘사%';
