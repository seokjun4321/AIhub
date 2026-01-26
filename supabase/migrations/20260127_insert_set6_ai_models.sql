-- Insert Looka, Brandmark, AdCreative.ai, Udio, Murf AI, Ideogram into ai_models table
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
-- 1. Looka
(
  'Looka',
  '회사 이름과 업종만 입력하면 수백 가지 고퀄리티 로고 디자인을 제안하고, 명함·SNS 프로필 등 브랜드 키트까지 한 번에 만들어주는 AI 디자이너.',
  'Looka',
  'https://looka.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Looka_logo.svg/512px-Looka_logo.svg.png', -- Common wikimedia
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Startups, Small Businesses"
  }'::jsonb,
  'Freemium',
  'Basic Logo $20 (1회) / Brand Kit $96/년',
  '로고 생성 및 수정 무제한 무료. 고화질 다운로드는 유료.',
  '[
    {
      "plan": "Basic Logo",
      "price": "$20 (1회)",
      "target": "알뜰족",
      "features": "PNG 파일 1개 (투명 배경 X)"
    },
    {
      "plan": "Premium Logo",
      "price": "$65 (1회)",
      "target": "실무자",
      "features": "고화질(SVG/EPS), 투명 배경, 평생 수정"
    },
    {
      "plan": "Brand Kit",
      "price": "$96/년",
      "target": "창업가",
      "features": "명함/SNS 프로필 등 300+ 템플릿"
    }
  ]'::jsonb,
  ARRAY[
    '디자인 퀄리티: 색감과 심볼 매칭이 세련됨 (디자이너급)',
    'Brand Kit: 로고 기반 명함, SNS 프로필 등 자동 생성',
    'Mockup: 간판, 티셔츠 등 실제 적용 모습 미리보기 제공',
    '평생 수정: Premium 이상 구매 시 구매 후에도 무제한 수정'
  ],
  ARRAY[
    '한글 폰트: 한글 지원이 약해 영문 로고에 최적화',
    'Basic 패키지: $20짜리는 투명 배경 로고를 안 줌 (실무 불가)'
  ],
  '[
    {"name": "AI Logo Generator", "description": "취향 분석 기반 로고 생성"},
    {"name": "Brand Kit Subscription", "description": "마케팅 자료 300종 자동 생성"},
    {"name": "Vector Files", "description": "인쇄용 고화질 파일(SVG/EPS)"},
    {"name": "Post-purchase Edits", "description": "구매 후 디자인 수정"},
    {"name": "Website Builder", "description": "브랜드 스타일 적용 웹사이트"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "초기 창업자", "badge": "Startup", "reason": "5분 만에 그럴듯한 로고 세트 완성"},
      {"target": "영문 브랜드", "badge": "English", "reason": "영문 이니셜 로고 최적화"},
      {"target": "SNS 운영", "badge": "Social", "reason": "채널 아트/프로필 깔맞춤"}
    ],
    "not_recommended": [
      {"target": "한글 로고", "reason": "캘리그라피나 예쁜 한글 폰트 부족"},
      {"target": "캐릭터 로고", "reason": "복잡한 마스코트 그림 불가"}
    ]
  }'::jsonb,
  ARRAY[
    '저작권: 아이콘은 비독점 라이브러리라 상표권 등록 시 유의',
    '구독 주의: Brand Kit은 연간 구독이니 로고만 필요하면 Premium 일회성 구매'
  ],
  '{
    "privacy_protection": "Designs saved in account until purchased"
  }'::jsonb,
  '[
    {"name": "Brandmark", "description": "구독 없이 일회성 결제로 브랜드 가이드 제공"},
    {"name": "Canva", "description": "직접 디자인 수정이 편함"}
  ]'::jsonb,
  '[
    {"title": "How to Design a Logo with Looka", "url": "https://www.youtube.com/results?search_query=Looka+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Logo Design', 'Brand Identity', 'Startup Tool'],
  ARRAY['Design', 'Logo', 'Brand', 'Startup', 'AI'],
  '[
    {"competitor": "Brandmark", "comparison": "Looka has better visual mockups, Brandmark is better for one-time payments"},
    {"competitor": "Canva", "comparison": "Looka generates logos automatically, Canva requires more manual work"}
  ]'::jsonb,
  ARRAY['AI 로고 생성기', '브랜드 키트(명함/SNS)', '목업 미리보기(Mockup)', '벡터 파일 다운로드', '웹사이트 빌더']
),

