-- Update Whimsical Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '화이트보드, 플로우차트, 마인드맵, 와이어프레임을 하나의 무한 캔버스에서 AI와 함께 그리는 초고속 시각 협업 도구.',
    website_url = 'https://whimsical.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": false,
        "login_required": "required",
        "platforms": ["Web", "macOS", "Windows", "iOS (Viewer)"],
        "target_audience": "기획자(PM/PO), UX 디자이너, 개발자(아키텍처 설계), 아이디어 회의가 많은 팀"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '보드 3개 생성 가능, 1,000개 아이템 제한 없음, AI Actions 월 100회 무료.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "개인/소팀",
            "features": "보드 3개, AI 액션 100회/월"
        },
        {
            "plan": "Pro",
            "price": "$10/월/인",
            "target": "실무자",
            "features": "무제한 보드, AI 액션 500회/월, 1GB 파일 업로드"
        },
        {
            "plan": "Business",
            "price": "$15/월/인",
            "target": "팀/조직",
            "features": "AI 액션 1,000회/월, SSO, 무제한 팀"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        'Whimsical AI: "로그인 프로세스 그려줘"라고 입력하면 텍스트를 분석해 플로우차트나 마인드맵 구조를 순식간에 그려줍니다.',
        '직관성: Miro나 FigJam보다 기능이 단순하지만, 그만큼 배우지 않고도 바로 쓸 수 있을 정도로 UI가 직관적이고 빠릅니다.',
        '와이어프레임: 버튼, 입력창, 아이콘 등 UI 요소가 내장되어 있어 드래그 앤 드롭만으로 웹/앱 기획서를 뚝딱 만들 수 있습니다.',
        '문서(Docs) 통합: 노션 같은 문서 기능이 보드 안에 통합되어 있어, 기획서(글)와 다이어그램(그림)을 한 화면에서 관리합니다.'
    ],
    cons = ARRAY[
        '무료 보드 제한: 보드 3개 제한이 꽤 빡빡해서, 프로젝트가 늘어나면 유료 결제가 필요합니다.',
        '디자인 커스텀: 색상이나 폰트 스타일링 옵션이 제한적입니다. (예쁘게 꾸미기보다 ''빠르게 그리기''에 집중된 툴).',
        'AI 횟수 제한: 유료 플랜조차 AI 사용 횟수(500~1000회)에 월간 제한이 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "서비스 기획자",
                "badge": "Planning",
                "reason": "화면 설계서(Wireframe)와 유저 플로우(Flowchart)를 동시에 그려야 하는 분"
            },
            {
                "target": "개발자",
                "badge": "Architecture",
                "reason": "시스템 아키텍처나 시퀀스 다이어그램을 빠르게 도식화하고 싶은 분"
            },
            {
                "target": "브레인스토밍",
                "badge": "Ideation",
                "reason": "AI에게 \"마케팅 아이디어 10개 내봐\" 하고 마인드맵으로 정리하고 싶은 팀"
            }
        ],
        "not_recommended": [
            {
                "target": "화려한 디자인",
                "reason": "포토샵처럼 자유로운 드로잉이나 복잡한 디자인 작업이 필요한 경우 (Figma 권장)"
            },
            {
                "target": "무제한 무료",
                "reason": "보드 개수 제한 없이 쓰고 싶다면 Miro(제한적)나 draw.io(완전 무료)가 나을 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Whimsical AI",
            "description": "텍스트 → 마인드맵/플로우차트/시퀀스 자동 변환"
        },
        {
            "name": "Wireframes",
            "description": "로우파이(Lo-Fi) UI 디자인을 위한 풍부한 컴포넌트 라이브러리"
        },
        {
            "name": "Flowcharts",
            "description": "스마트한 화살표 연결과 자동 정렬 기능"
        },
        {
            "name": "Docs",
            "description": "캔버스 위에 바로 쓰는 위키/문서 도구 (Notion 스타일)"
        },
        {
            "name": "Mind Maps",
            "description": "단축키만으로 가지를 치며 아이디어를 확장하는 마인드맵"
        },
        {
            "name": "Quick-add",
            "description": "(최신) 방향 상관없이 도형을 빠르게 추가하는 기능 개선"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '보드 개수: 무료 사용자는 보드 3개가 차면 새 보드를 못 만듭니다. 안 쓰는 보드를 지우거나 내용을 한 보드 안에 몰아서 쓰세요.',
        'AI 횟수: "AI 액션"은 AI에게 명령할 때마다 차감됩니다. 무료 100회는 금방 소진되니 신중하게 쓰세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_storage": "클라우드 기반으로 자동 저장되며, 엔터프라이즈 플랜의 경우 고급 보안(SSO 등)을 지원합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Miro",
            "description": "더 다양한 템플릿과 자유로운 화이트보드 기능 (단, 무겁게 느껴질 수 있음)"
        },
        {
            "name": "FigJam",
            "description": "Figma를 쓰고 있다면 연동성이 가장 좋은 화이트보드"
        },
        {
            "name": "Draw.io",
            "description": "디자인은 투박하지만 완전 무료인 다이어그램 툴"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Whimsical AI: Generate ideas at the speed of thought",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Whimsical%' OR name ILIKE '%윔지컬%';
