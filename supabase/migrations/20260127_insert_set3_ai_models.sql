-- Insert Wolfram Alpha, Photomath, Quizlet, Mindgrasp, Make, Vellum, Granola, Otter.ai, Fireflies.ai into ai_models table
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
-- 1. Wolfram Alpha
(
  'Wolfram Alpha',
  '단순 검색을 넘어, 방대한 전문 지식 데이터베이스와 연산 엔진을 통해 수학, 과학, 금융 문제의 "정답"과 "풀이 과정"을 도출하는 계산 지식 엔진.',
  'Wolfram Research',
  'https://www.wolframalpha.com',
  'https://upload.wikimedia.org/wikipedia/commons/e/ea/Wolfram_Alpha.png', -- Common placeholder or specific URL found
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Optional",
    "platforms": ["Web", "iOS", "Android", "ChatGPT Plugin"],
    "target_audience": "STEM Students, Researchers, Data Analysts"
  }'::jsonb,
  'Freemium',
  'Free (정답 확인) / Pro $5~9.99/월',
  '기본 연산 및 지식 검색(정답) 무료. 단계별 풀이(Step-by-step)는 유료.',
  '[
    {
      "plan": "Basic",
      "price": "Free",
      "target": "찍먹파",
      "features": "정답 및 기본 그래프 확인, 풀이 과정 불가"
    },
    {
      "plan": "Pro",
      "price": "$5-9.99/월",
      "target": "대학생",
      "features": "Step-by-step 풀이, 파일 업로드 분석, 고급 시각화"
    },
    {
      "plan": "Pro Premium",
      "price": "$24.99/월",
      "target": "전문가",
      "features": "모든 Pro 기능 + 우선 지원 + 전문가급 데이터 내보내기"
    }
  ]'::jsonb,
  ARRAY[
    '할루시네이션 제로: 100% 정확한 계산 결과와 근거 제시 (Symbolic Computation)',
    'Step-by-step: 미적분/복잡한 방정식의 풀이 과정을 교과서처럼 한 줄 한 줄 제공 (Pro)',
    '방대한 데이터: 수학뿐만 아니라 화학, 금융, 영양 등 구조화된 DB 압도적',
    'LLM 연동: ChatGPT 플러그인으로 언어 능력과 계산 능력 결합 가능'
  ],
  ARRAY[
    '자연어 이해 한계: 긴 문장형 질문보다 수식/키워드 위주 검색 필요',
    '유료 필수: 핵심인 단계별 풀이가 유료라 비용 부담'
  ],
  '[
    {"name": "Step-by-step Solutions", "description": "수학/과학 문제의 상세 풀이 과정 제공 (Pro)"},
    {"name": "Image Input", "description": "수식 사진 인식 후 풀이 (Pro)"},
    {"name": "Data Analysis", "description": "엑셀/CSV 파일 통계 분석 및 시각화"},
    {"name": "Plotting", "description": "2D/3D 그래프 생성 및 함수 시각화"},
    {"name": "Notebook Edition", "description": "코딩과 계산을 동시에 하는 노트 환경"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "이공계생", "badge": "Math", "reason": "미적분, 선형대수학 과제 풀이 과정 확인"},
      {"target": "데이터 검증", "badge": "FactCheck", "reason": "AI 리포트의 통계 수치 팩트 체크"},
      {"target": "연구자", "badge": "Graph", "reason": "논문용 정확한 과학 그래프 필요 시"}
    ],
    "not_recommended": [
      {"target": "창의적 글쓰기", "reason": "에세이나 소설 작성 도구 아님"},
      {"target": "단순 산수", "reason": "1+1 수준은 구글 검색이 더 빠름"}
    ]
  }'::jsonb,
  ARRAY[
    '구독 취소: 방학 때는 일시 정지하거나 취소하여 절약하세요.',
    '입력 언어: "differentiate x^2" 처럼 명확한 영어 명령어/수식 사용 권장'
  ],
  '{
    "privacy_protection": "Queries anonymized for service improvement"
  }'::jsonb,
  '[
    {"name": "Photomath", "description": "중고생 수준 수식은 사진 찍어 풀기 편함"},
    {"name": "Symbolab", "description": "UI가 더 직관적인 수학 전용 도구"}
  ]'::jsonb,
  '[
    {"title": "What is Wolfram|Alpha?", "url": "https://www.youtube.com/results?search_query=Wolfram+Alpha+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Math Solver', 'Symbolic Computation', 'Data Analysis'],
  ARRAY['Math', 'Science', 'Calculator', 'Graph', 'Data'],
  '[
    {"competitor": "ChatGPT", "comparison": "Wolfram Alpha is exact for math, ChatGPT can hallucinate numbers"},
    {"competitor": "Photomath", "comparison": "Wolfram handles university/research level math, Photomath is for K-12"}
  ]'::jsonb,
  ARRAY['단계별 풀이(Step-by-step)', '수식 이미지 인식', '데이터 시각화(Plotting)', '과학/금융 전문 DB', 'ChatGPT 플러그인']
),

