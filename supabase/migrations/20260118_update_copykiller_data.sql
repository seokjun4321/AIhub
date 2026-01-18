-- Update CopyKiller Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '100억 건 이상의 빅데이터와 비교해 표절률을 검사하고, 사람이 쓴 글인지 AI(GPT)가 쓴 글인지까지 탐지해 주는 국내 1위 표절 검사 서비스.',
    website_url = 'https://www.copykiller.com',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web"],
        "target_audience": "대학생(리포트/논문), 취준생(자기소개서), 교사/교수(과제 검수)"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (무료 제한적 + 건당 결제/기관 구독)',
    free_tier_note = 'Lite 회원 기준 1일 3건 무료 검사 (단, 문서당 3,000자 이내, 1MB 미만 제한, 비교 DB 제한적)',
    pricing_plans = '[
        {
            "plan": "Lite (Free)",
            "price": "무료",
            "target": "학부생/가벼운 용도",
            "features": "일 3건 무료, 3,000자 제한, 기본 표절 검사"
        },
        {
            "plan": "Lite (Paid)",
            "price": "9,900원/건",
            "target": "졸업논문/공모전",
            "features": "문서 용량/글자 수 무제한, 상세 결과 확인서 제공"
        },
        {
            "plan": "Campus/School",
            "price": "무료(학교 구독)",
            "target": "학교 소속",
            "features": "학교 도서관 계정 연동 시 무제한 무료 (GPT 킬러 포함)"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '압도적인 DB: 국내 논문, 리포트, 웹 문서 등 100억 건 이상의 데이터베이스와 대조하므로 표절 잡아내는 능력이 가장 확실합니다.',
        'GPT 킬러: ChatGPT나 네이버 클로바X 등이 작성한 문장을 찾아내어 "AI 작성 확률"을 수치로 보여줍니다. (자기소개서 검증에 필수)',
        '학교 제휴: 국내 대부분의 대학교와 제휴되어 있어, 학교 포털을 통해 접속하면 유료 기능을 공짜로 쓸 수 있는 경우가 많습니다.',
        '상세 결과확인서: 단순히 "몇 퍼센트 표절"이라고 알려주는 게 아니라, 어느 문장이 어디서 베껴졌는지 형광펜으로 칠해진 PDF 리포트를 줍니다.'
    ],
    cons = ARRAY[
        '무료 제한: 개인 무료 회원은 글자 수(3,000자) 제한이 있어 긴 논문은 쪼개서 검사하거나 돈을 내야 합니다.',
        '건당 결제 비용: 정기 구독이 아니라 ''건당 9,900원''이라 개인이 여러 번 돌려보기엔 비용 부담이 큽니다.',
        'GPT 킬러 별도: 무료 검사에서는 AI 탐지(GPT 킬러) 기능이 제한되거나 별도 과금일 수 있습니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "대학생/대학원생",
                "badge": "Thesis",
                "reason": "논문 제출 전 표절률 15% 미만 맞추기 위해 필수 (학교 무료 계정 확인 필수)"
            },
            {
                "target": "취준생",
                "badge": "Jobs",
                "reason": "자기소개서가 타 기업 지원서와 겹치지 않는지, 혹은 AI 티가 너무 나지 않는지 확인"
            },
            {
                "target": "블로거",
                "badge": "Copyright",
                "reason": "내 글이 다른 곳에 무단 도용되었는지 역추적하고 싶을 때"
            }
        ],
        "not_recommended": [
            {
                "target": "단순 문법 검사",
                "reason": "맞춤법 검사기 기능도 있지만, 부산대 맞춤법 검사기 등이 더 전문적입니다"
            },
            {
                "target": "영어 에세이",
                "reason": "영문 자료 비교도 가능하지만, Turnitin(턴잇인)이 해외 DB 커버리지는 더 넓습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "표절 검사",
            "description": "6어절 이상 일치 시 표절 의심 영역으로 표시"
        },
        {
            "name": "GPT 킬러",
            "description": "생성형 AI가 쓴 문장 탐지 및 확률 분석"
        },
        {
            "name": "출처 생성기",
            "description": "검사 후 올바른 인용/출처 표기법 가이드 제공"
        },
        {
            "name": "1:1 비교",
            "description": "내 문서와 특정 비교 대상 문서 간의 유사도만 정밀 분석"
        },
        {
            "name": "결과 확인서",
            "description": "기관 제출용 공인 PDF 리포트 다운로드"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '학교 계정 확인: 무턱대고 9,900원 결제하지 마세요. 학교 도서관 홈페이지 로그인 후 ''카피킬러 캠퍼스'' 배너를 누르면 무료인 경우가 90%입니다.',
        '인용구 제외: \"인용부호 내 문장 제외\" 설정을 켜야 정당하게 인용한 문장이 표절률에서 빠집니다.',
        '자가 표절: 예전에 냈던 내 리포트를 그대로 복붙하면 ''자가 표절''로 걸립니다. (내용을 수정하거나 인용 표기 필요)'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "data_storage": "검사한 문서는 표절 비교 DB에 포함되지 않으므로(사용자 설정 가능), 내 논문이 남의 표절 검사 대상으로 쓰일 걱정은 안 해도 됩니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Turnitin",
            "description": "해외 저널 투고나 영문 에세이 과제라면 세계 표준 도구"
        },
        {
            "name": "GPTZero",
            "description": "영문 텍스트의 AI 작성 여부 탐지에 특화된 글로벌 툴"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "카피킬러 사용법 및 표절 예방 가이드",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%CopyKiller%' OR name ILIKE '%카피킬러%';
