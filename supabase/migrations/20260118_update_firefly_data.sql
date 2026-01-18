-- Update Adobe Firefly Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '저작권 문제없는 안전한 상업용 이미지·벡터·비디오 생성 AI로, 포토샵과 프리미어 프로 등 어도비 툴에 통합된 크리에이티브 엔진.',
    website_url = 'https://firefly.adobe.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Photoshop", "Illustrator", "Premiere Pro", "Express"],
        "target_audience": "저작권 걱정 없이 상업용 이미지를 써야 하는 디자이너, 마케터, 영상 편집자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Credit-based (월 크레딧 제공)',
    free_tier_note = '월 25 크레딧 제공. (이미지 생성 시 약 25장). 워터마크 없음(단, 무료 사용자는 생성 속도가 느릴 수 있음).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "체험/가벼운 용도",
            "features": "월 25 크레딧, 기능 체험 가능"
        },
        {
            "plan": "Premium",
            "price": "$4.99/월",
            "target": "디자이너",
            "features": "월 100 크레딧, 워터마크 제거, 고속 생성"
        },
        {
            "plan": "Standard (Video)",
            "price": "$9.99/월",
            "target": "영상 제작자",
            "features": "월 2,000 크레딧, Firefly Video 모델(비디오 생성) 사용"
        },
        {
            "plan": "Pro (Video)",
            "price": "$29.99/월",
            "target": "헤비 유저",
            "features": "월 7,000 크레딧, 대량 비디오/이미지 생성"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '상업적 안전성: Adobe Stock 이미지로만 학습했기 때문에, 생성된 이미지를 상업적으로 써도 저작권 소송 걱정이 없습니다. (가장 큰 강점)',
        'Firefly Video (최신): 텍스트를 입력하면 고퀄리티 영상을 만들어주는 비디오 모델이 정식 도입되었습니다. (Standard 플랜 이상)',
        '툴 통합: 포토샵의 ''생성형 채우기(Generative Fill)'', 일러스트레이터의 ''벡터 생성'' 등 기존 작업 흐름 안에서 바로 쓸 수 있습니다.',
        '텍스트 효과: 글자에 질감(털, 풍선, 빵 등)을 입히는 타이포그래피 디자인 기능이 독보적입니다.'
    ],
    cons = ARRAY[
        '실사 퀄리티: 미드저니(Midjourney)에 비해 예술적이거나 몽환적인 화풍은 다소 부족하고, 정직한 스톡 사진 느낌이 강합니다.',
        '엄격한 검열: 폭력, 선정성, 유명인 얼굴, 브랜드 로고 생성 등이 강력하게 차단됩니다.',
        '비디오 크레딧: 영상 생성은 크레딧 소모가 커서(초당 비용 높음), 무료나 저가 플랜으로는 몇 초 못 만듭니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "기업 디자이너",
                "badge": "Copyright Safe",
                "reason": "회사 홍보물에 쓸 이미지를 저작권 걱정 없이 만들고 싶은 분"
            },
            {
                "target": "포토샵 유저",
                "badge": "Integration",
                "reason": "사진 배경을 늘리거나(Generative Expand), 불필요한 사람을 지우는 작업을 자주 하는 분"
            },
            {
                "target": "영상 편집자",
                "badge": "Video",
                "reason": "프리미어 프로에서 영상 길이가 살짝 모자랄 때 ''생성형 확장''으로 늘리고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "서브컬처/애니",
                "reason": "일본 애니메이션 스타일이나 특정 작가 화풍을 따라 하는 그림은 잘 안 그려줍니다"
            },
            {
                "target": "유명인 생성",
                "reason": "\"아이유가 노래하는 모습 그려줘\" 같은 요청은 거절당합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Text to Image (Image 3)",
            "description": "고품질 포토/아트 이미지 생성 (프롬프트 준수율 향상)"
        },
        {
            "name": "Generative Fill",
            "description": "포토샵 내에서 영역을 지정해 사물 추가/삭제/배경 변경"
        },
        {
            "name": "Text to Video",
            "description": "텍스트 설명으로 1080p 영상 클립 생성 (Standard 이상)"
        },
        {
            "name": "Text to Vector",
            "description": "일러스트레이터용 벡터(SVG) 그래픽 생성"
        },
        {
            "name": "Text Effects",
            "description": "텍스트에 스타일과 질감을 입히는 타이포그래피 도구"
        },
        {
            "name": "Generative Recolor",
            "description": "벡터 아트웍의 색상 테마를 한 번에 변경"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '크레딧 소진: 비디오 생성은 이미지보다 크레딧을 훨씬 많이 씁니다. 무료 크레딧(25개)으로는 영상 1~2번 시도하면 끝날 수 있습니다.',
        '다운로드: 생성된 이미지는 웹에서 바로 다운로드하거나 ''Creative Cloud 라이브러리''에 저장해야 다른 앱에서 쓰기 편합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_source": "어도비 스톡 및 저작권 만료 콘텐츠로만 학습하여 투명성을 보장합니다.",
        "content_credentials": "생성된 파일에는 \"AI로 생성됨\"이라는 디지털 태그가 영구적으로 심어집니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Midjourney",
            "description": "저작권보다는 압도적인 예술성과 화려한 비주얼이 필요할 때"
        },
        {
            "name": "Stable Diffusion",
            "description": "내 컴퓨터에 설치해 검열 없이 자유롭게 생성하고 싶을 때"
        },
        {
            "name": "Runway",
            "description": "영상 생성 전문 툴로서 더 정교한 카메라 컨트롤이 필요할 때"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Adobe Firefly Video Model: Now Available",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Firefly%' OR name ILIKE '%파이어플라이%';
