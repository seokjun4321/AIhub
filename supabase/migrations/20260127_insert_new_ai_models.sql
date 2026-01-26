-- Insert NotebookLM, Elicit, and Consensus into ai_models table
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
-- 1. NotebookLM
(
  'NotebookLM',
  '사용자가 업로드한 문서(PDF, 텍스트, 오디오 등)만을 근거로 답변하고, 내용을 심층 팟캐스트로 변환해 주는 구글의 개인화 AI 노트.',
  'Google',
  'https://notebooklm.google.com',
  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Google_Gemini_logo.svg/512px-Google_Gemini_logo.svg.png',
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web", "Mobile Web"],
    "target_audience": "College Students, Researchers, Writers"
  }'::jsonb,
  'Free',
  '개인 구글 계정 사용 시 완전 무료 / 기업용 Workspace 포함',
  '소스 업로드, 질의응답, 오디오 오버뷰(팟캐스트) 생성 무료 (노트당 50개 소스)',
  '[
    {
      "plan": "Personal (Free)",
      "price": "Free",
      "target": "학생/개인",
      "features": "업로드한 자료 기반 답변, 오디오 생성 무료"
    },
    {
      "plan": "Business",
      "price": "구독 포함",
      "target": "기업",
      "features": "데이터 보안 강화(학습 미사용), Workspace 연동"
    }
  ]'::jsonb,
  ARRAY[
    '할루시네이션 제로: 내가 올린 자료 안에서만 답을 찾으므로 거짓말을 거의 하지 않음 (Source Grounding)',
    'Audio Overview (팟캐스트): 딱딱한 자료를 두 명의 AI 호스트가 대화하며 쉽게 설명해 주는 오디오 생성',
    '멀티모달 소스: PDF, 텍스트, 구글 슬라이드, 웹사이트, 유튜브, 오디오 파일 지원',
    '인라인 인용: 답변의 각 문장마다 출처 번호 제공, 클릭 시 원본 이동'
  ],
  ARRAY[
    '외부 지식 한계: 업로드한 자료 외의 일반 상식 질문에는 답변 제한',
    '오디오 언어: 한국어 문서를 이해하지만 대화 자체는 영어나 부자연스러운 한국어로 생성될 수 있음'
  ],
  '[
    {"name": "Source Grounding", "description": "업로드된 소스 기반의 정확한 답변 및 요약"},
    {"name": "Audio Overview", "description": "문서를 심층 대화형 팟캐스트 오디오로 변환"},
    {"name": "Multimodal Input", "description": "PDF, txt, Drive, URL, YouTube, MP3 지원"},
    {"name": "Inline Citations", "description": "답변의 근거가 되는 원문 위치 즉시 확인"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "시험 기간 대학생", "badge": "Exam", "reason": "교재 PDF와 강의 녹음 파일을 넣고 예상 문제 추출"},
      {"target": "논문 리서치", "badge": "Research", "reason": "논문 20편을 한 번에 넣고 통합 결론 도출"},
      {"target": "청각 학습자", "badge": "Listening", "reason": "글 읽기 대신 라디오처럼 듣고 공부"}
    ],
    "not_recommended": [
      {"target": "일반 검색", "reason": "날씨나 맛집 추천 같은 일반적인 AI 비서 용도 불가"}
    ]
  }'::jsonb,
  ARRAY[
    '소스 선택: 사이드바에서 체크박스로 선택된 소스들만 답변에 반영됩니다.',
    '오디오 제어: 생성 전 "Customize" 버튼을 눌러 "초보자 눈높이 설명" 등 지침을 주세요.'
  ],
  '{
    "training_data": "Personal(Free) used for tuning, Enterprise not used",
    "privacy_protection": "Source data isolated per user"
  }'::jsonb,
  '[
    {"name": "Claude", "description": "긴 문맥 처리가 뛰어나지만 파일 기반 엄격함은 NotebookLM 우위"},
    {"name": "ChatPDF", "description": "PDF 파일 하나랑 간단히 대화할 때 좋음"}
  ]'::jsonb,
  '[
    {"title": "NotebookLM Official", "url": "https://notebooklm.google.com", "platform": "Web"}
  ]'::jsonb,
  '1.0',
  ARRAY['Study', 'Research', 'Podcast Generation', 'Note Taking'],
  ARRAY['Google', 'PDF', 'RAG', 'Summary', 'Audio', 'Free'],
  '[
    {"competitor": "Claude", "comparison": "Claude handles long context well but NotebookLM has better citations"},
    {"competitor": "ChatPDF", "comparison": "NotebookLM supports multiple files and audio overview"}
  ]'::jsonb,
  ARRAY['소스 그라운딩', '오디오 오버뷰 (팟캐스트)', '멀티모달 입력', '인라인 인용', 'AI 노트 저장']
),

