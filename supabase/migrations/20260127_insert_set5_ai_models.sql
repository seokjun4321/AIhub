-- Insert HeyGen, Luma Dream Machine, Kling AI, CapCut, OpusClip, Krea.ai into ai_models table
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
-- 1. HeyGen
(
  'HeyGen',
  '텍스트만 입력하면 실제 사람과 구분하기 힘든 초고화질 AI 아바타가 자연스럽게 말하는 영상을 만들어주는 생성형 비디오 플랫폼.',
  'HeyGen',
  'https://www.heygen.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/HeyGen_logo.png/640px-HeyGen_logo.png', -- Common URL format, checking validity
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Marketers, Educators, HR"
  }'::jsonb,
  'Credit-based',
  'Free (1분 1회) / Creator $24/월',
  '가입 시 1크레딧(1분) 제공. 이후 유료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "1 크레딧(1회성), 최대 1분, 워터마크"
    },
    {
      "plan": "Creator",
      "price": "$24/월",
      "target": "개인",
      "features": "월 15 크레딧(15분), 워터마크 제거"
    },
    {
      "plan": "Team",
      "price": "$69/월",
      "target": "조직",
      "features": "월 30 크레딧, 4K 해상도, 팀 협업"
    }
  ]'::jsonb,
  ARRAY[
    'Video Translate: 내 목소리 톤을 유지하며 입모양까지 맞춰 다국어 변환 (강력)',
    'Instant Avatar: 웹캠 2분 촬영으로 내 디지털 트윈 즉시 생성',
    'URL to Video: 뉴스/상품 페이지 링크만으로 대본+영상 자동 제작',
    'Streaming Avatar: 실시간 대화형 아바타 API 지원'
  ],
  ARRAY[
    '비싼 가격: 월 $24에 15분은 경쟁사 대비 고가',
    '엄격한 모더레이션: 유명인 얼굴 등 생성 거부 확률 높음'
  ],
  '[
    {"name": "Text to Video", "description": "텍스트 입력 시 아바타 영상 생성"},
    {"name": "Video Translate", "description": "영상 언어 변환 (목소리 복제+립싱크)"},
    {"name": "Instant Avatar", "description": "5분 촬영으로 나만의 아바타 생성"},
    {"name": "URL to Video", "description": "웹사이트 링크 기반 영상 자동 제작"},
    {"name": "Photo Avatar", "description": "정지된 사진을 말하는 영상으로 변환"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "글로벌 유튜버", "badge": "Global", "reason": "한국어 영상 -> 영어 영상 변환"},
      {"target": "CEO/강사", "badge": "Busy", "reason": "매번 촬영 없이 아바타로 영상 제작"},
      {"target": "쇼핑몰", "badge": "Commerce", "reason": "상품 상세 페이지 설명 가상 쇼호스트"}
    ],
    "not_recommended": [
      {"target": "감성 연기", "reason": "드라마틱한 감정 표현 부자연스러움"},
      {"target": "가성비", "reason": "대량 숏폼 생산엔 단가 높음"}
    ]
  }'::jsonb,
  ARRAY[
    '크레딧 계산: 1분 1초는 2크레딧 차감. 59초 끊기 필수.',
    '번역 모드: Video Translate 시 "Lip Sync" 옵션 켜야 입모양 맞음'
  ],
  '{
    "privacy_protection": "SOC 2 compliant, Multi-factor auth for deepfake prevention"
  }'::jsonb,
  '[
    {"name": "Synthesia", "description": "제스처 제어 등 연출이 중요할 때"},
    {"name": "D-ID", "description": "사진 한 장으로 만드는 가성비 툴"}
  ]'::jsonb,
  '[
    {"title": "HeyGen Video Translate", "url": "https://www.youtube.com/results?search_query=HeyGen+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['AI Avatar', 'Video Translate', 'Text to Video'],
  ARRAY['Avatar', 'Video', 'Translate', 'Clone', 'Lip Sync'],
  '[
    {"competitor": "Synthesia", "comparison": "HeyGen has better video translation and instant avatar, Synthesia has better studio features"},
    {"competitor": "D-ID", "comparison": "HeyGen is higher quality for realistic avatars, D-ID is cheaper/faster for photos"}
  ]'::jsonb,
  ARRAY['비디오 번역(Video Translate)', '인스턴트 아바타(디지털 트윈)', 'URL to Video', '스트리밍 아바타', '사진 아바타']
),

