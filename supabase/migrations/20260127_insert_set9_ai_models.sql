-- Insert Kickresume, Shortwave, Superhuman, Monica, Genspark, Captions into ai_models table
INSERT INTO ai_models (
  name,
  description,
  provider,
  website_url,
  logo_url,
  average_rating,
  rating_count,
  meta_info,
  pricing_model,
  pricing_info,
  free_tier_note,
  pricing_plans,
  pros,
  cons,
  key_features,
  recommendations,
  usage_tips,
  privacy_info,
  alternatives,
  media_info,
  version,
  best_for,
  search_tags,
  comparison_data,
  features
) VALUES 
-- 1. Kickresume
(
  'Kickresume',
  'GPT-4 기반의 AI가 이력서 문장을 대신 써주고, 디자인 템플릿 제공 및 ATS(채용 시스템) 통과 확률까지 분석해 주는 취업 치트키.',
  'Kickresume',
  'https://www.kickresume.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Kickresume_Company_Logo.png/972px-Kickresume_Company_Logo.png', -- Wikimedia commons
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "Mobile"],
    "target_audience": "Job Seekers, Global Applicants"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Premium $19/월',
  '기본 템플릿 4개, 1개 이력서 생성 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "찍먹파",
      "features": "템플릿 4개, 기본 웹사이트, 제한적 다운로드"
    },
    {
      "plan": "Premium",
      "price": "$19/월",
      "target": "취준생",
      "features": "35+ 템플릿, AI Writer 무제한, ATS 분석"
    }
  ]'::jsonb,
  ARRAY[
    'AI Writer: 경력 입력 시 전문적인 Bullet point 자동 생성 (GPT-4)',
    'ATS Checker: 채용 시스템 통과 확률 점수 분석 및 개선 제안',
    'Pyjama Jobs: 원격 근무 공고 매칭 기능 내장',
    'Personal Website: 이력서 내용 기반 포트폴리오 사이트 자동 생성'
  ],
  ARRAY[
    '유료 유도: 예쁜 템플릿과 고급 기능은 대부분 유료',
    '영어 중심: 영문 레주메에는 강력하나 국문 자소서에는 표현 한계'
  ],
  '[
    {"name": "AI Resume Writer", "description": "직무별 맞춤 문장 자동 생성"},
    {"name": "Resume Checker", "description": "이력서 분석 및 개선"},
    {"name": "Cover Letter Generator", "description": "맞춤형 커버 레터 작성"},
    {"name": "Website Builder", "description": "포트폴리오 사이트 생성"},
    {"name": "Proofreading", "description": "전문가 교정 (유료)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "해외 취업", "badge": "Global", "reason": "링크드인 프로필 PDF 변환 및 영문 이력서"},
      {"target": "영작 울렁증", "badge": "English", "reason": "성과를 있어 보이게 포장"},
      {"target": "디자인 똥손", "badge": "Design", "reason": "워드 줄 맞추기 스트레스 해방"}
    ],
    "not_recommended": [
      {"target": "국내 공채", "reason": "한국 대기업 지정 양식(hwp) 호환 안 됨"},
      {"target": "완전 무료", "reason": "Canva 무료 템플릿이 대안"}
    ]
  }'::jsonb,
  ARRAY[
    '구독 해지: 취업 성공 시 해지 필수 (연 결제가 저렴하지만 주의)',
    '사진 첨부: 영미권 이력서는 사진 제외 관례 준수'
  ],
  '{
    "privacy_protection": "Personal website can be public"
  }'::jsonb,
  '[
    {"name": "Teal", "description": "채용 공고 추적 관리에 강점"},
    {"name": "Rezi", "description": "ATS 통과율 최적화에 특화"}
  ]'::jsonb,
  '[
    {"title": "Best AI Resume Builder - Kickresume", "url": "https://www.youtube.com/results?search_query=Kickresume+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Resume Builder', 'CV Maker', 'Job Search'],
  ARRAY['Resume', 'Job', 'CV', 'Kickresume', 'Career'],
  '[
    {"competitor": "Teal", "comparison": "Kickresume has better design templates, Teal has better job tracking"},
    {"competitor": "Rezi", "comparison": "Kickresume is better for visual CVs, Rezi is better for text-based ATS optimization"}
  ]'::jsonb,
  ARRAY['AI 이력서 작성(Writer)', 'ATS 점수 분석', '커버레터 생성', '개인 웹사이트 빌더', '원격 근무 매칭']
),

