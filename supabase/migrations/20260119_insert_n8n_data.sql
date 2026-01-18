-- Insert n8n data into ai_models table
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
  pricing_info, -- Existing column
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
  -- New columns
  version,
  best_for,
  search_tags,
  comparison_data
) VALUES (
  'n8n',
  '내 서버에 설치하면 무료 — 노드 기반으로 복잡한 업무를 자동화하고, 최신 LLM을 연결해 AI 에이전트까지 직접 만들 수 있는 개발자 친화적 자동화 툴.',
  'n8n',
  'https://n8n.io',
  'https://upload.wikimedia.org/wikipedia/commons/f/fa/N8n-logo-new.svg',
  4.8,
  42,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web", "Docker", "Desktop"],
    "target_audience": "Developer, DevOps, AI Builder"
  }'::jsonb,
  'Freemium / Open Source',
  'Self-hosted 무료 / Cloud 월 €20~', -- pricing_info
  'Self-hosted 버전은 기능 제한 없이 무료 (상용 재판매 제외)',
  '[
    {
      "plan": "Self-hosted",
      "price": "Free",
      "target": "개발자/기업",
      "features": "무제한 실행, 데이터 100% 소유, 서버 직접 관리"
    },
    {
      "plan": "Cloud Starter",
      "price": "€20/월",
      "target": "입문자/소규모",
      "features": "월 2,500회 실행, 서버 관리 불필요, 빠른 시작"
    },
    {
      "plan": "Cloud Pro",
      "price": "€50~/월",
      "target": "팀/헤비유저",
      "features": "월 10,000회~ 실행, API/SSO 고급 기능"
    }
  ]'::jsonb,
  ARRAY[
    '가성비 끝판왕 (Self-hosted): 내 서버에 설치하면 유지비 외 추가 비용 0원',
    '강력한 AI 통합: LangChain 내장으로 메모리를 가진 AI 챗봇 및 자율 에이전트 구축 가능',
    '개발 자유도: Code Node에서 JavaScript/Python을 직접 사용하여 모든 API 연결 가능',
    '데이터 프라이버시: 모든 데이터가 내 서버 안에서만 처리되어 보안 우수'
  ],
  ARRAY[
    '높은 진입 장벽: 서버 설치, Docker, JSON 등 개발 지식 필요',
    '유지보수 책임: 자가 호스팅 시 서버 에러나 다운 타임을 직접 해결해야 함',
    'UI 영어: 인터페이스가 영문이라 사용 시 영어 이해 필요'
  ],
  '[
    {"name": "Visual Workflow Editor", "description": "노드와 선을 연결하여 흐름을 만드는 직관적 UI"},
    {"name": "AI Agent & Chains", "description": "OpenAI, Anthropic, Vector DB 등을 연결해 AI 앱 구축"},
    {"name": "HTTP Request", "description": "전 세계 모든 API와 통신 가능 (Auth 설정 지원)"},
    {"name": "Code Node", "description": "JavaScript / Python 코드를 직접 실행하여 데이터 가공"},
    {"name": "Webhook", "description": "외부 시스템에서 데이터가 들어오면 즉시 실행되는 트리거"},
    {"name": "1,000+ Integrations", "description": "구글, 슬랙, 노션, 깃허브 등 주요 앱 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "개발자/엔지니어", "badge": "Must Have", "reason": "Zapier의 비용과 기능 한계를 느끼는 분들에게 최적"},
      {"target": "AI 에이전트 개발", "badge": "Best", "reason": "RAG 시스템이나 사내용 AI 비서 직접 구축 시 강력함"},
      {"target": "데이터 보안 중시", "badge": "Secure", "reason": "금융/의료 등 데이터 외부 유출이 민감한 환경"},
       {"target": "대량 반복 업무", "badge": "Cost-Save", "reason": "수만 건의 데이터 처리 비용 절감"}
    ],
    "not_recommended": [
      {"target": "완전 비개발자", "reason": "코드와 서버 개념이 없다면 Make나 Zapier가 더 적합"},
      {"target": "초간단 개인 용도", "reason": "단순 알림 하나 때문에 서버를 운영하는 것은 비효율적"}
    ]
  }'::jsonb,
  ARRAY[
    '저장 공간 관리: 실행 로그(Execution Data) 자동 삭제(Pruning) 설정을 꼭 켜세요.',
    '라이선스 주의: 무료지만 상용 재판매는 제한되는 Fair-code 라이선스입니다.',
    '버전 업데이트: 최신 AI 기능을 쓰려면 Docker 이미지를 주기적으로 업데이트하세요.'
  ],
  '{
    "training_data": "N/A (Automation Tool)",
    "privacy_protection": "GDPR/HIPAA Compliance (Self-hosted)",
    "enterprise_security": "Data stays on your server"
  }'::jsonb,
  '[
    {"name": "Zapier", "description": "비싸지만 가장 쉽고 연동 앱이 많음"},
    {"name": "Make", "description": "시각적이고 강력하지만 유료인 중간 단계 도구"},
    {"name": "Activepieces", "description": "n8n보다 더 가벼운 오픈소스 자동화 도구"}
  ]'::jsonb,
  '[
    {"title": "Build AI Agents with n8n", "url": "https://www.youtube.com/watch?v=s_N9wXW9zpk", "platform": "YouTube"}
  ]'::jsonb,
  -- New Columns Data
  '1.x', -- version
  ARRAY['Marketing Automation', 'DevOps Pipeline', 'Chatbot Backend', 'Data Sync', 'RAG System', 'Email Automation'], -- best_for
  ARRAY['Workflow Automation', 'AI Agent Builder', 'API Integration', 'Low-code', 'Open Source', 'Docker', 'Self-hosted'], -- search_tags
  '[
    {"competitor": "Zapier", "comparison": "cheaper and more flexible (self-hosted) but harder to use"},
    {"competitor": "Make", "comparison": "similar visual editor but n8n has better free tier (self-hosted)"}
  ]'::jsonb -- comparison_data
);
