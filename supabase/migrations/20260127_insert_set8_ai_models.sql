-- Insert Pinecone, LangSmith, Phind, Agent Factory (Concept), AutoDev, Teal into ai_models table
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
-- 1. Pinecone
(
  'Pinecone',
  'AI 장기기억(Long-term Memory)의 핵심인 "벡터 데이터베이스"를 서버 관리 없이 API로 간편하게 제공하는 매니지드 서비스.',
  'Pinecone',
  'https://www.pinecone.io',
  'https://cdn.worldvectorlogo.com/logos/pinecone.svg', -- Common vector source
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web", "API"],
    "target_audience": "AI Developers, RAG Engineers"
  }'::jsonb,
  'Freemium',
  'Starter Free / Serverless (Usage-based)',
  '1개 프로젝트, 10만 벡터 저장 무료.',
  '[
    {
      "plan": "Starter",
      "price": "Free",
      "target": "입문자",
      "features": "1개 인덱스, 10만 벡터, 공유 하드웨어"
    },
    {
      "plan": "Serverless",
      "price": "Usage",
      "target": "실무자",
      "features": "무제한 인덱스, 사용량 기반 과금(Read/Write Unit)"
    },
    {
      "plan": "Pod-based",
      "price": "Hourly",
      "target": "기업",
      "features": "전용 하드웨어 할당, 예측 가능 비용"
    }
  ]'::jsonb,
  ARRAY[
    'Serverless: 서버 관리 없이 사용량만큼만 지불 (비용 효율적)',
    '초고속 검색: 수십억 벡터 중 유사 문맥 밀리초 단위 검색',
    '관리 불필요: 인프라/스케일링 자동화',
    '하이브리드 검색: 키워드(BM25) + 벡터(Semantic) 결합'
  ],
  ARRAY[
    '비용 예측: 트래픽 폭증 시 요금 급증 가능성',
    '로컬 불가: 클라우드 전용이라 폐쇄망 사용 불가'
  ],
  '[
    {"name": "Vector Search", "description": "텍스트/이미지 벡터 유사도 검색"},
    {"name": "Serverless Architecture", "description": "자동 스케일링 및 종량제"},
    {"name": "Hybrid Search", "description": "의미 + 키워드 검색 결합"},
    {"name": "Metadata Filtering", "description": "속성 기반 필터링 검색"},
    {"name": "Multitenancy", "description": "데이터 격리 및 보안"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "RAG 개발자", "badge": "RAG", "reason": "매뉴얼 질문답변 시스템 구축"},
      {"target": "추천 시스템", "badge": "RecSys", "reason": "유사 상품/콘텐츠 추천"},
      {"target": "서버 관리 귀차니즘", "badge": "Managed", "reason": "인프라 관리 없이 API로 해결"}
    ],
    "not_recommended": [
      {"target": "완전 무료", "reason": "대규모 상용 무료는 Chroma/Milvus 추천"},
      {"target": "오프라인", "reason": "인터넷 필수"}
    ]
  }'::jsonb,
  ARRAY[
    'Dimension 일치: 모델 차원수(예: 1536)와 인덱스 설정 일치 필수',
    '무료 인덱스 삭제: Starter 인덱스 7일 미사용 시 삭제 주의'
  ],
  '{
    "privacy_protection": "SOC 2 Type II, PrivateLink available"
  }'::jsonb,
  '[
    {"name": "ChromaDB", "description": "로컬 설치 가능한 무료 오픈소스"},
    {"name": "Weaviate", "description": "커스터마이징 가능한 오픈소스 DB"}
  ]'::jsonb,
  '[
    {"title": "Introduction to Pinecone Serverless", "url": "https://www.youtube.com/results?search_query=Pinecone+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Vector DB', 'RAG', 'Semantic Search', 'Serverless'],
  ARRAY['Database', 'Vector', 'Search', 'AI', 'RAG'],
  '[
    {"competitor": "Chroma", "comparison": "Pinecone is fully managed (cloud), Chroma is open-source (local/cloud)"},
    {"competitor": "Weaviate", "comparison": "Pinecone is simpler to start, Weaviate offers more modular customization"}
  ]'::jsonb,
  ARRAY['벡터 검색(Vector Search)', '서버리스 아키텍처', '하이브리드 검색', '메타데이터 필터링', '멀티테넌시']
),

