-- Update ChatGPT Data with Detailed Information
-- This script updates the existing 'ChatGPT' row in ai_models table with the new detailed schema.

UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '최신 GPT-5.1 모델과 o3 추론 엔진, 그리고 Sora 영상 생성까지 하나로 통합된 세계 표준 AI 슈퍼앱.',
    website_url = 'https://chatgpt.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "optional",
        "platforms": ["Web", "iOS", "Android", "macOS", "Windows", "API", "Voice Mode"],
        "target_audience": "전 국민 (단순 검색부터 박사급 연구, 헐리우드급 영상 제작자까지)"
    }'::jsonb,

    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = 'GPT-5.1 Instant(기본 대화), o3-mini(코딩/수학), 웹 검색, 기본 이미지 생성 무료.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "GPT-5.1 Instant 사용, o3-mini(일일 제한), 기본 검색"
        },
        {
            "plan": "Plus",
            "price": "$20/월",
            "target": "헤비 유저/직장인",
            "features": "GPT-5(Full), o3(Standard), Sora 영상 생성(Standard), Canvas"
        },
        {
            "plan": "Pro",
            "price": "$200/월",
            "target": "전문가/기업",
            "features": "o3 Pro 무제한, Sora High-Fidelity 생성, Deep Research 풀 액세스"
        },
        {
            "plan": "Team",
            "price": "$25/인/월",
            "target": "협업 조직",
            "features": "데이터 학습 제외(보안), 워크스페이스 공유, 관리자 기능"
        }
    ]'::jsonb,

    -- 3) Pros & Cons
    pros = ARRAY[
        'GPT-5.1의 압도적 성능: 이전 세대(GPT-4o) 대비 추론 속도는 2배 빠르고, 할루시네이션은 획기적으로 줄어든 완성형 모델',
        'Sora 통합: 별도 도구 없이 채팅창에서 곧바로 영화급 퀄리티의 비디오 클립(최대 1분) 생성 및 편집',
        'Deep Research (심층 연구): AI 에이전트가 수십 분간 웹을 탐색하여 수백 페이지 분량의 보고서를 작성해 주는 자율 연구 기능 탑재',
        'o3 Pro (추론 끝판왕): 복잡한 과학/수학 난제나 수만 줄의 레거시 코드 리팩토링에서 타의 추종을 불허하는 정확도'
    ],
    cons = ARRAY[
        '비싼 Pro 플랜: 최상위 모델(o3 Pro)과 Sora 무제한 기능을 쓰려면 월 $200(약 27만 원) 지불 필요',
        '무료 사용자 제한: 피크 타임 대기열 발생 가능성 및 구형 모델(4o-mini) 자동 전환 가능성',
        '엄격한 안전 정책: Sora 영상 생성 시 인물/뉴스/유명인 관련 프롬프트는 매우 보수적으로 차단'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            { "target": "영상 콘텐츠 제작자", "boge": "Sora", "reason": "텍스트 아이디어를 즉시 고화질 영상 소스로 만들고 싶은 분" },
            { "target": "전문 개발자/연구원", "badge": "o3 Pro", "reason": "남들이 못 푸는 에러를 잡거나, 논문 데이터를 심층 분석해야 하는 분" },
            { "target": "트렌드 리서처", "badge": "Deep Research", "reason": "최신 반도체 시장 동향 보고서 써줘 한마디로 끝내고 싶은 분" },
            { "target": "자연스러운 대화", "badge": "GPT-5.1", "reason": "기계적인 말투가 싫고, 사람처럼 농담하고 공감하는 AI를 원하시는 분" }
        ],
        "not_recommended": [
            { "target": "가성비 중시 (헤비유저)", "reason": "월 $20만 내고 o3 Pro급의 무제한 추론을 기대하는 경우 (Pro 플랜 유도 심함)" },
            { "target": "성인/미검열 콘텐츠", "reason": "안전 필터가 가장 강력하게 적용되어 있어 자유도가 낮음" }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        { "name": "GPT-5.1 (Instant/Thinking)", "description": "상황에 따라 속도와 깊이를 자동 조절하는 최신 플래그십 모델" },
        { "name": "OpenAI o3 & o3-mini", "description": "사고 과정(Chain of Thought)을 시각화해주며 문제를 해결하는 추론 모델" },
        { "name": "Sora (Video)", "description": "텍스트-투-비디오(Text-to-Video) 기능 채팅창 내장" },
        { "name": "Deep Research Agent", "description": "자율적으로 웹을 탐색, 정리, 검증하여 보고서 생성" },
        { "name": "Canvas 2.0", "description": "문서/코드 작성 시 AI와 실시간으로 협업하는 듀얼 인터페이스" },
        { "name": "Advanced Voice", "description": "감정 표현, 끼어들기, 노래하기가 가능한 초실감 음성 대화" }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '모델 확인: 채팅방 상단에 GPT-5인지 GPT-4o인지 확인하세요. 무료 사용자는 자동 다운그레이드될 수 있습니다.',
        'Deep Research 시간: 심층 연구 기능은 답변 생성에 5분~30분이 소요될 수 있으니 기다림이 필요합니다.',
        'Sora 크레딧: Plus 사용자라도 영상 생성 횟수(Credit)에 일일 제한이 있으니, 프롬프트를 신중하게 작성하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "기본 설정 시 대화 내용은 모델 학습에 사용됩니다. (설정 > 데이터 제어에서 Off 가능)",
        "privacy_protection": "전화번호, 이메일 등 민감 정보가 포함된 프롬프트는 시스템이 자동으로 마스킹하거나 경고를 보냅니다.",
        "enterprise_security": "Team/Enterprise: 데이터 학습 원천 차단, SOC2 등 엔터프라이즈 보안 규격 준수"
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        { "name": "Google Gemini (Gemini 3)", "description": "Google Workspace 연동과 긴 문맥 처리가 필요하다면" },
        { "name": "Claude (Claude 3.7)", "description": "코딩 작성 스타일과 문학적 창작 능력에서 더 선호된다면" },
        { "name": "Perplexity", "description": "보고서 작성보다는 빠르고 정확한 검색 결과 나열이 목적이라면" }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing GPT-5",
            "url": "https://www.youtube.com/watch?v=DQacCB9tDaw",
            "platform": "YouTube"
        }
    ]'::jsonb,

    updated_at = now()
WHERE
    name ILIKE '%ChatGPT%' OR name ILIKE '%GPT-4%';