-- 2. Elicit
(
  'Elicit',
  '수백 편의 논문을 한 번에 분석하여 연구 질문에 답하고, 핵심 데이터를 표(Matrix) 형태로 자동 추출해 주는 AI 연구 보조 도구.',
  'Elicit',
  'https://elicit.com',
  'https://avatars.githubusercontent.com/u/89658829?s=200&v=4',
  0.00,
  0,
  '{
    "korean_support": true,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "Researchers, PhD Students"
  }'::jsonb,
  'Freemium',
  'Free (5,000 크레딧 1회) / Plus $12/월',
  '가입 시 5,000 크레딧 제공 (리필 안 됨, 소진 시 유료 전환 필요)',
  '[
    {
      "plan": "Basic (Free)",
      "price": "Free",
      "target": "찍먹파",
      "features": "5,000 크레딧(1회), 기본 검색 및 요약"
    },
    {
      "plan": "Plus",
      "price": "$12/월",
      "target": "대학원생",
      "features": "월 12,000 크레딧 리필, 고정밀 모드, 데이터 추출, 내보내기"
    }
  ]'::jsonb,
  ARRAY[
    '데이터 추출(Extraction): 논문의 참가자 수, 방법론, 결과 등을 엑셀 표처럼 정리해줌 (Kill Feature)',
    'Find Papers: 정확한 키워드 없이 연구 질문(Research Question)만으로 연관 논문 검색',
    'List of Concepts: 여러 논문의 공통 개념이나 효과를 추출하여 비교 분석 용이',
    'Notebooks: 검색-추출-요약 워크플로우 저장 및 관리'
  ],
  ARRAY[
    '크레딧 소모: 고정밀 모드나 대량 추출 시 크레딧 소모가 빠름 (무료 리필 없음)',
    '영어 위주: 한국어 논문(KCI) 검색 능력은 낮으며 영문 저널(Semantic Scholar)에 최적화'
  ],
  '[
    {"name": "Find Papers", "description": "연구 질문 기반 시맨틱 논문 검색 (2억 건+)"},
    {"name": "Extract Info", "description": "PDF에서 원하는 항목(방법론, 결과 등) 자동 추출"},
    {"name": "Synthesis", "description": "상위 논문들의 내용을 종합하여 질문에 답변"},
    {"name": "Upload PDFs", "description": "보유한 PDF 파일을 업로드하여 자체 분석 가능"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "체계적 문헌 고찰", "badge": "Matrix", "reason": "수십 편 논문의 변수값 엑셀 정리"},
      {"target": "선행 연구 조사", "badge": "Review", "reason": "빠르게 훑어보고 연구 갭(Gap) 발견"},
      {"target": "정확성 중시", "badge": "Valid", "reason": "환각 없이 실제 논문 근거만 사용"}
    ],
    "not_recommended": [
      {"target": "국내 논문 위주", "reason": "RISS나 DBpia 검색이 주력이라면 부적합"},
      {"target": "단순 요약", "reason": "논문 1개 요약은 ChatPDF나 Claude가 더 빠름"}
    ]
  }'::jsonb,
  ARRAY[
    'Column 추가: 결과에서 "Add Column"을 눌러 Sample Size 등을 추가해야 진가 발휘',
    'High Accuracy: 중요 정보 추출 시 High Accuracy 모드 켜기 (크레딧 소모 주의)'
  ],
  '{
    "privacy_protection": "Files are private, enhanced security for Plus plans"
  }'::jsonb,
  '[
    {"name": "Consensus", "description": "학계 동의 여부(Yes/No) 확인에 더 좋음"},
    {"name": "Scite.ai", "description": "인용의 맥락(긍정/부정) 파악 시 필수"}
  ]'::jsonb,
  '[
    {"title": "Elicit Official", "url": "https://elicit.com", "platform": "Web"}
  ]'::jsonb,
  '2.0',
  ARRAY['Literature Review', 'Data Extraction', 'Systematic Review'],
  ARRAY['Research', 'Paper', 'Academic', 'Matrix', 'Extraction'],
  '[
    {"competitor": "Consensus", "comparison": "Elicit extracts data points, Consensus extracts conclusions"},
    {"competitor": "Perplexity", "comparison": "Elicit is strictly for academic papers"}
  ]'::jsonb,
  ARRAY['논문 데이터 추출', '연구 질문 검색', '결과 종합(Synthesis)', 'High Accuracy 모드', '엑셀 내보내기']
),