-- 2. LangSmith
(
  'LangSmith',
  'LLM 앱 개발 프레임워크인 "LangChain" 팀이 만든 도구로, AI가 내놓은 답변 과정을 추적(Tracing)하고 테스트/평가하는 LLM Ops 플랫폼.',
  'LangChain',
  'https://smith.langchain.com',
  'https://upload.wikimedia.org/wikipedia/commons/5/5a/LangChain_logo.png', -- Using LangChain logo as proxy
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "LLM App Developers, Prompt Engineers"
  }'::jsonb,
  'Freemium',
  'Developer Free / Plus $39/월',
  '월 5,000 트레이스 무료. 14일 보관.',
  '[
    {
      "plan": "Developer",
      "price": "Free",
      "target": "개인",
      "features": "5,000 Trace/월, 14일 보관"
    },
    {
      "plan": "Plus",
      "price": "$39/월",
      "target": "팀",
      "features": "Trace 무제한(종량제), 400일 보관, 협업"
    },
    {
      "plan": "Enterprise",
      "price": "Custom",
      "target": "대기업",
      "features": "보안 강화, 전담 지원"
    }
  ]'::jsonb,
  ARRAY[
    '투명한 디버깅: 프롬프트부터 결과까지 전체 체인 시각화 (X-ray)',
    'Prompt Playground: 웹에서 프롬프트 즉시 수정 및 테스트',
    'Dataset & Testing: 골든 데이터셋 기반 자동 평가 및 회귀 테스트',
    'LangChain 최적화: 랭체인 코드와 완벽 연동'
  ],
  ARRAY[
    '종속성: 랭체인 환경에서 가장 강력함',
    '비용 증가: 고트래픽 서비스 시 Trace 비용 발생'
  ],
  '[
    {"name": "Tracing", "description": "LLM 입출력 및 비용 시각화"},
    {"name": "Prompt Hub", "description": "프롬프트 버전 관리"},
    {"name": "Evaluation", "description": "자동 채점 및 평가"},
    {"name": "Annotation", "description": "사람의 피드백(Human Loop)"},
    {"name": "Monitoring", "description": "에러율 및 토큰 대시보드"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "AI 앱 개발자", "badge": "Debug", "reason": "환각 현상(Hallucination) 원인 추적"},
      {"target": "프롬프트 엔지니어", "badge": "Prompt", "reason": "A/B 테스트 및 버전 관리"},
      {"target": "품질 관리", "badge": "QA", "reason": "RAG 정확도 정량 측정"}
    ],
    "not_recommended": [
      {"target": "단순 사용자", "reason": "개발자용 로그 데이터 도구"},
      {"target": "로컬 로깅", "reason": "자체 호스팅 필요 시 LangFuse 추천"}
    ]
  }'::jsonb,
  ARRAY[
    'API Key: 서버 환경변수에만 저장 (프론트엔드 노출 금지)',
    'Trace 필터링: 운영 환경에서는 샘플링하여 비용 절감'
  ],
  '{
    "privacy_protection": "PII masking recommended"
  }'::jsonb,
  '[
    {"name": "LangFuse", "description": "오픈소스/셀프호스팅 가능"},
    {"name": "Arize Phoenix", "description": "LLM 관측 및 평가 특화"}
  ]'::jsonb,
  '[
    {"title": "LangSmith Walkthrough", "url": "https://www.youtube.com/results?search_query=LangSmith+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['LLMOps', 'Tracing', 'Evaluation', 'Debugging'],
  ARRAY['LLM', 'Ops', 'Debug', 'Test', 'LangChain'],
  '[
    {"competitor": "LangFuse", "comparison": "LangSmith is SaaS optimized for LangChain, LangFuse is open-source and framework agnostic"},
    {"competitor": "WandB", "comparison": "LangSmith focuses on chains/agents, WandB focuses on model training metrics"}
  ]'::jsonb,
  ARRAY['트레이싱(Tracing)', '프롬프트 플레이그라운드', '자동 평가(Eval)', '데이터셋 관리', '모니터링 대시보드']
),

