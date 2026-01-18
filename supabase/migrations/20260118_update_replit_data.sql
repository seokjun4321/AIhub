-- Update Replit Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '환경 설정 없이 브라우저에서 바로 코딩하고 배포까지 가능한 클라우드 IDE이자, 앱 하나를 통째로 만들어주는 ''Replit Agent''가 탑재된 도구.',
    website_url = 'https://replit.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web (Browser)", "Mobile App"],
        "target_audience": "입문자, 프로토타입을 빠르게 만들고 싶은 창업가, 환경 설정이 귀찮은 개발자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '기본 클라우드 IDE 사용, 공개(Public) 프로젝트 무제한. **AI Agent 기능은 유료**.',
    pricing_plans = '[
        {
            "plan": "Starter (Free)",
            "price": "무료",
            "target": "학생/입문자",
            "features": "기본 IDE, 공개 프로젝트, AI 맛보기 제한"
        },
        {
            "plan": "Core",
            "price": "$25/월",
            "target": "앱 제작자",
            "features": "Replit Agent(앱 생성기) 사용, 비공개 프로젝트, 고성능 서버"
        },
        {
            "plan": "Teams",
            "price": "별도 문의",
            "target": "협업 팀",
            "features": "동시 편집, 권한 관리, 전용 지원"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Replit Agent (핵심): "구글 지도 연동해서 맛집 기록 앱 만들어줘"라고 말하면, 기획-코딩-디버깅-배포까지 AI가 알아서 진행합니다. (현재 업계에서 가장 주목받는 기능)',
        'Zero Setup: "파이썬 설치하고, 환경변수 잡고..." 이런 과정이 없습니다. 접속하면 바로 코딩 시작입니다.',
        'Instant Deploy: 코드를 짜고 버튼 하나 누르면 즉시 웹사이트 URL이 생성되어 배포됩니다.',
        'Mobile Coding: 모바일 앱 퀄리티가 훌륭해서, 태블릿이나 폰에서도 꽤 진지하게 코딩할 수 있습니다.'
    ],
    cons = ARRAY[
        'Core 필수: 핵심 기능인 ''Replit Agent''를 제대로 쓰려면 유료 플랜(Core) 결제가 거의 필수입니다.',
        '성능 한계: 브라우저 기반이다 보니, 아주 무거운 대규모 프로젝트나 네이티브 앱 개발에는 한계가 있습니다.',
        '비공개 유료: 무료 플랜은 내 코드가 남들에게 다 보이는 ''Public'' 상태가 기본입니다. (Private 하려면 유료).'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "비개발자 창업가",
                "badge": "No-Code",
                "reason": "코딩은 모르지만 아이디어를 앱으로 만들고 싶은 분 (Replit Agent 강추)"
            },
            {
                "target": "코딩 입문자",
                "badge": "Beginner",
                "reason": "환경 설정하다가 지쳐서 포기했던 분"
            },
            {
                "target": "해커톤 참가자",
                "badge": "Hackathon",
                "reason": "짧은 시간 안에 결과물을 만들고 배포해서 보여줘야 하는 팀"
            }
        ],
        "not_recommended": [
            {
                "target": "대용량 엔터프라이즈",
                "reason": "수백 개의 마이크로서비스가 얽힌 복잡한 기업용 시스템 개발"
            },
            {
                "target": "오프라인",
                "reason": "인터넷이 끊기면 아무것도 할 수 없습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Replit Agent",
            "description": "자연어로 앱 사양을 말하면 처음부터 끝까지 제작"
        },
        {
            "name": "Collaborative Coding",
            "description": "구글 닥스처럼 여러 명이 동시에 코드 수정"
        },
        {
            "name": "Cloud IDE",
            "description": "50개 이상의 언어 지원, 별도 설치 없는 개발 환경"
        },
        {
            "name": "Deploy",
            "description": "클릭 한 번으로 웹/서버 배포 및 호스팅"
        },
        {
            "name": "Replit Voice",
            "description": "모바일에서 말로 코딩하는 음성 인식 기능"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '가격 정책: 이미지에는 ''$20''으로 나와있으나, 최근 월 결제 기준 **$25**로 인상되거나 연간 결제 시 할인폭이 큰 경우가 많으니 최종 결제액을 확인하세요.',
        '데이터 공개: 무료 버전에서 비밀번호나 API 키를 코드에 그대로 적으면 전 세계에 공개됩니다. 반드시 ''Secrets'' 기능을 쓰세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "visibility": "무료 플랜의 프로젝트는 기본적으로 공개됩니다. 민감한 프로젝트는 반드시 유료(Core)를 쓰거나 주의해야 합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "GitHub Codespaces",
            "description": "깃허브 친화적인 클라우드 개발 환경"
        },
        {
            "name": "Cursor",
            "description": "로컬 에디터(VS Code) 기반의 강력한 AI 기능을 원한다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Replit Agent",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Replit%' OR name ILIKE '%레플릿%';