-- 2. Photomath
(
  'Photomath',
  '스마트폰 카메라로 수학 문제를 비추기만 하면, AI가 숫자를 인식해 즉시 정답과 풀이 과정을 보여주는 구글(Google)의 수학 비서.',
  'Google',
  'https://photomath.com',
  'https://upload.wikimedia.org/wikipedia/commons/e/e0/PhotoMath_Logo.png',
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Optional",
    "platforms": ["iOS", "Android"],
    "target_audience": "K-12 Students, Parents"
  }'::jsonb,
  'Freemium',
  'Free (기본 풀이) / Plus 약 6,000원/월',
  '카메라 인식, 정답 확인, 기본 단계별 풀이 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반 학생",
      "features": "문제 인식, 정답, 기본 풀이 단계"
    },
    {
      "plan": "Plus",
      "price": "~6,000원/월",
      "target": "수포자/학부모",
      "features": "애니메이션 튜토리얼, 심층 설명, 교과서별 솔루션"
    }
  ]'::jsonb,
  ARRAY[
    '압도적 인식률: 개발새발 쓴 손글씨도 정확히 인식 (최상위 OCR)',
    '직관적 풀이: 변환 과정을 말풍선으로 친절하게 설명',
    '접근성: 구글 인수 후 앱 안정성 향상 및 깔끔한 UI',
    '애니메이션(Plus): 그래프나 이항 과정을 동영상처럼 시각적으로 보여줌'
  ],
  ARRAY[
    '대학 수학 한계: 고등 수준(미적분 기초)까지만 완벽, 복잡한 공학 수학은 불가',
    '문장제 문제: 서술형 문제 인식 능력은 LLM보다 떨어짐'
  ],
  '[
    {"name": "Camera Scan", "description": "손글씨 및 인쇄된 수식 스캔"},
    {"name": "Step-by-step", "description": "단계별 풀이 과정 텍스트 제공"},
    {"name": "Smart Calculator", "description": "직접 입력 가능한 공학용 계산기 UI"},
    {"name": "Animated Tutorial", "description": "풀이 과정 시각화 애니메이션 (Plus)"},
    {"name": "Textbook Solutions", "description": "주요 교과서 페이지별 해설"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "중고등학생", "badge": "Math", "reason": "혼자 공부하다 답지 봐도 모를 때"},
      {"target": "학부모", "badge": "Helper", "reason": "자녀 질문에 당황하지 않고 확인용"},
      {"target": "검산용", "badge": "Review", "reason": "내가 푼 답 빠르게 확인"}
    ],
    "not_recommended": [
      {"target": "대학생", "reason": "전공 수학은 울프람알파 권장"},
      {"target": "숙제 대행", "reason": "베끼기만 하면 실력 안 늠"}
    ]
  }'::jsonb,
  ARRAY[
    '손글씨: 너무 흘려쓰면 오인식 가능하니 또박또박 쓰세요.',
    '구글 렌즈: 앱 설치 귀찮으면 구글 렌즈 과제 검색 기능 활용 가능'
  ],
  '{
    "privacy_protection": "Google privacy policy applies"
  }'::jsonb,
  '[
    {"name": "Qanda", "description": "서술형 문제나 한국 명문대 풀이 필요 시"},
    {"name": "Wolfram Alpha", "description": "더 전문적인 대학 수학용"}
  ]'::jsonb,
  '[
    {"title": "Photomath Plus: Learning Math made easy", "url": "https://www.youtube.com/results?search_query=Photomath+official", "platform": "YouTube"}
  ]'::jsonb,
  '5.0',
  ARRAY['Math Helper', 'Homework', 'OCR'],
  ARRAY['Math', 'Mobile', 'Camera', 'Google', 'Student'],
  '[
    {"competitor": "Qanda", "comparison": "Photomath is better at raw calculation/OCR, Qanda at word problems"},
    {"competitor": "Wolfram Alpha", "comparison": "Photomath is easier for simple algebra, Wolfram for complex calculus"}
  ]'::jsonb,
  ARRAY['카메라 수식 인식', '단계별 풀이', '애니메이션 튜토리얼', '스마트 계산기', '교과서 해설']
),