-- 3. Phind
(
  'Phind',
  '"개발자를 위한 구글" — 스택오버플로우나 공식 문서를 뒤질 필요 없이, 코딩 질문에 특화된 답변과 최신 코드를 찾아주는 AI 검색 엔진.',
  'Phind',
  'https://www.phind.com',
  'https://placehold.co/200x200?text=P', -- Placeholder as strict logo not found
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Optional",
    "platforms": ["Web", "VS Code Extension"],
    "target_audience": "Developers"
  }'::jsonb,
  'Freemium',
  'Free (70B 모델) / Pro $20/월',
  'Phind-70B 모델 무제한 무료. (GPT-4급 코딩 성능).',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반 개발자",
      "features": "Phind-70B 무제한, GPT-4 제한적 사용"
    },
    {
      "plan": "Pro",
      "price": "$20/월",
      "target": "헤비 유저",
      "features": "GPT-4o/Claude 3.5 무제한, 비공개 모드"
    }
  ]'::jsonb,
  ARRAY[
    '개발자 특화: 최신 공식 문서(Docs) 기반 검색 탁월',
    'Phind-70B: 무료 제공 자체 모델의 뛰어난 코딩 성능',
    'VS Code 연동: 에디터 내에서 바로 검색 및 코드 적용',
    '출처 표시: StackOverflow/Github 등 근거 링크 제공'
  ],
  ARRAY[
    '일반 상식: 코딩 외 질문 답변은 ChatGPT보다 약함',
    '유료 차별: 범용 최상위 모델 무제한은 유료'
  ],
  '[
    {"name": "AI Search", "description": "개발자 특화 검색 엔진"},
    {"name": "Phind-70B Model", "description": "코딩 특화 고성능 무료 모델"},
    {"name": "Pair Programmer", "description": "VS Code 실시간 가이드"},
    {"name": "Sources", "description": "답변 근거 문서 링크"},
    {"name": "Repo Context", "description": "내 리포지토리 문맥 파악 (Pro)"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "디버깅 지옥", "badge": "Debug", "reason": "에러 로그 복붙으로 해결책 찾기"},
      {"target": "최신 기술", "badge": "Docs", "reason": "최신 라이브러리 공식 문서 검색"},
      {"target": "가성비", "badge": "Free", "reason": "GPT-4급 코딩 비서 무료 사용"}
    ],
    "not_recommended": [
      {"target": "비개발자", "reason": "일반 검색은 Perplexity 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '모델 확인: 무료 유저는 Phind-70B 사용 확인',
    '확장 프로그램: VS Code Extension 설치 권장'
  ],
  '{
    "privacy_protection": "Opt-out available for data training"
  }'::jsonb,
  '[
    {"name": "Perplexity", "description": "범용 AI 검색 엔진"},
    {"name": "GitHub Copilot", "description": "자동 완성 중심"}
  ]'::jsonb,
  '[
    {"title": "Using Phind in VS Code", "url": "https://www.youtube.com/results?search_query=Phind+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Search Engine', 'Developer Tool', 'Coding Assistant'],
  ARRAY['Search', 'Code', 'Dev', 'Phind', 'Docs'],
  '[
    {"competitor": "Perplexity", "comparison": "Phind is optimized for code/docs, Perplexity for general knowledge"},
    {"competitor": "ChatGPT", "comparison": "Phind searches current docs better than ChatGPT`s knowledge cutoff"}
  ]'::jsonb,
  ARRAY['개발자 전용 검색', 'Phind-70B(무료 모델)', 'VS Code 연동', '공식 문서(Docs) 기반', '출처 링크 제공']
),