-- 2. Luma Dream Machine
(
  'Luma Dream Machine',
  '텍스트와 이미지를 입력하면 헐리우드급 물리 엔진이 적용된 고품질 비디오를 5초 만에 생성해 주는 AI 영상 모델.',
  'Luma Labs',
  'https://lumalabs.ai/dream-machine',
  'https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg', -- Placeholder (Luma logo hard to direct link)
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Video Creators, VFX Artists"
  }'::jsonb,
  'Freemium',
  'Free (월 30회) / Standard $29.99/월',
  '월 30회 생성 무료. 상업적 이용 불가.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "찍먹파",
      "features": "월 30회 생성, 일반 속도"
    },
    {
      "plan": "Standard",
      "price": "$29.99/월",
      "target": "크리에이터",
      "features": "월 120회 생성, 상업적 이용 가능, 워터마크 제거"
    },
    {
      "plan": "Pro",
      "price": "$99.99/월",
      "target": "전문가",
      "features": "월 400회 생성, 우선순위 큐"
    }
  ]'::jsonb,
  ARRAY[
    'Keyframes: 시작/끝 장면 지정 시 자연스러운 연결 생성 (최대 강점)',
    '속도: 경쟁 모델(Sora 등) 대비 빠른 120초 내외 생성',
    '물리 구현: 액체, 연기 등 물리적 움직임 사실적',
    'Loop: 무한 반복 루프 영상 제작 용이'
  ],
  ARRAY[
    '시간 제한: 한 번에 5초 생성 (연장 가능하지만 크레딧 소모)',
    '텍스트 뭉개짐: 영상 내 글자 표현 약함'
  ],
  '[
    {"name": "Text to Video", "description": "텍스트 명령어로 영상 생성"},
    {"name": "Image to Video", "description": "이미지를 영상으로 변환"},
    {"name": "Keyframes Control", "description": "시작/끝 이미지 지정"},
    {"name": "Extend Video", "description": "영상 뒷부분 연장"},
    {"name": "Loop Mode", "description": "무한 반복 영상 생성"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "트랜지션 제작", "badge": "Morph", "reason": "A->B 장면 자연스러운 모핑"},
      {"target": "밈 제작", "badge": "Meme", "reason": "사진 한 장을 움짤로 변환"},
      {"target": "제품 홍보", "badge": "Product", "reason": "제품 360도 회전 샷 연출"}
    ],
    "not_recommended": [
      {"target": "긴 영상", "reason": "1분 이상 스토리 영상 불가"},
      {"target": "대사 처리", "reason": "립싱크 기능 없음"}
    ]
  }'::jsonb,
  ARRAY[
    '프롬프트: "Zoom in", "Pan right" 등 카메라 동사 구체적 사용',
    '손가락: 손 클로즈업 장면은 가급적 피하기'
  ],
  '{
    "privacy_protection": "Free tier content used for training"
  }'::jsonb,
  '[
    {"name": "Runway Gen-3", "description": "정교한 카메라 컨트롤 필요 시"},
    {"name": "Kling AI", "description": "더 긴 영상(10초) 및 인물 자연스러움"}
  ]'::jsonb,
  '[
    {"title": "Introducing Dream Machine", "url": "https://www.youtube.com/results?search_query=Luma+Labs+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Video Generation', 'Keyframes', 'Physics Engine'],
  ARRAY['Video', 'GenAI', '3D', 'Physics', 'Luma'],
  '[
    {"competitor": "Sora", "comparison": "Luma is available now, Sora is not public"},
    {"competitor": "Runway", "comparison": "Luma handles keyframes better, Runway has better motion brush"}
  ]'::jsonb,
  ARRAY['키프레임 제어(Keyframes)', 'Text/Image to Video', '영상 연장(Extend)', '루프 모드', '물리 엔 진 구현']
),

