-- Update Claude Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '사람처럼 자연스러운 문체와 뛰어난 코딩 능력, 그리고 화면을 보고 컴퓨터를 조작하는 ''Computer Use'' 기능까지 갖춘 최상위 AI 모델.',
    website_url = 'https://claude.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "iOS", "Android", "API"],
        "target_audience": "개발자(코딩), 작가(글쓰기), 긴 문서를 다루는 연구원"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '**Claude 3.5 Sonnet** 모델 이용 가능(메시지 횟수/빈도 제한). 파일 업로드 및 분석 지원.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "Claude 3.5 Sonnet 사용(횟수 제한), 기본 기능"
        },
        {
            "plan": "Pro",
            "price": "$20/월",
            "target": "헤비 유저",
            "features": "무료 대비 5배 사용량, 트래픽 몰릴 때 우선 접속, 신기능 먼저 사용"
        },
        {
            "plan": "Team",
            "price": "$25/인/월",
            "target": "협업 조직",
            "features": "사용자당 더 많은 사용량, 중앙 관리 콘솔, 데이터 보안"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Claude 3.5 Sonnet: GPT-4o와 대등하거나 그 이상의 코딩/추론 능력을 보여주며, 특히 ''문학적 글쓰기''와 ''뉘앙스 파악''에서 평가가 좋습니다.',
        'Computer Use (최신): AI가 내 컴퓨터 화면을 보고 마우스를 움직이고 클릭하며 복잡한 작업(예: 데이터 입력, 웹 서핑)을 대신 수행하는 기능이 도입되었습니다.',
        'Artifacts: 코드를 짜거나 문서를 만들 때, 별도 창(Preview)에서 즉시 결과물을 렌더링해서 보여주는 UI가 매우 편리합니다.',
        'Projects: 자주 쓰는 문서나 코드를 ''프로젝트''에 등록해두면, AI가 해당 지식을 바탕으로 맞춤형 답변을 줍니다.'
    ],
    cons = ARRAY[
        '사용량 제한: Pro($20) 유저라도 메시지 제한이 빡빡한 편입니다(특히 긴 대화 시). "남은 메시지 0개" 경고를 자주 볼 수 있습니다.',
        '이미지 생성 부재: 달리(DALL-E) 같은 이미지 생성 기능은 자체적으로 제공하지 않습니다(분석만 가능).'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "개발자",
                "badge": "Coding",
                "reason": "\"이 코드 에러 잡아줘\" 했을 때 가장 정확하고 설명이 친절한 AI를 찾는 분"
            },
            {
                "target": "글쓰기/번역",
                "badge": "Writing",
                "reason": "기계 번역 티가 안 나는 자연스러운 한국어 번역과 윤문이 필요한 작가"
            },
            {
                "target": "긴 문서 분석",
                "badge": "Analysis",
                "reason": "책 한 권 분량의 PDF를 업로드하고 내용을 파악해야 하는 연구원"
            }
        ],
        "not_recommended": [
            {
                "target": "그림 그리기",
                "reason": "이미지 생성이 필요하다면 ChatGPT나 Midjourney를 써야 합니다"
            },
            {
                "target": "무제한 대화",
                "reason": "하루 종일 채팅을 켜두고 쓰는 헤비 유저라면 API 사용을 고려해야 합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Claude 3.5 Sonnet",
            "description": "코딩, 추론, 작문에 특화된 고성능 모델"
        },
        {
            "name": "Computer Use",
            "description": "화면 인식 및 마우스/키보드 제어 (API/Beta)"
        },
        {
            "name": "Artifacts",
            "description": "코드, 문서, 웹사이트 미리보기를 채팅창 옆에 띄워주는 기능"
        },
        {
            "name": "Projects",
            "description": "나만의 지식베이스(문서, 코드)를 업로드해두고 전용 챗봇처럼 활용"
        },
        {
            "name": "Vision",
            "description": "이미지 속 텍스트 추출이나 도표 분석 능력 탁월"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '메시지 제한: 짧은 질문을 여러 번 하기보다, 긴 질문 하나에 내용을 꽉 채워 보내는 것이 사용량 아끼는 팁입니다.',
        'Computer Use: 아직 베타 단계이며 API를 통해 주로 사용되므로, 일반 채팅창에서 바로 "내 컴퓨터 조종해줘"라고 하면 안 될 수 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training": "기본적으로 개인 사용자의 데이터는 모델 학습에 사용되지 않는 정책을 취하고 있으나, 설정에서 확인이 필요합니다. Team 플랜은 학습 배제를 명시합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "ChatGPT",
            "description": "음성 대화, 이미지 생성 등 ''종합 선물 세트'' 기능이 필요할 때"
        },
        {
            "name": "Cursor",
            "description": "Claude 모델을 사용하여 코딩에만 집중하고 싶을 때 (IDE)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Claude 3.5 Sonnet & Computer Use Demo",
            "url": "https://www.youtube.com/watch?v=ODaU8W_5G3w",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Claude%' OR name ILIKE '%클로드%';
