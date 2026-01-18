-- Update Gamma Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'PPT 장표 한 장 한 장 깎을 필요 없이, 텍스트만 넣으면 디자인과 레이아웃이 완성된 프레젠테이션/웹사이트를 만들어주는 생성형 AI 도구.',
    website_url = 'https://gamma.app',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "발표 자료를 급하게 만들어야 하는 직장인, 스타트업 대표(IR자료), 대학생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 크레딧 + 유료 구독)',
    free_tier_note = '가입 시 400 크레딧 제공(일회성, 매월 리필 안 됨). PPT 내보내기 가능, 워터마크 포함',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "찍먹파",
            "features": "400 크레딧(1회), 기본 모델, PPT/PDF 내보내기 가능"
        },
        {
            "plan": "Plus",
            "price": "$8/월",
            "target": "개인 사용자",
            "features": "월 400 크레딧 리필, 워터마크 제거, PPT 무제한 내보내기"
        },
        {
            "plan": "Pro",
            "price": "$15/월",
            "target": "헤비 유저",
            "features": "무제한 AI 생성, 고급 이미지 모델, 자세한 분석 및 폰트 커스텀"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '원클릭 디자인: "AI 트렌드 발표 자료 만들어줘" 한 마디면 목차부터 내용, 이미지, 디자인까지 1분 만에 끝납니다.',
        '스마트 레이아웃: 텍스트 상자를 늘리거나 줄이면 주변 요소들이 알아서 자리를 잡는 ''유동적 레이아웃''이라 줄 맞춤 노가다가 없습니다.',
        '다양한 포맷: 하나의 내용으로 프레젠테이션(PPT), 문서(Doc), 웹사이트(Web Page) 세 가지 형식을 자유롭게 오갈 수 있습니다.',
        'PPT 내보내기: 만든 자료를 파워포인트(.pptx)로 다운로드하면, 파워포인트에서 텍스트 수정이 가능한 상태로 열립니다.'
    ],
    cons = ARRAY[
        '크레딧 소모: 무료로 주는 400 크레딧은 금방 씁니다. (덱 1개 생성에 40크레딧). 리필이 안 돼서 계속 쓰려면 유료 결제가 필요합니다.',
        '정형화된 디자인: 템플릿이 세련됐지만, 감마 특유의 ''웹사이트스러운'' 느낌이 있어 전통적인 PPT 디자인과는 조금 다릅니다.',
        '이미지 퀄리티: 기본 무료 모델이 생성하는 이미지는 다소 퀄리티가 낮을 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "초안 작성",
                "badge": "Drafting",
                "reason": "\"백지에서 시작하기 막막할 때\" 80% 완성된 초안을 1분 만에 얻고 싶은 분"
            },
            {
                "target": "비디자이너",
                "badge": "Design",
                "reason": "디자인 감각은 없지만 예쁜 발표 자료가 필요한 마케터/기획자"
            },
            {
                "target": "정보 전달",
                "badge": "Info",
                "reason": "화려한 애니메이션보다는 깔끔한 정보 전달형 장표(Notion 스타일)를 선호하는 분"
            }
        ],
        "not_recommended": [
            {
                "target": "미세 컨트롤",
                "reason": "도형 위치를 1픽셀 단위로 조정해야 하거나 겹침 효과를 많이 쓰는 복잡한 장표"
            },
            {
                "target": "애니메이션",
                "reason": "파워포인트의 화려한 화면 전환 효과가 필수인 경우"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Generate from Prompt",
            "description": "주제만 입력하면 전체 슬라이드 자동 생성"
        },
        {
            "name": "Text to Deck",
            "description": "기존에 써둔 메모나 문서를 붙여넣으면 슬라이드로 변환"
        },
        {
            "name": "Smart Layout",
            "description": "내용을 추가하면 레이아웃이 자동으로 최적화됨"
        },
        {
            "name": "AI Image Editing",
            "description": "AI로 이미지 스타일 변경 및 수정 (Pro)"
        },
        {
            "name": "Export",
            "description": "PDF, PPTX, PNG 내보내기 지원"
        },
        {
            "name": "Web Publishing",
            "description": "별도 호스팅 없이 링크 하나로 웹사이트처럼 배포"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '무료 크레딧 아끼기: 처음에 목차(Outline)를 보여줄 때 최대한 꼼꼼하게 수정하세요. 일단 생성하고 나서 "다시 만들어줘" 하면 크레딧이 왕창 나갑니다.',
        'PPT 호환성: PPT로 내보낼 때 폰트나 일부 레이아웃이 깨질 수 있으니, 중요 발표 전에는 반드시 파워포인트에서 열어 확인해야 합니다.',
        '워터마크: 무료 버전은 우측 하단에 ''Made with Gamma'' 배지가 붙습니다. 중요한 외부 발표라면 유료(Plus)를 쓰거나 자르기 편집이 필요합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "privacy": "기본적으로 생성된 링크는 ''비공개''이나, 팀원 초대를 잘못하면 노출될 수 있으니 권한 설정을 확인하세요.",
        "copyright": "유료 플랜 사용 시 생성된 콘텐츠의 상업적 이용 권한이 명확해집니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Canva",
            "description": "디자인 요소가 더 풍부하고 인쇄물 제작까지 가능하다면"
        },
        {
            "name": "Tome",
            "description": "스토리텔링에 특화된 또 다른 감성적인 AI 슬라이드 도구"
        },
        {
            "name": "Beautiful.ai",
            "description": "디자인 제약이 더 강하지만 그만큼 \"절대 안 망가지는\" 디자인을 원한다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "Introducing Gamma: A new medium for presenting ideas",
            "url": "https://www.youtube.com/watch?v=y76Cv4RzXpE",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Gamma%' OR name ILIKE '%감마%';
