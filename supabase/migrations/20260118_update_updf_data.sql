-- Update UPDF AI Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'PDF 편집, 변환, OCR 기능에 ''DeepSeek/GPT-5'' 기반의 강력한 요약·번역·마인드맵 생성 기능을 더한 올인원 PDF 편집기.',
    website_url = 'https://updf.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Windows", "macOS", "iOS", "Android"],
        "target_audience": "논문 리서치 연구원, 계약서 검토 직장인, 원서 읽는 대학생"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 체험 + 유료 구독/영구)',
    free_tier_note = 'PDF 뷰어/리더 무료. 편집 저장 시 워터마크 삽입. AI 질문/요약 횟수 제한(약 3~5회)',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "뷰어 사용자",
            "features": "읽기 무료, 편집 시 워터마크, AI 맛보기 제한"
        },
        {
            "plan": "UPDF Pro",
            "price": "45,900원~/년",
            "target": "편집 중심",
            "features": "편집/변환/OCR 무제한, 4개 기기 동시 사용"
        },
        {
            "plan": "UPDF AI",
            "price": "별도/번들",
            "target": "AI 활용 중심",
            "features": "DeepSeek/GPT 기반 무제한 요약/번역, PDF to MindMap"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '최신 모델 탑재: 2026년 기준 DeepSeek R1 및 GPT-5(일부 플랜) 모델을 통합하여 요약과 번역의 정확도가 매우 높습니다.',
        'PDF to MindMap: PDF 내용을 읽고 자동으로 구조화된 마인드맵으로 그려주는 신기능이 강력합니다.',
        '가성비: 경쟁사(Adobe Acrobat) 대비 가격이 훨씬 저렴하며, 한 번 구매로 PC/모바일 모든 기기에서 쓸 수 있습니다.',
        'Deep Research: 단순 요약을 넘어, AI 에이전트가 웹을 검색해 심층 보고서를 써주는 기능이 추가되었습니다.'
    ],
    cons = ARRAY[
        'AI 별도 과금: ''UPDF Pro(편집기)''와 ''UPDF AI(기능)'' 라이선스가 분리되어 있어, AI를 무제한 쓰려면 추가 비용이 들 수 있습니다.',
        '데스크탑 앱 중심: 웹 버전도 있지만, 강력한 편집 기능은 설치형 프로그램에서 가장 잘 작동합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "논문/원서 리서치",
                "badge": "Research",
                "reason": "영어 논문을 통째로 넣고 \"한국어로 요약하고 마인드맵 그려줘\"라고 해야 하는 대학원생"
            },
            {
                "target": "PDF 편집+AI",
                "badge": "Edit+AI",
                "reason": "단순히 PDF를 읽는 걸 넘어 텍스트 수정과 이미지 교체가 빈번한 실무자"
            },
            {
                "target": "멀티 디바이스",
                "badge": "Cross-Platform",
                "reason": "아이패드와 윈도우 노트북을 오가며 작업하는 유저"
            }
        ],
        "not_recommended": [
            {
                "target": "웹 전용 도구 선호",
                "reason": "설치 없이 브라우저에서만 가볍게 해결하고 싶은 경우 (ChatPDF 등이 더 빠를 수 있음)"
            },
            {
                "target": "완전 무료",
                "reason": "워터마크 없는 무료 편집기를 찾는다면 알PDF(개인) 등이 나을 수 있습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "AI 요약/번역",
            "description": "수백 페이지 PDF도 몇 초 만에 요약하고 원하는 언어로 번역"
        },
        {
            "name": "PDF to MindMap",
            "description": "줄글로 된 문서를 시각적인 마인드맵으로 자동 변환 (v2.0 신기능)"
        },
        {
            "name": "Deep Research",
            "description": "AI가 스스로 웹을 검색하여 문서 내용을 보강하거나 심층 분석"
        },
        {
            "name": "OCR (광학 문자 인식)",
            "description": "스캔한 이미지 문서를 편집 가능한 텍스트로 변환"
        },
        {
            "name": "Chat with Image",
            "description": "PDF 내 이미지를 인식하고 내용을 설명하는 멀티모달 기능"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '라이선스 확인: \"평생(Perpetual)\" 라이선스를 사더라도 메이저 업데이트(예: v3.0)는 유료일 수 있으며, AI 크레딧은 별도인 경우가 많습니다. 구매 전 확인하세요.',
        '워터마크: 무료 버전에서 열심히 편집하고 저장하면 워터마크가 박혀버립니다. 저장 전 ''Pro'' 여부를 꼭 확인하세요.',
        'AI 모델 선택: 채팅창에서 일반 모드와 Deep Research 모드를 구분해서 써야 크레딧을 아낄 수 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "enterprise_security": "기업용(Enterprise) 플랜 사용 시 데이터 학습 배제가 보장됩니다.",
        "privacy_protection": "문서는 암호화되어 전송되며, 로컬 처리 옵션을 통해 보안을 강화할 수 있습니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "ChatPDF",
            "description": "설치 없이 웹에서 바로 PDF와 대화하는 가장 간편한 도구"
        },
        {
            "name": "Adobe Acrobat AI",
            "description": "업계 표준, Creative Cloud를 이미 구독 중이라면 추천"
        },
        {
            "name": "LiquidText",
            "description": "태블릿에서 손으로 쓰며 문서를 연결/정리하는 데 특화된 도구"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "UPDF AI: Chat with PDF, Summarize, Translate",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%UPDF%';
