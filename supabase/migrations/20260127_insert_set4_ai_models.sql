-- Insert Fathom, Julius AI, Coefficient, Bardeen, Lindy.ai into ai_models table
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
-- 1. Fathom
(
  'Fathom',
  '"개인은 평생 무료" — 설치만 해두면 줌/구글미트 회의를 자동으로 녹화, 전사(텍스트 변환), 요약해 주는 AI 회의 비서.',
  'Fathom.video',
  'https://fathom.video',
  'https://fathom.io/wp-content/uploads/2019/08/cropped-fathom-logo-HQW-1.png', -- Fathom logo found
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Desktop App (Mac/Windows)", "Zoom/Meet Integration"],
    "target_audience": "Freelancers, Individuals, 1-person Business"
  }'::jsonb,
  'Freemium',
  'Free (개인 완전 무료) / Team $15/월',
  '개인 사용자 기준 녹화, 전사, 요약 기능이 무제한 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인/프리랜서",
      "features": "무제한 녹화/요약, 이메일 공유, 7개 언어 지원"
    },
    {
      "plan": "Team",
      "price": "$15/월",
      "target": "조직",
      "features": "CRM 연동, 폴더별 공유 권한, 팀 분석"
    }
  ]'::jsonb,
  ARRAY[
    '진짜 무료: 개인 사용자에게 기능 제한 거의 없음 (녹화/요약 무제한)',
    '설치형 앱: 데스크톱 앱으로 구동되어 안정적이고 방해되지 않음',
    '즉시 공유: 종료 후 1분 내 요약 링크 생성 및 공유 가능',
    '하이라이트: 중요 순간 클릭 한 번으로 클립 생성'
  ],
  ARRAY[
    '팀 기능 유료: CRM 연동이나 팀 폴더 공유는 유료',
    '한국어 요약: 받아쓰기는 잘하지만 요약문은 영어로 나올 때 있음'
  ],
  '[
    {"name": "Auto-Recording", "description": "회의 시작 시 자동 참여 및 녹화"},
    {"name": "AI Summary", "description": "핵심 내용 및 할 일(Action Item) 요약"},
    {"name": "Highlight Clips", "description": "중요 구간 마킹 및 클립 생성"},
    {"name": "Share Link", "description": "즉시 공유 가능한 회의록 링크"},
    {"name": "Search", "description": "키워드로 특정 발언 순간 검색"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "가성비 끝판왕", "badge": "Free", "reason": "회의록 툴에 돈 쓰기 싫은 개인 사용자"},
      {"target": "영상 클립 공유", "badge": "Clip", "reason": "특정 구간만 잘라서 공유할 때"},
      {"target": "줌/미트 헤비 유저", "badge": "Heavy", "reason": "플랫폼 가리지 않고 자동 기록 희망"}
    ],
    "not_recommended": [
      {"target": "오프라인 녹음", "reason": "온라인 화상 회의 전용"},
      {"target": "정교한 CRM", "reason": "복잡한 영업 파이프라인 관리는 Fireflies 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '녹화 알림: 참여 시 소리가 나므로 사전 공지',
    '앱 실행 필수: 데스크톱 앱이 켜져 있어야 자동 녹화 작동'
  ],
  '{
    "privacy_protection": "SOC 2 Type II, Encrypted storage"
  }'::jsonb,
  '[
    {"name": "Otter.ai", "description": "모바일 앱 지원 및 영어 회의 비중 높음"},
    {"name": "Fireflies.ai", "description": "영업팀 CRM 연동 핵심"}
  ]'::jsonb,
  '[
    {"title": "Fathom: The Free AI Meeting Assistant", "url": "https://www.youtube.com/results?search_query=Fathom+video+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Meeting Recorder', 'Transcription', 'Free Meeting Tool'],
  ARRAY['Meeting', 'Free', 'Record', 'Summary', 'Desktop'],
  '[
    {"competitor": "Otter", "comparison": "Fathom provides unlimited free recording for individuals, Otter has limits"},
    {"competitor": "Fireflies", "comparison": "Fathom is simpler and free for individuals, Fireflies is for sales teams"}
  ]'::jsonb,
  ARRAY['무제한 무료 녹화(개인)', 'AI 요약', '하이라이트 클립', '즉시 공유 링크', '데스크톱 앱']
),