-- 2. Shortwave
(
  'Shortwave',
  '구글 지메일(Gmail)을 메신저처럼 빠르고 똑똑하게 바꿔주는 AI 이메일 클라이언트. (구글 인박스(Inbox) 팀 출신이 만듦).',
  'Shortwave',
  'https://www.shortwave.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Shortwave_App_Icon.png/640px-Shortwave_App_Icon.png', -- Sourced or generic placeholder if failed
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Web", "Mobile", "Desktop"],
    "target_audience": "Gmail Power Users"
  }'::jsonb,
  'Freemium',
  'Free (90일 제한) / Standard $7/월',
  '최근 90일 이메일 검색 및 AI 요약 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인",
      "features": "90일 검색 제한, 기본 AI 요약"
    },
    {
      "plan": "Standard",
      "price": "$7/월",
      "target": "직장인",
      "features": "전체 검색, 즉시 알림, AI 비서 강화"
    },
    {
      "plan": "Pro",
      "price": "$14/월",
      "target": "헤비 유저",
      "features": "AI 심화, 대량 메일 처리"
    }
  ]'::jsonb,
  ARRAY[
    'AI Assistant: 채팅으로 메일함 검색 및 정보 추출 (RAG)',
    'Smart Summary: 긴 스레드/뉴스레터 한 줄 요약',
    'AI Autocomplete: 내 말투 학습하여 답장 자동 완성 (Ghost writing)',
    'Speed: 지메일 웹보다 훨씬 빠르고 강력한 단축키 지원'
  ],
  ARRAY[
    'Gmail 전용: 아웃룩 등 타사 메일 미지원',
    '무료 제한: 90일 이전 메일 검색 불가 (치명적)'
  ],
  '[
    {"name": "AI Summary", "description": "이메일 스레드 요약"},
    {"name": "Conversational Search", "description": "자연어 이메일 검색"},
    {"name": "Ghost AI", "description": "답장 초안 작성"},
    {"name": "Smart Bundles", "description": "메일 카테고리 묶음"},
    {"name": "Calendar Integration", "description": "일정 자동 등록"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "인박스 제로", "badge": "Productivity", "reason": "메일함 비우기 최적화"},
      {"target": "영어 이메일", "badge": "English", "reason": "요약 및 영작 도움"},
      {"target": "구글 인박스 팬", "badge": "Fan", "reason": "Inbox by Gmail UI 계승"}
    ],
    "not_recommended": [
      {"target": "아웃룩 유저", "reason": "구글 계정만 지원"},
      {"target": "무료 헤비 유저", "reason": "90일 검색 제한"}
    ]
  }'::jsonb,
  ARRAY[
    '서명 설정: "Sent with Shortwave" 문구 확인 및 제거',
    '알림 설정: 중요 메일만 알림, 나머지는 Bundle 처리 권장'
  ],
  '{
    "privacy_protection": "SOC 2 certified, Training on user data optional"
  }'::jsonb,
  '[
    {"name": "Superhuman", "description": "더 빠르고 비싼 대안"},
    {"name": "Spark Mail", "description": "다중 계정 통합 관리"}
  ]'::jsonb,
  '[
    {"title": "Introducing Shortwave AI Assistant", "url": "https://www.youtube.com/results?search_query=Shortwave+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Email Client', 'AI Email', 'Gmail'],
  ARRAY['Email', 'Gmail', 'AI', 'Shortwave', 'Inbox'],
  '[
    {"competitor": "Superhuman", "comparison": "Shortwave is cheaper and has better AI search, Superhuman is slightly faster"},
    {"competitor": "Spark", "comparison": "Shortwave is Gmail-only, Spark supports all providers"}
  ]'::jsonb,
  ARRAY['AI 이메일 요약', '대화형 검색(AI Search)', '고스트 AI(답장 작성)', '스마트 번들(묶음)', '캘린더 연동']
),

