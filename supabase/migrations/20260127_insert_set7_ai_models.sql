-- Insert Descript, Windsurf, Manus, Bolt.new, Lovable, Hugging Face into ai_models table
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
-- 1. Descript
(
  'Descript',
  '영상/음성 편집을 워드 문서 편집하듯이 텍스트를 지우고 고치면 원본 미디어도 함께 수정되는 "문서 기반" 올인원 편집기.',
  'Descript',
  'https://www.descript.com',
  'https://upload.wikimedia.org/wikipedia/commons/e/e6/Descript_logo.svg', -- SVG likely preferred or PNG preview
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Desktop App (Mac/Windows)", "Web"],
    "target_audience": "Podcasters, YouTubers"
  }'::jsonb,
  'Freemium',
  'Free (1시간/월) / Creator $12/월',
  '월 1시간 내보내기 무료. 720p 제한.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "입문자",
      "features": "월 1시간, 720p, 기본 AI 기능"
    },
    {
      "plan": "Creator",
      "price": "$12/월",
      "target": "팟캐스터",
      "features": "월 10시간, 4K 내보내기, 워터마크 제거"
    },
    {
      "plan": "Pro",
      "price": "$24/월",
      "target": "유튜버",
      "features": "월 30시간, Underlord(AI) 무제한, 오버덥"
    }
  ]'::jsonb,
  ARRAY[
    '텍스트 편집 방식: 텍스트 삭제/수정이 영상 컷편집으로 즉시 반영',
    'Underlord (AI): 편집, 자막, 사운드 보정 등 자동화 비서',
    'Studio Sound: 노이즈 캔슬링 및 음질 향상 (업계 최고 수준)',
    'Overdub: 텍스트 입력으로 내 목소리 더빙 생성 (Voice Clone)'
  ],
  ARRAY[
    '한글 오타: 한국어 인식 오타 수정 과정 필요',
    '무거운 앱: 긴 영상 작업 시 리소스 소모 큼'
  ],
  '[
    {"name": "Text-Based Editing", "description": "텍스트 수정으로 컷편집"},
    {"name": "Underlord AI", "description": "멀티캠/자막/쇼츠 자동화 비서"},
    {"name": "Studio Sound", "description": "원클릭 음질 향상"},
    {"name": "Overdub", "description": "AI 음성 생성 (Voice Clone)"},
    {"name": "Eye Contact", "description": "시선 교정 AI"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "인터뷰 편집", "badge": "Editing", "reason": "불필요한 잡담 텍스트로 빠르게 삭제"},
      {"target": "오디오 품질", "badge": "Sound", "reason": "안 좋은 마이크 음질 살리기"},
      {"target": "팟캐스트", "badge": "Podcast", "reason": "편집과 자막 동시 해결"}
    ],
    "not_recommended": [
      {"target": "화려한 예능", "reason": "특수 효과 많은 한국 예능 스타일 부적합"},
      {"target": "정밀 프레임", "reason": "미세 프레임 조절보다 내용 위주 편집용"}
    ]
  }'::jsonb,
  ARRAY[
    '원본 보존: 텍스트 지워도 Cmd+Z 또는 스크립트 복구 가능',
    '내보내기: 클라우드 렌더링 시간 소요 감안'
  ],
  '{
    "privacy_protection": "Overdub requires voice consent script"
  }'::jsonb,
  '[
    {"name": "Vrew", "description": "한국어 자막/편집 특화 국산 툴"},
    {"name": "Premiere Pro", "description": "정밀 편집 필요 시"}
  ]'::jsonb,
  '[
    {"title": "Meet Descript: The All-in-One Video & Audio Editor", "url": "https://www.youtube.com/results?search_query=Descript+official", "platform": "YouTube"}
  ]'::jsonb,
  '5.0',
  ARRAY['Video Editor', 'Podcast', 'Text-based Editing'],
  ARRAY['Video', 'Audio', 'Editor', 'AI', 'Podcast'],
  '[
    {"competitor": "Premiere Pro", "comparison": "Descript is document-based and easier for speech, Premiere is timeline-based and better for visuals"},
    {"competitor": "Vrew", "comparison": "Descript has better audio processing (Studio Sound), Vrew has better Korean support"}
  ]'::jsonb,
  ARRAY['텍스트 기반 영상 편집', '스튜디오 사운드(음질향상)', '언더로드(AI 비서)', '오버덥(AI 성우)', '아이 컨택(시선교정)']
),