-- 2. Julius AI
(
  'Julius AI',
  '엑셀 파일을 업로드하고 질문하면, Python 코드를 작성해 데이터를 분석하고 시각화 차트까지 그려주는 AI 데이터 분석가.',
  'Julius AI',
  'https://julius.ai',
  'https://placehold.co/200x200?text=J', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "iOS", "Android"],
    "target_audience": "Marketers, Data Analysts, Planners"
  }'::jsonb,
  'Subscription',
  'Basic $17.99/월 / Essential $37/월',
  '월 15개 메시지 무료 (맛보기용).',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "월 15 메시지, 기본 모델"
    },
    {
      "plan": "Basic",
      "price": "$17.99/월",
      "target": "개인",
      "features": "월 250 메시지, GPT-4o/Claude 선택, 파일 업로드"
    },
    {
      "plan": "Essential",
      "price": "$37/월",
      "target": "실무자",
      "features": "무제한 메시지, 긴 컨텍스트, 복잡한 처리"
    }
  ]'::jsonb,
  ARRAY[
    '코드 실행(Python): 데이터 분석에 특화된 정교한 코드 생성 및 실행',
    '시각화: 요청 즉시 깔끔한 차트/그래프 생성 및 다운로드',
    '다양한 소스: 엑셀, CSV, 구글시트, Postgres DB 직접 연결',
    '모델 선택: GPT-4o, Claude 3.5 Sonnet 등 최신 모델 선택 가능'
  ],
  ARRAY[
    '유료 필수: 무료 15회는 매우 부족하여 실사용엔 유료 필요',
    '대용량 한계: GB 단위 초대형 데이터는 웹 처리 속도 이슈'
  ],
  '[
    {"name": "Chat with Data", "description": "자연어로 데이터 질의응답"},
    {"name": "Data Visualization", "description": "차트, 그래프, 히트맵 생성"},
    {"name": "Data Cleaning", "description": "결측치 제거 및 전처리 자동화"},
    {"name": "Advanced Math", "description": "복잡한 수학/물리 모델링"},
    {"name": "Report Generation", "description": "분석 결과 리포트 작성"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "엑셀 초보", "badge": "NoCode", "reason": "함수 몰라도 말로 데이터 분석"},
      {"target": "보고서 작성", "badge": "Viz", "reason": "예쁜 그래프 빠른 생성"},
      {"target": "데이터 클리닝", "badge": "Prep", "reason": "전처리 작업 자동화"}
    ],
    "not_recommended": [
      {"target": "민감 정보", "reason": "개인정보 포함 파일 업로드 주의"},
      {"target": "실시간 대시보드", "reason": "Tableau 같은 실시간 모니터링 아님"}
    ]
  }'::jsonb,
  ARRAY[
    '한글 폰트: 차트 생성 시 "한글 폰트 적용해줘" 명시',
    '데이터 확인: 원본 데이터 정합성 사전 확인 필요'
  ],
  '{
    "privacy_protection": "Strict privacy, data deleted after retention period"
  }'::jsonb,
  '[
    {"name": "ChatGPT (Plus)", "description": "Advanced Data Analysis 기능 유사"},
    {"name": "Noteable", "description": "주피터 노트북 기반 분석"}
  ]'::jsonb,
  '[
    {"title": "Getting Started with Julius AI", "url": "https://www.youtube.com/results?search_query=Julius+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Data Analysis', 'Visualization', 'Python generation'],
  ARRAY['Data', 'Excel', 'Python', 'Chart', 'Analysis'],
  '[
    {"competitor": "ChatGPT", "comparison": "Julius is more specialized for data with better visualization tools"},
    {"competitor": "Excel", "comparison": "Julius allows natural language analysis unlike manual Excel formulas"}
  ]'::jsonb,
  ARRAY['데이터 시각화(Chart)', 'Python 코드 실행', '데이터 전처리(Cleaning)', '엑셀/DB 연동', '자연어 분석']
),