-- 3. Superhuman
(
  'Superhuman',
  '"세상에서 가장 빠른 이메일" — 0.1초의 딜레이도 허용하지 않는 속도와 강력한 AI 기능을 결합한 하이엔드 이메일 클라이언트.',
  'Superhuman',
  'https://superhuman.com',
  'https://www.kindpng.com/picc/m/26-260232_superhuman-email-client-hd-png-download.png', -- Sourced
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Mac", "Windows", "Mobile", "Web"],
    "target_audience": "Executives, Power Users"
  }'::jsonb,
  'Subscription',
  'Member $30/월',
  '무료 플랜 없음 (데모 요청 필수).',
  '[
    {
      "plan": "Member",
      "price": "$30/월",
      "target": "전문가",
      "features": "AI 기능, 무제한 속도, 단축키"
    },
    {
      "plan": "Growth",
      "price": "Custom",
      "target": "팀",
      "features": "팀 공유, 우선 지원"
    }
  ]'::jsonb,
  ARRAY[
    '속도(Speed): 100ms 이내 반응 속도 (로딩 없음)',
    'Superhuman AI: 즉시 답장, 자동 요약, 자연어 검색 기능 강력',
    '단축키: 마우스 없이 키보드로만 모든 메일 처리 가능',
    'Outlook 지원: 구글 및 아웃룩 계정 모두 지원'
  ],
  ARRAY[
    '가격: 월 $30라는 높은 가격 장벽',
    '진입 장벽: 단축키 습득을 위한 온보딩 필요'
  ],
  '[
    {"name": "Instant Reply", "description": "AI 답장 초안 작성"},
    {"name": "Split Inbox", "description": "중요 메일 자동 분리"},
    {"name": "Snippet", "description": "상용구 단축키 입력"},
    {"name": "Read Status", "description": "수신 확인 추적"},
    {"name": "Ask AI", "description": "자연어 메일 검색"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "경영진/임원", "badge": "Exec", "reason": "높은 시간 가치 절약"},
      {"target": "키보드 워리어", "badge": "Speed", "reason": "마우스 없는 초고속 작업"},
      {"target": "얼리어답터", "badge": "Elite", "reason": "최고급 생산성 도구 경험"}
    ],
    "not_recommended": [
      {"target": "일반 직장인", "reason": "기본 앱으로 충분함"},
      {"target": "무료 선호", "reason": "유료 전용"}
    ]
  }'::jsonb,
  ARRAY[
    '수신 확인: 상대방이 싫어할 수 있으니 설정 확인',
    '온보딩: 1:1 교육 세션 참여 권장 (단축키 마스터)'
  ],
  '{
    "privacy_protection": "Google security audit passed, No data sale"
  }'::jsonb,
  '[
    {"name": "Shortwave", "description": "더 저렴한 AI 대안"},
    {"name": "Spark Mail", "description": "대중적인 무료 대안"}
  ]'::jsonb,
  '[
    {"title": "Superhuman AI: The Future of Email", "url": "https://www.youtube.com/results?search_query=Superhuman+email+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Fastest Email', 'Productivity', 'Email Client'],
  ARRAY['Email', 'Fast', 'Superhuman', 'AI', 'Client'],
  '[
    {"competitor": "Shortwave", "comparison": "Superhuman is faster and supports Outlook, Shortwave is cheaper"},
    {"competitor": "Gmail", "comparison": "Superhuman uses Gmail data but provides a much faster UI"}
  ]'::jsonb,
  ARRAY['인스턴트 답장(AI)', '스플릿 인박스', '스니펫(상용구)', '수신 확인(Read Status)', 'Ask AI']
),

