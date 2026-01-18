-- Update inFACE Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '국내 기업 채용에 실제 사용되는 ''AI 역량 검사(게임+면접)'' 시스템과 가장 유사한 환경을 제공하는 실전 모의 테스트 도구.',
    website_url = 'http://www.inface.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web (PC 권장)"],
        "target_audience": "AI 역량 검사(마이다스아이티 등) 전형이 있는 기업 지원자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (대학 제휴 무료 / 개인 유료)',
    free_tier_note = '제휴 대학교 재학생은 도서관/취업지원센터를 통해 무제한 무료 이용 가능. (개인은 별도 이용권 구매 필요)',
    pricing_plans = '[
        {
            "plan": "제휴 대학",
            "price": "무료(학교 부담)",
            "target": "대학생",
            "features": "AI 역량 검사 / 자소서 등 무제한 무료"
        },
        {
            "plan": "개인 회원",
            "price": "유료",
            "target": "일반 취준생",
            "features": "이용권 구매 후 사용 (24시간/회차별 상이)"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '전략 게임 연습: 단순 면접뿐만 아니라, AI 채용의 핵심인 ''성향 파악 게임(N-back, 하노이의 탑 등)''을 미리 연습해볼 수 있습니다.',
        '실전 싱크로율: 실제 기업이 쓰는 솔루션(Educe 등) 기반이라 화면 구성이나 진행 방식이 실전과 매우 흡사합니다.',
        '대학 제휴: 웬만한 국내 4년제 대학과는 제휴가 되어 있어 공짜로 쓸 수 있는 확률이 높습니다.'
    ],
    cons = ARRAY[
        'PC 필수: 마우스 감도나 게임 조작 때문에 모바일보다는 PC/노트북 환경에서 해야 제대로 된 연습이 됩니다.',
        '유료 접근성: 학교 제휴가 없으면 개인이 돈 내고 쓰기에 결제 루트가 번거로울 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "AI 역량 검사 예정자",
                "badge": "Test Prep",
                "reason": "다음 주에 AI 면접(게임 포함)을 봐야 하는 지원자 (필수)"
            },
            {
                "target": "게임 불안감",
                "badge": "Strategy Game",
                "reason": "\"AI 면접에서 게임을 망치면 떨어진다는데...\" 걱정되는 분"
            },
            {
                "target": "대학생",
                "badge": "Free (Univ)",
                "reason": "학교 돈으로 비싼 솔루션을 무료로 쓰고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "단순 인성 면접",
                "reason": "게임이나 역량 분석 없이 그냥 말하기 연습만 하고 싶다면 Haijob이나 Vrew가 더 가볍습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI 역량 검사",
            "description": "성향 파악, 전략 게임, 심층 대화 풀코스 모의고사"
        },
        {
            "name": "전략 게임 연습",
            "description": "뇌과학 기반의 미니 게임(순발력, 기억력 등) 무제한 연습"
        },
        {
            "name": "기본/심화 면접",
            "description": "자기소개, 성격 장단점 및 상황 대처 질문"
        },
        {
            "name": "결과 분석지",
            "description": "나의 호감도, 뇌파(추정), 역량 등급표 제공"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '학교 확인: 구글에 \"OO대학교 인페이스\" 또는 \"OO대 AI면접\"이라고 검색해보세요. 로그인만 학교 포털로 하면 무료입니다.',
        '마우스 준비: 게임 단계에서는 트랙패드보다 마우스가 훨씬 유리합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "retention": "나의 게임 결과와 영상 데이터는 분석 리포트 생성 후 일정 기간 뒤 파기됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Jobda (잡다)",
            "description": "마이다스아이티(실제 AI 역검 개발사)가 운영하는 공식 연습 사이트 (가장 정확함)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "인페이스 AI 면접 솔루션 소개",
            "url": "https://www.youtube.com/watch?v=fgbxhQkiCAs",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%inFACE%' OR name ILIKE '%인페이스%';