-- 3. Coefficient
(
  'Coefficient',
  '구글 시트/엑셀 내에서 세일즈포스, 허브스팟, DB 데이터를 실시간으로 연동하고, AI(GPT)로 수식과 데이터를 관리하는 스프레드시트 플러그인.',
  'Coefficient',
  'https://coefficient.io',
  'https://upload.wikimedia.org/wikipedia/commons/e/e0/Coefficient_Logo_Green.png',
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Google Sheets", "Excel Add-on"],
    "target_audience": "Sales Ops, Marketers"
  }'::jsonb,
  'Freemium',
  'Free (수동 Import) / Starter $49/월',
  '수동 데이터 가져오기 무료. 자동 새로고침 유료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인",
      "features": "수동 Import, GPT Copilot"
    },
    {
      "plan": "Starter",
      "price": "$49/월",
      "target": "실무자",
      "features": "자동 새로고침(매시간), 스냅샷"
    },
    {
      "plan": "Pro",
      "price": "$99/월",
      "target": "팀",
      "features": "실시간 새로고침, 양방향 동기화(Writeback)"
    }
  ]'::jsonb,
  ARRAY[
    'No More CSV: CRM 데이터 내보내기/붙여넣기 노가다 제거',
    'GPT Copilot: 시트 내에서 자연어로 수식/차트 생성 및 데이터 분류',
    '양방향 동기화: 시트 수정 사항을 CRM 원본에 반영 (Pro)',
    '알림(Alerts): 데이터 변경 시 슬랙 알림 자동화'
  ],
  ARRAY[
    '비싼 가격: 자동 새로고침 위해선 월 $49 필요',
    '종속성: 시트 확장 프로그램 형태'
  ],
  '[
    {"name": "Data Connectors", "description": "Salesforce, HubSpot, SQL DB 연동"},
    {"name": "Auto-Refresh", "description": "데이터 주기적 최신화"},
    {"name": "GPT Copilot", "description": "시트 내 AI 수식 생성"},
    {"name": "GPT Functions", "description": "=GPTX 함수 사용"},
    {"name": "Alerts", "description": "데이터 변경 슬랙/이메일 알림"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "RevOps/영업관리", "badge": "Ops", "reason": "CRM 데이터 엑셀 가공 및 보고"},
      {"target": "마케터", "badge": "Ads", "reason": "광고 데이터 대시보드 구축"},
      {"target": "엑셀 러버", "badge": "Sheet", "reason": "스프레드시트 환경 선호"}
    ],
    "not_recommended": [
      {"target": "단순 AI", "reason": "단순 엑셀 함수 질문은 ChatGPT 무료 충분"},
      {"target": "개인 가계부", "reason": "기업용 연동(CRM)이 주 기능"}
    ]
  }'::jsonb,
  ARRAY[
    '데이터 덮어쓰기: 새로고침 시 기존 데이터 덮어씀 주의',
    'API 제한: 너무 잦은 새로고침은 API 한도 소모'
  ],
  '{
    "privacy_protection": "SOC 2, Encrypted transmission"
  }'::jsonb,
  '[
    {"name": "Supermetrics", "description": "마케팅 데이터 연동 최강자"},
    {"name": "Zapier", "description": "앱 간 데이터 전송 자동화"}
  ]'::jsonb,
  '[
    {"title": "Coefficient: The #1 Google Sheets Extension", "url": "https://www.youtube.com/results?search_query=Coefficient+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Spreadsheet Automation', 'Data Connector', 'Sales Ops'],
  ARRAY['Excel', 'Sheet', 'CRM', 'Salesforce', 'Data'],
  '[
    {"competitor": "Supermetrics", "comparison": "Coefficient allows write-back to CRM, Supermetrics is mostly read-only"},
    {"competitor": "Zapier", "comparison": "Coefficient brings live data into sheets, Zapier moves data between apps"}
  ]'::jsonb,
  ARRAY['실시간 데이터 연동(Salesforce 등)', 'GPT Copilot(수식 생성)', '자동 새로고침', '슬랙 알림', '양방향 동기화(Writeback)']
),