-- 4. Monica
(
  'Monica',
  'GPT-4, Claude 3.5, Gemini 등 최신 AI 모델을 하나의 사이드바에서 골라 쓸 수 있는 올인원 AI 브라우저 확장 프로그램.',
  'Monica.im',
  'https://monica.im',
  'https://img.utdstc.com/icon/30d/3d3/30d3d3a04010530752495392576288647acae069634e9760777e486004652c4d:200', -- Common vector or store icon
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Chrome Extension", "Edge", "Mac", "Windows"],
    "target_audience": "General Users, Researchers"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Pro $9.9/월',
  '일일 40회 기본 채팅 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "라이트 유저",
      "features": "일일 40회 채팅, 기본 기능"
    },
    {
      "plan": "Pro",
      "price": "$9.9/월",
      "target": "헤비 유저",
      "features": "고급 모델(GPT-4/Claude) 쿼리 증가, 이미지 생성"
    },
    {
      "plan": "Unlimited",
      "price": "$19.9/월",
      "target": "전문가",
      "features": "무제한 고급 쿼리"
    }
  ]'::jsonb,
  ARRAY[
    'All-in-One Model: GPT-4, Claude, Gemini 등 모든 모델 통합 사용 (가성비)',
    'Sidebar: 브라우저 사이드바에서 드래그 번역/요약 즉시 실행',
    'Monica Bots: 번역가, 코딩, 여행 등 특화 봇 원클릭 호출',
    '다양한 기능: PDF/유튜브 요약, 이미지 생성, 글쓰기 등 종합 선물세트'
  ],
  ARRAY[
    '복잡한 UI: 기능이 많아 화면이 복잡함',
    '쿼리 제한: 유료라도 고급 모델 횟수 제한 확인 필요'
  ],
  '[
    {"name": "Model Switching", "description": "LLM 모델 교차 사용"},
    {"name": "Web Summary", "description": "웹페이지/PDF 요약"},
    {"name": "YouTube Summary", "description": "영상 내용 요약"},
    {"name": "Writing Assistant", "description": "글쓰기/이메일 작성"},
    {"name": "Parallel Translate", "description": "원문/번역문 동시 표시"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "모델 유목민", "badge": "Models", "reason": "여러 유료 모델 한 번에 사용"},
      {"target": "웹 서핑족", "badge": "Web", "reason": "즉시 번역 및 요약"},
      {"target": "유튜브 요약", "badge": "Summary", "reason": "영상 핵심 파악"}
    ],
    "not_recommended": [
      {"target": "미니멀리스트", "reason": "UI 복잡함"},
      {"target": "깊이 있는 대화", "reason": "긴 문맥 프로젝트는 전용 사이트 권장"}
    ]
  }'::jsonb,
  ARRAY[
    '단축키 충돌: 호출 키 설정 확인',
    '모델 확인: 무료 쿼리 절약을 위해 GPT-3.5/4 전환 확인'
  ],
  '{
    "privacy_protection": "Browser extension requires read access"
  }'::jsonb,
  '[
    {"name": "Liner", "description": "형광펜 및 한국어 검색 특화"},
    {"name": "Harpa AI", "description": "웹 자동화 기능 강력"}
  ]'::jsonb,
  '[
    {"title": "Meet Monica: Your ChatGPT AI Copilot", "url": "https://www.youtube.com/results?search_query=Monica.im+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['AI Sidebar', 'Browser Extension', 'Summarizer'],
  ARRAY['AI', 'Extension', 'Chatbot', 'Monica', 'GPT-4'],
  '[
    {"competitor": "Liner", "comparison": "Monica allows model switching (Claude/GPT), Liner focuses on search/highlighting"},
    {"competitor": "Harpa", "comparison": "Monica is better for chat/writing, Harpa is better for monitoring/automation"}
  ]'::jsonb,
  ARRAY['모델 스위칭(GPT-4/Claude 등)', '웹페이지 요약', '유튜브 요약', 'AI 사이드바', '병렬 번역']
),

