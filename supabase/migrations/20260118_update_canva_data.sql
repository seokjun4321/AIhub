-- Update Canva Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '''매직 스튜디오(Magic Studio)''라는 강력한 AI 제품군을 탑재하여, 디자인·영상·문서를 전문가 수준으로 원클릭 제작하는 올인원 디자인 툴.',
    website_url = 'https://www.canva.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "iOS", "Android", "Windows", "macOS"],
        "target_audience": "디자이너가 없는 마케터, 소상공인, 카드뉴스 만드는 대학생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '수천 개의 무료 템플릿, **Magic Media(이미지/비디오) 일일 50회**, Magic Write 일일 50회. (Pro 전용 소스는 사용 불가).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "개인/학생",
            "features": "AI 생성 50회/일, 무료 템플릿만 사용, 배경 제거 불가"
        },
        {
            "plan": "Pro",
            "price": "$12.99/월",
            "target": "프리랜서",
            "features": "AI 생성 500회/일, 배경 제거, 매직 리사이즈, 프리미엄 소스"
        },
        {
            "plan": "Teams",
            "price": "$14.99/월",
            "target": "팀 (2인↑)",
            "features": "브랜드 키트 공유, 실시간 협업, Pro 기능 모두 포함"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Magic Studio: 이미지 생성뿐만 아니라, 영상 생성(Runway 기반), 배경 지우기, 디자인 크기 변경(Resize) 등이 한 곳에 모여 있어 작업 속도가 비약적으로 빠릅니다.',
        'Magic Switch: 인스타그램용으로 만든 게시물을 클릭 한 번으로 PPT나 블로그 배너 사이즈로 자동 변환해 줍니다.',
        'Magic Edit: 포토샵 없이도 사진 속 물체를 텍스트 명령("꽃을 풍선으로 바꿔줘")만으로 자연스럽게 수정합니다.',
        '한글 친화적: 한국 감성의 템플릿과 예쁜 한글 폰트가 매우 많아, 국내 마케팅 용도로 쓰기에 최적입니다.'
    ],
    cons = ARRAY[
        'Pro 필수 기능: 가장 많이 쓰는 **''배경 제거(누끼 따기)''**나 **''크기 변경''** 기능이 유료(Pro)에 묶여 있어 결국 결제하게 됩니다.',
        '디자인 중복: 템플릿 기반이다 보니, 남들과 비슷한 느낌의 디자인이 나올 수 있습니다.',
        '레이어 한계: 전문 툴(Illustrator)처럼 정교한 벡터 패스 작업이나 레이어 합성은 어렵습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "SNS 마케터",
                "badge": "Marketing",
                "reason": "인스타, 유튜브 썸네일, 릴스 커버를 매일 만들어야 하는 분"
            },
            {
                "target": "자영업자",
                "badge": "SMB",
                "reason": "메뉴판, 전단지, 배너를 디자이너 없이 직접 예쁘게 만들고 싶은 사장님"
            },
            {
                "target": "발표자",
                "badge": "Presentation",
                "reason": "PPT 디자인할 시간이 없어서 \"내용만 넣으면 완성되는\" 템플릿이 필요한 분 (Magic Design)"
            }
        ],
        "not_recommended": [
            {
                "target": "로고 디자이너",
                "reason": "캔바 템플릿으로 만든 로고는 상표권 등록이 불가능할 수 있어 주의해야 합니다"
            },
            {
                "target": "인쇄 전문가",
                "reason": "초고해상도 오프셋 인쇄 작업에는 일러스트레이터가 더 적합합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Magic Media",
            "description": "텍스트를 이미지나 비디오로 변환 (DALL-E, Runway 등 연동)"
        },
        {
            "name": "Magic Eraser/Edit",
            "description": "불필요한 사물 지우기 및 다른 사물로 교체"
        },
        {
            "name": "Magic Switch",
            "description": "디자인 크기 및 포맷 자동 변환 (인스타 → PPT)"
        },
        {
            "name": "Background Remover",
            "description": "원클릭 배경 제거 (Pro)"
        },
        {
            "name": "Magic Write",
            "description": "문구 추천, 요약, 말투 변경 (브랜드 보이스 적용)"
        },
        {
            "name": "Brand Kit",
            "description": "로고, 색상, 폰트를 저장해두고 팀원과 일관된 디자인 공유 (Pro)"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '상표권: 캔바의 무료/유료 요소(Element)를 사용해 만든 로고는 **상표권 등록이 거절**될 수 있습니다. 상업적 이용은 가능하나 독점권은 없습니다.',
        '해지 타이밍: 30일 무료 체험(Trial)을 많이 제공하는데, 잊어버리면 자동 결제되니 달력에 표시해두세요.',
        '이미지 횟수: 무료 사용자도 AI 그림을 그릴 수 있지만 하루 50회 제한이 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training": "사용자의 개인 데이터는 기본적으로 AI 학습에 사용되지 않도록 설정(Opt-out)할 수 있는 옵션을 제공합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Adobe Express",
            "description": "캔바와 유사하지만 어도비 생태계(포토샵)와 연동이 필요할 때"
        },
        {
            "name": "Miricanvas",
            "description": "한국 토종 툴로, 국내 인쇄소 연동이나 한국적 소스가 더 중요하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Meet Magic Studio: The Power of AI in Canva",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Canva%' OR name ILIKE '%캔바%';