-- 4. Agent Factory
(
  'Agent Factory',
  '코딩 없이 자연어로 "이메일 정리 비서 만들어줘"라고 하면, 역할을 수행하는 AI 에이전트를 공장에서 찍어내듯 생성하고 배포하는 플랫폼.',
  'Agent Factory',
  'https://agentfactory.ai',
  'https://placehold.co/200x200?text=A', -- Placeholder for generic concept brand
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Operations Managers, Non-coders"
  }'::jsonb,
  'Freemium',
  'Free (1 에이전트) / Starter $29/월',
  '기본 에이전트 1개, 월 50회 실행 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "체험",
      "features": "1 에이전트, 50회 실행/월"
    },
    {
      "plan": "Starter",
      "price": "$29/월",
      "target": "개인",
      "features": "5 에이전트, 1,000회 실행, API 연동"
    },
    {
      "plan": "Business",
      "price": "$99/월",
      "target": "기업",
      "features": "무제한 에이전트, 화이트라벨링"
    }
  ]'::jsonb,
  ARRAY[
    'No-Code: 복잡한 코딩 없이 자연어로 에이전트 생성',
    'Tool Use: 검색, 이메일, 파일 읽기 등 실제 도구 사용 능력 부여',
    '배포 용이: 웹 챗봇, 슬랙, 디스코드 등으로 원클릭 배포'
  ],
  ARRAY[
    '복잡도 한계: 정교한 에러 처리는 n8n 등 병행 필요',
    '비용: 토큰 사용량 증가 시 비용 급증 가능'
  ],
  '[
    {"name": "Agent Builder", "description": "자연어 기반 에이전트 설정"},
    {"name": "Knowledge Base", "description": "문서(PDF/URL) 지식 주입"},
    {"name": "Tool Integration", "description": "검색/API 등 도구 연결"},
    {"name": "Multi-Agent", "description": "에이전트 간 협업 (Pro)"},
    {"name": "Publishing", "description": "슬랙/카톡/웹 배포"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "운영 매니저", "badge": "Ops", "reason": "CS/문의 자동 응대 봇 제작"},
      {"target": "콘텐츠 팀", "badge": "Content", "reason": "뉴스 요약 및 글쓰기 자동화"},
      {"target": "프로토타이핑", "badge": "MVP", "reason": "AI 서비스 기획 빠른 검증"}
    ],
    "not_recommended": [
      {"target": "전문 개발자", "reason": "LangChain/AutoGen 직접 코딩 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '지식 최신화: 업로드 문서는 수동 업데이트 필요',
    '루프 주의: 에이전트 간 대화 시 무한 루프 방지'
  ],
  '{
    "privacy_protection": "Encrypted vector storage"
  }'::jsonb,
  '[
    {"name": "GPTs", "description": "ChatGPT 내에서만 작동하는 쉬운 대안"},
    {"name": "Flowise", "description": "시각적 노드 연결 방식"}
  ]'::jsonb,
  '[
    {"title": "How to build AI Agents", "url": "https://www.youtube.com/results?search_query=No-code+AI+Agent+builder", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['No-code Agent', 'Chatbot Builder', 'Automation'],
  ARRAY['Agent', 'No-code', 'Bot', 'Automation', 'Factory'],
  '[
    {"competitor": "GPTs", "comparison": "Agent Factory allows external tools/embedding on sites, GPTs are stuck in ChatGPT"},
    {"competitor": "Voiceflow", "comparison": "Agent Factory focuses on LLM reasoning, Voiceflow on structured conversation flows"}
  ]'::jsonb,
  ARRAY['노코드 에이전트 빌더', '지식 베이스(KB) 연동', '외부 도구(Tool) 연결', '멀티 에이전트 협업', '챗봇/슬랙 배포']
),

