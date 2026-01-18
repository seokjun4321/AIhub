-- Update MyMap.ai Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '채팅만 하면 복잡한 아이디어를 마인드맵, 순서도, 프레젠테이션으로 즉시 시각화해 주는 시각적 사고 도구.',
    website_url = 'https://www.mymap.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "대학생(개념 정리), 기획자(순서도/구조화), 강사/발표자(자료 시각화)"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '매일 5 AI 크레딧 제공 (약 5개의 맵 생성 가능), PNG 내보내기 지원, 기본 편집 기능',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "찍먹파/학생",
            "features": "일 5 크레딧, PNG 내보내기만 가능, 기본 템플릿"
        },
        {
            "plan": "Plus",
            "price": "$9.99/월",
            "target": "개인 사용자",
            "features": "월 100 크레딧, PDF/SVG 고화질 내보내기, 웹 검색 연동"
        },
        {
            "plan": "Pro",
            "price": "$19.99/월",
            "target": "헤비 유저",
            "features": "무제한 크레딧, 팀 협업 기능, 고급 AI 모델 및 템플릿"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '대화형 생성: "한국 역사 흐름도 그려줘"라고 말하면 자동으로 구조화된 마인드맵을 그려줍니다.',
        '웹 검색 연동: 최신 정보를 웹에서 검색하여 마인드맵 내용에 자동으로 반영할 수 있습니다.',
        '다양한 시각화: 단순 마인드맵뿐만 아니라 순서도(Flowchart), 프레젠테이션 슬라이드, 간트 차트까지 생성합니다.',
        '직관적 UI: 생성된 노드를 드래그 앤 드롭으로 쉽게 수정할 수 있어 파워포인트보다 작업 속도가 빠릅니다.'
    ],
    cons = ARRAY[
        '무료 제한: 하루 5개 제한이 있어 본격적인 업무용으로 쓰기엔 부족할 수 있습니다.',
        '모바일 앱 부재: 전용 앱보다는 모바일 웹 브라우저 사용을 권장합니다.',
        '디테일 수정: AI가 만든 구조를 아주 세밀하게 커스터마이징(디자인 요소 등)하는 데는 한계가 있을 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "개념 정리",
                "badge": "Brainstorm",
                "reason": "공부한 내용을 구조도로 한눈에 보고 싶은 학생/수험생"
            },
            {
                "target": "초안 작성",
                "badge": "Drafting",
                "reason": "기획서나 발표 자료의 뼈대를 1분 안에 잡고 싶은 직장인"
            },
            {
                "target": "시각적 브레인스토밍",
                "badge": "Visualization",
                "reason": "아이디어가 텍스트로만 맴돌 때 그림으로 정리하고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "정밀한 디자인",
                "reason": "포토샵급의 예쁜 디자인이나 자유로운 드로잉이 필요한 경우"
            },
            {
                "target": "오프라인 작업",
                "reason": "인터넷 연결 없이는 생성 기능을 사용할 수 없습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Chat to Map",
            "description": "텍스트 대화로 마인드맵/순서도 자동 생성"
        },
        {
            "name": "URL to Map",
            "description": "유튜브 영상 링크나 긴 글 URL을 넣으면 내용을 요약해 시각화"
        },
        {
            "name": "AI Presentation",
            "description": "주제만 주면 PPT 슬라이드 초안 생성"
        },
        {
            "name": "Real-time Web Search",
            "description": "구글/빙 검색 결과를 반영한 최신 정보 매핑"
        },
        {
            "name": "Team Collaboration",
            "description": "생성된 맵을 링크로 공유하고 협업 (Pro)"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '크레딧 관리: "수정해줘"라는 명령도 크레딧을 소모할 수 있으니, 처음에 프롬프트를 구체적으로 적는 것이 좋습니다.',
        '언어 설정: 결과물이 영어로 나온다면 프롬프트 뒤에 "...한국어로 적어줘"라고 명시하거나 설정에서 언어를 확인하세요.',
        '내보내기: 무료 버전은 배경 투명화나 벡터(SVG) 저장이 안 되므로, 고화질 인쇄가 목적이라면 유료 전환이 필요할 수 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "training_data": "무료 사용자의 데이터는 모델 개선에 활용될 수 있으므로 민감한 개인정보 입력은 지양하세요.",
        "privacy_protection": "생성한 맵의 공유 링크가 외부에 노출되지 않도록 주의가 필요합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Whimsical AI",
            "description": "더 깔끔한 디자인과 UI/UX 기획에 특화된 도구"
        },
        {
            "name": "XMind AI",
            "description": "전통적인 마인드맵 강자로 오프라인 기능과 호환성 우수"
        },
        {
            "name": "Miro",
            "description": "팀 화이트보드 협업 기능이 더 중요하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "How to use MyMap.AI",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%MyMap%' OR name ILIKE '%마이맵%';