-- 2. Windsurf
(
  'Windsurf',
  'AI 코딩 도구의 강자 Codeium이 만든 차세대 IDE로, 개발자의 의도와 코드 흐름(Flow)을 깊이 이해하는 "Cascades" 기능이 핵심인 에디터.',
  'Codeium',
  'https://codeium.com/windsurf',
  'https://placehold.co/200x200?text=W', -- Placeholder (common logo hard to link directly)
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Windows", "macOS", "Linux"],
    "target_audience": "Developers, VS Code Users"
  }'::jsonb,
  'Freemium',
  'Free (개인 무료) / Pro $15/월',
  '개인 사용자 영구 무료 (기본 모델 무제한).',
  '[
    {
      "plan": "Individual",
      "price": "Free",
      "target": "개인 개발자",
      "features": "Flows/Cascades 무료, 기본 모델 무제한"
    },
    {
      "plan": "Pro",
      "price": "$15/월",
      "target": "헤비 유저",
      "features": "GPT-4o/Claude 3.5 무제한급, 더 긴 컨텍스트"
    }
  ]'::jsonb,
  ARRAY[
    'Cascades (Flows): 변수 수정 시 연관 파일 추적하여 수정 제안 (Deep Context)',
    'Deep Context: 전체 프로젝트 구조 이해 및 답변 능력 탁월',
    'VS Code 호환: VS Code 포크 기반으로 확장 프로그램 완벽 호환',
    '가격 정책: 개인 무료 혜택이 매우 관대함'
  ],
  ARRAY[
    '인지도: Cursor 대비 커뮤니티 자료 적음',
    '무거운 구동: 깊은 문맥 분석 시 리소스 소모'
  ],
  '[
    {"name": "Cascades", "description": "다중 파일 문맥 기반 자동 수정"},
    {"name": "Supercomplete", "description": "코드 로직 예측 자동 완성"},
    {"name": "Context-Aware Chat", "description": "프로젝트 맥락 이해 채팅"},
    {"name": "Terminal AI", "description": "자연어 터미널 명령어 변환"},
    {"name": "Model Selection", "description": "GPT-4o, Claude 3.5 선택"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "Cursor 대안", "badge": "Free", "reason": "Cursor 무료량 부족 시"},
      {"target": "복잡한 프로젝트", "badge": "Flow", "reason": "파일 간 의존성 복잡할 때 Cascades 유리"},
      {"target": "개인 개발자", "badge": "Solo", "reason": "AI 페어 프로그래밍 필요"}
    ],
    "not_recommended": [
      {"target": "JetBrains 유저", "reason": "VS Code 환경 낯설면 불편"},
      {"target": "폐쇄망", "reason": "클라우드 필수"}
    ]
  }'::jsonb,
  ARRAY[
    '인덱싱: 초기 인덱싱 완료까지 대기 필요',
    '단축키: Cmd+I (Inline Edit) 적극 활용'
  ],
  '{
    "privacy_protection": "Zero Retention policy for Enterprise"
  }'::jsonb,
  '[
    {"name": "Cursor", "description": "가장 대중적인 AI 에디터 1위"},
    {"name": "GitHub Copilot", "description": "표준 연동성 우수"}
  ]'::jsonb,
  '[
    {"title": "Introducing Windsurf Editor", "url": "https://www.youtube.com/results?search_query=Windsurf+Codeium+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['IDE', 'Code Editor', 'AI Coding', 'VS Code'],
  ARRAY['Code', 'IDE', 'Windsurf', 'Codeium', 'Agent'],
  '[
    {"competitor": "Cursor", "comparison": "Windsurf Cascades offers deeper context awareness than basic Composer"},
    {"competitor": "Copilot", "comparison": "Windsurf is a full IDE, Copilot is just an extension"}
  ]'::jsonb,
  ARRAY['Cascades(심층 문맥 수정)', '슈퍼컴플리트(예측 완성)', '터미널 AI', '전체 프로젝트 이해', 'VS Code 완벽 호환']
),

