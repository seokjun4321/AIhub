-- Insert Motion, Beautiful.ai, Autoppt, DeepSeek into ai_models table
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
-- 1. Motion
(
  'Motion',
  '할 일(Task)과 일정(Calendar)을 입력하면, 마감 기한과 우선순위에 맞춰 "오늘 하루 스케줄을 AI가 자동으로 짜주는" 자율 주행 플래너.',
  'Motion',
  'https://www.usemotion.com',
  'https://cdn.brandfetch.io/idE-rV6Q-I/theme/dark/logo.svg', -- Found via brandfetch
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web", "Mobile", "Chrome Extension"],
    "target_audience": "ADHD, Managers, Busy Professionals"
  }'::jsonb,
  'Subscription',
  'Individual $19/월',
  '무료 플랜 없음 (7일 무료 체험).',
  '[
    {
      "plan": "Individual",
      "price": "$19/월",
      "target": "개인",
      "features": "AI 오토 스케줄링, 프로젝트 관리"
    },
    {
      "plan": "Team",
      "price": "$12/인/월",
      "target": "팀",
      "features": "팀원 일정 조율, 업무 할당"
    }
  ]'::jsonb,
  ARRAY[
    'Happiness Algorithm: 돌발 일정 발생 시 남은 업무 자동 재배치',
    'Deep Work: 자잘한 미팅 사이 틈새 피하고 덩어리 집중 시간 확보',
    'Booking: Calendly 같은 일정 예약 링크 기능 내장',
    '통합: 할 일과 캘린더가 하나로 합쳐져 관리 용이'
  ],
  ARRAY[
    '비싼 가격: 월 2~4만 원대로 경쟁 툴 대비 고가',
    '적응 기간: AI 통제를 따르는 것에 대한 적응 필요'
  ],
  '[
    {"name": "Auto-Scheduling", "description": "마감일 기반 자동 배정"},
    {"name": "Rescheduling", "description": "밀린 업무 자동 재배치"},
    {"name": "Meeting Scheduler", "description": "예약 링크 생성"},
    {"name": "Project Management", "description": "칸반/리스트 뷰"},
    {"name": "Focus Time", "description": "방해 금지 모드"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "ADHD 성향", "badge": "ADHD", "reason": "우선순위 결정 및 실행 강제"},
      {"target": "미팅 많은 직군", "badge": "Meeting", "reason": "틈새 시간 업무 자동 채우기"},
      {"target": "프리랜서", "badge": "Freelance", "reason": "여러 마감 기한 동시 관리"}
    ],
    "not_recommended": [
      {"target": "단순 기록용", "reason": "구글 캘린더나 노션 권장"},
      {"target": "유동적 업무", "reason": "계획이 무의미한 현장직"}
    ]
  }'::jsonb,
  ARRAY[
    '설정 디테일: 업무 시간(9-6) 정확히 설정',
    '쪼개기: 큰 업무는 1~2시간 단위로 쪼개서 입력'
  ],
  '{
    "privacy_protection": "Calendar read/write access required"
  }'::jsonb,
  '[
    {"name": "Reclaim.ai", "description": "구글 캘린더 중심 무료 대안"},
    {"name": "FlowSavvy", "description": "저렴한 대안"}
  ]'::jsonb,
  '[
    {"title": "Motion: The AI Exec that manages your day", "url": "https://www.youtube.com/results?search_query=Motion+app+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['AI Planner', 'Calendar', 'Task Manager'],
  ARRAY['Calendar', 'Task', 'Motion', 'Planner', 'AI'],
  '[
    {"competitor": "Reclaim.ai", "comparison": "Motion replaces your calendar UI, Reclaim works inside Google Calendar"},
    {"competitor": "Notion", "comparison": "Motion schedules tasks for you, Notion just lists them"}
  ]'::jsonb,
  ARRAY['AI 오토 스케줄링', '자동 리스케줄링', '미팅 스케줄러(예약)', '프로젝트 관리(칸반)', '집중 시간(Deep Work)']
),

