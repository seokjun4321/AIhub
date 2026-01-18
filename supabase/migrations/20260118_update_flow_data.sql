-- Update Flow Data
UPDATE public.ai_models
SET
    -- 0) Basic Info Update
    description = '프로젝트 관리, 메신저, 화상회의, OKR 목표 관리를 하나로 합친 대한민국 대표 올인원 AI 협업툴.',
    website_url = 'https://flow.team',
    
    -- 1) Meta Info (Badges)
    meta_info = '{
        "korean_support": true,
        "login_required": "required",
        "platforms": ["Web", "Windows", "macOS", "iOS", "Android"],
        "target_audience": "카카오톡으로 업무 보느라 스트레스받는 중소기업, 체계적인 협업이 필요한 팀"
    }'::jsonb,
    
    -- 2) Pricing Info
    pricing_model = 'Freemium (인원수 기반 무료 + 유료 구독)',
    free_tier_note = '300인 이하 조직 대상 무료 사용 프로모션(이벤트성). 기본 협업 기능(메신저, 프로젝트, 파일 공유) 제공.',
    pricing_plans = '[
        {
            "plan": "Free",
            "price": "무료",
            "target": "중소기업/팀",
            "features": "300명 이하 무료 (이벤트성), 기본 프로젝트/메신저"
        },
        {
            "plan": "Business",
            "price": "6,000원/인/월",
            "target": "일반 기업",
            "features": "무제한 프로젝트, 관리자 기능, 게스트 초대"
        },
        {
            "plan": "Enterprise",
            "price": "별도 문의",
            "target": "대기업",
            "features": "사내 구축형(On-Premise), 보안 강화, 전담 매니저"
        }
    ]'::jsonb,

    -- 3) Pros and Cons
    pros = ARRAY[
        '한국형 UI: 밴드(Band)나 카카오톡과 유사한 ''게시물 형태''의 프로젝트 방식을 써서, 노션/슬랙이 어려운 4050 세대도 금방 적응합니다.',
        '올인원: 메신저 따로, 줌(Zoom) 따로, 트렐로 따로 쓸 필요 없이 플로우 하나에서 화상회의와 일정 관리까지 다 됩니다.',
        '외부 협업: 협력사 직원이나 프리랜서를 ''게스트''로 초대해 우리 회사 내부 자료는 안 보여주고 딱 그 프로젝트만 같이하기 좋습니다.',
        'Flow AI: 업무 일지 자동 요약, 하위 업무 생성, 문구 다듬기 등 AI 비서 기능이 탑재되어 있습니다.'
    ],
    cons = ARRAY[
        '깊이의 한계: 올인원이다 보니, 슬랙(Slack)만큼의 봇 연동성이나 노션(Notion)만큼의 문서 자유도는 조금 부족할 수 있습니다.',
        '무료 정책 변동: ''300인 무료''는 매우 파격적이나 이벤트성일 수 있어, 도입 전 영구 무료인지 기간 한정인지 체크가 필요합니다.'
    ],

    -- 4) Recommendations
    recommendations = '{
        "recommended": [
            {
                "target": "카톡 업무 탈출",
                "badge": "No KaTalk",
                "reason": "개인 카톡과 업무용 메신저를 분리하고 싶은 모든 직장인"
            },
            {
                "target": "중소기업 도입",
                "badge": "SMB",
                "reason": "복잡한 교육 없이 전 직원이 바로 쓸 수 있는 쉬운 툴을 찾는 대표님"
            },
            {
                "target": "외부 협업",
                "badge": "Collaboration",
                "reason": "거래처와 이메일 핑퐁 대신 공유방 하나 파서 끝내고 싶은 분"
            }
        ],
        "not_recommended": [
            {
                "target": "개발자 위주",
                "reason": "코딩 소스 연동이나 복잡한 자동화가 핵심이라면 Slack이나 Jira가 더 적합합니다"
            },
            {
                "target": "문서 덕후",
                "reason": "위키(Wiki) 정리가 업무의 90%라면 Notion이 낫습니다"
            }
        ]
    }'::jsonb,

    -- 5) Key Features
    key_features = '[
        {
            "name": "프로젝트 관리",
            "description": "게시물형 타임라인, 간트 차트, 업무 리포트"
        },
        {
            "name": "사내 메신저",
            "description": "실시간 채팅, 읽음 확인, 이모티콘, 시크릿 채팅"
        },
        {
            "name": "Flow AI",
            "description": "업무 필터링, AI 문장 생성, 프로젝트 템플릿 추천"
        },
        {
            "name": "OKR 관리",
            "description": "회사 목표와 개인 업무를 연결하여 성과 측정"
        },
        {
            "name": "화상회의",
            "description": "줌 연동 필요 없이 자체 기능으로 화면 공유 및 회의"
        }
    ]'::jsonb,

    -- 6) Usage Tips
    usage_tips = ARRAY[
        '알림 설정: 기본 설정이면 게시물 등록마다 알림이 울릴 수 있으니, 중요한 프로젝트만 알림을 켜두세요.',
        '게스트 초대: 외부인을 초대할 때 ''멤버(내부 직원)''로 초대하면 과금 대상이 될 수 있으니 반드시 ''게스트'' 권한인지 확인하세요.'
    ],

    -- 7) Privacy Info
    privacy_info = '{
        "security": "금융권 수준의 보안 시스템을 갖추고 있으며, 사내 구축형(On-Premise) 옵션도 지원합니다."
    }'::jsonb,

    -- 8) Alternatives
    alternatives = '[
        {
            "name": "Slack",
            "description": "개발자 친화적이고 앱 연동성이 뛰어난 글로벌 메신저"
        },
        {
            "name": "Jandi",
            "description": "플로우와 유사하지만 메신저(채팅) 기능이 좀 더 강조된 한국형 툴"
        },
        {
            "name": "Notion",
            "description": "프로젝트 관리보다 ''문서 정리''가 더 중요하다면"
        }
    ]'::jsonb,

    -- 9) Media Info
    media_info = '[
        {
            "title": "대한민국 1위 협업툴 플로우(Flow) 소개",
            "url": "https://www.youtube.com/watch?v=0",
            "platform": "YouTube"
        }
    ]'::jsonb

WHERE name ILIKE '%Flow%' OR name ILIKE '%플로우%';