-- 5. AutoDev AI
(
  'AutoDev',
  '"AI가 개발 팀원이 된다" — 복잡한 소프트웨어 엔지니어링 작업을 자율적으로 계획하고, 코드를 작성하고, 테스트까지 수행하는 마이크로소프트의 자율 AI 프레임워크.',
  'Microsoft',
  'https://github.com/microsoft/autodev',
  'https://placehold.co/200x200?text=A', -- Placeholder for repo-based tool
  0.00,
  0,
  '{
    "korean_support": "Partial",
    "login_required": "Optional",
    "platforms": ["Local", "Cloud"],
    "target_audience": "AI Researchers, DevOps Engineers"
  }'::jsonb,
  'Open Source',
  'Free (Open Source) / API Cost',
  '오픈소스 프레임워크 무료. (API 비용 별도).',
  '[
    {
      "plan": "Open Source",
      "price": "Free",
      "target": "연구자",
      "features": "전체 코드 접근, 커스텀 에이전트"
    },
    {
      "plan": "Enterprise",
      "price": "Custom",
      "target": "기업",
      "features": "Azure 통합, 기술 지원"
    }
  ]'::jsonb,
  ARRAY[
    '완전 자율성: 코드 작성부터 테스트, 수정까지 복합 임무 수행',
    'Docker 통합: 격리된 환경에서 코드 실행 및 검증 (안전성)',
    'Multi-Agent: 기획/코딩/리뷰 에이전트 협업 구조',
    'MS 생태계: Azure 및 MS 개발 도구 연동성'
  ],
  ARRAY[
    '설치 난이도: Docker/Python 등 개발 지식 필수',
    '비용 통제: 자율 반복 실행으로 인한 API 비용 급증 주의'
  ],
  '[
    {"name": "Autonomous Coding", "description": "계획-작성-테스트-수정 반복"},
    {"name": "Secure Execution", "description": "Docker 컨테이너 내 실행"},
    {"name": "Multi-Agent Collaboration", "description": "역할별 에이전트 협업"},
    {"name": "Context Awareness", "description": "전체 코드베이스 이해"},
    {"name": "Fine-tuning Support", "description": "도메인 특화 튜닝"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "DevOps 엔지니어", "badge": "DevOps", "reason": "CI/CD 내 자동 AI 검수"},
      {"target": "AI 연구자", "badge": "Research", "reason": "자율 소프트웨어 개발 실험"},
      {"target": "사내 도구 팀", "badge": "Team", "reason": "커스텀 코딩 봇 구축"}
    ],
    "not_recommended": [
      {"target": "일반 개발자", "reason": "단순 보조는 Cursor/Copilot 추천"}
    ]
  }'::jsonb,
  ARRAY[
    '무한 루프: 최대 시도 횟수 설정 필수',
    '보안 격리: 로컬 파일 보호를 위한 Docker 설정 필수'
  ],
  '{
    "privacy_protection": "Local execution keeps code private"
  }'::jsonb,
  '[
    {"name": "Devin", "description": "상용 완전 자율 AI 엔지니어"},
    {"name": "OpenDevin", "description": "오픈소스 대안"}
  ]'::jsonb,
  '[
    {"title": "AutoDev: Automated AI-Driven Development", "url": "https://www.youtube.com/results?search_query=Microsoft+AutoDev", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Autonomous Agent', 'AI Engineer', 'Microsoft'],
  ARRAY['Agent', 'Code', 'Microsoft', 'AutoDev', 'Automation'],
  '[
    {"competitor": "Devin", "comparison": "AutoDev is an open framework, Devin is a closed product"},
    {"competitor": "MetaGPT", "comparison": "AutoDev emphasizes secure execution (Docker) more than MetaGPT"}
  ]'::jsonb,
  ARRAY['자율 코딩(Autonomous)', '도커 기반 안전 실행', '멀티 에이전트 협업', '문맥 인식 개발', '도메인 파인튜닝']
),