-- 3. Quizlet Q-Chat
(
  'Quizlet Q-Chat',
  '전 세계 1위 암기 카드 서비스 "퀴즈렛"에 OpenAI 기술이 결합된 AI 튜터로, 소크라테스 문답법으로 사용자의 학습을 유도하는 대화형 코치.',
  'Quizlet',
  'https://quizlet.com/features/q-chat',
  'https://placehold.co/200x200?text=Q', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "iOS", "Android"],
    "target_audience": "Students, Language Learners"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Plus $35.99/년',
  'Q-Chat 체험판 사용 가능(하루 횟수 제한).',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "라이트 유저",
      "features": "학습 세트 생성, 광고 포함, Q-Chat 제한적 사용"
    },
    {
      "plan": "Plus",
      "price": "$35.99/년",
      "target": "수험생",
      "features": "Q-Chat 무제한, 광고 제거, 오프라인 학습"
    }
  ]'::jsonb,
  ARRAY[
    '소크라테스식 문답: 정답을 바로 주지 않고 질문을 던져 스스로 생각하게 유도',
    '학습 세트 연동: 내 단어장 기반으로 퀴즈를 내어 범위 이탈 방지',
    '다양한 모드: 퀴즈, 심화 학습, 스토리텔링 등 성격 변경 가능',
    '언어 학습: 외국어 회화 연습과 문법 교정 동시 가능'
  ],
  ARRAY[
    '유료화: Q-Chat 제대로 쓰려면 유료 구독 필수',
    '깊이 한계: 논리적 추론보다는 암기와 개념 확인에 특화'
  ],
  '[
    {"name": "Quiz Me", "description": "학습 세트 기반 즉석 퀴즈 출제"},
    {"name": "Deepen Understanding", "description": "심층 이해를 위한 꼬리 질문"},
    {"name": "Practice with Sentences", "description": "단어 활용 작문 연습"},
    {"name": "Story Mode", "description": "암기 내용을 이야기로 각색"},
    {"name": "Flashcards Integration", "description": "기존 학습 세트와 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "단어 암기", "badge": "Vocab", "reason": "영단어, 의학 용어 등 암기 과목"},
      {"target": "능동적 학습", "badge": "Active", "reason": "AI와 대화하며 인출(Output) 연습"},
      {"target": "수업 복습", "badge": "Review", "reason": "배운 내용 바로 테스트"}
    ],
    "not_recommended": [
      {"target": "수학 풀이", "reason": "계산 툴 아님"},
      {"target": "자료 생성", "reason": "PPT/글쓰기 생성 툴 아님"}
    ]
  }'::jsonb,
  ARRAY[
    '세트 선택: 시작 전 학습 세트를 먼저 선택해야 함',
    '언어 설정: "한국어로 설명해줘" 요청 시 한국어 모드 전환 가능'
  ],
  '{
    "privacy_protection": "Uses OpenAI API, standard privacy policy"
  }'::jsonb,
  '[
    {"name": "Anki", "description": "무료로 강력한 암기 도구 (AI는 플러그인 필요)"},
    {"name": "Kahoot!", "description": "다같이 푸는 게임형 퀴즈"}
  ]'::jsonb,
  '[
    {"title": "Meet Q-Chat", "url": "https://www.youtube.com/results?search_query=Quizlet+Q-Chat+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Flashcards', 'Language Learning', 'Study Aid'],
  ARRAY['Study', 'Flashcard', 'Quiz', 'Language', 'Tutor'],
  '[
    {"competitor": "Anki", "comparison": "Quizlet is easier to use, Anki is more customizable and free"},
    {"competitor": "ChatGPT", "comparison": "Q-Chat is grounded in your specific study sets"}
  ]'::jsonb,
  ARRAY['소크라테스식 문답', '학습 세트 연동', '스토리 모드', '맞춤형 퀴즈', '언어 회화 연습']
),