-- 3. Manus
(
  'Manus',
  '채팅만 하는 게 아니라, 실제 사람처럼 웹 브라우저를 켜고 클릭하고 입력하며 복잡한 업무를 끝까지 수행하는 "자율 AI 에이전트".',
  'Manus AI',
  'https://manus.ai',
  'https://placehold.co/200x200?text=M', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web/Desktop Agent"],
    "target_audience": "Early Adopters, Researchers"
  }'::jsonb,
  'Waitlist',
  '초대 기반 / High-tier Paid (예상)',
  '현재 대기 명단 등록 중.',
  '[
    {
      "plan": "Waitlist",
      "price": "Free/Invite",
      "target": "초대받은 자",
      "features": "베타 체험"
    },
    {
      "plan": "Pro",
      "price": "$50+ (예상)",
      "target": "전문가",
      "features": "복잡한 워크플로우 수행"
    }
  ]'::jsonb,
  ARRAY[
    '실행력(Action): 실제 사이트 접속, 클릭, 장바구니 담기 등 물리적 행동 수행',
    '자율성: 문제 발생 시 우회 방법 스스로 판단 (Reasoning)',
    'No API Needed: API 없는 사이트도 UI 보고 조작 가능'
  ],
  ARRAY[
    '속도: 브라우저 조작으로 인해 단순 API보다 느림',
    '접근성: 아직 베타/웨이팅리스트 단계',
    '오류: UI 변경 시 멈춤 가능성'
  ],
  '[
    {"name": "Autonomous Browsing", "description": "직접 브라우저 제어"},
    {"name": "Complex Task", "description": "다단계 업무(조사->정리->전송) 수행"},
    {"name": "UI Interaction", "description": "클릭, 타이핑, 파일 업로드"},
    {"name": "Reasoning", "description": "오류 상황 판단 및 해결"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "리서처", "badge": "Research", "reason": "노가다성 정보 수집/정리"},
      {"target": "여행 계획", "badge": "Travel", "reason": "여러 사이트 가격 비교 및 예약"},
      {"target": "얼리어답터", "badge": "Agent", "reason": "자율 에이전트 경험"}
    ],
    "not_recommended": [
      {"target": "실시간성", "reason": "빠른 검색은 Perplexity 추천"},
      {"target": "금융 거래", "reason": "결제는 아직 신중 필요"}
    ]
  }'::jsonb,
  ARRAY[
    '감독 필요: 작동 화면 모니터링 권장',
    '개인정보: 민감 정보 입력 주의'
  ],
  '{
    "privacy_protection": "Sandboxed browser environment"
  }'::jsonb,
  '[
    {"name": "MultiOn", "description": "브라우저 에이전트 경쟁자"},
    {"name": "Rabbit R1", "description": "하드웨어 기반 에이전트"}
  ]'::jsonb,
  '[
    {"title": "Manus AI Demo", "url": "https://www.youtube.com/results?search_query=Manus+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['AI Agent', 'Autonomous Browser', 'Action Model'],
  ARRAY['Agent', 'Browser', 'Automation', 'Manus', 'Action'],
  '[
    {"competitor": "MultiOn", "comparison": "Manus claims better reasoning for complex errors"},
    {"competitor": "ChatGPT", "comparison": "Manus acts on the web, ChatGPT reads text"}
  ]'::jsonb,
  ARRAY['자율 브라우징(Autonomous)', '복잡한 태스크 수행', 'UI 상호작용(클릭/타이핑)', '문제 해결 추론(Reasoning)', 'API 없는 사이트 조작']
),

