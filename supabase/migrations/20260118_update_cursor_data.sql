-- Update Cursor Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'VS Code를 기반으로 만든 AI 네이티브 에디터로, 프로젝트 전체를 이해하고 여러 파일을 동시에 수정하는 ''Composer'' 기능이 핵심.',
    website_url = 'https://cursor.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Windows", "macOS", "Linux"],
        "target_audience": "현업 개발자(주니어~시니어), 풀스택 엔지니어, 생산성을 극대화하려는 코딩 입문자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = 'Hobby Plan: 2주간 Pro 기능 체험 가능, 이후에는 월 2,000회 Tab(자동완성) 및 일반 속도 챗봇 사용 가능',
    pricing_plans = '[
        {
            "plan": "Hobby",
            "price": "무료",
            "target": "입문자/찍먹파",
            "features": "기본 AI 챗, Tab 2,000회, Pro 2주 체험"
        },
        {
            "plan": "Pro",
            "price": "$20/월",
            "target": "현업 개발자",
            "features": "Tab 무제한, 고속 프리미엄 모델(Claude/GPT) 500회, Composer 사용"
        },
        {
            "plan": "Ultra",
            "price": "$200/월",
            "target": "헤비 유저",
            "features": "일일 사용량 제한 거의 없음, 신기능(Alpha) 우선 접근"
        },
        {
            "plan": "Business",
            "price": "$40/인/월",
            "target": "팀/기업",
            "features": "중앙 결제(Admin), SSO, 데이터 프라이버시(Zero Copy) 보장"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Composer (에이전트): "Ctrl+I" 한 번으로 단순 채팅을 넘어, 여러 개의 파일을 동시에 생성·수정·삭제하며 프로젝트 전체를 리팩토링합니다.',
        'Codebase Context: @Codebase 태그를 쓰면 프로젝트의 모든 파일과 문서를 읽고 문맥에 맞는 정확한 답변을 줍니다(RAG 성능 최상위).',
        'Cursor Tab: 단순 한 줄 완성이 아니라, 커서의 다음 이동 위치와 여러 줄의 코드 수정 내역을 미리 예측해 ''탭'' 한 번으로 작성합니다.',
        'VS Code 호환: VS Code의 확장 프로그램(Extension), 테마, 단축키를 그대로 가져와 쓸 수 있어 이질감이 없습니다.',
        '최신 모델 통합: Claude 3.5(혹은 최신) Sonnet, GPT-4o 등 당대 최고의 코딩 모델을 골라 쓸 수 있습니다.'
    ],
    cons = ARRAY[
        '리소스 소모: 대형 프로젝트 인덱싱 시 초반에 메모리와 CPU 점유율이 높아질 수 있습니다.',
        '비싼 Ultra 플랜: 헤비 유저를 위한 무제한급 플랜이 월 $200로, 경쟁사 대비 가격 장벽이 있는 편입니다.',
        '의존성 심화: ''Tab'' 기능이 너무 강력해서, 끄고 나면 코딩 역체감이 심하게 들 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "풀스택 개발자",
                "badge": "Composer",
                "reason": "프론트엔드와 백엔드 코드를 동시에 수정해야 하는 경우"
            },
            {
                "target": "레거시 코드 분석",
                "badge": "@Codebase",
                "reason": "남이 짠 복잡한 코드를 @Codebase로 질문하며 파악해야 하는 분"
            },
            {
                "target": "VS Code 사용자",
                "badge": "호환성",
                "reason": "기존 환경을 버리지 않고 AI 기능만 ''플러스'' 하고 싶은 분"
            },
            {
                "target": "터미널/CLI 덕후",
                "badge": "CLI Agent",
                "reason": "2026년 1월 추가된 CLI Agent 모드로 터미널에서도 AI 도움을 받고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "JetBrains(IntelliJ) 찐팬",
                "reason": "단축키나 UI 철학이 달라서 적응이 힘들 수 있습니다 (이 경우 IntelliJ AI Assistant나 Copilot 권장)"
            },
            {
                "target": "오프라인 코딩",
                "reason": "인터넷 연결 없이는 핵심 AI 기능(Tab, Chat)이 작동하지 않습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Cursor Composer",
            "description": "다중 파일 생성/편집 및 전체 앱 구조 설계 (Agent Mode)"
        },
        {
            "name": "Cursor Tab",
            "description": "차세대 AI 자동완성 (커서 위치 예측 + 멀티 라인 수정)"
        },
        {
            "name": "@Codebase Chat",
            "description": "내 전체 프로젝트 코드를 벡터로 인덱싱해 문맥 기반 답변"
        },
        {
            "name": "MCP (Model Context Protocol)",
            "description": "외부 도구 및 데이터 소스를 연결하는 표준 프로토콜 지원 (2026.01 최신)"
        },
        {
            "name": "CLI Agent / Plan Mode",
            "description": "터미널에서 \"cursor --mode=plan\"으로 설계 및 코딩 명령 수행"
        },
        {
            "name": "이미지/디자인 인식",
            "description": "UI 스크린샷을 넣으면 프론트엔드 코드로 변환"
        },
        {
            "name": "Privacy Mode",
            "description": "내 코드가 서버에 저장되지 않도록 하는 보안 설정 (SOC2 인증)"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        'Composer 모드 확인: \"Cmd(Ctrl)+I\" 창에서 ''Normal''이 아니라 ''Agent'' 모드가 켜져 있어야 파일을 직접 수정해 줍니다.',
        '인덱싱 대기: 프로젝트를 처음 열면 우측 상단에 ''Indexing...''이 뜹니다. 이게 끝나야 @Codebase 답변이 똑똑해집니다.',
        '.cursorrules 활용: 프로젝트 루트에 .cursorrules 파일을 만들고 \"한글로 답변해\", \"React 함수형 컴포넌트만 써\" 등의 규칙을 적어두면 AI가 항상 따릅니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "설정을 켜면 코드는 AI 답변 생성 직후 즉시 삭제되며, 서버에 저장되거나 학습되지 않습니다 (Privacy Mode).",
        "data_retention": "Business Plan 사용 시 기본적으로 ''Zero Data Retention'' 정책이 적용됩니다.",
        "local_processing": "일부 자동완성(Local Tab)은 로컬 소형 모델을 사용하여 데이터를 외부로 보내지 않고 작동합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Windsurf (Codeium)",
            "description": "월 $15로 더 저렴하며, ''Cascades'' 기능으로 Cursor와 유사한 에이전트 경험 제공"
        },
        {
            "name": "GitHub Copilot",
            "description": "가장 무난하고 기업 도입이 쉬운 표준 AI (VS Code, IntelliJ 모두 지원)"
        },
        {
            "name": "Trae (ByteDance)",
            "description": "최근 부상하는 무료/저가형 AI 에디터"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Cursor Composer: Build software faster",
            "url": "https://www.youtube.com/watch?v=oFfCa3n_s7Q",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Cursor%' OR name ILIKE '%커서%';
