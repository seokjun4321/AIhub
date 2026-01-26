-- Insert Grok, Mistral, Microsoft Copilot, Hume AI into ai_models table
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
-- 1. Grok
(
  'Grok',
  'X(구 트위터)의 실시간 데이터를 독점적으로 학습하여, 가장 최신의 트렌드와 뉴스를 거침없이(Fun Mode) 답변해 주는 일론 머스크의 AI.',
  'xAI',
  'https://x.com/i/grok',
  'https://upload.wikimedia.org/wikipedia/commons/1/18/Logo_Grok_AI_%282025%29.png', -- Wikimedia commons
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "Mobile"],
    "target_audience": "Marketers, Investors"
  }'::jsonb,
  'Subscription',
  'X Premium+ $16/월 (approx)',
  '무료 플랜 제한적 (유료 전용).',
  '[
    {
      "plan": "Premium+",
      "price": "$16/월",
      "target": "헤비 유저",
      "features": "Grok-2/3 무제한, 광고 제거"
    }
  ]'::jsonb,
  ARRAY[
    'Real-time Access: X(트위터) 실시간 피드 기반 속보 분석',
    'Fun Mode: 정치적 올바름(PC) 없는 풍자와 유머 답변',
    'Image Generation: FLUX 기반의 검열 자유로운 고퀄리티 이미지 생성',
    'Grok Vision: 이미지 맥락 및 밈(Meme) 해석 능력'
  ],
  ARRAY[
    '비싼 가격: X Premium+ 구독 필수',
    '정보 편향: 트위터 여론 기반으로 루머 섞일 위험'
  ],
  '[
    {"name": "Real-time News", "description": "X 게시물 기반 실시간 정보"},
    {"name": "Fun Mode", "description": "유머러스한 답변 스타일"},
    {"name": "Image Generation", "description": "FLUX 기반 이미지 생성"},
    {"name": "Post Analysis", "description": "트윗 성향 분석"},
    {"name": "Code Assistant", "description": "코딩 답변 가능"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "트렌드 마케터", "badge": "Trend", "reason": "SNS 실시간 이슈/밈 파악"},
      {"target": "주식/코인 투자", "badge": "Invest", "reason": "실시간 뉴스 및 대중 반응 확인"},
      {"target": "유머 감각", "badge": "Fun", "reason": "친구 같은 농담 따먹기"}
    ],
    "not_recommended": [
      {"target": "학술 연구", "reason": "팩트 체크 및 엄근진 작업 부적합"},
      {"target": "SNS 비사용자", "reason": "트위터 안 쓰면 가성비 낮음"}
    ]
  }'::jsonb,
  ARRAY[
    '팩트 체크: 실시간 정보 교차 검증 필수',
    '결제 플랫폼: 앱보다 웹 결제가 저렴'
  ],
  '{
    "privacy_protection": "Public X posts used for training"
  }'::jsonb,
  '[
    {"name": "Perplexity", "description": "정제된 실시간 검색"},
    {"name": "ChatGPT Search", "description": "OpenAI 검색 기능"}
  ]'::jsonb,
  '[
    {"title": "Introducing Grok", "url": "https://www.youtube.com/results?search_query=xAI+Grok+official", "platform": "YouTube"}
  ]'::jsonb,
  '3.0',
  ARRAY['Real-time AI', 'Chatbot', 'Image Generator', 'X'],
  ARRAY['AI', 'Grok', 'X', 'Realtime', 'Chat'],
  '[
    {"competitor": "ChatGPT", "comparison": "Grok is funnier and has real-time X data, ChatGPT is more formal and accurate"},
    {"competitor": "Perplexity", "comparison": "Grok searches tweets, Perplexity searches articles"}
  ]'::jsonb,
  ARRAY['실시간 뉴스 검색(X 데이터)', '재미 모드(Fun Mode)', '이미지 생성(FLUX)', '그록 비전', '트윗 성향 분석']
),

