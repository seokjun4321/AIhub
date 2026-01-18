-- Update Suno Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '음악 지식이 전혀 없어도, "신나는 여름 팝송 만들어줘" 한 마디면 작사·작곡·보컬까지 완성된 노래를 1분 만에 만들어주는 AI 작곡가.',
    website_url = 'https://suno.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "iOS", "Android (Mobile Web)"],
        "target_audience": "콘텐츠 크리에이터(BGM), 작곡 아이디어가 필요한 뮤지션, 나만의 노래를 갖고 싶은 일반인"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '**매일 50 크레딧** (노래 10곡 분량) 무료 제공. 단, 생성된 음원의 **상업적 이용 불가** (유튜브 수익 창출 등 제한).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "취미/체험",
            "features": "일 50크레딧(10곡), 상업적 이용 불가, 대기열 발생"
        },
        {
            "plan": "Pro",
            "price": "$10/월",
            "target": "유튜버/크리에이터",
            "features": "월 2,500크레딧(500곡), 상업적 이용 허용, 우선 생성"
        },
        {
            "plan": "Premier",
            "price": "$30/월",
            "target": "헤비 유저",
            "features": "월 10,000크레딧(2,000곡), 신규 모델(v4) 최우선 접근"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적 퀄리티(v4): 최신 v4 모델은 라디오에서 나오는 실제 가요와 구분하기 힘들 정도로 보컬 발음과 악기 사운드가 정교합니다.',
        '한국어 특화: K-Pop, 트로트, 발라드 등 한국 음악 장르에 대한 이해도가 높고 한국어 가사 발음이 매우 자연스럽습니다.',
        '가사 생성: 가사를 직접 쓰지 않아도 "이별한 슬픔을 담은 가사 써줘"라고 하면 GPT가 자동으로 작사해줍니다.',
        'Extend(곡 연장): 마음에 드는 2분짜리 곡 뒤에 2절, 3절을 계속 이어 붙여서 5분짜리 완곡을 만들 수 있습니다.'
    ],
    cons = ARRAY[
        '저작권 귀속: 무료 플랜 사용자가 만든 노래의 소유권은 Suno에 있으며, 수익 창출이 불가능합니다. (유료 전환 시부터 내 소유)',
        '랜덤성: 똑같은 프롬프트를 넣어도 매번 다른 곡이 나오기 때문에, "이 멜로디에서 악기만 바꿔줘" 같은 미세 조정은 어렵습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "유튜버",
                "badge": "Content",
                "reason": "저작권 걱정 없는 나만의 오프닝/엔딩 BGM이 필요한 분 (Pro 이상)"
            },
            {
                "target": "이벤트",
                "badge": "Event",
                "reason": "친구 생일 축하 노래나 회사 로고송을 재미로 만들고 싶은 분"
            },
            {
                "target": "작사가",
                "badge": "Lyrics",
                "reason": "가사는 썼는데 멜로디를 못 붙여서 답답했던 분"
            }
        ],
        "not_recommended": [
            {
                "target": "전문 작곡가",
                "reason": "MIDI 파일이나 악보(Score) 형태로 내보내는 기능은 제공하지 않으므로, 편곡 작업용으로는 부적합합니다"
            },
            {
                "target": "음질 민감자",
                "reason": "v4가 좋아졌지만, 여전히 스튜디오 녹음 수준의 초고음질(WAV Stem 분리 등)은 완벽하지 않을 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Text to Music",
            "description": "장르와 분위기 설명만으로 작곡 완료"
        },
        {
            "name": "Custom Mode",
            "description": "내가 쓴 가사를 넣거나 특정 스타일을 지정해서 생성"
        },
        {
            "name": "Extend",
            "description": "짧은 클립을 연장하여 4~5분짜리 완곡 제작"
        },
        {
            "name": "Audio Input",
            "description": "내가 흥얼거린 녹음 파일을 올리면 완성된 곡으로 변환 (유료)"
        },
        {
            "name": "Instrumental",
            "description": "보컬 없이 반주(BGM)만 생성 가능"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '상업적 이용: "무료 때 만든 노래"는 나중에 유료 회원이 되어도 상업적으로 못 씁니다. 수익 창출 목적이면 처음부터 Pro를 결제하고 만드세요.',
        '크레딧 소멸: 유료 플랜의 월간 크레딧은 다음 달로 이월되지 않으니 아끼지 말고 다 쓰세요. (무료 크레딧은 매일 리셋)'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "visibility": "기본적으로 생성된 곡은 ''Public''으로 설정될 수 있으니, 나만 듣고 싶다면 ''Private'' 설정을 확인하세요."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Udio",
            "description": "Suno의 가장 강력한 라이벌, 좀 더 복잡하고 긴 곡 구성에 강점"
        },
        {
            "name": "Stable Audio",
            "description": "효과음이나 짧은 비트 생성에 더 적합함"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Suno v4: The Future of Music",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Suno%' OR name ILIKE '%수노%';