-- 5. Genspark
(
  'Genspark',
  '검색어를 입력하면 단순한 답변이 아니라, AI가 실시간으로 조사하여 나만을 위한 맞춤형 위키 페이지(Sparkpage)를 만들어주는 차세대 검색 엔진.',
  'Genspark',
  'https://www.genspark.ai',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Genspark_logo.png/640px-Genspark_logo.png', -- Assuming wikimedia or generic
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Optional",
    "platforms": ["Web"],
    "target_audience": "Travelers, Researchers"
  }'::jsonb,
  'Freemium',
  'Free (Beta) / Premium $19.99/월',
  '검색 및 Sparkpage 생성 무료 (베타).',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반 사용자",
      "features": "무제한 검색, Sparkpage 생성"
    },
    {
      "plan": "Premium",
      "price": "$19.99/월",
      "target": "헤비 유저",
      "features": "고급 모델 무제한, 심층 리서치"
    }
  ]'::jsonb,
  ARRAY[
    'Sparkpage: 검색 결과로 지도, 영상, 정보가 담긴 구조화된 웹페이지 생성',
    'Autopilot Agent: 여러 소스 교차 검증 및 정보 취합',
    '신뢰성: 광고 없는 결과 및 출처 명시',
    '큐레이션: 블로그 글처럼 목차와 이미지로 정리된 가독성'
  ],
  ARRAY[
    '속도: 페이지 구성에 몇 초 소요 (단순 검색보다 느림)',
    '최신성: 실시간 속보보다는 리뷰/가이드에 적합'
  ],
  '[
    {"name": "Sparkpage Generator", "description": "맞춤형 위키 페이지 생성"},
    {"name": "AI Parallel Search", "description": "다중 소스 동시 검색"},
    {"name": "Comparison Table", "description": "스펙 비교표 생성"},
    {"name": "Travel Guide", "description": "지도 포함 여행 가이드"},
    {"name": "Pros & Cons", "description": "장단점 분석 요약"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "여행 계획러", "badge": "Travel", "reason": "맛집/관광지 지도 포함 페이지 공유"},
      {"target": "쇼핑 고민", "badge": "Shop", "reason": "제품 스펙 비교표 생성"},
      {"target": "리포트 작성", "badge": "Research", "reason": "깊이 있는 자료 조사 및 정리"}
    ],
    "not_recommended": [
      {"target": "단답형 검색", "reason": "날씨/환율은 구글 권장"},
      {"target": "대화형 선호", "reason": "채팅 방식을 선호하면 Perplexity 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '공유: 생성된 페이지 링크로 친구에게 공유 가능',
    '수정: 채팅으로 추가 요청하여 페이지 내용 수정 가능'
  ],
  '{
    "privacy_protection": "Citations provided for verification"
  }'::jsonb,
  '[
    {"name": "Perplexity", "description": "대화형 검색 엔진"},
    {"name": "Arc Search", "description": "모바일 브라우징 요약"}
  ]'::jsonb,
  '[
    {"title": "Introducing Genspark", "url": "https://www.youtube.com/results?search_query=Genspark+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Search Engine', 'AI Agent', 'Travel Planner', 'Sparkpage'],
  ARRAY['Search', 'Genspark', 'Page', 'Travel', 'AI'],
  '[
    {"competitor": "Perplexity", "comparison": "Genspark generates a one-page report (Sparkpage), Perplexity gives a chat answer"},
    {"competitor": "Google", "comparison": "Genspark synthesizes information into a page, Google lists links"}
  ]'::jsonb,
  ARRAY['스파크페이지(Sparkpage) 생성', '자율 에이전트 리서치', '비교표 자동 생성', '여행 가이드', '장단점 분석']
),