-- 4. Mindgrasp
(
  'Mindgrasp',
  '강의 영상, PDF, PPT 파일을 업로드하면 AI가 내용을 분석해 요약 노트, 플래시카드, 퀴즈를 자동으로 생성해 주는 "학습 자료 제작기".',
  'Mindgrasp AI',
  'https://mindgrasp.ai',
  'https://placehold.co/200x200?text=M', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "iOS App"],
    "target_audience": "University Students, ADHD Learners"
  }'::jsonb,
  'Subscription',
  'Basic $6.99/월 / Scholar $9.99/월',
  '4일 무료 체험 후 유료 전환됨 (완전 무료 플랜 없음)',
  '[
    {
      "plan": "Basic",
      "price": "$6.99/월",
      "target": "가벼운 학습",
      "features": "월 제한적 업로드, 기본 요약"
    },
    {
      "plan": "Scholar",
      "price": "$9.99/월",
      "target": "대학생",
      "features": "무제한 업로드, 퀴즈/플래시카드 생성, 웹 검색"
    }
  ]'::jsonb,
  ARRAY[
    '멀티모달: 텍스트, 유튜브, MP3, 줌 영상까지 분석해 요약 (최대 강점)',
    '자동 퀴즈: 자료 기반 예상 문제 생성으로 셀프 테스트 용이',
    '웹 검색: 파일 없이도 주제 검색 및 요약 가능',
    '접근성: ADHD/난독증 학습자를 위한 요약 및 음성 읽기 기능'
  ],
  ARRAY[
    '유료 필수: 체험판만 있고 무료 플랜 없음',
    '한국어 정확도: STT 발음 인식률에 따라 오타 발생 가능'
  ],
  '[
    {"name": "Video/Audio Summarizer", "description": "영상/음성 파일을 텍스트 노트로 변환"},
    {"name": "Smart Notes", "description": "핵심 내용 구조화 요약"},
    {"name": "Flashcard Generator", "description": "중요 개념 카드 생성"},
    {"name": "Quiz Maker", "description": "객관식/주관식 예상 문제 생성"},
    {"name": "Web Search", "description": "인터넷 검색 기반 답변"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "녹음 러너", "badge": "Audio", "reason": "강의 녹음파일 다시 듣기 귀찮을 때"},
      {"target": "시험 벼락치기", "badge": "Exam", "reason": "방대한 분량 빠른 요약"},
      {"target": "영상 학습", "badge": "Video", "reason": "유튜브 강의 필기 자동화"}
    ],
    "not_recommended": [
      {"target": "무료 선호", "reason": "NotebookLM이나 ChatPDF 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '구독 해지: 4일 체험 짧으니 주의',
    '저작권: 요약본 판매/공유 시 저작권 주의'
  ],
  '{
    "privacy_protection": "Files stored in private library"
  }'::jsonb,
  '[
    {"name": "NotebookLM", "description": "기능 유사하고 완전 무료 (강력 추천)"},
    {"name": "ChatPDF", "description": "PDF 분석 집중 시"}
  ]'::jsonb,
  '[
    {"title": "Mindgrasp AI Study Tool", "url": "https://www.youtube.com/results?search_query=Mindgrasp+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Note Taking', 'Summarization', 'Flashcards', 'Video Summary'],
  ARRAY['Study', 'Summary', 'Video', 'Note', 'ADHD'],
  '[
    {"competitor": "NotebookLM", "comparison": "Mindgrasp has better mobile app, NotebookLM is free"},
    {"competitor": "Otter", "comparison": "Mindgrasp creates study materials, Otter creates transcripts"}
  ]'::jsonb,
  ARRAY['영상/음성 요약', '스마트 노트 생성', '자동 플래시카드', '예상 문제 퀴즈', '웹 검색 기반 요약']
),

