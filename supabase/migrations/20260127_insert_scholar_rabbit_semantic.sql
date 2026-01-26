-- Insert ScholarAI, ResearchRabbit, and Semantic Scholar into ai_models table
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
-- 1. ScholarAI
(
  'ScholarAI',
  '할루시네이션 없이 실제 논문 원문(Full-text)에 접속하여 분석해주고, 인용 가능한 텍스트를 작성해주는 학술 전용 AI 코파일럿.',
  'ScholarAI',
  'https://scholarai.io',
  'https://placehold.co/200x200?text=S', -- Placeholder as explicit logo not found
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "ChatGPT Plugin", "API"],
    "target_audience": "Researchers, PhD Students"
  }'::jsonb,
  'Freemium',
  'Free (제한적) / Basic $9.99/월 / Premium $18.99/월',
  '무료 플랜은 1회성 체험판 성격이 강함. 본격 연구용은 유료 권장.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "찍먹파",
      "features": "1회성 크레딧, 제한적 업로드, 맛보기용"
    },
    {
      "plan": "Basic",
      "price": "$9.99/월",
      "target": "학생",
      "features": "월 50 크레딧, 추가 업로드, 기본 분석"
    },
    {
      "plan": "Premium",
      "price": "$18.99/월",
      "target": "연구자",
      "features": "무제한 GPT & Copilot, 무제한 업로드/분석"
    }
  ]'::jsonb,
  ARRAY[
    'Full-Text Access: Springer 등 제휴 출판사의 유료 논문 전문을 직접 읽고 분석 (최대 강점)',
    'ScholarAI Copilot: 도표/수치 추출 및 심층 질문 답변 가능',
    '정확한 인용: 모든 답변에 실제 논문 출처 링크 제공 (할루시네이션 최소화)',
    'Export: 분석 내용 및 참고문헌 원클릭 내보내기'
  ],
  ARRAY[
    '무료의 한계: 무료 플랜은 크레딧이 적어 실질적 연구에는 유료 필수',
    '오픈 액세스 제한: 비제휴 유료 저널은 여전히 접근 제한될 수 있음'
  ],
  '[
    {"name": "Copilot", "description": "논문 기반 심층 질의응답 및 데이터 추출"},
    {"name": "Literature Search", "description": "2억 건 이상의 논문/특허/책 검색"},
    {"name": "Full-Text Analysis", "description": "제휴 출판사 논문 전문 분석"},
    {"name": "Citation Manager", "description": "Zotero 등 참고문헌 관리 도구 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "논문 리서치", "badge": "FullText", "reason": "전문(Full-text) 분석이 필요한 경우"},
      {"target": "유료 저널", "badge": "Access", "reason": "도서관 계정 없이 주요 저널 내용 파악"},
      {"target": "신뢰성 중시", "badge": "Reliable", "reason": "가짜 논문 없이 정확한 인용 필요"}
    ],
    "not_recommended": [
      {"target": "가성비", "reason": "무료로 대량 분석하려면 Elicit이나 Semantic Scholar 추천"}
    ]
  }'::jsonb,
  ARRAY[
    'GPT Store vs 웹: 웹사이트에서 사용하는 전용 코파일럿이 기능이 더 강력합니다.',
    '크레딧: Basic 플랜도 월 50회 제한이 있으니 헤비 유저는 Premium 추천.'
  ],
  '{
    "privacy_protection": "Files are private and not shared"
  }'::jsonb,
  '[
    {"name": "Scite.ai", "description": "인용의 맥락(지지/반박) 분석 시 유리"},
    {"name": "Elicit", "description": "여러 논문 데이터의 엑셀 정리 시 유리"}
  ]'::jsonb,
  '[
    {"title": "How to use ScholarAI for Research", "url": "https://www.youtube.com/results?search_query=ScholarAI+official", "platform": "YouTube"}
  ]'::jsonb,
  '1.0',
  ARRAY['Full Text Analysis', 'Citation', 'Literature Search'],
  ARRAY['Academic', 'Paper', 'Search', 'Copilot', 'Full Text'],
  '[
    {"competitor": "Elicit", "comparison": "ScholarAI excels at full-text reading, Elicit at data extraction matrix"},
    {"competitor": "ChatGPT", "comparison": "ScholarAI connects to real paper repositories unlike standard ChatGPT"}
  ]'::jsonb,
  ARRAY['논문 전문(Full-text) 분석', '정확한 인용(Citation)', 'ScholarAI Copilot', '참고문헌 관리 연동', '도표 데이터 추출']
),