-- 2. Mistral
(
  'Mistral',
  '유럽의 자존심이자 오픈소스 AI의 최강자. 가벼우면서도 GPT-4급 성능을 내는 효율적인 모델과 챗봇 서비스 "Le Chat"을 제공.',
  'Mistral AI',
  'https://mistral.ai',
  'https://logo.svgcdn.com/logos/mistral-ai.png', -- Common logo source
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "API", "Local"],
    "target_audience": "Developers, Privacy-conscious Users"
  }'::jsonb,
  'Freemium',
  'Free (Le Chat) / API Usage',
  'Le Chat에서 최신 모델 무료 사용.',
  '[
    {
      "plan": "Le Chat",
      "price": "Free",
      "target": "일반인",
      "features": "Mistral Large, Codestral 무료"
    },
    {
      "plan": "La Plateforme",
      "price": "Usage",
      "target": "개발자",
      "features": "API 호출, 파인튜닝"
    }
  ]'::jsonb,
  ARRAY[
    'Le Chat (무료): 고성능 모델(Mistral Large) 웹 무료 개방',
    'Codestral: 80개 언어 학습한 코딩 특화 모델',
    '효율성: 모델 사이즈 대비 압도적 성능 (로컬 구동 최적)',
    '유럽 감성: EU 개인정보 보호 기준 준수 및 다국어 강점'
  ],
  ARRAY[
    '부가 기능: 멀티모달(음성/이미지 생성) 기능 상대적 부족',
    '생태계: 플러그인 등 확장성 아직 부족'
  ],
  '[
    {"name": "Le Chat", "description": "무료 웹 챗봇"},
    {"name": "Mistral Large", "description": "플래그십 모델"},
    {"name": "Codestral", "description": "코딩 특화 모델"},
    {"name": "Open Weights", "description": "가중치 공개"},
    {"name": "Canvas", "description": "코드 편집 미리보기"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "무료 유저", "badge": "Free", "reason": "GPT-4급 성능 무료 사용"},
      {"target": "개발자", "badge": "Local", "reason": "로컬 설치(Ollama) 최적화"},
      {"target": "보안 중시", "badge": "Privacy", "reason": "유럽 데이터 보호 준수"}
    ],
    "not_recommended": [
      {"target": "이미지 생성", "reason": "미드저니 등 전용 툴 권장"},
      {"target": "음성 비서", "reason": "음성 대화 기능 약함"}
    ]
  }'::jsonb,
  ARRAY[
    '모델 선택: Le Chat에서 코딩 질문 시 Codestral 선택',
    '로컬 설치: Ollama나 LM Studio 활용'
  ],
  '{
    "privacy_protection": "GDPR compliant, No training on enterprise data"
  }'::jsonb,
  '[
    {"name": "ChatGPT", "description": "범용 대장주"},
    {"name": "Claude", "description": "문학적 글쓰기 강점"}
  ]'::jsonb,
  '[
    {"title": "Mistral AI: The Open Weight Revolution", "url": "https://www.youtube.com/results?search_query=Mistral+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['LLM', 'Open Source', 'Coding AI', 'European AI'],
  ARRAY['AI', 'Mistral', 'Chat', 'Code', 'OpenSource'],
  '[
    {"competitor": "Llama", "comparison": "Mistral is often more efficient (performance per parameter) than Llama"},
    {"competitor": "GPT-4", "comparison": "Mistral Large approaches GPT-4 performace but is cheaper/open"}
  ]'::jsonb,
  ARRAY['르 챗(무료 챗봇)', '미스트랄 라지', '코드스트랄(코딩)', '오픈 웨이트', '캔버스(Canvas)']
),

-- 3. Microsoft Copilot
(
  'Microsoft Copilot',
  '엑셀, PPT, 워드 등 MS 오피스 프로그램에 내장되어 문서 작업을 자동화하고, 윈도우 OS까지 제어하는 마이크로소프트의 AI 비서.',
  'Microsoft',
  'https://copilot.microsoft.com',
  'https://img.logokit.com/copilot', -- Common placeholder or fetched url if specific one found. Using generic capable url.
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Windows", "Office 365", "Web"],
    "target_audience": "Office Workers, Students"
  }'::jsonb,
  'Freemium',
  'Free (Web) / Pro $20/월',
  '웹에서 GPT-4, DALL-E 3 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반인",
      "features": "웹 검색, GPT-4, 이미지 생성"
    },
    {
      "plan": "Pro",
      "price": "$20/월",
      "target": "개인",
      "features": "Office 앱 내장 AI 사용"
    },
    {
      "plan": "M365",
      "price": "$30/인/월",
      "target": "기업",
      "features": "Teams 요약, 보안 강화"
    }
  ]'::jsonb,
  ARRAY[
    '오피스 통합: 워드->PPT, 엑셀 분석 등 문서 작업 자동화 (Pro)',
    '기업 보안: M365 플랜 시 데이터 유출 방지',
    '접근성: 윈도우 단축키(Win+C) 통합',
    '무료 혜택: 웹에서 GPT-4/DALL-E 3 무료 사용'
  ],
  ARRAY[
    '느린 속도: 오피스 내 분석/생성 속도 다소 느림',
    '이중 지출: Pro 결제 외에 Office 구독 별도 필요'
  ],
  '[
    {"name": "Word", "description": "문서 초안 및 요약"},
    {"name": "Excel", "description": "데이터 분석 및 시각화"},
    {"name": "PowerPoint", "description": "문서 기반 슬라이드 생성"},
    {"name": "Teams", "description": "회의 실시간 요약"},
    {"name": "Outlook", "description": "이메일 초안 및 요약"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "직장인", "badge": "Office", "reason": "문서->PPT 변환 등 업무 자동화"},
      {"target": "엑셀 초보", "badge": "Excel", "reason": "자연어로 엑셀 분석"},
      {"target": "팀즈 사용자", "badge": "Meeting", "reason": "회의 내용 요약"}
    ],
    "not_recommended": [
      {"target": "구글 워크스페이스", "reason": "Gemini 추천"},
      {"target": "맥 유저", "reason": "윈도우만큼 매끄럽지 않음"}
    ]
  }'::jsonb,
  ARRAY[
    '라이선스 확인: 기업 계정 라이선스 할당 여부 확인',
    '새 파일: PPT 생성 시 새 파일에서 시작하는 것이 유리'
  ],
  '{
    "privacy_protection": "Commercial Data Protection for business plans"
  }'::jsonb,
  '[
    {"name": "Gemini", "description": "구글 문서 사용자용"},
    {"name": "Gamma", "description": "더 예쁜 PPT 디자인"}
  ]'::jsonb,
  '[
    {"title": "Microsoft Copilot: Your everyday AI companion", "url": "https://www.youtube.com/results?search_query=Microsoft+Copilot+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['AI Assistant', 'Office 365', 'Productivity', 'Windows'],
  ARRAY['Microsoft', 'Copilot', 'Office', 'AI', 'Chat'],
  '[
    {"competitor": "Gemini", "comparison": "Copilot rules MS Office, Gemini rules Google Docs"},
    {"competitor": "ChatGPT", "comparison": "Copilot is built into Windows/Office, ChatGPT is a standalone app"}
  ]'::jsonb,
  ARRAY['워드/엑셀/PPT 통합', '팀즈 회의 요약', '달리3 이미지 생성', '윈도우 OS 통합', '엔터프라이즈 보안']
),