-- 5. Make
(
  'Make',
  '"이거 되면 저거 해" — 앱과 앱을 구슬 꿰듯이 시각적으로 연결하여 복잡한 업무 프로세스를 자동화하는 노코드(No-code) 플랫폼.',
  'Celonis',
  'https://www.make.com',
  'https://upload.wikimedia.org/wikipedia/commons/1/1f/Make_Logo_RGB.png', -- Found on wikimedia usually, placeholder check
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Marketers, Developers, Automators"
  }'::jsonb,
  'Freemium',
  'Free (1,000 Ops) / Core $9/월',
  '월 1,000 Ops 무료. 다단계 시나리오 가능.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인/테스트",
      "features": "1,000 Ops/월, 복잡한 시나리오 가능"
    },
    {
      "plan": "Core",
      "price": "$9/월",
      "target": "사업자",
      "features": "10,000 Ops/월, 1분 간격 실행"
    }
  ]'::jsonb,
  ARRAY[
    '시각적 편집: 노드 연결 방식이 매우 직관적',
    'AI Assistant: 자연어로 시나리오 초안 생성',
    '가성비: Zapier 대비 저렴하고 무료 혜택 우수',
    '복잡한 로직: 조건문, 반복문, JSON 파싱 등 정교한 구현 가능'
  ],
  ARRAY[
    '러닝 커브: Zapier보다 배우는 데 시간 필요',
    'Ops 소모: 잘못 짜면 크레딧 순삭 가능성'
  ],
  '[
    {"name": "Scenario Builder", "description": "무한 캔버스 자동화 설계"},
    {"name": "AI Assistant", "description": "자연어 시나리오 생성"},
    {"name": "Router/Filter", "description": "조건부 흐름 분기"},
    {"name": "Data Store", "description": "내부 데이터 저장소"},
    {"name": "Error Handling", "description": "에러 발생 시 재시도/알림"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "마케터", "badge": "Marketing", "reason": "리드 수집 및 자동화 프로세스 구축"},
      {"target": "쇼핑몰", "badge": "Commerce", "reason": "주문 알림 및 고객 메시지 발송"},
      {"target": "비용 절감", "badge": "Saving", "reason": "Zapier 비용 부담 시 이동"}
    ],
    "not_recommended": [
      {"target": "초간단 연결", "reason": "단순 작업은 IFTTT나 Zapier가 더 쉬움"},
      {"target": "영어 울렁증", "reason": "UI 영문 필수"}
    ]
  }'::jsonb,
  ARRAY[
    'Ops 낭비 주의: 테스트 시 데이터 1개만 사용 권장',
    'Webhook 권장: 주기적 폴링(Polling)보다 웹훅이 효율적'
  ],
  '{
    "privacy_protection": "GDPR compliant, ISO 27001"
  }'::jsonb,
  '[
    {"name": "Zapier", "description": "더 쉽고 미국 앱 연동 많음 (비쌈)"},
    {"name": "n8n", "description": "서버 설치형 무료 도구"}
  ]'::jsonb,
  '[
    {"title": "What is Make?", "url": "https://www.youtube.com/results?search_query=Make+automation+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Workflow Automation', 'Integration', 'No-code'],
  ARRAY['Automation', 'No-code', 'Integration', 'Workflow', 'Bot'],
  '[
    {"competitor": "Zapier", "comparison": "Make is more visual and cheaper, Zapier is easier"},
    {"competitor": "n8n", "comparison": "Make is cloud-first, n8n is self-hosted first"}
  ]'::jsonb,
  ARRAY['시각적 시나리오 빌더', 'AI 어시스턴트', '조건부 라우팅', '데이터 스토어', '에러 핸들링']
),