-- 2. Brandmark
(
  'Brandmark',
  '로고 디자인부터 브랜드 가이드라인, 명함, 소셜 미디어 그래픽까지 "일회성 결제"로 평생 소장할 수 있는 가성비 AI 로고 생성기.',
  'Brandmark',
  'https://brandmark.io',
  'https://brandmark.io/logo.png', -- Official URL pattern
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Optional",
    "platforms": ["Web"],
    "target_audience": "Small Business Owners"
  }'::jsonb,
  'One-time Payment',
  'Basic $25 (1회) / Designer $65 (1회)',
  '로고 생성 및 커스터마이징 무료. 다운로드 유료.',
  '[
    {
      "plan": "Basic",
      "price": "$25 (1회)",
      "target": "개인",
      "features": "PNG 파일 (투명 배경 X)"
    },
    {
      "plan": "Designer",
      "price": "$65 (1회)",
      "target": "창업가",
      "features": "소스 파일(EPS/SVG), 브랜드 가이드, 수정"
    },
    {
      "plan": "Enterprise",
      "price": "$175 (1회)",
      "target": "기업",
      "features": "디자이너 패키지 + 10개 오리지널 컨셉"
    }
  ]'::jsonb,
  ARRAY[
    '구독 없음: 일회성 결제로 끝 (가성비 최고)',
    '디자인 스타일: 심플하고 모던한 미니멀리즘 로고 특화',
    'Brand Guide: 폰트, 색상 코드가 정리된 PDF 가이드북 제공 ($65 이상)',
    '무제한 수정: 구매 후에도 텍스트/색상 변경 가능'
  ],
  ARRAY[
    '커스텀 한계: 정밀한 1px 단위 이동 등 편집 기능 투박',
    '한글 폰트: 영문 대비 지원 부족'
  ],
  '[
    {"name": "AI Logo Design", "description": "키워드 기반 로고 생성"},
    {"name": "Brand Guidelines", "description": "폰트/컬러 가이드북"},
    {"name": "Social Media Kit", "description": "프로필/커버 리사이징"},
    {"name": "Business Card", "description": "명함 템플릿"},
    {"name": "Source Files", "description": "인쇄용 벡터 파일(SVG)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "가성비 중시", "badge": "Value", "reason": "월 구독료 없이 한 번에 소장"},
      {"target": "패키지 필요", "badge": "Package", "reason": "명함, 레터헤드 등 풀세트"},
      {"target": "미니멀리즘", "badge": "Minimal", "reason": "깔끔하고 모던한 스타일 선호"}
    ],
    "not_recommended": [
      {"target": "화려한 일러스트", "reason": "복잡한 그림 로고는 Ideogram 추천"}
    ]
  }'::jsonb,
  ARRAY[
    'Basic vs Designer: $25는 투명 PNG 없고 수정 안 됨. $65 추천.'
  ],
  '{
    "privacy_protection": "Ownership transferred upon purchase"
  }'::jsonb,
  '[
    {"name": "Looka", "description": "더 화려한 템플릿 (구독형)"},
    {"name": "Hatchful", "description": "무료지만 퀄리티 낮음"}
  ]'::jsonb,
  '[
    {"title": "Create a unique brand identity", "url": "https://www.youtube.com/results?search_query=Brandmark.io+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Logo Maker', 'Brand Guide', 'No Subscription'],
  ARRAY['Logo', 'Brand', 'Design', 'Minimal', 'One-time'],
  '[
    {"competitor": "Looka", "comparison": "Brandmark is one-time payment, Looka pushes subscription for brand kits"},
    {"competitor": "Tailor Brands", "comparison": "Brandmark creates cleaner, more modern designs"}
  ]'::jsonb,
  ARRAY['AI 로고 디자인', '브랜드 가이드라인(PDF)', '소셜 미디어 키트', '명함 디자인', '소스 파일(EPS/SVG)']
),