-- 6. Captions
(
  'Captions',
  '영상만 찍으면 자막, 편집, 더빙, 심지어 "눈 맞춤(Eye Contact)"까지 AI가 알아서 해주는 숏폼 크리에이터의 필수 앱.',
  'Captions.ai',
  'https://www.captions.ai',
  'https://placehold.co/200x200?text=C', -- Placeholder or generic
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["iOS", "Android", "Desktop"],
    "target_audience": "Short-form Creators"
  }'::jsonb,
  'Subscription',
  'Pro $13/월',
  '무료 체험 제한적 (워터마크). 유료 필수.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "워터마크, 기능 제한"
    },
    {
      "plan": "Pro",
      "price": "$13/월",
      "target": "크리에이터",
      "features": "Eye Contact, Lipdub, 워터마크 제거"
    },
    {
      "plan": "Max",
      "price": "$30/월",
      "target": "전문가",
      "features": "데스크톱 앱, 추가 생성 시간"
    }
  ]'::jsonb,
  ARRAY[
    'AI Eye Contact: 시선 교정 기능으로 프롬프트 보고 읽어도 정면 응시 효과',
    'Lipdub (립덥): 입모양까지 맞추는 다국어 AI 더빙',
    'AI Edit: 말실수/무음 자동 삭제 및 줌인/줌아웃 효과',
    'AI Music: 저작권 걱정 없는 배경음악 생성'
  ],
  ARRAY[
    '유료 필수: 무료로는 실사용 어려움',
    '부자연스러움: Eye Contact 강도 높으면 눈빛이 어색할 수 있음'
  ],
  '[
    {"name": "AI Eye Contact", "description": "시선 자동 교정"},
    {"name": "AI Lipdub", "description": "다국어 더빙 및 입모양"},
    {"name": "Auto Captions", "description": "애니메이션 자막"},
    {"name": "AI Trim", "description": "무음/실수 자동 컷편집"},
    {"name": "AI Music", "description": "배경음악 생성"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "대본 리딩", "badge": "Eye", "reason": "프롬프트 읽으며 촬영 가능"},
      {"target": "글로벌 진출", "badge": "Dub", "reason": "외국어 더빙으로 해외 유입"},
      {"target": "편집 초보", "badge": "Edit", "reason": "자막/컷편집 자동화"}
    ],
    "not_recommended": [
      {"target": "긴 영상", "reason": "10분 이상 롱폼에는 부적합"},
      {"target": "PC 편집", "reason": "모바일 앱 중심 UI"}
    ]
  }'::jsonb,
  ARRAY[
    '눈동자 조절: Eye Contact 강도 조절 필수',
    '자막 수정: 업로드 전 오타 검수 권장'
  ],
  '{
    "privacy_protection": "Cloud processing for video"
  }'::jsonb,
  '[
    {"name": "Vrew", "description": "PC 무료 기능 및 한국어 특화"},
    {"name": "CapCut", "description": "다양한 무료 편집 효과"}
  ]'::jsonb,
  '[
    {"title": "Captions App: Your AI Video Creator", "url": "https://www.youtube.com/results?search_query=Captions+app+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Video Editor', 'AI Dubbing', 'Eye Contact'],
  ARRAY['Video', 'Captions', 'Shorts', 'Dubbing', 'AI'],
  '[
    {"competitor": "Vrew", "comparison": "Captions has better AI visual effects (Eye Contact), Vrew is better for text editing on PC"},
    {"competitor": "CapCut", "comparison": "Captions automates editing more aggressively, CapCut gives more manual control"}
  ]'::jsonb,
  ARRAY['아이 컨택(Eye Contact)', 'AI 립덥(Lipdub)', '자동 자막 생성', 'AI 컷편집', 'AI 음악 생성']
);