-- 6. Vellum
(
  'Vellum',
  'LLM 앱을 개발하는 엔지니어를 위한 IDE로, 여러 AI 모델(GPT, Claude 등)을 비교 테스트하고 프롬프트를 관리하며 배포까지 돕는 개발 툴.',
  'Vellum.ai',
  'https://www.vellum.ai',
  'https://placehold.co/200x200?text=V', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "AI Engineers, Prompt Engineers"
  }'::jsonb,
  'Paid Only',
  '기업용 B2B (데모 요청)',
  '무료 플랜 없음 (데모 요청 필수).',
  '[
    {
      "plan": "Starter",
      "price": "문의",
      "target": "초기 팀",
      "features": "모델 비교, 프롬프트 버전 관리"
    },
    {
      "plan": "Growth",
      "price": "문의",
      "target": "성장기",
      "features": "대량 테스트(Batch), 협업"
    }
  ]'::jsonb,
  ARRAY[
    '모델 비교: GPT, Claude, Gemini 동시 테스트 및 성능 비교',
    '버전 관리: 프롬프트 수정 이력 Git처럼 관리 및 롤백',
    '평가(Eval): 정량적 테스트로 프롬프트 성능 검증',
    '통합 API: 단일 Proxy API로 여러 모델 교체 용이'
  ],
  ARRAY[
    '비개발자 비추: AI 앱 개발자 전용 툴',
    '가격: 개인 취미용으로는 고가'
  ],
  '[
    {"name": "Prompt Playground", "description": "다중 모델 병렬 테스트"},
    {"name": "Evaluations", "description": "응답 품질 자동 채점"},
    {"name": "Version Control", "description": "프롬프트 이력 관리"},
    {"name": "Workflows", "description": "RAG 파이프라인 구축"},
    {"name": "Proxy API", "description": "단일 인터페이스 모델 연결"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "AI 스타트업", "badge": "Startup", "reason": "최적의 LLM 모델 선정 및 비용 최적화"},
      {"target": "프롬프트 엔지니어", "badge": "Prompt", "reason": "성능 개선 수치 증명"},
      {"target": "비용 최적화", "badge": "Cost", "reason": "저가 모델로 고성능 튜닝"}
    ],
    "not_recommended": [
      {"target": "일반 사용자", "reason": "단순 대화용 아님"},
      {"target": "문서 작성", "reason": "전자책 툴 Vellum 아님"}
    ]
  }'::jsonb,
  ARRAY[
    '이름 혼동: 전자책 SW Vellum과 다름',
    'API 키: BYOK(Bring Your Own Key) 방식일 수 있음'
  ],
  '{
    "privacy_protection": "SOC 2 Type II, No training on customer data"
  }'::jsonb,
  '[
    {"name": "LangSmith", "description": "LangChain 기반 오픈소스 모니터링"},
    {"name": "PromptLayer", "description": "로그 추적 특화"}
  ]'::jsonb,
  '[
    {"title": "Vellum.ai Demo", "url": "https://www.youtube.com/results?search_query=Vellum.ai+demo", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['LLM Ops', 'Prompt Engineering', 'Evaluation'],
  ARRAY['Developer', 'LLM', 'Prompt', 'Testing', 'API'],
  '[
    {"competitor": "LangSmith", "comparison": "Vellum has better UI for non-coders/PMs"},
    {"competitor": "PromptLayer", "comparison": "Vellum offers more robust evaluation features"}
  ]'::jsonb,
  ARRAY['프롬프트 플레이그라운드', '자동 평가(Evaluation)', '버전 관리(Git style)', 'RAG 워크플로우', '통합 Proxy API']
),

-- 7. Granola
(
  'Granola',
  '단순히 받아쓰기만 하는 게 아니라, 내가 쓴 메모를 바탕으로 AI가 살을 붙여 완벽한 회의록을 완성해 주는 "인간 주도형" AI 미팅 노트.',
  'Granola',
  'https://granola.ai',
  'https://placehold.co/200x200?text=G', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["macOS"],
    "target_audience": "Mac Users, PMs, Designers"
  }'::jsonb,
  'Freemium',
  'Free (월 5회) / Pro $10/월',
  '월 5회 무료. 횟수 제한 있음.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "라이트 유저",
      "features": "월 5회 회의, 기본 템플릿"
    },
    {
      "plan": "Pro",
      "price": "$10/월",
      "target": "직장인",
      "features": "무제한 회의, 커스텀 템플릿"
    }
  ]'::jsonb,
  ARRAY[
    'Human-in-the-loop: 내 키워드 메모 + AI 작문으로 정확도 높음',
    '템플릿 커스텀: 회의 목적별(인터뷰, 투자 등) 상세 양식 설정',
    '비봇(No-bot): 봇 참여 없이 맥 시스템 오디오 직접 녹음',
    '디자인: 예쁘고 직관적인 UI'
  ],
  ARRAY[
    '맥 전용: 윈도우 지원 불가',
    '영어 최적화: 한국어 인식률은 경쟁사 대비 낮을 수 있음'
  ],
  '[
    {"name": "Audio Recording", "description": "시스템 오디오 녹음 (봇 X)"},
    {"name": "AI Enhancement", "description": "메모+녹음 결합 회의록 작성"},
    {"name": "Custom Templates", "description": "나만의 양식 생성"},
    {"name": "Shareable Links", "description": "링크/텍스트 공유"},
    {"name": "Smart Formatting", "description": "할 일/결정 사항 추출"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "프로덕트 매니저", "badge": "PM", "reason": "구조적인 회의록 품질 중요"},
      {"target": "맥북 유저", "badge": "Mac", "reason": "네이티브 앱 선호"},
      {"target": "녹음 봇 혐오", "badge": "Privacy", "reason": "조용한 녹음 선호"}
    ],
    "not_recommended": [
      {"target": "윈도우 유저", "reason": "설치 불가"},
      {"target": "완전 자동화", "reason": "메모조차 안 하려면 Otter 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '이어폰 필수: 하울링 방지',
    '메모 습관: 핵심 키워드를 적어줘야 퀄리티 상승'
  ],
  '{
    "privacy_protection": "Local-centric processing, no bot intrusion"
  }'::jsonb,
  '[
    {"name": "Otter.ai", "description": "완전 자동화 & 윈도우 지원"},
    {"name": "Supernormal", "description": "구글 미트 확장 프로그램"}
  ]'::jsonb,
  '[
    {"title": "Granola: The notepad that listens", "url": "https://www.youtube.com/results?search_query=Granola+AI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Meeting Notes', 'Mac App', 'Productivity'],
  ARRAY['Meeting', 'Notes', 'Mac', 'AI', 'Recorder'],
  '[
    {"competitor": "Otter", "comparison": "Granola keeps humans in the loop for better quality, Otter is fully auto"},
    {"competitor": "Clova Note", "comparison": "Granola has better templates, Clova Note better Korean"}
  ]'::jsonb,
  ARRAY['시스템 오디오 녹음(No-bot)', 'AI 메모 확장', '커스텀 템플릿', '할 일 자동 추출', 'Mac 전용 네이티브']
),