-- 3. Kling AI
(
  'Kling AI',
  '중국 콰이쇼우(Kuaishou)가 개발한 "Sora 대항마"로, 최대 10초(유료)까지 생성 가능하며 인물의 자연스러운 움직임이 압도적인 영상 모델.',
  'Kuaishou',
  'https://klingai.com',
  'https://placehold.co/200x200?text=K', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Filmmakers, Content Creators"
  }'::jsonb,
  'Credit-based',
  'Free (매일 66 크레딧) / Standard $10/월',
  '매일 66 크레딧(약 6개) 무료. 대기 시간 있음.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "66 크레딧/일, 워터마크, 5초 영상"
    },
    {
      "plan": "Standard",
      "price": "$10/월",
      "target": "입문자",
      "features": "660 크레딧/월, 워터마크 제거, 10초 영상"
    },
    {
      "plan": "Pro",
      "price": "$37/월",
      "target": "전문가",
      "features": "3000 크레딧/월, 고성능 모드"
    }
  ]'::jsonb,
  ARRAY[
    '리얼리즘: 인물 걷는 모습, 표정, 취식 장면 등 불쾌한 골짜기 없는 자연스러움',
    '긴 지속 시간: 유료 시 10초 생성으로 숏폼 유리',
    'Camera Control: 수평/수직/줌/틸트 구체적 제어',
    '매일 무료: 리필되는 크레딧 정책'
  ],
  ARRAY[
    '대기 시간: 무료 사용자 대기열 김',
    '검열: 중국권 서비스 특성상 이슈 민감'
  ],
  '[
    {"name": "Text to Video", "description": "고화질 영상 생성 (High Quality)"},
    {"name": "Image to Video", "description": "이미지 기반 영상 변환"},
    {"name": "Extend Video", "description": "기존 영상 5초 연장"},
    {"name": "Camera Control", "description": "카메라 워킹 제어"},
    {"name": "Professional Mode", "description": "10초 생성 및 고퀄리티 (유료)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "영화 제작", "badge": "Cinema", "reason": "시네마틱 질감 B-roll 소스"},
      {"target": "인물 영상", "badge": "Human", "reason": "자연스러운 행동 묘사"},
      {"target": "무료 유저", "badge": "Daily", "reason": "매일 무료 리필 혜택"}
    ],
    "not_recommended": [
      {"target": "급한 성격", "reason": "무료 대기 시간 김"},
      {"target": "텍스트 묘사", "reason": "글자 정확도 부족"}
    ]
  }'::jsonb,
  ARRAY[
    '크레딧 소모: Pro 모드나 10초 생성은 크레딧 많이 듦',
    '프롬프트: 구체적인 4K, detailed cinematic 묘사 권장'
  ],
  '{
    "privacy_protection": "Sensitive data caution advised"
  }'::jsonb,
  '[
    {"name": "Luma Dream Machine", "description": "빠른 생성 속도"},
    {"name": "Runway Gen-3", "description": "정교한 모션 제어"}
  ]'::jsonb,
  '[
    {"title": "Kling AI Official Global Launch", "url": "https://www.youtube.com/results?search_query=Kling+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Realistic Video', '10s Video', 'Motion Control'],
  ARRAY['Video', 'Cinema', 'China', 'Sora', 'Realism'],
  '[
    {"competitor": "Sora", "comparison": "Kling is currently the closest public alternative to Sora quality"},
    {"competitor": "Luma", "comparison": "Kling typically has better human motion realism than Luma"}
  ]'::jsonb,
  ARRAY['10초 영상 생성(Pro)', '카메라 컨트롤', '인물 리얼리즘', '이미지 투 비디오', '비디오 연장']
),