-- 3. AdCreative.ai
(
  'AdCreative.ai',
  '광고 배너와 카피를 대량으로 생성하고, AI가 미리 "전환율(성과)"을 예측하여 클릭률 높은 광고 소재를 찾아주는 마케팅 자동화 툴.',
  'AdCreative.ai',
  'https://www.adcreative.ai',
  'https://placehold.co/200x200?text=A', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Performance Marketers, Agencies"
  }'::jsonb,
  'Subscription',
  'Startup $21/월 / Professional $141/월',
  '7일 무료 체험 (카드 등록 필수).',
  '[
    {
      "plan": "Startup",
      "price": "$21/월",
      "target": "개인",
      "features": "10 크레딧/월, 1개 브랜드"
    },
    {
      "plan": "Professional",
      "price": "$141/월",
      "target": "대행사",
      "features": "100 크레딧/월, 5개 브랜드"
    },
    {
      "plan": "Agency",
      "price": "$374/월",
      "target": "기업",
      "features": "500 크레딧/월, 50개 브랜드"
    }
  ]'::jsonb,
  ARRAY[
    'Conversion Score: 성과 예측 점수로 AB 테스트 비용 절감',
    'Mass Generation: SNS 채널별 사이즈 수백 개 배너 자동 생성',
    'Competitor Insights: 경쟁사 우수 소재 분석',
    '연동성: Meta/Google Ads 연동으로 성과 데이터 학습'
  ],
  ARRAY[
    '디자인 자유도: 템플릿 기반이라 정밀 커스텀 제한적',
    '비싼 가격: 크레딧 대비 구독료가 높음'
  ],
  '[
    {"name": "Ad Creatives Generation", "description": "배너 대량 생성"},
    {"name": "Text Generator", "description": "광고 카피 자동 작성"},
    {"name": "Creative Scoring", "description": "성과 예측 점수 제공"},
    {"name": "Social Creatives", "description": "SNS용 리사이징"},
    {"name": "Competitor Intelligence", "description": "경쟁사 분석"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "퍼포먼스 마케터", "badge": "Ads", "reason": "대량 소재 세팅 및 효율 테스트"},
      {"target": "1인 셀러", "badge": "Seller", "reason": "디자인 감각 없이 고효율 배너 제작"},
      {"target": "대행사", "badge": "Agency", "reason": "여러 클라이언트 소재 공장식 생산"}
    ],
    "not_recommended": [
      {"target": "브랜드 마케터", "reason": "감성적이고 예술적인 브랜딩엔 부적합"},
      {"target": "소액 광고주", "reason": "툴 비용이 광고비보다 비쌀 수 있음"}
    ]
  }'::jsonb,
  ARRAY[
    '크레딧 소모: 다운로드 시 차감되므로 신중하게',
    '이미지 소스: 제품 누끼(PNG) 준비 필수'
  ],
  '{
    "privacy_protection": "Ad account data used for training models"
  }'::jsonb,
  '[
    {"name": "Canva", "description": "직접 디자인 수정 용이"},
    {"name": "Creatopy", "description": "배너 애니메이션 기능 강력"}
  ]'::jsonb,
  '[
    {"title": "Generate High Converting Ads", "url": "https://www.youtube.com/results?search_query=AdCreative.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Ad Generator', 'Marketing Automation', 'Performance Marketing'],
  ARRAY['Ads', 'Marketing', 'Banner', 'Creative', 'CRO'],
  '[
    {"competitor": "Canva", "comparison": "AdCreative is data-driven for conversion, Canva is design-driven"},
    {"competitor": "Creatopy", "comparison": "AdCreative focuses on static banners text scoring, Creatopy on animation"}
  ]'::jsonb,
  ARRAY['광고 배너 대량 생성', '전환율 예측 점수', '광고 카피 생성', '경쟁사 소재 분석', 'SNS 리사이징']
),