-- 8. Otter.ai
(
  'Otter.ai',
  '줌, 구글 미트, 팀즈 회의에 가상 비서(OtterPilot)를 보내 자동으로 대화를 받아 적고, 요약하고, 질문까지 받아주는 원조 AI 회의록 서비스.',
  'Otter.ai',
  'https://otter.ai',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Otter_ai_logo.png/600px-Otter_ai_logo.png', -- Common logo
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Required",
    "platforms": ["Web", "Mobile", "Chrome Extension"],
    "target_audience": "Business Professionals, Students"
  }'::jsonb,
  'Freemium',
  'Free (월 300분) / Pro $10/월',
  '월 300분 무료 (회의당 30분 제한).',
  '[
    {
      "plan": "Basic",
      "price": "Free",
      "target": "개인",
      "features": "300분/월, 회의당 30분"
    },
    {
      "plan": "Pro",
      "price": "$10/월",
      "target": "직장인",
      "features": "1200분/월, 회의당 90분, 고급 검색"
    }
  ]'::jsonb,
  ARRAY[
    'OtterPilot: 캘린더 연동 시 자동 참여/녹음 (지각/불참 시 유용)',
    'Otter Chat: 회의 중 실시간 질문 답변 (Q&A)',
    '스크립트 동기화: 텍스트 클릭 시 해당 음성 재생',
    '슬라이드 캡처: 화상 회의 화면(PPT) 자동 캡처'
  ],
  ARRAY[
    '영어 중심: 한국어 인식은 클로바노트 대비 부족',
    '무료 제한: 회의당 30분 끊김 현상'
  ],
  '[
    {"name": "OtterPilot", "description": "자동 참여 및 녹기록"},
    {"name": "Real-time Transcript", "description": "실시간 음성 텍스트 변환"},
    {"name": "Automated Summary", "description": "종료 후 이메일 요약 발송"},
    {"name": "Otter Chat", "description": "회의 내용 AI 질의응답"},
    {"name": "Slide Capture", "description": "화면 캡처 삽입"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "글로벌 미팅", "badge": "English", "reason": "영어 회의 놓치지 않기"},
      {"target": "더블 부킹", "badge": "Busy", "reason": "몸이 두 개여야 할 때 봇 대리 참석"},
      {"target": "유학생", "badge": "Study", "reason": "영어 강의 녹음 및 복습"}
    ],
    "not_recommended": [
      {"target": "한국어 회의", "reason": "클로바노트 권장"},
      {"target": "보안 민감", "reason": "봇 참여 꺼리는 환경"}
    ]
  }'::jsonb,
  ARRAY[
    '봇 강퇴 주의: 사전 양해 구해 불쾌감 방지',
    '캘린더 설정: 개인 일정에 따라오지 않도록 확인'
  ],
  '{
    "privacy_protection": "Data may be used for training unless on Business plan"
  }'::jsonb,
  '[
    {"name": "Fireflies.ai", "description": "CRM 연동 및 영업 분석 특화"},
    {"name": "Clova Note", "description": "한국어 최고 성능"}
  ]'::jsonb,
  '[
    {"title": "Meet OtterPilot", "url": "https://www.youtube.com/results?search_query=Otter.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '3.0',
  ARRAY['Transcribing', 'Meeting Minutes', 'Automated Note'],
  ARRAY['Meeting', 'Voice', 'Record', 'Transcript', 'Bot'],
  '[
    {"competitor": "Fireflies", "comparison": "Otter is better for general use, Fireflies for sales teams"},
    {"competitor": "Zoom", "comparison": "Otter offers better search and summaries than native Zoom recording"}
  ]'::jsonb,
  ARRAY['오터파일럿(자동참여)', '실시간 스크립트', '자동 요약 이메일', 'Otter Chat', '슬라이드 자동 캡처']
),