-- 3. Consensus
(
  'Consensus',
  '"커피가 건강에 좋은가?" 같은 질문에 대해 과학 논문들을 분석하여 합의(Consensus) 비율을 시각적으로 보여주는 AI 검색 엔진.',
  'Consensus',
  'https://consensus.app',
  'https://consensus.app/logo.png',
  0.00,
  0,
  '{
    "korean_support": false,
    "login_required": "Required",
    "platforms": ["Web"],
    "target_audience": "EBM Practitioners, Bloggers, General Public"
  }'::jsonb,
  'Freemium',
  'Free (무제한 검색) / Premium $8.99/월',
  '무제한 검색 가능, AI 요약 20회/월 무료. 합의 미터기 제한적.',
  '[
    {
      "plan": "Free",
      "price": "Free",
      "target": "일반인",
      "features": "무제한 검색, AI 요약 20회/월"
    },
    {
      "plan": "Premium",
      "price": "$8.99/월",
      "target": "연구자",
      "features": "무제한 AI 요약, Consensus Meter, 상세 분석"
    }
  ]'::jsonb,
  ARRAY[
    'Consensus Meter: 논문들을 분석해 "70%가 YES"라고 시각적으로 보여주어 결론 도출 용이',
    'Copilot: 검색 결과뿐만 아니라 서론(Intro)이나 문헌 고찰 초안 작성 지원',
    'Study Snapshot: 논문 핵심(대상, 방법, 결과)을 카드 형태로 요약',
    'Quality Indicators: 저널 인용 지수(SJR), 연구 질 배지 표시'
  ],
  ARRAY[
    'Yes/No 질문 특화: 서술형(How)보다는 진위 여부(Yes/No) 질문에 최적',
    '유료 기능: Consensus Meter나 Synthesize(종합) 기능이 무료에선 제한적'
  ],
  '[
    {"name": "Consensus Meter", "description": "학계 의견 합치도(Yes/No/Possibly) 시각화"},
    {"name": "Copilot", "description": "질문에 대한 과학적 답변 초안 작성 및 인용"},
    {"name": "Synthesize", "description": "상위 10개 논문 결과 종합 요약"},
    {"name": "Study Snapshots", "description": "논문 핵심 정보 요약 카드"}
  ]'::jsonb,
  '{
    "recommended": [
      {"target": "헬스케어/영양", "badge": "FactCheck", "reason": "건강 관련 팩트 체크 및 근거 확인"},
      {"target": "블로거/유튜버", "badge": "Content", "reason": "뇌피셜 아닌 과학적 근거 기반 콘텐츠 제작"},
      {"target": "초기 연구자", "badge": "Hypothesis", "reason": "내 가설의 지지 여부 빠른 확인"}
    ],
    "not_recommended": [
      {"target": "깊은 이론 연구", "reason": "복잡한 철학적 이론 탐구에는 부적합"},
      {"target": "국내 이슈", "reason": "한국 사회 특수 이슈 논문은 부족"}
    ]
  }'::jsonb,
  ARRAY[
    '필터 활용: "Human(사람 대상)", "Sample Size", "Year" 필터로 쥐 실험이나 구형 연구 제외',
    '맹신 금지: YES가 많아도 연구의 질(Quality)을 꼭 함께 확인'
  ],
  '{
    "privacy_protection": "Unspecified"
  }'::jsonb,
  '[
    {"name": "Perplexity", "description": "일반 웹 검색까지 포함해 넓게 볼 때"},
    {"name": "Elicit", "description": "논문에서 구체적 데이터를 뽑아야 할 때"}
  ]'::jsonb,
  '[
    {"title": "Consensus Official", "url": "https://consensus.app", "platform": "Web"}
  ]'::jsonb,
  '1.0',
  ARRAY['Fact Checking', 'Evidence Based', 'Health Research'],
  ARRAY['Science', 'Paper', 'Fact Check', 'Medical', 'Search Engine'],
  '[
    {"competitor": "Perplexity", "comparison": "Consensus is built on scientific papers only"},
    {"competitor": "Elicit", "comparison": "Consensus creates summaries of agreement, Elicit extracts data"}
  ]'::jsonb,
  ARRAY['합의 미터기(Consensus Meter)', '과학적 답변 초안(Copilot)', '연구 요약(Snapshots)', '품질 지표(Quality Indicators)', 'Yes/No 분석']
);
