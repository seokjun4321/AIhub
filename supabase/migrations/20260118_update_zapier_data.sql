-- Update Zapier Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '6,000개 이상의 앱을 코딩 없이 연결하여 반복 업무를 자동화하고, ''Zapier Central''로 AI 봇까지 만들 수 있는 노코드 자동화의 끝판왕.',
    website_url = 'https://zapier.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "반복 업무(복붙)를 없애고 싶은 직장인, 마케터, 운영 매니저"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '**월 100 태스크(작업)** 무료. **단일 단계(Single-step) Zap**만 가능(트리거 1개 + 액션 1개).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "개인/테스트",
            "features": "100 태스크/월, 단일 단계 Zap, 기본 앱 연동"
        },
        {
            "plan": "Starter",
            "price": "$19.99/월",
            "target": "프리랜서",
            "features": "750 태스크/월, 다단계(Multi-step) Zap, 필터/포맷터 사용"
        },
        {
            "plan": "Professional",
            "price": "$49/월",
            "target": "실무자",
            "features": "2,000 태스크/월, 무제한 Zap, 고급 로직(Branching)"
        },
        {
            "plan": "Team",
            "price": "$69/월",
            "target": "팀 협업",
            "features": "공유 워크스페이스, 무제한 사용자, 프리미어 서포트"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적 연동성: Gmail, Slack, Notion, 엑셀, 심지어 한국의 카카오톡(비즈니스)까지 API만 있다면 거의 모든 앱을 연결할 수 있습니다.',
        'Zapier Central (AI): 단순 자동화를 넘어, "이메일 오면 내용을 요약해서 노션에 정리하고 슬랙으로 알려줘" 같은 AI 에이전트 봇을 말로 만들 수 있습니다.',
        'Canvas: 복잡한 업무 흐름을 화이트보드에 그림 그리듯 시각화(Diagram)하면서 자동화 로직을 짤 수 있습니다.',
        '안정성: 자동화 툴 중 가장 역사가 깊고 서버 안정성이 뛰어나 에러율이 낮습니다.'
    ],
    cons = ARRAY[
        '비싼 가격: 경쟁 툴(Make, n8n)에 비해 태스크당 단가가 비쌉니다. (무료 100 태스크는 금방 씁니다).',
        '무료 제한: 무료 플랜에서는 ''A 하면 B 하고 C 한다(다단계)''는 설정이 불가능해 실무에 쓰기 어렵습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "마케터",
                "badge": "Marketing",
                "reason": "\"페이스북 광고로 들어온 리드를 엑셀에 넣고 문자 보내기\" 자동화"
            },
            {
                "target": "쇼핑몰 운영",
                "badge": "E-commerce",
                "reason": "\"주문 들어오면 배송팀 슬랙에 알림 보내기\""
            },
            {
                "target": "AI 활용",
                "badge": "AI Bot",
                "reason": "ChatGPT와 다른 앱들을 연결해 \"자동 블로그 포스팅 봇\"을 만들고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "대량 데이터 처리",
                "reason": "하루에 수천 건의 데이터를 동기화해야 한다면 Zapier는 비용 폭탄을 맞을 수 있습니다. (Make가 더 저렴)"
            },
            {
                "target": "복잡한 로직",
                "reason": "개발자 수준의 복잡한 데이터 가공이 필요하다면 n8n(오픈소스)이 더 낫습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Zaps",
            "description": "트리거(Trigger)와 액션(Action)을 연결하는 자동화 레시피"
        },
        {
            "name": "Zapier Central",
            "description": "대화형 AI 봇이 데이터를 검색하고 작업을 수행"
        },
        {
            "name": "Canvas",
            "description": "업무 프로세스 시각화 및 자동화 설계 도구"
        },
        {
            "name": "Tables",
            "description": "엑셀 없이 Zapier 내에서 데이터 저장 및 관리 (No-code DB)"
        },
        {
            "name": "Interfaces",
            "description": "나만의 앱/폼(Form)을 만들어 데이터 수집"
        },
        {
            "name": "Multi-step Zaps",
            "description": "하나의 트리거로 여러 가지 액션 연쇄 실행 (유료)"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '태스크 계산: "이메일 1개 처리"가 태스크 1개가 아니라, 그 안의 동작(Step) 하나하나가 태스크입니다. 복잡한 Zap은 1번 실행에 태스크 5~10개를 쓸 수도 있습니다.',
        '무한 루프: A가 B를 만들고, B가 다시 A를 건드리는 설정을 하면 순식간에 태스크 수천 개가 증발할 수 있으니 주의하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "security": "SOC 2 Type II 및 GDPR을 준수하며, 엔터프라이즈 플랜에서는 고급 관리자 권한을 제공합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Make",
            "description": "시각적이고 가격이 훨씬 저렴하지만 배우기 약간 어려움"
        },
        {
            "name": "n8n",
            "description": "자체 서버에 설치해 무료로 쓸 수 있는 개발자 친화적 자동화 툴"
        },
        {
            "name": "IFTTT",
            "description": "스마트홈이나 개인용 간단 자동화에 적합"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "What is Zapier?",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Zapier%' OR name ILIKE '%재피어%';