-- 4. Bolt.new
(
  'Bolt.new',
  '"프롬프트 한 줄로 풀스택 앱 완성" — 브라우저 안에서 개발 환경 설정부터 배포까지 한 번에 끝내는 WebContainer 기반 AI 개발 도구.',
  'StackBlitz',
  'https://bolt.new',
  'https://bolt-public-pages.pages.dev/public-page-assets/og-image-default.png', -- Found specific URL
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Prototypers, Full Stack Developers"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Pro $20/월',
  '기본 프로젝트 생성 무료. 일일 토큰(수정) 제한.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "찍먹파",
      "features": "일일 토큰 제한, 공개 프로젝트"
    },
    {
      "plan": "Pro",
      "price": "$20/월",
      "target": "앱 메이커",
      "features": "무제한 토큰(Fair use), 비공개 프로젝트"
    }
  ]'::jsonb,
  ARRAY[
    'WebContainers: 브라우저 내에서 Node.js 서버 실제 구동 (설치 불필요)',
    'Full Stack: 프론트/백엔드 로직 동시 생성',
    '즉시 실행: 코드 생성 즉시 프리뷰 및 에러 자동 수정',
    '배포(Deploy): 원클릭으로 실제 URL 생성'
  ],
  ARRAY[
    '토큰 소모: 복잡한 앱 수정 시 토큰 빨리 소진',
    '복잡도 한계: 대규모 서비스보다는 단일 기능 앱에 최적'
  ],
  '[
    {"name": "Prompt to App", "description": "자연어로 풀스택 앱 생성"},
    {"name": "In-browser IDE", "description": "설치 없는 개발 환경"},
    {"name": "Auto-Fix", "description": "에러 자동 분석 및 수정"},
    {"name": "Package Manager", "description": "npm 패키지 설치 지원"},
    {"name": "One-click Deploy", "description": "즉시 클라우드 배포"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "아이디어 뱅크", "badge": "Idea", "reason": "MVP 10분 컷 제작"},
      {"target": "프론트엔드 공부", "badge": "Study", "reason": "AI 코드 보며 구조 학습"},
      {"target": "내부 도구", "badge": "Tool", "reason": "간단한 사내 대시보드/계산기 제작"}
    ],
    "not_recommended": [
      {"target": "대규모 서비스", "reason": "복잡한 DB 설계 및 트래픽 대응용 아님"},
      {"target": "기존 프로젝트", "reason": "새 프로젝트 생성 전용"}
    ]
  }'::jsonb,
  ARRAY[
    '토큰 아끼기: 초기 프롬프트를 매우 구체적으로 작성',
    '데이터 저장: 영구 저장은 Supabase 등 외부 DB 연결 필수'
  ],
  '{
    "privacy_protection": "Sandboxed execution in browser"
  }'::jsonb,
  '[
    {"name": "Lovable", "description": "디자인(UI/UX)에 더 강점"},
    {"name": "Replit Agent", "description": "백엔드 설정에 더 강점"}
  ]'::jsonb,
  '[
    {"title": "Build Full Stack Apps with Bolt.new", "url": "https://www.youtube.com/results?search_query=Bolt.new+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Web App Builder', 'Full Stack AI', 'WebContainer'],
  ARRAY['Code', 'Builder', 'App', 'WebContainer', 'StackBlitz'],
  '[
    {"competitor": "Lovable", "comparison": "Bolt handles backend logic better, Lovable handles UI design better"},
    {"competitor": "Replit", "comparison": "Bolt runs in browser (WebContainer), Replit runs on cloud containers"}
  ]'::jsonb,
  ARRAY['자연어 앱 생성', '브라우저 내 풀스택 구동(WebContainer)', '에러 자동 수정(Auto-Fix)', '원클릭 배포', 'npm 패키지 지원']
),

