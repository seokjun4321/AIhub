-- Update Vrew Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '영상 속 음성을 분석해 자동 자막을 달아주고, 워드처럼 텍스트를 지우면 영상도 컷 편집되는 AI 영상 편집기.',
    website_url = 'https://vrew.voyagerx.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Windows", "macOS", "Linux", "Web"],
        "target_audience": "유튜버(자막 노가다 싫은 분), 초보 편집자, 쇼츠/릴스 대량 생산자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '음성 분석 월 120분, AI 목소리 1만 자, 번역 3만 자, 이미지 생성 100장 (워터마크: AI 생성 기능 사용 시에만 부착)',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "입문자",
            "features": "분석 120분/월, 기본 편집 무료, AI 기능 제한적"
        },
        {
            "plan": "Light",
            "price": "7,900원/월",
            "target": "취미/초급",
            "features": "분석 1,200분/월(대폭 증가), AI 목소리 10만 자"
        },
        {
            "plan": "Standard",
            "price": "13,900원/월",
            "target": "유튜버",
            "features": "워터마크 제거(AI 생성물), 무제한급 자막 번역"
        },
        {
            "plan": "Business",
            "price": "35,000원/월",
            "target": "기업/팀",
            "features": "협업 기능, 상업적 이용 라이선스 완전 보장"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '문서 편집 같은 영상 편집: 녹화된 영상의 대본(텍스트)을 보고, 불필요한 문장을 ''Backspace''로 지우면 해당 영상 구간도 함께 잘려 나갑니다.',
        '무음 구간 한방 삭제: 말 없이 조용한 구간(숨 고르기 등)을 버튼 하나로 일괄 삭제해 영상을 타이트하게 만들어줍니다.',
        '텍스트 to 비디오: 대본만 입력하면 AI가 어울리는 무료 이미지/영상을 찾아 배치하고 성우 더빙까지 입혀 쇼츠를 완성해 줍니다.',
        '다국어 자막 번역: 한국어 자막을 영어, 일본어, 스페인어 등으로 번역해 다국어 자막 파일을 생성하기 매우 쉽습니다.'
    ],
    cons = ARRAY[
        '전문 편집의 한계: 프리미어 프로 같은 정교한 이펙트나 색보정 작업에는 적합하지 않습니다. (컷 편집 후 내보내기용)',
        '무거운 구동: 영상 길이가 길어지면(1시간 이상) 프로그램이 다소 무거워지거나 버벅일 수 있습니다.',
        'AI 목소리 톤: 제공되는 AI 성우가 다양하지만, 감정 연기가 필요한 고난도 더빙에는 여전히 기계적인 느낌이 듭니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "토크 위주 유튜버",
                "badge": "Subtitles",
                "reason": "말하는 영상의 자막을 일일이 치기 귀찮은 분 (필수템)"
            },
            {
                "target": "강의 영상 편집",
                "badge": "Cut Edit",
                "reason": "\"음... 어...\" 같은 군더더기 소리와 무음 구간을 빠르게 쳐내고 싶은 강사님"
            },
            {
                "target": "쇼츠 공장장",
                "badge": "Shorts",
                "reason": "텍스트만 넣어서 하루에 쇼츠 10개씩 찍어내고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "시네마틱 영상",
                "reason": "화려한 트랜지션과 색감이 중요한 브이로그나 뮤직비디오 편집"
            },
            {
                "target": "미세 오디오 조절",
                "reason": "음향 효과를 프레임 단위로 믹싱해야 하는 경우"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "자동 자막 생성",
            "description": "음성 인식률 98% 수준, 타임코드 자동 매칭"
        },
        {
            "name": "컷 편집",
            "description": "텍스트 에디터 방식으로 영상 자르기/붙이기"
        },
        {
            "name": "AI 목소리(TTS)",
            "description": "500여 종의 다양한 성우 목소리로 더빙 입히기"
        },
        {
            "name": "텍스트로 비디오 만들기",
            "description": "주제나 대본만 주면 영상+자막+더빙 풀패키지 생성"
        },
        {
            "name": "무음 구간 줄이기",
            "description": "답답한 침묵 구간을 단축하거나 삭제"
        },
        {
            "name": "프리미어 프로 내보내기",
            "description": "xml 형식을 지원해, 브루에서 컷편집하고 프리미어에서 효과 넣기 가능"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '프로젝트 저장: 클라우드 저장이 기본이지만, 인터넷이 불안정하면 ''로컬 프로젝트''로 저장하는 습관을 들이세요.',
        '자막 수정 필수: 인식률이 높지만 고유명사나 발음이 뭉개진 곳은 오타가 있으니 반드시 눈으로 검수해야 합니다.',
        'AI 이미지 저작권: 무료 플랜에서 생성한 AI 이미지는 상업적 이용 시 출처 표기 등의 제약이 있을 수 있으니 약관을 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "음성 데이터는 분석 후 즉시 파기되거나 사용자 동의 없이 학습에 쓰이지 않는 옵션을 제공합니다.",
        "commercial_use": "무료 버전도 유튜브 수익 창출은 가능하나, 일부 유료 폰트/음원 사용 시 주의가 필요합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "CapCut",
            "description": "템플릿과 이펙트가 훨씬 화려하며 모바일에 강함"
        },
        {
            "name": "Premiere Pro",
            "description": "어도비 유저라면 내장된 텍스트 편집 기능 사용"
        },
        {
            "name": "Descript",
            "description": "영미권에서 가장 유명한 텍스트 기반 편집 원조 (한국어 지원은 Vrew가 우위)"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Vrew 사용법 완벽 가이드 (기초편)",
            "url": "https://www.youtube.com/watch?v=S012345",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Vrew%' OR name ILIKE '%브루%';