-- 4. Udio
(
  'Udio',
  'Suno와 양대 산맥을 이루는 AI 음악 생성 서비스로, 특히 음질과 보컬의 리얼함에서 뮤지션들에게 고평가받는 작곡 AI.',
  'Udio',
  'https://www.udio.com',
  'https://upload.wikimedia.org/wikipedia/commons/d/d1/Udio_AI_Logo.png', -- Common wiki
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Musicians, Creators"
  }'::jsonb,
  'Freemium',
  'Free (10곡) / Standard $10/월',
  '월 100크레딧 무료. 상업적 이용 불가.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "100 크레딧/월, 상업적 이용 불가"
    },
    {
      "plan": "Standard",
      "price": "$10/월",
      "target": "크리에이터",
      "features": "1200 크레딧/월, 상업적 이용 가능"
    },
    {
      "plan": "Pro",
      "price": "$30/월",
      "target": "전문가",
      "features": "4800 크레딧/월, Audio Inpainting"
    }
  ]'::jsonb,
  ARRAY[
    'High Fidelity: 깨끗한 음질과 뛰어난 악기 분리도 (전문가 취향)',
    'V2 Model: 곡 구조 이해력 및 스테레오감 향상',
    'Inpainting: 특정 구간 수정 기능 강력',
    'Context Window: 긴 곡 생성 시 일관성 유지 우수'
  ],
  ARRAY[
    '생성 시간: 고음질 프로세싱으로 다소 느림',
    '가사 씹힘: 빠른 한국어 가사 발음 뭉개짐 존재',
    '난이도: 세부 설정이 많아 입문자에게 어려울 수 있음'
  ],
  '[
    {"name": "Text to Music", "description": "프롬프트로 고음질 음악 생성"},
    {"name": "Remix & Extend", "description": "곡 변형 및 연장"},
    {"name": "Audio Inpainting", "description": "특정 구간 수정"},
    {"name": "Manual Mode", "description": "전문가용 제어 모드"},
    {"name": "Stem Downloads", "description": "보컬/반주 분리 파일"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "음질 중요", "badge": "HiFi", "reason": "노이즈 없는 깔끔한 사운드"},
      {"target": "디테일 수정", "badge": "Edit", "reason": "Inpainting으로 부분 수정 필요"},
      {"target": "장르 실험", "badge": "Genre", "reason": "복잡한 재즈/클래식 시도"}
    ],
    "not_recommended": [
      {"target": "빠른 생성", "reason": "Suno가 더 빠름"},
      {"target": "완전 무료 상업", "reason": "무료 플랜 상업 불가"}
    ]
  }'::jsonb,
  ARRAY[
    '저작권: 유튜브 수익 창출 시 유료 결제 권장',
    '가사 입력: [Verse], [Chorus] 태그 필수'
  ],
  '{
    "privacy_protection": "Rights owned by paid users"
  }'::jsonb,
  '[
    {"name": "Suno", "description": "더 대중적이고 빠름"},
    {"name": "Stable Audio", "description": "효과음 및 루프 생성"}
  ]'::jsonb,
  '[
    {"title": "Introducing Udio", "url": "https://www.youtube.com/results?search_query=Udio+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Music Generation', 'AI Composition', 'High Fidelity'],
  ARRAY['Music', 'Song', 'Udio', 'Audio', 'Composer'],
  '[
    {"competitor": "Suno", "comparison": "Udio has better audio fidelity, Suno has better song structure coherence"},
    {"competitor": "Suno", "comparison": "Udio is more for pros, Suno is more for fun/memes"}
  ]'::jsonb,
  ARRAY['고음질 음악 생성', '오디오 인페인팅(수정)', '곡 연장(Extend)', '매뉴얼 모드', '스템(Stem) 다운로드']
),

