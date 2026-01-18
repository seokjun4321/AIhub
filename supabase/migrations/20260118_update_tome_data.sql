-- Update Tome Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '텍스트 프롬프트만 입력하면 스토리텔링이 담긴 고퀄리티 프레젠테이션 슬라이드(PPT)를 이미지와 함께 자동 생성해 주는 AI 도구.',
    website_url = 'https://tome.app',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "iOS"],
        "target_audience": "스타트업 대표(Pitch Deck), 마케터, 감각적인 슬라이드가 필요한 기획자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 제한적 + 유료 구독)',
    free_tier_note = '기본 템플릿 사용 및 수동 편집 가능. AI 슬라이드 생성 기능은 무료 버전에서 제한되거나 크레딧이 제공되지 않을 수 있습니다.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "뷰어/편집",
            "features": "수동 편집, 기본 템플릿, AI 생성 제한됨"
        },
        {
            "plan": "Tome Plus",
            "price": "$10/월",
            "target": "개인/전문가",
            "features": "무제한 AI 생성, PDF 내보내기, 로고 제거"
        },
        {
            "plan": "Pro",
            "price": "$16~/월",
            "target": "팀 협업",
            "features": "워크스페이스 협업, 고급 브랜딩, 우선 지원"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '스토리텔링 중심: 단순히 개조식 나열이 아니라, "이야기"가 있는 내러티브 구조를 짜주는 데 특화되어 있습니다.',
        '세련된 디자인: 파워포인트의 딱딱한 느낌이 아닌, 매거진이나 노션(Notion) 스타일의 모던한 레이아웃을 자동으로 잡아줍니다.',
        '멀티미디어 통합: Figma, YouTube, Twitter 등을 슬라이드 안에 바로 임베드(Embed)하여 보여줄 수 있습니다.',
        'DALL-E 3 통합: 슬라이드 분위기에 맞는 고해상도 이미지를 AI가 즉석에서 생성해 배치합니다.'
    ],
    cons = ARRAY[
        '무료 AI 제한: 초기와 달리 현재는 AI 생성 기능을 제대로 쓰려면 유료 결제가 거의 필수입니다.',
        'PPT 호환성: 파워포인트 파일(.pptx)로 내보낼 수는 있지만, 레이아웃이 이미지 통으로 저장되거나 폰트가 깨지는 등 완벽한 호환은 어렵습니다.',
        '정형화된 포맷: 자유로운 도형 배치보다는 정해진 그리드(Grid) 안에서의 배치를 강제하므로 디자인 자유도가 낮습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "스타트업 IR",
                "badge": "Pitch Deck",
                "reason": "투자자에게 보낼 깔끔하고 트렌디한 회사 소개서(Deck)를 10분 만에 만들고 싶은 분"
            },
            {
                "target": "포트폴리오",
                "badge": "Portfolio",
                "reason": "텍스트와 이미지가 조화로운 개인 포트폴리오 사이트 같은 슬라이드가 필요한 분"
            },
            {
                "target": "아이디어 시각화",
                "badge": "Storytelling",
                "reason": "머릿속 생각을 빠르게 시각적 스토리로 구체화해보고 싶은 기획자"
            }
        ],
        "not_recommended": [
            {
                "target": "전통적 보고서",
                "reason": "표, 차트, 빽빽한 텍스트가 들어가야 하는 관공서/대기업 보고서"
            },
            {
                "target": "애니메이션 필수",
                "reason": "화면 전환 효과나 객체 애니메이션을 화려하게 넣어야 하는 경우"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI Presentation",
            "description": "프롬프트 입력으로 슬라이드 전체 자동 생성"
        },
        {
            "name": "Document to Presentation",
            "description": "긴 문서를 붙여넣으면 요약해서 슬라이드로 변환"
        },
        {
            "name": "AI Image Gen",
            "description": "DALL-E 3 기반으로 슬라이드에 어울리는 이미지 자동 생성"
        },
        {
            "name": "Responsive Layout",
            "description": "모바일, 태블릿, PC 어디서 봐도 깨지지 않는 반응형 디자인"
        },
        {
            "name": "Integration",
            "description": "Figma, Framer, Miro, YouTube 등 외부 툴 임베드"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '유료 결제: "예전엔 무료였는데?" 하고 들어갔다가 AI 기능이 안 돼서 당황할 수 있습니다. 본격적으로 쓰려면 월 $10 결제를 고려하세요.',
        '한글 폰트: 기본 폰트가 영어에 최적화되어 있어, 한글 입력 시 폰트가 투박하게 보일 수 있으니 설정에서 폰트를 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "sharing": "생성된 자료는 웹 링크 형태로 공유되는데, 비밀번호 설정이나 권한 관리를 꼼꼼히 해야 합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Gamma",
            "description": "PPT/PDF 내보내기가 훨씬 강력하고 디자인 수정이 유연함"
        },
        {
            "name": "Canva",
            "description": "다양한 템플릿과 디자인 요소가 중요하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Tome: The AI-powered storytelling format",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Tome%' OR name ILIKE '%톰%';
