-- Update Copy.ai Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '반복적인 영업/마케팅 업무를 ''워크플로우(Workflow)''로 자동화하고, 수천 개의 카피를 대량 생산하는 GTM(Go-to-Market) AI 플랫폼.',
    website_url = 'https://www.copy.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "영업(Sales) 담당자, 퍼포먼스 마케터, 콜드 메일 발송자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '**월 2,000단어** 생성 무료, 1 사용자, 채팅 기능 제한적 사용 가능. (신용카드 등록 불필요).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "개인/체험",
            "features": "2,000단어/월, 1유저, 기본 채팅"
        },
        {
            "plan": "Starter",
            "price": "$36/월",
            "target": "솔로 프리랜서",
            "features": "무제한 단어, 무제한 채팅, 1유저"
        },
        {
            "plan": "Advanced",
            "price": "$186/월",
            "target": "팀 (5인)",
            "features": "워크플로우(자동화) 빌더, 5유저, 2,000 워크플로우 크레딧"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Workflows: "링크드인 프로필 100개를 긁어와서 맞춤형 콜드 메일 100통을 써줘" 같은 대량 반복 작업을 자동화할 수 있습니다. (Jasper와의 차별점).',
        '무제한 단어(Starter): 유료 플랜부터는 글자 수 제한이 없어서, 하루 종일 글을 써도 추가 요금이 없습니다.',
        'GTM 특화: 영업 리드 발굴, 회사 분석, 아웃바운드 메일 작성 등 세일즈와 마케팅 실무에 특화된 템플릿이 강력합니다.',
        'Chat: ChatGPT처럼 대화하며 글을 쓸 수 있고, 웹 검색을 통해 최신 정보를 반영합니다.'
    ],
    cons = ARRAY[
        '한국어 뉘앙스: 한국어 생성이 가능하지만, 가끔 번역투가 섞일 수 있어 검수가 필요합니다.',
        '가격 상승: 예전보다 Pro 플랜 가격이 올랐고(약 5~6만 원), 워크플로우 기능은 상위 플랜에서 더 강력합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "영업 담당자",
                "badge": "Sales",
                "reason": "고객사 50곳에 각각 다른 내용으로 제안서를 보내야 할 때 (Workflows)"
            },
            {
                "target": "블로그 공장",
                "badge": "SEO",
                "reason": "SEO용 아티클을 대량으로 생산하고 싶은 분"
            },
            {
                "target": "무료 찍먹",
                "badge": "Trial",
                "reason": "Jasper와 달리 평생 무료 플랜(2,000단어)이 있어 가볍게 써보기 좋습니다"
            }
        ],
        "not_recommended": [
            {
                "target": "감성 에세이",
                "reason": "딱딱하고 효율적인 마케팅 글쓰기에 최적화되어 있어, 문학적인 글에는 맞지 않습니다"
            },
            {
                "target": "소량 사용자",
                "reason": "한 달에 글 1~2개 쓰는 정도라면 무료 플랜으로 버티거나 ChatGPT Free가 낫습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Workflows",
            "description": "드래그 앤 드롭으로 업무 자동화 파이프라인 구축"
        },
        {
            "name": "Bulk Generate",
            "description": "엑셀(CSV) 파일을 올려 수백 개의 카피 일괄 생성"
        },
        {
            "name": "Chat by Copy.ai",
            "description": "실시간 웹 검색이 가능한 대화형 에디터"
        },
        {
            "name": "Brand Voice",
            "description": "브랜드 톤앤매너 학습 (Jasper와 유사)"
        },
        {
            "name": "90+ Templates",
            "description": "인스타 캡션, 블로그 서론, 제품 설명 등 다양한 템플릿"
        },
        {
            "name": "Infobase",
            "description": "우리 회사 정보를 저장해두고 반복해서 재사용"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '단어 수 확인: 무료 플랜 2,000단어는 긴 블로그 글 2~3개면 끝납니다. 테스트용으로만 생각하세요.',
        '워크플로우 크레딧: 자동화 기능(Workflow)은 무제한이 아니라 별도의 ''크레딧''을 소모하므로 대량 작업 시 잔량을 확인해야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "compliance": "SOC2 준수: 데이터 보안 표준을 따르며, 기업용 플랜에서는 학습 데이터 배제 옵션을 제공합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Jasper",
            "description": "브랜드 보이스 관리와 콘텐츠 퀄리티가 더 중요하다면"
        },
        {
            "name": "Rytr",
            "description": "훨씬 저렴하고 가벼운 AI 글쓰기 도구를 찾는다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Copy.ai Workflows",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Copy.ai%' OR name ILIKE '%카피에이아이%';