-- 5. Murf AI
(
  'Murf AI',
  '텍스트를 입력하면 스튜디오 품질의 AI 성우 목소리로 변환해주고, 영상 싱크까지 맞출 수 있는 올인원 AI 보이스오버 플랫폼.',
  'Murf AI',
  'https://murf.ai',
  'https://placehold.co/200x200?text=M', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "Canva Add-on"],
    "target_audience": "Educators, Marketers, Podcasters"
  }'::jsonb,
  'Freemium',
  'Free (다운로드 불가) / Creator $19/월',
  '10분 체험 무료 (다운로드 불가).',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "10분 생성, 다운로드 불가"
    },
    {
      "plan": "Creator",
      "price": "$19/월",
      "target": "개인",
      "features": "24시간/년 생성, 상업적 이용, 무제한 다운로드"
    },
    {
      "plan": "Business",
      "price": "$29/월",
      "target": "팀",
      "features": "96시간/년 생성, 보이스 체인저"
    }
  ]'::jsonb,
  ARRAY[
    '자연스러움: 음정, 속도, 일시정지 미세 조절로 리얼한 목소리',
    'Video Sync: 영상 타임라인에 맞춰 오디오 싱크 편집 가능',
    'Canva 연동: 캔바 내에서 바로 내레이션 생성',
    'Voice Changer: 내 녹음 파일을 AI 성우로 변환 (Business)'
  ],
  ARRAY[
    '무료 다운로드 불가: 무료는 듣기만 가능',
    '생성 시간 제한: 연간 시간 제한 존재'
  ],
  '[
    {"name": "Text to Speech", "description": "120+ 성우 목소리 변환"},
    {"name": "Voice Cloning", "description": "내 목소리 복제"},
    {"name": "Video over Voice", "description": "영상 싱크 편집"},
    {"name": "Voice Changer", "description": "녹음 음성 변환"},
    {"name": "Add-ons", "description": "Canva/Google Slides 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "이러닝 제작", "badge": "Edu", "reason": "강의 슬라이드 내레이션"},
      {"target": "기업 홍보", "badge": "Promo", "reason": "성우 섭외 비용 절감"},
      {"target": "캔바 유저", "badge": "Canva", "reason": "캔바 영상에 바로 목소리 입히기"}
    ],
    "not_recommended": [
      {"target": "무료 파일", "reason": "ElevenLabs나 TTSMaker 추천"},
      {"target": "실시간 대화", "reason": "스트리밍용 아님"}
    ]
  }'::jsonb,
  ARRAY[
    '다운로드: 무료는 불가하니 주의',
    '강조하기: [Emphasis] 태그 활용'
  ],
  '{
    "privacy_protection": "Encrypted data, User owns rights (Paid)"
  }'::jsonb,
  '[
    {"name": "ElevenLabs", "description": "감정 표현 더 풍부"},
    {"name": "Typecast", "description": "다양한 한국어 캐릭터"}
  ]'::jsonb,
  '[
    {"title": "Murf AI Studio Demo", "url": "https://www.youtube.com/results?search_query=Murf+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Text to Speech', 'Voiceover', 'AI Voice'],
  ARRAY['TTS', 'Voice', 'Audio', 'Narrator', 'Speech'],
  '[
    {"competitor": "ElevenLabs", "comparison": "Murf has better video sync tools, ElevenLabs has better raw voice quality"},
    {"competitor": "Typecast", "comparison": "Murf integrates with Canva, Typecast has avatars"}
  ]'::jsonb,
  ARRAY['텍스트 투 스피치(TTS)', '비디오 싱크 편집', '보이스 체인저', 'Canva 연동', '보이스 클로닝']
),