-- 2. Beautiful.ai
(
  'Beautiful.ai',
  '"디자인 감각 제로여도 괜찮아" — 슬라이드 내용을 입력하면 레이아웃, 색상, 정렬을 AI가 강제로 예쁘게 맞춰주는 제약 기반 프레젠테이션 툴.',
  'Beautiful.ai',
  'https://www.beautiful.ai',
  'https://cdn.brandfetch.io/idl9C88C03/theme/dark/logo.svg', -- Found via brandfetch
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "PowerPoint Add-in"],
    "target_audience": "Sales, Marketing, Startups"
  }'::jsonb,
  'Subscription',
  'Pro $12/월',
  '무료 플랜 없음 (14일 체험).',
  '[
    {
      "plan": "Pro",
      "price": "$12/월",
      "target": "개인",
      "features": "무제한 슬라이드, AI 생성"
    },
    {
      "plan": "Team",
      "price": "$40/인/월",
      "target": "팀",
      "features": "팀 라이브러리, 중앙 결제"
    },
    {
      "plan": "Ad-hoc",
      "price": "$45 (1회)",
      "target": "일회성",
      "features": "단일 프로젝트 다운로드"
    }
  ]'::jsonb,
  ARRAY[
    'Smart Slide: 내용 입력 시 레이아웃 자동 최적화 (줄 맞춤 불필요)',
    'DesignerBot: 프롬프트로 전체 슬라이드 덱 초안 1분 생성',
    '제약의 미학: 디자인 가이드라인 강제 적용으로 통일성 유지',
    '차트 애니메이션: 수치 입력 시 부드러운 애니메이션 자동 적용'
  ],
  ARRAY[
    '자유도 부족: 정해진 그리드 외 픽셀 단위 배치 불가',
    'PPT 호환성: 내보내기 시 스마트 기능 깨지거나 이미지화 가능성'
  ],
  '[
    {"name": "DesignerBot", "description": "텍스트로 전체 덱 생성"},
    {"name": "Smart Templates", "description": "지능형 레이아웃"},
    {"name": "Stock Library", "description": "이미지/아이콘 제공"},
    {"name": "Analytics", "description": "조회수 추적 (Pro)"},
    {"name": "PowerPoint Export", "description": "PPT 변환"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "영업 제안서", "badge": "Sales", "reason": "빠르고 신뢰감 있는 디자인"},
      {"target": "디자인 똥손", "badge": "Design", "reason": "색 조합/배치 AI 자동화"},
      {"target": "스타트업 IR", "badge": "Pitch", "reason": "세련된 피치덱 제작"}
    ],
    "not_recommended": [
      {"target": "디자이너", "reason": "픽셀 단위 정밀 제어 불가"},
      {"target": "애니메이션 장인", "reason": "화려한 PPT 효과 미지원"}
    ]
  }'::jsonb,
  ARRAY[
    '결제 주기: 월 결제($45)보다 연간 결제($12/월)가 훨씬 저렴',
    'PPT 변환: 폰트 깨짐 주의, PDF나 웹 링크 공유 권장'
  ],
  '{
    "privacy_protection": "Enterprise SSO available"
  }'::jsonb,
  '[
    {"name": "Gamma", "description": "문서 기반 생성 및 유연성 우수"},
    {"name": "Canva", "description": "높은 자유도와 다양한 템플릿"}
  ]'::jsonb,
  '[
    {"title": "Beautiful.ai: The First AI Presentation Maker", "url": "https://www.youtube.com/results?search_query=Beautiful.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Presentation', 'AI Slides', 'Pitch Deck'],
  ARRAY['Presentation', 'Slide', 'PPT', 'Design', 'AI'],
  '[
    {"competitor": "Gamma", "comparison": "Beautiful.ai creates traditional slides, Gamma creates web-doc slides"},
    {"competitor": "PowerPoint", "comparison": "Beautiful.ai forces good design constraints, PowerPoint allows anything"}
  ]'::jsonb,
  ARRAY['디자이너봇(DesignerBot)', '스마트 슬라이드(자동정렬)', '스톡 라이브러리', 'PPT 내보내기', '차트 애니메이션']
),

