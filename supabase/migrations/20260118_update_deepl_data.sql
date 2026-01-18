-- Update DeepL Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '미묘한 뉘앙스와 문맥까지 잡아내는 세계 최고 수준의 AI 번역기이자, 실시간 음성 번역(DeepL Voice)까지 지원하는 언어 AI 솔루션.',
    website_url = 'https://www.deepl.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "optional",
        "platforms": ["Web", "Windows", "macOS", "iOS", "Android", "Chrome Extension", "API"],
        "target_audience": "글로벌 비즈니스맨, 해외 논문 연구자, 전문 번역가"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '1회 번역 시 1,500~5,000자 제한, 파일 번역 월 3개(편집 불가), 용어집 제한적 사용',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "짧은 텍스트 번역, 데이터 보안 보장 안 됨(학습 사용)"
        },
        {
            "plan": "Starter",
            "price": "$8.74/월",
            "target": "개인/프리랜서",
            "features": "데이터 보안(학습 X), 파일 번역 월 5개, 글자 수 무제한"
        },
        {
            "plan": "Advanced",
            "price": "$28.74/월",
            "target": "팀/비즈니스",
            "features": "파일 번역 월 20개, SSO 통합, 팀 관리 기능"
        },
        {
            "plan": "DeepL Write",
            "price": "별도 구독",
            "target": "작문 교정",
            "features": "(별도 상품) 문법/스타일 교정 Pro 기능"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적인 자연스러움: 구글 번역기보다 훨씬 문맥을 잘 이해하며, 특히 한국어-영어 간의 번역 품질이 현존 최고 수준입니다.',
        'DeepL Voice (최신): 화상 회의(Zoom, Teams)나 대면 대화에서 실시간으로 다국어 자막을 띄워주는 음성 번역 기능이 추가되었습니다.',
        '문서 통번역: Word(.docx), PPT(.pptx), PDF 파일을 업로드하면 원본 서식(레이아웃, 폰트)을 유지한 채 텍스트만 번역해 줍니다.',
        '용어집(Glossary): \"우리 회사 이름은 번역하지 마\" 처럼 특정 단어의 번역 규칙을 지정할 수 있어 비즈니스 용도에 적합합니다.'
    ],
    cons = ARRAY[
        '무료 파일 제한: 무료 버전에서 번역한 문서는 편집이 불가능하거나 워터마크가 있을 수 있고 개수 제한(월 3개)이 빡빡합니다.',
        'DeepL Write 분리: 번역이 아닌 ''작문 교정(Grammarly 유사)'' 기능인 DeepL Write Pro는 별도 요금제인 경우가 있어 비용 부담이 될 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "비즈니스 이메일",
                "badge": "Email",
                "reason": "실수 없는 영문 메일을 빠르게 작성해야 하는 직장인"
            },
            {
                "target": "논문 번역",
                "badge": "Paper",
                "reason": "PDF 논문의 레이아웃을 깨지 않고 한글로 읽고 싶은 대학원생 (문서 번역)"
            },
            {
                "target": "글로벌 회의",
                "badge": "Voice",
                "reason": "외국인 클라이언트와의 미팅 내용을 실시간 자막으로 보고 싶은 분 (DeepL Voice)"
            }
        ],
        "not_recommended": [
            {
                "target": "초단문 여행 회화",
                "reason": "여행지에서 가볍게 쓸 용도라면 오프라인 기능이 강력한 구글 번역기나 파파고가 나을 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI 번역",
            "description": "뉘앙스를 살린 고품질 텍스트 번역"
        },
        {
            "name": "DeepL Voice",
            "description": "실시간 음성 인식 및 다국어 자막 생성 (Meeting/Conversation)"
        },
        {
            "name": "문서 번역",
            "description": "Word/PPT/PDF 파일 통번역 (서식 유지)"
        },
        {
            "name": "DeepL Write",
            "description": "문법 교정 및 문체(Tone & Manner) 변경 제안"
        },
        {
            "name": "용어집(Glossary)",
            "description": "사용자 지정 고유명사/전문용어 고정"
        },
        {
            "name": "데이터 보안(Pro)",
            "description": "번역 원문을 서버에 저장하지 않고 즉시 삭제 (Pro 이상)"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '기밀 문서 주의: 무료 버전 사용 시 입력한 텍스트는 모델 학습에 사용될 수 있습니다. 사내 기밀이나 개인정보는 절대 무료 버전에 넣지 마세요.',
        '파일 번역 편집: 무료 플랜으로 파일 번역 시 ''편집 불가'' 상태로 다운로드될 수 있으니, 수정이 필요하면 텍스트만 복사해서 쓰세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "free_tier": "데이터가 모델 개선(학습)에 활용됨.",
        "pro_enterprise": "데이터가 번역 후 즉시 삭제되며, 학습에 절대 사용되지 않음(Zero Retention)."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Google Translate",
            "description": "100개 이상의 언어 지원과 무료 접근성"
        },
        {
            "name": "Papago (Naver)",
            "description": "한국어 높임말/웹툰 번역 등 ''한국 문화''에 특화"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing DeepL Voice",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%DeepL%' OR name ILIKE '%딥엘%';