-- 4. Bardeen
(
  'Bardeen',
  '브라우저에서 바로 실행되는 노코드 자동화 툴로, 웹 스크래핑과 AI 에이전트(Magic Box)를 활용해 반복 클릭 업무를 대신해 주는 로봇.',
  'Bardeen AI',
  'https://www.bardeen.ai',
  'https://placehold.co/200x200?text=B', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Chrome/Edge Extension"],
    "target_audience": "Sales, Recruiters, Marketers"
  }'::jsonb,
  'Freemium',
  'Free (로컬 실행) / Professional $15/월',
  '로컬 실행 무제한. 클라우드/AI 실행 시 크레딧 소모.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인",
      "features": "로컬 자동화 무료, 월 100 크레딧"
    },
    {
      "plan": "Professional",
      "price": "$15/월",
      "target": "실무자",
      "features": "월 500+ 크레딧, 고급 스크래핑, 백그라운드"
    }
  ]'::jsonb,
  ARRAY[
    'Frontend Automation: 내 브라우저 화면에서 클릭하듯 작동 (API 없는 사이트 가능)',
    'Scraper: 링크드인 등 웹 데이터 스크래핑이 매우 강력하고 쉬움',
    'Magic Box: 자연어 채팅으로 자동화 워크플로우 생성',
    '비용 효율: 로컬 실행 시 무료 활용 가능'
  ],
  ARRAY[
    '브라우저 의존: 브라우저가 켜져 있어야 작동 (로컬 실행 시)',
    '사이트 변경: UI 변경 시 스크래퍼 유지보수 필요'
  ],
  '[
    {"name": "Magic Box", "description": "자연어 워크플로우 생성"},
    {"name": "Web Scraper", "description": "클릭 몇 번으로 데이터 추출"},
    {"name": "Integration", "description": "Notion, Slack, GSheets 등 연동"},
    {"name": "Right Click Automation", "description": "우클릭 메뉴 실행"},
    {"name": "Background Actions", "description": "탭 비활성 상태 작동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "세일즈/리크루팅", "badge": "Scraping", "reason": "링크드인/인스타 프로필 크롤링"},
      {"target": "정보 수집", "badge": "Data", "reason": "반복적인 웹 데이터 엑셀 정리"},
      {"target": "Zapier 대안", "badge": "NoAPI", "reason": "API 없는 웹사이트 자동화"}
    ],
    "not_recommended": [
      {"target": "서버형 자동화", "reason": "24시간 서버 실행 필요 시 Zapier 추천"},
      {"target": "대량 데이터", "reason": "수만 건 대량 크롤링 시 차단 위험"}
    ]
  }'::jsonb,
  ARRAY[
    '크레딧 확인: Local 실행(무료)과 Cloud 실행(유료) 구분 사용',
    '로그인 상태: 대상 사이트 로그인 필수'
  ],
  '{
    "privacy_protection": "Local processing favored"
  }'::jsonb,
  '[
    {"name": "Instant Data Scraper", "description": "단순 스크래핑 확장 프로그램"},
    {"name": "Zapier", "description": "앱 간 백엔드연동"}
  ]'::jsonb,
  '[
    {"title": "Automate your work with Bardeen AI", "url": "https://www.youtube.com/results?search_query=Bardeen+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Web Scraping', 'Browser Automation', 'Workflow'],
  ARRAY['Scraper', 'Automation', 'Browser', 'No-code', 'AI'],
  '[
    {"competitor": "Zapier", "comparison": "Bardeen runs in browser (frontend), Zapier runs on server (backend)"},
    {"competitor": "UiPath", "comparison": "Bardeen is lightweight browser automation, UiPath is heavy enterprise RPA"}
  ]'::jsonb,
  ARRAY['매직 박스(Magic Box)', '웹 스크래퍼', '브라우저 자동화', '우클릭 실행', '노션/구글시트 연동']
),

