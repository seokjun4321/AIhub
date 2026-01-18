-- Update Synthesia Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '카메라나 마이크 없이 텍스트만 입력하면, 실제 사람 같은 AI 아바타가 자연스럽게 말하는 영상을 만들어주는 AI 비디오 생성 플랫폼.',
    website_url = 'https://www.synthesia.io',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "사내 교육(L&D) 담당자, 마케팅 영상 제작자, 세일즈팀"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Subscription (구독형)',
    free_tier_note = '가입 시 맛보기용 무료 영상 생성 가능 (약 3분/월, 워터마크 포함, 기능 제한).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "체험용",
            "features": "월 3분 영상, 기본 아바타, 워터마크 있음"
        },
        {
            "plan": "Starter",
            "price": "$22/월",
            "target": "개인/소상공인",
            "features": "월 10분 영상, 125+ 아바타, 워터마크 제거"
        },
        {
            "plan": "Creator",
            "price": "$67/월",
            "target": "전문 제작자",
            "features": "월 30분 영상, 180+ 아바타, 프리미엄 보이스"
        },
        {
            "plan": "Enterprise",
            "price": "별도 문의",
            "target": "기업",
            "features": "무제한 영상, 맞춤형 아바타, 보안/협업 기능"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Expressive Avatars: AI 아바타가 단순히 입만 뻥긋거리는 게 아니라, "기쁨", "슬픔" 같은 감정을 표현하고 손짓(제스처)까지 자연스럽게 구사합니다.',
        '다국어 제작: 한국어로 만든 영상을 클릭 한 번으로 영어, 일본어, 중국어 등 140개 언어로 번역 및 더빙할 수 있습니다.',
        'Personal Avatar: 웹캠으로 나를 5분만 찍으면, 내 얼굴과 목소리를 똑같이 따라 하는 ''디지털 트윈'' 아바타를 만들 수 있습니다. (유료 애드온)',
        '쉬운 편집: PPT 만들듯이 슬라이드에 텍스트를 넣고 배경을 바꾸면 영상이 완성되므로 영상 편집 기술이 필요 없습니다.'
    ],
    cons = ARRAY[
        '분량 제한: Starter 플랜($22/월)도 월 10분(또는 120분/년)으로 생성 시간이 넉넉하지 않아, 긴 교육 영상을 많이 만들기엔 부족할 수 있습니다.',
        '크레딧 이월 불가: 매월 주어지는 영상 생성 시간(분)은 다음 달로 이월되지 않는 경우가 일반적입니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "사내 교육 영상",
                "badge": "L&D",
                "reason": "직원 교육용 매뉴얼 영상을 매번 새로 찍기 힘든 인사팀"
            },
            {
                "target": "글로벌 마케팅",
                "badge": "Global",
                "reason": "제품 소개 영상을 10개 국어로 빠르게 배포해야 하는 마케터"
            },
            {
                "target": "얼굴 노출 부담",
                "badge": "Privacy",
                "reason": "유튜버가 되고 싶지만 본인 얼굴을 공개하기 꺼려지는 분"
            }
        ],
        "not_recommended": [
            {
                "target": "라이브 방송",
                "reason": "실시간으로 대화하거나 스트리밍하는 용도가 아닙니다 (렌더링 시간 필요)"
            },
            {
                "target": "감성 브이로그",
                "reason": "사람의 미묘한 감성이나 현장감이 중요한 영상에는 아직 AI 티가 날 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Text-to-Video",
            "description": "대본 입력 시 AI 아바타가 말하는 영상 자동 생성"
        },
        {
            "name": "140+ AI Avatars",
            "description": "다양한 인종, 연령, 복장의 아바타 라이브러리"
        },
        {
            "name": "AI Voice Cloning",
            "description": "내 목소리를 복제하여 텍스트만 치면 내 목소리로 더빙"
        },
        {
            "name": "Micro-Gestures",
            "description": "고개 끄덕임, 눈썹 움직임 등 미세한 제스처 구현"
        },
        {
            "name": "AI Script Assistant",
            "description": "주제만 주면 영상 대본을 AI가 써주는 기능"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        'Starter vs Creator: 월 10분(Starter)은 생각보다 짧습니다. 영상 길이가 2~3분짜리라면 한 달에 3~4개밖에 못 만드니 **Creator($67)** 플랜을 고려하세요.',
        'Personal Avatar 비용: 나만의 아바타를 만드는 건 별도 비용(연 $1,000 수준 등)이 들 수 있으니 플랜 상세를 확인해야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "ethics": "딥페이크 악용 방지를 위해 유명인이나 동의 없는 인물의 아바타 생성은 엄격히 금지되며, 모든 콘텐츠는 모니터링됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "HeyGen",
            "description": "입모양 싱크(Lip-sync) 기술이 뛰어나고 영상 번역 기능이 강력함"
        },
        {
            "name": "D-ID",
            "description": "사진 한 장으로 말하는 영상을 만들고 싶다면 (가성비 우수)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Synthesia 2.0",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Synthesia%' OR name ILIKE '%신디시아%';