-- 2. ResearchRabbit
(
  'ResearchRabbit',
  '논문 간의 인용 관계를 시각적인 네트워크 지도(Graph)로 보여주어, 꼬리에 꼬리를 무는 논문 탐색을 도와주는 "논문용 스포티파이".',
  'ResearchRabbit',
  'https://www.researchrabbit.ai',
  'https://icons.veryicon.com/png/o/business/financial-category/rabbit.png', -- Generic rabbit icon
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "PhD Students, Researchers"
  }'::jsonb,
  'Freemium',
  'Free (핵심 기능) / RR+ $12.5~/월',
  '기본 탐색 및 시각화 기능 평생 무료. 대량 검색 등 고급 기능은 유료.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "연구자",
      "features": "무제한 시각화/검색, Zotero 연동"
    },
    {
      "plan": "RR+ (New)",
      "price": "$12.5~/월",
      "target": "헤비유저",
      "features": "고급 검색 필터, 대량 입력(300개), 우선 지원"
    }
  ]'::jsonb,
  ARRAY[
    '시각적 탐색: 인용/피인용 관계를 거미줄 그래프로 시각화 (시초 논문 찾기 용이)',
    'Zotero 연동: 양방향 동기화 지원, 원클릭으로 내 서재 저장',
    '이메일 알림: 내 컬렉션 관련 신규 논문 추천 알림 (스포티파이 방식)',
    '여전히 혜자: 핵심 네트워크 탐색 기능은 여전히 무료'
  ],
  ARRAY[
    '유료화(RR+): 고급 검색 기능이 유료 전환됨',
    '요약 기능 부족: 채팅이나 요약 기능은 타 툴에 비해 약함 (탐색 전문)'
  ],
  '[
    {"name": "Citation Network", "description": "인용 관계 시각화 그래프 생성"},
    {"name": "Similar Work", "description": "유사 논문 추천 알고리즘"},
    {"name": "Earlier/Later Work", "description": "기원 논문 vs 후속 연구 분류"},
    {"name": "Zotero Sync", "description": "조테로 서재 실시간 연동"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "문헌 고찰 시작", "badge": "Discovery", "reason": "연구 주제의 족보(핵심 논문) 파악"},
      {"target": "비주얼 러너", "badge": "Visual", "reason": "텍스트보다 도표/지도로 보는 게 편한 분"},
      {"target": "놓친 논문 찾기", "badge": "Serendipity", "reason": "키워드 검색 한계 보완"}
    ],
    "not_recommended": [
      {"target": "본문 분석", "reason": "논문 요약/채팅 기능은 없음"},
      {"target": "정밀 검색", "reason": "복잡한 Boolean 검색은 유료 필요"}
    ]
  }'::jsonb,
  ARRAY[
    'Seed Paper: 처음에 넣는 씨앗 논문 2~3개가 정확해야 추천 품질이 좋아집니다.',
    '유료 오해: RR+ 광고가 있어도 Free 버전으로 충분히 강력합니다.'
  ],
  '{
    "privacy_protection": "Collections are private by default"
  }'::jsonb,
  '[
    {"name": "Connected Papers", "description": "그래프가 더 단순하고 직관적 (유료 제한)"},
    {"name": "Litmaps", "description": "시간 흐름(Timeline) 시각화에 강점"}
  ]'::jsonb,
  '[
    {"title": "ResearchRabbit: The Spotify for Papers", "url": "https://www.youtube.com/results?search_query=ResearchRabbit+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Citation Analysis', 'Visual Discovery', 'Literature Mapping'],
  ARRAY['Graph', 'Citation', 'Visual', 'Zotero', 'Free'],
  '[
    {"competitor": "Connected Papers", "comparison": "ResearchRabbit allows unlimited collections, Connected Papers has limits"},
    {"competitor": "Litmaps", "comparison": "ResearchRabbit focuses on network, Litmaps on timeline"}
  ]'::jsonb,
  ARRAY['인용 네트워크 시각화', '유사 논문 추천', 'Zotero 연동', '신규 논문 알림', '시각적 탐색']
),