-- 5. Lindy.ai
(
  'Lindy.ai',
  '"나만의 AI 직원 채용" — 이메일 관리, 일정 조율, 고객 지원 등 특정 직무를 자율적으로 수행하는 AI 에이전트 플랫폼.',
  'Lindy',
  'https://www.lindy.ai',
  'https://placehold.co/200x200?text=L', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "CEOs, Teams needing AI employees"
  }'::jsonb,
  'Subscription',
  'Starter $49/월',
  '무료 체험 크레딧 제공.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "기본 기능 체험"
    },
    {
      "plan": "Starter",
      "price": "$49/월",
      "target": "개인/사업가",
      "features": "무제한 액션, 개인 비서 활용"
    },
    {
      "plan": "Pro/Team",
      "price": "$119+/월",
      "target": "기업",
      "features": "팀 공유, 맞춤형 린디, API"
    }
  ]'::jsonb,
  ARRAY[
    '자율성(Autonomous): 시키지 않아도 스스로 판단하여 이메일 답장 및 일정 조율',
    '전용 린디(Lindy): 의료 서기, 채용 담당자 등 직무별 특화 에이전트 생성',
    'Trigger: 이벤트(메일 수신 등) 기반 24시간 작동',
    '통합: 캘린더, 메일, 슬랙 등 업무 툴 깊은 연동'
  ],
  ARRAY[
    '비싼 가격: 월 $49 시작으로 비용 부담',
    '설정 난이도: 초기 교육(프롬프트/룰) 필요',
    '오류 가능성: 자율 에이전트의 오작동 주의'
  ],
  '[
    {"name": "AI Executive Assistant", "description": "이메일/일정 자율 관리"},
    {"name": "Specialized Agents", "description": "직무별(채용, CS) 에이전트"},
    {"name": "Triggers & Actions", "description": "자율 행동 규칙 설정"},
    {"name": "Voice Interaction", "description": "음성 지시 가능"},
    {"name": "App Integrations", "description": "50+ 업무 앱 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "1인 기업가", "badge": "CEO", "reason": "일정 관리 및 비서 업무 자동화"},
      {"target": "CS 자동화", "badge": "Support", "reason": "단순 문의 자동 응대"},
      {"target": "아웃바운드 영업", "badge": "Sales", "reason": "콜드 메일 및 미팅 예약 자동화"}
    ],
    "not_recommended": [
      {"target": "단순 챗봇", "reason": "ChatGPT가 더 저렴"},
      {"target": "통제광", "reason": "자율 행동이 불안한 경우"}
    ]
  }'::jsonb,
  ARRAY[
    'Human in the loop: 초기엔 "검토 후 발송" 모드로 설정 권장',
    '권한 부여: 업무용 계정 위주 연동'
  ],
  '{
    "privacy_protection": "SOC 2 compliant standard"
  }'::jsonb,
  '[
    {"name": "HyperWrite", "description": "웹 브라우징 중심 개인 비서"},
    {"name": "Zapier Central", "description": "자동화 기반 에이전트 봇"}
  ]'::jsonb,
  '[
    {"title": "Meet Lindy: Your AI Employee", "url": "https://www.youtube.com/results?search_query=Lindy.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['AI Agent', 'Executive Assistant', 'Autonomous'],
  ARRAY['Agent', 'Assistant', 'Automation', 'Email', 'Calendar'],
  '[
    {"competitor": "Zapier", "comparison": "Lindy is an autonomous agent, Zapier is a linear automation tool"},
    {"competitor": "ChatGPT", "comparison": "Lindy integrates deeply with tools and acts autonomously, ChatGPT is primarily chat"}
  ]'::jsonb,
  ARRAY['AI 비서(이메일/일정)', '자율 에이전트', '직무별 특화(채용/CS)', '트리거 자동화', '음성 지시']
);