-- 9. Fireflies.ai
(
  'Fireflies.ai',
  '"Fred"라는 이름의 AI 봇이 회의를 기록하고, 감정 분석, 발언 점유율 분석, CRM 자동 입력까지 해주는 영업/비즈니스 특화 회의 분석기.',
  'Fireflies.ai',
  'https://fireflies.ai',
  'https://placehold.co/200x200?text=F', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "Zoom/Meet/Teams Integration"],
    "target_audience": "Sales Teams, Recruiters"
  }'::jsonb,
  'Freemium',
  'Free (800분) / Pro $10/월',
  '월 800분 무료. AI 요약은 제한.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "개인",
      "features": "800분/월, 검색"
    },
    {
      "plan": "Pro",
      "price": "$10/월",
      "target": "팀",
      "features": "8000분/월, AI 요약, 스마트 검색"
    },
    {
      "plan": "Business",
      "price": "$19/월",
      "target": "영업팀",
      "features": "분석(감정/비율), CRM 연동, 영상 녹화"
    }
  ]'::jsonb,
  ARRAY[
    'AskFred: 회의 후 질문 답변 및 이메일 초안 작성',
    'Conversation Intelligence: 발언 점유율, 감정 분석 데이터 제공 (관리자용)',
    'CRM 연동: 세일즈포스/허브스팟 자동 입력',
    'Soundbites: 중요 순간 오디오 클립 공유'
  ],
  ARRAY[
    '비디오 제한: 오디오 중심 분석 (화면 녹화 약함)',
    '설정 복잡: 기능이 많아 초기 세팅 시간 소요'
  ],
  '[
    {"name": "Fred Bot", "description": "모든 플랫폼 자동 참여"},
    {"name": "Super Summaries", "description": "핵심/액션아이템 요약"},
    {"name": "AskFred", "description": "AI 질의응답 챗봇"},
    {"name": "Sentiment Analysis", "description": "감정 흐름 분석"},
    {"name": "Topic Tracker", "description": "키워드 추적"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "영업 팀장", "badge": "Sales", "reason": "고객 반응 및 팀원 성과 분석"},
      {"target": "면접관", "badge": "Hiring", "reason": "지원자 답변 리뷰 및 클립 공유"},
      {"target": "CRM 사용자", "badge": "CRM", "reason": "로그 입력 자동화"}
    ],
    "not_recommended": [
      {"target": "단순 기록", "reason": "Otter가 더 가벼움"},
      {"target": "화면 녹화", "reason": "비디오 중심이면 Fathom 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '무료 요약 제한: 녹음 시간은 많아도 AI 요약 횟수 확인',
    '알림 설정: Fred 참여 알림 사전 공지'
  ],
  '{
    "privacy_protection": "SOC 2 Type II, GDPR, Encrypted storage"
  }'::jsonb,
  '[
    {"name": "Otter.ai", "description": "교육/개인 범용"},
    {"name": "Gong.io", "description": "엔터프라이즈급 영업 분석"}
  ]'::jsonb,
  '[
    {"title": "Automate Meeting Notes", "url": "https://www.youtube.com/results?search_query=Fireflies.ai+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Sales AI', 'Meeting Intelligence', 'CRM Automation'],
  ARRAY['Sales', 'Meeting', 'CRM', 'Analysis', 'Bot'],
  '[
    {"competitor": "Otter", "comparison": "Fireflies offers deeper analytics (sentiment, talk time), Otter is better for transcripts"},
    {"competitor": "Gong", "comparison": "Fireflies is more affordable and accessible for smaller teams"}
  ]'::jsonb,
  ARRAY['Fred 봇(자동참여)', 'AI 슈퍼 요약', '대화 분석(감정/점유율)', 'CRM 자동 연동', '사운드바이트 클립']
);