-- 6. Ideogram
(
  'Ideogram',
  '"글자가 뭉개지지 않는 그림 AI" — 이미지 내에 정확한 텍스트(타이포그래피)를 삽입하는 능력이 독보적인 최신 이미지 생성 모델.',
  'Ideogram',
  'https://ideogram.ai',
  'https://placehold.co/200x200?text=I', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Designers, T-shirt Sellers"
  }'::jsonb,
  'Freemium',
  'Free (일일 제한) / Basic $7/월',
  '하루 약 20장 무료. 대기열 있음.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "일일 20장, JPG, 공개"
    },
    {
      "plan": "Basic",
      "price": "$7/월",
      "target": "개인",
      "features": "월 400장, PNG, 우선 생성"
    },
    {
      "plan": "Plus",
      "price": "$16/월",
      "target": "디자이너",
      "features": "월 1000장, 비공개 모드, 에디터"
    }
  ]'::jsonb,
  ARRAY[
    '텍스트 렌더링: 이미지 내 스펠링 정확도 독보적 (최강점)',
    'Magic Prompt: 간단한 단어를 화려한 프롬프트로 자동 확장',
    '다양한 비율: 16:9, 10:16 등 자유로운 비율 설정',
    '최신 모델: v2.5/v3 업데이트로 실사 묘사력 향상'
  ],
  ARRAY[
    '무료 제한: 무료는 JPG만 제공 (인쇄용 화질 부족)',
    '공개: Plus 미만 플랜은 갤러리 강제 공개'
  ],
  '[
    {"name": "Reliable Text", "description": "이미지 내 텍스트 정확 렌더링"},
    {"name": "Magic Prompt", "description": "프롬프트 자동 개선"},
    {"name": "Remix", "description": "이미지 변형 생성"},
    {"name": "Image Weight", "description": "참조 이미지 조절"},
    {"name": "Editor", "description": "색상/자르기 수정 (Plus)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "로고/엠블럼", "badge": "Logo", "reason": "이름이 들어간 로고 디자인"},
      {"target": "POD 사업", "badge": "Print", "reason": "티셔츠 레터링 디자인"},
      {"target": "포스터/표지", "badge": "Poster", "reason": "제목이 포함된 이미지 필요 시"}
    ],
    "not_recommended": [
      {"target": "초고해상도 실사", "reason": "피부 질감은 Midjourney 우위"},
      {"target": "한글 텍스트", "reason": "한글 입력 불가 (영어만)"}
    ]
  }'::jsonb,
  ARRAY[
    '텍스트 입력: 글자는 큰따옴표("")로 묶기',
    '다운로드: 상업용은 Basic 이상(PNG)'
  ],
  '{
    "privacy_protection": "Public gallery for Free/Basic users"
  }'::jsonb,
  '[
    {"name": "DALL-E 3", "description": "대화형 수정 용이"},
    {"name": "Midjourney", "description": "예술적 화풍 우위"}
  ]'::jsonb,
  '[
    {"title": "Ideogram 2.0: The Future of Text in AI Images", "url": "https://www.youtube.com/results?search_query=Ideogram+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Text Rendering', 'Typography', 'Logo Design'],
  ARRAY['Image', 'Text', 'Logo', 'Design', 'Typography'],
  '[
    {"competitor": "Midjourney", "comparison": "Ideogram handles text better, Midjourney handles artistic style better"},
    {"competitor": "DALL-E 3", "comparison": "Ideogram gives more control over text rendering than DALL-E 3"}
  ]'::jsonb,
  ARRAY['정확한 텍스트 렌더링', '매직 프롬프트', '이미지 리믹스', '다양한 비율 설정', '색상 팔레트 제어']
);
