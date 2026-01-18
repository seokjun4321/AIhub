-- Update Haijob Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '내 자기소개서를 분석해 ''나올법한 면접 질문''을 예측해주고, 실제 면접관처럼 질문하고 피드백해 주는 AI 면접 코치.',
    website_url = 'https://www.haijob.co.kr',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Mobile App"],
        "target_audience": "면접을 앞둔 취준생, 내 자소서에서 무슨 질문이 나올지 막막한 지원자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 체험 + 건당 결제)',
    free_tier_note = '가입 시 무료 체험 1회 제공 (기본 면접 연습). 상세 피드백이나 무제한 생성은 유료',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "신규 가입자",
            "features": "1회 무료 체험, 기본 질문 연습, 간단 피드백"
        },
        {
            "plan": "Standard",
            "price": "건당 결제",
            "target": "면접 직전",
            "features": "자소서 기반 맞춤 질문 생성, 영상 분석 리포트, 다시 하기"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '자소서 기반 질문: \"지원 동기\" 같은 뻔한 질문뿐만 아니라, 내가 쓴 프로젝트 경험이나 성격 장단점을 분석해 꼬리 질문을 던집니다.',
        '답변 구조 가이드: 단순히 \"목소리가 작아요\"를 넘어, \"이 질문에는 두괄식으로 이렇게 답변하는 게 좋아요\"라고 내용적 힌트를 줍니다.',
        '영상 모의 면접: 실제 면접장처럼 카메라를 보고 말하는 연습을 하므로, 시선 처리나 표정 습관을 교정하기 좋습니다.'
    ],
    cons = ARRAY[
        '건당 결제: 월 구독이 아니라 모의면접 ''1회권'' 단위로 파는 경우가 많아, 연습을 수십 번 하고 싶은 사람에겐 비용 부담이 될 수 있습니다.',
        '피드백 깊이: AI가 텍스트 내용을 완벽히 이해하고 직무 적합성을 판단하기보다는, 발화 태도나 키워드 매칭 위주의 분석일 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "면접 초보",
                "badge": "Beginner",
                "reason": "면접장에서 무슨 말을 해야 할지 머리가 하얘지는 분"
            },
            {
                "target": "예상 질문 추출",
                "badge": "Prediction",
                "reason": "내 자소서의 약점이 어디인지, 면접관이 뭘 물어볼지 미리 알고 싶은 분"
            },
            {
                "target": "비대면 면접 대비",
                "badge": "Online",
                "reason": "화상 면접(Zoom 등)이나 AI 역량 검사를 앞두고 카메라 울렁증을 없애고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "대면 면접 분위기",
                "reason": "실제 사람 앞에서 느껴지는 압박감을 100% 재현하기는 어렵습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI 면접 질문 생성",
            "description": "자소서 내용을 분석해 개인화된 예상 질문 추출"
        },
        {
            "name": "영상 모의 면접",
            "description": "웹캠/폰카로 실제 면접 진행 (타이머 포함)"
        },
        {
            "name": "AI 피드백",
            "description": "시선 처리, 목소리 톤, 표정, 답변 내용(키워드) 분석"
        },
        {
            "name": "답변 가이드",
            "description": "질문 의도 파악 및 추천 답변 구조 제공"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '조명/각도: AI가 표정을 분석하므로, 역광을 피하고 얼굴이 밝게 나오는 곳에서 연습해야 점수가 잘 나옵니다.',
        '말하기 속도: 너무 빠르거나 느리면 감점 요인이 되니, 또박또박 말하는 연습을 하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "video_storage": "연습한 영상은 피드백 제공 후 일정 기간 뒤 삭제되거나 사용자 설정에 따라 관리됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "inFACE",
            "description": "AI 역량 검사(게임 포함) 대비에 더 특화된 도구"
        },
        {
            "name": "ViewInter",
            "description": "모바일 앱 접근성이 좋고 영상 분석이 정밀한 경쟁 서비스"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "하이자브 AI 면접 가이드",
            "url": "https://www.youtube.com/channel/UCxxxxxx",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Haijob%' OR name ILIKE '%하이자브%';
