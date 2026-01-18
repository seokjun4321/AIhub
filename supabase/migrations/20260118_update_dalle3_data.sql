-- Update DALL-E 3 Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'ChatGPT와 통합되어 대화하듯 수정이 가능하고, 텍스트(타이포그래피) 묘사 능력이 획기적으로 개선된 OpenAI의 이미지 생성 AI.',
    website_url = 'https://openai.com/dall-e-3',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web (ChatGPT)", "API", "Mobile App"],
        "target_audience": "프롬프트 엔지니어링이 어려운 초보자, 블로그/SNS 운영자, 마케터"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Paid (ChatGPT Plus 구독 또는 API 종량제)',
    free_tier_note = '**ChatGPT Free** 사용자 기준 **하루 2장** 생성 가능. (과거 Bing Image Creator와 유사한 제한적 접근).',
    pricing_plans = '[
        {
            "plan": "ChatGPT Free",
            "price": "무료",
            "target": "찍먹파",
            "features": "1일 2장 생성, 기본 해상도"
        },
        {
            "plan": "ChatGPT Plus",
            "price": "$20/월",
            "target": "헤비 유저",
            "features": "3시간당 50장 생성, 초고속 생성, 저작권 소유"
        },
        {
            "plan": "API",
            "price": "종량제",
            "target": "개발자",
            "features": "1024x1024 Standard 기준 장당 $0.040"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '대화형 생성: "고양이 그려줘" 하고 나서 "아니, 모자 씌워줘", "수채화풍으로 바꿔줘"라고 말로 수정할 수 있어 편의성이 압도적입니다.',
        '텍스트 묘사: 이미지 안에 정확한 영어 텍스트(간판, 로고 등)를 넣는 능력이 경쟁 모델(Midjourney) 대비 뛰어납니다.',
        '안전성: 폭력적이거나 선정적인 이미지는 생성 단계에서 강력하게 차단되어 기업용으로 쓰기에 안전합니다.',
        '프롬프트 자동화: 개떡같이 말해도 ChatGPT가 찰떡같이 상세 프롬프트로 변환해서 그려줍니다.'
    ],
    cons = ARRAY[
        '실사 퀄리티: 미드저니 v6나 Flux 모델에 비해 ''사진 같은 리얼함''은 다소 떨어지고, 특유의 ''CG 느낌''이 날 수 있습니다.',
        '비싼 API: API 사용 시 장당 약 50원($0.04)으로, 대량 생성 시 비용 부담이 있습니다.',
        '엄격한 검열: 저작권 있는 캐릭터나 실존 인물 묘사는 거부될 확률이 높습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "초보자",
                "badge": "Beginner",
                "reason": "복잡한 명령어(Prompt) 공부하기 싫고 채팅하듯 그림 뽑고 싶은 분"
            },
            {
                "target": "콘텐츠 제작",
                "badge": "Content",
                "reason": "블로그 썸네일, 카드뉴스 삽화 등 텍스트가 들어간 이미지가 필요한 분"
            },
            {
                "target": "아이디어 스케치",
                "badge": "Idea",
                "reason": "추상적인 개념을 빠르게 시각화해야 하는 기획자"
            }
        ],
        "not_recommended": [
            {
                "target": "초고화질 실사",
                "reason": "피부 모공까지 보이는 극실사 포토그래피가 필요하다면 Midjourney나 Stable Diffusion 추천"
            },
            {
                "target": "비율/구도 제어",
                "reason": "16:9 외에 아주 특이한 비율이나 정밀한 구도(ControlNet) 제어는 어렵습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Conversational Editing",
            "description": "채팅으로 이미지 부분 수정 및 스타일 변경"
        },
        {
            "name": "Text Rendering",
            "description": "이미지 내 정확한 텍스트/타이포그래피 삽입"
        },
        {
            "name": "Prompt Rewrite",
            "description": "짧은 요청을 구체적인 프롬프트로 자동 확장"
        },
        {
            "name": "HD Quality",
            "description": "1792x1024 등 고해상도 옵션 지원 (API)"
        },
        {
            "name": "Variations",
            "description": "생성된 이미지의 변형 버전(Variation) 즉시 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '3시간 제한: Plus 유저라도 3시간에 50장 제한이 있습니다. 무한정 뽑다가는 "잠시 후 다시 시도하세요"가 뜰 수 있습니다.',
        '저작권: DALL-E로 만든 이미지의 저작권은 사용자에게 귀속되나(유료 기준), AI 생성물에 대한 법적 보호 여부는 국가별로 다르니 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training": "OpenAI는 DALL-E 3 생성 데이터를 기본적으로 모델 학습에 사용하지 않거나, 옵트아웃 옵션을 제공합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Midjourney",
            "description": "예술적이고 회화적인 느낌이 중요하다면"
        },
        {
            "name": "Adobe Firefly",
            "description": "저작권 이슈 없는 상업용 이미지가 필요하다면"
        },
        {
            "name": "Ideogram",
            "description": "텍스트 삽입 능력이 더 뛰어난 무료 툴을 찾는다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "DALL·E 3 Available in ChatGPT",
            "url": "https://www.youtube.com/watch?v=sqQrN0d3WAG",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%DALL-E%' OR name ILIKE '%달리%';