-- 4. Hume AI
(
  'Hume AI',
  '단순한 언어 이해(IQ)를 넘어, 목소리의 톤, 숨소리, 억양에서 "감정(EQ)"을 읽어내고 공감하며 대화하는 세계 최초의 "공감형 음성 AI".',
  'Hume AI',
  'https://www.hume.ai',
  'https://img.logokit.com/hume.ai', -- Sourced from logokit
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Web", "iOS", "API"],
    "target_audience": "Healthcare Apps, CS Teams"
  }'::jsonb,
  'Usage-based',
  'Free Demo / API Cost',
  '웹 데모 무료 체험.',
  '[
    {
      "plan": "Demo",
      "price": "Free",
      "target": "일반인",
      "features": "EVI 실시간 음성 대화 체험"
    },
    {
      "plan": "Developer",
      "price": "Usage",
      "target": "개발자",
      "features": "API 접근, 감정 데이터 출력"
    }
  ]'::jsonb,
  ARRAY[
    '감정 인식(EQ): 목소리 톤/억양 분석하여 감정 상태 파악',
    'EVI: 텍스트 변환 없이 음성-to-음성 처리로 빠른 반응',
    'Prosody Analysis: 53가지 감정 뉘앙스 측정',
    '몰입감: 웃음, 한숨 등 인간적인 비언어적 표현 가능'
  ],
  ARRAY[
    '비용: 텍스트 모델 대비 높은 연산 비용',
    '한국어: 영어만큼 미묘한 감정선 완벽 분석 미지수'
  ],
  '[
    {"name": "EVI", "description": "공감형 음성 인터페이스"},
    {"name": "Expression Measurement", "description": "목소리 감정 측정"},
    {"name": "Voice-to-Voice", "description": "초저지연 대화"},
    {"name": "Interruption Handling", "description": "자연스러운 말 끊기"},
    {"name": "Custom Voice", "description": "브랜드 페르소나 설정"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "멘탈 헬스케어", "badge": "Health", "reason": "심리 상담 및 우울증 케어"},
      {"target": "고객 센터", "badge": "CS", "reason": "화난 고객 감지 및 대응"},
      {"target": "게임/메타버스", "badge": "Game", "reason": "플레이어 감정 반응형 NPC"}
    ],
    "not_recommended": [
      {"target": "단순 정보 전달", "reason": "시리/구글 어시스턴트 권장"},
      {"target": "텍스트 중심", "reason": "음성 감정 분석 장점 활용 불가"}
    ]
  }'::jsonb,
  ARRAY[
    '마이크 환경: 조용한 곳에서 테스트 권장',
    '과몰입 주의: 지나친 공감 능 주의'
  ],
  '{
    "privacy_protection": "Enterprise options available for data privacy"
  }'::jsonb,
  '[
    {"name": "OpenAI Realtime API", "description": "감정 표현 가능하나 분석 약함"},
    {"name": "Hume Legacy models", "description": "얼굴 표정 분석 등"}
  ]'::jsonb,
  '[
    {"title": "Introducing EVI", "url": "https://www.youtube.com/results?search_query=Hume+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Empathic AI', 'Voice AI', 'EQ'],
  ARRAY['Voice', 'Emotion', 'AI', 'Hume', 'Audio'],
  '[
    {"competitor": "OpenAI Voice", "comparison": "Hume focuses on detecting your emotion, OpenAI focuses on responding with emotion"},
    {"competitor": "Siri", "comparison": "Hume is conversational and empathetic, Siri is transactional"}
  ]'::jsonb,
  ARRAY['공감형 음성 인터페이스(EVI)', '목소리 감정 측정(53종)', '실시간 음성 대화', '자연스러운 끼어들기', '맞춤형 페르소나']
);