-- 4. CapCut AI
(
  'CapCut',
  '틱톡(TikTok) 숏폼 편집의 제왕이자, "대본만 주면 영상 완성", "AI 모델 입히기" 등 커머스와 편집 자동화 기능이 강력한 올인원 에디터.',
  'ByteDance',
  'https://www.capcut.com',
  'https://upload.wikimedia.org/wikipedia/commons/a/a0/CapCut_logo.png', -- Common logo
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Windows", "macOS", "iOS", "Android", "Web"],
    "target_audience": "Short-form Creators, SMB Owners"
  }'::jsonb,
  'Freemium',
  'Free (강력함) / Pro $7.99/월',
  '컷편집, 자동 자막, 텍스트 투 비디오, 4K 내보내기 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반 유저",
      "features": "컷편집, 자동 자막, AI 생성, 4K"
    },
    {
      "plan": "Pro",
      "price": "$7.99/월",
      "target": "크리에이터",
      "features": "AI 보컬 제거, 피부 보정, Pro 효과, 클라우드"
    }
  ]'::jsonb,
  ARRAY[
    'Script to Video: 대본 입력 시 영상+자막+더빙 원클릭 완성',
    'Long to Shorts: 롱폼 영상을 숏폼으로 자동 재가공',
    'AI Model: 옷 사진을 AI 모델 착샷으로 변환 (쇼핑몰 강추)',
    '자동 자막: 높은 인식률 및 트렌디한 디자인 템플릿'
  ],
  ARRAY[
    'Pro 유도: 예쁜 효과는 유료인 경우가 많음',
    'PC 사양: 기능이 많아 무거울 수 있음'
  ],
  '[
    {"name": "Script to Video", "description": "대본 기반 영상/더빙 자동 생성"},
    {"name": "Long Video to Shorts", "description": "긴 영상 숏폼 재가공"},
    {"name": "AI Model", "description": "의류 제품 AI 착용샷"},
    {"name": "Auto Captions", "description": "자동 자막 생성"},
    {"name": "Vocal Isolation", "description": "MR/목소리 분리 (Pro)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "숏폼 입문자", "badge": "Shorts", "reason": "템플릿으로 요즘 영상 쉽게 제작"},
      {"target": "쇼핑몰 운영", "badge": "Commerce", "reason": "마네킹 샷을 모델 샷으로 변환"},
      {"target": "자막 작업", "badge": "Caption", "reason": "빠르고 예쁜 자동 자막"}
    ],
    "not_recommended": [
      {"target": "방송급 편집", "reason": "세밀한 색보정 오디오 믹싱 한계"},
      {"target": "기업 보안", "reason": "사내 보안 규정 확인 필요"}
    ]
  }'::jsonb,
  ARRAY[
    '워터마크: 모바일 앱 엔딩 로고는 삭제 가능',
    '저작권: 틱톡 외 상업적 이용 시 음원 저작권 확인'
  ],
  '{
    "privacy_protection": "Cloud sync, requires logout on public PC"
  }'::jsonb,
  '[
    {"name": "Vrew", "description": "문서 편집 방식의 컷편집"},
    {"name": "Premiere Pro", "description": "전문가용 편집"}
  ]'::jsonb,
  '[
    {"title": "CapCut AI Features Overview", "url": "https://www.youtube.com/results?search_query=CapCut+official", "platform": "YouTube"}
  ]'::jsonb,
  '4.0',
  ARRAY['Video Editor', 'Shorts Maker', 'AI Model'],
  ARRAY['Edit', 'Video', 'TikTok', 'Shorts', 'AI'],
  '[
    {"competitor": "Premiere Pro", "comparison": "CapCut is faster/easier for social media, Premiere is for cinema/TV"},
    {"competitor": "Vrew", "comparison": "CapCut has better effects/templates, Vrew has easier text-based editing"}
  ]'::jsonb,
  ARRAY['대본 투 비디오(Script to Video)', 'AI 모델 착용샷', '롱폼 투 숏폼', '자동 자막', 'AI 캐릭터']
),

