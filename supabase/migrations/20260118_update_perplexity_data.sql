-- Update Perplexity Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '최신 AI 모델(GPT-5/Claude 3.7 등)을 실시간 웹 검색과 결합하여, 출처가 명확하고 깊이 있는 답변을 제공하는 ''대화형 검색 엔진''.',
    website_url = 'https://www.perplexity.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "optional",
        "platforms": ["Web", "iOS", "Android", "Chrome Extension"],
        "target_audience": "팩트 체크가 필요한 연구자, 최신 정보를 찾는 기획자, 구글링 시간을 줄이고 싶은 모든 사람"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '기본 검색 무제한(Standard Model), **Pro Search 하루 5회** 제공. 파일 업로드 제한적.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "기본 검색, Pro Search 5회/일, 기본 모델"
        },
        {
            "plan": "Pro",
            "price": "$20/월",
            "target": "헤비 유저",
            "features": "Pro Search 300회+/일, GPT-4o/Claude 3.7 선택, $5 API 크레딧"
        },
        {
            "plan": "Max",
            "price": "$200/월",
            "target": "전문가",
            "features": "Pro Search 무제한, O3-Pro 등 최상위 모델 접근, 우선 처리"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '모델 선택권: 유료 사용자는 GPT-4o, Claude 3.7 Sonnet, Sonar(자체 모델) 중 원하는 두뇌를 골라 검색할 수 있습니다.',
        'Pro Search (심층 검색): 단순 키워드 매칭이 아니라, AI가 질문을 이해하기 위해 역으로 질문(Clarifying Question)을 던지고, 단계별로 추론하여 보고서급 답변을 줍니다.',
        '정확한 출처: 모든 문장 뒤에 각주([1], [2])가 달려있어, 클릭 한 번으로 원본 뉴스나 논문을 검증할 수 있습니다. (할루시네이션 최소화)',
        'Deep Research: 2025년 도입된 심층 리서치 기능으로, 복잡한 시장 조사나 학술 조사를 자율 에이전트가 수행합니다.'
    ],
    cons = ARRAY[
        '무료 제한: 하루 5회의 Pro Search는 금방 소진되며, 이후에는 다소 성능이 낮은 기본 모델로 전환됩니다.',
        '창의성 부족: ''검색''에 최적화되어 있어, 소설 쓰기나 자유로운 창작(Roleplay) 능력은 전문 챗봇보다 딱딱할 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "시장 조사",
                "badge": "Research",
                "reason": "\"2026년 생성형 AI 시장 규모와 주요 플레이어 정리해줘\" 같은 리서치가 필요한 기획자"
            },
            {
                "target": "팩트 체크",
                "badge": "Fact Check",
                "reason": "\"이 뉴스 진짜야?\" 하고 교차 검증이 필요한 경우"
            },
            {
                "target": "모델 찍먹",
                "badge": "All-in-One",
                "reason": "GPT와 Claude 유료 버전을 따로 결제하기 아까운 분 (하나로 다 쓸 수 있음)"
            }
        ],
        "not_recommended": [
            {
                "target": "창작 작가",
                "reason": "팩트 기반이 아닌 감성적인 글쓰기나 스토리텔링이 주 목적일 때"
            },
            {
                "target": "오프라인",
                "reason": "인터넷 연결 없이는 아무런 답변도 할 수 없습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Pro Search",
            "description": "다단계 추론을 통한 심층 답변 생성"
        },
        {
            "name": "Model Switch",
            "description": "GPT-4o, Claude 3.7, Sonar 모델 자유 전환 (Pro)"
        },
        {
            "name": "Collections",
            "description": "검색 결과를 주제별로 모아두고 공유하는 보관함"
        },
        {
            "name": "File Analysis",
            "description": "PDF/CSV 파일을 업로드하면 내용 분석 및 요약"
        },
        {
            "name": "Discover",
            "description": "그날의 주요 뉴스를 AI가 요약해주는 뉴스 피드"
        },
        {
            "name": "Pages",
            "description": "검색 결과를 바탕으로 블로그 글 형태의 페이지 자동 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        'Copilot 횟수: 무료 사용자는 ''Pro Search(구 Copilot)'' 버튼을 켜두면 순식간에 5회가 차감되니, 꼭 필요할 때만 켜세요.',
        '최신성 설정: 검색 대상이 ''전체 웹''인지 ''학술(Academic)''인지, ''유튜브''인지 필터를 잘 걸어야 원하는 결과를 얻습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "setting": "설정에서 ''AI 데이터 사용(AI Data Retention)''을 끄면 내 검색 기록이 모델 학습에 사용되지 않습니다.",
        "enterprise": "기업용 플랜은 데이터 학습이 원천 차단되며 SOC2 보안을 준수합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Liner",
            "description": "한국어 검색 최적화와 형광펜 기능이 필요하다면"
        },
        {
            "name": "Google Gemini",
            "description": "구글 워크스페이스(Docs, Gmail) 연동이 중요하다면"
        },
        {
            "name": "ChatGPT Search",
            "description": "대화의 맥락 유지와 검색을 동시에 하고 싶다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Perplexity: Where knowledge begins",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Perplexity%' OR name ILIKE '%퍼플렉시티%';
