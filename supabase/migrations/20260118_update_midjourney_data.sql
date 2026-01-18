-- Update Midjourney Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '현존하는 AI 중 가장 예술적이고 심미적인 고퀄리티 이미지를 생성하며, 이제는 디스코드 없이 웹에서도 편하게 쓰는 최고의 이미지 AI.',
    website_url = 'https://www.midjourney.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web (Alpha/Beta)", "Discord"],
        "target_audience": "디자이너, 아티스트, 고퀄리티 삽화가 필요한 모든 창작자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Subscription (유료 전용)',
    free_tier_note = '현재 상시 **무료 플랜 없음**. (결제해야 생성 가능).',
    pricing_plans = '[
        {
            "plan": "Basic",
            "price": "$10/월",
            "target": "입문자",
            "features": "월 3.3시간(약 200장) 생성, 개인 갤러리 접근"
        },
        {
            "plan": "Standard",
            "price": "$30/월",
            "target": "일반 사용자",
            "features": "월 15시간(약 900장), Relax 모드(무제한 느린 생성) 가능"
        },
        {
            "plan": "Pro",
            "price": "$60/월",
            "target": "헤비 유저",
            "features": "월 30시간, Stealth 모드(비공개), 동시 작업 12개"
        },
        {
            "plan": "Mega",
            "price": "$120/월",
            "target": "기업/팀",
            "features": "월 60시간, Pro 혜택 포함"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적 퀄리티: 별다른 명령어 없이 "아름다운 풍경"이라고만 쳐도 미술관에 걸릴 법한 예술적인 그림을 뽑아줍니다. (미적 감각 1위).',
        'Web Creation: 그동안 디스코드 사용이 어려워 진입장벽이 있었으나, **공식 웹사이트에서 바로 생성하고 편집**하는 기능이 열려 매우 편리해졌습니다. (2024/25 대규모 업데이트).',
        '다양한 기능: Zoom Out(배경 확장), Pan(옆으로 늘리기), Vary(부분 수정), Style Reference(그림체 따라하기) 등 편집 기능이 강력합니다.',
        'v6/v7 모델: 최신 모델은 실사(Photo-realism)와 텍스트 묘사 능력이 비약적으로 발전했습니다.'
    ],
    cons = ARRAY[
        '유료 필수: 무료 찍먹이 불가능해 무조건 $10을 내야 시작할 수 있습니다.',
        '공개 기본: Basic과 Standard 플랜은 내가 만든 이미지가 미드저니 갤러리에 **전체 공개**됩니다. 비공개(Stealth)하려면 월 $60 Pro 플랜을 써야 합니다.',
        '영어 프롬프트: 한글을 알아듣지 못하므로, ChatGPT나 번역기를 써서 영어로 입력해야 합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "디자이너/아티스트",
                "badge": "Art",
                "reason": "영감이 필요하거나 시안 작업을 빠르게 끝내야 하는 분"
            },
            {
                "target": "고퀄리티 실사",
                "badge": "Visual",
                "reason": "진짜 사진 같은 인물, 제품 이미지가 필요한 분"
            },
            {
                "target": "스타일 일관성",
                "badge": "Style",
                "reason": "''캐릭터 레퍼런스(Cref)'' 기능을 써서 동일한 캐릭터가 나오는 동화책 등을 만들고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "정확한 텍스트",
                "reason": "이미지 안에 복잡한 글자를 정확히 넣어야 한다면 DALL-E 3나 Ideogram이 더 낫습니다"
            },
            {
                "target": "비공개 필수",
                "reason": "저렴한 가격에 비공개 생성을 원한다면 Stable Diffusion(로컬)이 답입니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Text to Image",
            "description": "텍스트 명령어로 고해상도 이미지 생성"
        },
        {
            "name": "Web Interface",
            "description": "디스코드 없이 웹사이트에서 직관적인 생성 및 관리"
        },
        {
            "name": "Style Reference (Sref)",
            "description": "참고 이미지의 화풍/색감을 그대로 복사해 적용"
        },
        {
            "name": "Character Reference (Cref)",
            "description": "캐릭터의 얼굴과 특징을 유지하며 다른 포즈 생성"
        },
        {
            "name": "Inpainting (Vary Region)",
            "description": "이미지의 특정 부분만 선택해 수정"
        },
        {
            "name": "Relax Mode",
            "description": "(Standard 이상) 생성 속도는 느리지만 무제한으로 공짜 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        'Fast 시간 소진: Basic($10) 플랜은 200장 뽑으면 끝입니다. 연습을 많이 하고 싶다면 무제한(Relax) 모드가 있는 **Standard($30)**를 추천합니다.',
        '자동 결제: 구독 취소를 하지 않으면 매달 자동 결제됩니다. 안 쓸 때는 꼭 ''Cancel Plan''을 하세요.',
        '저작권: 유료 회원이 만든 이미지는 상업적 이용이 가능합니다. (단, AI 저작권법은 국가별로 다르니 확인 필요).'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "visibility": "Pro 플랜 미만 사용자의 이미지는 미드저니 웹사이트 ''Explore'' 탭에서 누구나 볼 수 있고 검색할 수 있습니다. 기밀 유지가 필요하면 주의하세요."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "DALL-E 3",
            "description": "대화하듯 편하게 수정하고 싶고 한글을 쓰고 싶다면"
        },
        {
            "name": "Stable Diffusion",
            "description": "검열 없이 자유롭게, 내 컴퓨터에서 공짜로 돌리고 싶다면"
        },
        {
            "name": "Adobe Firefly",
            "description": "저작권 문제없는 안전한 상업용 소스가 필요하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Midjourney Web: Creation & Editing",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Midjourney%' OR name ILIKE '%미드저니%';