-- 5. OpusClip
(
  'OpusClip',
  '긴 유튜브 영상을 넣으면, AI가 "가장 떡상할 만한(Viral)" 하이라이트 구간을 찾아 세로형 숏폼으로 잘라주고 자막까지 달아주는 툴.',
  'Opus Pro',
  'https://www.opus.pro',
  'https://placehold.co/200x200?text=O', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Podcasters, Streamers"
  }'::jsonb,
  'Freemium',
  'Free (60분/월) / Starter $9/월',
  '월 60분 업로드 무료. 1080p 불가.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "60분/월, 워터마크, 자동 자막"
    },
    {
      "plan": "Starter",
      "price": "$9/월",
      "target": "개인",
      "features": "150분/월, 워터마크 제거"
    },
    {
      "plan": "Pro",
      "price": "$29/월",
      "target": "팀",
      "features": "300분/월, 4K, 프리미엄 템플릿"
    }
  ]'::jsonb,
  ARRAY[
    'Virality Score: 조회수 잘 나올 구간을 AI 점수로 예측',
    'Active Speaker: 화자 얼굴 자동 추적 및 리프레이밍',
    'AI B-roll: 내용에 맞는 자료화면 자동 삽입',
    '키워드 강조: 핵심 단어 자동 색상 강조 자막'
  ],
  ARRAY[
    '처리 시간: 1시간 이상 영상은 분석 시간 소요',
    '한국어 밈: 유행어나 밈 자막 처리는 부족'
  ],
  '[
    {"name": "AI Curation", "description": "하이라이트 추출 및 점수 예측"},
    {"name": "Auto Resize", "description": "가로->세로 화자 추적 변환"},
    {"name": "AI Captions", "description": "애니메이션 자막 생성"},
    {"name": "AI B-roll", "description": "자료 화면 자동 삽입"},
    {"name": "Social Scheduler", "description": "SNS 예약 업로드"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "팟캐스터", "badge": "Podcast", "reason": "인터뷰 영상 숏폼 대량 생산"},
      {"target": "스트리머", "badge": "Live", "reason": "방송 다시보기 재가공"},
      {"target": "마케터", "badge": "Promo", "reason": "웨비나 핵심 요약"}
    ],
    "not_recommended": [
      {"target": "브이로그", "reason": "대사 없는 영상은 하이라이트 못 잡음"},
      {"target": "세밀한 편집", "reason": "정교한 컷 편짐은 CapCut 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '크레딧: 업로드 길이만큼 차감되므로 불필요한 부분 자르고 업로드',
    '언어 설정: 한국어로 설정해야 자막 정확'
  ],
  '{
    "privacy_protection": "Uploaded content retention policies apply"
  }'::jsonb,
  '[
    {"name": "Munch", "description": "마케팅 트렌드 분석 포함"},
    {"name": "Vizard", "description": "편집 기능이 더 강함"}
  ]'::jsonb,
  '[
    {"title": "Turn Long Videos into Viral Shorts", "url": "https://www.youtube.com/results?search_query=OpusClip+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Repurposing', 'Shorts', 'Clips'],
  ARRAY['Shorts', 'Clip', 'Viral', 'Repurpose', 'AI'],
  '[
    {"competitor": "Munch", "comparison": "OpusClip focuses on virality scores, Munch on marketing trends"},
    {"competitor": "CapCut", "comparison": "OpusClip automates selection, CapCut requires manual editing"}
  ]'::jsonb,
  ARRAY['바이럴 점수(Virality Score)', '화자 자동 추적(Active Speaker)', 'AI B-roll 삽입', '자동 캡션(키워드 강조)', '긴 영상 요약']
),