-- 5. Lovable
(
  'Lovable',
  '"디자이너가 없어도 예쁜 앱 완성" — Bolt.new와 유사하지만, UI/UX 디자인(Shadcn/Tailwind)과 Supabase 연동에 특화된 앱 생성 AI.',
  'Lovable',
  'https://lovable.dev',
  'https://logos-download.com/wp-content/uploads/2025/01/Lovable_Logo_2025_icon-629x640.png', -- Found specific URL
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Prototypers, Designers"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Pro $20/월',
  '기본 프로젝트 생성 무료. 일일 메시지 제한.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "일일 제한 편집, 공개 프로젝트"
    },
    {
      "plan": "Pro",
      "price": "$20/월",
      "target": "앱 메이커",
      "features": "무제한 편집, 비공개 프로젝트, GitHub 연동"
    }
  ]'::jsonb,
  ARRAY[
    '디자인 퀄리티: Shadcn/Tailwind 기반의 예쁘고 트렌디한 UI 기본 적용',
    'Supabase 통합: DB/인증 연결 반자동 지원',
    'GitHub Sync: 생성 코드를 내 깃허브로 푸시하여 독립적 개발 가능',
    '비전 인식: 스케치/스크린샷 업로드로 UI 클론'
  ],
  ARRAY[
    '토큰 제한: 무료 플랜 일일 사용량 적음',
    '복잡한 로직: 백엔드 로직 복잡 시 한계'
  ],
  '[
    {"name": "Design-first Generation", "description": "고퀄리티 UI 자동 생성"},
    {"name": "Supabase Integration", "description": "DB/Auth 연동"},
    {"name": "Image to Code", "description": "스크린샷으로 코딩"},
    {"name": "GitHub Sync", "description": "깃허브로 코드 내보내기"},
    {"name": "Instant Preview", "description": "실시간 미리보기"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "심미주의자", "badge": "Design", "reason": "예쁜 앱이 최우선일 때"},
      {"target": "데이터 앱", "badge": "DB", "reason": "Supabase 연동 앱 제작"},
      {"target": "개발자 협업", "badge": "Dev", "reason": "초안 AI 생성 후 VS Code 마무 리"}
    ],
    "not_recommended": [
      {"target": "완전 무료", "reason": "끝까지 완성하려면 결제 필요"},
      {"target": "파이썬 유저", "reason": "React 생태계 중심"}
    ]
  }'::jsonb,
  ARRAY[
    'DB 연결: AI 가이드대로 API Key 설정 정확히',
    '코드 수정: 깃허브 내보낸 후 외부 수정 시 충돌 주의'
  ],
  '{
    "privacy_protection": "Code ownership belongs to user"
  }'::jsonb,
  '[
    {"name": "Bolt.new", "description": "로직 구현에 강점"},
    {"name": "v0.dev", "description": "UI 컴포넌트 생성 특화"}
  ]'::jsonb,
  '[
    {"title": "Lovable: Building Software with AI", "url": "https://www.youtube.com/results?search_query=Lovable+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['UI Builder', 'App Generator', 'Shadcn UI'],
  ARRAY['UI', 'Design', 'App', 'Builder', 'Supabase'],
  '[
    {"competitor": "Bolt.new", "comparison": "Lovable generates better looking UIs by default, Bolt is better at full-stack logic"},
    {"competitor": "v0", "comparison": "Lovable builds full apps with logic, v0 is mainly for UI components"}
  ]'::jsonb,
  ARRAY['고퀄리티 UI 생성(Shadcn)', 'Supabase 자동 연동', '깃허브 동기화', '이미지 투 코드', '실시간 미리보기']
),

