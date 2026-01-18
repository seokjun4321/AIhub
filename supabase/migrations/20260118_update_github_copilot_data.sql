-- Update GitHub Copilot Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'OpenAI, Anthropic(Claude), Google(Gemini)의 최신 모델을 골라 쓸 수 있는 전 세계 1위 AI 페어 프로그래머.',
    website_url = 'https://github.com/features/copilot',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["VS Code", "Visual Studio", "JetBrains (IntelliJ)", "Vim", "Web", "Mobile"],
        "target_audience": "전 세계 모든 개발자, 특히 VS Code 사용자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Subscription (구독형)',
    free_tier_note = '일반 사용자는 **무료 없음** (30일 무료 체험만 제공). 학생/교사/오픈소스 메인테이너는 인증 후 무료 사용 가능.',
    pricing_plans = '[
        {
            "plan": "Individual",
            "price": "$10/월",
            "target": "개인 개발자",
            "features": "멀티 모델(Claude 3.5, GPT-4o, Gemini) 선택 가능, 코드 완성, 채팅"
        },
        {
            "plan": "Business",
            "price": "$19/인/월",
            "target": "팀/조직",
            "features": "IP 면책(저작권 보호), 정책 관리, 조직 단위 라이선스"
        },
        {
            "plan": "Enterprise",
            "price": "$39/인/월",
            "target": "대기업",
            "features": "Copilot Knowledge(사내 문서 연동), 파인튜닝, 보안 강화"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '멀티 모델 지원 (최신): 이제 GPT-4o뿐만 아니라 코딩에 강한 **Claude 3.5 Sonnet**이나 **Gemini 1.5 Pro**로 모델을 변경해 사용할 수 있습니다. (가장 큰 변화)',
        'Copilot Workspace: 이슈(Issue)만 등록하면 계획 수립부터 코드 구현, 빌드 수정까지 AI가 개발 환경 전체를 제어하며 해결해 줍니다.',
        '압도적 생태계: GitHub 저장소와의 연동성이 가장 좋고, PR(Pull Request) 요약이나 커밋 메시지 작성 등 개발 전 과정을 돕습니다.',
        'Copilot Edits: 여러 파일을 오가며 동시에 수정해야 하는 작업을 채팅 한 번으로 처리할 수 있습니다 (Cursor Composer와 유사).'
    ],
    cons = ARRAY[
        '완전 무료 없음: 학생이 아니면 무조건 결제해야 합니다. (경쟁사들은 제한적 무료 플랜 제공).',
        '무거운 IDE: VS Code나 IntelliJ 자체가 무거우면 코파일럿 구동 시 약간의 딜레이가 생길 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "모델 유목민",
                "badge": "Multi-Model",
                "reason": "코딩할 땐 Claude, 채팅할 땐 GPT-4o 등 상황에 맞춰 모델을 바꿔 쓰고 싶은 분"
            },
            {
                "target": "GitHub 헤비 유저",
                "badge": "GitHub",
                "reason": "이슈 관리, PR, 코드 리뷰까지 깃허브 안에서 모든 걸 해결하는 팀"
            },
            {
                "target": "VS Code 사용자",
                "badge": "VS Code",
                "reason": "확장 프로그램 설치만으로 가장 매끄럽게 연동됩니다"
            }
        ],
        "not_recommended": [
            {
                "target": "로컬 데이터 보안",
                "reason": "코드가 외부 서버(MS/OpenAI)로 전송되는 것이 절대적으로 금지된 폐쇄망 환경 (Tabnine 권장)"
            },
            {
                "target": "완전 무료",
                "reason": "돈을 전혀 쓰고 싶지 않은 일반 개발자 (Codeium 등 대체재 추천)"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Model Switching",
            "description": "Claude 3.5 Sonnet, GPT-4o, Gemini 1.5 Pro 선택 사용"
        },
        {
            "name": "Ghost Text",
            "description": "주석이나 코드를 칠 때 회색 텍스트로 자동 완성 제안"
        },
        {
            "name": "Copilot Chat",
            "description": "IDE 옆창에서 코드에 대해 질문하고 리팩토링 요청"
        },
        {
            "name": "Copilot Workspace",
            "description": "자연어로 이슈를 설명하면 개발 환경 세팅부터 구현까지 수행"
        },
        {
            "name": "CLI 지원",
            "description": "터미널 명령어를 자연어로 변환 및 추천 (gh copilot suggest)"
        },
        {
            "name": "Copilot Autofix",
            "description": "코드 취약점을 분석하고 보안 패치를 자동 생성"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '공개 코드 매칭: 설정에서 ''공개 코드와 일치하는 제안 허용''을 끄면(Block), 오픈소스 라이선스 위반 위험을 줄일 수 있습니다.',
        '학생 인증: 대학생이라면 학교 이메일이나 증명서로 ''GitHub Student Pack''을 신청해 무료로 쓰세요. 승인까지 며칠 걸립니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training": "Business/Enterprise 플랜은 고객의 코드를 모델 학습에 사용하지 않음을 보장합니다. Individual 플랜은 설정에서 옵트아웃해야 합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Cursor",
            "description": "VS Code 기반이지만 AI 기능(Composer)이 더 강력하게 내장된 에디터"
        },
        {
            "name": "Codeium",
            "description": "개인 사용자에게 관대한 무료 플랜을 제공하는 도구"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "GitHub Copilot: The AI Pair Programmer",
            "url": "https://www.youtube.com/watch?v=Fi3AJZZQhQI",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%GitHub Copilot%' OR name ILIKE '%깃허브 코파일럿%';