-- 6. Krea.ai
(
  'Krea.ai',
  '내가 대충 그린 낙서를 실시간으로 고퀄리티 이미지로 바꿔주는 "Real-time Generation" 기능과 강력한 업스케일러를 갖춘 예술 AI.',
  'Krea',
  'https://www.krea.ai',
  'https://placehold.co/200x200?text=K', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Artists, Designers"
  }'::jsonb,
  'Freemium',
  'Free (일일 제한) / Basic $8/월',
  '매일 무료 생성량 제공.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "일일 제한 생성, 기본 속도"
    },
    {
      "plan": "Basic",
      "price": "$8/월",
      "target": "개인",
      "features": "월 36,000장(실시간), 상업적 이용"
    },
    {
      "plan": "Pro",
      "price": "$24/월",
      "target": "전문가",
      "features": "무제한 실시간 생성, 비공개 모드"
    }
  ]'::jsonb,
  ARRAY[
    'Real-time Generation: 그리는 즉시 변하는 실시간 LCM 기술 (경이로움)',
    'Upscaler: 저화질 사진을 4K급으로 선명하게 복원 (업계 최고)',
    'Patterns: 로고나 텍스트를 숨긴 착시 이미지 생성',
    'Webcam Input: 웹캠 속 내 모습을 실시간 캐릭터화'
  ],
  ARRAY[
    '디테일 제어: 실시간성의 우연함이 강해 정밀 통제는 어려움',
    '서버 부하: 사용량 몰리면 느려짐'
  ],
  '[
    {"name": "Real-time Canvas", "description": "실시간 페인팅 생성"},
    {"name": "AI Upscaler", "description": "이미지 해상도/디테일 복원"},
    {"name": "Pattern Tool", "description": "착시 패턴 이미지"},
    {"name": "Logo Illusions", "description": "로고 숨김 이미지"},
    {"name": "Video Generation", "description": "키프레임 비디오 (Beta)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "컨셉 아티스트", "badge": "Concept", "reason": "아이디어 스케치 빠른 시각화"},
      {"target": "아이패드 드로잉", "badge": "Drawing", "reason": "낙서를 고퀄 그림으로 변환"},
      {"target": "사진 보정", "badge": "Upscale", "reason": "옛날 사진 고화질 복원"}
    ],
    "not_recommended": [
      {"target": "정교한 텍스트", "reason": "글자 삽입은 Ideogram 추천"},
      {"target": "프롬프트 장인", "reason": "완벽 통제는 Midjourney 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '무료 시간: 혼잡 시간대 대기열 발생 가능',
    '저장 필수: 실시간 생성은 지나가면 사라지니 Quick Save 습관화'
  ],
  '{
    "privacy_protection": "Private mode available only on Pro"
  }'::jsonb,
  '[
    {"name": "Leonardo.ai", "description": "Live Canvas 기능 유사"},
    {"name": "Magnific AI", "description": "고가형 전문 업스케일러"}
  ]'::jsonb,
  '[
    {"title": "Introducing Krea Real-time Generation", "url": "https://www.youtube.com/results?search_query=Krea.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Real-time TV', 'Upscaler', 'Pattern'],
  ARRAY['Art', 'Design', 'Realtime', 'Upscale', 'Drawing'],
  '[
    {"competitor": "Leonardo.ai", "comparison": "Krea is faster for real-time, Leonardo has more models"},
    {"competitor": "Magnific", "comparison": "Krea is cheaper and offers generation, Magnific is purely upscale"}
  ]'::jsonb,
  ARRAY['실시간 생성(Real-time)', 'AI 업스케일러', '패턴 일루전', '웹캠 투 이미지', '로고 착시 효과']
);