-- 3. Semantic Scholar
(
  'Semantic Scholar',
  '앨런 AI 연구소(Ai2)에서 만든 무료 학술 검색 엔진으로, "TLDR(한 줄 요약)"과 "Semantic Reader"로 논문 읽는 시간을 획기적으로 줄여줍니다.',
  'Allen Institute for AI',
  'https://www.semanticscholar.org',
  'https://icons.iconarchive.com/icons/academicons-team/academicons/128/semantic-scholar-icon.png',
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Optional",
    "platforms": ["Web", "Mobile Web", "API"],
    "target_audience": "CS Researchers, Bio/Medical Researchers"
  }'::jsonb,
  'Free',
  'Free (Open Source / Non-profit)',
  '모든 기능 완전 무료 (비영리 재단 운영)',
  '[
    {
      "plan": "Full Access",
      "price": "Free",
      "target": "모든 연구자",
      "features": "TLDR(초요약), Semantic Reader, 알림, 라이브러리"
    }
  ]'::jsonb,
  ARRAY[
    'TLDR (Too Long; Didn''t Read): 논문 핵심 기여를 한 문장으로 초요약해줌 (속독에 최적)',
    'Semantic Reader (Beta): 본문 속 수식/인용 클릭 시 설명 팝업 제공 (논문 읽기 혁명)',
    'Asta (최신): AI 에이전트와 연동되어 연구 보조 기능 강화',
    '완전 무료: 비영리 재단 운영으로 상업적 유도가 없음'
  ],
  ARRAY[
    '대화형 기능 부재: ChatGPT처럼 논문과 대화하는 기능은 없음 (읽기/검색 전용)',
    '분야 편중: CS/Bio 분야 데이터가 풍부하고 인문/사회과학은 상대적으로 약함'
  ],
  '[
    {"name": "TLDR", "description": "논문의 핵심 기여를 한 문장으로 자동 요약"},
    {"name": "Semantic Reader", "description": "수식/인용 클릭 시 설명 팝업이 뜨는 차세대 PDF 뷰어"},
    {"name": "Research Feeds", "description": "내 관심 주제의 최신 논문 AI 추천"},
    {"name": "Citation Velocity", "description": "최근 인용 추세 그래프 표시"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "속독가", "badge": "Speed", "reason": "TLDR로 수백 개 논문 빠르게 스크리닝"},
      {"target": "딥러닝/CS 연구자", "badge": "CS/AI", "reason": "arXiv 논문 읽기에 최적화된 Semantic Reader"},
      {"target": "가성비", "badge": "Free", "reason": "완전 무료로 고품질 검색/분석"}
    ],
    "not_recommended": [
      {"target": "논문 대화", "reason": "채팅 기능 필요 시 ChatPDF 사용 권장"},
      {"target": "한글 논문", "reason": "국내 저널 검색은 미흡"}
    ]
  }'::jsonb,
  ARRAY[
    'Reader 호환성: 모든 논문이 Semantic Reader를 지원하진 않음 (주로 arXiv 등)',
    'API 사용: 개발자라면 무료 API로 나만의 도구 제작 가능'
  ],
  '{
    "privacy_protection": "Non-profit, high privacy standards"
  }'::jsonb,
  '[
    {"name": "Google Scholar", "description": "방대한 DB 필요 시 (기능은 투박)"},
    {"name": "Consensus", "description": "과학적 합의 여부 확인 시"}
  ]'::jsonb,
  '[
    {"title": "Introducing Semantic Reader", "url": "https://www.youtube.com/results?search_query=Semantic+Scholar+official", "platform": "YouTube"}
  ]'::jsonb,
  '2.0',
  ARRAY['Search Engine', 'Paper Reading', 'Quick Summary'],
  ARRAY['Free', 'Search', 'TLDR', 'AI2', 'Open Source'],
  '[
    {"competitor": "Google Scholar", "comparison": "Semantic Scholar offers AI summaries (TLDR), Google Scholar does not"},
    {"competitor": "ResearchRabbit", "comparison": "Semantic Scholar is for reading/search, ResearchRabbit for visualization"}
  ]'::jsonb,
  ARRAY['TLDR(초요약)', 'Semantic Reader', 'Research Feeds', '인용 속도(Velocity)', '영향력 있는 인용 필터']
);
