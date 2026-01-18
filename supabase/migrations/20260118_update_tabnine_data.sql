-- Update Tabnine Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '내 코드를 외부로 유출하지 않고 로컬/프라이빗 환경에서 안전하게 사용하는, 보안에 특화된 AI 코딩 어시스턴트.',
    website_url = 'https://www.tabnine.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["VS Code", "IntelliJ", "Eclipse", "Visual Studio"],
        "target_audience": "금융권, 보안이 중요한 기업 개발자, 폐쇄망 환경 사용자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '**Basic 플랜** 무료. (짧은 코드 자동 완성만 지원. 전체 라인 완성이나 채팅 기능은 제한됨).',
    pricing_plans = '[
        {
            "plan": "Basic (Free)",
            "price": "무료",
            "target": "개인",
            "features": "짧은 코드 자동 완성(2-3 단어), 커뮤니티 지원"
        },
        {
            "plan": "Pro",
            "price": "$19/월",
            "target": "전문 개발자",
            "features": "전체 라인/함수 완성, Tabnine Chat, 자연어→코드 변환"
        },
        {
            "plan": "Enterprise",
            "price": "별도 문의",
            "target": "기업",
            "features": "사내 코드 학습(Fine-tuning), 온프레미스(사내 구축), SSO"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '프라이버시(Privacy): 코드가 학습 데이터로 쓰이지 않으며, 아예 외부 서버로 나가지 않게(Local mode) 설정할 수도 있습니다. 보안이 생명인 기업에 최적입니다.',
        '개인화(Personalization): 내 프로젝트의 코딩 스타일과 변수 명명 규칙을 학습해, 내가 짠 것 같은 코드를 추천해 줍니다.',
        'Switchable Models: Tabnine 고유 모델뿐만 아니라, 상황에 따라 다른 모델을 선택하거나 기업 전용 모델을 연결할 수 있습니다.',
        '호환성: VS Code뿐만 아니라 Eclipse, Android Studio 같은 구형/특수 IDE도 폭넓게 지원합니다.'
    ],
    cons = ARRAY[
        '지능: 순수 추론 능력이나 창의적인 해결책 제시는 GPT-4o 기반의 GitHub Copilot보다 다소 보수적일 수 있습니다.',
        '가격: 개인용 Pro 플랜($19)이 GitHub Copilot($10)보다 비쌉니다. (보안 비용).'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "금융/보안 기업",
                "badge": "Security",
                "reason": "사내 코드가 외부 AI 서버로 전송되는 것이 법적으로 금지된 팀"
            },
            {
                "target": "오프라인 코딩",
                "badge": "Offline",
                "reason": "비행기 안이나 인터넷이 없는 환경에서도 AI 자동 완성을 쓰고 싶은 분 (Local Model)"
            },
            {
                "target": "레거시 IDE",
                "badge": "Compatibility",
                "reason": "Eclipse 등을 써야 해서 Copilot 설치가 안 되는 환경"
            }
        ],
        "not_recommended": [
            {
                "target": "최신 기능 중시",
                "reason": "Copilot Workspace처럼 \"알아서 다 해주는\" 최신 에이전트 기능이 필요하다면 부족할 수 있습니다"
            },
            {
                "target": "가성비",
                "reason": "개인 개발자라면 $10짜리 GitHub Copilot이 더 저렴하고 강력할 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Whole Line Completion",
            "description": "문맥을 파악해 줄 전체 자동 완성 (Pro)"
        },
        {
            "name": "Tabnine Chat",
            "description": "내 프로젝트 코드를 참조하여 질문에 답변하는 챗봇"
        },
        {
            "name": "Private Codebase Training",
            "description": "우리 회사 코드만 학습시켜 맞춤형 추천 (Enterprise)"
        },
        {
            "name": "Local Mode",
            "description": "인터넷 연결 없이 로컬 머신 자원으로만 작동 가능"
        },
        {
            "name": "Zero Data Retention",
            "description": "코드를 서버에 저장하지 않는 보안 정책"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '무료의 한계: Free 버전은 "Tab 누르면 완성"되는 짧은 단어 수준이라, Copilot급의 성능을 기대하면 실망합니다. 제대로 쓰려면 Pro가 필요합니다.',
        '리소스 점유: 로컬 모델 사용 시 내 컴퓨터의 메모리/CPU를 사용하므로 사양이 낮으면 버벅거릴 수 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "retention": "Tabnine은 사용자의 코드를 저장하거나 제3자와 공유하지 않음을 핵심 가치로 내세웁니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "GitHub Copilot for Business",
            "description": "보안 설정을 강화하여 사용하는 방법"
        },
        {
            "name": "CodeLlama (Ollama)",
            "description": "아예 오픈소스 모델을 로컬에 직접 설치해서 쓰는 방법 (무료)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Tabnine: AI Assistant for Software Developers",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Tabnine%' OR name ILIKE '%탭나인%';