-- 3. Autoppt
(
  'Autoppt',
  '복잡한 기능 없이 주제만 입력하면 1분 안에 파워포인트(PPTX) 파일 구조를 잡아주는 초간편 AI 프레젠테이션 생성기.',
  'AutoPPT',
  'https://autoppt.com',
  'https://placehold.co/200x200?text=A', -- Placeholder as strict logo not found
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Students, Office Workers"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Pay-per-download',
  '무료 생성 횟수 제한. 워터마크 있음.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "기본 템플릿, 제한적 슬라이드"
    },
    {
      "plan": "Pro",
      "price": "Micro-payment",
      "target": "학생",
      "features": "무제한 생성, 워터마크 제거"
    }
  ]'::jsonb,
  ARRAY[
    '심플함: 주제 입력 -> 다운로드 끝 (가장 간편)',
    'PPTX 호환: 결과물이 바로 파워포인트 파일로 생성',
    '속도: 매우 빠른 생성 속도'
  ],
  ARRAY[
    '디자인 퀄리티: 기본 템플릿 수준으로 세련미 부족',
    '기능 제한: 고급 차트나 애니메이션 기능 없음'
  ],
  '[
    {"name": "Text to PPT", "description": "주제로 PPT 생성"},
    {"name": "Outline Editor", "description": "목차 수정"},
    {"name": "Image Search", "description": "이미지 자동 삽입"},
    {"name": "Export to PPTX", "description": "PPT 원본 다운로드"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "대학생 과제", "badge": "Student", "reason": "교양 과제용 뼈대 생성"},
      {"target": "초안 작성", "badge": "Draft", "reason": "백지 상태 탈출"},
      {"target": "파워포인트 필수", "badge": "PPTX", "reason": "pptx 파일 제출 필요 시"}
    ],
    "not_recommended": [
      {"target": "중요한 발표", "reason": "디자인 퀄리티 부족"},
      {"target": "복잡한 데이터", "reason": "차트 연동 불가"}
    ]
  }'::jsonb,
  ARRAY[
    '내용 검증: AI 생성 텍스트는 일반적이므로 구체적 사례로 교체 필수',
    '이미지 저작권: 자동 삽입 이미지 저작권 확인'
  ],
  '{
    "privacy_protection": "Generating and downloading focused"
  }'::jsonb,
  '[
    {"name": "Gamma", "description": "더 예쁜 디자인"},
    {"name": "SlidesAI.io", "description": "구글 슬라이드 연동"}
  ]'::jsonb,
  '[
    {"title": "How to create PPT with AI", "url": "https://www.youtube.com/results?search_query=AutoPPT+tutorial", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['PPT Generator', 'PowerPoint AI', 'Simple'],
  ARRAY['PPT', 'PowerPoint', 'Generator', 'Auto', 'Slide'],
  '[
    {"competitor": "Beautiful.ai", "comparison": "Autoppt works directly with .pptx files, Beautiful.ai is a separate platform"},
    {"competitor": "Gamma", "comparison": "Autoppt is simpler/faster, Gamma is more feature-rich"}
  ]'::jsonb,
  ARRAY['텍스트 투 PPT', '개요(목차) 편집기', '이미지 자동 검색', 'PPTX 다운로드', '간편 생성']
),