-- 6. Hugging Face
(
  'Hugging Face',
  '전 세계 모든 오픈소스 AI 모델(Llama 3, Mistral, FLUX 등)과 데이터셋이 모여 있는 "AI계의 깃허브(GitHub)".',
  'Hugging Face',
  'https://huggingface.co',
  'https://img.logokit.com/huggingface.co', -- Provided embedding URL, using as source
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Optional",
    "platforms": ["Web", "Python Lib"],
    "target_audience": "AI Developers, Data Scientists"
  }'::jsonb,
  'Open Source',
  'Free (기본) / Pro $9/월',
  '모델/데이터셋 다운로드 무제한. Spaces 호스팅 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개발자",
      "features": "모델/데이터 다운로드, CPU Spaces"
    },
    {
      "plan": "PRO",
      "price": "$9/월",
      "target": "헤비 유저",
      "features": "ZeroGPU 할당량 증가, 배지"
    },
    {
      "plan": "Inference",
      "price": "Usage",
      "target": "서비스",
      "features": "전용 GPU(A100 등) 시간당 과금"
    }
  ]'::jsonb,
  ARRAY[
    '모든 모델 존재: 최신 오픈소스 모델이 가장 먼저 올라오는 곳',
    'Spaces (데모): 설치 없이 웹에서 최신 AI 모델 체험 가능',
    'Transformers: 표준 파이썬 라이브러리로 호환성 최고',
    'ZeroGPU: 무료 GPU 할당 기회 제공'
  ],
  ARRAY[
    '개발자 중심: 일반인을 위한 서비스가 아님 (재료 시장)',
    '컴퓨팅 비용: 무거운 모델 구동 시 고사양 GPU 비용 필요'
  ],
  '[
    {"name": "Models", "description": "100만+ 오픈소스 모델 호스팅"},
    {"name": "Datasets", "description": "다양한 학습용 데이터셋"},
    {"name": "Spaces", "description": "AI 웹 데모 앱 호스팅"},
    {"name": "Inference Endpoints", "description": "AI API 서버 구축"},
    {"name": "Transformers Lib", "description": "표준 AI 라이브러리"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "AI 개발자", "badge": "Dev", "reason": "모델 탐색/파이튜닝 필수 코스"},
      {"target": "얼리어답터", "badge": "New", "reason": "최신 모델 Spaces에서 체험"},
      {"target": "데이터 분석가", "badge": "Data", "reason": "학습용 데이터셋 확보"}
    ],
    "not_recommended": [
      {"target": "완전 비개발자", "reason": "코드 없이 쓰는 완제품 서비스 아님"}
    ]
  }'::jsonb,
  ARRAY[
    '라이선스: 모델별 상업적 이용 가능 여부(Apache 2.0 등) 확인',
    'Space 절전: 무료 데모는 미사용 시 Sleep 모드 전환'
  ],
  '{
    "privacy_protection": "Private repos available"
  }'::jsonb,
  '[
    {"name": "GitHub", "description": "코드는 깃허브, 모델은 허깅페이스"},
    {"name": "Kaggle", "description": "데이터셋 및 경쟁 중심"}
  ]'::jsonb,
  '[
    {"title": "What is Hugging Face?", "url": "https://www.youtube.com/results?search_query=Hugging+Face+official", "platform": "YouTube"}
  ]'::jsonb,
  '5.0',
  ARRAY['Open Source', 'LLM', 'Datasets', 'Spaces'],
  ARRAY['AI', 'Model', 'Hosting', 'Data', 'Python'],
  '[
    {"competitor": "GitHub", "comparison": "Hugging Face is optimized for large model files (Git LFS), GitHub for code"},
    {"competitor": "Kaggle", "comparison": "Hugging Face has more state-of-the-art models, Kaggle has better competitions"}
  ]'::jsonb,
  ARRAY['오픈소스 모델 저장소', '데이터셋 허브', 'Spaces(웹 데모 호스팅)', '트랜스포머 라이브러리', 'Inference API']
);
