-- Update ChatPDF Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '논문, 계약서, 교재 등 PDF 파일을 업로드하면 마치 저자와 대화하듯 내용을 물어보고 답변받는 원조 PDF 대화 AI.',
    website_url = 'https://www.chatpdf.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "optional",
        "platforms": ["Web", "Mobile App"],
        "target_audience": "논문 읽는 대학원생, 두꺼운 매뉴얼을 봐야 하는 엔지니어, 계약서 검토 직장인"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = '하루 2개 파일 업로드 무료(120페이지/10MB 이하). 질문 횟수 제한(하루 20~50회).',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "가벼운 용도",
            "features": "120페이지/PDF, 하루 2개 파일, 질문 50회"
        },
        {
            "plan": "Plus",
            "price": "$5/월",
            "target": "헤비 유저",
            "features": "페이지/파일 무제한급, 질문 무제한, 여러 PDF 동시 대화"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적 간편함: 회원가입 없이도 사이트 접속하자마자 PDF를 드래그하면 바로 대화가 시작됩니다. (접근성 1위)',
        '정확한 인용: 답변이 문서의 몇 페이지에서 나왔는지 ''쪽수(Page Number)''를 클릭 가능한 링크로 달아줍니다.',
        '다국어 지원: 영어 논문을 올리고 "한국어로 요약해줘"라고 하면 완벽하게 번역 요약해 줍니다.',
        '가성비: 경쟁 툴 대비 기능은 심플하지만 가격(월 $5~)이 매우 저렴한 편입니다.'
    ],
    cons = ARRAY[
        '기능 단순함: PDF 외에 워드/PPT 지원이 약하거나, 복잡한 표/이미지 분석 능력은 GPT-4 Vision이나 UPDF AI보다 떨어질 수 있습니다.',
        '파일 관리: 폴더 정리나 팀 협업 기능보다는 ''개인용 뷰어''에 가깝습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "대학원생",
                "badge": "Thesis",
                "reason": "영어 논문 100페이지를 다 읽기 벅찰 때 \"핵심 결론과 한계점만 요약해줘\"라고 시킬 때"
            },
            {
                "target": "수험생",
                "badge": "Study",
                "reason": "교재 PDF를 넣고 \"이 내용에서 시험 문제 5개만 뽑아줘\"라고 할 때"
            },
            {
                "target": "빠른 검토",
                "badge": "Quick",
                "reason": "설치 없이 10초 만에 문서를 파악해야 할 때"
            }
        ],
        "not_recommended": [
            {
                "target": "스캔 문서",
                "reason": "텍스트 드래그가 안 되는 이미지형 PDF(스캔본)는 OCR 인식이 잘 안될 수 있습니다. (이 경우 UPDF나 Acrobat 추천)"
            },
            {
                "target": "대용량 라이브러리",
                "reason": "수백 개의 문서를 한 번에 연결해서 지식베이스를 만드는 용도로는 부족합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "Chat with PDF",
            "description": "문서 내용 기반 질의응답 (할루시네이션 최소화)"
        },
        {
            "name": "Citation",
            "description": "답변의 근거가 되는 페이지 바로가기 링크 제공"
        },
        {
            "name": "Summary",
            "description": "파일 업로드 즉시 문단별/요소별 요약 생성"
        },
        {
            "name": "Multi-file Chat",
            "description": "여러 개의 PDF를 하나의 채팅방에서 동시에 질문 (Plus)"
        },
        {
            "name": "Export Chat",
            "description": "대화 내용을 텍스트로 내보내기"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '민감 정보: 무료/게스트 모드 사용 시 업로드한 파일이 서버에 임시 저장될 수 있으므로, 주민번호나 비밀 계약서는 올리지 마세요.',
        'OCR 확인: 글자가 드래그되지 않는 PDF는 ChatPDF가 내용을 못 읽습니다. 미리 OCR 변환을 거쳐야 합니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "security": "전송 구간 암호화를 지원하며, 사용자는 언제든 데이터를 삭제 요청할 수 있습니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "UPDF AI",
            "description": "편집 기능까지 포함된 설치형 프로그램을 원한다면"
        },
        {
            "name": "Claude",
            "description": "아주 긴 문맥(책 한 권 분량)을 한 번에 분석해야 한다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "How to use ChatPDF for Research",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%ChatPDF%' OR name ILIKE '%챗PDF%';
