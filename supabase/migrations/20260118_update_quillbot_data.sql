-- Update QuillBot Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '어색한 영어 문장을 원어민처럼 매끄럽게 바꿔주는(Paraphrasing) 세계 최고의 AI 영문 교정 및 재작성 도구.',
    website_url = 'https://quillbot.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "optional",
        "platforms": ["Web", "Chrome Extension", "macOS", "Word Plugin"],
        "target_audience": "영어 논문 쓰는 대학원생, 영문 이메일 쓰는 직장인, 해외 유학생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '패러프레이징 1회 125단어 제한, 요약 1,200단어, 기본 모드(Standard, Fluency)만 제공',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "라이트 유저",
            "features": "125단어/회, 기본 모드 2개, 동의어 조절 제한"
        },
        {
            "plan": "Premium",
            "price": "$8.33/월",
            "target": "논문/업무용",
            "features": "무제한 단어, 모든 모드(Academic/Formal 등), 표절 검사, AI 탐지기"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '자연스러운 재작성: 단순히 단어만 바꾸는 게 아니라, 문장 구조를 뜯어고쳐 원어민이 쓴 것처럼 만들어줍니다. (Grammarly보다 강력한 수정)',
        '다양한 모드: ''Academic(학술적)'', ''Formal(격식)'', ''Simple(쉽게)'', ''Shorten(줄이기)'' 등 목적에 맞춰 문체를 바꿀 수 있습니다. (Premium)',
        '올인원 툴: 패러프레이징뿐만 아니라 문법 검사, 표절 검사, 인용 생성기, AI 감지기가 하나에 다 들어 있습니다.',
        '확장 프로그램: 크롬이나 워드에 설치해두면 글을 쓰면서 바로바로 드래그해서 고칠 수 있습니다.'
    ],
    cons = ARRAY[
        '무료 제한: 무료 버전의 125단어 제한은 긴 글을 쓸 때 끊어서 넣어야 하므로 매우 불편합니다.',
        '표절 검사 유료: 표절 검사(Plagiarism Checker)는 무료 플랜에 없으며, 유료라도 월 25,000단어(약 20쪽) 제한이 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "영어 논문 작성",
                "badge": "Academic",
                "reason": "내 영어가 ''콩글리시'' 같을 때, ''Academic'' 모드로 돌리면 학술적 표현으로 바뀝니다"
            },
            {
                "target": "표절 회피",
                "badge": "Paraphrase",
                "reason": "남의 글을 인용할 때 문장을 적당히 바꿔서(Paraphrasing) 표절 시비를 피하고 싶은 분"
            },
            {
                "target": "이메일 작성",
                "badge": "Email",
                "reason": "\"좀 더 정중하게(Formal) 바꿔줘\" 기능이 필요한 비즈니스맨"
            }
        ],
        "not_recommended": [
            {
                "target": "창작/소설",
                "reason": "사실 관계가 중요한 글이 아닌 문학적 글쓰기에서는 뉘앙스를 망칠 수 있습니다"
            },
            {
                "target": "한국어 교정",
                "reason": "한글 맞춤법 검사기가 아니며, 영문에 최적화되어 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Paraphraser",
            "description": "문맥을 유지하며 문장 재작성 (7+ 모드)"
        },
        {
            "name": "Grammar Checker",
            "description": "문법, 철자, 구두점 오류 수정 (무료 무제한)"
        },
        {
            "name": "Plagiarism Checker",
            "description": "100개 언어 지원 표절 검사 (Premium)"
        },
        {
            "name": "Summarizer",
            "description": "긴 텍스트나 논문을 핵심 요약 (불릿 포인트 등)"
        },
        {
            "name": "Citation Generator",
            "description": "APA, MLA 등 논문 형식에 맞는 출처 생성"
        },
        {
            "name": "QuillBot Flow",
            "description": "글쓰기, 조사, 교정을 한 화면에서 하는 올인원 에디터"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '표절 주의: QuillBot으로 문장을 바꿨더라도, 원작자의 아이디어를 가져온 것이라면 반드시 인용(Citation)을 달아야 윤리적입니다.',
        'Freeze Words: 전문 용어(고유명사)가 바뀌면 안 될 때, ''Freeze Words'' 기능으로 해당 단어는 바꾸지 말라고 고정하세요.',
        '환불 정책: 결제 후 3일(72시간) 이내에만 100% 환불 보장이 되니, 써보고 안 맞으면 바로 취소해야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "ai_detection": "QuillBot으로 고친 글은 AI 탐지기(GPTZero 등)에 걸릴 확률이 낮아지지만, 100% 인간처럼 보이는 건 아닙니다.",
        "data_usage": "입력된 텍스트는 서비스 개선을 위해 사용될 수 있으므로, 극비 문서는 주의가 필요합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Grammarly",
            "description": "문법 교정과 톤 앤 매너 교정에 더 강력한 표준 도구"
        },
        {
            "name": "Wordtune",
            "description": "문장 단위로 여러 가지 대안을 보여주고 선택하는 방식이 편하다면"
        },
        {
            "name": "DeepL Write",
            "description": "번역기 기반의 자연스러운 작문 교정을 원한다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "How to use QuillBot for Academic Writing",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%QuillBot%' OR name ILIKE '%퀼봇%';
