UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    name = 'Google Gemini',
    description = 'Gemini 3 모델 기반의 초고속·고지능 멀티모달 AI이자, ''딥 씽크(Deep Think)'' 추론과 에이전트 기능을 갖춘 만능 어시스턴트.',
    website_url = 'https://gemini.google.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "Google 계정 필수",
        "platforms": ["Web", "Android", "iOS", "API", "Agentic Workflows"],
        "target_audience": "전천후(일반인부터 개발자, 크리에이터까지), 특히 복잡한 코딩과 영상 제작이 필요한 전문가"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = 'Gemini 3 Flash 모델(이전 Pro급 지능+초고속), 기본 이미지 생성, Google 앱 연동(Workspace) 무료.',
    pricing_plans = '[
        {
            "plan": "Gemini (Free)",
            "price": "무료",
            "target": "일반 사용자, 학생",
            "features": "Gemini 3 Flash 모델(초고속), 기본 멀티모달, 이미지 생성 무료"
        },
        {
            "plan": "Gemini Advanced",
            "price": "월 29,000원",
            "target": "전문가, 헤비 유저",
            "features": "Gemini 3 Pro 모델(고성능), Deep Think 추론, Veo 영상 생성"
        },
        {
            "plan": "Google Workspace",
            "price": "기업 문의",
            "target": "기업/팀",
            "features": "엔터프라이즈 보안, 관리자 콘솔 제공, 데이터 학습 제외"
        }
    ]'::jsonb,
    
    -- 3) Pros & Cons
    pros = ARRAY[
        '압도적인 속도와 지능(3 Flash): 무료 버전인 ''3 Flash''가 이전 세대(1.5 Pro)보다 똑똑하면서 속도는 훨씬 빨라졌습니다.',
        'Deep Think (심층 추론): 유료(Pro) 버전의 경우, 복잡한 수학/과학/코딩 문제 해결 시 스스로 생각하는 과정을 거쳐 정확도를 비약적으로 높입니다.',
        'Vibe Coding: 사용자가 원하는 UI나 앱의 ''느낌(Vibe)''만 설명해도 코드를 짜고 실행해주는 기능이 강력합니다.',
        '영상 생성(Veo): 텍스트 명령어로 고해상도 영상을 생성하는 ''Veo 3.1'' 기능이 통합되었습니다. (Advanced 전용)'
    ],
    cons = ARRAY[
        '기능 과부하: ''딥 씽크'', ''바이브 코딩'', ''Veo'' 등 기능이 너무 많아져, 단순 채팅만 원하는 사용자에겐 UI가 다소 복잡할 수 있습니다.',
        '엄격한 안전 필터: Gemini 3 역시 인물 생성이나 특정 주제에 대한 안전 필터(Safety Filter)가 매우 보수적으로 작동합니다.',
        '모바일 발열: 고성능 ''Nano Banana'' 모델 등이 온디바이스로 작동하거나 무거운 연산을 할 때 모바일 기기 발열 이슈가 간혹 보고됩니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            { "target": "복잡한 코딩/앱 개발", "badge": "Vibe Coding", "reason": "\"이런 느낌으로 웹사이트 만들어줘\"라고 하면 코드부터 프리뷰까지 한 번에 끝내고 싶은 분" },
            { "target": "영상 크리에이터", "badge": "Veo 3.1", "reason": "아이디어 구상 단계에서 즉시 시안 영상을 뽑아보고 싶은 분" },
            { "target": "심층 연구/학습", "badge": "Deep Think", "reason": "논문이나 전공 서적을 분석하고, 복잡한 수식을 틀리지 않고 풀고 싶은 분" },
            { "target": "Google 생태계", "badge": "Integration", "reason": "Gmail, Docs, Drive 내의 정보를 엮어서 비서처럼 부리고 싶은 분" }
        ],
        "not_recommended": [
            { "target": "단순/가벼운 대화", "reason": "굳이 ''딥 씽크''나 에이전트 기능이 필요 없고, 심플한 텍스트 핑퐁만 원하시는 분" },
            { "target": "성인/미검열 콘텐츠", "reason": "타협 없는 안전 정책으로 인해 자유도가 제한될 수 있습니다" }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        { "name": "Gemini 3 Flash", "description": "속도와 지능을 모두 잡은 차세대 기본 모델 (무료 제공)" },
        { "name": "Deep Think (심층 추론)", "description": "복잡한 문제를 단계별로 생각하여 해결 (Pro 전용)" },
        { "name": "Veo 3.1 영상 생성", "description": "텍스트 프롬프트로 고화질 비디오 클립 생성" },
        { "name": "Nano Banana Pro(이미지)", "description": "텍스트 및 이미지 편집을 위한 최신 이미지 생성 모델" },
        { "name": "Agentic Workflows", "description": "여러 단계의 작업을 자율적으로 수행하는 에이전트 기능" },
        { "name": "실시간 멀티모달", "description": "영상/음성을 실시간으로 보고 들으며 대화 가능" },
        { "name": "확장 프로그램", "description": "YouTube, Maps, Hotels, Flights 등 실시간 정보 연동" }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '모델 선택 확인: 채팅창 상단에서 ''Flash(속도)''와 ''Thinking(추론)'' 모드를 작업 성격에 맞게 전환하세요. 간단한 인사는 Flash가, 코딩은 Thinking이 유리합니다.',
        'Veo 크레딧: 영상 생성 기능(Veo)은 무제한이 아닐 수 있으며, 생성 횟수 제한이 있는지 확인이 필요합니다.',
        '할루시네이션: ''Deep Think''가 논리적 오류를 많이 줄였지만, 여전히 팩트(연도, 인물 등)는 ''G'' 버튼으로 교차 검증해야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "무료/개인용 유료 버전의 대화는 일부 익명화되어 모델 개선에 활용될 수 있습니다. (설정에서 Off 가능)",
        "enterprise_security": "기업용 라이선스 사용 시 데이터 학습이 원천 차단됩니다.",
        "privacy_protection": "생성된 모든 영상(Veo)과 이미지(Imagen/Nano)에는 AI 생성물임을 식별하는 ''SynthID'' 워터마크가 삽입됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        { "name": "ChatGPT (GPT-4o/5 계열)", "description": "OpenAI의 최신 모델, 여전히 가장 강력한 범용 경쟁자" },
        { "name": "Claude (Anthropic)", "description": "자연스러운 문맥 이해와 코딩 능력에서 Gemini와 쌍벽" },
        { "name": "Perplexity", "description": "답변 생성보다는 ''검색''과 ''출처''가 핵심일 때" }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Gemini 3", 
            "url": "https://www.youtube.com/watch?v=gemini3_official", 
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Gemini%';
