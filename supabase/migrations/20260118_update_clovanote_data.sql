-- Update Naver CLOVA Note Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '녹음 버튼만 누르면 대화 내용을 텍스트로 받아 적고, AI가 핵심 내용 요약과 할 일까지 정리해 주는 스마트 녹음기.',
    website_url = 'https://clovanote.naver.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["iOS", "Android", "Web"],
        "target_audience": "회의록 쓰는 직장인, 강의 녹음하는 대학생, 인터뷰하는 기자"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Free (부분 유료화 가능성)',
    free_tier_note = '매월 300분(5시간) 변환 무료 (소진 시 24시간 대기 모드로 전환)',
    pricing_plans = '[
        {
            "plan": "Basic (Free)",
            "price": "무료",
            "target": "일반 사용자",
            "features": "월 300분 무료 변환, AI 요약 횟수 제한(월 10~15회)"
        },
        {
            "plan": "추가 시간권",
            "price": "확인 필요",
            "target": "헤비 유저",
            "features": "기본 제공량 소진 시 추가 결제하여 사용 (유동적)"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적인 한국어 성능: HyperCLOVA 기술이 적용되어 한국어 발음, 문맥, 끊어 말하기 인식률이 타사(Google, Apple) 대비 압도적입니다.',
        '화자 분리: "참석자 1", "참석자 2"를 목소리로 구별하여 누가 무슨 말을 했는지 대화 형식으로 정리해 줍니다.',
        'AI 핵심 요약: 1시간짜리 회의도 버튼 하나 누르면 ''주요 안건'', ''결론'', ''할 일(To-do)''로 깔끔하게 요약해 줍니다.',
        '줌(Zoom) 연동: 줌 계정을 연동해두면 화상 회의 내용도 자동으로 녹음하고 노트로 만들어줍니다.'
    ],
    cons = ARRAY[
        '월 300분 제한: 매일 회의를 하는 직장인이나 하루 종일 강의를 듣는 학생에게는 5시간이 부족할 수 있습니다.',
        '녹음 파일 업로드: 앱에서 직접 녹음하지 않고 외부 파일(m4a, mp3)을 업로드할 때는 차감 시간이 다르게 적용될 수 있습니다.',
        '보안 이슈: 클라우드 기반이므로 극도로 민감한 사내 기밀 회의(녹음 금지 구역)에서는 사용이 제한될 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "회의록 담당자",
                "badge": "Meeting",
                "reason": "\"회의 끝나고 정리해서 보내\"라는 말을 들었을 때 구세주 같은 도구"
            },
            {
                "target": "인터뷰어/기자",
                "badge": "Interview",
                "reason": "녹취록을 풀 때 1시간 걸릴 일을 5분으로 줄여줍니다"
            },
            {
                "target": "강의 복습",
                "badge": "Lecture",
                "reason": "교수님 농담까지 받아 적어놓고, 키워드 검색으로 공부하고 싶은 학생"
            }
        ],
        "not_recommended": [
            {
                "target": "통화 녹음(아이폰)",
                "reason": "아이폰 자체 통화 녹음이 아니므로, 스피커폰으로 통화하며 녹음해야 하는 불편함이 있습니다"
            },
            {
                "target": "오프라인 환경",
                "reason": "인터넷 연결 없이는 텍스트 변환 및 요약이 불가능합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "음성 기록(STT)",
            "description": "실시간 녹음 및 파일 업로드 텍스트 변환"
        },
        {
            "name": "AI 요약",
            "description": "긴 대화를 문단별로 요약하고 주요 키워드 추출"
        },
        {
            "name": "화자 분리",
            "description": "목소리 지문을 인식해 참석자별 대화 정리"
        },
        {
            "name": "북마크/메모",
            "description": "녹음 중 중요한 순간에 북마크를 찍어두면 나중에 바로 찾아듣기 가능"
        },
        {
            "name": "텍스트 검색",
            "description": "\"지난주 회의 때 ''예산'' 이야기 언제 했지?\" 검색으로 바로 찾기"
        },
        {
            "name": "공유 링크",
            "description": "생성된 노트를 비밀번호 걸어 팀원에게 링크로 공유"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '마이크 위치: 여러 명이 회의할 때는 스마트폰을 발화자들 중앙에 두어야 화자 분리가 정확합니다.',
        '시간 소진 주의: "녹음" 자체는 무제한이지만, "텍스트 변환" 버튼을 누를 때 시간이 차감됩니다. 불필요한 잡담 녹음은 변환하지 마세요.',
        '자주 쓰는 단어: 설정에서 ''자주 쓰는 단어(전문 용어, 회사명)''를 등록해두면 인식 정확도가 훨씬 올라갑니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "설정에서 ''학습 동의 철회''가 가능합니다. (민감 정보라면 끄는 것 권장)",
        "data_retention": "변환된 텍스트와 음성 파일은 계정에 귀속되어 저장되나, 사용자가 삭제 시 서버에서도 영구 삭제됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Daglo",
            "description": "영상 링크만 넣어도 내용을 받아 적어주며, 유튜브 요약에 강점"
        },
        {
            "name": "SKT A. (에이닷)",
            "description": "아이폰 통화 녹음 및 요약이 필요하다면 필수"
        },
        {
            "name": "Otter.ai",
            "description": "영어 회의나 영어 인터뷰 녹음이 주력이라면 클로바보다 강력"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "클로바노트 사용법: 눈으로 보며 듣는 음성 기록",
            "url": "https://www.youtube.com/watch?v=S012345",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%CLOVA%' OR name ILIKE '%클로바%';
