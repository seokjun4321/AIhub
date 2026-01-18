-- Update Wrtn Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = 'GPT-4o, Claude 3.5 등 최신 LLM을 한곳에서 무료(제한적)로 쓸 수 있는 한국형 AI 포털이자, 강력한 AI 검색 에이전트.',
    website_url = 'https://wrtn.ai',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "optional",
        "platforms": ["Web", "iOS", "Android", "KakaoTalk Channel"],
        "target_audience": "대학생(리포트/검색), 직장인(문서 초안), 최신 AI 모델을 무료로 찍먹하고 싶은 분"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 + 유료 구독)',
    free_tier_note = 'GPT-4o, Claude 3.5 Sonnet 등 최신 모델 무료 이용 가능 (속도/빈도 제한)',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "일반 사용자",
            "features": "최신 모델 무료(속도 제한), 기본 AI 검색, 이미지 생성"
        },
        {
            "plan": "Pro",
            "price": "11,900원/월",
            "target": "헤비 유저",
            "features": "속도 제한 없음, 최신 모델 무제한급 사용, 전용 지원"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '모델 골라 쓰기: GPT-4o, Claude 3.5 Sonnet, Gemini 등 유료 모델들을 뤼튼에서는 무료로 바꿔가며 써볼 수 있습니다. (가장 큰 장점)',
        'AI 검색(Search): \"2026년 마케팅 트렌드 알려줘\"라고 하면 웹을 검색해 출처와 함께 보고서를 써줍니다. (Perplexity와 유사)',
        '접근성: 카카오톡 채널에서도 바로 대화가 가능하며, UI가 한국인에게 매우 친숙합니다.',
        '나만의 챗봇: 코딩 없이 프롬프트만으로 나만의 AI 툴이나 캐릭터 챗봇을 만들어 공유할 수 있습니다.'
    ],
    cons = ARRAY[
        '무료 속도 제한: 사용자가 몰리는 시간대에는 무료 회원의 답변 속도가 느려지거나 대기열이 생길 수 있습니다.',
        '정확성 이슈: 여러 모델을 섞어 쓰다 보니, 가끔 모델 특유의 성능이 100% 발휘되지 않거나 검열이 강하게 적용될 때가 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "비용 절감",
                "badge": "Free LLM",
                "reason": "ChatGPT Plus($20) 결제가 부담스러운 학생이나 라이트 유저"
            },
            {
                "target": "정보 검색",
                "badge": "Search",
                "reason": "광고 많은 네이버/구글 검색 대신 깔끔하게 요약된 답변을 원할 때 (AI 검색)"
            },
            {
                "target": "국내 트렌드",
                "badge": "Korea Trend",
                "reason": "한국의 최신 뉴스나 문화적 맥락이 중요한 글쓰기를 할 때"
            }
        ],
        "not_recommended": [
            {
                "target": "전문 개발/추론",
                "reason": "복잡한 코딩이나 추론 작업 시 원본(OpenAI/Anthropic) 사이트보다 안정성이 떨어질 수 있습니다"
            },
            {
                "target": "성인/미검열",
                "reason": "국내 서비스 특성상 윤리 필터링이 매우 엄격합니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "멀티 LLM",
            "description": "GPT-4o, Claude 3.5, PaLM 2 등 다양한 모델 선택 사용"
        },
        {
            "name": "AI 검색",
            "description": "실시간 웹 정보를 출처와 함께 요약 제공"
        },
        {
            "name": "AI 이미지 생성",
            "description": "한국어 프롬프트로 그림 그리기 (Stable Diffusion 등 활용)"
        },
        {
            "name": "문서 요약",
            "description": "PDF나 한글(HWP) 파일을 올리면 내용 요약"
        },
        {
            "name": "캐릭터 챗",
            "description": "다양한 페르소나의 AI 캐릭터와 감성 대화"
        },
        {
            "name": "스튜디오",
            "description": "나만의 프롬프트 툴 제작 및 배포"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '모델 확인: 채팅창 상단에서 현재 선택된 모델이 ''GPT-4o''인지 ''Gemma''인지 확인하세요. 모델마다 똑똑함의 정도가 다릅니다.',
        '출처 확인: AI 검색 결과에 달린 각주(숫자)를 클릭해 원본 기사가 맞는지 꼭 더블 체크하세요.',
        '이미지 생성: \"그려줘\"라고 말하면 그려주지만, 전문 툴(Midjourney)보다는 퀄리티가 낮을 수 있습니다.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_usage": "기본적으로 서비스 품질 향상을 위해 대화 내용이 활용될 수 있습니다.",
        "opt_out": "설정 메뉴에서 데이터 학습 거부(Opt-out) 기능을 제공하는지 확인이 필요합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Perplexity",
            "description": "글로벌 정보 검색과 출처 정리에 더 강력한 도구"
        },
        {
            "name": "ChatGPT",
            "description": "가장 표준적이고 안정적인 성능을 원한다면"
        },
        {
            "name": "Liner",
            "description": "웹 형광펜 기능과 결합된 한국의 또 다른 AI 검색 강자"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "뤼튼(Wrtn) 사용법 가이드",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Wrtn%' OR name ILIKE '%뤼튼%';