-- 4. DeepSeek
(
  'DeepSeek',
  '"가격 파괴자, 성능 괴물" — OpenAI o1급의 추론 능력(R1)과 GPT-4급 성능(V3)을 1/10도 안 되는 가격에 제공하는 중국발 오픈소스 AI 모델.',
  'DeepSeek',
  'https://www.deepseek.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/DeepSeek_logo.svg/100px-DeepSeek_logo.svg.png', -- Common wiki logo
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "API", "Mobile"],
    "target_audience": "Developers, Researchers, Cost-conscious Users"
  }'::jsonb,
  'Free',
  'Free Chat / API Usage',
  '웹사이트(Chat)에서 V3/R1 모델 무료 사용.',
  '[
    {
      "plan": "Chat (Web)",
      "price": "Free",
      "target": "일반인",
      "features": "DeepSeek-V3/R1 모델 무료, 검색 포함"
    },
    {
      "plan": "API",
      "price": "Usage",
      "target": "개발자",
      "features": "입력 $0.14 / 출력 $0.28 (1M 토큰당)"
    }
  ]'::jsonb,
  ARRAY[
    '압도적 가성비: GPT-4o 대비 1/20 수준의 저렴한 API 가격',
    'DeepSeek-R1 (Reasoning): OpenAI o1급의 심층 추론(CoT) 능력',
    '코딩 능력: 코드 생성 및 디버깅 성능 탁월',
    '오픈 웨이트: 모델 가중치 공개로 로컬 설치 가능'
  ],
  ARRAY[
    '검열/보안 우려: 중국 개발사 이슈 및 데이터 보안 우려',
    '서버 불안정: 사용자 폭주로 인한 접속 장애 빈번'
  ],
  '[
    {"name": "DeepSeek-V3", "description": "GPT-4o급 범용 모델"},
    {"name": "DeepSeek-R1", "description": "심층 추론(CoT) 모델"},
    {"name": "Context Caching", "description": "프롬프트 캐싱 할인"},
    {"name": "FIM", "description": "코드 중간 채우기"},
    {"name": "Web Search", "description": "실시간 검색 반영"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "개발자", "badge": "Dev", "reason": "Cursor/IDE 연동으로 코딩 비용 절감"},
      {"target": "수학/과학도", "badge": "Math", "reason": "복잡한 수식 증명 및 논리 (R1)"},
      {"target": "스타트업", "badge": "Startup", "reason": "저렴한 API로 서비스 구축"}
    ],
    "not_recommended": [
      {"target": "보안 극민감", "reason": "국가 기밀/극비 기술은 로컬 권장"},
      {"target": "창의적 글쓰기", "reason": "감성적 글쓰기는 Claude 추천"}
    ]
  }'::jsonb,
  ARRAY[
    'API 연동: OpenAI Compatible 모드로 URL 변경하여 사용',
    '생각 과정: R1 모델의 긴 Thought process 접기 가능'
  ],
  '{
    "privacy_protection": "Use local deployment (Ollama) for sensitive data"
  }'::jsonb,
  '[
    {"name": "OpenAI o1", "description": "원조 추론 모델 (비쌈)"},
    {"name": "Claude 3.5 Sonnet", "description": "코딩/글쓰기 밸런스 우수"}
  ]'::jsonb,
  '[
    {"title": "DeepSeek-V3 & R1 Review", "url": "https://www.youtube.com/results?search_query=DeepSeek+official", "platform": "YouTube"}
  ]'::jsonb,
  '3.0',
  ARRAY['LLM', 'Open Source', 'Reasoning Model', 'Coding AI'],
  ARRAY['AI', 'Model', 'DeepSeek', 'Chat', 'Code'],
  '[
    {"competitor": "OpenAI o1", "comparison": "DeepSeek R1 matches o1 reasoning at a fraction of the cost"},
    {"competitor": "GPT-4o", "comparison": "DeepSeek V3 is cheaper and comparable in coding, GPT-4o is better at general knowledge"}
  ]'::jsonb,
  ARRAY['딥시크-V3(범용)', '딥시크-R1(추론)', '컨텍스트 캐싱', '코드 중간 채우기(FIM)', '오픈 웨이트(로컬설치)']
);
