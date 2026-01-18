-- Update Stable Diffusion Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '내 컴퓨터에 설치해 무료로 무제한 이미지를 생성하거나, 파인튜닝으로 나만의 그림체를 만들 수 있는 가장 강력한 오픈소스 AI 모델.',
    website_url = 'https://stability.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": "partial",
        "login_required": "optional",
        "platforms": ["Local(PC)", "Web(DreamStudio)", "API"],
        "target_audience": "고사양 GPU 보유자, AI 그림 연구자, 게임/웹툰 개발자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Open Source (무료) / API (유료)',
    free_tier_note = '로컬 설치(Local Install) 시 모델 다운로드 및 생성 **완전 무료 & 무제한**. (단, 고사양 NVIDIA 그래픽카드 필요).',
    pricing_plans = '[
        {
            "plan": "Local (Open Source)",
            "price": "무료",
            "target": "개발자/헤비유저",
            "features": "평생 무료, 무제한 생성, 검열 없음, SD 3.5 사용 가능"
        },
        {
            "plan": "DreamStudio (Web)",
            "price": "$10/1000Cr",
            "target": "일반 사용자",
            "features": "설치 불필요, 1,000 크레딧(약 500장+), 쉽고 빠름"
        },
        {
            "plan": "API (Ultra/Core)",
            "price": "종량제",
            "target": "기업/개발자",
            "features": "최신 모델(Ultra) API 호출, 상업적 라이선스(매출 $1M↑)"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '무한한 자유도: SD 3.5 (Large/Medium) 최신 모델을 내 PC에 깔면, 인터넷 없이도 검열 없는 이미지를 마음껏 뽑을 수 있습니다.',
        '커스터마이징(LoRA): 특정 캐릭터, 그림체, 의상을 학습시킨 ''LoRA'' 파일을 추가해 내가 원하는 스타일을 완벽하게 재현할 수 있습니다.',
        'ControlNet: 사람의 포즈(졸라맨)나 스케치 선을 그대로 따서 구도를 잡는 정교한 제어가 가능합니다. (타 툴 대비 압도적 우위)',
        '생태계: Civitai 등 커뮤니티에서 전 세계 유저가 만든 수만 개의 모델과 소스를 공유받을 수 있습니다.'
    ],
    cons = ARRAY[
        '진입 장벽: ''WebUI''나 ''ComfyUI''를 설치하고 세팅하는 과정이 초보자에게는 매우 어렵고 복잡합니다.',
        '하드웨어 요구: 최신 모델(SD 3.5 Large)을 돌리려면 고가의 NVIDIA 그래픽카드(VRAM 12GB 이상 권장)가 필요합니다.',
        '라이선스: 개인/소기업은 무료지만, 연 매출 100만 달러 이상 기업은 ''Enterprise License''를 별도 계약해야 합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "웹툰/게임 작가",
                "badge": "Custom",
                "reason": "내 그림체를 AI에 학습시켜 배경이나 엑스트라 작업을 자동화하고 싶은 분"
            },
            {
                "target": "고사양 PC 보유자",
                "badge": "Local",
                "reason": "집에 RTX 4070 이상 그래픽카드가 놀고 있는 분"
            },
            {
                "target": "성인/자유 창작",
                "badge": "Uncensored",
                "reason": "검열 필터 때문에 막히는 프롬프트 없이 자유롭게 생성하고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "컴맹",
                "reason": "설치하다가 에러 나면 해결하기 힘든 분 (DreamStudio나 Midjourney 권장)"
            },
            {
                "target": "저사양 노트북",
                "reason": "그래픽카드가 없는 일반 노트북에서는 거의 돌아가지 않거나 매우 느립니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Stable Diffusion 3.5",
            "description": "텍스트 이해력과 이미지 품질이 대폭 향상된 최신 모델"
        },
        {
            "name": "LoRA & Checkpoint",
            "description": "수천 가지 그림체와 캐릭터 모델 교체 사용"
        },
        {
            "name": "Inpainting/Outpainting",
            "description": "이미지의 일부만 수정하거나 바깥 영역 확장"
        },
        {
            "name": "ControlNet",
            "description": "포즈, 깊이(Depth), 선화(Canny) 정보를 통한 정밀 구도 제어"
        },
        {
            "name": "ComfyUI",
            "description": "노드(Node) 방식으로 복잡한 생성 워크플로우 설계"
        },
        {
            "name": "Upscaling",
            "description": "저해상도 이미지를 4K 이상으로 깨짐 없이 확대"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '모델 버전: SD 1.5, SDXL, SD 3.5는 서로 호환되지 않는 플러그인이 많으니, 다운로드할 때 버전을 꼭 확인하세요.',
        'DreamStudio: 웹사이트(DreamStudio)는 유료 크레딧 기반입니다. "무료라더니 왜 돈 내래?" 하지 마시고, 무료를 원하면 ''WebUI'' 설치법을 검색하세요.',
        '상업적 이용: 커뮤니티에서 받은 모델(Checkpoint) 중에는 ''상업적 이용 불가''인 것도 있으니 라이선스 표기를 꼭 봐야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "local": "내 컴퓨터에서 돌리는 로컬 버전은 어떤 이미지를 만들어도 외부로 유출되지 않아 프라이버시가 가장 강력합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Midjourney",
            "description": "설치 귀찮고 그냥 가장 예쁜 그림을 원한다면"
        },
        {
            "name": "DALL-E 3",
            "description": "말귀를 가장 잘 알아듣고 대화하듯 수정하고 싶다면"
        },
        {
            "name": "Leonardo.ai",
            "description": "스테이블 디퓨전 기반이지만 웹에서 쉽게 쓰고 싶다면 (무료 크레딧 제공)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Stable Diffusion 3.5",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Stable Diffusion%' OR name ILIKE '%스테이블 디퓨전%';
