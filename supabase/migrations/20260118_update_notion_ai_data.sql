-- Update Notion AI Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '내 노션 워크스페이스에 있는 모든 문서와 회의록을 기억하고, 질문하면 찾아주고 요약하고 글까지 써주는 올인원 업무 비서.',
    website_url = 'https://www.notion.so/product/ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Windows", "macOS", "iOS", "Android"],
        "target_audience": "노션을 ''제2의 두뇌''로 쓰는 헤비 유저, 문서가 너무 많아 못 찾는 팀"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Paid Add-on (유료 부가서비스)',
    free_tier_note = '별도 AI 무료 플랜은 없으며, 일반 사용자에게 **맛보기용(20~40회) 무료 응답**이 제공될 수 있음. 이후엔 결제 차단.',
    pricing_plans = '[
        {
            "plan": "AI Add-on",
            "price": "$8/월",
            "target": "모든 유저",
            "features": "Q&A(내 문서 검색), 글쓰기, 자동 채우기, 무제한 사용"
        },
        {
            "plan": "Notion Plus",
            "price": "$8/월",
            "target": "(참고)",
            "features": "AI 기능 제외, 블록 무제한 등 워크스페이스 기능"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Q&A 기능: "지난주 마케팅 회의에서 결정된 예산이 얼마지?"라고 물으면, 수많은 회의록 중 정확한 문서를 찾아 답변해 줍니다. (ChatGPT보다 내 업무를 더 잘 앎)',
        '데이터베이스 자동화: 표(Database)에 ''AI 요약'', ''AI 번역'' 속성을 넣으면, 데이터가 추가될 때마다 AI가 알아서 빈칸을 채워줍니다.',
        '글쓰기 통합: 별도 창을 띄울 필요 없이, 스페이스바만 누르면 바로 초안을 작성하거나 톤을 수정할 수 있습니다.',
        '보안: 내 데이터를 AI 학습에 사용하지 않는다고 명시하여, 기업 데이터 보안 우려가 적습니다.'
    ],
    cons = ARRAY[
        '별도 과금: 노션 요금제(Plus)를 내고 있어도, AI를 쓰려면 인당 $8을 **추가로** 내야 해서 팀 단위 도입 시 비용이 꽤 듭니다.',
        '외부 정보 한계: 내 문서 안의 정보는 잘 찾지만, 최신 인터넷 뉴스를 검색해서 알려주는 기능(Perplexity 같은)은 약합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "노션 헤비 유저",
                "badge": "Power User",
                "reason": "노션에 자료가 너무 많아서 검색해도 잘 안 나오는 분 (Q&A 필수)"
            },
            {
                "target": "프로젝트 매니저",
                "badge": "PM",
                "reason": "회의록 요약과 할 일 추출을 자동으로 끝내고 싶은 분"
            },
            {
                "target": "데이터 정리",
                "badge": "Organization",
                "reason": "수백 개의 고객 피드백을 감정 분석하거나 태그를 달아야 하는 분 (자동 채우기)"
            }
        ],
        "not_recommended": [
            {
                "target": "노션 안 쓰는 분",
                "reason": "노션에 데이터가 없으면 깡통이나 마찬가지입니다. (일반 챗봇은 ChatGPT가 더 쌈)"
            },
            {
                "target": "가성비",
                "reason": "AI 기능만 가끔 쓸 거라면 월 $10 추가 결제는 비쌀 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Q&A",
            "description": "내 워크스페이스 문서를 기반으로 답변하는 지능형 검색"
        },
        {
            "name": "Autofill",
            "description": "데이터베이스 속성(요약, 번역, 태그) 자동 입력"
        },
        {
            "name": "Writer",
            "description": "초안 작성, 이어 쓰기, 문체 변경, 맞춤법 교정"
        },
        {
            "name": "Summarizer",
            "description": "긴 회의록이나 문서 핵심 내용 3줄 요약"
        },
        {
            "name": "Connect",
            "description": "(최신) Slack, Google Drive 등 외부 앱 데이터까지 연결하여 답변"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '요금 착각: "노션 유료 회원이니까 AI도 되겠지?" -> 아닙니다. **별도 구매**입니다. 반대로 무료 회원도 AI만 따로 결제해서 쓸 수 있습니다.',
        '환각 주의: 내 문서에 없는 내용을 물어보면 가끔 지어낼 수 있으니, 답변 아래에 달린 ''출처(어느 페이지에서 가져왔는지)''를 꼭 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training": "Notion AI는 고객 데이터를 모델 학습에 사용하지 않으며, 데이터는 암호화되어 처리됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Obsidian",
            "description": "로컬 기반의 보안과 무료 AI 연결을 원한다면 (with AI plugin)"
        },
        {
            "name": "Microsoft Copilot",
            "description": "노션 대신 MS Word/Excel 생태계를 쓴다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Notion AI Q&A",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Notion%' OR name ILIKE '%노션%';
