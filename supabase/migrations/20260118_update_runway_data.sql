-- Update Runway Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '할리우드급 영상 물리 엔진을 탑재한 최신 ''Gen-4.5'' 모델로, 텍스트와 이미지를 영화 같은 비디오로 바꿔주는 AI 영상 생성의 선두주자.',
    website_url = 'https://runwayml.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web", "iOS", "API", "Adobe Firefly"],
        "target_audience": "영상 크리에이터, 영화/광고 제작자, 모션 그래픽 디자이너, VFX 전문가"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '가입 시 125 크레딧 1회 제공 (약 5초 분량의 Gen-4.5 영상 생성 가능). 워터마크 포함, 해상도 제한 (월 리필 없음)',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "찍먹파",
            "features": "1회성 125 크레딧(리필 X), 워터마크 있음, 맛보기용"
        },
        {
            "plan": "Standard",
            "price": "$12/월",
            "target": "취미/초급",
            "features": "월 625 크레딧, 워터마크 제거, 1080p 업스케일링"
        },
        {
            "plan": "Pro",
            "price": "$28/월",
            "target": "전문가",
            "features": "월 2,250 크레딧, ProRes 코덱 및 PNG 시퀀스 내보내기 지원"
        },
        {
            "plan": "Unlimited",
            "price": "$76/월",
            "target": "헤비 유저",
            "features": "Explore 모드 무제한 생성(속도 제한), 월 2,250 고속 크레딧"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Gen-4.5의 물리 엔진: 최신 모델(Gen-4.5)은 사물의 무게감, 유체 역학(물 튀김 등), 조명 변화를 실제 촬영본처럼 정교하게 구현합니다.',
        '정밀한 카메라 제어: ''Director Mode''를 통해 줌, 팬, 틸트 등 카메라 무빙의 방향과 속도를 수치로 미세 조정할 수 있습니다.',
        '다양한 제어 도구: 단순 프롬프트 외에 ''Motion Brush''(특정 영역만 움직이게 하기), ''Act-One''(표정 연기 입히기) 등 전문가용 제어 기능이 독보적입니다.',
        'Adobe 연동: 2026년부터 Adobe Firefly와 파트너십을 맺어, 프리미어 프로나 Firefly 웹에서도 Runway 모델을 만날 수 있습니다.'
    ],
    cons = ARRAY[
        '비싼 크레딧 소모: 최신 Gen-4.5 모델은 초당 25 크레딧을 소모합니다. Standard 플랜(월 625 크레딧)으로는 한 달에 고작 25초 분량만 만들 수 있어 가성비가 떨어집니다.',
        'Android 앱 부재: iOS 앱은 있지만, 공식 안드로이드 앱은 아직 없습니다. (유사품 주의)',
        '무료 리필 없음: 무료 플랜은 매달 충전되지 않고 가입 시 딱 한 번만 줍니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "전문 영상 제작자",
                "badge": "Motion Brush",
                "reason": "정확한 카메라 워킹과 특정 사물의 움직임을 집요하게 컨트롤해야 하는 분"
            },
            {
                "target": "영화/광고 콘티 제작",
                "badge": "Pre-viz",
                "reason": "촬영 전 시안(Pre-viz)을 고퀄리티로 빠르게 뽑아봐야 하는 감독님"
            },
            {
                "target": "캐릭터 애니메이팅",
                "badge": "Act-One",
                "reason": "정지된 인물 사진에 내가 지은 표정과 목소리를 입혀 연기시키고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "가성비 중시",
                "reason": "\"그냥 움직이는 짤방 많이 만들고 싶다\"면 Luma Dream Machine이나 Kling AI가 더 저렴할 수 있습니다"
            },
            {
                "target": "안드로이드 유저",
                "reason": "모바일로 주로 작업하신다면 웹사이트로 접속해야 해서 불편합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Gen-4.5 Video",
            "description": "현존 최고 수준의 물리 구현과 일관성을 보여주는 플래그십 모델 (초당 25 크레딧)"
        },
        {
            "name": "Gen-4 Turbo",
            "description": "화질은 조금 낮추고 속도는 높인 가성비 모델 (초당 5 크레딧)"
        },
        {
            "name": "Motion Brush",
            "description": "영상 내 특정 부분(예: 구름, 물결)만 칠해서 움직임을 부여"
        },
        {
            "name": "Act-One",
            "description": "내 웹캠 영상의 표정과 연기를 애니메이션/이미지 캐릭터에 그대로 전송"
        },
        {
            "name": "Advanced Camera Control",
            "description": "줌, 롤, 팬, 틸트 등의 수치를 입력해 정확한 카메라 무빙 구현"
        },
        {
            "name": "Custom Voice",
            "description": "텍스트를 입력하면 생성된 영상에 맞는 성우 목소리(Lip Sync 포함) 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '모델 선택 주의: 기본 설정이 비싼 ''Gen-4.5''로 되어 있을 수 있습니다. 단순 테스트라면 ''Gen-4 Turbo''나 ''Gen-3 Alpha''로 변경해야 크레딧을 아낍니다. (5배 차이)',
        '안드로이드 앱 주의: 구글 플레이스토어의 \"RunAway\"는 공식 앱이 아닙니다. 반드시 모바일 웹(Chrome 등)을 이용하세요.',
        '무료 크레딧 소진: 처음에 주는 125 크레딧은 Gen-4.5 기준 단 ''5초''면 사라집니다. 신중하게 프롬프트를 작성하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "기본적으로 사용자가 생성한 공개 영상은 모델 개선에 활용될 수 있습니다.",
        "enterprise_security": "엔터프라이즈 플랜 사용 시 데이터 학습 배제 및 보안 규정을 준수합니다.",
        "privacy_protection": "생성된 영상에는 AI로 제작되었음을 알리는 메타데이터(C2PA)가 포함됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Luma Dream Machine",
            "description": "첫 프레임과 끝 프레임을 지정해 영상을 만드는 기능이 강력하며 무료 제공량이 좀 더 후함"
        },
        {
            "name": "Kling AI",
            "description": "중국발 고성능 모델로, 인물 움직임이 매우 자연스럽고 생성 시간이 긺"
        },
        {
            "name": "Sora (OpenAI)",
            "description": "ChatGPT Plus 사용자라면 별도 가입 없이 바로 쓸 수 있는 접근성"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Gen-4: A new standard for video generation",
            "url": "https://www.youtube.com/watch?v=70W2k1i_X5c",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Runway%' OR name ILIKE '%런웨이%';
