-- Update Grammarly Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '단순 맞춤법 교정을 넘어, AI가 문장의 톤과 스타일을 다듬어주고 문단 전체를 새로 써주는(Rewrite) 영문 작문 파트너.',
    website_url = 'https://www.grammarly.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web", "Windows", "macOS", "Browser Extension", "Mobile Keyboard"],
        "target_audience": "영어 이메일 쓰는 직장인, 영문 논문 작성자, 유학생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '기본 문법/철자 교정, 톤 감지, **월 100회의 AI 프롬프트** 사용 가능.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "기본 문법 교정, 톤 감지, AI 100회/월"
        },
        {
            "plan": "Pro (Premium)",
            "price": "$12/월",
            "target": "직장인/학생",
            "features": "완전한 문장 재작성, 표절 검사, AI 1,000~2,000회"
        },
        {
            "plan": "Business",
            "price": "$15/인/월",
            "target": "팀",
            "features": "스타일 가이드 공유, 브랜드 톤 설정, 중앙 관리"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Generative AI (GrammarlyGO): "더 공손하게 바꿔줘", "이메일 답장 써줘"라고 명령하면 AI가 맥락을 파악해 글을 써주거나 고쳐줍니다.',
        '어디서나 작동: 크롬, 워드, 슬랙, 카카오톡(PC) 등 내가 글을 쓰는 모든 곳에 둥둥 떠다니며 실시간으로 교정해 줍니다.',
        '표절 검사 (Pro): 수십억 개의 웹페이지와 대조하여 내 글의 독창성을 검증해 줍니다 (논문 작성 시 유용).',
        '톤 앤 매너: 내 글이 "자신감 있어 보이는지", "친근한지" 분석해주고, 상황에 맞게 어조를 조정해 줍니다.'
    ],
    cons = ARRAY[
        '영어 전용: 한국어 맞춤법 검사는 지원하지 않습니다. (오직 영어 작문용)',
        'Pro 유도: 무료 버전에서는 "고급 제안(노란색 밑줄)"이 흐릿하게 보이기만 하고 내용을 안 보여줘서 결제를 유도합니다.',
        '가격 차이: 월 결제($30)와 연 결제($12)의 가격 차이가 매우 커서, 한 달만 쓰기엔 비쌉니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "비즈니스 영어",
                "badge": "Business",
                "reason": "실수 없는 완벽한 영문 이메일을 빠르게 보내야 하는 분"
            },
            {
                "target": "유학/논문",
                "badge": "Academic",
                "reason": "문법 오류뿐만 아니라 원어민들이 쓰는 세련된 표현(Paraphrasing)을 배우고 싶은 분"
            },
            {
                "target": "영어 초보",
                "badge": "Beginner",
                "reason": "내 영작이 콩글리시인지 불안한 분 (AI가 통째로 고쳐줌)"
            }
        ],
        "not_recommended": [
            {
                "target": "번역기",
                "reason": "한글을 영어로 바꿔주는 도구가 아닙니다. (이미 쓴 영어를 고쳐주는 도구). 번역은 DeepL 추천"
            },
            {
                "target": "한국어 교정",
                "reason": "부산대 맞춤법 검사기나 네이버를 쓰세요"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Grammar & Spelling",
            "description": "기본 문법, 철자, 구두점 실시간 교정"
        },
        {
            "name": "Full-sentence Rewrite",
            "description": "어색한 문장을 통째로 다시 써서 가독성 개선 (Pro)"
        },
        {
            "name": "Generative AI",
            "description": "텍스트 생성, 요약, 아이디어 브레인스토밍"
        },
        {
            "name": "Plagiarism Checker",
            "description": "표절 여부 확인 및 출처 표기 제안 (Pro)"
        },
        {
            "name": "Tone Detector",
            "description": "글의 분위기(격식, 친근함 등) 분석 및 조정"
        },
        {
            "name": "Everywhere",
            "description": "브라우저, 데스크톱 앱, 모바일 키보드 통합"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '플랜 이름: 최근 ''Premium'' 플랜 명칭이 **''Pro''** 또는 **''Premium''**으로 혼용되거나 변경되는 추세이니 혜택(AI 사용량)을 확인하세요.',
        '대학생 할인: 학교 이메일(.edu)로 가입한다고 무조건 무료는 아니지만, 학교가 라이선스를 계약했다면 ''Grammarly for Education''으로 무료 이용 가능합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "security": "엔터프라이즈급 보안(SOC 2)을 준수하며, 사용자 데이터를 제3자에 판매하지 않음을 명시합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "QuillBot",
            "description": "문장을 다양하게 바꿔쓰는(Paraphrasing) 기능에 더 집중하고 싶다면 (가성비 좋음)"
        },
        {
            "name": "DeepL Write",
            "description": "AI 번역기 기반으로 자연스러운 작문 교정을 원한다면"
        },
        {
            "name": "ChatGPT",
            "description": "그냥 \"이거 고쳐줘\"라고 말로 시키는 게 편하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Grammarly: Your AI Writing Partner",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Grammarly%' OR name ILIKE '%그래멀리%';