-- 6. Teal
(
  'Teal',
  '여기저기 흩어진 채용 공고를 한곳에 모으고, AI가 이력서를 공고에 맞춰 자동으로 수정해 주는 "올인원 취업/이직 관리 플랫폼".',
  'TealHQ',
  'https://www.tealhq.com',
  'https://placehold.co/200x200?text=T', -- Placeholder
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web", "Chrome Extension"],
    "target_audience": "Job Seekers"
  }'::jsonb,
  'Freemium',
  'Free (공고 추적) / Teal+ $29/월',
  '무제한 공고 저장, 기본 이력서 빌더 무료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "취준생",
      "features": "공고 추적, 이력서 빌더"
    },
    {
      "plan": "Teal+",
      "price": "$29/월",
      "target": "적극 구직자",
      "features": "무제한 AI 수정, 커버레터, 키워드 매칭"
    }
  ]'::jsonb,
  ARRAY[
    'Job Tracker: 채용 공고 원클릭 저장 및 상태 관리 (엑셀 해방)',
    'Matching Score: 내 이력서와 공고(JD) 매칭 점수 분석',
    'AI Resume Builder: 공고 키워드 기반 이력서 자동 수정',
    'Cover Letter: 맞춤형 커버 레터 1초 생성'
  ],
  ARRAY[
    '영어 최적화: 한국어 자소서는 문맥 검수 필요',
    '유료 유도: 핵심 분석 기능은 유료 플랜'
  ],
  '[
    {"name": "Job Tracker", "description": "공고 저장 및 상태 관리"},
    {"name": "AI Resume Builder", "description": "맞춤형 이력서 생성"},
    {"name": "Keyword Analysis", "description": "JD 키워드 매칭 분석"},
    {"name": "Cover Letter Generator", "description": "커버 레터 자동 생성"},
    {"name": "Work Styles Test", "description": "커리어 성향 테스트"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "해외 취업러", "badge": "Global", "reason": "영문 이력서/커버레터 필수"},
      {"target": "다작 지원러", "badge": "Track", "reason": "지원 현황 한눈에 관리"},
      {"target": "이직 준비", "badge": "Career", "reason": "평소 공고 스크랩 및 관리"}
    ],
    "not_recommended": [
      {"target": "한국 공채", "reason": "자소설닷컴 스타일 양식 아님"},
      {"target": "모바일 유저", "reason": "PC 크롬 확장 프로그램 필수"}
    ]
  }'::jsonb,
  ARRAY[
    '결제 주기: 단기간 집중 시 주 단위($9) 결제 추천',
    'PDF 파싱: 한글 깨짐 주의, 텍스트 복사 붙여넣기 권장'
  ],
  '{
    "privacy_protection": "Resumes not shared without consent"
  }'::jsonb,
  '[
    {"name": "Rezi", "description": "ATS 최적화 이력서 툴"},
    {"name": "Notion", "description": "템플릿 기반 관리"}
  ]'::jsonb,
  '[
    {"title": "How to Use Teal to Land Your Dream Job", "url": "https://www.youtube.com/results?search_query=TealHQ+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Job Tracker', 'Resume Builder', 'Career Tool'],
  ARRAY['Job', 'Resume', 'Career', 'Teal', 'Tracker'],
  '[
    {"competitor": "Rezi", "comparison": "Teal is better for job tracking, Rezi is better for resume formatting"},
    {"competitor": "LinkedIn", "comparison": "Teal allows tracking jobs from ANY site, not just LinkedIn"}
  ]'::jsonb,
  ARRAY['채용 공고 트래커(Job Tracker)', 'AI 이력서 빌더', '키워드 매칭 분석', '커버레터 생성', '커리어 성향 테스트']
);
