-- Updated AI Models Content Migration

-- Generated based on user provided text content

UPDATE ai_models SET
    description = '사용자가 업로드한 문서(PDF, 텍스트, 오디오 등)만을 근거로 답변하고, 내용을 심층 팟캐스트로 변환해 주는 구글의 개인화 AI 노트.',
    website_url = 'https://notebooklm.google.com/',
    pricing_model = 'Free (개인용 무료 / 기업용 Workspace 포함)',
    pricing_info = '(기업용) Google Workspace 구독에 포함 (Business/Enterprise).',
    free_tier_note = '개인 사용자는 소스 업로드(노트북당 50개, 소스당 50만 단어) 및 질의응답, 오디오 오버뷰(팟캐스트) 생성 기능 무료.',
    pricing_plans = '[{"plan": "Personal (Free)", "target": "학생/개인", "features": "업로드한 자료 기반 답변, 오디오 생성 무료", "price": "무료"}, {"plan": "Business", "target": "기업", "features": "데이터 보안 강화(학습 미사용), Workspace 연동", "price": "구독 포함"}]'::jsonb,
    pros = ARRAY['할루시네이션 제로: 인터넷을 뒤지는 게 아니라, "내가 올린 자료" 안에서만 답을 찾으므로 거짓말을 거의 하지 않습니다. (Source Grounding).', 'Audio Overview (팟캐스트): 딱딱한 논문이나 교재를 업로드하면, 두 명의 AI 호스트가 서로 대화하며 내용을 쉽게 설명해 주는 ''오디오(라디오)''를 만들어줍니다. (학습 효과 최강).', '멀티모달 소스: PDF, 텍스트뿐만 아니라 구글 슬라이드, 웹사이트 링크, 유튜브 영상 링크, 오디오 파일까지 소스로 넣을 수 있습니다.', '인라인 인용: 답변의 각 문장마다 출처 번호가 달려 있어, 클릭하면 원본 문서의 해당 위치로 바로 이동합니다.'],
    cons = ARRAY['외부 지식 한계: 내가 올린 자료 외의 일반 상식(인터넷 검색)을 물어보면 답변하지 않거나 범위가 제한됩니다.', '오디오 언어: 팟캐스트(Audio Overview) 기능이 한국어 문서를 이해는 하지만, 대화 자체는 영어로 생성되는 경우가 많거나 한국어 발음이 아직 부자연스러울 수 있습니다.'],
    key_features = '[{"name": "Source Grounding", "description": "업로드된 소스 기반의 정확한 답변 및 요약"}, {"name": "Audio Overview", "description": "문서를 심층 대화형 팟캐스트 오디오로 변환"}, {"name": "Multimodal Input", "description": "PDF, txt, Google Drive, URL, YouTube, MP3 지원"}, {"name": "Suggested Actions", "description": "요약하기, 관련 아이디어 제안, 스터디 가이드 생성"}, {"name": "Inline Citations", "description": "답변의 근거가 되는 원문 위치 즉시 확인"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 시험 기간 대학생", "reason": "교재 PDF와 강의 녹음 파일을 넣고 \"시험에 나올만한 문제 10개 뽑아줘\"라고 할 때."}, {"target": "✅ 논문 리서치", "reason": "논문 20편을 한 번에 넣고 \"이 논문들의 공통된 결론이 뭐야?\"라고 통합 분석할 때."}, {"target": "✅ 청각 학습자", "reason": "글 읽기가 싫어서 내용을 라디오처럼 듣고 공부하고 싶은 분 (Audio Overview)."}], "not_recommended": [{"target": "❌ 일반 검색", "reason": "\"오늘 날씨 어때?\"나 \"맛집 추천해줘\" 같은 일반적인 AI 비서 용도로는 쓸 수 없습니다."}]}'::jsonb,
    usage_tips = ARRAY['소스 선택: 왼쪽 사이드바에서 체크박스로 선택된 소스들만 답변에 반영됩니다. 전체를 다 보고 싶으면 모두 체크하세요.', '오디오 제어: 오디오 오버뷰 생성 전 "설명(Customize)" 버튼을 눌러 "초보자 눈높이로 설명해줘" 같은 지침을 줄 수 있습니다.'],
    privacy_info = '{"description": "학습: 개인용(Free) 버전의 데이터는 모델 튜닝에 사용될 수 있으나, Enterprise(Workspace) 버전은 학습에 사용되지 않습니다."}'::jsonb,
    alternatives = '[{"name": "Claude", "description": "긴 문맥 처리가 뛰어나지만 \"파일 기반 답변\"의 엄격함은 NotebookLM이 우위"}, {"name": "ChatPDF", "description": "PDF 파일 하나랑 대화할 때 간편함"}]'::jsonb,
    media_info = '[{"title": "NotebookLM: Your Personalized AI Research Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Google Labs)"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Mobile Web 지원)"], "target_audience": "대학생(시험 공부), 연구원(논문 분석), 작가(자료 정리)"}'::jsonb,
    features = ARRAY['Source Grounding', 'Audio Overview', 'Multimodal Input', 'Suggested Actions', 'Inline Citations']
WHERE name = 'NotebookLM';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'NotebookLM', '사용자가 업로드한 문서(PDF, 텍스트, 오디오 등)만을 근거로 답변하고, 내용을 심층 팟캐스트로 변환해 주는 구글의 개인화 AI 노트.', 'https://notebooklm.google.com/',
    'Free (개인용 무료 / 기업용 Workspace 포함)', '(기업용) Google Workspace 구독에 포함 (Business/Enterprise).', '개인 사용자는 소스 업로드(노트북당 50개, 소스당 50만 단어) 및 질의응답, 오디오 오버뷰(팟캐스트) 생성 기능 무료.',
    '[{"plan": "Personal (Free)", "target": "학생/개인", "features": "업로드한 자료 기반 답변, 오디오 생성 무료", "price": "무료"}, {"plan": "Business", "target": "기업", "features": "데이터 보안 강화(학습 미사용), Workspace 연동", "price": "구독 포함"}]'::jsonb, ARRAY['할루시네이션 제로: 인터넷을 뒤지는 게 아니라, "내가 올린 자료" 안에서만 답을 찾으므로 거짓말을 거의 하지 않습니다. (Source Grounding).', 'Audio Overview (팟캐스트): 딱딱한 논문이나 교재를 업로드하면, 두 명의 AI 호스트가 서로 대화하며 내용을 쉽게 설명해 주는 ''오디오(라디오)''를 만들어줍니다. (학습 효과 최강).', '멀티모달 소스: PDF, 텍스트뿐만 아니라 구글 슬라이드, 웹사이트 링크, 유튜브 영상 링크, 오디오 파일까지 소스로 넣을 수 있습니다.', '인라인 인용: 답변의 각 문장마다 출처 번호가 달려 있어, 클릭하면 원본 문서의 해당 위치로 바로 이동합니다.'], ARRAY['외부 지식 한계: 내가 올린 자료 외의 일반 상식(인터넷 검색)을 물어보면 답변하지 않거나 범위가 제한됩니다.', '오디오 언어: 팟캐스트(Audio Overview) 기능이 한국어 문서를 이해는 하지만, 대화 자체는 영어로 생성되는 경우가 많거나 한국어 발음이 아직 부자연스러울 수 있습니다.'], '[{"name": "Source Grounding", "description": "업로드된 소스 기반의 정확한 답변 및 요약"}, {"name": "Audio Overview", "description": "문서를 심층 대화형 팟캐스트 오디오로 변환"}, {"name": "Multimodal Input", "description": "PDF, txt, Google Drive, URL, YouTube, MP3 지원"}, {"name": "Suggested Actions", "description": "요약하기, 관련 아이디어 제안, 스터디 가이드 생성"}, {"name": "Inline Citations", "description": "답변의 근거가 되는 원문 위치 즉시 확인"}]'::jsonb,
    '{"recommended": [{"target": "✅ 시험 기간 대학생", "reason": "교재 PDF와 강의 녹음 파일을 넣고 \"시험에 나올만한 문제 10개 뽑아줘\"라고 할 때."}, {"target": "✅ 논문 리서치", "reason": "논문 20편을 한 번에 넣고 \"이 논문들의 공통된 결론이 뭐야?\"라고 통합 분석할 때."}, {"target": "✅ 청각 학습자", "reason": "글 읽기가 싫어서 내용을 라디오처럼 듣고 공부하고 싶은 분 (Audio Overview)."}], "not_recommended": [{"target": "❌ 일반 검색", "reason": "\"오늘 날씨 어때?\"나 \"맛집 추천해줘\" 같은 일반적인 AI 비서 용도로는 쓸 수 없습니다."}]}'::jsonb, ARRAY['소스 선택: 왼쪽 사이드바에서 체크박스로 선택된 소스들만 답변에 반영됩니다. 전체를 다 보고 싶으면 모두 체크하세요.', '오디오 제어: 오디오 오버뷰 생성 전 "설명(Customize)" 버튼을 눌러 "초보자 눈높이로 설명해줘" 같은 지침을 줄 수 있습니다.'], '{"description": "학습: 개인용(Free) 버전의 데이터는 모델 튜닝에 사용될 수 있으나, Enterprise(Workspace) 버전은 학습에 사용되지 않습니다."}'::jsonb,
    '[{"name": "Claude", "description": "긴 문맥 처리가 뛰어나지만 \"파일 기반 답변\"의 엄격함은 NotebookLM이 우위"}, {"name": "ChatPDF", "description": "PDF 파일 하나랑 대화할 때 간편함"}]'::jsonb, '[{"title": "NotebookLM: Your Personalized AI Research Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Google Labs)"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Mobile Web 지원)"], "target_audience": "대학생(시험 공부), 연구원(논문 분석), 작가(자료 정리)"}'::jsonb,
    ARRAY['Source Grounding', 'Audio Overview', 'Multimodal Input', 'Suggested Actions', 'Inline Citations'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'NotebookLM');

UPDATE ai_models SET
    description = '수백 편의 논문을 한 번에 분석하여 연구 질문에 답하고, 핵심 데이터를 표(Matrix) 형태로 자동 추출해 주는 AI 연구 보조 도구.',
    website_url = 'https://elicit.com/',
    pricing_model = 'Freemium (크레딧 기반)',
    pricing_info = '월 $12 (Plus / 연 결제 시 월 $10)',
    free_tier_note = '가입 시 5,000 크레딧 제공. (논문 검색 및 기본 요약 가능, 데이터 대량 추출 시 소진됨). 리필 안 됨.',
    pricing_plans = '[{"plan": "Basic (Free)", "target": "찍먹파", "features": "5,000 크레딧(1회), 기본 검색 및 요약", "price": "무료"}, {"plan": "Plus", "target": "대학원생", "features": "월 12,000 크레딧 리필, 고정밀 모드, 데이터 추출, 결과 내보내기", "price": "$12/월"}, {"plan": "Team/Ent", "target": "연구실", "features": "공유 워크스페이스, 대량 크레딧", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['데이터 추출(Extraction): "이 논문들의 ''참가자 수'', ''실험 방법'', ''결과 수치''를 표로 만들어줘"라고 하면 엑셀처럼 정리해 줍니다. (가장 강력한 기능).', 'Find Papers: 키워드가 정확하지 않아도 연구 질문(Research Question)을 문장으로 입력하면 연관성이 높은 논문을 찾아줍니다.', 'List of Concepts: 여러 논문에서 공통으로 다루는 개념이나 효과를 추출하여 비교 분석하기 좋습니다.', 'Notebooks: 검색-추출-요약-채팅으로 이어지는 연구 흐름을 워크플로우 형태로 저장하고 관리할 수 있습니다.'],
    cons = ARRAY['크레딧 소모: 고정밀 모드나 데이터 추출을 많이 쓰면 크레딧이 빨리 닳습니다. 무료 크레딧은 매월 충전되지 않습니다.', '영어 위주: 한국어 논문(KCI 등) 검색 능력은 떨어지며, 주로 영문 저널(Semantic Scholar DB)에 최적화되어 있습니다.'],
    key_features = '[{"name": "Find Papers", "description": "연구 질문 기반의 시맨틱 논문 검색 (2억 건 이상 DB)"}, {"name": "Extract Info from PDFs", "description": "논문 PDF에서 원하는 항목(방법론, 결과 등) 자동 추출"}, {"name": "Synthesis", "description": "상위 4~8개 논문의 내용을 종합하여 연구 질문에 대한 답변 생성"}, {"name": "Notebooks", "description": "단계별 연구 작업(검색→필터링→추출) 저장 및 관리"}, {"name": "Upload PDFs", "description": "내가 가진 PDF 파일을 올려서 분석"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 체계적 문헌 고찰", "reason": "수십 편의 논문에서 특정 변수값만 뽑아서 엑셀로 정리해야 하는 연구자."}, {"target": "✅ 선행 연구 조사", "reason": "내 연구 주제와 관련된 기존 논문들을 빠르게 훑어보고 갭(Gap)을 찾고 싶은 분."}, {"target": "✅ 정확성 중시", "reason": "AI의 환각 없이 실제 논문 내용만 근거로 삼아야 하는 분."}], "not_recommended": [{"target": "❌ 국내 논문 위주", "reason": "RISS나 DBpia 검색이 주력이라면 적합하지 않습니다."}, {"target": "❌ 단순 요약", "reason": "논문 1개만 읽을 거라면 ChatPDF나 Claude가 더 가볍고 빠릅니다."}]}'::jsonb,
    usage_tips = ARRAY['Column 추가: 결과 화면에서 "Add Column"을 눌러 ''Sample Size'', ''Methodology'' 등을 추가해야 진가를 발휘합니다.', 'High Accuracy: 추출 시 ''High Accuracy'' 모드를 켜면 정확도는 올라가지만 크레딧이 더 많이 듭니다.'],
    privacy_info = '{"description": "보안: 업로드한 논문은 비공개로 유지되며, Plus 플랜 이상에서는 데이터 처리의 보안 수준이 강화됩니다."}'::jsonb,
    alternatives = '[{"name": "Consensus", "description": "\"이 주제에 대해 학계가 동의하는가?\"를 볼 때 더 좋음"}, {"name": "Scite.ai", "description": "인용의 맥락(긍정/부정)을 파악할 때 필수"}]'::jsonb,
    media_info = '[{"title": "Elicit: The AI Research Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Elicit)"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "석박사 과정생, 체계적 문헌 고찰(Systematic Review) 연구자"}'::jsonb,
    features = ARRAY['Find Papers', 'Extract Info from PDFs', 'Synthesis', 'Notebooks', 'Upload PDFs']
WHERE name = 'Elicit';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Elicit', '수백 편의 논문을 한 번에 분석하여 연구 질문에 답하고, 핵심 데이터를 표(Matrix) 형태로 자동 추출해 주는 AI 연구 보조 도구.', 'https://elicit.com/',
    'Freemium (크레딧 기반)', '월 $12 (Plus / 연 결제 시 월 $10)', '가입 시 5,000 크레딧 제공. (논문 검색 및 기본 요약 가능, 데이터 대량 추출 시 소진됨). 리필 안 됨.',
    '[{"plan": "Basic (Free)", "target": "찍먹파", "features": "5,000 크레딧(1회), 기본 검색 및 요약", "price": "무료"}, {"plan": "Plus", "target": "대학원생", "features": "월 12,000 크레딧 리필, 고정밀 모드, 데이터 추출, 결과 내보내기", "price": "$12/월"}, {"plan": "Team/Ent", "target": "연구실", "features": "공유 워크스페이스, 대량 크레딧", "price": "별도 문의"}]'::jsonb, ARRAY['데이터 추출(Extraction): "이 논문들의 ''참가자 수'', ''실험 방법'', ''결과 수치''를 표로 만들어줘"라고 하면 엑셀처럼 정리해 줍니다. (가장 강력한 기능).', 'Find Papers: 키워드가 정확하지 않아도 연구 질문(Research Question)을 문장으로 입력하면 연관성이 높은 논문을 찾아줍니다.', 'List of Concepts: 여러 논문에서 공통으로 다루는 개념이나 효과를 추출하여 비교 분석하기 좋습니다.', 'Notebooks: 검색-추출-요약-채팅으로 이어지는 연구 흐름을 워크플로우 형태로 저장하고 관리할 수 있습니다.'], ARRAY['크레딧 소모: 고정밀 모드나 데이터 추출을 많이 쓰면 크레딧이 빨리 닳습니다. 무료 크레딧은 매월 충전되지 않습니다.', '영어 위주: 한국어 논문(KCI 등) 검색 능력은 떨어지며, 주로 영문 저널(Semantic Scholar DB)에 최적화되어 있습니다.'], '[{"name": "Find Papers", "description": "연구 질문 기반의 시맨틱 논문 검색 (2억 건 이상 DB)"}, {"name": "Extract Info from PDFs", "description": "논문 PDF에서 원하는 항목(방법론, 결과 등) 자동 추출"}, {"name": "Synthesis", "description": "상위 4~8개 논문의 내용을 종합하여 연구 질문에 대한 답변 생성"}, {"name": "Notebooks", "description": "단계별 연구 작업(검색→필터링→추출) 저장 및 관리"}, {"name": "Upload PDFs", "description": "내가 가진 PDF 파일을 올려서 분석"}]'::jsonb,
    '{"recommended": [{"target": "✅ 체계적 문헌 고찰", "reason": "수십 편의 논문에서 특정 변수값만 뽑아서 엑셀로 정리해야 하는 연구자."}, {"target": "✅ 선행 연구 조사", "reason": "내 연구 주제와 관련된 기존 논문들을 빠르게 훑어보고 갭(Gap)을 찾고 싶은 분."}, {"target": "✅ 정확성 중시", "reason": "AI의 환각 없이 실제 논문 내용만 근거로 삼아야 하는 분."}], "not_recommended": [{"target": "❌ 국내 논문 위주", "reason": "RISS나 DBpia 검색이 주력이라면 적합하지 않습니다."}, {"target": "❌ 단순 요약", "reason": "논문 1개만 읽을 거라면 ChatPDF나 Claude가 더 가볍고 빠릅니다."}]}'::jsonb, ARRAY['Column 추가: 결과 화면에서 "Add Column"을 눌러 ''Sample Size'', ''Methodology'' 등을 추가해야 진가를 발휘합니다.', 'High Accuracy: 추출 시 ''High Accuracy'' 모드를 켜면 정확도는 올라가지만 크레딧이 더 많이 듭니다.'], '{"description": "보안: 업로드한 논문은 비공개로 유지되며, Plus 플랜 이상에서는 데이터 처리의 보안 수준이 강화됩니다."}'::jsonb,
    '[{"name": "Consensus", "description": "\"이 주제에 대해 학계가 동의하는가?\"를 볼 때 더 좋음"}, {"name": "Scite.ai", "description": "인용의 맥락(긍정/부정)을 파악할 때 필수"}]'::jsonb, '[{"title": "Elicit: The AI Research Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Elicit)"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "석박사 과정생, 체계적 문헌 고찰(Systematic Review) 연구자"}'::jsonb,
    ARRAY['Find Papers', 'Extract Info from PDFs', 'Synthesis', 'Notebooks', 'Upload PDFs'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Elicit');

UPDATE ai_models SET
    description = '"커피가 건강에 좋은가?" 같은 질문에 대해 과학 논문들을 분석하여 ''예/아니오/모름''의 합의(Consensus) 비율을 시각적으로 보여주는 AI 검색 엔진.',
    website_url = 'https://consensus.app/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $8.99 (Premium / 연 결제 시)',
    free_tier_note = '무제한 검색, 월 20회 AI 분석(Copilot/Synthesize) 무료. Study Snapshots(핵심 요약) 일부 제한.',
    pricing_plans = '[{"plan": "Free", "target": "일반인", "features": "무제한 검색, AI 요약 20회/월, 합의 미터기(제한적)", "price": "무료"}, {"plan": "Premium", "target": "연구자/작가", "features": "무제한 AI 요약, 합의 미터기(Consensus Meter), 상세 분석", "price": "$8.99/월"}, {"plan": "Team", "target": "조직", "features": "중앙 청구, 팀 공유 기능", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['Consensus Meter: 논문들을 분석해 "70%의 연구가 YES라고 합니다"라고 시각적인 미터기로 보여주어 결론을 내리기 쉽습니다. (핵심 기능).', 'Copilot: 검색 결과뿐만 아니라, 해당 주제에 대한 서론(Intro)이나 문헌 고찰 초안을 AI가 써줍니다.', 'Study Snapshot: 논문 제목만 보는 게 아니라, "대상: 성인 500명, 방법: RCT, 결과: 유의미함" 같은 핵심 정보를 카드 형태로 요약해 줍니다.', 'Quality Indicators: 해당 저널의 인용 지수(SJR)나 연구의 질을 배지로 표시해 주어 신뢰도를 판단하기 좋습니다.'],
    cons = ARRAY['Yes/No 질문 특화: "어떻게(How)" 같은 서술형 질문보다는 "맞나/아닌가" 질문에 가장 효과적입니다.', '유료 기능: 핵심인 ''Consensus Meter''나 ''Synthesize(종합)'' 기능이 무료 버전에서는 횟수 제한이 있어 감질날 수 있습니다.'],
    key_features = '[{"name": "Consensus Meter", "description": "학계의 의견 합치도(Yes/No/Possibly) 시각화"}, {"name": "Copilot", "description": "질문에 대한 과학적 답변 초안 작성 및 인용"}, {"name": "Synthesize", "description": "상위 10개 논문의 결과를 한 문단으로 종합 요약"}, {"name": "Study Snapshots", "description": "논문의 핵심(인구, 방법, 결과) 요약 카드"}, {"name": "Quality Indicators", "description": "저널 등급, 인용 수, 연구 유형(RCT, 메타분석 등) 표시"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 헬스케어/영양", "reason": "\"비타민C가 감기에 효과 있나?\" 같은 건강 관련 팩트 체크."}, {"target": "✅ 블로거/유튜버", "reason": "뇌피셜이 아닌 과학적 근거를 바탕으로 콘텐츠를 만들고 싶은 분."}, {"target": "✅ 초기 연구자", "reason": "내 가설이 학계에서 지지받고 있는지 빠르게 확인하고 싶을 때."}], "not_recommended": [{"target": "❌ 깊은 이론 연구", "reason": "수식이나 복잡한 철학적 이론을 깊게 파고드는 용도로는 적합하지 않습니다."}, {"target": "❌ 국내 이슈", "reason": "한국 사회의 특수한 이슈에 대한 논문은 찾기 어렵습니다."}]}'::jsonb,
    usage_tips = ARRAY['필터 활용: "Human(사람 대상)", "Sample Size(표본 크기)", "Year(최신순)" 필터를 걸어야 쥐 실험이나 오래된 연구를 거를 수 있습니다.', '맹신 금지: ''Yes''가 많다고 해서 무조건 진리는 아닙니다. 연구의 질(Quality)을 함께 확인하세요.'],
    privacy_info = '{"description": "출처: Semantic Scholar 데이터를 기반으로 하며, 광고 없이 객관적인 논문 데이터만 보여줍니다."}'::jsonb,
    alternatives = '[{"name": "Perplexity", "description": "일반적인 웹 검색까지 포함해서 넓게 보고 싶을 때"}, {"name": "Elicit", "description": "논문에서 데이터를 직접 뽑아내야 할 때"}]'::jsonb,
    media_info = '[{"title": "Introducing Consensus: Evidence-Based Search", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Consensus)"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "근거 중심 의학(EBM) 종사자, 팩트 체크가 필요한 블로거, 호기심 많은 일반인"}'::jsonb,
    features = ARRAY['Consensus Meter', 'Copilot', 'Synthesize', 'Study Snapshots', 'Quality Indicators']
WHERE name = 'Consensus';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Consensus', '"커피가 건강에 좋은가?" 같은 질문에 대해 과학 논문들을 분석하여 ''예/아니오/모름''의 합의(Consensus) 비율을 시각적으로 보여주는 AI 검색 엔진.', 'https://consensus.app/',
    'Freemium (무료 + 유료 구독)', '월 $8.99 (Premium / 연 결제 시)', '무제한 검색, 월 20회 AI 분석(Copilot/Synthesize) 무료. Study Snapshots(핵심 요약) 일부 제한.',
    '[{"plan": "Free", "target": "일반인", "features": "무제한 검색, AI 요약 20회/월, 합의 미터기(제한적)", "price": "무료"}, {"plan": "Premium", "target": "연구자/작가", "features": "무제한 AI 요약, 합의 미터기(Consensus Meter), 상세 분석", "price": "$8.99/월"}, {"plan": "Team", "target": "조직", "features": "중앙 청구, 팀 공유 기능", "price": "별도 문의"}]'::jsonb, ARRAY['Consensus Meter: 논문들을 분석해 "70%의 연구가 YES라고 합니다"라고 시각적인 미터기로 보여주어 결론을 내리기 쉽습니다. (핵심 기능).', 'Copilot: 검색 결과뿐만 아니라, 해당 주제에 대한 서론(Intro)이나 문헌 고찰 초안을 AI가 써줍니다.', 'Study Snapshot: 논문 제목만 보는 게 아니라, "대상: 성인 500명, 방법: RCT, 결과: 유의미함" 같은 핵심 정보를 카드 형태로 요약해 줍니다.', 'Quality Indicators: 해당 저널의 인용 지수(SJR)나 연구의 질을 배지로 표시해 주어 신뢰도를 판단하기 좋습니다.'], ARRAY['Yes/No 질문 특화: "어떻게(How)" 같은 서술형 질문보다는 "맞나/아닌가" 질문에 가장 효과적입니다.', '유료 기능: 핵심인 ''Consensus Meter''나 ''Synthesize(종합)'' 기능이 무료 버전에서는 횟수 제한이 있어 감질날 수 있습니다.'], '[{"name": "Consensus Meter", "description": "학계의 의견 합치도(Yes/No/Possibly) 시각화"}, {"name": "Copilot", "description": "질문에 대한 과학적 답변 초안 작성 및 인용"}, {"name": "Synthesize", "description": "상위 10개 논문의 결과를 한 문단으로 종합 요약"}, {"name": "Study Snapshots", "description": "논문의 핵심(인구, 방법, 결과) 요약 카드"}, {"name": "Quality Indicators", "description": "저널 등급, 인용 수, 연구 유형(RCT, 메타분석 등) 표시"}]'::jsonb,
    '{"recommended": [{"target": "✅ 헬스케어/영양", "reason": "\"비타민C가 감기에 효과 있나?\" 같은 건강 관련 팩트 체크."}, {"target": "✅ 블로거/유튜버", "reason": "뇌피셜이 아닌 과학적 근거를 바탕으로 콘텐츠를 만들고 싶은 분."}, {"target": "✅ 초기 연구자", "reason": "내 가설이 학계에서 지지받고 있는지 빠르게 확인하고 싶을 때."}], "not_recommended": [{"target": "❌ 깊은 이론 연구", "reason": "수식이나 복잡한 철학적 이론을 깊게 파고드는 용도로는 적합하지 않습니다."}, {"target": "❌ 국내 이슈", "reason": "한국 사회의 특수한 이슈에 대한 논문은 찾기 어렵습니다."}]}'::jsonb, ARRAY['필터 활용: "Human(사람 대상)", "Sample Size(표본 크기)", "Year(최신순)" 필터를 걸어야 쥐 실험이나 오래된 연구를 거를 수 있습니다.', '맹신 금지: ''Yes''가 많다고 해서 무조건 진리는 아닙니다. 연구의 질(Quality)을 함께 확인하세요.'], '{"description": "출처: Semantic Scholar 데이터를 기반으로 하며, 광고 없이 객관적인 논문 데이터만 보여줍니다."}'::jsonb,
    '[{"name": "Perplexity", "description": "일반적인 웹 검색까지 포함해서 넓게 보고 싶을 때"}, {"name": "Elicit", "description": "논문에서 데이터를 직접 뽑아내야 할 때"}]'::jsonb, '[{"title": "Introducing Consensus: Evidence-Based Search", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Consensus)"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "근거 중심 의학(EBM) 종사자, 팩트 체크가 필요한 블로거, 호기심 많은 일반인"}'::jsonb,
    ARRAY['Consensus Meter', 'Copilot', 'Synthesize', 'Study Snapshots', 'Quality Indicators'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Consensus');

UPDATE ai_models SET
    description = '할루시네이션 없이 실제 논문 원문(Full-text)에 접속하여 분석해주고, 인용 가능한 텍스트를 작성해주는 학술 전용 AI 코파일럿.',
    website_url = 'https://scholarai.io/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $9.99 (Basic) / 월 $18.99 (Premium).',
    free_tier_note = '가입 시 소량의 크레딧(One-time) 제공. 기본 검색 및 제한된 횟수의 AI 코파일럿 질문 가능. 본격적인 연구용으로는 부족함.',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "1회성 크레딧, 제한적 업로드, 맛보기용", "price": "무료"}, {"plan": "Basic", "target": "학생", "features": "월 50 크레딧, 추가 업로드, 기본 분석", "price": "$9.99/월"}, {"plan": "Premium", "target": "연구자", "features": "GPT & Copilot 무제한, 무제한 업로드/분석", "price": "$18.99/월"}]'::jsonb,
    pros = ARRAY['Full-Text Access: Springer, Taylor & Francis 등 주요 출판사와 제휴하여, 초록(Abstract)뿐만 아니라 유료 논문의 전문(Full-text)을 직접 읽고 분석합니다. (가장 큰 강점)', 'ScholarAI Copilot: 단순 요약을 넘어, 논문 속의 특정 도표나 수치를 찾아내고 "이 연구의 한계점이 뭐야?" 같은 심층 질문에 답합니다.', '정확한 인용: 모든 답변 문장에 실제 논문 출처 링크를 달아주어 할루시네이션(거짓 정보) 걱정이 적습니다.', 'Export: 분석한 내용을 원클릭으로 정리하여 내보내거나 참고문헌 리스트로 만들 수 있습니다.'],
    cons = ARRAY['무료의 한계: 무료 플랜은 사실상 체험판에 가까워, 논문 한두 편 분석하면 크레딧이 끝납니다.', '오픈 액세스 제한: 제휴되지 않은 일부 유료 저널은 여전히 전문 접근이 제한될 수 있습니다. (사용자가 PDF를 직접 올려야 함).'],
    key_features = '[{"name": "Copilot", "description": "논문 기반 심층 질의응답 및 데이터 추출"}, {"name": "Literature Search", "description": "2억 건 이상의 논문/특허/책 검색"}, {"name": "Full-Text Analysis", "description": "제휴 출판사 논문 전문 분석"}, {"name": "Citation Manager", "description": "Zotero 등 참고문헌 관리 도구 연동"}, {"name": "Figure Extraction", "description": "논문 내 표와 그림 데이터 추출 (Pro)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 논문 리서치", "reason": "\"이 주제와 관련된 최신 논문 10개 찾아서 결론만 비교해줘\"가 필요한 분."}, {"target": "✅ 유료 저널", "reason": "학교 도서관 계정 없이도 주요 저널의 내용을 파악하고 싶은 분."}, {"target": "✅ 신뢰성 중시", "reason": "ChatGPT가 지어낸 가짜 논문에 지친 분."}], "not_recommended": [{"target": "❌ 가성비", "reason": "돈을 한 푼도 안 쓰고 논문을 무제한으로 분석하고 싶다면 Elicit(초기 크레딧)이나 Semantic Scholar가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['GPT 스토어 vs 웹: ChatGPT 유료 사용자라면 ''GPT 스토어''에서 ScholarAI를 불러와 쓰는 게 편하지만, 더 강력한 기능(전용 코파일럿)은 공식 웹사이트에서 제공됩니다.', '크레딧: 유료 플랜이라도 ''Basic''은 월 50회 제한이 있으니, 헤비 유저라면 ''Premium''을 선택해야 스트레스가 없습니다.'],
    privacy_info = '{"description": "데이터 보안: 업로드한 논문 데이터는 사용자 계정에 비공개로 저장되며, 타인과 공유되지 않습니다."}'::jsonb,
    alternatives = '[{"name": "Scite.ai", "description": "인용의 맥락(지지/반박) 분석이 더 중요하다면"}, {"name": "Elicit", "description": "여러 논문의 결과를 엑셀 표로 정리하는 게 주 목적이라면"}]'::jsonb,
    media_info = '[{"title": "How to use ScholarAI for Research", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (ScholarAI)"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "ChatGPT Plugin (GPT Store)", "API"], "target_audience": "정확한 인용이 필요한 석박사생, 유료 논문 접근이 필요한 연구자"}'::jsonb,
    features = ARRAY['Copilot', 'Literature Search', 'Full-Text Analysis', 'Citation Manager', 'Figure Extraction']
WHERE name = 'ScholarAI';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'ScholarAI', '할루시네이션 없이 실제 논문 원문(Full-text)에 접속하여 분석해주고, 인용 가능한 텍스트를 작성해주는 학술 전용 AI 코파일럿.', 'https://scholarai.io/',
    'Freemium (무료 + 유료 구독)', '월 $9.99 (Basic) / 월 $18.99 (Premium).', '가입 시 소량의 크레딧(One-time) 제공. 기본 검색 및 제한된 횟수의 AI 코파일럿 질문 가능. 본격적인 연구용으로는 부족함.',
    '[{"plan": "Free", "target": "찍먹파", "features": "1회성 크레딧, 제한적 업로드, 맛보기용", "price": "무료"}, {"plan": "Basic", "target": "학생", "features": "월 50 크레딧, 추가 업로드, 기본 분석", "price": "$9.99/월"}, {"plan": "Premium", "target": "연구자", "features": "GPT & Copilot 무제한, 무제한 업로드/분석", "price": "$18.99/월"}]'::jsonb, ARRAY['Full-Text Access: Springer, Taylor & Francis 등 주요 출판사와 제휴하여, 초록(Abstract)뿐만 아니라 유료 논문의 전문(Full-text)을 직접 읽고 분석합니다. (가장 큰 강점)', 'ScholarAI Copilot: 단순 요약을 넘어, 논문 속의 특정 도표나 수치를 찾아내고 "이 연구의 한계점이 뭐야?" 같은 심층 질문에 답합니다.', '정확한 인용: 모든 답변 문장에 실제 논문 출처 링크를 달아주어 할루시네이션(거짓 정보) 걱정이 적습니다.', 'Export: 분석한 내용을 원클릭으로 정리하여 내보내거나 참고문헌 리스트로 만들 수 있습니다.'], ARRAY['무료의 한계: 무료 플랜은 사실상 체험판에 가까워, 논문 한두 편 분석하면 크레딧이 끝납니다.', '오픈 액세스 제한: 제휴되지 않은 일부 유료 저널은 여전히 전문 접근이 제한될 수 있습니다. (사용자가 PDF를 직접 올려야 함).'], '[{"name": "Copilot", "description": "논문 기반 심층 질의응답 및 데이터 추출"}, {"name": "Literature Search", "description": "2억 건 이상의 논문/특허/책 검색"}, {"name": "Full-Text Analysis", "description": "제휴 출판사 논문 전문 분석"}, {"name": "Citation Manager", "description": "Zotero 등 참고문헌 관리 도구 연동"}, {"name": "Figure Extraction", "description": "논문 내 표와 그림 데이터 추출 (Pro)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 논문 리서치", "reason": "\"이 주제와 관련된 최신 논문 10개 찾아서 결론만 비교해줘\"가 필요한 분."}, {"target": "✅ 유료 저널", "reason": "학교 도서관 계정 없이도 주요 저널의 내용을 파악하고 싶은 분."}, {"target": "✅ 신뢰성 중시", "reason": "ChatGPT가 지어낸 가짜 논문에 지친 분."}], "not_recommended": [{"target": "❌ 가성비", "reason": "돈을 한 푼도 안 쓰고 논문을 무제한으로 분석하고 싶다면 Elicit(초기 크레딧)이나 Semantic Scholar가 낫습니다."}]}'::jsonb, ARRAY['GPT 스토어 vs 웹: ChatGPT 유료 사용자라면 ''GPT 스토어''에서 ScholarAI를 불러와 쓰는 게 편하지만, 더 강력한 기능(전용 코파일럿)은 공식 웹사이트에서 제공됩니다.', '크레딧: 유료 플랜이라도 ''Basic''은 월 50회 제한이 있으니, 헤비 유저라면 ''Premium''을 선택해야 스트레스가 없습니다.'], '{"description": "데이터 보안: 업로드한 논문 데이터는 사용자 계정에 비공개로 저장되며, 타인과 공유되지 않습니다."}'::jsonb,
    '[{"name": "Scite.ai", "description": "인용의 맥락(지지/반박) 분석이 더 중요하다면"}, {"name": "Elicit", "description": "여러 논문의 결과를 엑셀 표로 정리하는 게 주 목적이라면"}]'::jsonb, '[{"title": "How to use ScholarAI for Research", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (ScholarAI)"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "ChatGPT Plugin (GPT Store)", "API"], "target_audience": "정확한 인용이 필요한 석박사생, 유료 논문 접근이 필요한 연구자"}'::jsonb,
    ARRAY['Copilot', 'Literature Search', 'Full-Text Analysis', 'Citation Manager', 'Figure Extraction'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'ScholarAI');

UPDATE ai_models SET
    description = '논문 간의 인용 관계를 시각적인 네트워크 지도(Graph)로 보여주어, 꼬리에 꼬리를 무는 논문 탐색을 도와주는 ''논문용 스포티파이''.',
    website_url = 'https://www.researchrabbit.ai/',
    pricing_model = 'Freemium (기본 무료 + RR+ 유료 플랜 신설)',
    pricing_info = '월 $12.5 ~ $15 (RR+ 플랜).',
    free_tier_note = '기본 탐색 및 시각화 기능 평생 무료. 컬렉션 생성, Zotero 연동 무료. (단, 2025년부터 고급 검색 기능 제한).',
    pricing_plans = '[{"plan": "Free", "target": "대부분의 연구자", "features": "무제한 검색/시각화, Zotero 연동, 기본 검색 필터", "price": "무료"}, {"plan": "RR+ (New)", "target": "헤비 유저", "features": "고급 검색 필터, 대량 입력(300개) 검색, 우선 지원", "price": "$12.5~/월"}, {"plan": "Institution", "target": "연구소", "features": "기관 단위 라이선스, 관리자 대시보드", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['시각적 탐색: 논문 하나를 넣으면 인용된 논문(Reference)과 인용한 논문(Citation)을 거미줄처럼 연결해 보여줍니다. "이 분야의 시초가 되는 논문"을 찾기 쉽습니다.', 'Zotero 연동: Zotero 서재와 양방향으로 동기화되어, 리서치래빗에서 찾은 논문을 클릭 한 번으로 내 서재에 넣을 수 있습니다.', '이메일 알림: 내 컬렉션과 관련된 새로운 논문이 나오면 "스포티파이 추천 곡"처럼 메일로 알려줍니다.', '여전히 혜자: 유료 플랜(RR+)이 생겼지만, 핵심인 ''네트워크 탐색''은 여전히 무료입니다.'],
    cons = ARRAY['유료화(RR+): 과거엔 "완전 무료"였으나, 2025년부터 고급 검색 기능(대량 검색 등)이 유료로 전환되었습니다.', '요약 기능 부족: 논문 내용을 AI가 요약해주거나 채팅하는 기능은 ScholarAI나 Elicit에 비해 약합니다. (탐색 도구에 가까움).'],
    key_features = '[{"name": "Citation Network", "description": "인용 관계 시각화 그래프 생성"}, {"name": "Similar Work", "description": "내가 고른 논문들과 유사한 다른 논문 추천"}, {"name": "Earlier/Later Work", "description": "해당 연구의 기원이 되는 논문 vs 최신 후속 연구 분류"}, {"name": "Zotero Sync", "description": "조테로 서재와 실시간 연동"}, {"name": "Alerts", "description": "관련 신규 논문 이메일 알림"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 문헌 고찰 시작", "reason": "\"이 주제의 족보(핵심 논문)가 어떻게 되지?\" 흐름을 잡고 싶은 분."}, {"target": "✅ 비주얼 러너", "reason": "텍스트 리스트보다 도표나 지도로 보는 게 편한 분."}, {"target": "✅ 놓친 논문 찾기", "reason": "키워드 검색으로는 안 나오는데, 꼭 읽어야 할 연관 논문을 발굴하고 싶을 때."}], "not_recommended": [{"target": "❌ 본문 분석", "reason": "논문 PDF를 업로드해서 \"이거 요약해줘\"라고 시키는 용도로는 적합하지 않습니다. (채팅 기능 없음)."}, {"target": "❌ 정밀 검색", "reason": "복잡한 Boolean 연산자(AND/OR)를 쓴 정밀 검색은 유료(RR+)여야 원활합니다."}]}'::jsonb,
    usage_tips = ARRAY['Seed Paper: 처음에 넣는 ''씨앗 논문''이 중요합니다. 엉뚱한 논문을 넣으면 추천 알고리즘 전체가 꼬이니, 가장 핵심적인 논문 2~3개를 먼저 넣으세요.', '유료 오해: 사이트에 들어가면 유료(RR+) 광고가 보일 수 있지만, 겁먹지 말고 Free 버전을 써도 충분합니다.'],
    privacy_info = '{"description": "공개/비공개: 컬렉션을 ''Public''으로 설정하면 공유 링크를 만들 수 있고, 기본적으로는 비공개입니다."}'::jsonb,
    alternatives = '[{"name": "Connected Papers", "description": "리서치래빗보다 그래프가 더 단순하고 직관적인 도구 (유료 제한 있음)"}, {"name": "Litmaps", "description": "시간 흐름(Timeline)에 따른 논문 관계를 보기에 더 좋은 도구"}]'::jsonb,
    media_info = '[{"title": "ResearchRabbit: The Spotify for Papers", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (ResearchRabbit)"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "선행 연구 조사를 시작하는 대학원생, 연관 논문을 놓치고 싶지 않은 연구자"}'::jsonb,
    features = ARRAY['Citation Network', 'Similar Work', 'Earlier/Later Work', 'Zotero Sync', 'Alerts']
WHERE name = 'ResearchRabbit';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'ResearchRabbit', '논문 간의 인용 관계를 시각적인 네트워크 지도(Graph)로 보여주어, 꼬리에 꼬리를 무는 논문 탐색을 도와주는 ''논문용 스포티파이''.', 'https://www.researchrabbit.ai/',
    'Freemium (기본 무료 + RR+ 유료 플랜 신설)', '월 $12.5 ~ $15 (RR+ 플랜).', '기본 탐색 및 시각화 기능 평생 무료. 컬렉션 생성, Zotero 연동 무료. (단, 2025년부터 고급 검색 기능 제한).',
    '[{"plan": "Free", "target": "대부분의 연구자", "features": "무제한 검색/시각화, Zotero 연동, 기본 검색 필터", "price": "무료"}, {"plan": "RR+ (New)", "target": "헤비 유저", "features": "고급 검색 필터, 대량 입력(300개) 검색, 우선 지원", "price": "$12.5~/월"}, {"plan": "Institution", "target": "연구소", "features": "기관 단위 라이선스, 관리자 대시보드", "price": "별도 문의"}]'::jsonb, ARRAY['시각적 탐색: 논문 하나를 넣으면 인용된 논문(Reference)과 인용한 논문(Citation)을 거미줄처럼 연결해 보여줍니다. "이 분야의 시초가 되는 논문"을 찾기 쉽습니다.', 'Zotero 연동: Zotero 서재와 양방향으로 동기화되어, 리서치래빗에서 찾은 논문을 클릭 한 번으로 내 서재에 넣을 수 있습니다.', '이메일 알림: 내 컬렉션과 관련된 새로운 논문이 나오면 "스포티파이 추천 곡"처럼 메일로 알려줍니다.', '여전히 혜자: 유료 플랜(RR+)이 생겼지만, 핵심인 ''네트워크 탐색''은 여전히 무료입니다.'], ARRAY['유료화(RR+): 과거엔 "완전 무료"였으나, 2025년부터 고급 검색 기능(대량 검색 등)이 유료로 전환되었습니다.', '요약 기능 부족: 논문 내용을 AI가 요약해주거나 채팅하는 기능은 ScholarAI나 Elicit에 비해 약합니다. (탐색 도구에 가까움).'], '[{"name": "Citation Network", "description": "인용 관계 시각화 그래프 생성"}, {"name": "Similar Work", "description": "내가 고른 논문들과 유사한 다른 논문 추천"}, {"name": "Earlier/Later Work", "description": "해당 연구의 기원이 되는 논문 vs 최신 후속 연구 분류"}, {"name": "Zotero Sync", "description": "조테로 서재와 실시간 연동"}, {"name": "Alerts", "description": "관련 신규 논문 이메일 알림"}]'::jsonb,
    '{"recommended": [{"target": "✅ 문헌 고찰 시작", "reason": "\"이 주제의 족보(핵심 논문)가 어떻게 되지?\" 흐름을 잡고 싶은 분."}, {"target": "✅ 비주얼 러너", "reason": "텍스트 리스트보다 도표나 지도로 보는 게 편한 분."}, {"target": "✅ 놓친 논문 찾기", "reason": "키워드 검색으로는 안 나오는데, 꼭 읽어야 할 연관 논문을 발굴하고 싶을 때."}], "not_recommended": [{"target": "❌ 본문 분석", "reason": "논문 PDF를 업로드해서 \"이거 요약해줘\"라고 시키는 용도로는 적합하지 않습니다. (채팅 기능 없음)."}, {"target": "❌ 정밀 검색", "reason": "복잡한 Boolean 연산자(AND/OR)를 쓴 정밀 검색은 유료(RR+)여야 원활합니다."}]}'::jsonb, ARRAY['Seed Paper: 처음에 넣는 ''씨앗 논문''이 중요합니다. 엉뚱한 논문을 넣으면 추천 알고리즘 전체가 꼬이니, 가장 핵심적인 논문 2~3개를 먼저 넣으세요.', '유료 오해: 사이트에 들어가면 유료(RR+) 광고가 보일 수 있지만, 겁먹지 말고 Free 버전을 써도 충분합니다.'], '{"description": "공개/비공개: 컬렉션을 ''Public''으로 설정하면 공유 링크를 만들 수 있고, 기본적으로는 비공개입니다."}'::jsonb,
    '[{"name": "Connected Papers", "description": "리서치래빗보다 그래프가 더 단순하고 직관적인 도구 (유료 제한 있음)"}, {"name": "Litmaps", "description": "시간 흐름(Timeline)에 따른 논문 관계를 보기에 더 좋은 도구"}]'::jsonb, '[{"title": "ResearchRabbit: The Spotify for Papers", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (ResearchRabbit)"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "선행 연구 조사를 시작하는 대학원생, 연관 논문을 놓치고 싶지 않은 연구자"}'::jsonb,
    ARRAY['Citation Network', 'Similar Work', 'Earlier/Later Work', 'Zotero Sync', 'Alerts'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'ResearchRabbit');

UPDATE ai_models SET
    description = '앨런 AI 연구소(Ai2)에서 만든 무료 학술 검색 엔진으로, ''TLDR(한 줄 요약)''과 ''Semantic Reader''로 논문 읽는 시간을 획기적으로 줄여줍니다.',
    website_url = 'https://www.semanticscholar.org/',
    pricing_model = 'Free (Open Source / Non-profit)',
    pricing_info = '없음.',
    free_tier_note = '검색, TLDR 요약, Semantic Reader, API 사용 등 모든 기능이 무료입니다. (비영리 재단 운영).',
    pricing_plans = '[{"plan": "Full Access", "target": "모든 연구자", "features": "TLDR(초요약), Semantic Reader(베타), 알림, 라이브러리", "price": "무료"}]'::jsonb,
    pros = ARRAY['TLDR (Too Long; Didn''t Read): 논문 초록조차 읽기 귀찮을 때, AI가 만든 ''한 줄짜리 초요약''을 보여줍니다. 스크롤하면서 핵심만 파악하기 최고입니다.', 'Semantic Reader (Beta): PDF를 열면, 본문 속의 난해한 수식이나 인용 표시를 클릭했을 때 해당 개념 설명이나 인용 논문 정보를 팝업으로 띄워줍니다. (논문 읽기 혁명).', 'Asta (최신): 2026년 공개된 Ai2의 에이전트(Asta)와 연동되어, 단순 검색을 넘어 연구 보조 기능을 강화하고 있습니다.', '완전 무료: 상업적 도구가 아니라서 유료 결제 유도가 전혀 없습니다.'],
    cons = ARRAY['대화형 기능 부재: ChatGPT처럼 논문과 대화하거나 질문하는 기능은 없습니다. (읽기/검색 전용).', '분야 편중: 컴퓨터 과학(CS)이나 바이오 분야 논문 데이터베이스가 가장 풍부하고, 인문/사회과학 쪽은 상대적으로 약할 수 있습니다.'],
    key_features = '[{"name": "TLDR", "description": "논문의 핵심 기여를 한 문장으로 자동 요약"}, {"name": "Semantic Reader", "description": "수식/인용 클릭 시 설명 팝업이 뜨는 차세대 PDF 뷰어"}, {"name": "Research Feeds", "description": "내 관심 주제의 최신 논문을 AI가 추천"}, {"name": "Citation Velocity", "description": "이 논문이 최근에 얼마나 핫하게 인용되는지 그래프로 표시"}, {"name": "Highly Influential Citations", "description": "단순 인용 횟수가 아니라, 실제로 중요한 영향을 미친 인용만 필터링"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 속독가", "reason": "수백 개의 검색 결과 중 읽을 만한 논문을 ''TLDR''로 1초 만에 거르고 싶은 분."}, {"target": "✅ 딥러닝/CS 연구자", "reason": "아카이브(arXiv) 논문을 가장 편하게 읽고 싶은 분 (Semantic Reader)."}, {"target": "✅ 가성비", "reason": "유료 툴은 부담스럽고, 구글 스칼라보다는 똑똑한 무료 툴을 찾는 분."}], "not_recommended": [{"target": "❌ 논문 대화", "reason": "\"이 논문 방법론 설명해줘\"라고 채팅하고 싶다면 ChatPDF나 ScholarAI를 쓰세요."}, {"target": "❌ 한글 논문", "reason": "국내 저널 검색용으로는 적합하지 않습니다."}]}'::jsonb,
    usage_tips = ARRAY['Reader 호환성: 모든 논문에서 ''Semantic Reader''가 작동하는 건 아닙니다. 주로 arXiv나 파트너 출판사 논문에서만 "Read Research Paper" 버튼이 파랗게 활성화됩니다.', 'API 사용: 개발자라면 Semantic Scholar API를 무료로 따서 나만의 논문 분석 툴을 만들 수도 있습니다.'],
    privacy_info = '{"description": "비영리: 앨런 AI 연구소(Ai2)가 운영하므로 상업적 데이터 판매 걱정이 적습니다."}'::jsonb,
    alternatives = '[{"name": "Google Scholar", "description": "가장 방대한 DB를 원한다면 (기능은 투박함)"}, {"name": "Consensus", "description": "\"과학적 합의\" 여부를 알고 싶다면"}]'::jsonb,
    media_info = '[{"title": "Introducing Semantic Reader", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Allen Institute for AI)"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Optional", "platforms": ["Web", "Mobile Web", "API"], "target_audience": "컴퓨터 과학(CS), 바이오 등 최신 기술 트렌드를 빠르게 파악해야 하는 연구자"}'::jsonb,
    features = ARRAY['TLDR', 'Semantic Reader', 'Research Feeds', 'Citation Velocity', 'Highly Influential Citations']
WHERE name = 'Semantic Scholar';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Semantic Scholar', '앨런 AI 연구소(Ai2)에서 만든 무료 학술 검색 엔진으로, ''TLDR(한 줄 요약)''과 ''Semantic Reader''로 논문 읽는 시간을 획기적으로 줄여줍니다.', 'https://www.semanticscholar.org/',
    'Free (Open Source / Non-profit)', '없음.', '검색, TLDR 요약, Semantic Reader, API 사용 등 모든 기능이 무료입니다. (비영리 재단 운영).',
    '[{"plan": "Full Access", "target": "모든 연구자", "features": "TLDR(초요약), Semantic Reader(베타), 알림, 라이브러리", "price": "무료"}]'::jsonb, ARRAY['TLDR (Too Long; Didn''t Read): 논문 초록조차 읽기 귀찮을 때, AI가 만든 ''한 줄짜리 초요약''을 보여줍니다. 스크롤하면서 핵심만 파악하기 최고입니다.', 'Semantic Reader (Beta): PDF를 열면, 본문 속의 난해한 수식이나 인용 표시를 클릭했을 때 해당 개념 설명이나 인용 논문 정보를 팝업으로 띄워줍니다. (논문 읽기 혁명).', 'Asta (최신): 2026년 공개된 Ai2의 에이전트(Asta)와 연동되어, 단순 검색을 넘어 연구 보조 기능을 강화하고 있습니다.', '완전 무료: 상업적 도구가 아니라서 유료 결제 유도가 전혀 없습니다.'], ARRAY['대화형 기능 부재: ChatGPT처럼 논문과 대화하거나 질문하는 기능은 없습니다. (읽기/검색 전용).', '분야 편중: 컴퓨터 과학(CS)이나 바이오 분야 논문 데이터베이스가 가장 풍부하고, 인문/사회과학 쪽은 상대적으로 약할 수 있습니다.'], '[{"name": "TLDR", "description": "논문의 핵심 기여를 한 문장으로 자동 요약"}, {"name": "Semantic Reader", "description": "수식/인용 클릭 시 설명 팝업이 뜨는 차세대 PDF 뷰어"}, {"name": "Research Feeds", "description": "내 관심 주제의 최신 논문을 AI가 추천"}, {"name": "Citation Velocity", "description": "이 논문이 최근에 얼마나 핫하게 인용되는지 그래프로 표시"}, {"name": "Highly Influential Citations", "description": "단순 인용 횟수가 아니라, 실제로 중요한 영향을 미친 인용만 필터링"}]'::jsonb,
    '{"recommended": [{"target": "✅ 속독가", "reason": "수백 개의 검색 결과 중 읽을 만한 논문을 ''TLDR''로 1초 만에 거르고 싶은 분."}, {"target": "✅ 딥러닝/CS 연구자", "reason": "아카이브(arXiv) 논문을 가장 편하게 읽고 싶은 분 (Semantic Reader)."}, {"target": "✅ 가성비", "reason": "유료 툴은 부담스럽고, 구글 스칼라보다는 똑똑한 무료 툴을 찾는 분."}], "not_recommended": [{"target": "❌ 논문 대화", "reason": "\"이 논문 방법론 설명해줘\"라고 채팅하고 싶다면 ChatPDF나 ScholarAI를 쓰세요."}, {"target": "❌ 한글 논문", "reason": "국내 저널 검색용으로는 적합하지 않습니다."}]}'::jsonb, ARRAY['Reader 호환성: 모든 논문에서 ''Semantic Reader''가 작동하는 건 아닙니다. 주로 arXiv나 파트너 출판사 논문에서만 "Read Research Paper" 버튼이 파랗게 활성화됩니다.', 'API 사용: 개발자라면 Semantic Scholar API를 무료로 따서 나만의 논문 분석 툴을 만들 수도 있습니다.'], '{"description": "비영리: 앨런 AI 연구소(Ai2)가 운영하므로 상업적 데이터 판매 걱정이 적습니다."}'::jsonb,
    '[{"name": "Google Scholar", "description": "가장 방대한 DB를 원한다면 (기능은 투박함)"}, {"name": "Consensus", "description": "\"과학적 합의\" 여부를 알고 싶다면"}]'::jsonb, '[{"title": "Introducing Semantic Reader", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Allen Institute for AI)"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Optional", "platforms": ["Web", "Mobile Web", "API"], "target_audience": "컴퓨터 과학(CS), 바이오 등 최신 기술 트렌드를 빠르게 파악해야 하는 연구자"}'::jsonb,
    ARRAY['TLDR', 'Semantic Reader', 'Research Feeds', 'Citation Velocity', 'Highly Influential Citations'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Semantic Scholar');

UPDATE ai_models SET
    description = '단순 검색을 넘어, 방대한 전문 지식 데이터베이스와 연산 엔진을 통해 수학, 과학, 금융 문제의 ''정답''과 ''풀이 과정''을 도출하는 계산 지식 엔진.',
    website_url = 'https://www.wolframalpha.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $5 (Pro / 학생 할인가), 일반 월 $9.99.',
    free_tier_note = '기본 연산 및 지식 검색 결과(정답) 확인 가능. 단계별 풀이(Step-by-step)는 미리보기만 제공.',
    pricing_plans = '[{"plan": "Basic", "target": "찍먹파", "features": "정답 및 기본 그래프 확인, 풀이 과정 불가", "price": "무료"}, {"plan": "Pro", "target": "대학생", "features": "Step-by-step 풀이, 파일 업로드 분석, 고급 시각화", "price": "$5~9.99/월"}, {"plan": "Pro Premium", "target": "전문가", "features": "모든 Pro 기능 + 우선 지원 + 전문가급 데이터 내보내기", "price": "$24.99/월"}]'::jsonb,
    pros = ARRAY['할루시네이션 제로: ChatGPT가 수학 계산을 틀릴 때, 울프람알파는 100% 정확한 계산 결과와 근거를 제시합니다. (Symbolic Computation).', 'Step-by-step: 미적분이나 복잡한 방정식의 풀이 과정을 교과서처럼 한 줄 한 줄 보여줍니다. (Pro).', '방대한 데이터: 수학뿐만 아니라 화학 원소 정보, 금융 데이터, 영양 성분 등 구조화된 데이터베이스가 압도적입니다.', 'LLM 연동: ChatGPT 유료 사용자라면 울프람알파 플러그인을 통해 "언어 능력(GPT)"과 "계산 능력(Wolfram)"을 합체시킬 수 있습니다.'],
    cons = ARRAY['자연어 이해 한계: 긴 문장형 질문보다는 수식이나 키워드 위주의 검색어(Query)를 잘 넣어야 정확한 답이 나옵니다.', '유료 필수: 핵심 기능인 ''단계별 풀이''가 유료라서 학생들에게는 비용 부담이 될 수 있습니다.'],
    key_features = '[{"name": "Step-by-step Solutions", "description": "수학/과학 문제의 상세 풀이 과정 제공 (Pro)"}, {"name": "Image Input", "description": "수식 사진을 찍어 업로드하면 인식 후 풀이 (Pro)"}, {"name": "Data Analysis", "description": "엑셀/CSV 파일을 올려 통계 분석 및 시각화"}, {"name": "Plotting", "description": "2D/3D 그래프 생성 및 함수 시각화"}, {"name": "Notebook Edition", "description": "파이썬/울프람 언어 코딩과 계산을 동시에 하는 노트 환경"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 이공계생", "reason": "미적분, 선형대수학 과제할 때 풀이 과정이 막히는 분."}, {"target": "✅ 데이터 검증", "reason": "AI가 쓴 리포트의 통계 수치가 맞는지 팩트 체크가 필요한 분."}, {"target": "✅ 연구자", "reason": "논문에 들어갈 정확한 과학적 그래프나 도표가 필요한 분."}], "not_recommended": [{"target": "❌ 창의적 글쓰기", "reason": "에세이나 소설을 써주는 도구가 아닙니다."}, {"target": "❌ 단순 산수", "reason": "1+1 수준의 계산은 구글 검색이나 기본 계산기가 더 빠릅니다."}]}'::jsonb,
    usage_tips = ARRAY['구독 취소: 방학 때는 안 쓰게 되니, 학기 중에만 구독하고 방학엔 일시 정지하거나 취소하는 게 절약 팁입니다.', '입력 언어: "이거 미분해줘"보다 "differentiate x^2"처럼 영어 명령어나 수식 기호를 쓰는 게 훨씬 정확합니다.'],
    privacy_info = '{"description": "데이터 활용: 사용자의 검색 쿼리는 서비스 개선 및 통계 목적으로 익명화되어 활용될 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "Photomath", "description": "중고등학생 수준의 수식은 사진만 찍으면 더 쉽게 풀어줌"}, {"name": "Symbolab", "description": "울프람보다 UI가 좀 더 직관적인 수학 전용 풀이 도구"}]'::jsonb,
    media_info = '[{"title": "What is Wolfram|Alpha?", "url": "[https://www.youtube.com/watch?v=R2g8t-d3bNs](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DR2g8t-d3bNs) (공식 채널)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "ChatGPT Plugin"], "target_audience": "이공계 대학생, 연구원, 데이터 분석가, 수학 문제를 풀어야 하는 모든 사람"}'::jsonb,
    features = ARRAY['Step-by-step Solutions', 'Image Input', 'Data Analysis', 'Plotting', 'Notebook Edition']
WHERE name = 'Wolfram Alpha';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Wolfram Alpha', '단순 검색을 넘어, 방대한 전문 지식 데이터베이스와 연산 엔진을 통해 수학, 과학, 금융 문제의 ''정답''과 ''풀이 과정''을 도출하는 계산 지식 엔진.', 'https://www.wolframalpha.com/',
    'Freemium (무료 + 유료 구독)', '월 $5 (Pro / 학생 할인가), 일반 월 $9.99.', '기본 연산 및 지식 검색 결과(정답) 확인 가능. 단계별 풀이(Step-by-step)는 미리보기만 제공.',
    '[{"plan": "Basic", "target": "찍먹파", "features": "정답 및 기본 그래프 확인, 풀이 과정 불가", "price": "무료"}, {"plan": "Pro", "target": "대학생", "features": "Step-by-step 풀이, 파일 업로드 분석, 고급 시각화", "price": "$5~9.99/월"}, {"plan": "Pro Premium", "target": "전문가", "features": "모든 Pro 기능 + 우선 지원 + 전문가급 데이터 내보내기", "price": "$24.99/월"}]'::jsonb, ARRAY['할루시네이션 제로: ChatGPT가 수학 계산을 틀릴 때, 울프람알파는 100% 정확한 계산 결과와 근거를 제시합니다. (Symbolic Computation).', 'Step-by-step: 미적분이나 복잡한 방정식의 풀이 과정을 교과서처럼 한 줄 한 줄 보여줍니다. (Pro).', '방대한 데이터: 수학뿐만 아니라 화학 원소 정보, 금융 데이터, 영양 성분 등 구조화된 데이터베이스가 압도적입니다.', 'LLM 연동: ChatGPT 유료 사용자라면 울프람알파 플러그인을 통해 "언어 능력(GPT)"과 "계산 능력(Wolfram)"을 합체시킬 수 있습니다.'], ARRAY['자연어 이해 한계: 긴 문장형 질문보다는 수식이나 키워드 위주의 검색어(Query)를 잘 넣어야 정확한 답이 나옵니다.', '유료 필수: 핵심 기능인 ''단계별 풀이''가 유료라서 학생들에게는 비용 부담이 될 수 있습니다.'], '[{"name": "Step-by-step Solutions", "description": "수학/과학 문제의 상세 풀이 과정 제공 (Pro)"}, {"name": "Image Input", "description": "수식 사진을 찍어 업로드하면 인식 후 풀이 (Pro)"}, {"name": "Data Analysis", "description": "엑셀/CSV 파일을 올려 통계 분석 및 시각화"}, {"name": "Plotting", "description": "2D/3D 그래프 생성 및 함수 시각화"}, {"name": "Notebook Edition", "description": "파이썬/울프람 언어 코딩과 계산을 동시에 하는 노트 환경"}]'::jsonb,
    '{"recommended": [{"target": "✅ 이공계생", "reason": "미적분, 선형대수학 과제할 때 풀이 과정이 막히는 분."}, {"target": "✅ 데이터 검증", "reason": "AI가 쓴 리포트의 통계 수치가 맞는지 팩트 체크가 필요한 분."}, {"target": "✅ 연구자", "reason": "논문에 들어갈 정확한 과학적 그래프나 도표가 필요한 분."}], "not_recommended": [{"target": "❌ 창의적 글쓰기", "reason": "에세이나 소설을 써주는 도구가 아닙니다."}, {"target": "❌ 단순 산수", "reason": "1+1 수준의 계산은 구글 검색이나 기본 계산기가 더 빠릅니다."}]}'::jsonb, ARRAY['구독 취소: 방학 때는 안 쓰게 되니, 학기 중에만 구독하고 방학엔 일시 정지하거나 취소하는 게 절약 팁입니다.', '입력 언어: "이거 미분해줘"보다 "differentiate x^2"처럼 영어 명령어나 수식 기호를 쓰는 게 훨씬 정확합니다.'], '{"description": "데이터 활용: 사용자의 검색 쿼리는 서비스 개선 및 통계 목적으로 익명화되어 활용될 수 있습니다."}'::jsonb,
    '[{"name": "Photomath", "description": "중고등학생 수준의 수식은 사진만 찍으면 더 쉽게 풀어줌"}, {"name": "Symbolab", "description": "울프람보다 UI가 좀 더 직관적인 수학 전용 풀이 도구"}]'::jsonb, '[{"title": "What is Wolfram|Alpha?", "url": "[https://www.youtube.com/watch?v=R2g8t-d3bNs](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DR2g8t-d3bNs) (공식 채널)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "ChatGPT Plugin"], "target_audience": "이공계 대학생, 연구원, 데이터 분석가, 수학 문제를 풀어야 하는 모든 사람"}'::jsonb,
    ARRAY['Step-by-step Solutions', 'Image Input', 'Data Analysis', 'Plotting', 'Notebook Edition'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Wolfram Alpha');

UPDATE ai_models SET
    description = '스마트폰 카메라로 수학 문제를 비추기만 하면, AI가 숫자를 인식해 즉시 정답과 풀이 과정을 보여주는 구글(Google)의 수학 비서.',
    website_url = 'https://photomath.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 약 6,000원 (Photomath Plus / 연 결제 시 할인)',
    free_tier_note = '카메라 인식, 기본 정답 확인, 기본적인 단계별 풀이 제공.',
    pricing_plans = '[{"plan": "Free", "target": "일반 학생", "features": "문제 인식, 정답, 기본 풀이 단계", "price": "무료"}, {"plan": "Plus", "target": "수포자/학부모", "features": "애니메이션 튜토리얼, 심층 설명, 교과서별 솔루션", "price": "유료 구독"}]'::jsonb,
    pros = ARRAY['압도적 인식률: 손으로 개발새발 쓴 글씨도 찰떡같이 알아보고 수식으로 변환합니다. (OCR 기술 최상위).', '직관적 풀이: "왜 여기서 숫자가 바뀌었지?" 싶은 부분을 누르면 말풍선으로 친절하게 설명해 줍니다.', '접근성: 구글이 인수한 뒤로 앱 안정성이 더 좋아졌고, 광고 없이 깔끔한 UI를 유지하고 있습니다.', '애니메이션(Plus): 유료 버전은 그래프가 그려지는 과정이나 이항 과정을 동영상처럼 움직이면서 보여줘 이해를 돕습니다.'],
    cons = ARRAY['대학 수학 한계: 고등학교 수준(미적분 기초)까지는 완벽하지만, 대학 수준의 복잡한 공학 수학이나 증명 문제는 풀지 못할 수 있습니다.', '문장제 문제: 수식이 아닌 "철수가 사과를..." 같은 긴 문장형 문제(서술형) 인식 능력은 LLM(ChatGPT 등)보다 떨어집니다.'],
    key_features = '[{"name": "Camera Scan", "description": "손글씨 및 인쇄된 수식 스캔"}, {"name": "Step-by-step", "description": "단계별 풀이 과정 텍스트 제공"}, {"name": "Smart Calculator", "description": "스캔이 안 될 때 직접 입력할 수 있는 공학용 계산기 UI"}, {"name": "Animated Tutorial", "description": "풀이 과정을 시각적으로 보여주는 애니메이션 (Plus)"}, {"name": "Textbook Solutions", "description": "주요 수학 교과서/문제집의 페이지별 해설 (국가별 상이)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 중고등학생", "reason": "혼자 공부하다가 답지 해설을 봐도 이해가 안 갈 때."}, {"target": "✅ 학부모", "reason": "아이가 수학 물어보는데 다 까먹어서 당황스러울 때 몰래 찍어서 확인용."}, {"target": "✅ 검산용", "reason": "내가 푼 답이 맞는지 빠르게 확인하고 싶을 때."}], "not_recommended": [{"target": "❌ 대학생", "reason": "선형대수학이나 복소해석학 같은 전공 수학은 울프람알파를 쓰세요."}, {"target": "❌ 숙제 대행", "reason": "베끼기 용도로만 쓰면 본인 실력은 하나도 안 늡니다 (의존 주의)."}]}'::jsonb,
    usage_tips = ARRAY['손글씨: 너무 흘려쓰면 5를 S로, 1을 7로 인식할 수 있습니다. 수식은 또박또박 쓰고, 인식된 수식을 수정 버튼으로 고치세요.', '구글 렌즈: 구글 앱의 ''과제 검색'' 기능에도 포토매스 기술이 통합되어 있으니, 앱 설치가 귀찮으면 구글 렌즈를 써보세요.'],
    privacy_info = '{"description": "구글 계정: 구글 인수 후 구글 계정 연동이 강화되었습니다. 데이터 처리는 구글의 개인정보 방침을 따릅니다."}'::jsonb,
    alternatives = '[{"name": "Qanda (콴다)", "description": "한국 앱, 모르는 문제를 찍으면 명문대 선생님 풀이나 유사 문제를 찾아줌 (서술형에 강함)"}, {"name": "Wolfram Alpha", "description": "더 복잡하고 전문적인 대학 수학용"}]'::jsonb,
    media_info = '[{"title": "Photomath Plus: Learning Math made easy", "url": "https://www.youtube.com/watch?v= (공식 채널)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Optional", "platforms": ["iOS", "Android (모바일 전용)"], "target_audience": "초·중·고등학생, 자녀 수학 숙제를 봐주는 학부모"}'::jsonb,
    features = ARRAY['Camera Scan', 'Step-by-step', 'Smart Calculator', 'Animated Tutorial', 'Textbook Solutions']
WHERE name = 'Photomath';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Photomath', '스마트폰 카메라로 수학 문제를 비추기만 하면, AI가 숫자를 인식해 즉시 정답과 풀이 과정을 보여주는 구글(Google)의 수학 비서.', 'https://photomath.com/',
    'Freemium (무료 + 유료 구독)', '월 약 6,000원 (Photomath Plus / 연 결제 시 할인)', '카메라 인식, 기본 정답 확인, 기본적인 단계별 풀이 제공.',
    '[{"plan": "Free", "target": "일반 학생", "features": "문제 인식, 정답, 기본 풀이 단계", "price": "무료"}, {"plan": "Plus", "target": "수포자/학부모", "features": "애니메이션 튜토리얼, 심층 설명, 교과서별 솔루션", "price": "유료 구독"}]'::jsonb, ARRAY['압도적 인식률: 손으로 개발새발 쓴 글씨도 찰떡같이 알아보고 수식으로 변환합니다. (OCR 기술 최상위).', '직관적 풀이: "왜 여기서 숫자가 바뀌었지?" 싶은 부분을 누르면 말풍선으로 친절하게 설명해 줍니다.', '접근성: 구글이 인수한 뒤로 앱 안정성이 더 좋아졌고, 광고 없이 깔끔한 UI를 유지하고 있습니다.', '애니메이션(Plus): 유료 버전은 그래프가 그려지는 과정이나 이항 과정을 동영상처럼 움직이면서 보여줘 이해를 돕습니다.'], ARRAY['대학 수학 한계: 고등학교 수준(미적분 기초)까지는 완벽하지만, 대학 수준의 복잡한 공학 수학이나 증명 문제는 풀지 못할 수 있습니다.', '문장제 문제: 수식이 아닌 "철수가 사과를..." 같은 긴 문장형 문제(서술형) 인식 능력은 LLM(ChatGPT 등)보다 떨어집니다.'], '[{"name": "Camera Scan", "description": "손글씨 및 인쇄된 수식 스캔"}, {"name": "Step-by-step", "description": "단계별 풀이 과정 텍스트 제공"}, {"name": "Smart Calculator", "description": "스캔이 안 될 때 직접 입력할 수 있는 공학용 계산기 UI"}, {"name": "Animated Tutorial", "description": "풀이 과정을 시각적으로 보여주는 애니메이션 (Plus)"}, {"name": "Textbook Solutions", "description": "주요 수학 교과서/문제집의 페이지별 해설 (국가별 상이)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 중고등학생", "reason": "혼자 공부하다가 답지 해설을 봐도 이해가 안 갈 때."}, {"target": "✅ 학부모", "reason": "아이가 수학 물어보는데 다 까먹어서 당황스러울 때 몰래 찍어서 확인용."}, {"target": "✅ 검산용", "reason": "내가 푼 답이 맞는지 빠르게 확인하고 싶을 때."}], "not_recommended": [{"target": "❌ 대학생", "reason": "선형대수학이나 복소해석학 같은 전공 수학은 울프람알파를 쓰세요."}, {"target": "❌ 숙제 대행", "reason": "베끼기 용도로만 쓰면 본인 실력은 하나도 안 늡니다 (의존 주의)."}]}'::jsonb, ARRAY['손글씨: 너무 흘려쓰면 5를 S로, 1을 7로 인식할 수 있습니다. 수식은 또박또박 쓰고, 인식된 수식을 수정 버튼으로 고치세요.', '구글 렌즈: 구글 앱의 ''과제 검색'' 기능에도 포토매스 기술이 통합되어 있으니, 앱 설치가 귀찮으면 구글 렌즈를 써보세요.'], '{"description": "구글 계정: 구글 인수 후 구글 계정 연동이 강화되었습니다. 데이터 처리는 구글의 개인정보 방침을 따릅니다."}'::jsonb,
    '[{"name": "Qanda (콴다)", "description": "한국 앱, 모르는 문제를 찍으면 명문대 선생님 풀이나 유사 문제를 찾아줌 (서술형에 강함)"}, {"name": "Wolfram Alpha", "description": "더 복잡하고 전문적인 대학 수학용"}]'::jsonb, '[{"title": "Photomath Plus: Learning Math made easy", "url": "https://www.youtube.com/watch?v= (공식 채널)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Optional", "platforms": ["iOS", "Android (모바일 전용)"], "target_audience": "초·중·고등학생, 자녀 수학 숙제를 봐주는 학부모"}'::jsonb,
    ARRAY['Camera Scan', 'Step-by-step', 'Smart Calculator', 'Animated Tutorial', 'Textbook Solutions'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Photomath');

UPDATE ai_models SET
    description = '전 세계 1위 암기 카드 서비스 ''퀴즈렛''에 OpenAI 기술이 결합된 AI 튜터로, 소크라테스 문답법으로 사용자의 학습을 유도하는 대화형 코치.',
    website_url = 'https://www.google.com/search?q=https://quizlet.com/features/q-chat',
    pricing_model = 'Freemium (일부 무료 + 유료 구독)',
    pricing_info = '월 약 $3~7 (Quizlet Plus / 연간 결제 시).',
    free_tier_note = 'Q-Chat 체험판 사용 가능(하루 질문 횟수 제한).',
    pricing_plans = '[{"plan": "Free", "target": "라이트 유저", "features": "학습 세트 생성, 광고 포함, Q-Chat 제한적 사용", "price": "무료"}, {"plan": "Plus", "target": "수험생", "features": "Q-Chat 무제한, 광고 제거, 오프라인 학습, 맞춤 학습 경로", "price": "$35.99/년"}]'::jsonb,
    pros = ARRAY['소크라테스식 문답: "정답은 이거야"라고 바로 알려주는 게 아니라, "이 단어의 어원은 뭘까요?"라며 질문을 던져서 스스로 생각하게 만듭니다.', '학습 세트 연동: 내가 만든 단어장(Flashcards)을 기반으로 퀴즈를 내주므로, 범위를 벗어난 딴소리를 안 합니다.', '다양한 모드: ''퀴즈 내줘'', ''심화 학습'', ''스토리텔링으로 가르쳐줘'' 등 공부 스타일에 맞춰 AI 성격을 바꿀 수 있습니다.', '언어 학습: 외국어 문장을 주고받으며 회화 연습과 문법 교정을 동시에 할 수 있습니다.'],
    cons = ARRAY['유료화: Q-Chat을 제대로 쓰려면 사실상 Plus 구독이 필수입니다.', '깊이의 한계: 논리적인 추론이나 복잡한 에세이 작성보다는 ''암기''와 ''개념 확인''에 특화되어 있습니다.'],
    key_features = '[{"name": "Quiz Me", "description": "학습 세트 기반으로 즉석 퀴즈 출제"}, {"name": "Deepen Understanding", "description": "개념을 더 깊이 이해하도록 꼬리 질문"}, {"name": "Practice with Sentences", "description": "해당 단어를 활용한 작문 연습"}, {"name": "Story Mode", "description": "암기할 내용을 재미있는 이야기로 각색해서 들려줌"}, {"name": "Flashcards Integration", "description": "7억 개 이상의 기존 학습 세트와 바로 연동"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 단어 암기", "reason": "영단어, 의학 용어, 법률 용어 등 외울 게 산더미인 분."}, {"target": "✅ 능동적 학습", "reason": "그냥 눈으로 보는 게 아니라, AI랑 대화하면서 내가 아는 걸 인출(Output)하고 싶은 분."}, {"target": "✅ 수업 복습", "reason": "오늘 배운 내용을 퀴즈렛 세트로 만들고 AI한테 \"나 테스트해줘\"라고 시키고 싶은 학생."}], "not_recommended": [{"target": "❌ 수학 풀이", "reason": "계산 문제는 포토매스나 울프람알파가 낫습니다."}, {"target": "❌ 자료 생성", "reason": "PPT를 만들거나 긴 글을 써주는 생성형 AI는 아닙니다."}]}'::jsonb,
    usage_tips = ARRAY['세트 선택: Q-Chat을 켜기 전에 반드시 ''어떤 학습 세트''로 공부할지 먼저 선택해야 합니다. 빈 화면에서 대화하는 게 아닙니다.', '언어 설정: 영어 학습 세트라면 AI와 영어로 대화하는 게 기본이지만, "한국어로 설명해줘"라고 하면 한국어로 바꿔줍니다.'],
    privacy_info = '{"description": "OpenAI API: ChatGPT API를 사용하며, 학습 데이터는 개인정보 보호 정책에 따라 관리됩니다."}'::jsonb,
    alternatives = '[{"name": "Anki", "description": "무료(PC/안드로이드)로 쓸 수 있는 가장 강력한 암기 도구 (AI 기능은 플러그인 필요)"}, {"name": "Kahoot!", "description": "여럿이서 게임처럼 퀴즈를 풀고 싶다면"}]'::jsonb,
    media_info = '[{"title": "Meet Q-Chat: Your personal AI tutor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Quizlet)"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "암기 과목(영단어, 의학 용어, 역사 등)을 공부하는 학생 및 수험생"}'::jsonb,
    features = ARRAY['Quiz Me', 'Deepen Understanding', 'Practice with Sentences', 'Story Mode', 'Flashcards Integration']
WHERE name = 'Quizlet';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Quizlet', '전 세계 1위 암기 카드 서비스 ''퀴즈렛''에 OpenAI 기술이 결합된 AI 튜터로, 소크라테스 문답법으로 사용자의 학습을 유도하는 대화형 코치.', 'https://www.google.com/search?q=https://quizlet.com/features/q-chat',
    'Freemium (일부 무료 + 유료 구독)', '월 약 $3~7 (Quizlet Plus / 연간 결제 시).', 'Q-Chat 체험판 사용 가능(하루 질문 횟수 제한).',
    '[{"plan": "Free", "target": "라이트 유저", "features": "학습 세트 생성, 광고 포함, Q-Chat 제한적 사용", "price": "무료"}, {"plan": "Plus", "target": "수험생", "features": "Q-Chat 무제한, 광고 제거, 오프라인 학습, 맞춤 학습 경로", "price": "$35.99/년"}]'::jsonb, ARRAY['소크라테스식 문답: "정답은 이거야"라고 바로 알려주는 게 아니라, "이 단어의 어원은 뭘까요?"라며 질문을 던져서 스스로 생각하게 만듭니다.', '학습 세트 연동: 내가 만든 단어장(Flashcards)을 기반으로 퀴즈를 내주므로, 범위를 벗어난 딴소리를 안 합니다.', '다양한 모드: ''퀴즈 내줘'', ''심화 학습'', ''스토리텔링으로 가르쳐줘'' 등 공부 스타일에 맞춰 AI 성격을 바꿀 수 있습니다.', '언어 학습: 외국어 문장을 주고받으며 회화 연습과 문법 교정을 동시에 할 수 있습니다.'], ARRAY['유료화: Q-Chat을 제대로 쓰려면 사실상 Plus 구독이 필수입니다.', '깊이의 한계: 논리적인 추론이나 복잡한 에세이 작성보다는 ''암기''와 ''개념 확인''에 특화되어 있습니다.'], '[{"name": "Quiz Me", "description": "학습 세트 기반으로 즉석 퀴즈 출제"}, {"name": "Deepen Understanding", "description": "개념을 더 깊이 이해하도록 꼬리 질문"}, {"name": "Practice with Sentences", "description": "해당 단어를 활용한 작문 연습"}, {"name": "Story Mode", "description": "암기할 내용을 재미있는 이야기로 각색해서 들려줌"}, {"name": "Flashcards Integration", "description": "7억 개 이상의 기존 학습 세트와 바로 연동"}]'::jsonb,
    '{"recommended": [{"target": "✅ 단어 암기", "reason": "영단어, 의학 용어, 법률 용어 등 외울 게 산더미인 분."}, {"target": "✅ 능동적 학습", "reason": "그냥 눈으로 보는 게 아니라, AI랑 대화하면서 내가 아는 걸 인출(Output)하고 싶은 분."}, {"target": "✅ 수업 복습", "reason": "오늘 배운 내용을 퀴즈렛 세트로 만들고 AI한테 \"나 테스트해줘\"라고 시키고 싶은 학생."}], "not_recommended": [{"target": "❌ 수학 풀이", "reason": "계산 문제는 포토매스나 울프람알파가 낫습니다."}, {"target": "❌ 자료 생성", "reason": "PPT를 만들거나 긴 글을 써주는 생성형 AI는 아닙니다."}]}'::jsonb, ARRAY['세트 선택: Q-Chat을 켜기 전에 반드시 ''어떤 학습 세트''로 공부할지 먼저 선택해야 합니다. 빈 화면에서 대화하는 게 아닙니다.', '언어 설정: 영어 학습 세트라면 AI와 영어로 대화하는 게 기본이지만, "한국어로 설명해줘"라고 하면 한국어로 바꿔줍니다.'], '{"description": "OpenAI API: ChatGPT API를 사용하며, 학습 데이터는 개인정보 보호 정책에 따라 관리됩니다."}'::jsonb,
    '[{"name": "Anki", "description": "무료(PC/안드로이드)로 쓸 수 있는 가장 강력한 암기 도구 (AI 기능은 플러그인 필요)"}, {"name": "Kahoot!", "description": "여럿이서 게임처럼 퀴즈를 풀고 싶다면"}]'::jsonb, '[{"title": "Meet Q-Chat: Your personal AI tutor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Quizlet)"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "암기 과목(영단어, 의학 용어, 역사 등)을 공부하는 학생 및 수험생"}'::jsonb,
    ARRAY['Quiz Me', 'Deepen Understanding', 'Practice with Sentences', 'Story Mode', 'Flashcards Integration'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Quizlet');

UPDATE ai_models SET
    description = '강의 영상, PDF, PPT 파일을 업로드하면 AI가 내용을 분석해 요약 노트, 플래시카드, 퀴즈를 자동으로 생성해 주는 ''학습 자료 제작기''.',
    website_url = 'https://mindgrasp.ai/',
    pricing_model = 'Subscription (구독형)',
    pricing_info = '월 $6.99 (Basic / 연 결제 시) ~ $9.99 (Scholar).',
    free_tier_note = '4일 무료 체험(Trial) 제공. 체험 기간 종료 후 자동 결제되므로 주의 필요.',
    pricing_plans = '[{"plan": "Basic", "target": "가벼운 학습", "features": "월 제한적 업로드, 기본 요약", "price": "$6.99/월"}, {"plan": "Scholar", "target": "대학생", "features": "무제한 업로드, 퀴즈/플래시카드 생성, 웹 검색", "price": "$9.99/월"}, {"plan": "Premium", "target": "헤비 유저", "features": "여러 파일 동시 분석, 최우선 지원", "price": "$14.99/월"}]'::jsonb,
    pros = ARRAY['멀티모달 소스: 텍스트뿐만 아니라 유튜브 링크, 강의 녹음 파일(MP3), 줌 영상을 넣어도 내용을 다 이해하고 요약해 줍니다. (가장 큰 강점).', '자동 퀴즈 생성: 자료를 읽고 AI가 예상 시험 문제를 만들어주므로, 시험 기간에 셀프 테스트하기 좋습니다.', '웹 검색: 파일을 올리지 않아도 "양자역학에 대해 알려줘"라고 하면 웹을 검색해서 요약해 줍니다 (Perplexity 유사).', '접근성: 난독증이나 ADHD가 있는 사용자에게 긴 줄글을 요약해 주거나 음성으로 읽어주는 기능이 유용합니다.'],
    cons = ARRAY['유료 필수: 완전 무료 플랜이 없고 체험판만 있어서 카드 등록이 필수입니다.', '한국어 정확도: 영상 음성 인식(STT)의 경우 한국어 발음이 부정확하면 오타가 날 수 있습니다.'],
    key_features = '[{"name": "Video/Audio Summarizer", "description": "영상/음성 파일을 텍스트 노트로 변환"}, {"name": "Smart Notes", "description": "업로드된 자료의 핵심 내용 구조화 요약"}, {"name": "Flashcard Generator", "description": "중요 개념을 빈칸 채우기나 카드로 생성"}, {"name": "Quiz Maker", "description": "객관식/주관식 예상 문제 생성"}, {"name": "Web Search", "description": "인터넷 검색 기반 답변 (파일 없이도 가능)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 녹음 러너", "reason": "교수님 강의를 녹음만 해두고 다시 듣기 귀찮아서 방치하는 분."}, {"target": "✅ 시험 벼락치기", "reason": "교재 100페이지를 읽을 시간이 없어서 핵심만 3페이지로 요약받고 싶은 분."}, {"target": "✅ 영상 학습", "reason": "유튜브 강의로 공부하는데 필기하기 귀찮은 분."}], "not_recommended": [{"target": "❌ 무료 선호", "reason": "돈 안 드는 툴을 찾는다면 클로바노트(녹음)나 ChatPDF(문서)를 조합해서 쓰는 게 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['구독 해지: 4일 체험은 정말 짧습니다. 써보고 아니다 싶으면 바로 해지해야 결제를 막을 수 있습니다.', '저작권: 전공 서적을 통째로 스캔해서 올리는 건 개인 공부용으로는 괜찮지만, 요약본을 공유/판매하면 저작권 위반 소지가 있습니다.'],
    privacy_info = '{"description": "데이터 저장: 업로드한 파일은 개인 라이브러리에 저장되며, 계정 삭제 시 함께 파기됩니다."}'::jsonb,
    alternatives = '[{"name": "NotebookLM", "description": "구글의 무료 도구로, 기능은 비슷하면서(오디오, 퀴즈, 요약) 완전 무료입니다. (강력 추천 대체재)"}, {"name": "ChatPDF", "description": "PDF 문서 분석에만 집중하고 싶다면"}]'::jsonb,
    media_info = '[{"title": "Mindgrasp AI: The Ultimate Study Tool", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS App"], "target_audience": "수업 내용을 필기하기 귀찮은 대학생, ADHD가 있어 긴 글 읽기가 힘든 학습자"}'::jsonb,
    features = ARRAY['Video/Audio Summarizer', 'Smart Notes', 'Flashcard Generator', 'Quiz Maker', 'Web Search']
WHERE name = 'Mindgrasp';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Mindgrasp', '강의 영상, PDF, PPT 파일을 업로드하면 AI가 내용을 분석해 요약 노트, 플래시카드, 퀴즈를 자동으로 생성해 주는 ''학습 자료 제작기''.', 'https://mindgrasp.ai/',
    'Subscription (구독형)', '월 $6.99 (Basic / 연 결제 시) ~ $9.99 (Scholar).', '4일 무료 체험(Trial) 제공. 체험 기간 종료 후 자동 결제되므로 주의 필요.',
    '[{"plan": "Basic", "target": "가벼운 학습", "features": "월 제한적 업로드, 기본 요약", "price": "$6.99/월"}, {"plan": "Scholar", "target": "대학생", "features": "무제한 업로드, 퀴즈/플래시카드 생성, 웹 검색", "price": "$9.99/월"}, {"plan": "Premium", "target": "헤비 유저", "features": "여러 파일 동시 분석, 최우선 지원", "price": "$14.99/월"}]'::jsonb, ARRAY['멀티모달 소스: 텍스트뿐만 아니라 유튜브 링크, 강의 녹음 파일(MP3), 줌 영상을 넣어도 내용을 다 이해하고 요약해 줍니다. (가장 큰 강점).', '자동 퀴즈 생성: 자료를 읽고 AI가 예상 시험 문제를 만들어주므로, 시험 기간에 셀프 테스트하기 좋습니다.', '웹 검색: 파일을 올리지 않아도 "양자역학에 대해 알려줘"라고 하면 웹을 검색해서 요약해 줍니다 (Perplexity 유사).', '접근성: 난독증이나 ADHD가 있는 사용자에게 긴 줄글을 요약해 주거나 음성으로 읽어주는 기능이 유용합니다.'], ARRAY['유료 필수: 완전 무료 플랜이 없고 체험판만 있어서 카드 등록이 필수입니다.', '한국어 정확도: 영상 음성 인식(STT)의 경우 한국어 발음이 부정확하면 오타가 날 수 있습니다.'], '[{"name": "Video/Audio Summarizer", "description": "영상/음성 파일을 텍스트 노트로 변환"}, {"name": "Smart Notes", "description": "업로드된 자료의 핵심 내용 구조화 요약"}, {"name": "Flashcard Generator", "description": "중요 개념을 빈칸 채우기나 카드로 생성"}, {"name": "Quiz Maker", "description": "객관식/주관식 예상 문제 생성"}, {"name": "Web Search", "description": "인터넷 검색 기반 답변 (파일 없이도 가능)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 녹음 러너", "reason": "교수님 강의를 녹음만 해두고 다시 듣기 귀찮아서 방치하는 분."}, {"target": "✅ 시험 벼락치기", "reason": "교재 100페이지를 읽을 시간이 없어서 핵심만 3페이지로 요약받고 싶은 분."}, {"target": "✅ 영상 학습", "reason": "유튜브 강의로 공부하는데 필기하기 귀찮은 분."}], "not_recommended": [{"target": "❌ 무료 선호", "reason": "돈 안 드는 툴을 찾는다면 클로바노트(녹음)나 ChatPDF(문서)를 조합해서 쓰는 게 낫습니다."}]}'::jsonb, ARRAY['구독 해지: 4일 체험은 정말 짧습니다. 써보고 아니다 싶으면 바로 해지해야 결제를 막을 수 있습니다.', '저작권: 전공 서적을 통째로 스캔해서 올리는 건 개인 공부용으로는 괜찮지만, 요약본을 공유/판매하면 저작권 위반 소지가 있습니다.'], '{"description": "데이터 저장: 업로드한 파일은 개인 라이브러리에 저장되며, 계정 삭제 시 함께 파기됩니다."}'::jsonb,
    '[{"name": "NotebookLM", "description": "구글의 무료 도구로, 기능은 비슷하면서(오디오, 퀴즈, 요약) 완전 무료입니다. (강력 추천 대체재)"}, {"name": "ChatPDF", "description": "PDF 문서 분석에만 집중하고 싶다면"}]'::jsonb, '[{"title": "Mindgrasp AI: The Ultimate Study Tool", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS App"], "target_audience": "수업 내용을 필기하기 귀찮은 대학생, ADHD가 있어 긴 글 읽기가 힘든 학습자"}'::jsonb,
    ARRAY['Video/Audio Summarizer', 'Smart Notes', 'Flashcard Generator', 'Quiz Maker', 'Web Search'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Mindgrasp');

UPDATE ai_models SET
    description = '"이거 되면 저거 해" — 앱과 앱을 구슬 꿰듯이 시각적으로 연결하여 복잡한 업무 프로세스를 자동화하는 노코드(No-code) 플랫폼.',
    website_url = 'https://www.make.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $9 (Core / 연간 결제 시).',
    free_tier_note = '월 1,000 Ops(작업 단위) 무료. 시나리오 개수 제한 없음. Zapier와 달리 무료에서도 다단계(Multi-step) 시나리오 생성 가능.',
    pricing_plans = '[{"plan": "Free", "target": "개인/테스트", "features": "1,000 Ops/월, 복잡한 시나리오 가능, 간격 15분", "price": "무료"}, {"plan": "Core", "target": "개인 사업자", "features": "10,000 Ops/월, 실행 간격 1분, 무제한 시나리오", "price": "$9/월"}, {"plan": "Pro", "target": "팀/기업", "features": "우선 처리, 사용자 권한 관리, 시나리오 변수 저장", "price": "$16/월"}, {"plan": "Teams", "target": "조직", "features": "팀 역할 관리, 시나리오 실행 기록 보관 연장", "price": "$29/월"}]'::jsonb,
    pros = ARRAY['시각적 편집: 동그라미(노드)를 드래그해서 연결하는 방식이라 흐름이 한눈에 보입니다. (Zapier보다 훨씬 직관적).', 'AI Assistant: 시나리오를 짤 때 "구글 폼 들어오면 슬랙 보내줘"라고 AI에게 말하면 초안을 만들어줍니다.', '가성비: 경쟁사인 Zapier 대비 같은 가격에 훨씬 많은 작업량(Ops)을 제공합니다. 무료 플랜 혜택도 더 좋습니다.', '복잡한 로직: 조건문(If), 반복문(Iterator), 데이터 가공(JSON parsing) 등 개발자에 준하는 정교한 자동화가 가능합니다.'],
    cons = ARRAY['러닝 커브: 기능이 강력한 만큼 Zapier보다 배우는 데 시간이 좀 더 걸립니다. (변수 매핑 등 이해 필요).', 'Ops 계산: 시나리오가 한 번 돌 때 여러 개의 Ops(노드 실행 횟수)를 소모하므로, 잘못 짜면 무료 크레딧이 순삭될 수 있습니다.'],
    key_features = '[{"name": "Scenario Builder", "description": "무한 캔버스에서 노드를 연결해 자동화 설계"}, {"name": "AI Assistant", "description": "자연어로 시나리오 구조 자동 생성"}, {"name": "Router/Filter", "description": "조건에 따라 흐름 분기 (예: VIP 고객이면 A, 아니면 B)"}, {"name": "Data Store", "description": "엑셀 없이 Make 내부에 간단한 데이터 저장"}, {"name": "Error Handling", "description": "에러 발생 시 재시도하거나 알림을 보내는 안전장치"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 마케터", "reason": "페이스북 리드 → 구글 시트 저장 → 문자 발송 자동화."}, {"target": "✅ 쇼핑몰", "reason": "주문 들어오면 배송팀 슬랙 알림 + 고객에게 카톡 발송."}, {"target": "✅ 비용 절감", "reason": "Zapier가 너무 비싸서 갈아탈 곳을 찾는 분."}], "not_recommended": [{"target": "❌ 초간단 연결", "reason": "단순히 \"A 하면 B\" 정도의 초보적인 연결만 필요하다면 IFTTT나 Zapier가 더 쉽습니다."}, {"target": "❌ 한국어 필수", "reason": "UI가 전부 영어라 영어 울렁증이 심하면 쓰기 어렵습니다."}]}'::jsonb,
    usage_tips = ARRAY['Ops 낭비: 테스트할 때는 데이터를 1개만 넣어서 돌리세요. 1000개 데이터를 한 번에 테스트하면 무료 크레딧이 1초 만에 사라집니다.', '트리거 설정: ''Watch Rows'' 같은 트리거는 주기적으로 실행되므로, 데이터가 없어도 실행 횟수를 잡아먹을 수 있습니다. (Webhook 방식 권장).'],
    privacy_info = '{"description": "보안: 유럽(EU) 기반 기업으로 GDPR을 준수하며, ISO 27001 보안 인증을 보유하고 있습니다."}'::jsonb,
    alternatives = '[{"name": "Zapier", "description": "더 비싸지만 미국 앱 연동이 가장 많고 쉬움"}, {"name": "n8n", "description": "개발자라면 내 서버에 설치해서 공짜로 쓸 수 있는 도구"}]'::jsonb,
    media_info = '[{"title": "What is Make?", "url": "https://www.youtube.com/watch?v= (공식 채널)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web (브라우저 기반)"], "target_audience": "마케터, 개발자, 반복 업무를 자동화하고 싶은 모든 직장인"}'::jsonb,
    features = ARRAY['Scenario Builder', 'AI Assistant', 'Router/Filter', 'Data Store', 'Error Handling']
WHERE name = 'Make';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Make', '"이거 되면 저거 해" — 앱과 앱을 구슬 꿰듯이 시각적으로 연결하여 복잡한 업무 프로세스를 자동화하는 노코드(No-code) 플랫폼.', 'https://www.make.com/',
    'Freemium (무료 + 유료 구독)', '월 $9 (Core / 연간 결제 시).', '월 1,000 Ops(작업 단위) 무료. 시나리오 개수 제한 없음. Zapier와 달리 무료에서도 다단계(Multi-step) 시나리오 생성 가능.',
    '[{"plan": "Free", "target": "개인/테스트", "features": "1,000 Ops/월, 복잡한 시나리오 가능, 간격 15분", "price": "무료"}, {"plan": "Core", "target": "개인 사업자", "features": "10,000 Ops/월, 실행 간격 1분, 무제한 시나리오", "price": "$9/월"}, {"plan": "Pro", "target": "팀/기업", "features": "우선 처리, 사용자 권한 관리, 시나리오 변수 저장", "price": "$16/월"}, {"plan": "Teams", "target": "조직", "features": "팀 역할 관리, 시나리오 실행 기록 보관 연장", "price": "$29/월"}]'::jsonb, ARRAY['시각적 편집: 동그라미(노드)를 드래그해서 연결하는 방식이라 흐름이 한눈에 보입니다. (Zapier보다 훨씬 직관적).', 'AI Assistant: 시나리오를 짤 때 "구글 폼 들어오면 슬랙 보내줘"라고 AI에게 말하면 초안을 만들어줍니다.', '가성비: 경쟁사인 Zapier 대비 같은 가격에 훨씬 많은 작업량(Ops)을 제공합니다. 무료 플랜 혜택도 더 좋습니다.', '복잡한 로직: 조건문(If), 반복문(Iterator), 데이터 가공(JSON parsing) 등 개발자에 준하는 정교한 자동화가 가능합니다.'], ARRAY['러닝 커브: 기능이 강력한 만큼 Zapier보다 배우는 데 시간이 좀 더 걸립니다. (변수 매핑 등 이해 필요).', 'Ops 계산: 시나리오가 한 번 돌 때 여러 개의 Ops(노드 실행 횟수)를 소모하므로, 잘못 짜면 무료 크레딧이 순삭될 수 있습니다.'], '[{"name": "Scenario Builder", "description": "무한 캔버스에서 노드를 연결해 자동화 설계"}, {"name": "AI Assistant", "description": "자연어로 시나리오 구조 자동 생성"}, {"name": "Router/Filter", "description": "조건에 따라 흐름 분기 (예: VIP 고객이면 A, 아니면 B)"}, {"name": "Data Store", "description": "엑셀 없이 Make 내부에 간단한 데이터 저장"}, {"name": "Error Handling", "description": "에러 발생 시 재시도하거나 알림을 보내는 안전장치"}]'::jsonb,
    '{"recommended": [{"target": "✅ 마케터", "reason": "페이스북 리드 → 구글 시트 저장 → 문자 발송 자동화."}, {"target": "✅ 쇼핑몰", "reason": "주문 들어오면 배송팀 슬랙 알림 + 고객에게 카톡 발송."}, {"target": "✅ 비용 절감", "reason": "Zapier가 너무 비싸서 갈아탈 곳을 찾는 분."}], "not_recommended": [{"target": "❌ 초간단 연결", "reason": "단순히 \"A 하면 B\" 정도의 초보적인 연결만 필요하다면 IFTTT나 Zapier가 더 쉽습니다."}, {"target": "❌ 한국어 필수", "reason": "UI가 전부 영어라 영어 울렁증이 심하면 쓰기 어렵습니다."}]}'::jsonb, ARRAY['Ops 낭비: 테스트할 때는 데이터를 1개만 넣어서 돌리세요. 1000개 데이터를 한 번에 테스트하면 무료 크레딧이 1초 만에 사라집니다.', '트리거 설정: ''Watch Rows'' 같은 트리거는 주기적으로 실행되므로, 데이터가 없어도 실행 횟수를 잡아먹을 수 있습니다. (Webhook 방식 권장).'], '{"description": "보안: 유럽(EU) 기반 기업으로 GDPR을 준수하며, ISO 27001 보안 인증을 보유하고 있습니다."}'::jsonb,
    '[{"name": "Zapier", "description": "더 비싸지만 미국 앱 연동이 가장 많고 쉬움"}, {"name": "n8n", "description": "개발자라면 내 서버에 설치해서 공짜로 쓸 수 있는 도구"}]'::jsonb, '[{"title": "What is Make?", "url": "https://www.youtube.com/watch?v= (공식 채널)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web (브라우저 기반)"], "target_audience": "마케터, 개발자, 반복 업무를 자동화하고 싶은 모든 직장인"}'::jsonb,
    ARRAY['Scenario Builder', 'AI Assistant', 'Router/Filter', 'Data Store', 'Error Handling'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Make');

UPDATE ai_models SET
    description = 'LLM 앱을 개발하는 엔지니어를 위한 IDE로, 여러 AI 모델(GPT, Claude 등)을 비교 테스트하고 프롬프트를 관리하며 배포까지 돕는 개발 툴.',
    website_url = 'https://www.vellum.ai/',
    pricing_model = 'Paid Only (유료 전용, 데모 요청 가능)',
    pricing_info = '스타트업 플랜 기준 월 수백 달러 수준 (공개된 정가보다 맞춤형 견적 위주).',
    free_tier_note = '일반적인 무료 가입은 제한적이며, 주로 데모 요청(Book a Demo)을 통해 기업 계약으로 진행됨.',
    pricing_plans = '[{"plan": "Starter", "target": "초기 팀", "features": "모델 비교, 프롬프트 버전 관리, 기본 API", "price": "별도 문의"}, {"plan": "Growth", "target": "성장기 기업", "features": "대량 테스트(Batch Testing), 협업 기능", "price": "별도 문의"}, {"plan": "Enterprise", "target": "대기업", "features": "보안(SSO), 전용 클라우드, SLA 보장", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['모델 비교(Playground): 같은 프롬프트를 GPT-4, Claude 3.5, Gemini에 동시에 던져서 누가 더 답변을 잘하는지 한눈에 비교할 수 있습니다. (비용/속도/퀄리티 비교).', '버전 관리: 코드를 Git으로 관리하듯, 프롬프트 수정 내역을 버전별로 저장하고 롤백할 수 있습니다.', '평가(Evaluation): 수백 개의 테스트 케이스를 돌려서 "이 프롬프트가 정답률이 90%다"라는 것을 정량적으로 검증해 줍니다.', '통합 API: 모델을 바꿔도 코드를 뜯어고칠 필요 없이 Vellum Proxy API 하나만 호출하면 됩니다.'],
    cons = ARRAY['비개발자 비추: 일반인이 챗봇처럼 쓰는 툴이 아니라, ''AI 앱을 만드는 사람''을 위한 툴입니다.', '가격: 개인 개발자가 취미로 쓰기엔 가격대가 높고 접근성이 낮습니다.'],
    key_features = '[{"name": "Prompt Playground", "description": "다중 모델 병렬 테스트 환경"}, {"name": "Evaluations", "description": "AI 응답 품질 자동 채점 및 회귀 테스트"}, {"name": "Version Control", "description": "프롬프트 변경 이력 관리 및 배포"}, {"name": "Workflows", "description": "RAG(검색 증강 생성) 파이프라인 구축 지원"}, {"name": "Proxy API", "description": "단일 인터페이스로 여러 LLM 제공사 연결"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ AI 스타트업", "reason": "\"우리 서비스에 GPT-4 쓸지 Claude 쓸지 고민이다\" 하는 개발팀."}, {"target": "✅ 프롬프트 엔지니어", "reason": "프롬프트 조금 고쳤을 때 성능이 얼마나 좋아졌는지 수치로 증명해야 하는 분."}, {"target": "✅ 비용 최적화", "reason": "퀄리티는 유지하면서 더 싼 모델로 갈아타고 싶은 팀."}], "not_recommended": [{"target": "❌ 일반 사용자", "reason": "그냥 AI랑 대화하고 싶다면 ChatGPT나 Claude를 쓰세요."}, {"target": "❌ 문서 작성", "reason": "전자책 저작 툴인 ''Vellum(맥용)''과 이름이 같으니 혼동하지 마세요. 이건 AI 개발 툴입니다."}]}'::jsonb,
    usage_tips = ARRAY['이름 혼동: 구글에 Vellum 치면 전자책 만드는 프로그램이 먼저 나올 수 있습니다. 반드시 Vellum.ai인지 확인하세요.', 'API 키: Vellum을 쓰려면 OpenAI나 Anthropic의 API 키를 내 계정에서 가져와서 연동해야 할 수 있습니다 (BYOK - Bring Your Own Key).'],
    privacy_info = '{"description": "데이터 보안: 고객의 데이터를 모델 학습에 사용하지 않으며, SOC 2 Type II 인증을 획득했습니다."}'::jsonb,
    alternatives = '[{"name": "LangSmith (LangChain)", "description": "개발자에게 더 익숙한 오픈소스 기반의 LLM 모니터링/테스트 도구"}, {"name": "PromptLayer", "description": "프롬프트 관리 및 로그 추적에 특화된 툴"}]'::jsonb,
    media_info = '[{"title": "Vellum.ai Product Demo", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "AI 프로덕트를 만드는 개발자, 프롬프트 엔지니어, 스타트업 CTO"}'::jsonb,
    features = ARRAY['Prompt Playground', 'Evaluations', 'Version Control', 'Workflows', 'Proxy API']
WHERE name = 'Vellum';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Vellum', 'LLM 앱을 개발하는 엔지니어를 위한 IDE로, 여러 AI 모델(GPT, Claude 등)을 비교 테스트하고 프롬프트를 관리하며 배포까지 돕는 개발 툴.', 'https://www.vellum.ai/',
    'Paid Only (유료 전용, 데모 요청 가능)', '스타트업 플랜 기준 월 수백 달러 수준 (공개된 정가보다 맞춤형 견적 위주).', '일반적인 무료 가입은 제한적이며, 주로 데모 요청(Book a Demo)을 통해 기업 계약으로 진행됨.',
    '[{"plan": "Starter", "target": "초기 팀", "features": "모델 비교, 프롬프트 버전 관리, 기본 API", "price": "별도 문의"}, {"plan": "Growth", "target": "성장기 기업", "features": "대량 테스트(Batch Testing), 협업 기능", "price": "별도 문의"}, {"plan": "Enterprise", "target": "대기업", "features": "보안(SSO), 전용 클라우드, SLA 보장", "price": "별도 문의"}]'::jsonb, ARRAY['모델 비교(Playground): 같은 프롬프트를 GPT-4, Claude 3.5, Gemini에 동시에 던져서 누가 더 답변을 잘하는지 한눈에 비교할 수 있습니다. (비용/속도/퀄리티 비교).', '버전 관리: 코드를 Git으로 관리하듯, 프롬프트 수정 내역을 버전별로 저장하고 롤백할 수 있습니다.', '평가(Evaluation): 수백 개의 테스트 케이스를 돌려서 "이 프롬프트가 정답률이 90%다"라는 것을 정량적으로 검증해 줍니다.', '통합 API: 모델을 바꿔도 코드를 뜯어고칠 필요 없이 Vellum Proxy API 하나만 호출하면 됩니다.'], ARRAY['비개발자 비추: 일반인이 챗봇처럼 쓰는 툴이 아니라, ''AI 앱을 만드는 사람''을 위한 툴입니다.', '가격: 개인 개발자가 취미로 쓰기엔 가격대가 높고 접근성이 낮습니다.'], '[{"name": "Prompt Playground", "description": "다중 모델 병렬 테스트 환경"}, {"name": "Evaluations", "description": "AI 응답 품질 자동 채점 및 회귀 테스트"}, {"name": "Version Control", "description": "프롬프트 변경 이력 관리 및 배포"}, {"name": "Workflows", "description": "RAG(검색 증강 생성) 파이프라인 구축 지원"}, {"name": "Proxy API", "description": "단일 인터페이스로 여러 LLM 제공사 연결"}]'::jsonb,
    '{"recommended": [{"target": "✅ AI 스타트업", "reason": "\"우리 서비스에 GPT-4 쓸지 Claude 쓸지 고민이다\" 하는 개발팀."}, {"target": "✅ 프롬프트 엔지니어", "reason": "프롬프트 조금 고쳤을 때 성능이 얼마나 좋아졌는지 수치로 증명해야 하는 분."}, {"target": "✅ 비용 최적화", "reason": "퀄리티는 유지하면서 더 싼 모델로 갈아타고 싶은 팀."}], "not_recommended": [{"target": "❌ 일반 사용자", "reason": "그냥 AI랑 대화하고 싶다면 ChatGPT나 Claude를 쓰세요."}, {"target": "❌ 문서 작성", "reason": "전자책 저작 툴인 ''Vellum(맥용)''과 이름이 같으니 혼동하지 마세요. 이건 AI 개발 툴입니다."}]}'::jsonb, ARRAY['이름 혼동: 구글에 Vellum 치면 전자책 만드는 프로그램이 먼저 나올 수 있습니다. 반드시 Vellum.ai인지 확인하세요.', 'API 키: Vellum을 쓰려면 OpenAI나 Anthropic의 API 키를 내 계정에서 가져와서 연동해야 할 수 있습니다 (BYOK - Bring Your Own Key).'], '{"description": "데이터 보안: 고객의 데이터를 모델 학습에 사용하지 않으며, SOC 2 Type II 인증을 획득했습니다."}'::jsonb,
    '[{"name": "LangSmith (LangChain)", "description": "개발자에게 더 익숙한 오픈소스 기반의 LLM 모니터링/테스트 도구"}, {"name": "PromptLayer", "description": "프롬프트 관리 및 로그 추적에 특화된 툴"}]'::jsonb, '[{"title": "Vellum.ai Product Demo", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "AI 프로덕트를 만드는 개발자, 프롬프트 엔지니어, 스타트업 CTO"}'::jsonb,
    ARRAY['Prompt Playground', 'Evaluations', 'Version Control', 'Workflows', 'Proxy API'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Vellum');

UPDATE ai_models SET
    description = '단순히 받아쓰기만 하는 게 아니라, 내가 쓴 메모를 바탕으로 AI가 살을 붙여 완벽한 회의록을 완성해 주는 ''인간 주도형'' AI 미팅 노트.',
    website_url = 'https://granola.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10 (Pro / 연간 결제 시).',
    free_tier_note = '월 5회 회의 녹음 및 노트 생성 무료. (횟수 제한 있음).',
    pricing_plans = '[{"plan": "Free", "target": "라이트 유저", "features": "월 5회 회의, 기본 템플릿", "price": "무료"}, {"plan": "Pro", "target": "직장인", "features": "무제한 회의, 커스텀 템플릿, 과거 회의 검색", "price": "$10/월"}, {"plan": "Team", "target": "조직", "features": "팀 템플릿 공유, 중앙 결제", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['Human-in-the-loop: AI가 100% 알아서 쓰는 게 아니라, 내가 회의 중에 끄적거린 핵심 키워드(Bullet point)를 AI가 인식해서 문장으로 다듬어줍니다. 훨씬 정확하고 내 의도가 반영됩니다.', '템플릿 커스텀: "인터뷰용", "스프린트 회의용", "투자 미팅용" 등 상황에 맞는 양식을 아주 디테일하게 설정할 수 있습니다.', '비봇(No-bot): 줌이나 구글 미트에 "녹음 봇"이 들어오지 않고, 내 맥북 시스템 오디오를 직접 녹음하므로 상대방에게 부담을 주지 않습니다.', '디자인: 앱 UI가 매우 예쁘고 직관적이라 쓸 맛이 납니다 (Notion 스타일).'],
    cons = ARRAY['맥 전용: 윈도우(Windows) 사용자는 쓸 수 없습니다. (치명적 단점).', '영어 최적화: 아직은 영어 회의에서 가장 성능이 좋고, 한국어 회의는 Otter나 클로바노트에 비해 인식률이 떨어질 수 있습니다.'],
    key_features = '[{"name": "Audio Recording", "description": "시스템 오디오 직접 녹음 (봇 참여 X)"}, {"name": "AI Enhancement", "description": "사용자 메모 + 녹음 내용을 결합해 회의록 완성"}, {"name": "Custom Templates", "description": "나만의 회의록 양식 생성 및 저장"}, {"name": "Shareable Links", "description": "완성된 노트를 링크나 텍스트로 공유"}, {"name": "Smart Formatting", "description": "할 일(To-do), 결정 사항 자동 추출"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 프로덕트 매니저(PM)", "reason": "회의록의 퀄리티와 구조가 중요한 분."}, {"target": "✅ 맥북 유저", "reason": "맥 환경에서 가볍게 돌아가는 네이티브 앱을 선호하는 분."}, {"target": "✅ 녹음 봇 혐오", "reason": "회의실에 \"Recording...\" 알림 뜨는 게 싫은 분."}], "not_recommended": [{"target": "❌ 윈도우 유저", "reason": "설치 불가입니다."}, {"target": "❌ 완전 자동화", "reason": "\"난 손 하나 까딱 안 하고 AI가 다 받아적었으면 좋겠어\" 하는 분은 Otter가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['이어폰 필수: 스피커로 들으면서 녹음하면 하울링이 생길 수 있으니, 되도록 이어폰을 끼고 회의하세요. (시스템 내부 소리와 마이크 소리를 합쳐서 녹음함).', '메모 습관: Granola의 핵심은 "내가 대충 적으면 AI가 잘 정리해 준다"입니다. 아예 아무것도 안 적으면 퀄리티가 낮아질 수 있습니다.'],
    privacy_info = '{"description": "로컬 중심: 녹음 데이터 처리가 사용자 기기 중심으로 이루어지며, 봇이 참여하지 않아 프라이버시 침해 우려가 적습니다."}'::jsonb,
    alternatives = '[{"name": "Otter.ai", "description": "봇이 들어와서 자동으로 받아적어주는 툴 (윈도우 가능)"}, {"name": "Supernormal", "description": "구글 미트/줌 확장 프로그램으로 작동하는 자동 회의록"}]'::jsonb,
    media_info = '[{"title": "Granola: The notepad that listens", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["macOS (Mac 전용 앱)"], "target_audience": "줌/미트 회의가 많은 PM, 디자이너, 세심한 회의록이 필요한 맥 사용자"}'::jsonb,
    features = ARRAY['Audio Recording', 'AI Enhancement', 'Custom Templates', 'Shareable Links', 'Smart Formatting']
WHERE name = 'Granola';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Granola', '단순히 받아쓰기만 하는 게 아니라, 내가 쓴 메모를 바탕으로 AI가 살을 붙여 완벽한 회의록을 완성해 주는 ''인간 주도형'' AI 미팅 노트.', 'https://granola.ai/',
    'Freemium (무료 + 유료 구독)', '월 $10 (Pro / 연간 결제 시).', '월 5회 회의 녹음 및 노트 생성 무료. (횟수 제한 있음).',
    '[{"plan": "Free", "target": "라이트 유저", "features": "월 5회 회의, 기본 템플릿", "price": "무료"}, {"plan": "Pro", "target": "직장인", "features": "무제한 회의, 커스텀 템플릿, 과거 회의 검색", "price": "$10/월"}, {"plan": "Team", "target": "조직", "features": "팀 템플릿 공유, 중앙 결제", "price": "별도 문의"}]'::jsonb, ARRAY['Human-in-the-loop: AI가 100% 알아서 쓰는 게 아니라, 내가 회의 중에 끄적거린 핵심 키워드(Bullet point)를 AI가 인식해서 문장으로 다듬어줍니다. 훨씬 정확하고 내 의도가 반영됩니다.', '템플릿 커스텀: "인터뷰용", "스프린트 회의용", "투자 미팅용" 등 상황에 맞는 양식을 아주 디테일하게 설정할 수 있습니다.', '비봇(No-bot): 줌이나 구글 미트에 "녹음 봇"이 들어오지 않고, 내 맥북 시스템 오디오를 직접 녹음하므로 상대방에게 부담을 주지 않습니다.', '디자인: 앱 UI가 매우 예쁘고 직관적이라 쓸 맛이 납니다 (Notion 스타일).'], ARRAY['맥 전용: 윈도우(Windows) 사용자는 쓸 수 없습니다. (치명적 단점).', '영어 최적화: 아직은 영어 회의에서 가장 성능이 좋고, 한국어 회의는 Otter나 클로바노트에 비해 인식률이 떨어질 수 있습니다.'], '[{"name": "Audio Recording", "description": "시스템 오디오 직접 녹음 (봇 참여 X)"}, {"name": "AI Enhancement", "description": "사용자 메모 + 녹음 내용을 결합해 회의록 완성"}, {"name": "Custom Templates", "description": "나만의 회의록 양식 생성 및 저장"}, {"name": "Shareable Links", "description": "완성된 노트를 링크나 텍스트로 공유"}, {"name": "Smart Formatting", "description": "할 일(To-do), 결정 사항 자동 추출"}]'::jsonb,
    '{"recommended": [{"target": "✅ 프로덕트 매니저(PM)", "reason": "회의록의 퀄리티와 구조가 중요한 분."}, {"target": "✅ 맥북 유저", "reason": "맥 환경에서 가볍게 돌아가는 네이티브 앱을 선호하는 분."}, {"target": "✅ 녹음 봇 혐오", "reason": "회의실에 \"Recording...\" 알림 뜨는 게 싫은 분."}], "not_recommended": [{"target": "❌ 윈도우 유저", "reason": "설치 불가입니다."}, {"target": "❌ 완전 자동화", "reason": "\"난 손 하나 까딱 안 하고 AI가 다 받아적었으면 좋겠어\" 하는 분은 Otter가 낫습니다."}]}'::jsonb, ARRAY['이어폰 필수: 스피커로 들으면서 녹음하면 하울링이 생길 수 있으니, 되도록 이어폰을 끼고 회의하세요. (시스템 내부 소리와 마이크 소리를 합쳐서 녹음함).', '메모 습관: Granola의 핵심은 "내가 대충 적으면 AI가 잘 정리해 준다"입니다. 아예 아무것도 안 적으면 퀄리티가 낮아질 수 있습니다.'], '{"description": "로컬 중심: 녹음 데이터 처리가 사용자 기기 중심으로 이루어지며, 봇이 참여하지 않아 프라이버시 침해 우려가 적습니다."}'::jsonb,
    '[{"name": "Otter.ai", "description": "봇이 들어와서 자동으로 받아적어주는 툴 (윈도우 가능)"}, {"name": "Supernormal", "description": "구글 미트/줌 확장 프로그램으로 작동하는 자동 회의록"}]'::jsonb, '[{"title": "Granola: The notepad that listens", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["macOS (Mac 전용 앱)"], "target_audience": "줌/미트 회의가 많은 PM, 디자이너, 세심한 회의록이 필요한 맥 사용자"}'::jsonb,
    ARRAY['Audio Recording', 'AI Enhancement', 'Custom Templates', 'Shareable Links', 'Smart Formatting'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Granola');

UPDATE ai_models SET
    description = '줌, 구글 미트, 팀즈 회의에 가상 비서(OtterPilot)를 보내 자동으로 대화를 받아 적고, 요약하고, 질문까지 받아주는 원조 AI 회의록 서비스.',
    website_url = 'https://otter.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10 (Pro / 연간 결제 시) ~ $20 (Business).',
    free_tier_note = '월 300분 녹음 무료. 회의당 최대 30분까지만 녹음 가능. (과거보다 혜택이 줄어듦).',
    pricing_plans = '[{"plan": "Basic", "target": "개인/학생", "features": "300분/월, 회의당 30분, 실시간 스크립트", "price": "무료"}, {"plan": "Pro", "target": "직장인", "features": "1,200분/월, 회의당 90분, 고급 검색, 사용자 사전", "price": "$10/월"}, {"plan": "Business", "target": "팀", "features": "6,000분/월, 회의당 4시간, 팀 용어집, 관리자 기능", "price": "$20/인/월"}]'::jsonb,
    pros = ARRAY['OtterPilot: 내 캘린더랑 연동해두면, 회의 시간에 맞춰 알아서 줌(Zoom) 링크를 타고 들어와 녹음하고 나갑니다. (지각하거나 불참해도 회의록 확보 가능).', 'Otter Chat: 회의 도중에 "오터야, 방금 마케팅 팀장이 뭐라고 했지?"라고 채팅으로 물어보면 답해줍니다. (실시간 Q&A).', '스크립트 동기화: 녹음된 오디오와 텍스트가 하이라이트로 동기화되어, 텍스트를 클릭하면 그 부분 음성이 바로 재생됩니다.', '슬라이드 캡처: 화상 회의 중 화면에 PPT가 나오면 자동으로 스크린샷을 찍어 회의록 중간에 끼워 넣습니다.'],
    cons = ARRAY['영어 중심: 영어 인식률은 세계 최고 수준이지만, 한국어 회의에서는 클로바노트보다 성능이 떨어집니다.', '무료 제한: 무료 버전의 ''회의당 30분'' 제한은 꽤 빡빡해서, 1시간 회의를 하려면 중간에 끊깁니다.'],
    key_features = '[{"name": "OtterPilot", "description": "회의 자동 참여 및 녹기록 작성"}, {"name": "Real-time Transcript", "description": "실시간 음성-텍스트 변환 (영어 최적)"}, {"name": "Automated Summary", "description": "회의 종료 후 이메일로 요약본 발송"}, {"name": "Otter Chat", "description": "회의 내용 기반 AI 질의응답"}, {"name": "Slide Capture", "description": "공유된 화면(PPT 등) 자동 캡처 및 삽입"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 글로벌 미팅", "reason": "영어 회의 내용을 놓칠까 봐 불안한 분 (실시간 자막처럼 활용)."}, {"target": "✅ 더블 부킹", "reason": "같은 시간에 회의가 2개 겹쳤을 때, 오터 봇을 대신 보내서 기록을 남길 분."}, {"target": "✅ 유학생", "reason": "영어 강의를 녹음하고 텍스트로 복습하고 싶은 학생."}], "not_recommended": [{"target": "❌ 100% 한국어 회의", "reason": "한국말만 쓰는 회의라면 네이버 클로바노트나 Vrew가 훨씬 낫습니다."}, {"target": "❌ 보안 민감", "reason": "\"제3자(봇)\"가 회의에 들어오는 걸 극도로 꺼리는 보안 환경."}]}'::jsonb,
    usage_tips = ARRAY['봇 강퇴: 사전 예고 없이 오터 봇을 회의에 보내면, 다른 참석자들이 "이게 뭐지?" 하고 강퇴시키거나 불쾌해할 수 있습니다. 미리 양해를 구하세요.', '캘린더 연동: 구글/아웃룩 캘린더 연동을 해제하지 않으면, 원치 않는 개인적인 미팅(데이트 등)에도 오터가 따라들어올 수 있으니 설정을 확인하세요.'],
    privacy_info = '{"description": "학습: 기본적으로 데이터가 AI 학습에 활용될 수 있으나, 비즈니스 플랜 이상에서는 데이터 프라이버시 설정이 강화됩니다."}'::jsonb,
    alternatives = '[{"name": "Fireflies.ai", "description": "CRM 연동이나 분석 기능이 더 중요한 영업팀이라면"}, {"name": "Clova Note", "description": "한국어 인식률이 1순위라면"}]'::jsonb,
    media_info = '[{"title": "Meet OtterPilot: The AI Meeting Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Chrome Extension"], "target_audience": "영어 회의가 많은 직장인, 강의를 녹음하는 유학생, 인터뷰어"}'::jsonb,
    features = ARRAY['OtterPilot', 'Real-time Transcript', 'Automated Summary', 'Otter Chat', 'Slide Capture']
WHERE name = 'Otter.ai';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Otter.ai', '줌, 구글 미트, 팀즈 회의에 가상 비서(OtterPilot)를 보내 자동으로 대화를 받아 적고, 요약하고, 질문까지 받아주는 원조 AI 회의록 서비스.', 'https://otter.ai/',
    'Freemium (무료 + 유료 구독)', '월 $10 (Pro / 연간 결제 시) ~ $20 (Business).', '월 300분 녹음 무료. 회의당 최대 30분까지만 녹음 가능. (과거보다 혜택이 줄어듦).',
    '[{"plan": "Basic", "target": "개인/학생", "features": "300분/월, 회의당 30분, 실시간 스크립트", "price": "무료"}, {"plan": "Pro", "target": "직장인", "features": "1,200분/월, 회의당 90분, 고급 검색, 사용자 사전", "price": "$10/월"}, {"plan": "Business", "target": "팀", "features": "6,000분/월, 회의당 4시간, 팀 용어집, 관리자 기능", "price": "$20/인/월"}]'::jsonb, ARRAY['OtterPilot: 내 캘린더랑 연동해두면, 회의 시간에 맞춰 알아서 줌(Zoom) 링크를 타고 들어와 녹음하고 나갑니다. (지각하거나 불참해도 회의록 확보 가능).', 'Otter Chat: 회의 도중에 "오터야, 방금 마케팅 팀장이 뭐라고 했지?"라고 채팅으로 물어보면 답해줍니다. (실시간 Q&A).', '스크립트 동기화: 녹음된 오디오와 텍스트가 하이라이트로 동기화되어, 텍스트를 클릭하면 그 부분 음성이 바로 재생됩니다.', '슬라이드 캡처: 화상 회의 중 화면에 PPT가 나오면 자동으로 스크린샷을 찍어 회의록 중간에 끼워 넣습니다.'], ARRAY['영어 중심: 영어 인식률은 세계 최고 수준이지만, 한국어 회의에서는 클로바노트보다 성능이 떨어집니다.', '무료 제한: 무료 버전의 ''회의당 30분'' 제한은 꽤 빡빡해서, 1시간 회의를 하려면 중간에 끊깁니다.'], '[{"name": "OtterPilot", "description": "회의 자동 참여 및 녹기록 작성"}, {"name": "Real-time Transcript", "description": "실시간 음성-텍스트 변환 (영어 최적)"}, {"name": "Automated Summary", "description": "회의 종료 후 이메일로 요약본 발송"}, {"name": "Otter Chat", "description": "회의 내용 기반 AI 질의응답"}, {"name": "Slide Capture", "description": "공유된 화면(PPT 등) 자동 캡처 및 삽입"}]'::jsonb,
    '{"recommended": [{"target": "✅ 글로벌 미팅", "reason": "영어 회의 내용을 놓칠까 봐 불안한 분 (실시간 자막처럼 활용)."}, {"target": "✅ 더블 부킹", "reason": "같은 시간에 회의가 2개 겹쳤을 때, 오터 봇을 대신 보내서 기록을 남길 분."}, {"target": "✅ 유학생", "reason": "영어 강의를 녹음하고 텍스트로 복습하고 싶은 학생."}], "not_recommended": [{"target": "❌ 100% 한국어 회의", "reason": "한국말만 쓰는 회의라면 네이버 클로바노트나 Vrew가 훨씬 낫습니다."}, {"target": "❌ 보안 민감", "reason": "\"제3자(봇)\"가 회의에 들어오는 걸 극도로 꺼리는 보안 환경."}]}'::jsonb, ARRAY['봇 강퇴: 사전 예고 없이 오터 봇을 회의에 보내면, 다른 참석자들이 "이게 뭐지?" 하고 강퇴시키거나 불쾌해할 수 있습니다. 미리 양해를 구하세요.', '캘린더 연동: 구글/아웃룩 캘린더 연동을 해제하지 않으면, 원치 않는 개인적인 미팅(데이트 등)에도 오터가 따라들어올 수 있으니 설정을 확인하세요.'], '{"description": "학습: 기본적으로 데이터가 AI 학습에 활용될 수 있으나, 비즈니스 플랜 이상에서는 데이터 프라이버시 설정이 강화됩니다."}'::jsonb,
    '[{"name": "Fireflies.ai", "description": "CRM 연동이나 분석 기능이 더 중요한 영업팀이라면"}, {"name": "Clova Note", "description": "한국어 인식률이 1순위라면"}]'::jsonb, '[{"title": "Meet OtterPilot: The AI Meeting Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Chrome Extension"], "target_audience": "영어 회의가 많은 직장인, 강의를 녹음하는 유학생, 인터뷰어"}'::jsonb,
    ARRAY['OtterPilot', 'Real-time Transcript', 'Automated Summary', 'Otter Chat', 'Slide Capture'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Otter.ai');

UPDATE ai_models SET
    description = '"Fred"라는 이름의 AI 봇이 회의를 기록하고, 감정 분석, 발언 점유율 분석, CRM(세일즈포스 등) 자동 입력까지 해주는 영업/비즈니스 특화 회의 분석기.',
    website_url = 'https://fireflies.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10 (Pro / 연간 결제 시) ~ $19 (Business).',
    free_tier_note = '월 800분 녹음 무료 (꽤 넉넉함). 단, AI 요약(Super Summary) 및 CRM 연동 등 고급 기능은 제한됨. 저장 공간 제한 있음.',
    pricing_plans = '[{"plan": "Free", "target": "개인", "features": "800분/월, 기본 전사(Transcript), 검색", "price": "무료"}, {"plan": "Pro", "target": "소규모 팀", "features": "8,000분/월, AI 요약(Super Summary), 스마트 검색", "price": "$10/월"}, {"plan": "Business", "target": "영업팀", "features": "무제한 저장, 대화 분석(감정/발언비율), CRM 연동", "price": "$19/월"}]'::jsonb,
    pros = ARRAY['AskFred: 회의가 끝나고 "프레드, 김 부장님이 말한 예산 이슈가 뭐였지?"라고 물어보면 답해주고, 후속 이메일 초안까지 써줍니다.', 'Conversation Intelligence: "누가 말을 제일 많이 했나?", "긍정적인 단어를 많이 썼나, 부정적인가?" 같은 대화 분석 데이터를 시각적으로 보여줍니다. (관리자에게 유용).', 'CRM 연동: 세일즈포스, 허브스팟 등에 회의 내용을 자동으로 밀어 넣어줍니다. 영업사원이 일일이 입력할 필요가 없습니다.', 'Soundbites: 중요한 순간을 짧은 오디오 클립으로 잘라서 슬랙이나 노션으로 바로 공유할 수 있습니다.'],
    cons = ARRAY['비디오 미지원: Otter와 달리 기본적으로 오디오(음성) 중심입니다. 화상 회의 화면(비디오)을 녹화해서 보여주는 기능은 제한적일 수 있습니다.', '설정 복잡: 기능이 워낙 많아서(필터, 토픽 트래커 등) 처음 세팅하는 데 시간이 좀 걸립니다.'],
    key_features = '[{"name": "Fred Bot", "description": "모든 화상 회의 플랫폼 자동 참여 및 기록"}, {"name": "AI Super Summaries", "description": "회의 핵심, 액션 아이템, 타임라인 요약"}, {"name": "AskFred (GPT-4)", "description": "회의 내용 기반 챗봇 질의응답"}, {"name": "Sentiment Analysis", "description": "대화의 긍정/부정 감정 흐름 분석 (Business)"}, {"name": "Topic Tracker", "description": "특정 키워드(예: \"가격\", \"경쟁사\")가 언급된 횟수 추적"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 영업 팀장", "reason": "팀원들이 고객이랑 무슨 이야기를 했는지, 고객 반응(감정)은 어땠는지 데이터로 보고 싶은 분."}, {"target": "✅ 면접관", "reason": "지원자의 답변을 다시 들으며 평가하고, 핵심 발언만 클립으로 공유하고 싶은 분."}, {"target": "✅ CRM 사용자", "reason": "미팅 끝나고 CRM에 로그 남기는 게 세상에서 제일 귀찮은 영업사원."}], "not_recommended": [{"target": "❌ 단순 기록용", "reason": "복잡한 분석 필요 없이 그냥 글자만 적어주면 된다면 Otter나 클로바노트가 더 가볍습니다."}, {"target": "❌ 비디오 녹화 필수", "reason": "화면 공유 내용이 중요하다면 비디오 녹화 기능이 강한 툴(Fathom 등)을 찾으세요."}]}'::jsonb,
    usage_tips = ARRAY['무료 요약 제한: 무료 플랜은 녹음 시간은 넉넉하지만, 정작 중요한 ''AI 요약'' 기능에 횟수 제한이 있을 수 있습니다.', '알림 끄기: 오터와 마찬가지로, 상대방에게 "Fred가 회의를 기록 중입니다"라는 알림이 갈 수 있으니 사전에 설정이나 양해가 필요합니다.'],
    privacy_info = '{"description": "보안: SOC 2 Type II 및 GDPR을 준수하며, 데이터는 암호화되어 저장됩니다. 봇 이름(Fred)을 커스텀하여 덜 눈에 띄게 할 수도 있습니다(유료)."}'::jsonb,
    alternatives = '[{"name": "Otter.ai", "description": "좀 더 범용적이고 교육/개인 용도에 적합"}, {"name": "Gong.io", "description": "파이어플라이보다 더 비싸고 강력한 엔터프라이즈급 영업 분석 툴"}]'::jsonb,
    media_info = '[{"title": "Automate Meeting Notes with Fireflies.ai", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Integrations (Zoom", "Meet", "Teams", "Slack)"], "target_audience": "영업팀(Sales), 리크루터(면접), 고객 관리(CS) 팀"}'::jsonb,
    features = ARRAY['Fred Bot', 'AI Super Summaries', 'AskFred (GPT-4)', 'Sentiment Analysis', 'Topic Tracker']
WHERE name = 'Fireflies.ai';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Fireflies.ai', '"Fred"라는 이름의 AI 봇이 회의를 기록하고, 감정 분석, 발언 점유율 분석, CRM(세일즈포스 등) 자동 입력까지 해주는 영업/비즈니스 특화 회의 분석기.', 'https://fireflies.ai/',
    'Freemium (무료 + 유료 구독)', '월 $10 (Pro / 연간 결제 시) ~ $19 (Business).', '월 800분 녹음 무료 (꽤 넉넉함). 단, AI 요약(Super Summary) 및 CRM 연동 등 고급 기능은 제한됨. 저장 공간 제한 있음.',
    '[{"plan": "Free", "target": "개인", "features": "800분/월, 기본 전사(Transcript), 검색", "price": "무료"}, {"plan": "Pro", "target": "소규모 팀", "features": "8,000분/월, AI 요약(Super Summary), 스마트 검색", "price": "$10/월"}, {"plan": "Business", "target": "영업팀", "features": "무제한 저장, 대화 분석(감정/발언비율), CRM 연동", "price": "$19/월"}]'::jsonb, ARRAY['AskFred: 회의가 끝나고 "프레드, 김 부장님이 말한 예산 이슈가 뭐였지?"라고 물어보면 답해주고, 후속 이메일 초안까지 써줍니다.', 'Conversation Intelligence: "누가 말을 제일 많이 했나?", "긍정적인 단어를 많이 썼나, 부정적인가?" 같은 대화 분석 데이터를 시각적으로 보여줍니다. (관리자에게 유용).', 'CRM 연동: 세일즈포스, 허브스팟 등에 회의 내용을 자동으로 밀어 넣어줍니다. 영업사원이 일일이 입력할 필요가 없습니다.', 'Soundbites: 중요한 순간을 짧은 오디오 클립으로 잘라서 슬랙이나 노션으로 바로 공유할 수 있습니다.'], ARRAY['비디오 미지원: Otter와 달리 기본적으로 오디오(음성) 중심입니다. 화상 회의 화면(비디오)을 녹화해서 보여주는 기능은 제한적일 수 있습니다.', '설정 복잡: 기능이 워낙 많아서(필터, 토픽 트래커 등) 처음 세팅하는 데 시간이 좀 걸립니다.'], '[{"name": "Fred Bot", "description": "모든 화상 회의 플랫폼 자동 참여 및 기록"}, {"name": "AI Super Summaries", "description": "회의 핵심, 액션 아이템, 타임라인 요약"}, {"name": "AskFred (GPT-4)", "description": "회의 내용 기반 챗봇 질의응답"}, {"name": "Sentiment Analysis", "description": "대화의 긍정/부정 감정 흐름 분석 (Business)"}, {"name": "Topic Tracker", "description": "특정 키워드(예: \"가격\", \"경쟁사\")가 언급된 횟수 추적"}]'::jsonb,
    '{"recommended": [{"target": "✅ 영업 팀장", "reason": "팀원들이 고객이랑 무슨 이야기를 했는지, 고객 반응(감정)은 어땠는지 데이터로 보고 싶은 분."}, {"target": "✅ 면접관", "reason": "지원자의 답변을 다시 들으며 평가하고, 핵심 발언만 클립으로 공유하고 싶은 분."}, {"target": "✅ CRM 사용자", "reason": "미팅 끝나고 CRM에 로그 남기는 게 세상에서 제일 귀찮은 영업사원."}], "not_recommended": [{"target": "❌ 단순 기록용", "reason": "복잡한 분석 필요 없이 그냥 글자만 적어주면 된다면 Otter나 클로바노트가 더 가볍습니다."}, {"target": "❌ 비디오 녹화 필수", "reason": "화면 공유 내용이 중요하다면 비디오 녹화 기능이 강한 툴(Fathom 등)을 찾으세요."}]}'::jsonb, ARRAY['무료 요약 제한: 무료 플랜은 녹음 시간은 넉넉하지만, 정작 중요한 ''AI 요약'' 기능에 횟수 제한이 있을 수 있습니다.', '알림 끄기: 오터와 마찬가지로, 상대방에게 "Fred가 회의를 기록 중입니다"라는 알림이 갈 수 있으니 사전에 설정이나 양해가 필요합니다.'], '{"description": "보안: SOC 2 Type II 및 GDPR을 준수하며, 데이터는 암호화되어 저장됩니다. 봇 이름(Fred)을 커스텀하여 덜 눈에 띄게 할 수도 있습니다(유료)."}'::jsonb,
    '[{"name": "Otter.ai", "description": "좀 더 범용적이고 교육/개인 용도에 적합"}, {"name": "Gong.io", "description": "파이어플라이보다 더 비싸고 강력한 엔터프라이즈급 영업 분석 툴"}]'::jsonb, '[{"title": "Automate Meeting Notes with Fireflies.ai", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Integrations (Zoom", "Meet", "Teams", "Slack)"], "target_audience": "영업팀(Sales), 리크루터(면접), 고객 관리(CS) 팀"}'::jsonb,
    ARRAY['Fred Bot', 'AI Super Summaries', 'AskFred (GPT-4)', 'Sentiment Analysis', 'Topic Tracker'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Fireflies.ai');

UPDATE ai_models SET
    description = '"개인은 평생 무료" — 설치만 해두면 줌/구글미트 회의를 자동으로 녹화, 전사(텍스트 변환), 요약해 주는 AI 회의 비서.',
    website_url = 'https://www.google.com/search?q=https://fathom.video',
    pricing_model = 'Free (개인 완전 무료) / Paid (팀 기능 유료)',
    pricing_info = '월 $15 (Team Edition / 사용자당).',
    free_tier_note = '개인 사용자 기준 녹화, 전사, 요약 기능이 무제한 무료. (경쟁사들이 30분/월 제한을 둘 때 가장 파격적인 정책).',
    pricing_plans = '[{"plan": "Free", "target": "개인/프리랜서", "features": "무제한 녹화/요약, 이메일 공유, 7개 언어 지원", "price": "무료"}, {"plan": "Team", "target": "조직", "features": "CRM(HubSpot/Salesforce) 연동, 폴더별 공유 권한, 팀 분석", "price": "$15/월"}]'::jsonb,
    pros = ARRAY['진짜 무료: "이게 왜 무료지?" 싶을 정도로 개인 사용자에겐 기능 제한이 거의 없습니다. Otter나 Fireflies의 무료 제한이 답답한 분들에게 최고입니다.', '설치형 앱: 브라우저 확장이 아니라 데스크톱 앱으로 구동되어 안정적이고, 회의 중 화면 한구석에 작게 떠 있어서 방해가 안 됩니다.', '즉시 공유: 회의 끝나자마자 처리 속도가 매우 빨라, 종료 후 1분 안에 요약 링크를 슬랙이나 메일로 뿌릴 수 있습니다.', '하이라이트: 회의 중 중요한 순간에 ''Highlight'' 버튼을 누르면 그 부분만 따로 클립으로 따줍니다.'],
    cons = ARRAY['팀 기능 유료: CRM(세일즈포스 등)에 자동으로 데이터를 넣거나 팀원끼리 폴더를 공유하려면 유료 버전을 써야 합니다.', '한국어 요약: 한국어 음성을 텍스트로 받아적는 건 잘하지만, AI 요약문 생성 시 영어로 나오거나 한국어 문장이 다소 어색할 때가 있습니다.'],
    key_features = '[{"name": "Auto-Recording", "description": "회의 시작 시 자동 참여 및 녹화"}, {"name": "AI Summary", "description": "회의 종료 즉시 핵심 내용 및 할 일(Action Item) 요약"}, {"name": "Highlight Clips", "description": "회의 중 클릭 한 번으로 중요 구간 마킹"}, {"name": "Share Link", "description": "별도 가입 없이 볼 수 있는 회의록 링크 생성"}, {"name": "Search", "description": "\"예산\"이라고 검색하면 해당 단어가 나온 순간을 찾아 재생"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 가성비 끝판왕", "reason": "회의록 툴에 돈 쓰고 싶지 않은 모든 개인 사용자."}, {"target": "✅ 영상 클립 공유", "reason": "\"아까 그 부분 다시 들어보자\"라며 특정 구간만 잘라서 공유하는 일이 잦은 분."}, {"target": "✅ 줌/미트 헤비 유저", "reason": "플랫폼 가리지 않고 자동으로 따라와서 기록해주길 원하는 분."}], "not_recommended": [{"target": "❌ 오프라인 녹음", "reason": "온라인 화상 회의 전용입니다. 대면 회의 녹음은 클로바노트 등을 쓰세요."}, {"target": "❌ 정교한 CRM", "reason": "복잡한 영업 파이프라인 관리가 필요하면 Fireflies가 더 전문적일 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['녹화 알림: Fathom이 들어오면 "Recording in progress"라는 소리가 날 수 있습니다. 상대방이 놀라지 않게 미리 공지하세요.', '앱 실행: 데스크톱 앱을 설치했다면, 회의 전에 앱이 켜져 있는지 확인해야 자동 녹화가 작동합니다.'],
    privacy_info = '{"description": "보안: SOC 2 Type II 인증을 받았으며, 녹화 데이터는 암호화되어 저장됩니다."}'::jsonb,
    alternatives = '[{"name": "Otter.ai", "description": "모바일 앱이 필요하거나 영어 회의 비중이 높다면"}, {"name": "Fireflies.ai", "description": "영업팀 CRM 연동이 핵심이라면"}]'::jsonb,
    media_info = '[{"title": "Fathom: The Free AI Meeting Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Desktop App (Mac", "Windows)", "Zoom", "Google Meet", "Teams 연동"], "target_audience": "프리랜서, 1인 기업가, 회의록 작성에 돈 쓰기 싫은 직장인"}'::jsonb,
    features = ARRAY['Auto-Recording', 'AI Summary', 'Highlight Clips', 'Share Link', 'Search']
WHERE name = 'Fathom';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Fathom', '"개인은 평생 무료" — 설치만 해두면 줌/구글미트 회의를 자동으로 녹화, 전사(텍스트 변환), 요약해 주는 AI 회의 비서.', 'https://www.google.com/search?q=https://fathom.video',
    'Free (개인 완전 무료) / Paid (팀 기능 유료)', '월 $15 (Team Edition / 사용자당).', '개인 사용자 기준 녹화, 전사, 요약 기능이 무제한 무료. (경쟁사들이 30분/월 제한을 둘 때 가장 파격적인 정책).',
    '[{"plan": "Free", "target": "개인/프리랜서", "features": "무제한 녹화/요약, 이메일 공유, 7개 언어 지원", "price": "무료"}, {"plan": "Team", "target": "조직", "features": "CRM(HubSpot/Salesforce) 연동, 폴더별 공유 권한, 팀 분석", "price": "$15/월"}]'::jsonb, ARRAY['진짜 무료: "이게 왜 무료지?" 싶을 정도로 개인 사용자에겐 기능 제한이 거의 없습니다. Otter나 Fireflies의 무료 제한이 답답한 분들에게 최고입니다.', '설치형 앱: 브라우저 확장이 아니라 데스크톱 앱으로 구동되어 안정적이고, 회의 중 화면 한구석에 작게 떠 있어서 방해가 안 됩니다.', '즉시 공유: 회의 끝나자마자 처리 속도가 매우 빨라, 종료 후 1분 안에 요약 링크를 슬랙이나 메일로 뿌릴 수 있습니다.', '하이라이트: 회의 중 중요한 순간에 ''Highlight'' 버튼을 누르면 그 부분만 따로 클립으로 따줍니다.'], ARRAY['팀 기능 유료: CRM(세일즈포스 등)에 자동으로 데이터를 넣거나 팀원끼리 폴더를 공유하려면 유료 버전을 써야 합니다.', '한국어 요약: 한국어 음성을 텍스트로 받아적는 건 잘하지만, AI 요약문 생성 시 영어로 나오거나 한국어 문장이 다소 어색할 때가 있습니다.'], '[{"name": "Auto-Recording", "description": "회의 시작 시 자동 참여 및 녹화"}, {"name": "AI Summary", "description": "회의 종료 즉시 핵심 내용 및 할 일(Action Item) 요약"}, {"name": "Highlight Clips", "description": "회의 중 클릭 한 번으로 중요 구간 마킹"}, {"name": "Share Link", "description": "별도 가입 없이 볼 수 있는 회의록 링크 생성"}, {"name": "Search", "description": "\"예산\"이라고 검색하면 해당 단어가 나온 순간을 찾아 재생"}]'::jsonb,
    '{"recommended": [{"target": "✅ 가성비 끝판왕", "reason": "회의록 툴에 돈 쓰고 싶지 않은 모든 개인 사용자."}, {"target": "✅ 영상 클립 공유", "reason": "\"아까 그 부분 다시 들어보자\"라며 특정 구간만 잘라서 공유하는 일이 잦은 분."}, {"target": "✅ 줌/미트 헤비 유저", "reason": "플랫폼 가리지 않고 자동으로 따라와서 기록해주길 원하는 분."}], "not_recommended": [{"target": "❌ 오프라인 녹음", "reason": "온라인 화상 회의 전용입니다. 대면 회의 녹음은 클로바노트 등을 쓰세요."}, {"target": "❌ 정교한 CRM", "reason": "복잡한 영업 파이프라인 관리가 필요하면 Fireflies가 더 전문적일 수 있습니다."}]}'::jsonb, ARRAY['녹화 알림: Fathom이 들어오면 "Recording in progress"라는 소리가 날 수 있습니다. 상대방이 놀라지 않게 미리 공지하세요.', '앱 실행: 데스크톱 앱을 설치했다면, 회의 전에 앱이 켜져 있는지 확인해야 자동 녹화가 작동합니다.'], '{"description": "보안: SOC 2 Type II 인증을 받았으며, 녹화 데이터는 암호화되어 저장됩니다."}'::jsonb,
    '[{"name": "Otter.ai", "description": "모바일 앱이 필요하거나 영어 회의 비중이 높다면"}, {"name": "Fireflies.ai", "description": "영업팀 CRM 연동이 핵심이라면"}]'::jsonb, '[{"title": "Fathom: The Free AI Meeting Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Desktop App (Mac", "Windows)", "Zoom", "Google Meet", "Teams 연동"], "target_audience": "프리랜서, 1인 기업가, 회의록 작성에 돈 쓰기 싫은 직장인"}'::jsonb,
    ARRAY['Auto-Recording', 'AI Summary', 'Highlight Clips', 'Share Link', 'Search'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Fathom');

UPDATE ai_models SET
    description = '엑셀 파일을 업로드하고 질문하면, Python 코드를 작성해 데이터를 분석하고 시각화 차트까지 그려주는 AI 데이터 분석가.',
    website_url = 'https://julius.ai/',
    pricing_model = 'Subscription (유료 중심)',
    pricing_info = '월 $17.99 (Basic / 연 결제 시) ~ $37 (Pro).',
    free_tier_note = '월 15개 메시지 무료. (데이터 분석 맛보기 용도).',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "월 15 메시지, 기본 모델", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 250 메시지, GPT-4o/Claude 3.5 선택, 파일 업로드", "price": "$17.99/월"}, {"plan": "Essential", "target": "실무자", "features": "무제한 메시지, 더 긴 컨텍스트, 복잡한 데이터 처리", "price": "$37/월"}]'::jsonb,
    pros = ARRAY['코드 실행(Python): ChatGPT의 ''Code Interpreter''와 유사하지만, 데이터 분석에 특화되어 있어 훨씬 정교하고 오류가 적습니다.', '시각화: "월별 매출 추이 막대 그래프로 그려줘" 하면 즉시 깔끔한 차트를 생성하고, 이미지나 GIF로 다운로드할 수 있습니다.', '다양한 소스: 엑셀(Excel), CSV뿐만 아니라 구글 시트(Google Sheets), Postgres 데이터베이스와도 직접 연결됩니다.', '모델 선택: GPT-4o, Claude 3.5 Sonnet 등 분석에 가장 적합한 최신 모델을 골라 쓸 수 있습니다.'],
    cons = ARRAY['유료 필수: 무료 15회는 데이터 몇 번 뜯어보면 끝납니다. 제대로 쓰려면 월 $20 이상 써야 합니다.', '대용량 한계: 수 기가바이트(GB) 단위의 초대형 데이터를 웹에 올리면 처리가 느리거나 멈출 수 있습니다.'],
    key_features = '[{"name": "Chat with Data", "description": "자연어로 데이터 질의응답 및 분석"}, {"name": "Data Visualization", "description": "차트, 그래프, 히트맵 생성 및 편집"}, {"name": "Data Cleaning", "description": "결측치 제거, 형식 변환 등 전처리 자동화"}, {"name": "Advanced Math", "description": "복잡한 수학/물리 문제 풀이 및 모델링"}, {"name": "Report Generation", "description": "분석 결과를 요약하여 리포트 작성"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 엑셀 초보", "reason": "VLOOKUP이나 피벗 테이블이 어려운 분 (\"서울 지역 판매량만 뽑아줘\"라고 말로 하면 됨)."}, {"target": "✅ 보고서 작성", "reason": "데이터를 예쁜 그래프로 만들어서 PPT에 넣어야 하는 직장인."}, {"target": "✅ 데이터 클리닝", "reason": "\"날짜 형식이 뒤죽박죽인데 통일해줘\" 같은 전처리 작업이 필요한 분."}], "not_recommended": [{"target": "❌ 민감 정보", "reason": "고객 개인정보(주민번호 등)가 담긴 파일은 클라우드 업로드 시 주의해야 합니다."}, {"target": "❌ 실시간 대시보드", "reason": "태블로(Tableau)처럼 실시간으로 변하는 대시보드를 구축하는 용도는 아닙니다 (분석 리포트용)."}]}'::jsonb,
    usage_tips = ARRAY['한글 폰트: 차트를 그릴 때 한글이 깨질 수 있습니다. 프롬프트에 "한글 폰트(Malgun Gothic 등) 적용해서 그려줘"라고 명시하면 해결됩니다.', '데이터 확인: AI가 코드를 짜서 분석하지만, 원본 데이터 자체가 이상하면 결과도 이상합니다. 업로드 전 파일 상태를 확인하세요.'],
    privacy_info = '{"description": "Strict Privacy: 사용자가 업로드한 데이터는 분석 목적으로만 사용되며, 일정 기간 후 삭제하거나 사용자가 직접 지울 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "ChatGPT (Plus)", "description": "''Advanced Data Analysis'' 기능이 거의 유사함 (가성비는 GPT가 나을 수 있음)"}, {"name": "Noteable", "description": "주피터 노트북 기반의 또 다른 강력한 AI 데이터 툴"}]'::jsonb,
    media_info = '[{"title": "Getting Started with Julius AI", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "엑셀/SQL이 어려운 마케터, 데이터를 빠르게 시각화해야 하는 기획자"}'::jsonb,
    features = ARRAY['Chat with Data', 'Data Visualization', 'Data Cleaning', 'Advanced Math', 'Report Generation']
WHERE name = 'Julius AI';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Julius AI', '엑셀 파일을 업로드하고 질문하면, Python 코드를 작성해 데이터를 분석하고 시각화 차트까지 그려주는 AI 데이터 분석가.', 'https://julius.ai/',
    'Subscription (유료 중심)', '월 $17.99 (Basic / 연 결제 시) ~ $37 (Pro).', '월 15개 메시지 무료. (데이터 분석 맛보기 용도).',
    '[{"plan": "Free", "target": "체험", "features": "월 15 메시지, 기본 모델", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 250 메시지, GPT-4o/Claude 3.5 선택, 파일 업로드", "price": "$17.99/월"}, {"plan": "Essential", "target": "실무자", "features": "무제한 메시지, 더 긴 컨텍스트, 복잡한 데이터 처리", "price": "$37/월"}]'::jsonb, ARRAY['코드 실행(Python): ChatGPT의 ''Code Interpreter''와 유사하지만, 데이터 분석에 특화되어 있어 훨씬 정교하고 오류가 적습니다.', '시각화: "월별 매출 추이 막대 그래프로 그려줘" 하면 즉시 깔끔한 차트를 생성하고, 이미지나 GIF로 다운로드할 수 있습니다.', '다양한 소스: 엑셀(Excel), CSV뿐만 아니라 구글 시트(Google Sheets), Postgres 데이터베이스와도 직접 연결됩니다.', '모델 선택: GPT-4o, Claude 3.5 Sonnet 등 분석에 가장 적합한 최신 모델을 골라 쓸 수 있습니다.'], ARRAY['유료 필수: 무료 15회는 데이터 몇 번 뜯어보면 끝납니다. 제대로 쓰려면 월 $20 이상 써야 합니다.', '대용량 한계: 수 기가바이트(GB) 단위의 초대형 데이터를 웹에 올리면 처리가 느리거나 멈출 수 있습니다.'], '[{"name": "Chat with Data", "description": "자연어로 데이터 질의응답 및 분석"}, {"name": "Data Visualization", "description": "차트, 그래프, 히트맵 생성 및 편집"}, {"name": "Data Cleaning", "description": "결측치 제거, 형식 변환 등 전처리 자동화"}, {"name": "Advanced Math", "description": "복잡한 수학/물리 문제 풀이 및 모델링"}, {"name": "Report Generation", "description": "분석 결과를 요약하여 리포트 작성"}]'::jsonb,
    '{"recommended": [{"target": "✅ 엑셀 초보", "reason": "VLOOKUP이나 피벗 테이블이 어려운 분 (\"서울 지역 판매량만 뽑아줘\"라고 말로 하면 됨)."}, {"target": "✅ 보고서 작성", "reason": "데이터를 예쁜 그래프로 만들어서 PPT에 넣어야 하는 직장인."}, {"target": "✅ 데이터 클리닝", "reason": "\"날짜 형식이 뒤죽박죽인데 통일해줘\" 같은 전처리 작업이 필요한 분."}], "not_recommended": [{"target": "❌ 민감 정보", "reason": "고객 개인정보(주민번호 등)가 담긴 파일은 클라우드 업로드 시 주의해야 합니다."}, {"target": "❌ 실시간 대시보드", "reason": "태블로(Tableau)처럼 실시간으로 변하는 대시보드를 구축하는 용도는 아닙니다 (분석 리포트용)."}]}'::jsonb, ARRAY['한글 폰트: 차트를 그릴 때 한글이 깨질 수 있습니다. 프롬프트에 "한글 폰트(Malgun Gothic 등) 적용해서 그려줘"라고 명시하면 해결됩니다.', '데이터 확인: AI가 코드를 짜서 분석하지만, 원본 데이터 자체가 이상하면 결과도 이상합니다. 업로드 전 파일 상태를 확인하세요.'], '{"description": "Strict Privacy: 사용자가 업로드한 데이터는 분석 목적으로만 사용되며, 일정 기간 후 삭제하거나 사용자가 직접 지울 수 있습니다."}'::jsonb,
    '[{"name": "ChatGPT (Plus)", "description": "''Advanced Data Analysis'' 기능이 거의 유사함 (가성비는 GPT가 나을 수 있음)"}, {"name": "Noteable", "description": "주피터 노트북 기반의 또 다른 강력한 AI 데이터 툴"}]'::jsonb, '[{"title": "Getting Started with Julius AI", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "엑셀/SQL이 어려운 마케터, 데이터를 빠르게 시각화해야 하는 기획자"}'::jsonb,
    ARRAY['Chat with Data', 'Data Visualization', 'Data Cleaning', 'Advanced Math', 'Report Generation'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Julius AI');

UPDATE ai_models SET
    description = '구글 시트/엑셀 내에서 세일즈포스, 허브스팟, DB 데이터를 실시간으로 연동하고, AI(GPT)로 수식과 데이터를 관리하는 스프레드시트 플러그인.',
    website_url = 'https://coefficient.io/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $49 (Starter / 연간 결제 시).',
    free_tier_note = '수동 데이터 가져오기(Import) 무료. GPT Copilot 기능 무료 사용 가능. (자동 새로고침 불가).',
    pricing_plans = '[{"plan": "Free", "target": "개인", "features": "수동 Import, GPT Copilot, 기본 커넥터", "price": "무료"}, {"plan": "Starter", "target": "실무자", "features": "자동 새로고침(매시간), 스냅샷 저장, 월 1만 행", "price": "$49/월"}, {"plan": "Pro", "target": "팀", "features": "실시간 새로고침, 양방향 동기화(Writeback), SQL 빌더", "price": "$99/월"}]'::jsonb,
    pros = ARRAY['No More CSV: 매번 세일즈포스 들어가서 ''Export CSV'' 하고 엑셀에 붙여넣는 노가다를 없애줍니다. 시트에서 버튼 한 번이면 최신 데이터가 뜹니다.', 'GPT Copilot: 시트 안에서 `=GPTX("이메일 말투를 정중하게 바꿔줘", A2)` 같은 함수를 쓰거나, 말로 차트와 수식을 만들 수 있습니다.', '양방향 동기화(Writeback): 시트에서 수정한 데이터를 세일즈포스 같은 CRM 원본에 다시 업데이트할 수 있습니다. (Pro 이상).', '알림(Alerts): "매출이 목표보다 떨어지면 슬랙으로 알림 보내" 같은 자동화가 시트 내에서 가능합니다.'],
    cons = ARRAY['비싼 가격: 자동 새로고침 기능을 쓰려면 월 $49(약 6~7만 원)을 내야 해서 개인보다는 회사 법인카드로 결제해야 합니다.', '종속성: 구글 시트나 엑셀에 설치하는 ''확장 프로그램'' 형태라 단독 앱보다는 기능이 제한적일 수 있습니다.'],
    key_features = '[{"name": "Data Connectors", "description": "Salesforce, HubSpot, SQL DB, Tableau 데이터 가져오기"}, {"name": "Auto-Refresh", "description": "설정한 스케줄(매시간/매일)대로 데이터 최신화"}, {"name": "GPT Copilot", "description": "텍스트 명령어로 수식 생성, 데이터 분류, 피벗 테이블 생성"}, {"name": "GPT Functions", "description": "시트 셀 내에서 GPT 함수(`=GPTX`) 직접 사용"}, {"name": "Slack/Email Alerts", "description": "데이터 변경 시 알림 발송"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ RevOps/영업관리", "reason": "CRM 데이터를 엑셀로 가공해서 보고해야 하는 분."}, {"target": "✅ 마케터", "reason": "페이스북/구글 광고 데이터를 한 시트에 모아서 대시보드를 만드는 분."}, {"target": "✅ 엑셀 러버", "reason": "\"난 죽어도 엑셀/구글시트가 편해\" 하는 분들에게 날개를 달아줌."}], "not_recommended": [{"target": "❌ 단순 AI", "reason": "그냥 엑셀 함수만 AI한테 물어볼 거라면 ChatGPT 무료 버전으로 충분합니다."}, {"target": "❌ 개인 가계부", "reason": "기업용 데이터 연결(Salesforce, DB)이 핵심이므로 개인 용도로는 과분합니다."}]}'::jsonb,
    usage_tips = ARRAY['데이터 덮어쓰기: 새로고침(Refresh)을 하면 시트에 있던 기존 데이터가 덮어씌워질 수 있습니다. 수동으로 입력한 데이터는 별도 열(Column)에 관리하세요.', 'API 제한: 너무 자주 새로고침하면 연동된 서비스(예: Salesforce)의 API 호출 한도를 넘길 수 있습니다.'],
    privacy_info = '{"description": "보안: SOC 2 인증을 보유하고 있으며, 데이터는 전송 구간에서 암호화됩니다."}'::jsonb,
    alternatives = '[{"name": "Supermetrics", "description": "마케팅 데이터(광고 성과) 연동의 최강자 (더 비쌈)"}, {"name": "Zapier", "description": "시트로 데이터를 보내는 자동화를 짤 수 있음 (실시간성은 낮음)"}]'::jsonb,
    media_info = '[{"title": "Coefficient: The #1 Google Sheets Extension", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Google Sheets", "Excel (Add-on)"], "target_audience": "영업 운영(Sales Ops), 마케터, 데이터를 엑셀로 자주 내려받는 직장인"}'::jsonb,
    features = ARRAY['Data Connectors', 'Auto-Refresh', 'GPT Copilot', 'GPT Functions', 'Slack/Email Alerts']
WHERE name = 'Coefficient';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Coefficient', '구글 시트/엑셀 내에서 세일즈포스, 허브스팟, DB 데이터를 실시간으로 연동하고, AI(GPT)로 수식과 데이터를 관리하는 스프레드시트 플러그인.', 'https://coefficient.io/',
    'Freemium (무료 + 유료 구독)', '월 $49 (Starter / 연간 결제 시).', '수동 데이터 가져오기(Import) 무료. GPT Copilot 기능 무료 사용 가능. (자동 새로고침 불가).',
    '[{"plan": "Free", "target": "개인", "features": "수동 Import, GPT Copilot, 기본 커넥터", "price": "무료"}, {"plan": "Starter", "target": "실무자", "features": "자동 새로고침(매시간), 스냅샷 저장, 월 1만 행", "price": "$49/월"}, {"plan": "Pro", "target": "팀", "features": "실시간 새로고침, 양방향 동기화(Writeback), SQL 빌더", "price": "$99/월"}]'::jsonb, ARRAY['No More CSV: 매번 세일즈포스 들어가서 ''Export CSV'' 하고 엑셀에 붙여넣는 노가다를 없애줍니다. 시트에서 버튼 한 번이면 최신 데이터가 뜹니다.', 'GPT Copilot: 시트 안에서 `=GPTX("이메일 말투를 정중하게 바꿔줘", A2)` 같은 함수를 쓰거나, 말로 차트와 수식을 만들 수 있습니다.', '양방향 동기화(Writeback): 시트에서 수정한 데이터를 세일즈포스 같은 CRM 원본에 다시 업데이트할 수 있습니다. (Pro 이상).', '알림(Alerts): "매출이 목표보다 떨어지면 슬랙으로 알림 보내" 같은 자동화가 시트 내에서 가능합니다.'], ARRAY['비싼 가격: 자동 새로고침 기능을 쓰려면 월 $49(약 6~7만 원)을 내야 해서 개인보다는 회사 법인카드로 결제해야 합니다.', '종속성: 구글 시트나 엑셀에 설치하는 ''확장 프로그램'' 형태라 단독 앱보다는 기능이 제한적일 수 있습니다.'], '[{"name": "Data Connectors", "description": "Salesforce, HubSpot, SQL DB, Tableau 데이터 가져오기"}, {"name": "Auto-Refresh", "description": "설정한 스케줄(매시간/매일)대로 데이터 최신화"}, {"name": "GPT Copilot", "description": "텍스트 명령어로 수식 생성, 데이터 분류, 피벗 테이블 생성"}, {"name": "GPT Functions", "description": "시트 셀 내에서 GPT 함수(`=GPTX`) 직접 사용"}, {"name": "Slack/Email Alerts", "description": "데이터 변경 시 알림 발송"}]'::jsonb,
    '{"recommended": [{"target": "✅ RevOps/영업관리", "reason": "CRM 데이터를 엑셀로 가공해서 보고해야 하는 분."}, {"target": "✅ 마케터", "reason": "페이스북/구글 광고 데이터를 한 시트에 모아서 대시보드를 만드는 분."}, {"target": "✅ 엑셀 러버", "reason": "\"난 죽어도 엑셀/구글시트가 편해\" 하는 분들에게 날개를 달아줌."}], "not_recommended": [{"target": "❌ 단순 AI", "reason": "그냥 엑셀 함수만 AI한테 물어볼 거라면 ChatGPT 무료 버전으로 충분합니다."}, {"target": "❌ 개인 가계부", "reason": "기업용 데이터 연결(Salesforce, DB)이 핵심이므로 개인 용도로는 과분합니다."}]}'::jsonb, ARRAY['데이터 덮어쓰기: 새로고침(Refresh)을 하면 시트에 있던 기존 데이터가 덮어씌워질 수 있습니다. 수동으로 입력한 데이터는 별도 열(Column)에 관리하세요.', 'API 제한: 너무 자주 새로고침하면 연동된 서비스(예: Salesforce)의 API 호출 한도를 넘길 수 있습니다.'], '{"description": "보안: SOC 2 인증을 보유하고 있으며, 데이터는 전송 구간에서 암호화됩니다."}'::jsonb,
    '[{"name": "Supermetrics", "description": "마케팅 데이터(광고 성과) 연동의 최강자 (더 비쌈)"}, {"name": "Zapier", "description": "시트로 데이터를 보내는 자동화를 짤 수 있음 (실시간성은 낮음)"}]'::jsonb, '[{"title": "Coefficient: The #1 Google Sheets Extension", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Google Sheets", "Excel (Add-on)"], "target_audience": "영업 운영(Sales Ops), 마케터, 데이터를 엑셀로 자주 내려받는 직장인"}'::jsonb,
    ARRAY['Data Connectors', 'Auto-Refresh', 'GPT Copilot', 'GPT Functions', 'Slack/Email Alerts'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Coefficient');

UPDATE ai_models SET
    description = '브라우저에서 바로 실행되는 노코드 자동화 툴로, 웹 스크래핑과 AI 에이전트(Magic Box)를 활용해 반복 클릭 업무를 대신해 주는 로봇.',
    website_url = 'https://www.bardeen.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10~15 (Professional / 연간 결제 시).',
    free_tier_note = '무제한 Playbook 실행(로컬). 월 100 AI 크레딧. (AI 기능은 제한적).',
    pricing_plans = '[{"plan": "Free", "target": "개인", "features": "로컬 자동화 무료, 월 100 크레딧, 기본 스크래핑", "price": "무료"}, {"plan": "Professional", "target": "실무자", "features": "월 500+ 크레딧, 고급 스크래핑, 백그라운드 실행", "price": "$15/월"}, {"plan": "Business", "target": "팀", "features": "팀 공유, 전담 지원, 대량 크레딧", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['Frontend Automation: Zapier가 서버(백엔드)끼리 통신한다면, Bardeen은 내 브라우저 화면(프론트엔드)에서 내가 클릭하듯이 작동합니다. API가 없는 사이트도 자동화 가능합니다.', 'Scraper: "이 링크드인 프로필 긁어서 노션에 넣어줘" 같은 스크래핑 자동화가 매우 강력하고 쉽습니다.', 'Magic Box: "링크드인에서 CEO 찾아서 이메일 써줘"라고 채팅창에 치면, AI가 알아서 자동화 워크플로우를 짜줍니다.', '비용 효율: 내 브라우저 자원을 쓰기 때문에, 로컬 실행은 무료로 많이 돌릴 수 있습니다.'],
    cons = ARRAY['브라우저 의존: 브라우저 확장 프로그램이라서, 크롬 창을 켜놔야 자동화가 돌아갑니다. (클라우드 실행은 유료 크레딧 소모).', '사이트 변경: 웹사이트 UI가 바뀌면 스크래퍼가 고장 날 수 있어 유지보수가 필요합니다.', '러닝 커브: ''Playbook(자동화 레시피)'' 개념을 이해하는 데 시간이 조금 걸립니다.'],
    key_features = '[{"name": "Magic Box", "description": "자연어 프롬프트로 자동화 워크플로우 생성"}, {"name": "Web Scraper", "description": "클릭 몇 번으로 웹페이지 데이터 추출 (List/Detail)"}, {"name": "Integration", "description": "Notion, Google Sheets, Slack, Airtable 등 연동"}, {"name": "Right Click Automation", "description": "우클릭 메뉴에서 바로 자동화 실행"}, {"name": "Background Actions", "description": "탭을 보고 있지 않아도 작동 (유료 기능 강화)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 세일즈/리크루팅", "reason": "링크드인, 인스타그램, 지도 앱에서 사람/업체 정보를 긁어와야 하는 분."}, {"target": "✅ 정보 수집", "reason": "매일 특정 사이트에 들어가서 데이터를 엑셀로 옮겨 적는 분."}, {"target": "✅ Zapier 대안", "reason": "API가 없는 웹사이트를 자동화해야 할 때."}], "not_recommended": [{"target": "❌ 서버형 자동화", "reason": "내가 컴퓨터를 꺼도 24시간 돌아가야 하는 서버급 자동화는 Zapier나 Make가 낫습니다."}, {"target": "❌ 대량 데이터", "reason": "수만 건의 데이터를 긁으면 IP 차단을 당하거나 브라우저가 멈출 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['크레딧 소모: AI를 쓰거나 ''Cloud''에서 실행하면 크레딧이 깎입니다. ''Local''에서 실행하면 무료로 많이 쓸 수 있으니 설정을 확인하세요.', '로그인 상태: 자동화하려는 사이트(예: 링크드인)에 미리 로그인이 되어 있어야 Bardeen이 접근할 수 있습니다.'],
    privacy_info = '{"description": "로컬 처리: 대부분의 데이터 처리가 사용자 브라우저 내에서 이루어져 보안상 유리한 측면이 있습니다."}'::jsonb,
    alternatives = '[{"name": "Instant Data Scraper", "description": "단순 스크래핑만 필요하다면 무료 확장 프로그램"}, {"name": "Zapier", "description": "웹 화면이 아니라 앱 간 데이터 연동이 주 목적이라면"}]'::jsonb,
    media_info = '[{"title": "Automate your work with Bardeen AI", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Chrome", "Edge", "Brave Extension (브라우저 확장)"], "target_audience": "리드 수집하는 영업사원, 인재 찾는 리크루터, 웹 데이터를 긁어야 하는 마케터"}'::jsonb,
    features = ARRAY['Magic Box', 'Web Scraper', 'Integration', 'Right Click Automation', 'Background Actions']
WHERE name = 'Bardeen';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Bardeen', '브라우저에서 바로 실행되는 노코드 자동화 툴로, 웹 스크래핑과 AI 에이전트(Magic Box)를 활용해 반복 클릭 업무를 대신해 주는 로봇.', 'https://www.bardeen.ai/',
    'Freemium (무료 + 유료 구독)', '월 $10~15 (Professional / 연간 결제 시).', '무제한 Playbook 실행(로컬). 월 100 AI 크레딧. (AI 기능은 제한적).',
    '[{"plan": "Free", "target": "개인", "features": "로컬 자동화 무료, 월 100 크레딧, 기본 스크래핑", "price": "무료"}, {"plan": "Professional", "target": "실무자", "features": "월 500+ 크레딧, 고급 스크래핑, 백그라운드 실행", "price": "$15/월"}, {"plan": "Business", "target": "팀", "features": "팀 공유, 전담 지원, 대량 크레딧", "price": "별도 문의"}]'::jsonb, ARRAY['Frontend Automation: Zapier가 서버(백엔드)끼리 통신한다면, Bardeen은 내 브라우저 화면(프론트엔드)에서 내가 클릭하듯이 작동합니다. API가 없는 사이트도 자동화 가능합니다.', 'Scraper: "이 링크드인 프로필 긁어서 노션에 넣어줘" 같은 스크래핑 자동화가 매우 강력하고 쉽습니다.', 'Magic Box: "링크드인에서 CEO 찾아서 이메일 써줘"라고 채팅창에 치면, AI가 알아서 자동화 워크플로우를 짜줍니다.', '비용 효율: 내 브라우저 자원을 쓰기 때문에, 로컬 실행은 무료로 많이 돌릴 수 있습니다.'], ARRAY['브라우저 의존: 브라우저 확장 프로그램이라서, 크롬 창을 켜놔야 자동화가 돌아갑니다. (클라우드 실행은 유료 크레딧 소모).', '사이트 변경: 웹사이트 UI가 바뀌면 스크래퍼가 고장 날 수 있어 유지보수가 필요합니다.', '러닝 커브: ''Playbook(자동화 레시피)'' 개념을 이해하는 데 시간이 조금 걸립니다.'], '[{"name": "Magic Box", "description": "자연어 프롬프트로 자동화 워크플로우 생성"}, {"name": "Web Scraper", "description": "클릭 몇 번으로 웹페이지 데이터 추출 (List/Detail)"}, {"name": "Integration", "description": "Notion, Google Sheets, Slack, Airtable 등 연동"}, {"name": "Right Click Automation", "description": "우클릭 메뉴에서 바로 자동화 실행"}, {"name": "Background Actions", "description": "탭을 보고 있지 않아도 작동 (유료 기능 강화)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 세일즈/리크루팅", "reason": "링크드인, 인스타그램, 지도 앱에서 사람/업체 정보를 긁어와야 하는 분."}, {"target": "✅ 정보 수집", "reason": "매일 특정 사이트에 들어가서 데이터를 엑셀로 옮겨 적는 분."}, {"target": "✅ Zapier 대안", "reason": "API가 없는 웹사이트를 자동화해야 할 때."}], "not_recommended": [{"target": "❌ 서버형 자동화", "reason": "내가 컴퓨터를 꺼도 24시간 돌아가야 하는 서버급 자동화는 Zapier나 Make가 낫습니다."}, {"target": "❌ 대량 데이터", "reason": "수만 건의 데이터를 긁으면 IP 차단을 당하거나 브라우저가 멈출 수 있습니다."}]}'::jsonb, ARRAY['크레딧 소모: AI를 쓰거나 ''Cloud''에서 실행하면 크레딧이 깎입니다. ''Local''에서 실행하면 무료로 많이 쓸 수 있으니 설정을 확인하세요.', '로그인 상태: 자동화하려는 사이트(예: 링크드인)에 미리 로그인이 되어 있어야 Bardeen이 접근할 수 있습니다.'], '{"description": "로컬 처리: 대부분의 데이터 처리가 사용자 브라우저 내에서 이루어져 보안상 유리한 측면이 있습니다."}'::jsonb,
    '[{"name": "Instant Data Scraper", "description": "단순 스크래핑만 필요하다면 무료 확장 프로그램"}, {"name": "Zapier", "description": "웹 화면이 아니라 앱 간 데이터 연동이 주 목적이라면"}]'::jsonb, '[{"title": "Automate your work with Bardeen AI", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Chrome", "Edge", "Brave Extension (브라우저 확장)"], "target_audience": "리드 수집하는 영업사원, 인재 찾는 리크루터, 웹 데이터를 긁어야 하는 마케터"}'::jsonb,
    ARRAY['Magic Box', 'Web Scraper', 'Integration', 'Right Click Automation', 'Background Actions'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Bardeen');

UPDATE ai_models SET
    description = '"나만의 AI 직원 채용" — 이메일 관리, 일정 조율, 고객 지원 등 특정 직무를 자율적으로 수행하는 AI 에이전트(비서) 플랫폼.',
    website_url = 'https://www.lindy.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $49 (Starter / 개인용).',
    free_tier_note = '가입 시 무료 체험 크레딧 제공. 기본적인 ''Lindy(에이전트)'' 생성 및 테스트 가능. (장기 사용 시 유료 필요).',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "기본 기능 체험, 제한된 액션 수", "price": "무료"}, {"plan": "Starter", "target": "개인/사업가", "features": "무제한 액션, 고급 플러그인, 개인 비서 활용", "price": "$49/월"}, {"plan": "Pro/Team", "target": "기업", "features": "팀 공유, 맞춤형 린디 생성, API 연동", "price": "$119~/월"}]'::jsonb,
    pros = ARRAY['자율성(Autonomous): 시키지 않아도 "새로운 이메일이 오면 내용을 보고 캘린더를 확인해서 답장을 보낸다"는 판단을 스스로 합니다. (ChatGPT보다 능동적).', '전용 린디(Lindy): ''의료 서기'', ''채용 담당자'', ''CS 매니저'' 등 특정 직무에 특화된 AI 직원을 생성하거나 고용할 수 있습니다.', 'Trigger: "이메일 수신 시", "특정 시간마다" 등 트리거를 설정해두면 24시간 알아서 일합니다.', '통합: 구글 캘린더, 지메일, 슬랙 등 업무 툴과 깊게 연동되어 실제 비서처럼 권한을 행사합니다.'],
    cons = ARRAY['비싼 가격: 월 $49(약 6~7만 원)부터 시작하므로, 개인 비서 인건비보다는 싸지만 SW 구독료치고는 비쌉니다.', '설정 난이도: "제대로 일하게" 가르치려면 프롬프트와 룰 세팅을 꼼꼼하게 해줘야 합니다. (초기 교육 필요).', '오류 가능성: 자율 에이전트 특성상 가끔 엉뚱한 메일을 보낼 수 있으므로 초기에는 ''승인 후 발송'' 모드로 써야 합니다.'],
    key_features = '[{"name": "AI Executive Assistant", "description": "이메일 초안 작성, 일정 조율, 회의 예약"}, {"name": "Specialized Agents", "description": "리크루터, 세일즈 SDR, 고객 지원 등 직무별 에이전트"}, {"name": "Triggers & Actions", "description": "특정 이벤트 발생 시 자율 행동 수행"}, {"name": "Voice Interaction", "description": "음성으로 지시하고 대화 가능"}, {"name": "App Integrations", "description": "Gmail, Calendar, Slack, HubSpot 등 50+ 연동"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 1인 기업가", "reason": "비서 채용하기엔 부담스럽고 일정 관리는 빡빡한 대표님."}, {"target": "✅ CS 자동화", "reason": "단순 문의 메일에 대해 매뉴얼대로 답변하고 분류해줄 직원이 필요한 팀."}, {"target": "✅ 아웃바운드 영업", "reason": "잠재 고객에게 맞춤형 콜드 메일을 보내고 미팅을 잡는 과정을 자동화하고 싶은 분."}], "not_recommended": [{"target": "❌ 단순 챗봇", "reason": "그냥 궁금한 거 물어보는 용도라면 ChatGPT가 훨씬 쌉니다."}, {"target": "❌ 통제광", "reason": "AI가 내 허락 없이 메일 보내는 게 불안해서 못 견디는 분."}]}'::jsonb,
    usage_tips = ARRAY['Human in the loop: 처음에는 린디가 작성한 답장을 "내가 검토하고 보내기(Draft mode)"로 설정하세요. 100% 믿고 자동 발송했다가 실수할 수 있습니다.', '권한 부여: 캘린더 삭제/수정 권한을 주는 것이므로, 보안상 중요한 계정보다는 업무용 계정에만 연동하세요.'],
    privacy_info = '{"description": "보안: 사용자의 이메일이나 일정 데이터에 접근하므로, SOC 2 등 보안 표준 준수 여부를 확인하고 민감한 정보는 필터링해야 합니다."}'::jsonb,
    alternatives = '[{"name": "HyperWrite (Personal Assistant)", "description": "웹 브라우징 중심의 개인 비서"}, {"name": "Zapier Central", "description": "자동화 툴 기반의 AI 에이전트 봇"}]'::jsonb,
    media_info = '[{"title": "Meet Lindy: Your AI Employee", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "비서가 필요한 바쁜 대표님, 반복 업무를 맡길 ''AI 직원''이 필요한 팀"}'::jsonb,
    features = ARRAY['AI Executive Assistant', 'Specialized Agents', 'Triggers & Actions', 'Voice Interaction', 'App Integrations']
WHERE name = 'Lindy';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Lindy', '"나만의 AI 직원 채용" — 이메일 관리, 일정 조율, 고객 지원 등 특정 직무를 자율적으로 수행하는 AI 에이전트(비서) 플랫폼.', 'https://www.lindy.ai/',
    'Freemium (무료 + 유료 구독)', '월 $49 (Starter / 개인용).', '가입 시 무료 체험 크레딧 제공. 기본적인 ''Lindy(에이전트)'' 생성 및 테스트 가능. (장기 사용 시 유료 필요).',
    '[{"plan": "Free", "target": "체험", "features": "기본 기능 체험, 제한된 액션 수", "price": "무료"}, {"plan": "Starter", "target": "개인/사업가", "features": "무제한 액션, 고급 플러그인, 개인 비서 활용", "price": "$49/월"}, {"plan": "Pro/Team", "target": "기업", "features": "팀 공유, 맞춤형 린디 생성, API 연동", "price": "$119~/월"}]'::jsonb, ARRAY['자율성(Autonomous): 시키지 않아도 "새로운 이메일이 오면 내용을 보고 캘린더를 확인해서 답장을 보낸다"는 판단을 스스로 합니다. (ChatGPT보다 능동적).', '전용 린디(Lindy): ''의료 서기'', ''채용 담당자'', ''CS 매니저'' 등 특정 직무에 특화된 AI 직원을 생성하거나 고용할 수 있습니다.', 'Trigger: "이메일 수신 시", "특정 시간마다" 등 트리거를 설정해두면 24시간 알아서 일합니다.', '통합: 구글 캘린더, 지메일, 슬랙 등 업무 툴과 깊게 연동되어 실제 비서처럼 권한을 행사합니다.'], ARRAY['비싼 가격: 월 $49(약 6~7만 원)부터 시작하므로, 개인 비서 인건비보다는 싸지만 SW 구독료치고는 비쌉니다.', '설정 난이도: "제대로 일하게" 가르치려면 프롬프트와 룰 세팅을 꼼꼼하게 해줘야 합니다. (초기 교육 필요).', '오류 가능성: 자율 에이전트 특성상 가끔 엉뚱한 메일을 보낼 수 있으므로 초기에는 ''승인 후 발송'' 모드로 써야 합니다.'], '[{"name": "AI Executive Assistant", "description": "이메일 초안 작성, 일정 조율, 회의 예약"}, {"name": "Specialized Agents", "description": "리크루터, 세일즈 SDR, 고객 지원 등 직무별 에이전트"}, {"name": "Triggers & Actions", "description": "특정 이벤트 발생 시 자율 행동 수행"}, {"name": "Voice Interaction", "description": "음성으로 지시하고 대화 가능"}, {"name": "App Integrations", "description": "Gmail, Calendar, Slack, HubSpot 등 50+ 연동"}]'::jsonb,
    '{"recommended": [{"target": "✅ 1인 기업가", "reason": "비서 채용하기엔 부담스럽고 일정 관리는 빡빡한 대표님."}, {"target": "✅ CS 자동화", "reason": "단순 문의 메일에 대해 매뉴얼대로 답변하고 분류해줄 직원이 필요한 팀."}, {"target": "✅ 아웃바운드 영업", "reason": "잠재 고객에게 맞춤형 콜드 메일을 보내고 미팅을 잡는 과정을 자동화하고 싶은 분."}], "not_recommended": [{"target": "❌ 단순 챗봇", "reason": "그냥 궁금한 거 물어보는 용도라면 ChatGPT가 훨씬 쌉니다."}, {"target": "❌ 통제광", "reason": "AI가 내 허락 없이 메일 보내는 게 불안해서 못 견디는 분."}]}'::jsonb, ARRAY['Human in the loop: 처음에는 린디가 작성한 답장을 "내가 검토하고 보내기(Draft mode)"로 설정하세요. 100% 믿고 자동 발송했다가 실수할 수 있습니다.', '권한 부여: 캘린더 삭제/수정 권한을 주는 것이므로, 보안상 중요한 계정보다는 업무용 계정에만 연동하세요.'], '{"description": "보안: 사용자의 이메일이나 일정 데이터에 접근하므로, SOC 2 등 보안 표준 준수 여부를 확인하고 민감한 정보는 필터링해야 합니다."}'::jsonb,
    '[{"name": "HyperWrite (Personal Assistant)", "description": "웹 브라우징 중심의 개인 비서"}, {"name": "Zapier Central", "description": "자동화 툴 기반의 AI 에이전트 봇"}]'::jsonb, '[{"title": "Meet Lindy: Your AI Employee", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "비서가 필요한 바쁜 대표님, 반복 업무를 맡길 ''AI 직원''이 필요한 팀"}'::jsonb,
    ARRAY['AI Executive Assistant', 'Specialized Agents', 'Triggers & Actions', 'Voice Interaction', 'App Integrations'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Lindy');

UPDATE ai_models SET
    description = '텍스트만 입력하면 실제 사람과 구분하기 힘든 초고화질 AI 아바타가 자연스럽게 말하는 영상을 만들어주는 생성형 비디오 플랫폼.',
    website_url = 'https://www.heygen.com/',
    pricing_model = 'Credit-based Subscription (구독형)',
    pricing_info = '월 $24 (Creator / 연 결제 시) / 월 $29 (월 결제 시).',
    free_tier_note = '가입 시 1 크레딧(영상 1분) 1회 제공. 이후에는 유료 결제 필요. 워터마크 있음.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "1 크레딧(1회성), 최대 1분, 워터마크", "price": "무료"}, {"plan": "Creator", "target": "개인", "features": "월 15 크레딧(15분), 워터마크 제거, 빠른 처리", "price": "$24/월"}, {"plan": "Team", "target": "조직", "features": "월 30 크레딧(30분), 4K 해상도, 팀 협업, 우선순위 처리", "price": "$69/월"}]'::jsonb,
    pros = ARRAY['Video Translate: 내가 찍은 한국어 영상을 올리면, 내 목소리 톤을 유지한 채 입모양(Lip-sync)까지 맞춰서 영어, 일본어 등으로 바꿔줍니다. (가장 강력한 기능).', 'Instant Avatar: 웹캠으로 2분만 촬영하면 내 얼굴과 목소리를 복제한 디지털 트윈을 즉시 만들 수 있습니다.', 'URL to Video: 아마존 상품 페이지나 뉴스 기사 링크만 넣으면 대본 작성부터 영상 생성까지 한 번에 끝내줍니다.', 'Streaming Avatar: 실시간으로 대화 가능한 인터랙티브 아바타 API를 지원합니다.'],
    cons = ARRAY['비싼 가격: 월 $24에 15분은 경쟁사(D-ID 등) 대비 다소 비싼 편입니다. 크레딧 소모가 빠릅니다.', '엄격한 모더레이션: 유명인 얼굴이나 정책에 위반되는 스크립트는 생성 거부될 확률이 높습니다.'],
    key_features = '[{"name": "Text to Video", "description": "텍스트 입력 시 아바타 영상 생성"}, {"name": "Video Translate", "description": "영상 언어 변환 (목소리 복제+립싱크)"}, {"name": "Instant Avatar", "description": "5분 촬영으로 나만의 아바타 생성"}, {"name": "URL to Video", "description": "웹사이트 링크 기반 영상 자동 제작"}, {"name": "Photo Avatar", "description": "정지된 사진을 말하는 영상으로 변환"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 글로벌 유튜버", "reason": "한국어로 찍고 영어 채널도 동시에 운영하고 싶은 분 (Video Translate)."}, {"target": "✅ CEO/강사", "reason": "바빠서 매번 촬영할 시간은 없고, 얼굴 나온 영상은 필요한 분 (Instant Avatar)."}, {"target": "✅ 쇼핑몰", "reason": "상품 상세 페이지를 읽어주는 가상 쇼호스트가 필요한 분."}], "not_recommended": [{"target": "❌ 감성 연기", "reason": "드라마틱한 연기나 격한 감정 표현이 필요한 콘텐츠에는 아직 부자연스럽습니다."}, {"target": "❌ 가성비", "reason": "대량의 숏폼을 공장처럼 찍어내기에는 단가가 높습니다."}]}'::jsonb,
    usage_tips = ARRAY['크레딧 계산: 영상이 1분 1초가 되면 2크레딧이 차감됩니다. 59초로 끊는 편집 센스가 필요합니다.', '번역 모드: Video Translate 사용 시 ''Lip Sync'' 옵션을 켜야 입모양이 맞습니다. 안 켜면 더빙만 됩니다.'],
    privacy_info = '{"description": "보안: SOC 2 인증을 받았으며, 본인 인증 없는 딥페이크 생성을 방지하기 위해 다중 인증 절차를 거칩니다."}'::jsonb,
    alternatives = '[{"name": "Synthesia", "description": "제스처 제어 등 아바타 연출이 더 중요하다면"}, {"name": "D-ID", "description": "사진 한 장으로 움직이는 영상을 만드는 가성비 툴"}]'::jsonb,
    media_info = '[{"title": "HeyGen Video Translate: Speak to the World", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "기업 홍보팀, 교육 영상 제작자, 글로벌 마케터"}'::jsonb,
    features = ARRAY['Text to Video', 'Video Translate', 'Instant Avatar', 'URL to Video', 'Photo Avatar']
WHERE name = 'HeyGen';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'HeyGen', '텍스트만 입력하면 실제 사람과 구분하기 힘든 초고화질 AI 아바타가 자연스럽게 말하는 영상을 만들어주는 생성형 비디오 플랫폼.', 'https://www.heygen.com/',
    'Credit-based Subscription (구독형)', '월 $24 (Creator / 연 결제 시) / 월 $29 (월 결제 시).', '가입 시 1 크레딧(영상 1분) 1회 제공. 이후에는 유료 결제 필요. 워터마크 있음.',
    '[{"plan": "Free", "target": "체험", "features": "1 크레딧(1회성), 최대 1분, 워터마크", "price": "무료"}, {"plan": "Creator", "target": "개인", "features": "월 15 크레딧(15분), 워터마크 제거, 빠른 처리", "price": "$24/월"}, {"plan": "Team", "target": "조직", "features": "월 30 크레딧(30분), 4K 해상도, 팀 협업, 우선순위 처리", "price": "$69/월"}]'::jsonb, ARRAY['Video Translate: 내가 찍은 한국어 영상을 올리면, 내 목소리 톤을 유지한 채 입모양(Lip-sync)까지 맞춰서 영어, 일본어 등으로 바꿔줍니다. (가장 강력한 기능).', 'Instant Avatar: 웹캠으로 2분만 촬영하면 내 얼굴과 목소리를 복제한 디지털 트윈을 즉시 만들 수 있습니다.', 'URL to Video: 아마존 상품 페이지나 뉴스 기사 링크만 넣으면 대본 작성부터 영상 생성까지 한 번에 끝내줍니다.', 'Streaming Avatar: 실시간으로 대화 가능한 인터랙티브 아바타 API를 지원합니다.'], ARRAY['비싼 가격: 월 $24에 15분은 경쟁사(D-ID 등) 대비 다소 비싼 편입니다. 크레딧 소모가 빠릅니다.', '엄격한 모더레이션: 유명인 얼굴이나 정책에 위반되는 스크립트는 생성 거부될 확률이 높습니다.'], '[{"name": "Text to Video", "description": "텍스트 입력 시 아바타 영상 생성"}, {"name": "Video Translate", "description": "영상 언어 변환 (목소리 복제+립싱크)"}, {"name": "Instant Avatar", "description": "5분 촬영으로 나만의 아바타 생성"}, {"name": "URL to Video", "description": "웹사이트 링크 기반 영상 자동 제작"}, {"name": "Photo Avatar", "description": "정지된 사진을 말하는 영상으로 변환"}]'::jsonb,
    '{"recommended": [{"target": "✅ 글로벌 유튜버", "reason": "한국어로 찍고 영어 채널도 동시에 운영하고 싶은 분 (Video Translate)."}, {"target": "✅ CEO/강사", "reason": "바빠서 매번 촬영할 시간은 없고, 얼굴 나온 영상은 필요한 분 (Instant Avatar)."}, {"target": "✅ 쇼핑몰", "reason": "상품 상세 페이지를 읽어주는 가상 쇼호스트가 필요한 분."}], "not_recommended": [{"target": "❌ 감성 연기", "reason": "드라마틱한 연기나 격한 감정 표현이 필요한 콘텐츠에는 아직 부자연스럽습니다."}, {"target": "❌ 가성비", "reason": "대량의 숏폼을 공장처럼 찍어내기에는 단가가 높습니다."}]}'::jsonb, ARRAY['크레딧 계산: 영상이 1분 1초가 되면 2크레딧이 차감됩니다. 59초로 끊는 편집 센스가 필요합니다.', '번역 모드: Video Translate 사용 시 ''Lip Sync'' 옵션을 켜야 입모양이 맞습니다. 안 켜면 더빙만 됩니다.'], '{"description": "보안: SOC 2 인증을 받았으며, 본인 인증 없는 딥페이크 생성을 방지하기 위해 다중 인증 절차를 거칩니다."}'::jsonb,
    '[{"name": "Synthesia", "description": "제스처 제어 등 아바타 연출이 더 중요하다면"}, {"name": "D-ID", "description": "사진 한 장으로 움직이는 영상을 만드는 가성비 툴"}]'::jsonb, '[{"title": "HeyGen Video Translate: Speak to the World", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "기업 홍보팀, 교육 영상 제작자, 글로벌 마케터"}'::jsonb,
    ARRAY['Text to Video', 'Video Translate', 'Instant Avatar', 'URL to Video', 'Photo Avatar'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'HeyGen');

UPDATE ai_models SET
    description = '텍스트와 이미지를 입력하면 헐리우드급 물리 엔진이 적용된 고품질 비디오를 5초 만에 생성해 주는 AI 영상 모델.',
    website_url = 'https://lumalabs.ai/dream-machine',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $29.99 (Standard / 연 결제 시 $23.99).',
    free_tier_note = '월 30회 생성 무료. (하루 제한 없음, 월 단위 리셋). 상업적 이용 불가, 워터마크 포함.',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "월 30회 생성, 일반 속도, 상업적 이용 불가", "price": "무료"}, {"plan": "Standard", "target": "크리에이터", "features": "월 120회 생성, 상업적 이용 허용, 워터마크 제거", "price": "$29.99/월"}, {"plan": "Pro", "target": "전문가", "features": "월 400회 생성, 우선순위 큐(Fast), 고해상도", "price": "$99.99/월"}]'::jsonb,
    pros = ARRAY['속도: 경쟁 모델(Sora, Kling) 대비 생성 속도가 매우 빠릅니다 (120초 내외).', 'Keyframes: 영상의 첫 장면(Start Frame)과 끝 장면(End Frame)을 지정하면, AI가 그 사이를 자연스럽게 이어줍니다. (가장 큰 강점).', '물리 구현: 액체가 튀거나 연기가 피어오르는 물리적 움직임이 매우 사실적입니다.', 'Loop: 끊김 없이 무한 반복되는 루프 영상을 쉽게 만들 수 있습니다.'],
    cons = ARRAY['시간 제한: 한 번에 생성되는 길이가 5초로 짧은 편입니다. (Extend로 연장 가능하지만 크레딧 소모).', '텍스트 뭉개짐: 영상 내에 글자가 나올 경우 외계어처럼 뭉개지는 현상이 있습니다.', '역동성 부족: 때로는 움직임이 너무 적거나 정적인 영상이 나올 때가 있습니다.'],
    key_features = '[{"name": "Text to Video", "description": "텍스트 명령어로 영상 생성"}, {"name": "Image to Video", "description": "이미지를 살아 움직이게 변환"}, {"name": "Keyframes Control", "description": "시작과 끝 이미지를 지정해 중간 과정 생성"}, {"name": "Extend Video", "description": "생성된 영상의 뒷부분을 이어 붙여 연장"}, {"name": "Loop Mode", "description": "무한 반복 영상 생성"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 트랜지션 제작", "reason": "A 장면에서 B 장면으로 변하는 모핑(Morphing) 효과가 필요한 편집자 (Keyframes)."}, {"target": "✅ 밈 제작", "reason": "사진 한 장을 움직이는 짤방으로 만들고 싶은 분."}, {"target": "✅ 제품 홍보", "reason": "제품 사진을 기반으로 360도 회전 샷이나 연출 샷을 만들고 싶은 마케터."}], "not_recommended": [{"target": "❌ 긴 영상", "reason": "1분 이상의 스토리 영상을 한 번에 뽑아낼 수는 없습니다."}, {"target": "❌ 대사 처리", "reason": "인물이 말을 할 때 입모양을 맞추는 립싱크 기능은 없습니다."}]}'::jsonb,
    usage_tips = ARRAY['프롬프트: "Camera movement"나 "Action"을 구체적으로 적지 않으면 정지 화면 같은 영상이 나옵니다. "Zoom in", "Pan right", "Running fast" 등 동사를 많이 쓰세요.', '사람 손: AI 영상 특유의 ''손가락 6개'' 문제는 여전하므로, 손이 클로즈업되는 장면은 피하는 게 좋습니다.'],
    privacy_info = '{"description": "상업적 이용: 무료 플랜 결과물은 상업적으로 쓸 수 없습니다. 유튜브 수익 창출용이라면 Standard 이상을 구독하세요."}'::jsonb,
    alternatives = '[{"name": "Runway Gen-3", "description": "더 정교한 카메라 컨트롤이 필요하다면"}, {"name": "Kling AI", "description": "영상 길이가 더 길고(5~10초) 인물 움직임이 자연스러움을 원한다면"}]'::jsonb,
    media_info = '[{"title": "Introducing Dream Machine", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "영상 크리에이터, VFX 아티스트, 밈(Meme) 제작자"}'::jsonb,
    features = ARRAY['Text to Video', 'Image to Video', 'Keyframes Control', 'Extend Video', 'Loop Mode']
WHERE name = 'Luma Dream Machine';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Luma Dream Machine', '텍스트와 이미지를 입력하면 헐리우드급 물리 엔진이 적용된 고품질 비디오를 5초 만에 생성해 주는 AI 영상 모델.', 'https://lumalabs.ai/dream-machine',
    'Freemium (무료 + 유료 구독)', '월 $29.99 (Standard / 연 결제 시 $23.99).', '월 30회 생성 무료. (하루 제한 없음, 월 단위 리셋). 상업적 이용 불가, 워터마크 포함.',
    '[{"plan": "Free", "target": "찍먹파", "features": "월 30회 생성, 일반 속도, 상업적 이용 불가", "price": "무료"}, {"plan": "Standard", "target": "크리에이터", "features": "월 120회 생성, 상업적 이용 허용, 워터마크 제거", "price": "$29.99/월"}, {"plan": "Pro", "target": "전문가", "features": "월 400회 생성, 우선순위 큐(Fast), 고해상도", "price": "$99.99/월"}]'::jsonb, ARRAY['속도: 경쟁 모델(Sora, Kling) 대비 생성 속도가 매우 빠릅니다 (120초 내외).', 'Keyframes: 영상의 첫 장면(Start Frame)과 끝 장면(End Frame)을 지정하면, AI가 그 사이를 자연스럽게 이어줍니다. (가장 큰 강점).', '물리 구현: 액체가 튀거나 연기가 피어오르는 물리적 움직임이 매우 사실적입니다.', 'Loop: 끊김 없이 무한 반복되는 루프 영상을 쉽게 만들 수 있습니다.'], ARRAY['시간 제한: 한 번에 생성되는 길이가 5초로 짧은 편입니다. (Extend로 연장 가능하지만 크레딧 소모).', '텍스트 뭉개짐: 영상 내에 글자가 나올 경우 외계어처럼 뭉개지는 현상이 있습니다.', '역동성 부족: 때로는 움직임이 너무 적거나 정적인 영상이 나올 때가 있습니다.'], '[{"name": "Text to Video", "description": "텍스트 명령어로 영상 생성"}, {"name": "Image to Video", "description": "이미지를 살아 움직이게 변환"}, {"name": "Keyframes Control", "description": "시작과 끝 이미지를 지정해 중간 과정 생성"}, {"name": "Extend Video", "description": "생성된 영상의 뒷부분을 이어 붙여 연장"}, {"name": "Loop Mode", "description": "무한 반복 영상 생성"}]'::jsonb,
    '{"recommended": [{"target": "✅ 트랜지션 제작", "reason": "A 장면에서 B 장면으로 변하는 모핑(Morphing) 효과가 필요한 편집자 (Keyframes)."}, {"target": "✅ 밈 제작", "reason": "사진 한 장을 움직이는 짤방으로 만들고 싶은 분."}, {"target": "✅ 제품 홍보", "reason": "제품 사진을 기반으로 360도 회전 샷이나 연출 샷을 만들고 싶은 마케터."}], "not_recommended": [{"target": "❌ 긴 영상", "reason": "1분 이상의 스토리 영상을 한 번에 뽑아낼 수는 없습니다."}, {"target": "❌ 대사 처리", "reason": "인물이 말을 할 때 입모양을 맞추는 립싱크 기능은 없습니다."}]}'::jsonb, ARRAY['프롬프트: "Camera movement"나 "Action"을 구체적으로 적지 않으면 정지 화면 같은 영상이 나옵니다. "Zoom in", "Pan right", "Running fast" 등 동사를 많이 쓰세요.', '사람 손: AI 영상 특유의 ''손가락 6개'' 문제는 여전하므로, 손이 클로즈업되는 장면은 피하는 게 좋습니다.'], '{"description": "상업적 이용: 무료 플랜 결과물은 상업적으로 쓸 수 없습니다. 유튜브 수익 창출용이라면 Standard 이상을 구독하세요."}'::jsonb,
    '[{"name": "Runway Gen-3", "description": "더 정교한 카메라 컨트롤이 필요하다면"}, {"name": "Kling AI", "description": "영상 길이가 더 길고(5~10초) 인물 움직임이 자연스러움을 원한다면"}]'::jsonb, '[{"title": "Introducing Dream Machine", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "영상 크리에이터, VFX 아티스트, 밈(Meme) 제작자"}'::jsonb,
    ARRAY['Text to Video', 'Image to Video', 'Keyframes Control', 'Extend Video', 'Loop Mode'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Luma Dream Machine');

UPDATE ai_models SET
    description = '중국 콰이쇼우(Kuaishou)가 개발한 ''Sora 대항마''로, 최대 10초(유료)까지 생성 가능하며 인물의 자연스러운 움직임이 압도적인 영상 모델.',
    website_url = 'https://klingai.com/',
    pricing_model = 'Credit-based (매일 무료 + 유료 구독)',
    pricing_info = '월 $10 (Standard / 연 결제 시 할인).',
    free_tier_note = '매일 66 크레딧 무료 제공 (약 6개 영상). 단, 무료 사용자는 대기열이 길어 생성에 시간이 걸릴 수 있음.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "66 크레딧/일, 워터마크, 5초 영상만 가능", "price": "무료"}, {"plan": "Standard", "target": "입문자", "features": "660 크레딧/월, 워터마크 제거, 10초 영상 가능", "price": "$10/월"}, {"plan": "Pro", "target": "전문가", "features": "3000 크레딧/월, 고성능 모드(Professional Mode)", "price": "$37/월"}]'::jsonb,
    pros = ARRAY['리얼리즘: 현재 공개된 AI 중 인물의 걷는 모습, 표정, 음식을 먹는 장면 등이 가장 실제 촬영본과 흡사합니다. (불쾌한 골짜기가 적음).', '긴 지속 시간: 유료 플랜 사용 시 한 번에 10초 분량까지 생성할 수 있어 숏폼 제작에 유리합니다.', 'Camera Control: 카메라의 이동 경로(수평, 수직, 줌, 틸트)를 구체적으로 설정할 수 있습니다.', '매일 무료: 리필 안 되는 타사와 달리 매일 크레딧을 채워주는 혜자 정책입니다.'],
    cons = ARRAY['대기 시간: 무료 사용자가 몰리면 영상 하나 만드는 데 몇 시간이 걸리기도 합니다.', '검열: 중국 서비스 특성상 특정 키워드나 정치적/사회적 이슈에 대한 검열이 있을 수 있습니다.'],
    key_features = '[{"name": "Text to Video", "description": "텍스트로 고화질 영상 생성 (High Quality Mode)"}, {"name": "Image to Video", "description": "이미지를 영상으로 변환 (일관성 우수)"}, {"name": "Extend Video", "description": "기존 영상을 5초씩 연장"}, {"name": "Camera Control", "description": "줌, 팬, 틸트, 롤 등 카메라 워킹 제어"}, {"name": "Professional Mode", "description": "더 긴 시간(10초)과 높은 퀄리티 제공 (유료)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 영화 제작", "reason": "시네마틱한 질감의 B-roll 소스가 필요한 편집자."}, {"target": "✅ 인물 영상", "reason": "사람이 걷거나 행동하는 장면을 자연스럽게 만들고 싶은 분."}, {"target": "✅ 무료 유저", "reason": "느려도 좋으니 매일 공짜로 만들어보고 싶은 분."}], "not_recommended": [{"target": "❌ 급한 성격", "reason": "유료 결제 안 하면 대기 시간이 답답해 죽을 수 있습니다."}, {"target": "❌ 텍스트 묘사", "reason": "영상 내에 글자가 정확히 나와야 한다면 아직 부족합니다."}]}'::jsonb,
    usage_tips = ARRAY['크레딧 소모: ''Professional Mode''나 ''10초 생성''을 체크하면 크레딧이 몇 배로 듭니다. 테스트는 ''Standard Mode'', ''5초''로 하세요.', '프롬프트: 설명이 구체적일수록 좋습니다. "A girl walking"보다는 "Cinematic shot of a girl walking in Tokyo street, raining, neon lights, 4k, highly detailed"가 훨씬 잘 나옵니다.'],
    privacy_info = '{"description": "서버: 글로벌 버전은 해외 서버를 이용하나, 데이터 처리에 민감한 기업 정보는 입력하지 않는 것이 권장됩니다."}'::jsonb,
    alternatives = '[{"name": "Luma Dream Machine", "description": "대기 시간이 싫고 빠른 생성을 원한다면"}, {"name": "Runway Gen-3", "description": "더 정교한 제어(Motion Brush 등)가 필요하다면"}]'::jsonb,
    media_info = '[{"title": "Kling AI Official Global Launch", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "실사 영화 같은 고퀄리티 영상을 원하는 크리에이터"}'::jsonb,
    features = ARRAY['Text to Video', 'Image to Video', 'Extend Video', 'Camera Control', 'Professional Mode']
WHERE name = 'Kling AI';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Kling AI', '중국 콰이쇼우(Kuaishou)가 개발한 ''Sora 대항마''로, 최대 10초(유료)까지 생성 가능하며 인물의 자연스러운 움직임이 압도적인 영상 모델.', 'https://klingai.com/',
    'Credit-based (매일 무료 + 유료 구독)', '월 $10 (Standard / 연 결제 시 할인).', '매일 66 크레딧 무료 제공 (약 6개 영상). 단, 무료 사용자는 대기열이 길어 생성에 시간이 걸릴 수 있음.',
    '[{"plan": "Free", "target": "체험", "features": "66 크레딧/일, 워터마크, 5초 영상만 가능", "price": "무료"}, {"plan": "Standard", "target": "입문자", "features": "660 크레딧/월, 워터마크 제거, 10초 영상 가능", "price": "$10/월"}, {"plan": "Pro", "target": "전문가", "features": "3000 크레딧/월, 고성능 모드(Professional Mode)", "price": "$37/월"}]'::jsonb, ARRAY['리얼리즘: 현재 공개된 AI 중 인물의 걷는 모습, 표정, 음식을 먹는 장면 등이 가장 실제 촬영본과 흡사합니다. (불쾌한 골짜기가 적음).', '긴 지속 시간: 유료 플랜 사용 시 한 번에 10초 분량까지 생성할 수 있어 숏폼 제작에 유리합니다.', 'Camera Control: 카메라의 이동 경로(수평, 수직, 줌, 틸트)를 구체적으로 설정할 수 있습니다.', '매일 무료: 리필 안 되는 타사와 달리 매일 크레딧을 채워주는 혜자 정책입니다.'], ARRAY['대기 시간: 무료 사용자가 몰리면 영상 하나 만드는 데 몇 시간이 걸리기도 합니다.', '검열: 중국 서비스 특성상 특정 키워드나 정치적/사회적 이슈에 대한 검열이 있을 수 있습니다.'], '[{"name": "Text to Video", "description": "텍스트로 고화질 영상 생성 (High Quality Mode)"}, {"name": "Image to Video", "description": "이미지를 영상으로 변환 (일관성 우수)"}, {"name": "Extend Video", "description": "기존 영상을 5초씩 연장"}, {"name": "Camera Control", "description": "줌, 팬, 틸트, 롤 등 카메라 워킹 제어"}, {"name": "Professional Mode", "description": "더 긴 시간(10초)과 높은 퀄리티 제공 (유료)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 영화 제작", "reason": "시네마틱한 질감의 B-roll 소스가 필요한 편집자."}, {"target": "✅ 인물 영상", "reason": "사람이 걷거나 행동하는 장면을 자연스럽게 만들고 싶은 분."}, {"target": "✅ 무료 유저", "reason": "느려도 좋으니 매일 공짜로 만들어보고 싶은 분."}], "not_recommended": [{"target": "❌ 급한 성격", "reason": "유료 결제 안 하면 대기 시간이 답답해 죽을 수 있습니다."}, {"target": "❌ 텍스트 묘사", "reason": "영상 내에 글자가 정확히 나와야 한다면 아직 부족합니다."}]}'::jsonb, ARRAY['크레딧 소모: ''Professional Mode''나 ''10초 생성''을 체크하면 크레딧이 몇 배로 듭니다. 테스트는 ''Standard Mode'', ''5초''로 하세요.', '프롬프트: 설명이 구체적일수록 좋습니다. "A girl walking"보다는 "Cinematic shot of a girl walking in Tokyo street, raining, neon lights, 4k, highly detailed"가 훨씬 잘 나옵니다.'], '{"description": "서버: 글로벌 버전은 해외 서버를 이용하나, 데이터 처리에 민감한 기업 정보는 입력하지 않는 것이 권장됩니다."}'::jsonb,
    '[{"name": "Luma Dream Machine", "description": "대기 시간이 싫고 빠른 생성을 원한다면"}, {"name": "Runway Gen-3", "description": "더 정교한 제어(Motion Brush 등)가 필요하다면"}]'::jsonb, '[{"title": "Kling AI Official Global Launch", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "실사 영화 같은 고퀄리티 영상을 원하는 크리에이터"}'::jsonb,
    ARRAY['Text to Video', 'Image to Video', 'Extend Video', 'Camera Control', 'Professional Mode'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Kling AI');

UPDATE ai_models SET
    description = '틱톡(TikTok) 숏폼 편집의 제왕이자, ''대본만 주면 영상 완성'', ''AI 모델 입히기'' 등 커머스와 편집 자동화 기능이 강력한 올인원 에디터.',
    website_url = 'https://www.capcut.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $7.99 ~ $9.99 (CapCut Pro).',
    free_tier_note = '컷 편집, 자동 자막, 기본 AI 효과, 4K 내보내기 모두 무료. 워터마크 없음(엔딩 크레딧은 삭제 가능).',
    pricing_plans = '[{"plan": "Free", "target": "일반 유저", "features": "컷편집, 자동 자막, 텍스트 투 비디오, 4K 저장", "price": "무료"}, {"plan": "Pro", "target": "전문 크리에이터", "features": "AI 보컬 제거, 세밀한 피부 보정, Pro 효과/전환, 100GB 클라우드", "price": "$7.99/월"}]'::jsonb,
    pros = ARRAY['Script to Video: "다이어트 꿀팁 5가지 대본 써줘"라고 하면 대본 작성부터 어울리는 스톡 영상 매칭, 더빙, 자막까지 원클릭으로 만들어줍니다.', 'Long Video to Shorts: 긴 유튜브 가로 영상을 넣으면 AI가 하이라이트만 잘라서 세로 영상(Shorts) 여러 개로 만들어줍니다.', 'AI Model (Commerce): 옷 사진을 올리면 AI 모델이 그 옷을 입고 포즈를 취하는 착용 샷을 생성해 줍니다. (쇼핑몰 필수템).', '자동 자막: 한국어 음성 인식률이 매우 높고, 자막 디자인 템플릿이 트렌디합니다.'],
    cons = ARRAY['Pro 기능 구분: 쓰다 보면 예쁜 효과나 폰트는 "Pro" 딱지가 붙어 있어 결제를 유도합니다.', 'PC 용량: 데스크톱 버전은 기능이 많아질수록 프로그램이 무거워지고 사양을 탑니다.'],
    key_features = '[{"name": "Script to Video", "description": "대본 입력 시 영상+자막+더빙 자동 생성"}, {"name": "Long Video to Shorts", "description": "긴 영상을 숏폼으로 자동 재가공"}, {"name": "AI Model", "description": "의류 제품 사진을 AI 모델 착용샷으로 변환"}, {"name": "Auto Captions", "description": "고정확도 자동 자막 및 스타일링"}, {"name": "AI Character", "description": "말하는 3D/2D 캐릭터 아바타 삽입"}, {"name": "Vocal Isolation", "description": "배경음악과 목소리 분리 (Pro)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 숏폼 입문자", "reason": "편집 기술 없이 템플릿만으로 ''요즘 느낌'' 영상을 만들고 싶은 분."}, {"target": "✅ 쇼핑몰 운영", "reason": "마네킹에 입힌 옷을 AI 모델 착샷으로 바꾸고 싶은 분 (AI Model)."}, {"target": "✅ 자막 노가다 싫은 분", "reason": "버튼 한 번으로 자막 달고, 오타만 슥슥 고치면 끝."}], "not_recommended": [{"target": "❌ 방송급 편집", "reason": "프리미어 프로나 다빈치 리졸브 같은 세밀한 색보정/오디오 믹싱은 어렵습니다."}, {"target": "❌ 기업 보안", "reason": "틱톡(ByteDance) 계열이므로 사내 보안 규정이 엄격한 기업에서는 사용이 제한될 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['워터마크: 모바일 앱에서 영상 끝에 붙는 ''CapCut'' 로고는 터치해서 삭제할 수 있습니다. 굳이 남겨둘 필요 없습니다.', '저작권: 캡컷 내의 음악이나 템플릿은 캡컷/틱톡 내에서는 안전하지만, 유튜브 등 타 플랫폼 상업 이용 시 저작권 이슈가 있을 수 있으니 확인하세요.'],
    privacy_info = '{"description": "클라우드 동기화: 프로젝트가 클라우드에 자동 저장되므로, 공용 PC에서는 로그아웃을 꼭 하세요."}'::jsonb,
    alternatives = '[{"name": "Vrew", "description": "한국어 문서 편집 방식이 더 편하다면"}, {"name": "Premiere Pro", "description": "전문적인 편집 기능이 필요하다면"}]'::jsonb,
    media_info = '[{"title": "CapCut AI Features Overview", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "macOS", "iOS", "Android", "Web"], "target_audience": "틱톡/릴스/쇼츠 크리에이터, 쇼핑몰 사장님, 초보 편집자"}'::jsonb,
    features = ARRAY['Script to Video', 'Long Video to Shorts', 'AI Model', 'Auto Captions', 'AI Character', 'Vocal Isolation']
WHERE name = 'CapCut';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'CapCut', '틱톡(TikTok) 숏폼 편집의 제왕이자, ''대본만 주면 영상 완성'', ''AI 모델 입히기'' 등 커머스와 편집 자동화 기능이 강력한 올인원 에디터.', 'https://www.capcut.com/',
    'Freemium (무료 + 유료 구독)', '월 $7.99 ~ $9.99 (CapCut Pro).', '컷 편집, 자동 자막, 기본 AI 효과, 4K 내보내기 모두 무료. 워터마크 없음(엔딩 크레딧은 삭제 가능).',
    '[{"plan": "Free", "target": "일반 유저", "features": "컷편집, 자동 자막, 텍스트 투 비디오, 4K 저장", "price": "무료"}, {"plan": "Pro", "target": "전문 크리에이터", "features": "AI 보컬 제거, 세밀한 피부 보정, Pro 효과/전환, 100GB 클라우드", "price": "$7.99/월"}]'::jsonb, ARRAY['Script to Video: "다이어트 꿀팁 5가지 대본 써줘"라고 하면 대본 작성부터 어울리는 스톡 영상 매칭, 더빙, 자막까지 원클릭으로 만들어줍니다.', 'Long Video to Shorts: 긴 유튜브 가로 영상을 넣으면 AI가 하이라이트만 잘라서 세로 영상(Shorts) 여러 개로 만들어줍니다.', 'AI Model (Commerce): 옷 사진을 올리면 AI 모델이 그 옷을 입고 포즈를 취하는 착용 샷을 생성해 줍니다. (쇼핑몰 필수템).', '자동 자막: 한국어 음성 인식률이 매우 높고, 자막 디자인 템플릿이 트렌디합니다.'], ARRAY['Pro 기능 구분: 쓰다 보면 예쁜 효과나 폰트는 "Pro" 딱지가 붙어 있어 결제를 유도합니다.', 'PC 용량: 데스크톱 버전은 기능이 많아질수록 프로그램이 무거워지고 사양을 탑니다.'], '[{"name": "Script to Video", "description": "대본 입력 시 영상+자막+더빙 자동 생성"}, {"name": "Long Video to Shorts", "description": "긴 영상을 숏폼으로 자동 재가공"}, {"name": "AI Model", "description": "의류 제품 사진을 AI 모델 착용샷으로 변환"}, {"name": "Auto Captions", "description": "고정확도 자동 자막 및 스타일링"}, {"name": "AI Character", "description": "말하는 3D/2D 캐릭터 아바타 삽입"}, {"name": "Vocal Isolation", "description": "배경음악과 목소리 분리 (Pro)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 숏폼 입문자", "reason": "편집 기술 없이 템플릿만으로 ''요즘 느낌'' 영상을 만들고 싶은 분."}, {"target": "✅ 쇼핑몰 운영", "reason": "마네킹에 입힌 옷을 AI 모델 착샷으로 바꾸고 싶은 분 (AI Model)."}, {"target": "✅ 자막 노가다 싫은 분", "reason": "버튼 한 번으로 자막 달고, 오타만 슥슥 고치면 끝."}], "not_recommended": [{"target": "❌ 방송급 편집", "reason": "프리미어 프로나 다빈치 리졸브 같은 세밀한 색보정/오디오 믹싱은 어렵습니다."}, {"target": "❌ 기업 보안", "reason": "틱톡(ByteDance) 계열이므로 사내 보안 규정이 엄격한 기업에서는 사용이 제한될 수 있습니다."}]}'::jsonb, ARRAY['워터마크: 모바일 앱에서 영상 끝에 붙는 ''CapCut'' 로고는 터치해서 삭제할 수 있습니다. 굳이 남겨둘 필요 없습니다.', '저작권: 캡컷 내의 음악이나 템플릿은 캡컷/틱톡 내에서는 안전하지만, 유튜브 등 타 플랫폼 상업 이용 시 저작권 이슈가 있을 수 있으니 확인하세요.'], '{"description": "클라우드 동기화: 프로젝트가 클라우드에 자동 저장되므로, 공용 PC에서는 로그아웃을 꼭 하세요."}'::jsonb,
    '[{"name": "Vrew", "description": "한국어 문서 편집 방식이 더 편하다면"}, {"name": "Premiere Pro", "description": "전문적인 편집 기능이 필요하다면"}]'::jsonb, '[{"title": "CapCut AI Features Overview", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "macOS", "iOS", "Android", "Web"], "target_audience": "틱톡/릴스/쇼츠 크리에이터, 쇼핑몰 사장님, 초보 편집자"}'::jsonb,
    ARRAY['Script to Video', 'Long Video to Shorts', 'AI Model', 'Auto Captions', 'AI Character', 'Vocal Isolation'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'CapCut');

UPDATE ai_models SET
    description = '긴 유튜브 영상을 넣으면, AI가 ''가장 떡상할 만한(Viral)'' 하이라이트 구간을 찾아 세로형 숏폼으로 잘라주고 자막까지 달아주는 툴.',
    website_url = 'https://www.opus.pro/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $9 (Starter) / 월 $29 (Pro).',
    free_tier_note = '월 60분 영상 처리 무료. 워터마크 포함, 1080p 내보내기 불가.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "60분/월, 워터마크, 자동 자막", "price": "무료"}, {"plan": "Starter", "target": "개인", "features": "150분/월, 워터마크 제거, AI 큐레이션", "price": "$9/월"}, {"plan": "Pro", "target": "크리에이터", "features": "300분/월, 팀 협업, 프리미엄 템플릿, 4K", "price": "$29/월"}]'::jsonb,
    pros = ARRAY['Virality Score: AI가 영상을 분석해 "이 부분이 조회수가 잘 나올 것 같다"며 점수(99점 등)를 매겨줍니다.', 'Active Speaker: 화자가 여러 명일 때, 말하는 사람 얼굴을 자동으로 추적해서 화면 중앙에 맞춰줍니다 (Auto-reframing).', 'B-roll 추가: 말하는 내용에 맞춰 관련 자료 화면(이미지/영상)을 AI가 알아서 넣어 지루하지 않게 만듭니다.', '키워드 강조: 자막 중 핵심 키워드에 자동으로 색상을 입혀 가독성을 높여줍니다.'],
    cons = ARRAY['처리 시간: 긴 영상(1시간 이상)을 올리면 분석하는 데 시간이 꽤 걸립니다.', '한국어 밈: 한국 특유의 인터넷 밈이나 유행어를 완벽하게 캐치해서 자막을 달지는 못합니다.'],
    key_features = '[{"name": "AI Curation", "description": "하이라이트 구간 자동 추출 및 바이럴 점수 예측"}, {"name": "Auto Resize", "description": "가로 영상을 9:16 세로 영상으로 자동 변환 (화자 추적)"}, {"name": "AI Captions", "description": "애니메이션 자막 자동 생성 및 이모지 삽입"}, {"name": "AI B-roll", "description": "내용에 맞는 자료 화면 자동 삽입"}, {"name": "Social Scheduler", "description": "틱톡, 유튜브, 인스타로 바로 예약 업로드"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 팟캐스터", "reason": "1시간짜리 인터뷰 영상 하나로 쇼츠 10개를 뚝딱 만들고 싶은 분."}, {"target": "✅ 스트리머", "reason": "지난주 방송 다시보기를 숏폼으로 재가공해 틱톡에 올리고 싶은 분."}, {"target": "✅ 마케터", "reason": "CEO 연설이나 웨비나 영상에서 핵심 메시지만 뽑아 홍보하고 싶은 분."}], "not_recommended": [{"target": "❌ 브이로그", "reason": "대사가 별로 없고 분위기로 가는 영상은 AI가 하이라이트를 잘 못 잡습니다."}, {"target": "❌ 세밀한 편집", "reason": "컷 단위로 정교하게 다듬어야 한다면 캡컷이나 프리미어가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['크레딧: ''업로드한 영상 길이''만큼 크레딧이 차감됩니다. 1시간짜리 올리면 1시간 차감이니, 불필요한 부분은 미리 잘라내고 올리면 절약됩니다.', '언어 설정: 영상의 언어를 ''Korean''으로 설정해야 자막이 제대로 나옵니다.'],
    privacy_info = '{"description": "콘텐츠: 사용자가 업로드한 영상은 처리 후 일정 기간 보관되며, 개인정보 보호 정책에 따라 관리됩니다."}'::jsonb,
    alternatives = '[{"name": "Munch", "description": "마케팅 트렌드 분석 기능이 포함된 경쟁 툴"}, {"name": "Vizard", "description": "편집 기능이 좀 더 강화된 툴"}]'::jsonb,
    media_info = '[{"title": "Turn Long Videos into Viral Shorts with OpusClip", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "팟캐스트 운영자, 라이브 스트리머, 롱폼 유튜버"}'::jsonb,
    features = ARRAY['AI Curation', 'Auto Resize', 'AI Captions', 'AI B-roll', 'Social Scheduler']
WHERE name = 'Opus Clip';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Opus Clip', '긴 유튜브 영상을 넣으면, AI가 ''가장 떡상할 만한(Viral)'' 하이라이트 구간을 찾아 세로형 숏폼으로 잘라주고 자막까지 달아주는 툴.', 'https://www.opus.pro/',
    'Freemium (무료 + 유료 구독)', '월 $9 (Starter) / 월 $29 (Pro).', '월 60분 영상 처리 무료. 워터마크 포함, 1080p 내보내기 불가.',
    '[{"plan": "Free", "target": "체험", "features": "60분/월, 워터마크, 자동 자막", "price": "무료"}, {"plan": "Starter", "target": "개인", "features": "150분/월, 워터마크 제거, AI 큐레이션", "price": "$9/월"}, {"plan": "Pro", "target": "크리에이터", "features": "300분/월, 팀 협업, 프리미엄 템플릿, 4K", "price": "$29/월"}]'::jsonb, ARRAY['Virality Score: AI가 영상을 분석해 "이 부분이 조회수가 잘 나올 것 같다"며 점수(99점 등)를 매겨줍니다.', 'Active Speaker: 화자가 여러 명일 때, 말하는 사람 얼굴을 자동으로 추적해서 화면 중앙에 맞춰줍니다 (Auto-reframing).', 'B-roll 추가: 말하는 내용에 맞춰 관련 자료 화면(이미지/영상)을 AI가 알아서 넣어 지루하지 않게 만듭니다.', '키워드 강조: 자막 중 핵심 키워드에 자동으로 색상을 입혀 가독성을 높여줍니다.'], ARRAY['처리 시간: 긴 영상(1시간 이상)을 올리면 분석하는 데 시간이 꽤 걸립니다.', '한국어 밈: 한국 특유의 인터넷 밈이나 유행어를 완벽하게 캐치해서 자막을 달지는 못합니다.'], '[{"name": "AI Curation", "description": "하이라이트 구간 자동 추출 및 바이럴 점수 예측"}, {"name": "Auto Resize", "description": "가로 영상을 9:16 세로 영상으로 자동 변환 (화자 추적)"}, {"name": "AI Captions", "description": "애니메이션 자막 자동 생성 및 이모지 삽입"}, {"name": "AI B-roll", "description": "내용에 맞는 자료 화면 자동 삽입"}, {"name": "Social Scheduler", "description": "틱톡, 유튜브, 인스타로 바로 예약 업로드"}]'::jsonb,
    '{"recommended": [{"target": "✅ 팟캐스터", "reason": "1시간짜리 인터뷰 영상 하나로 쇼츠 10개를 뚝딱 만들고 싶은 분."}, {"target": "✅ 스트리머", "reason": "지난주 방송 다시보기를 숏폼으로 재가공해 틱톡에 올리고 싶은 분."}, {"target": "✅ 마케터", "reason": "CEO 연설이나 웨비나 영상에서 핵심 메시지만 뽑아 홍보하고 싶은 분."}], "not_recommended": [{"target": "❌ 브이로그", "reason": "대사가 별로 없고 분위기로 가는 영상은 AI가 하이라이트를 잘 못 잡습니다."}, {"target": "❌ 세밀한 편집", "reason": "컷 단위로 정교하게 다듬어야 한다면 캡컷이나 프리미어가 낫습니다."}]}'::jsonb, ARRAY['크레딧: ''업로드한 영상 길이''만큼 크레딧이 차감됩니다. 1시간짜리 올리면 1시간 차감이니, 불필요한 부분은 미리 잘라내고 올리면 절약됩니다.', '언어 설정: 영상의 언어를 ''Korean''으로 설정해야 자막이 제대로 나옵니다.'], '{"description": "콘텐츠: 사용자가 업로드한 영상은 처리 후 일정 기간 보관되며, 개인정보 보호 정책에 따라 관리됩니다."}'::jsonb,
    '[{"name": "Munch", "description": "마케팅 트렌드 분석 기능이 포함된 경쟁 툴"}, {"name": "Vizard", "description": "편집 기능이 좀 더 강화된 툴"}]'::jsonb, '[{"title": "Turn Long Videos into Viral Shorts with OpusClip", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "팟캐스트 운영자, 라이브 스트리머, 롱폼 유튜버"}'::jsonb,
    ARRAY['AI Curation', 'Auto Resize', 'AI Captions', 'AI B-roll', 'Social Scheduler'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Opus Clip');

UPDATE ai_models SET
    description = '내가 대충 그린 낙서를 실시간으로 고퀄리티 이미지로 바꿔주는 ''Real-time Generation'' 기능과 강력한 업스케일러를 갖춘 예술 AI.',
    website_url = 'https://www.krea.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $8 (Basic / 연 결제 시) ~ $24 (Pro).',
    free_tier_note = '매일 무료 생성량 제공 (약 50~60장 내외, 변동 가능). 실시간 생성 및 업스케일러 체험 가능.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "일일 제한적 생성, 기본 속도", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 36,000장(실시간), 500장(일반), 상업적 이용", "price": "$8/월"}, {"plan": "Pro", "target": "전문가", "features": "무제한 실시간 생성, 빠른 모드, 비공개 모드", "price": "$24/월"}]'::jsonb,
    pros = ARRAY['Real-time Generation: 캔버스에 동그라미 하나만 그려도 옆 화면에서 즉시 사과, 달, 공 등으로 변하는 속도가 경이롭습니다. (LCM 기술).', 'Upscaler & Enhancer: 흐릿한 저화질 사진을 넣으면 4K급으로 선명하게 복원해주고 디테일을 채워줍니다. (업계 최고 수준).', 'Patterns: 내 이름이나 로고 모양으로 숨은 그림 찾기 같은 패턴 이미지를 만들 수 있습니다.', 'Webcam Input: 웹캠으로 내 모습을 비추면 실시간으로 애니메이션 캐릭터나 조각상으로 바꿔줍니다.'],
    cons = ARRAY['디테일 제어: 미드저니만큼 프롬프트 하나하나를 완벽하게 따르기보다는, 실시간 변화의 ''우연성''이 강합니다.', '서버 부하: 사용자가 몰리면 실시간 생성 반응 속도가 느려질 수 있습니다.'],
    key_features = '[{"name": "Real-time Canvas", "description": "그리는 대로 변하는 실시간 생성"}, {"name": "AI Upscaler", "description": "이미지 해상도 및 디테일 향상"}, {"name": "Pattern Tool", "description": "로고나 텍스트를 이용한 착시 이미지 생성"}, {"name": "Logo Illusions", "description": "로고를 자연경관 등에 숨기는 기능"}, {"name": "Video Generation", "description": "(Beta) 키프레임 기반 비디오 생성"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 컨셉 아티스트", "reason": "아이디어 스케치 단계에서 빠르게 시안 100개를 보고 싶은 분."}, {"target": "✅ 아이패드 드로잉", "reason": "내 그림 실력을 AI가 보정해 주길 원하는 분 (화면 공유 등 활용)."}, {"target": "✅ 사진 보정", "reason": "옛날 디카로 찍은 사진을 고화질로 살리고 싶은 분 (Upscaler)."}], "not_recommended": [{"target": "❌ 정교한 텍스트", "reason": "이미지 안에 글자를 넣는 작업은 Ideogram이 낫습니다."}, {"target": "❌ 프롬프트 장인", "reason": "텍스트만으로 완벽한 통제를 원하면 Midjourney가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['무료 시간: 무료 사용자는 서버가 혼잡한 시간대(한국 기준 새벽 등)에 접속이 제한되거나 대기열이 길 수 있습니다.', '저장 필수: 실시간 생성 화면은 계속 변하므로, 마음에 드는 그림이 나오면 즉시 ''Quick Save''를 눌러야 합니다. 지나가면 다시 못 찾습니다.'],
    privacy_info = '{"description": "공개: 무료 및 Basic 플랜의 생성 이미지는 커뮤니티 피드에 공개될 수 있습니다. 비공개(Private)는 Pro 플랜부터 지원합니다."}'::jsonb,
    alternatives = '[{"name": "Leonardo.ai (Live Canvas)", "description": "비슷한 실시간 드로잉 기능을 제공"}, {"name": "Magnific AI", "description": "업스케일링 기능만 전문으로 하는 고성능(고가) 도구"}]'::jsonb,
    media_info = '[{"title": "Introducing Krea Real-time Generation", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "컨셉 디자이너, 일러스트레이터, 화질 개선이 필요한 사진가"}'::jsonb,
    features = ARRAY['Real-time Canvas', 'AI Upscaler', 'Pattern Tool', 'Logo Illusions', 'Video Generation']
WHERE name = 'Krea';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Krea', '내가 대충 그린 낙서를 실시간으로 고퀄리티 이미지로 바꿔주는 ''Real-time Generation'' 기능과 강력한 업스케일러를 갖춘 예술 AI.', 'https://www.krea.ai/',
    'Freemium (무료 + 유료 구독)', '월 $8 (Basic / 연 결제 시) ~ $24 (Pro).', '매일 무료 생성량 제공 (약 50~60장 내외, 변동 가능). 실시간 생성 및 업스케일러 체험 가능.',
    '[{"plan": "Free", "target": "체험", "features": "일일 제한적 생성, 기본 속도", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 36,000장(실시간), 500장(일반), 상업적 이용", "price": "$8/월"}, {"plan": "Pro", "target": "전문가", "features": "무제한 실시간 생성, 빠른 모드, 비공개 모드", "price": "$24/월"}]'::jsonb, ARRAY['Real-time Generation: 캔버스에 동그라미 하나만 그려도 옆 화면에서 즉시 사과, 달, 공 등으로 변하는 속도가 경이롭습니다. (LCM 기술).', 'Upscaler & Enhancer: 흐릿한 저화질 사진을 넣으면 4K급으로 선명하게 복원해주고 디테일을 채워줍니다. (업계 최고 수준).', 'Patterns: 내 이름이나 로고 모양으로 숨은 그림 찾기 같은 패턴 이미지를 만들 수 있습니다.', 'Webcam Input: 웹캠으로 내 모습을 비추면 실시간으로 애니메이션 캐릭터나 조각상으로 바꿔줍니다.'], ARRAY['디테일 제어: 미드저니만큼 프롬프트 하나하나를 완벽하게 따르기보다는, 실시간 변화의 ''우연성''이 강합니다.', '서버 부하: 사용자가 몰리면 실시간 생성 반응 속도가 느려질 수 있습니다.'], '[{"name": "Real-time Canvas", "description": "그리는 대로 변하는 실시간 생성"}, {"name": "AI Upscaler", "description": "이미지 해상도 및 디테일 향상"}, {"name": "Pattern Tool", "description": "로고나 텍스트를 이용한 착시 이미지 생성"}, {"name": "Logo Illusions", "description": "로고를 자연경관 등에 숨기는 기능"}, {"name": "Video Generation", "description": "(Beta) 키프레임 기반 비디오 생성"}]'::jsonb,
    '{"recommended": [{"target": "✅ 컨셉 아티스트", "reason": "아이디어 스케치 단계에서 빠르게 시안 100개를 보고 싶은 분."}, {"target": "✅ 아이패드 드로잉", "reason": "내 그림 실력을 AI가 보정해 주길 원하는 분 (화면 공유 등 활용)."}, {"target": "✅ 사진 보정", "reason": "옛날 디카로 찍은 사진을 고화질로 살리고 싶은 분 (Upscaler)."}], "not_recommended": [{"target": "❌ 정교한 텍스트", "reason": "이미지 안에 글자를 넣는 작업은 Ideogram이 낫습니다."}, {"target": "❌ 프롬프트 장인", "reason": "텍스트만으로 완벽한 통제를 원하면 Midjourney가 낫습니다."}]}'::jsonb, ARRAY['무료 시간: 무료 사용자는 서버가 혼잡한 시간대(한국 기준 새벽 등)에 접속이 제한되거나 대기열이 길 수 있습니다.', '저장 필수: 실시간 생성 화면은 계속 변하므로, 마음에 드는 그림이 나오면 즉시 ''Quick Save''를 눌러야 합니다. 지나가면 다시 못 찾습니다.'], '{"description": "공개: 무료 및 Basic 플랜의 생성 이미지는 커뮤니티 피드에 공개될 수 있습니다. 비공개(Private)는 Pro 플랜부터 지원합니다."}'::jsonb,
    '[{"name": "Leonardo.ai (Live Canvas)", "description": "비슷한 실시간 드로잉 기능을 제공"}, {"name": "Magnific AI", "description": "업스케일링 기능만 전문으로 하는 고성능(고가) 도구"}]'::jsonb, '[{"title": "Introducing Krea Real-time Generation", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "컨셉 디자이너, 일러스트레이터, 화질 개선이 필요한 사진가"}'::jsonb,
    ARRAY['Real-time Canvas', 'AI Upscaler', 'Pattern Tool', 'Logo Illusions', 'Video Generation'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Krea');

UPDATE ai_models SET
    description = '회사 이름과 업종만 입력하면 수백 가지 고퀄리티 로고 디자인을 제안하고, 명함·SNS 프로필 등 브랜드 키트까지 한 번에 만들어주는 AI 디자이너.',
    website_url = 'https://looka.com/',
    pricing_model = 'Freemium (무료 디자인 + 유료 다운로드)',
    pricing_info = '일회성 $20 (Basic Logo) / 구독형 $96/년 (Brand Kit).',
    free_tier_note = '로고 생성 및 수정 무제한 무료. (단, 워터마크 없는 고화질 파일 다운로드는 결제해야 함).',
    pricing_plans = '[{"plan": "Basic Logo", "target": "알뜰족", "features": "PNG 파일 1개 (투명 배경 X)", "price": "$20 (1회)"}, {"plan": "Premium Logo", "target": "실무자", "features": "고화질(SVG/EPS/PDF), 투명 배경, 평생 수정", "price": "$65 (1회)"}, {"plan": "Brand Kit", "target": "창업가", "features": "명함, SNS 프로필, 이메일 서명 등 300+ 템플릿", "price": "$96/년"}]'::jsonb,
    pros = ARRAY['디자인 퀄리티: 타 로고 생성기 대비 색감 배합과 심볼 매칭이 매우 세련되어 "디자이너가 만든 것 같은" 느낌을 줍니다.', 'Brand Kit: 로고만 딸랑 주는 게 아니라, 페이스북 커버, 인스타 프로필, 명함 시안까지 로고 색상에 맞춰 자동으로 생성해 줍니다.', 'Mockup: 간판에 걸렸을 때, 티셔츠에 인쇄했을 때 모습을 미리보기(Mockup)로 보여줘서 결정하기 쉽습니다.', '평생 수정(Premium): Premium 패키지 이상 구매 시, 구매 후에도 색상이나 폰트를 무제한으로 수정하고 다시 다운로드할 수 있습니다.'],
    cons = ARRAY['한글 폰트: 한글을 입력하면 굴림체 같은 기본 폰트로 나와서 안 예쁩니다. 영문 로고에 최적화되어 있습니다.', 'Basic 패키지: $20짜리 Basic 패키지는 배경 투명화가 안 된 파일 하나만 줘서 실무에 쓰기 어렵습니다. (최소 $65 권장).'],
    key_features = '[{"name": "AI Logo Generator", "description": "업종/취향 분석 기반 로고 생성"}, {"name": "Brand Kit Subscription", "description": "로고 기반의 마케팅 자료 300종 자동 생성"}, {"name": "Vector Files", "description": "인쇄용 고화질 파일(SVG, EPS) 제공 (Premium)"}, {"name": "Post-purchase Edits", "description": "구매 후에도 디자인 수정 가능"}, {"name": "Website Builder", "description": "생성된 브랜드 스타일을 적용한 웹사이트 제작"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 초기 창업자", "reason": "디자이너 고용할 돈은 없고, 5분 만에 그럴듯한 로고 세트를 맞추고 싶은 분."}, {"target": "✅ 영문 브랜드", "reason": "회사명이 영문이거나 이니셜 로고를 만드는 분."}, {"target": "✅ SNS 운영", "reason": "유튜브 채널 아트나 인스타 프로필까지 깔맞춤하고 싶은 분."}], "not_recommended": [{"target": "❌ 한글 로고", "reason": "\"김밥천국\"처럼 한글 캘리그라피가 중요한 로고는 못 만듭니다."}, {"target": "❌ 캐릭터 로고", "reason": "복잡한 마스코트 캐릭터를 직접 그려주지는 않습니다. (심볼 아이콘 조합 방식)."}]}'::jsonb,
    usage_tips = ARRAY['저작권 독점: Looka의 아이콘은 라이브러리에서 가져오는 것이라, 다른 회사와 심볼이 겹칠 수 있습니다. 상표권 등록 시 독점적 권리 주장이 어려울 수 있습니다.', '구독 주의: ''Brand Kit'' 플랜은 연간 구독입니다. 로고만 딱 하나 필요하면 ''Premium Logo Package($65)'' 일회성 결제를 선택하세요.'],
    privacy_info = '{"description": "공개 여부: 생성한 로고는 사용자가 구매하기 전까지 Looka 시스템에 저장됩니다."}'::jsonb,
    alternatives = '[{"name": "Brandmark", "description": "구독 없이 일회성 결제로 브랜드 가이드까지 받고 싶다면"}, {"name": "Canva", "description": "로고뿐만 아니라 다양한 디자인을 직접 수정하고 싶다면"}, {"name": "Ideogram", "description": "텍스트가 포함된 독창적인 엠블럼형 로고를 그리고 싶다면"}]'::jsonb,
    media_info = '[{"title": "How to Design a Logo with Looka", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "창업 초기 스타트업, 자영업자, 로고가 급히 필요한 유튜버"}'::jsonb,
    features = ARRAY['AI Logo Generator', 'Brand Kit Subscription', 'Vector Files', 'Post-purchase Edits', 'Website Builder']
WHERE name = 'Looka';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Looka', '회사 이름과 업종만 입력하면 수백 가지 고퀄리티 로고 디자인을 제안하고, 명함·SNS 프로필 등 브랜드 키트까지 한 번에 만들어주는 AI 디자이너.', 'https://looka.com/',
    'Freemium (무료 디자인 + 유료 다운로드)', '일회성 $20 (Basic Logo) / 구독형 $96/년 (Brand Kit).', '로고 생성 및 수정 무제한 무료. (단, 워터마크 없는 고화질 파일 다운로드는 결제해야 함).',
    '[{"plan": "Basic Logo", "target": "알뜰족", "features": "PNG 파일 1개 (투명 배경 X)", "price": "$20 (1회)"}, {"plan": "Premium Logo", "target": "실무자", "features": "고화질(SVG/EPS/PDF), 투명 배경, 평생 수정", "price": "$65 (1회)"}, {"plan": "Brand Kit", "target": "창업가", "features": "명함, SNS 프로필, 이메일 서명 등 300+ 템플릿", "price": "$96/년"}]'::jsonb, ARRAY['디자인 퀄리티: 타 로고 생성기 대비 색감 배합과 심볼 매칭이 매우 세련되어 "디자이너가 만든 것 같은" 느낌을 줍니다.', 'Brand Kit: 로고만 딸랑 주는 게 아니라, 페이스북 커버, 인스타 프로필, 명함 시안까지 로고 색상에 맞춰 자동으로 생성해 줍니다.', 'Mockup: 간판에 걸렸을 때, 티셔츠에 인쇄했을 때 모습을 미리보기(Mockup)로 보여줘서 결정하기 쉽습니다.', '평생 수정(Premium): Premium 패키지 이상 구매 시, 구매 후에도 색상이나 폰트를 무제한으로 수정하고 다시 다운로드할 수 있습니다.'], ARRAY['한글 폰트: 한글을 입력하면 굴림체 같은 기본 폰트로 나와서 안 예쁩니다. 영문 로고에 최적화되어 있습니다.', 'Basic 패키지: $20짜리 Basic 패키지는 배경 투명화가 안 된 파일 하나만 줘서 실무에 쓰기 어렵습니다. (최소 $65 권장).'], '[{"name": "AI Logo Generator", "description": "업종/취향 분석 기반 로고 생성"}, {"name": "Brand Kit Subscription", "description": "로고 기반의 마케팅 자료 300종 자동 생성"}, {"name": "Vector Files", "description": "인쇄용 고화질 파일(SVG, EPS) 제공 (Premium)"}, {"name": "Post-purchase Edits", "description": "구매 후에도 디자인 수정 가능"}, {"name": "Website Builder", "description": "생성된 브랜드 스타일을 적용한 웹사이트 제작"}]'::jsonb,
    '{"recommended": [{"target": "✅ 초기 창업자", "reason": "디자이너 고용할 돈은 없고, 5분 만에 그럴듯한 로고 세트를 맞추고 싶은 분."}, {"target": "✅ 영문 브랜드", "reason": "회사명이 영문이거나 이니셜 로고를 만드는 분."}, {"target": "✅ SNS 운영", "reason": "유튜브 채널 아트나 인스타 프로필까지 깔맞춤하고 싶은 분."}], "not_recommended": [{"target": "❌ 한글 로고", "reason": "\"김밥천국\"처럼 한글 캘리그라피가 중요한 로고는 못 만듭니다."}, {"target": "❌ 캐릭터 로고", "reason": "복잡한 마스코트 캐릭터를 직접 그려주지는 않습니다. (심볼 아이콘 조합 방식)."}]}'::jsonb, ARRAY['저작권 독점: Looka의 아이콘은 라이브러리에서 가져오는 것이라, 다른 회사와 심볼이 겹칠 수 있습니다. 상표권 등록 시 독점적 권리 주장이 어려울 수 있습니다.', '구독 주의: ''Brand Kit'' 플랜은 연간 구독입니다. 로고만 딱 하나 필요하면 ''Premium Logo Package($65)'' 일회성 결제를 선택하세요.'], '{"description": "공개 여부: 생성한 로고는 사용자가 구매하기 전까지 Looka 시스템에 저장됩니다."}'::jsonb,
    '[{"name": "Brandmark", "description": "구독 없이 일회성 결제로 브랜드 가이드까지 받고 싶다면"}, {"name": "Canva", "description": "로고뿐만 아니라 다양한 디자인을 직접 수정하고 싶다면"}, {"name": "Ideogram", "description": "텍스트가 포함된 독창적인 엠블럼형 로고를 그리고 싶다면"}]'::jsonb, '[{"title": "How to Design a Logo with Looka", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web"], "target_audience": "창업 초기 스타트업, 자영업자, 로고가 급히 필요한 유튜버"}'::jsonb,
    ARRAY['AI Logo Generator', 'Brand Kit Subscription', 'Vector Files', 'Post-purchase Edits', 'Website Builder'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Looka');

UPDATE ai_models SET
    description = '로고 디자인부터 브랜드 가이드라인, 명함, 소셜 미디어 그래픽까지 일회성 결제로 평생 소장할 수 있는 가성비 AI 로고 생성기.',
    website_url = 'https://brandmark.io/',
    pricing_model = 'One-time Payment (일회성 결제)',
    pricing_info = '일회성 $25 (Basic).',
    free_tier_note = '로고 생성, 색상/폰트 수정, 목업 확인까지 무료. 파일 다운로드 시 결제.',
    pricing_plans = '[{"plan": "Basic", "target": "개인", "features": "PNG 파일 (투명 배경 X)", "price": "$25 (1회)"}, {"plan": "Designer", "target": "창업가", "features": "소스 파일(EPS/SVG/PDF), 브랜드 가이드, 로고 수정", "price": "$65 (1회)"}, {"plan": "Enterprise", "target": "기업", "features": "디자이너 패키지 + 10개 오리지널 컨셉 디자인(사람 개입)", "price": "$175 (1회)"}]'::jsonb,
    pros = ARRAY['구독 없음 (No Subscription): Looka와 달리 브랜드 가이드나 명함 디자인을 받기 위해 매달 돈을 낼 필요가 없습니다. $65 한 번이면 끝입니다. (가장 큰 장점).', '디자인 스타일: 화려함보다는 심플하고 모던한 스타일의 로고를 아주 잘 뽑아냅니다.', 'Brand Guide: Designer($65) 플랜 구매 시, "어떤 폰트를 썼고, 색상 코드는 무엇인지" 정리된 PDF 브랜드 가이드북을 줍니다.', '무제한 수정: 구매 후에도 텍스트나 색상을 변경하고 다시 다운로드할 수 있습니다.'],
    cons = ARRAY['커스텀 한계: AI가 제안한 배치에서 아이콘 위치를 미세하게 1px 옮기는 식의 정밀 편집 기능은 다소 투박합니다.', '한글 폰트: 역시나 영문 폰트에 비해 한글 폰트 지원은 기본적입니다.'],
    key_features = '[{"name": "AI Logo Design", "description": "키워드 기반 로고 자동 생성"}, {"name": "Brand Guidelines", "description": "폰트/컬러 정보가 담긴 가이드북 제공 (Designer 이상)"}, {"name": "Social Media Kit", "description": "프로필, 커버 이미지 자동 리사이징"}, {"name": "Business Card", "description": "명함 디자인 템플릿 제공"}, {"name": "Source Files", "description": "인쇄 및 편집 가능한 벡터 파일(EPS, SVG) 제공"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 가성비 중시", "reason": "\"매달 나가는 돈 딱 질색이다\" 하시는 사장님."}, {"target": "✅ 패키지 필요", "reason": "로고 하나 샀는데 명함, 페이스북 커버, 레터헤드까지 몽땅 받고 싶은 분."}, {"target": "✅ 미니멀리즘", "reason": "IT 기업이나 스타트업 느낌의 깔끔한 로고를 원하시는 분."}], "not_recommended": [{"target": "❌ 화려한 일러스트", "reason": "복잡한 그림이나 3D 효과가 들어간 로고는 Ideogram이나 Midjourney로 가야 합니다."}]}'::jsonb,
    usage_tips = ARRAY['Basic vs Designer: $25짜리 Basic은 배경이 투명한 PNG를 안 줍니다. 인쇄소에 맡기거나 웹사이트에 예쁘게 넣으려면 무조건 $65 Designer 플랜을 사야 중복 지출을 막습니다.'],
    privacy_info = '{"description": "소유권: 구매한 디자인의 저작권은 사용자에게 귀속되나, 심볼 아이콘 자체는 비독점적일 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "Looka", "description": "구독형이지만 더 화려한 브랜드 키트 템플릿을 원한다면"}, {"name": "Hatchful (Shopify)", "description": "퀄리티는 낮지만 완전 무료 로고를 원한다면"}]'::jsonb,
    media_info = '[{"title": "Create a unique brand identity with Brandmark", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "None", "platforms": ["Web"], "target_audience": "월 구독료가 싫은 소상공인, 깔끔한 미니멀리즘 로고를 선호하는 분"}'::jsonb,
    features = ARRAY['AI Logo Design', 'Brand Guidelines', 'Social Media Kit', 'Business Card', 'Source Files']
WHERE name = 'Brandmark';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Brandmark', '로고 디자인부터 브랜드 가이드라인, 명함, 소셜 미디어 그래픽까지 일회성 결제로 평생 소장할 수 있는 가성비 AI 로고 생성기.', 'https://brandmark.io/',
    'One-time Payment (일회성 결제)', '일회성 $25 (Basic).', '로고 생성, 색상/폰트 수정, 목업 확인까지 무료. 파일 다운로드 시 결제.',
    '[{"plan": "Basic", "target": "개인", "features": "PNG 파일 (투명 배경 X)", "price": "$25 (1회)"}, {"plan": "Designer", "target": "창업가", "features": "소스 파일(EPS/SVG/PDF), 브랜드 가이드, 로고 수정", "price": "$65 (1회)"}, {"plan": "Enterprise", "target": "기업", "features": "디자이너 패키지 + 10개 오리지널 컨셉 디자인(사람 개입)", "price": "$175 (1회)"}]'::jsonb, ARRAY['구독 없음 (No Subscription): Looka와 달리 브랜드 가이드나 명함 디자인을 받기 위해 매달 돈을 낼 필요가 없습니다. $65 한 번이면 끝입니다. (가장 큰 장점).', '디자인 스타일: 화려함보다는 심플하고 모던한 스타일의 로고를 아주 잘 뽑아냅니다.', 'Brand Guide: Designer($65) 플랜 구매 시, "어떤 폰트를 썼고, 색상 코드는 무엇인지" 정리된 PDF 브랜드 가이드북을 줍니다.', '무제한 수정: 구매 후에도 텍스트나 색상을 변경하고 다시 다운로드할 수 있습니다.'], ARRAY['커스텀 한계: AI가 제안한 배치에서 아이콘 위치를 미세하게 1px 옮기는 식의 정밀 편집 기능은 다소 투박합니다.', '한글 폰트: 역시나 영문 폰트에 비해 한글 폰트 지원은 기본적입니다.'], '[{"name": "AI Logo Design", "description": "키워드 기반 로고 자동 생성"}, {"name": "Brand Guidelines", "description": "폰트/컬러 정보가 담긴 가이드북 제공 (Designer 이상)"}, {"name": "Social Media Kit", "description": "프로필, 커버 이미지 자동 리사이징"}, {"name": "Business Card", "description": "명함 디자인 템플릿 제공"}, {"name": "Source Files", "description": "인쇄 및 편집 가능한 벡터 파일(EPS, SVG) 제공"}]'::jsonb,
    '{"recommended": [{"target": "✅ 가성비 중시", "reason": "\"매달 나가는 돈 딱 질색이다\" 하시는 사장님."}, {"target": "✅ 패키지 필요", "reason": "로고 하나 샀는데 명함, 페이스북 커버, 레터헤드까지 몽땅 받고 싶은 분."}, {"target": "✅ 미니멀리즘", "reason": "IT 기업이나 스타트업 느낌의 깔끔한 로고를 원하시는 분."}], "not_recommended": [{"target": "❌ 화려한 일러스트", "reason": "복잡한 그림이나 3D 효과가 들어간 로고는 Ideogram이나 Midjourney로 가야 합니다."}]}'::jsonb, ARRAY['Basic vs Designer: $25짜리 Basic은 배경이 투명한 PNG를 안 줍니다. 인쇄소에 맡기거나 웹사이트에 예쁘게 넣으려면 무조건 $65 Designer 플랜을 사야 중복 지출을 막습니다.'], '{"description": "소유권: 구매한 디자인의 저작권은 사용자에게 귀속되나, 심볼 아이콘 자체는 비독점적일 수 있습니다."}'::jsonb,
    '[{"name": "Looka", "description": "구독형이지만 더 화려한 브랜드 키트 템플릿을 원한다면"}, {"name": "Hatchful (Shopify)", "description": "퀄리티는 낮지만 완전 무료 로고를 원한다면"}]'::jsonb, '[{"title": "Create a unique brand identity with Brandmark", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "None", "platforms": ["Web"], "target_audience": "월 구독료가 싫은 소상공인, 깔끔한 미니멀리즘 로고를 선호하는 분"}'::jsonb,
    ARRAY['AI Logo Design', 'Brand Guidelines', 'Social Media Kit', 'Business Card', 'Source Files'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Brandmark');

UPDATE ai_models SET
    description = '광고 배너와 카피를 대량으로 생성하고, AI가 미리 ''전환율(성과)''을 예측하여 클릭률 높은 광고 소재를 찾아주는 마케팅 자동화 툴.',
    website_url = 'https://www.adcreative.ai/',
    pricing_model = 'Subscription (구독형)',
    pricing_info = '월 $21 (Startup / 연 결제 시) ~ $141 (Professional).',
    free_tier_note = '7일 무료 체험(Trial) 제공. (가입 시 10 크레딧 제공, 이후 유료 전환).',
    pricing_plans = '[{"plan": "Startup", "target": "개인", "features": "10 크레딧/월, 1개 브랜드, 무제한 생성", "price": "$21/월"}, {"plan": "Professional", "target": "대행사", "features": "100 크레딧/월, 5개 브랜드, 팀원 초대", "price": "$141/월"}, {"plan": "Agency", "target": "기업", "features": "500 크레딧/월, 50개 브랜드, 화이트라벨링", "price": "$374/월"}]'::jsonb,
    pros = ARRAY['Conversion Score: 생성된 배너마다 AI가 "이 배너는 성과가 좋을 확률 90점" 식으로 점수를 매겨줍니다. (AB 테스트 비용 절감).', 'Mass Generation: 이미지 1장과 텍스트만 넣으면, 페이스북/인스타/구글/링크드인 사이즈별로 수백 개의 배너를 순식간에 만듭니다.', 'Competitor Insights: 경쟁사의 우수 광고 소재를 분석해 주는 기능이 있어 벤치마킹하기 좋습니다.', '연동성: 메타(Facebook), 구글 애즈 계정을 연동하면 성과 데이터를 학습해 더 정교한 소재를 추천합니다.'],
    cons = ARRAY['디자인 자유도: 템플릿 기반이라, 포토샵처럼 요소를 자유자재로 1px씩 옮기는 커스텀은 제한적입니다.', '비싼 가격: 크레딧(다운로드 횟수) 대비 월 구독료가 꽤 비싼 편입니다. ($141 플랜이 되어야 좀 쓸만함).', '자동 결제: 무료 체험 후 취소를 깜빡하면 고액이 결제될 수 있으니 주의해야 합니다.'],
    key_features = '[{"name": "Ad Creatives Generation", "description": "전환율 최적화된 배너 대량 생성"}, {"name": "Text Generator", "description": "고효율 광고 카피(헤드라인) 자동 작성"}, {"name": "Creative Scoring", "description": "광고 성과(CTR) 예측 점수 제공"}, {"name": "Social Creatives", "description": "인스타 스토리, 핀터레스트 등 SNS용 사이즈 자동 변환"}, {"name": "Competitor Intelligence", "description": "경쟁사 광고 분석"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 퍼포먼스 마케터", "reason": "하루에 배너 50개씩 세팅해서 효율 테스트를 돌려야 하는 분."}, {"target": "✅ 1인 셀러", "reason": "디자인 감각은 없는데 \"잘 팔리는\" 광고 이미지를 만들고 싶은 분."}, {"target": "✅ 대행사", "reason": "여러 클라이언트의 광고 소재를 빠르게 찍어내야 하는 팀."}], "not_recommended": [{"target": "❌ 브랜드 마케터", "reason": "감성적이고 예술적인, 딱 하나뿐인 고퀄리티 브랜드 이미지를 원한다면 맞지 않습니다. (효율 중심)."}, {"target": "❌ 소액 광고주", "reason": "월 광고비보다 툴 비용이 더 나올 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['크레딧 소모: ''생성''은 무제한이지만, 컴퓨터로 ''다운로드''할 때 크레딧이 차감됩니다. 맘에 드는 것만 신중하게 다운로드하세요.', '이미지 소스: 배경이 투명한 제품 누끼(PNG) 이미지를 준비해야 퀄리티가 훨씬 좋아집니다.'],
    privacy_info = '{"description": "데이터 활용: 연동된 광고 계정의 성과 데이터는 AI 모델 최적화에 사용될 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "Canva (Magic Design)", "description": "직접 디자인 수정이 편한 툴을 원한다면"}, {"name": "Creatopy", "description": "배너 자동화 및 애니메이션 기능이 강력한 툴"}]'::jsonb,
    media_info = '[{"title": "AdCreative.ai Demo - Generate High Converting Ads", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "퍼포먼스 마케터, 쇼핑몰 MD, 광고 대행사(Agency)"}'::jsonb,
    features = ARRAY['Ad Creatives Generation', 'Text Generator', 'Creative Scoring', 'Social Creatives', 'Competitor Intelligence']
WHERE name = 'AdCreative.ai';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'AdCreative.ai', '광고 배너와 카피를 대량으로 생성하고, AI가 미리 ''전환율(성과)''을 예측하여 클릭률 높은 광고 소재를 찾아주는 마케팅 자동화 툴.', 'https://www.adcreative.ai/',
    'Subscription (구독형)', '월 $21 (Startup / 연 결제 시) ~ $141 (Professional).', '7일 무료 체험(Trial) 제공. (가입 시 10 크레딧 제공, 이후 유료 전환).',
    '[{"plan": "Startup", "target": "개인", "features": "10 크레딧/월, 1개 브랜드, 무제한 생성", "price": "$21/월"}, {"plan": "Professional", "target": "대행사", "features": "100 크레딧/월, 5개 브랜드, 팀원 초대", "price": "$141/월"}, {"plan": "Agency", "target": "기업", "features": "500 크레딧/월, 50개 브랜드, 화이트라벨링", "price": "$374/월"}]'::jsonb, ARRAY['Conversion Score: 생성된 배너마다 AI가 "이 배너는 성과가 좋을 확률 90점" 식으로 점수를 매겨줍니다. (AB 테스트 비용 절감).', 'Mass Generation: 이미지 1장과 텍스트만 넣으면, 페이스북/인스타/구글/링크드인 사이즈별로 수백 개의 배너를 순식간에 만듭니다.', 'Competitor Insights: 경쟁사의 우수 광고 소재를 분석해 주는 기능이 있어 벤치마킹하기 좋습니다.', '연동성: 메타(Facebook), 구글 애즈 계정을 연동하면 성과 데이터를 학습해 더 정교한 소재를 추천합니다.'], ARRAY['디자인 자유도: 템플릿 기반이라, 포토샵처럼 요소를 자유자재로 1px씩 옮기는 커스텀은 제한적입니다.', '비싼 가격: 크레딧(다운로드 횟수) 대비 월 구독료가 꽤 비싼 편입니다. ($141 플랜이 되어야 좀 쓸만함).', '자동 결제: 무료 체험 후 취소를 깜빡하면 고액이 결제될 수 있으니 주의해야 합니다.'], '[{"name": "Ad Creatives Generation", "description": "전환율 최적화된 배너 대량 생성"}, {"name": "Text Generator", "description": "고효율 광고 카피(헤드라인) 자동 작성"}, {"name": "Creative Scoring", "description": "광고 성과(CTR) 예측 점수 제공"}, {"name": "Social Creatives", "description": "인스타 스토리, 핀터레스트 등 SNS용 사이즈 자동 변환"}, {"name": "Competitor Intelligence", "description": "경쟁사 광고 분석"}]'::jsonb,
    '{"recommended": [{"target": "✅ 퍼포먼스 마케터", "reason": "하루에 배너 50개씩 세팅해서 효율 테스트를 돌려야 하는 분."}, {"target": "✅ 1인 셀러", "reason": "디자인 감각은 없는데 \"잘 팔리는\" 광고 이미지를 만들고 싶은 분."}, {"target": "✅ 대행사", "reason": "여러 클라이언트의 광고 소재를 빠르게 찍어내야 하는 팀."}], "not_recommended": [{"target": "❌ 브랜드 마케터", "reason": "감성적이고 예술적인, 딱 하나뿐인 고퀄리티 브랜드 이미지를 원한다면 맞지 않습니다. (효율 중심)."}, {"target": "❌ 소액 광고주", "reason": "월 광고비보다 툴 비용이 더 나올 수 있습니다."}]}'::jsonb, ARRAY['크레딧 소모: ''생성''은 무제한이지만, 컴퓨터로 ''다운로드''할 때 크레딧이 차감됩니다. 맘에 드는 것만 신중하게 다운로드하세요.', '이미지 소스: 배경이 투명한 제품 누끼(PNG) 이미지를 준비해야 퀄리티가 훨씬 좋아집니다.'], '{"description": "데이터 활용: 연동된 광고 계정의 성과 데이터는 AI 모델 최적화에 사용될 수 있습니다."}'::jsonb,
    '[{"name": "Canva (Magic Design)", "description": "직접 디자인 수정이 편한 툴을 원한다면"}, {"name": "Creatopy", "description": "배너 자동화 및 애니메이션 기능이 강력한 툴"}]'::jsonb, '[{"title": "AdCreative.ai Demo - Generate High Converting Ads", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "퍼포먼스 마케터, 쇼핑몰 MD, 광고 대행사(Agency)"}'::jsonb,
    ARRAY['Ad Creatives Generation', 'Text Generator', 'Creative Scoring', 'Social Creatives', 'Competitor Intelligence'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'AdCreative.ai');

UPDATE ai_models SET
    description = 'Suno와 양대 산맥을 이루는 AI 음악 생성 서비스로, 특히 음질(Fidelity)과 보컬의 리얼함에서 뮤지션들에게 고평가받는 작곡 AI.',
    website_url = 'https://www.udio.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10 (Standard / 연 결제 시).',
    free_tier_note = '월 100 크레딧(약 10곡) 제공. 일일 추가 크레딧 제공 여부는 변동 가능. 상업적 이용 불가.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "100 크레딧/월, 상업적 이용 불가, 대기열 발생", "price": "무료"}, {"plan": "Standard", "target": "크리에이터", "features": "1,200 크레딧/월, 상업적 이용 허용, 우선 생성", "price": "$10/월"}, {"plan": "Pro", "target": "전문가", "features": "4,800 크레딧/월, Audio Inpainting, 2분 트랙 생성", "price": "$30/월"}]'::jsonb,
    pros = ARRAY['High Fidelity: 경쟁사(Suno)보다 음질이 깨끗하고 악기 분리도가 뛰어나다는 평이 많습니다. (전문가 취향).', 'V2 Model (최신): 최신 모델은 곡의 구조(Verse, Chorus)를 더 명확하게 이해하고, 스테레오감이 향상되었습니다.', 'Inpainting: 생성된 음악의 특정 구간만 선택해서 가사나 멜로디를 수정할 수 있는 기능이 강력합니다.', 'Context Window: 이전 맥락을 기억하는 능력이 좋아, 긴 곡을 만들 때 일관성이 잘 유지됩니다.'],
    cons = ARRAY['생성 시간: 고음질을 추구하다 보니 생성 속도가 Suno에 비해 다소 느릴 수 있습니다.', '가사 씹힘: 한국어 가사가 빠를 때 발음이 뭉개지거나 박자를 놓치는 경우가 간혹 발생합니다.', '난이도: "Manual Mode" 등 세부 설정이 많아 초보자에게는 Suno보다 조금 어렵게 느껴질 수 있습니다.'],
    key_features = '[{"name": "Text to Music", "description": "프롬프트로 고음질 음악 생성"}, {"name": "Remix & Extend", "description": "기존 곡을 변형하거나 길이를 연장 (최대 15분)"}, {"name": "Audio Inpainting", "description": "특정 구간 재생성 및 수정"}, {"name": "Manual Mode", "description": "프롬프트 제어를 위한 전문가 모드"}, {"name": "Stem Downloads", "description": "보컬/반주 분리 파일 다운로드 (Pro)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 음질 중요", "reason": "노이즈 없는 깔끔한 사운드가 최우선인 분."}, {"target": "✅ 디테일 수정", "reason": "곡의 일부만 고치는(Inpainting) 기능을 적극적으로 쓰고 싶은 분."}, {"target": "✅ 장르 실험", "reason": "복잡한 재즈나 클래식 등 악기 연주가 중요한 장르를 만들고 싶은 분."}], "not_recommended": [{"target": "❌ 빠른 생성", "reason": "1분 만에 뚝딱 만들고 싶다면 Suno가 더 빠르고 직관적일 수 있습니다."}, {"target": "❌ 완전 무료 상업", "reason": "무료 플랜 결과물은 저작권이 Udio에 있어 수익 창출이 불가능합니다."}]}'::jsonb,
    usage_tips = ARRAY['저작권: 무료 플랜에서 만든 곡을 유튜브에 올렸다가 나중에 "저작권 침해" 경고를 받을 수 있습니다. 유튜브용이라면 $10 결제가 마음 편합니다.', '가사 입력: 한국어 가사를 넣을 때 [Verse], [Chorus] 태그를 명확히 넣어줘야 AI가 구성을 이해합니다.'],
    privacy_info = '{"description": "권리: 유료 플랜 사용자는 생성된 음악의 저작권을 소유합니다."}'::jsonb,
    alternatives = '[{"name": "Suno", "description": "좀 더 대중적이고 보컬 곡(K-Pop) 생성에 강한 툴"}, {"name": "Stable Audio", "description": "효과음이나 짧은 루프 생성에 적합"}]'::jsonb,
    media_info = '[{"title": "Introducing Udio | Make Music", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "고음질 BGM이 필요한 크리에이터, 작곡 아이디어를 찾는 뮤지션"}'::jsonb,
    features = ARRAY['Text to Music', 'Remix & Extend', 'Audio Inpainting', 'Manual Mode', 'Stem Downloads']
WHERE name = 'Udio';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Udio', 'Suno와 양대 산맥을 이루는 AI 음악 생성 서비스로, 특히 음질(Fidelity)과 보컬의 리얼함에서 뮤지션들에게 고평가받는 작곡 AI.', 'https://www.udio.com/',
    'Freemium (무료 + 유료 구독)', '월 $10 (Standard / 연 결제 시).', '월 100 크레딧(약 10곡) 제공. 일일 추가 크레딧 제공 여부는 변동 가능. 상업적 이용 불가.',
    '[{"plan": "Free", "target": "체험", "features": "100 크레딧/월, 상업적 이용 불가, 대기열 발생", "price": "무료"}, {"plan": "Standard", "target": "크리에이터", "features": "1,200 크레딧/월, 상업적 이용 허용, 우선 생성", "price": "$10/월"}, {"plan": "Pro", "target": "전문가", "features": "4,800 크레딧/월, Audio Inpainting, 2분 트랙 생성", "price": "$30/월"}]'::jsonb, ARRAY['High Fidelity: 경쟁사(Suno)보다 음질이 깨끗하고 악기 분리도가 뛰어나다는 평이 많습니다. (전문가 취향).', 'V2 Model (최신): 최신 모델은 곡의 구조(Verse, Chorus)를 더 명확하게 이해하고, 스테레오감이 향상되었습니다.', 'Inpainting: 생성된 음악의 특정 구간만 선택해서 가사나 멜로디를 수정할 수 있는 기능이 강력합니다.', 'Context Window: 이전 맥락을 기억하는 능력이 좋아, 긴 곡을 만들 때 일관성이 잘 유지됩니다.'], ARRAY['생성 시간: 고음질을 추구하다 보니 생성 속도가 Suno에 비해 다소 느릴 수 있습니다.', '가사 씹힘: 한국어 가사가 빠를 때 발음이 뭉개지거나 박자를 놓치는 경우가 간혹 발생합니다.', '난이도: "Manual Mode" 등 세부 설정이 많아 초보자에게는 Suno보다 조금 어렵게 느껴질 수 있습니다.'], '[{"name": "Text to Music", "description": "프롬프트로 고음질 음악 생성"}, {"name": "Remix & Extend", "description": "기존 곡을 변형하거나 길이를 연장 (최대 15분)"}, {"name": "Audio Inpainting", "description": "특정 구간 재생성 및 수정"}, {"name": "Manual Mode", "description": "프롬프트 제어를 위한 전문가 모드"}, {"name": "Stem Downloads", "description": "보컬/반주 분리 파일 다운로드 (Pro)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 음질 중요", "reason": "노이즈 없는 깔끔한 사운드가 최우선인 분."}, {"target": "✅ 디테일 수정", "reason": "곡의 일부만 고치는(Inpainting) 기능을 적극적으로 쓰고 싶은 분."}, {"target": "✅ 장르 실험", "reason": "복잡한 재즈나 클래식 등 악기 연주가 중요한 장르를 만들고 싶은 분."}], "not_recommended": [{"target": "❌ 빠른 생성", "reason": "1분 만에 뚝딱 만들고 싶다면 Suno가 더 빠르고 직관적일 수 있습니다."}, {"target": "❌ 완전 무료 상업", "reason": "무료 플랜 결과물은 저작권이 Udio에 있어 수익 창출이 불가능합니다."}]}'::jsonb, ARRAY['저작권: 무료 플랜에서 만든 곡을 유튜브에 올렸다가 나중에 "저작권 침해" 경고를 받을 수 있습니다. 유튜브용이라면 $10 결제가 마음 편합니다.', '가사 입력: 한국어 가사를 넣을 때 [Verse], [Chorus] 태그를 명확히 넣어줘야 AI가 구성을 이해합니다.'], '{"description": "권리: 유료 플랜 사용자는 생성된 음악의 저작권을 소유합니다."}'::jsonb,
    '[{"name": "Suno", "description": "좀 더 대중적이고 보컬 곡(K-Pop) 생성에 강한 툴"}, {"name": "Stable Audio", "description": "효과음이나 짧은 루프 생성에 적합"}]'::jsonb, '[{"title": "Introducing Udio | Make Music", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "고음질 BGM이 필요한 크리에이터, 작곡 아이디어를 찾는 뮤지션"}'::jsonb,
    ARRAY['Text to Music', 'Remix & Extend', 'Audio Inpainting', 'Manual Mode', 'Stem Downloads'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Udio');

UPDATE ai_models SET
    description = '텍스트를 입력하면 스튜디오 품질의 AI 성우 목소리로 변환해주고, 영상 싱크까지 맞출 수 있는 올인원 AI 보이스오버 플랫폼.',
    website_url = 'https://murf.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $19 (Creator / 연 결제 시).',
    free_tier_note = '10분 분량의 음성 생성 및 듣기 무료. 단, 오디오 파일 다운로드 불가. (체험 전용).',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "10분 생성, 120+ 목소리, 다운로드 불가", "price": "무료"}, {"plan": "Creator", "target": "개인", "features": "24시간/년 생성, 상업적 이용, 무제한 다운로드", "price": "$19/월"}, {"plan": "Business", "target": "팀", "features": "96시간/년 생성, AI Voice Changer, 팀 협업", "price": "$29/월"}]'::jsonb,
    pros = ARRAY['자연스러움: 기계음 특유의 끊김이 적고, "Pitch(음정)", "Speed(속도)", "Pause(일시정지)"를 미세하게 조절해 진짜 사람처럼 만들 수 있습니다.', 'Video Sync: 단순 TTS가 아니라, 영상을 업로드하고 타임라인을 보면서 오디오 싱크를 맞출 수 있는 편집 툴이 내장되어 있습니다.', 'Canva 연동: 캔바 앱 내에서 바로 실행되므로, 캔바로 만든 카드뉴스에 내레이션을 입히기 매우 편합니다.', 'Voice Changer: 내 목소리로 대충 녹음한 파일을 올리면 전문 성우 목소리로 바꿔주는 기능이 있습니다. (Business).'],
    cons = ARRAY['무료 다운로드 불가: 무료 플랜에서는 열심히 만들어도 파일로 저장을 못 합니다. (화면 녹화로 따는 꼼수 외엔 결제 필수).', '생성 시간 제한: Creator 플랜도 연간 24시간 제한이 있어, 오디오북처럼 긴 작업을 많이 하면 부족할 수 있습니다.'],
    key_features = '[{"name": "Text to Speech", "description": "20개 언어, 120+ 성우 목소리 변환"}, {"name": "Voice Cloning", "description": "내 목소리 복제 (Custom Voice)"}, {"name": "Video over Voice", "description": "영상 타임라인에 맞춰 오디오 편집"}, {"name": "Voice Changer", "description": "녹음된 음성을 AI 성우로 변환"}, {"name": "Add-ons", "description": "Canva 및 Google Slides 통합 플러그인"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 이러닝 제작", "reason": "PPT 슬라이드마다 설명 내레이션을 넣어야 하는 강사님."}, {"target": "✅ 기업 홍보", "reason": "전문 성우 섭외 비용(수십만 원)을 아끼고 싶은 마케터."}, {"target": "✅ 캔바 유저", "reason": "캔바에서 만든 영상에 목소리가 필요하신 분."}], "not_recommended": [{"target": "❌ 무료 파일", "reason": "공짜로 MP3 파일을 받고 싶다면 ElevenLabs 무료 플랜이나 TTSMaker가 낫습니다."}, {"target": "❌ 실시간 대화", "reason": "실시간 스트리밍용 음성 변조 툴은 아닙니다."}]}'::jsonb,
    usage_tips = ARRAY['다운로드: "무료니까 써보자" 하고 다 만들었다가 다운로드 버튼 누르고 좌절하는 경우가 많습니다. 무료는 ''듣기''만 됩니다.', '강조하기: 특정 단어를 강조하고 싶으면 해당 단어 앞에 ''[Emphasis]'' 태그를 쓰거나 그래프를 조절해야 더 자연스럽습니다.'],
    privacy_info = '{"description": "보안: 데이터 암호화 및 2FA 인증을 지원하며, 사용자가 만든 오디오의 권리는 (유료 시) 사용자에게 있습니다."}'::jsonb,
    alternatives = '[{"name": "ElevenLabs", "description": "감정 표현이 더 풍부하고 무료 다운로드가 가능함"}, {"name": "Typecast", "description": "한국어 캐릭터와 연기 톤이 가장 다양한 국산 툴"}]'::jsonb,
    media_info = '[{"title": "Murf AI Studio Demo", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Canva Add-on", "Google Slides Add-on"], "target_audience": "이러닝 교육자, 기업 홍보 영상 제작자, 팟캐스터"}'::jsonb,
    features = ARRAY['Text to Speech', 'Voice Cloning', 'Video over Voice', 'Voice Changer', 'Add-ons']
WHERE name = 'Murf AI';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Murf AI', '텍스트를 입력하면 스튜디오 품질의 AI 성우 목소리로 변환해주고, 영상 싱크까지 맞출 수 있는 올인원 AI 보이스오버 플랫폼.', 'https://murf.ai/',
    'Freemium (무료 + 유료 구독)', '월 $19 (Creator / 연 결제 시).', '10분 분량의 음성 생성 및 듣기 무료. 단, 오디오 파일 다운로드 불가. (체험 전용).',
    '[{"plan": "Free", "target": "체험", "features": "10분 생성, 120+ 목소리, 다운로드 불가", "price": "무료"}, {"plan": "Creator", "target": "개인", "features": "24시간/년 생성, 상업적 이용, 무제한 다운로드", "price": "$19/월"}, {"plan": "Business", "target": "팀", "features": "96시간/년 생성, AI Voice Changer, 팀 협업", "price": "$29/월"}]'::jsonb, ARRAY['자연스러움: 기계음 특유의 끊김이 적고, "Pitch(음정)", "Speed(속도)", "Pause(일시정지)"를 미세하게 조절해 진짜 사람처럼 만들 수 있습니다.', 'Video Sync: 단순 TTS가 아니라, 영상을 업로드하고 타임라인을 보면서 오디오 싱크를 맞출 수 있는 편집 툴이 내장되어 있습니다.', 'Canva 연동: 캔바 앱 내에서 바로 실행되므로, 캔바로 만든 카드뉴스에 내레이션을 입히기 매우 편합니다.', 'Voice Changer: 내 목소리로 대충 녹음한 파일을 올리면 전문 성우 목소리로 바꿔주는 기능이 있습니다. (Business).'], ARRAY['무료 다운로드 불가: 무료 플랜에서는 열심히 만들어도 파일로 저장을 못 합니다. (화면 녹화로 따는 꼼수 외엔 결제 필수).', '생성 시간 제한: Creator 플랜도 연간 24시간 제한이 있어, 오디오북처럼 긴 작업을 많이 하면 부족할 수 있습니다.'], '[{"name": "Text to Speech", "description": "20개 언어, 120+ 성우 목소리 변환"}, {"name": "Voice Cloning", "description": "내 목소리 복제 (Custom Voice)"}, {"name": "Video over Voice", "description": "영상 타임라인에 맞춰 오디오 편집"}, {"name": "Voice Changer", "description": "녹음된 음성을 AI 성우로 변환"}, {"name": "Add-ons", "description": "Canva 및 Google Slides 통합 플러그인"}]'::jsonb,
    '{"recommended": [{"target": "✅ 이러닝 제작", "reason": "PPT 슬라이드마다 설명 내레이션을 넣어야 하는 강사님."}, {"target": "✅ 기업 홍보", "reason": "전문 성우 섭외 비용(수십만 원)을 아끼고 싶은 마케터."}, {"target": "✅ 캔바 유저", "reason": "캔바에서 만든 영상에 목소리가 필요하신 분."}], "not_recommended": [{"target": "❌ 무료 파일", "reason": "공짜로 MP3 파일을 받고 싶다면 ElevenLabs 무료 플랜이나 TTSMaker가 낫습니다."}, {"target": "❌ 실시간 대화", "reason": "실시간 스트리밍용 음성 변조 툴은 아닙니다."}]}'::jsonb, ARRAY['다운로드: "무료니까 써보자" 하고 다 만들었다가 다운로드 버튼 누르고 좌절하는 경우가 많습니다. 무료는 ''듣기''만 됩니다.', '강조하기: 특정 단어를 강조하고 싶으면 해당 단어 앞에 ''[Emphasis]'' 태그를 쓰거나 그래프를 조절해야 더 자연스럽습니다.'], '{"description": "보안: 데이터 암호화 및 2FA 인증을 지원하며, 사용자가 만든 오디오의 권리는 (유료 시) 사용자에게 있습니다."}'::jsonb,
    '[{"name": "ElevenLabs", "description": "감정 표현이 더 풍부하고 무료 다운로드가 가능함"}, {"name": "Typecast", "description": "한국어 캐릭터와 연기 톤이 가장 다양한 국산 툴"}]'::jsonb, '[{"title": "Murf AI Studio Demo", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Canva Add-on", "Google Slides Add-on"], "target_audience": "이러닝 교육자, 기업 홍보 영상 제작자, 팟캐스터"}'::jsonb,
    ARRAY['Text to Speech', 'Voice Cloning', 'Video over Voice', 'Voice Changer', 'Add-ons'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Murf AI');

UPDATE ai_models SET
    description = '"글자가 뭉개지지 않는 그림 AI" — 이미지 내에 정확한 텍스트(타이포그래피)를 삽입하는 능력이 독보적인 최신 이미지 생성 모델.',
    website_url = 'https://ideogram.ai/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $7 (Basic / 연 결제 시) ~ $16 (Plus).',
    free_tier_note = '하루 10~20장(4회 프롬프트) 정도 무료 생성 가능. (정책 변동 잦음). 대기열(Slow Queue) 적용. 생성물 공개.',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "일일 약 20장, JPG 다운로드, 공개 갤러리", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 400장, 우선 생성, PNG 다운로드", "price": "$7/월"}, {"plan": "Plus", "target": "디자이너", "features": "월 1,000장, 비공개 생성(Private), 이미지 에디터", "price": "$16/월"}]'::jsonb,
    pros = ARRAY['텍스트 렌더링: "카페 간판에 ''Coffee''라고 써줘"라고 했을 때, 스펠링 하나 안 틀리고 정확하게 써주는 능력은 미드저니보다 뛰어납니다. (가장 큰 강점).', 'Magic Prompt: 내가 "고양이"라고만 쳐도, AI가 알아서 "네온 사인이 반짝이는 미래 도시의 사이버펑크 고양이"처럼 프롬프트를 화려하게 업그레이드해 줍니다.', '다양한 비율: 16:9, 10:16 등 다양한 비율을 손쉽게 설정할 수 있습니다.', '최신 모델(v2.5/v3): 지속적인 업데이트로 실사 묘사 능력도 크게 향상되었습니다.'],
    cons = ARRAY['무료 제한: 무료 사용자는 이미지가 압축된 JPG로만 다운로드되어 인쇄용으로는 화질이 아쉽습니다. (유료는 PNG/WebP 지원).', '공개: 무료 및 Basic 플랜까지는 내 그림이 모두에게 공개됩니다. (비공개는 Plus부터).'],
    key_features = '[{"name": "Reliable Text", "description": "이미지 내 정확한 텍스트 렌더링"}, {"name": "Magic Prompt", "description": "프롬프트 자동 확장 및 개선"}, {"name": "Remix", "description": "기존 이미지를 바탕으로 변형 생성"}, {"name": "Image Weight", "description": "참조 이미지의 영향력 조절"}, {"name": "Editor", "description": "생성된 이미지의 색상이나 텍스트 수정 (Plus)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 로고/엠블럼", "reason": "회사 이름이 박힌 로고를 만들고 싶은 분."}, {"target": "✅ POD 사업", "reason": "티셔츠나 머그컵에 들어갈 레터링 디자인을 뽑아야 하는 셀러."}, {"target": "✅ 포스터/표지", "reason": "제목이 들어간 유튜브 썸네일이나 책 표지 시안 작업."}], "not_recommended": [{"target": "❌ 초고해상도 실사", "reason": "인물 사진의 피부 질감 등은 아직 Midjourney v6가 더 우위일 수 있습니다."}, {"target": "❌ 한글 텍스트", "reason": "한글은 아직 못 씁니다. 영어 텍스트만 완벽하게 지원합니다."}]}'::jsonb,
    usage_tips = ARRAY['텍스트 입력: 이미지에 넣고 싶은 글자는 반드시 큰따옴표("")로 묶어서 적어주세요. 예: text "Hello World".', '다운로드: 무료 버전의 JPG는 화질이 낮습니다. 상업용 굿즈 제작이 목적이라면 한 달만이라도 Basic($7)을 써서 PNG로 받는 게 좋습니다.'],
    privacy_info = '{"description": "공개 갤러리: 무료/Basic 사용자의 프롬프트와 결과물은 갤러리에 공개되어 남들이 볼 수 있고 따라 할 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "DALL-E 3", "description": "텍스트 묘사력이 좋고 대화형 수정이 편함"}, {"name": "Midjourney", "description": "텍스트보다는 그림 자체의 예술성이 더 중요하다면"}]'::jsonb,
    media_info = '[{"title": "Ideogram 2.0: The Future of Text in AI Images", "url": "https://www.youtube.com/ (공식/리뷰 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "로고 디자이너, 티셔츠/굿즈 제작자, 포스터 디자이너"}'::jsonb,
    features = ARRAY['Reliable Text', 'Magic Prompt', 'Remix', 'Image Weight', 'Editor']
WHERE name = 'Ideogram';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Ideogram', '"글자가 뭉개지지 않는 그림 AI" — 이미지 내에 정확한 텍스트(타이포그래피)를 삽입하는 능력이 독보적인 최신 이미지 생성 모델.', 'https://ideogram.ai/',
    'Freemium (무료 + 유료 구독)', '월 $7 (Basic / 연 결제 시) ~ $16 (Plus).', '하루 10~20장(4회 프롬프트) 정도 무료 생성 가능. (정책 변동 잦음). 대기열(Slow Queue) 적용. 생성물 공개.',
    '[{"plan": "Free", "target": "찍먹파", "features": "일일 약 20장, JPG 다운로드, 공개 갤러리", "price": "무료"}, {"plan": "Basic", "target": "개인", "features": "월 400장, 우선 생성, PNG 다운로드", "price": "$7/월"}, {"plan": "Plus", "target": "디자이너", "features": "월 1,000장, 비공개 생성(Private), 이미지 에디터", "price": "$16/월"}]'::jsonb, ARRAY['텍스트 렌더링: "카페 간판에 ''Coffee''라고 써줘"라고 했을 때, 스펠링 하나 안 틀리고 정확하게 써주는 능력은 미드저니보다 뛰어납니다. (가장 큰 강점).', 'Magic Prompt: 내가 "고양이"라고만 쳐도, AI가 알아서 "네온 사인이 반짝이는 미래 도시의 사이버펑크 고양이"처럼 프롬프트를 화려하게 업그레이드해 줍니다.', '다양한 비율: 16:9, 10:16 등 다양한 비율을 손쉽게 설정할 수 있습니다.', '최신 모델(v2.5/v3): 지속적인 업데이트로 실사 묘사 능력도 크게 향상되었습니다.'], ARRAY['무료 제한: 무료 사용자는 이미지가 압축된 JPG로만 다운로드되어 인쇄용으로는 화질이 아쉽습니다. (유료는 PNG/WebP 지원).', '공개: 무료 및 Basic 플랜까지는 내 그림이 모두에게 공개됩니다. (비공개는 Plus부터).'], '[{"name": "Reliable Text", "description": "이미지 내 정확한 텍스트 렌더링"}, {"name": "Magic Prompt", "description": "프롬프트 자동 확장 및 개선"}, {"name": "Remix", "description": "기존 이미지를 바탕으로 변형 생성"}, {"name": "Image Weight", "description": "참조 이미지의 영향력 조절"}, {"name": "Editor", "description": "생성된 이미지의 색상이나 텍스트 수정 (Plus)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 로고/엠블럼", "reason": "회사 이름이 박힌 로고를 만들고 싶은 분."}, {"target": "✅ POD 사업", "reason": "티셔츠나 머그컵에 들어갈 레터링 디자인을 뽑아야 하는 셀러."}, {"target": "✅ 포스터/표지", "reason": "제목이 들어간 유튜브 썸네일이나 책 표지 시안 작업."}], "not_recommended": [{"target": "❌ 초고해상도 실사", "reason": "인물 사진의 피부 질감 등은 아직 Midjourney v6가 더 우위일 수 있습니다."}, {"target": "❌ 한글 텍스트", "reason": "한글은 아직 못 씁니다. 영어 텍스트만 완벽하게 지원합니다."}]}'::jsonb, ARRAY['텍스트 입력: 이미지에 넣고 싶은 글자는 반드시 큰따옴표("")로 묶어서 적어주세요. 예: text "Hello World".', '다운로드: 무료 버전의 JPG는 화질이 낮습니다. 상업용 굿즈 제작이 목적이라면 한 달만이라도 Basic($7)을 써서 PNG로 받는 게 좋습니다.'], '{"description": "공개 갤러리: 무료/Basic 사용자의 프롬프트와 결과물은 갤러리에 공개되어 남들이 볼 수 있고 따라 할 수 있습니다."}'::jsonb,
    '[{"name": "DALL-E 3", "description": "텍스트 묘사력이 좋고 대화형 수정이 편함"}, {"name": "Midjourney", "description": "텍스트보다는 그림 자체의 예술성이 더 중요하다면"}]'::jsonb, '[{"title": "Ideogram 2.0: The Future of Text in AI Images", "url": "https://www.youtube.com/ (공식/리뷰 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "로고 디자이너, 티셔츠/굿즈 제작자, 포스터 디자이너"}'::jsonb,
    ARRAY['Reliable Text', 'Magic Prompt', 'Remix', 'Image Weight', 'Editor'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Ideogram');

UPDATE ai_models SET
    description = '영상/음성 편집을 워드 문서 편집하듯이 텍스트를 지우고 고치면 원본 미디어도 함께 수정되는 "문서 기반" 올인원 편집기.',
    website_url = 'https://www.descript.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $12 (Creator / 연 결제 시) ~ $24 (Pro).',
    free_tier_note = '월 1시간 분량의 전사(Transcript) 및 내보내기 무료. (워터마크 없음, 720p 제한).',
    pricing_plans = '[{"plan": "Free", "target": "입문자", "features": "월 1시간, 720p, 기본 AI 기능", "price": "무료"}, {"plan": "Creator", "target": "팟캐스터", "features": "월 10시간, 4K 내보내기, 워터마크 제거", "price": "$12/월"}, {"plan": "Pro", "target": "유튜버", "features": "월 30시간, Underlord(AI 비서) 무제한, 오버덥", "price": "$24/월"}]'::jsonb,
    pros = ARRAY['텍스트 편집 방식: 오디오 파형(Waveform)을 몰라도, 스크립트에서 "음..."이나 틀린 단어를 지우면 영상에서도 그 부분이 컷편집됩니다.', 'Underlord (AI): 2024/25 업데이트로 추가된 AI 비서 ''Underlord''가 편집, 클립 생성, 자막, 사운드 보정까지 알아서 다 해줍니다.', 'Studio Sound: 시끄러운 카페에서 녹음한 소리도 스튜디오 마이크로 녹음한 것처럼 노이즈를 완벽하게 제거하고 음질을 향상시킵니다. (업계 최고 수준).', 'Overdub: 내 목소리를 학습시켜, 텍스트를 타이핑하면 내 목소리로 더빙을 생성해 끼워 넣을 수 있습니다. (재녹음 불필요).'],
    cons = ARRAY['한글 오타: 한국어 인식률이 좋아졌지만, 여전히 고유명사 등은 오타가 나며 이를 수정하는 과정이 필요합니다.', '무거운 앱: 클라우드 기반이지만 로컬 리소스를 꽤 사용하여, 긴 영상을 작업할 때 프로그램이 무거워질 수 있습니다.'],
    key_features = '[{"name": "Text-Based Editing", "description": "텍스트 수정으로 영상/음성 컷편집"}, {"name": "Underlord AI", "description": "자동 멀티캠 전환, 챕터 생성, 쇼츠 제작 비서"}, {"name": "Studio Sound", "description": "원클릭 노이즈 캔슬링 및 음질 향상"}, {"name": "Overdub", "description": "텍스트 입력으로 내 목소리 생성 (Voice Clone)"}, {"name": "Eye Contact", "description": "대본을 보느라 눈이 다른 곳을 봐도 카메라를 보는 것처럼 보정"}, {"name": "Filler Word Removal", "description": "\"음\", \"아\", \"Uh\" 같은 추임새 일괄 삭제"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 인터뷰 편집", "reason": "1시간짜리 인터뷰에서 불필요한 잡담을 텍스트 보면서 빠르게 쳐내고 싶은 분."}, {"target": "✅ 오디오 품질", "reason": "마이크 장비가 안 좋아서 AI의 힘(Studio Sound)으로 음질을 살려야 하는 분."}, {"target": "✅ 팟캐스트", "reason": "음성 편집과 자막 생성을 한 번에 끝내고 싶은 분."}], "not_recommended": [{"target": "❌ 화려한 예능", "reason": "자막이 날아다니고 특수 효과가 많은 한국 예능 스타일 편집에는 프리미어 프로가 낫습니다."}, {"target": "❌ 정밀 프레임", "reason": "0.1초 단위의 미세한 프레임 조절보다는 내용 위주의 컷편집에 최적화되어 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['원본 보존: 텍스트를 지우면 원본 미디어도 삭제(비파괴)되지만, 실수로 지웠다면 `Cmd+Z`로 살리거나 스크립트 복구 기능을 써야 합니다.', '내보내기 시간: 클라우드 렌더링 방식이라 내보내기(Export) 버튼을 누르고 링크가 생성될 때까지 시간이 좀 걸릴 수 있습니다.'],
    privacy_info = '{"description": "목소리 보안: Overdub용 목소리 데이터는 본인의 동의 낭독 스크립트가 있어야만 생성 가능하며, 보안 철칙을 따릅니다."}'::jsonb,
    alternatives = '[{"name": "Vrew", "description": "한국어 자막 및 컷편집에 더 특화된 국산 툴 (무료 범위 넓음)"}, {"name": "Premiere Pro (Text-based)", "description": "어도비 유저라면 내장 기능을 쓰는 게 나을 수 있음"}]'::jsonb,
    media_info = '[{"title": "Meet Descript: The All-in-One Video & Audio Editor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Desktop App (Mac", "Windows)", "Web (일부 기능)"], "target_audience": "팟캐스터, 인터뷰 영상 편집자, 유튜브 크리에이터"}'::jsonb,
    features = ARRAY['Text-Based Editing', 'Underlord AI', 'Studio Sound', 'Overdub', 'Eye Contact', 'Filler Word Removal']
WHERE name = 'Descript';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Descript', '영상/음성 편집을 워드 문서 편집하듯이 텍스트를 지우고 고치면 원본 미디어도 함께 수정되는 "문서 기반" 올인원 편집기.', 'https://www.descript.com/',
    'Freemium (무료 + 유료 구독)', '월 $12 (Creator / 연 결제 시) ~ $24 (Pro).', '월 1시간 분량의 전사(Transcript) 및 내보내기 무료. (워터마크 없음, 720p 제한).',
    '[{"plan": "Free", "target": "입문자", "features": "월 1시간, 720p, 기본 AI 기능", "price": "무료"}, {"plan": "Creator", "target": "팟캐스터", "features": "월 10시간, 4K 내보내기, 워터마크 제거", "price": "$12/월"}, {"plan": "Pro", "target": "유튜버", "features": "월 30시간, Underlord(AI 비서) 무제한, 오버덥", "price": "$24/월"}]'::jsonb, ARRAY['텍스트 편집 방식: 오디오 파형(Waveform)을 몰라도, 스크립트에서 "음..."이나 틀린 단어를 지우면 영상에서도 그 부분이 컷편집됩니다.', 'Underlord (AI): 2024/25 업데이트로 추가된 AI 비서 ''Underlord''가 편집, 클립 생성, 자막, 사운드 보정까지 알아서 다 해줍니다.', 'Studio Sound: 시끄러운 카페에서 녹음한 소리도 스튜디오 마이크로 녹음한 것처럼 노이즈를 완벽하게 제거하고 음질을 향상시킵니다. (업계 최고 수준).', 'Overdub: 내 목소리를 학습시켜, 텍스트를 타이핑하면 내 목소리로 더빙을 생성해 끼워 넣을 수 있습니다. (재녹음 불필요).'], ARRAY['한글 오타: 한국어 인식률이 좋아졌지만, 여전히 고유명사 등은 오타가 나며 이를 수정하는 과정이 필요합니다.', '무거운 앱: 클라우드 기반이지만 로컬 리소스를 꽤 사용하여, 긴 영상을 작업할 때 프로그램이 무거워질 수 있습니다.'], '[{"name": "Text-Based Editing", "description": "텍스트 수정으로 영상/음성 컷편집"}, {"name": "Underlord AI", "description": "자동 멀티캠 전환, 챕터 생성, 쇼츠 제작 비서"}, {"name": "Studio Sound", "description": "원클릭 노이즈 캔슬링 및 음질 향상"}, {"name": "Overdub", "description": "텍스트 입력으로 내 목소리 생성 (Voice Clone)"}, {"name": "Eye Contact", "description": "대본을 보느라 눈이 다른 곳을 봐도 카메라를 보는 것처럼 보정"}, {"name": "Filler Word Removal", "description": "\"음\", \"아\", \"Uh\" 같은 추임새 일괄 삭제"}]'::jsonb,
    '{"recommended": [{"target": "✅ 인터뷰 편집", "reason": "1시간짜리 인터뷰에서 불필요한 잡담을 텍스트 보면서 빠르게 쳐내고 싶은 분."}, {"target": "✅ 오디오 품질", "reason": "마이크 장비가 안 좋아서 AI의 힘(Studio Sound)으로 음질을 살려야 하는 분."}, {"target": "✅ 팟캐스트", "reason": "음성 편집과 자막 생성을 한 번에 끝내고 싶은 분."}], "not_recommended": [{"target": "❌ 화려한 예능", "reason": "자막이 날아다니고 특수 효과가 많은 한국 예능 스타일 편집에는 프리미어 프로가 낫습니다."}, {"target": "❌ 정밀 프레임", "reason": "0.1초 단위의 미세한 프레임 조절보다는 내용 위주의 컷편집에 최적화되어 있습니다."}]}'::jsonb, ARRAY['원본 보존: 텍스트를 지우면 원본 미디어도 삭제(비파괴)되지만, 실수로 지웠다면 `Cmd+Z`로 살리거나 스크립트 복구 기능을 써야 합니다.', '내보내기 시간: 클라우드 렌더링 방식이라 내보내기(Export) 버튼을 누르고 링크가 생성될 때까지 시간이 좀 걸릴 수 있습니다.'], '{"description": "목소리 보안: Overdub용 목소리 데이터는 본인의 동의 낭독 스크립트가 있어야만 생성 가능하며, 보안 철칙을 따릅니다."}'::jsonb,
    '[{"name": "Vrew", "description": "한국어 자막 및 컷편집에 더 특화된 국산 툴 (무료 범위 넓음)"}, {"name": "Premiere Pro (Text-based)", "description": "어도비 유저라면 내장 기능을 쓰는 게 나을 수 있음"}]'::jsonb, '[{"title": "Meet Descript: The All-in-One Video & Audio Editor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Desktop App (Mac", "Windows)", "Web (일부 기능)"], "target_audience": "팟캐스터, 인터뷰 영상 편집자, 유튜브 크리에이터"}'::jsonb,
    ARRAY['Text-Based Editing', 'Underlord AI', 'Studio Sound', 'Overdub', 'Eye Contact', 'Filler Word Removal'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Descript');

UPDATE ai_models SET
    description = 'AI 코딩 도구의 강자 Codeium이 만든 차세대 IDE로, 개발자의 의도와 코드 흐름(Flow)을 깊이 이해하는 ''Cascades'' 기능이 핵심인 에디터.',
    website_url = 'https://codeium.com/windsurf',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $10 ~ $15 (Pro / 사용자당). (경쟁사 대비 저렴한 편).',
    free_tier_note = '개인 사용자 영구 무료. (고속 모델 사용량 제한은 있으나, 기본 모델은 무제한급).',
    pricing_plans = '[{"plan": "Individual", "target": "개인 개발자", "features": "Flows/Cascades 무료, 기본 모델 무제한, 고급 모델 제한적", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "GPT-4o/Claude 3.5 무제한급, 우선 지원, 더 긴 컨텍스트", "price": "$15/월"}, {"plan": "Teams", "target": "조직", "features": "데이터 프라이버시(Zero Retention), 라이선스 관리", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['Cascades (Flows): Cursor의 Composer와 비슷하지만, ''코드의 문맥(Context)''을 파악하는 깊이가 다릅니다. 변수 하나를 고치면 연관된 파일들까지 AI가 알아서 추적해 수정 제안을 합니다.', 'Deep Context: 단순히 현재 열린 파일뿐만 아니라, 전체 프로젝트 구조를 이해하고 답변하는 능력이 탁월합니다.', 'VS Code 100% 호환: VS Code를 포크(Fork)해서 만들었기 때문에 기존 확장 프로그램과 단축키를 그대로 쓸 수 있습니다.', '가격 정책: 경쟁사(Cursor, Copilot)가 월 $20인 데 비해, 무료 플랜이 훨씬 혜자롭고 유료도 저렴한 편입니다.'],
    cons = ARRAY['인지도: Cursor에 비해 늦게 주목받아 커뮤니티나 튜토리얼 자료가 상대적으로 적습니다.', '무거운 구동: 깊은 문맥 분석을 위해 리소스를 많이 사용하여, 저사양 PC에서는 인덱싱 때 버벅거릴 수 있습니다.'],
    key_features = '[{"name": "Cascades", "description": "여러 파일에 걸친 변경 사항을 AI가 주도적으로 수행 (Agentic)"}, {"name": "Supercomplete", "description": "단순 자동 완성을 넘어 다음 로직까지 예측해 미리 작성"}, {"name": "Context-Aware Chat", "description": "프로젝트 전체 맥락을 이해하는 사이드바 채팅"}, {"name": "Terminal AI", "description": "터미널 명령어를 자연어로 변환 및 실행"}, {"name": "Model Selection", "description": "GPT-4o, Claude 3.5 Sonnet 등 최신 모델 선택 가능"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ Cursor 대안", "reason": "Cursor의 $20 구독료가 부담스럽거나 무료 사용량이 부족한 분."}, {"target": "✅ 복잡한 프로젝트", "reason": "파일 간 의존성이 복잡해서 \"이거 고치면 저게 터지는\" 경험을 자주 하는 개발자 (Cascades)."}, {"target": "✅ 개인 개발자", "reason": "혼자서 풀스택 개발을 하며 AI의 도움이 많이 필요한 분."}], "not_recommended": [{"target": "❌ JetBrains 유저", "reason": "IntelliJ나 PyCharm의 단축키/UI에 익숙하다면 VS Code 기반이 불편할 수 있습니다."}, {"target": "❌ 폐쇄망", "reason": "클라우드 AI 연결이 필수라 오프라인 환경에서는 제한적입니다."}]}'::jsonb,
    usage_tips = ARRAY['인덱싱: 프로젝트를 처음 열면 우측 하단에 인덱싱 바가 돌아갑니다. 이게 끝나야 AI가 똑똑해지니 조금 기다리세요.', '단축키: `Cmd+I` (또는 설정된 키)를 눌러 에디터 내에서 바로 AI에게 명령을 내리는 ''Inline Edit'' 기능을 적극 활용하세요.'],
    privacy_info = '{"description": "Zero Retention: 기업용 플랜 사용 시 사용자의 코드를 저장하거나 학습하지 않는 정책을 강력하게 내세웁니다."}'::jsonb,
    alternatives = '[{"name": "Cursor", "description": "현재 가장 대중적이고 강력한 AI 에디터 1위"}, {"name": "GitHub Copilot", "description": "가장 무난하고 깃허브 연동성이 좋은 표준"}]'::jsonb,
    media_info = '[{"title": "Introducing Windsurf Editor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Codeium)"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "macOS", "Linux (VS Code 기반)"], "target_audience": "Cursor에서 갈아탈 곳을 찾는 개발자, VS Code 환경을 선호하는 코더"}'::jsonb,
    features = ARRAY['Cascades', 'Supercomplete', 'Context-Aware Chat', 'Terminal AI', 'Model Selection']
WHERE name = 'Windsurf';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Windsurf', 'AI 코딩 도구의 강자 Codeium이 만든 차세대 IDE로, 개발자의 의도와 코드 흐름(Flow)을 깊이 이해하는 ''Cascades'' 기능이 핵심인 에디터.', 'https://codeium.com/windsurf',
    'Freemium (무료 + 유료 구독)', '월 $10 ~ $15 (Pro / 사용자당). (경쟁사 대비 저렴한 편).', '개인 사용자 영구 무료. (고속 모델 사용량 제한은 있으나, 기본 모델은 무제한급).',
    '[{"plan": "Individual", "target": "개인 개발자", "features": "Flows/Cascades 무료, 기본 모델 무제한, 고급 모델 제한적", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "GPT-4o/Claude 3.5 무제한급, 우선 지원, 더 긴 컨텍스트", "price": "$15/월"}, {"plan": "Teams", "target": "조직", "features": "데이터 프라이버시(Zero Retention), 라이선스 관리", "price": "별도 문의"}]'::jsonb, ARRAY['Cascades (Flows): Cursor의 Composer와 비슷하지만, ''코드의 문맥(Context)''을 파악하는 깊이가 다릅니다. 변수 하나를 고치면 연관된 파일들까지 AI가 알아서 추적해 수정 제안을 합니다.', 'Deep Context: 단순히 현재 열린 파일뿐만 아니라, 전체 프로젝트 구조를 이해하고 답변하는 능력이 탁월합니다.', 'VS Code 100% 호환: VS Code를 포크(Fork)해서 만들었기 때문에 기존 확장 프로그램과 단축키를 그대로 쓸 수 있습니다.', '가격 정책: 경쟁사(Cursor, Copilot)가 월 $20인 데 비해, 무료 플랜이 훨씬 혜자롭고 유료도 저렴한 편입니다.'], ARRAY['인지도: Cursor에 비해 늦게 주목받아 커뮤니티나 튜토리얼 자료가 상대적으로 적습니다.', '무거운 구동: 깊은 문맥 분석을 위해 리소스를 많이 사용하여, 저사양 PC에서는 인덱싱 때 버벅거릴 수 있습니다.'], '[{"name": "Cascades", "description": "여러 파일에 걸친 변경 사항을 AI가 주도적으로 수행 (Agentic)"}, {"name": "Supercomplete", "description": "단순 자동 완성을 넘어 다음 로직까지 예측해 미리 작성"}, {"name": "Context-Aware Chat", "description": "프로젝트 전체 맥락을 이해하는 사이드바 채팅"}, {"name": "Terminal AI", "description": "터미널 명령어를 자연어로 변환 및 실행"}, {"name": "Model Selection", "description": "GPT-4o, Claude 3.5 Sonnet 등 최신 모델 선택 가능"}]'::jsonb,
    '{"recommended": [{"target": "✅ Cursor 대안", "reason": "Cursor의 $20 구독료가 부담스럽거나 무료 사용량이 부족한 분."}, {"target": "✅ 복잡한 프로젝트", "reason": "파일 간 의존성이 복잡해서 \"이거 고치면 저게 터지는\" 경험을 자주 하는 개발자 (Cascades)."}, {"target": "✅ 개인 개발자", "reason": "혼자서 풀스택 개발을 하며 AI의 도움이 많이 필요한 분."}], "not_recommended": [{"target": "❌ JetBrains 유저", "reason": "IntelliJ나 PyCharm의 단축키/UI에 익숙하다면 VS Code 기반이 불편할 수 있습니다."}, {"target": "❌ 폐쇄망", "reason": "클라우드 AI 연결이 필수라 오프라인 환경에서는 제한적입니다."}]}'::jsonb, ARRAY['인덱싱: 프로젝트를 처음 열면 우측 하단에 인덱싱 바가 돌아갑니다. 이게 끝나야 AI가 똑똑해지니 조금 기다리세요.', '단축키: `Cmd+I` (또는 설정된 키)를 눌러 에디터 내에서 바로 AI에게 명령을 내리는 ''Inline Edit'' 기능을 적극 활용하세요.'], '{"description": "Zero Retention: 기업용 플랜 사용 시 사용자의 코드를 저장하거나 학습하지 않는 정책을 강력하게 내세웁니다."}'::jsonb,
    '[{"name": "Cursor", "description": "현재 가장 대중적이고 강력한 AI 에디터 1위"}, {"name": "GitHub Copilot", "description": "가장 무난하고 깃허브 연동성이 좋은 표준"}]'::jsonb, '[{"title": "Introducing Windsurf Editor", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube (Codeium)"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "macOS", "Linux (VS Code 기반)"], "target_audience": "Cursor에서 갈아탈 곳을 찾는 개발자, VS Code 환경을 선호하는 코더"}'::jsonb,
    ARRAY['Cascades', 'Supercomplete', 'Context-Aware Chat', 'Terminal AI', 'Model Selection'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Windsurf');

UPDATE ai_models SET
    description = '채팅만 하는 게 아니라, 실제 사람처럼 웹 브라우저를 켜고 클릭하고 입력하며 복잡한 업무를 끝까지 수행하는 ''자율 AI 에이전트''.',
    website_url = 'https://manus.ai/) (가상/초대 기반',
    pricing_model = 'Waitlist / High-tier Paid (예상)',
    pricing_info = '(예상) 월 $30~50 이상. (컴퓨팅 비용이 많이 드는 에이전트 서비스 특성상 고가 정책 유지).',
    free_tier_note = '현재는 주로 Waitlist(대기 명단) 등록을 받거나, 제한된 베타 유저에게만 오픈. (일반 무료 사용 불가).',
    pricing_plans = '[{"plan": "Beta", "target": "초대받은 자", "features": "자율 에이전트 기능 체험", "price": "무료/초대"}, {"plan": "Pro", "target": "전문가", "features": "복잡한 워크플로우(Long-horizon) 수행, 우선 처리", "price": "$50+/월(예상)"}]'::jsonb,
    pros = ARRAY['실행력(Action): "최저가 항공권 찾아줘"에서 끝나는 게 아니라, 실제로 사이트에 들어가서 가격을 비교하고 장바구니에 담는 것까지 시도합니다.', '자율성: 막히는 부분이 생기면 스스로 다른 방법을 찾아 시도하는 문제 해결 능력(Reasoning)이 뛰어납니다.', 'No API Needed: API가 없는 웹사이트라도 사람처럼 화면(UI)을 보고 조작하므로 모든 사이트에서 작동합니다.'],
    cons = ARRAY['속도: 사람이 하는 것보다 빠르지만, 단순 API 호출보다는 훨씬 느립니다. (브라우저를 띄우고 클릭하는 시간 소요).', '접근성: 아직 대중에게 완전히 풀리지 않았거나 가격 장벽이 높을 수 있습니다.', '오류: 웹사이트 UI가 바뀌거나 팝업이 뜨면 에이전트가 멈출 수 있습니다.'],
    key_features = '[{"name": "Autonomous Browsing", "description": "AI가 직접 브라우저를 제어해 웹 서핑"}, {"name": "Complex Task", "description": "\"조사 -> 정리 -> 이메일 발송\" 같은 다단계 업무 수행"}, {"name": "UI Interaction", "description": "클릭, 스크롤, 타이핑, 파일 업로드 등 수행"}, {"name": "Reasoning", "description": "작업 중 오류 발생 시 스스로 판단하여 우회"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 리서처", "reason": "\"최근 3년치 경쟁사 뉴스 기사 찾아서 엑셀에 정리해\" 같은 노가다 업무가 많은 분."}, {"target": "✅ 여행 계획", "reason": "항공권, 호텔, 식당 예약을 일일이 사이트 돌아다니며 하기 귀찮은 분."}, {"target": "✅ 얼리어답터", "reason": "\"드디어 말로만 듣던 AI 에이전트를 써보고 싶다\"는 분."}], "not_recommended": [{"target": "❌ 실시간성", "reason": "1초 만에 답이 나와야 하는 검색 용도로는 적합하지 않습니다. (Perplexity 추천)."}, {"target": "❌ 금융 거래", "reason": "결제까지 AI에게 맡기는 건 아직 보안상 시기상조일 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['감독 필요: "알아서 하겠지" 하고 놔두기보다, 에이전트가 작동하는 화면을 가끔 지켜봐야 엉뚱한 짓을 안 합니다.', '개인정보: 로그인 정보나 카드 번호를 에이전트에게 입력하게 시키는 건 주의가 필요합니다.'],
    privacy_info = '{"description": "샌드박스: 에이전트는 격리된 브라우저 환경에서 실행되어 사용자 로컬 환경을 보호합니다."}'::jsonb,
    alternatives = '[{"name": "MultiOn", "description": "브라우저 에이전트 분야의 강력한 경쟁자"}, {"name": "Rabbit R1 (Software)", "description": "하드웨어가 아닌 소프트웨어 에이전트로서의 대안"}]'::jsonb,
    media_info = '[{"title": "Manus AI Demo: The Future of Agents", "url": "https://www.youtube.com/ (데모 영상 확인 필요)", "platform": "YouTube / X (Twitter)"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Desktop Agent"], "target_audience": "단순 챗봇에 질린 얼리어답터, 리서치/예약 업무 자동화가 필요한 사람"}'::jsonb,
    features = ARRAY['Autonomous Browsing', 'Complex Task', 'UI Interaction', 'Reasoning']
WHERE name = 'Manus';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Manus', '채팅만 하는 게 아니라, 실제 사람처럼 웹 브라우저를 켜고 클릭하고 입력하며 복잡한 업무를 끝까지 수행하는 ''자율 AI 에이전트''.', 'https://manus.ai/) (가상/초대 기반',
    'Waitlist / High-tier Paid (예상)', '(예상) 월 $30~50 이상. (컴퓨팅 비용이 많이 드는 에이전트 서비스 특성상 고가 정책 유지).', '현재는 주로 Waitlist(대기 명단) 등록을 받거나, 제한된 베타 유저에게만 오픈. (일반 무료 사용 불가).',
    '[{"plan": "Beta", "target": "초대받은 자", "features": "자율 에이전트 기능 체험", "price": "무료/초대"}, {"plan": "Pro", "target": "전문가", "features": "복잡한 워크플로우(Long-horizon) 수행, 우선 처리", "price": "$50+/월(예상)"}]'::jsonb, ARRAY['실행력(Action): "최저가 항공권 찾아줘"에서 끝나는 게 아니라, 실제로 사이트에 들어가서 가격을 비교하고 장바구니에 담는 것까지 시도합니다.', '자율성: 막히는 부분이 생기면 스스로 다른 방법을 찾아 시도하는 문제 해결 능력(Reasoning)이 뛰어납니다.', 'No API Needed: API가 없는 웹사이트라도 사람처럼 화면(UI)을 보고 조작하므로 모든 사이트에서 작동합니다.'], ARRAY['속도: 사람이 하는 것보다 빠르지만, 단순 API 호출보다는 훨씬 느립니다. (브라우저를 띄우고 클릭하는 시간 소요).', '접근성: 아직 대중에게 완전히 풀리지 않았거나 가격 장벽이 높을 수 있습니다.', '오류: 웹사이트 UI가 바뀌거나 팝업이 뜨면 에이전트가 멈출 수 있습니다.'], '[{"name": "Autonomous Browsing", "description": "AI가 직접 브라우저를 제어해 웹 서핑"}, {"name": "Complex Task", "description": "\"조사 -> 정리 -> 이메일 발송\" 같은 다단계 업무 수행"}, {"name": "UI Interaction", "description": "클릭, 스크롤, 타이핑, 파일 업로드 등 수행"}, {"name": "Reasoning", "description": "작업 중 오류 발생 시 스스로 판단하여 우회"}]'::jsonb,
    '{"recommended": [{"target": "✅ 리서처", "reason": "\"최근 3년치 경쟁사 뉴스 기사 찾아서 엑셀에 정리해\" 같은 노가다 업무가 많은 분."}, {"target": "✅ 여행 계획", "reason": "항공권, 호텔, 식당 예약을 일일이 사이트 돌아다니며 하기 귀찮은 분."}, {"target": "✅ 얼리어답터", "reason": "\"드디어 말로만 듣던 AI 에이전트를 써보고 싶다\"는 분."}], "not_recommended": [{"target": "❌ 실시간성", "reason": "1초 만에 답이 나와야 하는 검색 용도로는 적합하지 않습니다. (Perplexity 추천)."}, {"target": "❌ 금융 거래", "reason": "결제까지 AI에게 맡기는 건 아직 보안상 시기상조일 수 있습니다."}]}'::jsonb, ARRAY['감독 필요: "알아서 하겠지" 하고 놔두기보다, 에이전트가 작동하는 화면을 가끔 지켜봐야 엉뚱한 짓을 안 합니다.', '개인정보: 로그인 정보나 카드 번호를 에이전트에게 입력하게 시키는 건 주의가 필요합니다.'], '{"description": "샌드박스: 에이전트는 격리된 브라우저 환경에서 실행되어 사용자 로컬 환경을 보호합니다."}'::jsonb,
    '[{"name": "MultiOn", "description": "브라우저 에이전트 분야의 강력한 경쟁자"}, {"name": "Rabbit R1 (Software)", "description": "하드웨어가 아닌 소프트웨어 에이전트로서의 대안"}]'::jsonb, '[{"title": "Manus AI Demo: The Future of Agents", "url": "https://www.youtube.com/ (데모 영상 확인 필요)", "platform": "YouTube / X (Twitter)"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Desktop Agent"], "target_audience": "단순 챗봇에 질린 얼리어답터, 리서치/예약 업무 자동화가 필요한 사람"}'::jsonb,
    ARRAY['Autonomous Browsing', 'Complex Task', 'UI Interaction', 'Reasoning'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Manus');

UPDATE ai_models SET
    description = '"프롬프트 한 줄로 풀스택 앱 완성" — 브라우저 안에서 개발 환경 설정부터 배포까지 한 번에 끝내는 WebContainer 기반 AI 개발 도구.',
    website_url = 'https://bolt.new/',
    pricing_model = 'Freemium (토큰 제한 무료 + 유료 구독)',
    pricing_info = '월 $20 (Pro).',
    free_tier_note = '기본 프로젝트 생성 무료. AI 토큰(LLM 사용량) 제한 있음. (하루에 앱 1~2개 정도 수정 가능).',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "일일 토큰 제한, 공개 프로젝트, 기본 배포", "price": "무료"}, {"plan": "Pro", "target": "앱 메이커", "features": "무제한 토큰(Fair use), 비공개 프로젝트, Netlify 배포", "price": "$20/월"}, {"plan": "Team", "target": "협업", "features": "팀 공유, 중앙 관리", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['WebContainers: 별도의 서버나 로컬 설정 없이, 브라우저 안에서 Node.js 서버가 실제로 돌아갑니다. (스택블리츠의 핵심 기술).', 'Full Stack: 프론트엔드(React/Svelte)뿐만 아니라 백엔드 로직까지 한 프로젝트 안에서 다 짜줍니다.', '즉시 실행: 코드를 짜자마자 우측 프리뷰 화면에서 앱이 작동하는 걸 볼 수 있고, 에러가 나면 AI가 고쳐줍니다 (Auto-fix).', '배포(Deploy): ''Deploy'' 버튼만 누르면 Netlify 등을 통해 실제 접속 가능한 URL이 생성됩니다.'],
    cons = ARRAY['토큰 소모: 앱이 복잡해질수록 수정할 때마다 토큰을 많이 잡아먹어, 무료 유저는 금방 한계에 부딪힙니다.', '복잡도 한계: 쇼핑몰 전체 구축 같은 대규모 프로젝트보다는, 단일 기능 앱(To-do, 계산기, 랜딩페이지) 제작에 최적화되어 있습니다.'],
    key_features = '[{"name": "Prompt to App", "description": "자연어로 앱 사양을 말하면 전체 코드 생성"}, {"name": "In-browser IDE", "description": "설치 없는 완벽한 개발 환경 (VS Code 스타일)"}, {"name": "Auto-Fix", "description": "에러 발생 시 AI가 로그를 분석해 자동 수정"}, {"name": "Package Manager", "description": "npm 패키지 설치 및 실행 지원"}, {"name": "One-click Deploy", "description": "생성된 앱을 클라우드에 즉시 배포"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 아이디어 뱅크", "reason": "\"이런 앱 있으면 좋겠는데?\" 생각이 날 때 10분 만에 시제품(MVP)을 만들어보고 싶은 분."}, {"target": "✅ 프론트엔드 공부", "reason": "AI가 짠 코드를 보면서 React나 Tailwind CSS 구조를 배우고 싶은 초보자."}, {"target": "✅ 내부 도구", "reason": "회사 내부에서 쓸 간단한 대시보드나 계산기가 필요한 팀."}], "not_recommended": [{"target": "❌ 대규모 서비스", "reason": "데이터베이스 설계가 복잡하고 트래픽이 많은 상용 서비스용으로는 아직 가볍습니다."}, {"target": "❌ 기존 프로젝트", "reason": "내 컴퓨터에 있는 기존 프로젝트를 불러와서 수정하는 용도로는 적합하지 않습니다 (새 프로젝트 생성용)."}]}'::jsonb,
    usage_tips = ARRAY['토큰 아끼기: 처음에 프롬프트를 아주 구체적으로(기능, 디자인, 색상 등) 적어야 수정 횟수를 줄여 토큰을 아낄 수 있습니다.', '데이터 저장: 기본적으로 브라우저 기반이라 새로고침하면 데이터가 날아갈 수 있으니, 영구 저장이 필요하면 Supabase 같은 외부 DB를 연결해야 합니다.'],
    privacy_info = '{"description": "샌드박스: WebContainer 기술 덕분에 코드가 사용자 브라우저 내에서 안전하게 격리되어 실행됩니다."}'::jsonb,
    alternatives = '[{"name": "Lovable", "description": "디자인이 더 예쁘고 Supabase 연동이 쉬운 경쟁 툴"}, {"name": "Replit Agent", "description": "백엔드/DB 설정까지 좀 더 깊게 들어간다면"}]'::jsonb,
    media_info = '[{"title": "Build Full Stack Apps with Bolt.new", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Browser)"], "target_audience": "프로토타입을 빨리 만들고 싶은 기획자, 풀스택 개발자"}'::jsonb,
    features = ARRAY['Prompt to App', 'In-browser IDE', 'Auto-Fix', 'Package Manager', 'One-click Deploy']
WHERE name = 'Bolt.new';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Bolt.new', '"프롬프트 한 줄로 풀스택 앱 완성" — 브라우저 안에서 개발 환경 설정부터 배포까지 한 번에 끝내는 WebContainer 기반 AI 개발 도구.', 'https://bolt.new/',
    'Freemium (토큰 제한 무료 + 유료 구독)', '월 $20 (Pro).', '기본 프로젝트 생성 무료. AI 토큰(LLM 사용량) 제한 있음. (하루에 앱 1~2개 정도 수정 가능).',
    '[{"plan": "Free", "target": "찍먹파", "features": "일일 토큰 제한, 공개 프로젝트, 기본 배포", "price": "무료"}, {"plan": "Pro", "target": "앱 메이커", "features": "무제한 토큰(Fair use), 비공개 프로젝트, Netlify 배포", "price": "$20/월"}, {"plan": "Team", "target": "협업", "features": "팀 공유, 중앙 관리", "price": "별도 문의"}]'::jsonb, ARRAY['WebContainers: 별도의 서버나 로컬 설정 없이, 브라우저 안에서 Node.js 서버가 실제로 돌아갑니다. (스택블리츠의 핵심 기술).', 'Full Stack: 프론트엔드(React/Svelte)뿐만 아니라 백엔드 로직까지 한 프로젝트 안에서 다 짜줍니다.', '즉시 실행: 코드를 짜자마자 우측 프리뷰 화면에서 앱이 작동하는 걸 볼 수 있고, 에러가 나면 AI가 고쳐줍니다 (Auto-fix).', '배포(Deploy): ''Deploy'' 버튼만 누르면 Netlify 등을 통해 실제 접속 가능한 URL이 생성됩니다.'], ARRAY['토큰 소모: 앱이 복잡해질수록 수정할 때마다 토큰을 많이 잡아먹어, 무료 유저는 금방 한계에 부딪힙니다.', '복잡도 한계: 쇼핑몰 전체 구축 같은 대규모 프로젝트보다는, 단일 기능 앱(To-do, 계산기, 랜딩페이지) 제작에 최적화되어 있습니다.'], '[{"name": "Prompt to App", "description": "자연어로 앱 사양을 말하면 전체 코드 생성"}, {"name": "In-browser IDE", "description": "설치 없는 완벽한 개발 환경 (VS Code 스타일)"}, {"name": "Auto-Fix", "description": "에러 발생 시 AI가 로그를 분석해 자동 수정"}, {"name": "Package Manager", "description": "npm 패키지 설치 및 실행 지원"}, {"name": "One-click Deploy", "description": "생성된 앱을 클라우드에 즉시 배포"}]'::jsonb,
    '{"recommended": [{"target": "✅ 아이디어 뱅크", "reason": "\"이런 앱 있으면 좋겠는데?\" 생각이 날 때 10분 만에 시제품(MVP)을 만들어보고 싶은 분."}, {"target": "✅ 프론트엔드 공부", "reason": "AI가 짠 코드를 보면서 React나 Tailwind CSS 구조를 배우고 싶은 초보자."}, {"target": "✅ 내부 도구", "reason": "회사 내부에서 쓸 간단한 대시보드나 계산기가 필요한 팀."}], "not_recommended": [{"target": "❌ 대규모 서비스", "reason": "데이터베이스 설계가 복잡하고 트래픽이 많은 상용 서비스용으로는 아직 가볍습니다."}, {"target": "❌ 기존 프로젝트", "reason": "내 컴퓨터에 있는 기존 프로젝트를 불러와서 수정하는 용도로는 적합하지 않습니다 (새 프로젝트 생성용)."}]}'::jsonb, ARRAY['토큰 아끼기: 처음에 프롬프트를 아주 구체적으로(기능, 디자인, 색상 등) 적어야 수정 횟수를 줄여 토큰을 아낄 수 있습니다.', '데이터 저장: 기본적으로 브라우저 기반이라 새로고침하면 데이터가 날아갈 수 있으니, 영구 저장이 필요하면 Supabase 같은 외부 DB를 연결해야 합니다.'], '{"description": "샌드박스: WebContainer 기술 덕분에 코드가 사용자 브라우저 내에서 안전하게 격리되어 실행됩니다."}'::jsonb,
    '[{"name": "Lovable", "description": "디자인이 더 예쁘고 Supabase 연동이 쉬운 경쟁 툴"}, {"name": "Replit Agent", "description": "백엔드/DB 설정까지 좀 더 깊게 들어간다면"}]'::jsonb, '[{"title": "Build Full Stack Apps with Bolt.new", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Browser)"], "target_audience": "프로토타입을 빨리 만들고 싶은 기획자, 풀스택 개발자"}'::jsonb,
    ARRAY['Prompt to App', 'In-browser IDE', 'Auto-Fix', 'Package Manager', 'One-click Deploy'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Bolt.new');

UPDATE ai_models SET
    description = '"디자이너가 없어도 예쁜 앱 완성" — Bolt.new와 유사하지만, UI/UX 디자인(Shadcn/Tailwind)과 Supabase 연동에 특화된 앱 생성 AI.',
    website_url = 'https://lovable.dev/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $20 (Pro).',
    free_tier_note = '기본 프로젝트 생성 무료. 일일 메시지 제한이 꽤 빡빡함. 생성된 앱은 공개됨.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "일일 제한적 편집, 공개 프로젝트", "price": "무료"}, {"plan": "Pro", "target": "앱 메이커", "features": "무제한 편집(Fair use), 비공개 프로젝트, GitHub 연동", "price": "$20/월"}, {"plan": "Scale", "target": "기업", "features": "더 빠른 속도, 우선 지원, 고급 기능", "price": "$50~/월"}]'::jsonb,
    pros = ARRAY['디자인 퀄리티: Bolt.new보다 기본 디자인이 훨씬 예쁩니다. 최신 유행하는 Shadcn UI와 Tailwind CSS를 기본으로 써서 "요즘 앱" 느낌이 납니다.', 'Supabase 통합: 데이터베이스(Supabase) 연결을 AI가 반자동으로 도와줘서, 로그인이나 데이터 저장이 필요한 앱을 만들기 쉽습니다.', 'GitHub Sync: 생성된 코드를 내 GitHub 저장소로 바로 푸시(Push)해서, 이후에는 내가 직접 코드를 수정하며 개발을 이어갈 수 있습니다. (Lock-in 없음).', '비전 인식: 손으로 그린 스케치나 스크린샷을 올리면 그대로 코드로 짜줍니다.'],
    cons = ARRAY['토큰 제한: 무료 플랜은 하루에 몇 번 대화하면 "내일 다시 오세요"라고 합니다. 진지하게 쓰려면 결제해야 합니다.', '복잡한 로직: 프론트엔드 위주라 백엔드 로직이 아주 복잡해지면 AI가 헤맬 수 있습니다.'],
    key_features = '[{"name": "Design-first Generation", "description": "Shadcn UI 기반의 고퀄리티 UI 생성"}, {"name": "Supabase Integration", "description": "DB, 인증(Auth), 스토리지 연동 지원"}, {"name": "Image to Code", "description": "스크린샷/스케치를 업로드해 UI 클론 코딩"}, {"name": "GitHub Sync", "description": "생성된 코드를 깃허브 리포지토리로 내보내기"}, {"name": "Instant Preview", "description": "수정 사항 실시간 미리보기"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 심미주의자", "reason": "기능도 중요하지만 일단 앱이 예뻐야 쓰는 분. (Bolt보다 디자인 우위)."}, {"target": "✅ 데이터 앱", "reason": "게시판, 예약 시스템 등 DB가 필요한 앱을 만들 분 (Supabase 조합)."}, {"target": "✅ 개발자 협업", "reason": "초안은 AI로 짜고, 마무리는 내가 VS Code에서 하고 싶은 분 (GitHub Sync)."}], "not_recommended": [{"target": "❌ 완전 무료", "reason": "돈 안 내고 앱 하나를 끝까지 완성하기는 어렵습니다."}, {"target": "❌ 파이썬 유저", "reason": "기본적으로 React/TypeScript 생태계에 최적화되어 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['DB 연결: Supabase를 연동할 때 API Key 설정 등을 AI가 가이드하는 대로 정확히 따라야 에러가 안 납니다.', '코드 수정: GitHub로 내보낸 뒤에 코드를 직접 수정했다면, 다시 Lovable에서 수정할 때 충돌이 날 수 있으니 주의하세요.'],
    privacy_info = '{"description": "소유권: 생성된 코드의 소유권은 사용자에게 있으며, GitHub로 내보내면 플랫폼 의존성 없이 독립적으로 운영 가능합니다."}'::jsonb,
    alternatives = '[{"name": "Bolt.new", "description": "풀스택 로직 구현에 좀 더 강점이 있는 툴"}, {"name": "v0.dev (Vercel)", "description": "UI 컴포넌트 생성에 특화된 도구"}]'::jsonb,
    media_info = '[{"title": "Lovable: Building Software with AI", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "예쁜 디자인의 웹앱을 만들고 싶은 기획자, 풀스택 개발자"}'::jsonb,
    features = ARRAY['Design-first Generation', 'Supabase Integration', 'Image to Code', 'GitHub Sync', 'Instant Preview']
WHERE name = 'Lovable';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Lovable', '"디자이너가 없어도 예쁜 앱 완성" — Bolt.new와 유사하지만, UI/UX 디자인(Shadcn/Tailwind)과 Supabase 연동에 특화된 앱 생성 AI.', 'https://lovable.dev/',
    'Freemium (무료 + 유료 구독)', '월 $20 (Pro).', '기본 프로젝트 생성 무료. 일일 메시지 제한이 꽤 빡빡함. 생성된 앱은 공개됨.',
    '[{"plan": "Free", "target": "체험", "features": "일일 제한적 편집, 공개 프로젝트", "price": "무료"}, {"plan": "Pro", "target": "앱 메이커", "features": "무제한 편집(Fair use), 비공개 프로젝트, GitHub 연동", "price": "$20/월"}, {"plan": "Scale", "target": "기업", "features": "더 빠른 속도, 우선 지원, 고급 기능", "price": "$50~/월"}]'::jsonb, ARRAY['디자인 퀄리티: Bolt.new보다 기본 디자인이 훨씬 예쁩니다. 최신 유행하는 Shadcn UI와 Tailwind CSS를 기본으로 써서 "요즘 앱" 느낌이 납니다.', 'Supabase 통합: 데이터베이스(Supabase) 연결을 AI가 반자동으로 도와줘서, 로그인이나 데이터 저장이 필요한 앱을 만들기 쉽습니다.', 'GitHub Sync: 생성된 코드를 내 GitHub 저장소로 바로 푸시(Push)해서, 이후에는 내가 직접 코드를 수정하며 개발을 이어갈 수 있습니다. (Lock-in 없음).', '비전 인식: 손으로 그린 스케치나 스크린샷을 올리면 그대로 코드로 짜줍니다.'], ARRAY['토큰 제한: 무료 플랜은 하루에 몇 번 대화하면 "내일 다시 오세요"라고 합니다. 진지하게 쓰려면 결제해야 합니다.', '복잡한 로직: 프론트엔드 위주라 백엔드 로직이 아주 복잡해지면 AI가 헤맬 수 있습니다.'], '[{"name": "Design-first Generation", "description": "Shadcn UI 기반의 고퀄리티 UI 생성"}, {"name": "Supabase Integration", "description": "DB, 인증(Auth), 스토리지 연동 지원"}, {"name": "Image to Code", "description": "스크린샷/스케치를 업로드해 UI 클론 코딩"}, {"name": "GitHub Sync", "description": "생성된 코드를 깃허브 리포지토리로 내보내기"}, {"name": "Instant Preview", "description": "수정 사항 실시간 미리보기"}]'::jsonb,
    '{"recommended": [{"target": "✅ 심미주의자", "reason": "기능도 중요하지만 일단 앱이 예뻐야 쓰는 분. (Bolt보다 디자인 우위)."}, {"target": "✅ 데이터 앱", "reason": "게시판, 예약 시스템 등 DB가 필요한 앱을 만들 분 (Supabase 조합)."}, {"target": "✅ 개발자 협업", "reason": "초안은 AI로 짜고, 마무리는 내가 VS Code에서 하고 싶은 분 (GitHub Sync)."}], "not_recommended": [{"target": "❌ 완전 무료", "reason": "돈 안 내고 앱 하나를 끝까지 완성하기는 어렵습니다."}, {"target": "❌ 파이썬 유저", "reason": "기본적으로 React/TypeScript 생태계에 최적화되어 있습니다."}]}'::jsonb, ARRAY['DB 연결: Supabase를 연동할 때 API Key 설정 등을 AI가 가이드하는 대로 정확히 따라야 에러가 안 납니다.', '코드 수정: GitHub로 내보낸 뒤에 코드를 직접 수정했다면, 다시 Lovable에서 수정할 때 충돌이 날 수 있으니 주의하세요.'], '{"description": "소유권: 생성된 코드의 소유권은 사용자에게 있으며, GitHub로 내보내면 플랫폼 의존성 없이 독립적으로 운영 가능합니다."}'::jsonb,
    '[{"name": "Bolt.new", "description": "풀스택 로직 구현에 좀 더 강점이 있는 툴"}, {"name": "v0.dev (Vercel)", "description": "UI 컴포넌트 생성에 특화된 도구"}]'::jsonb, '[{"title": "Lovable: Building Software with AI", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "예쁜 디자인의 웹앱을 만들고 싶은 기획자, 풀스택 개발자"}'::jsonb,
    ARRAY['Design-first Generation', 'Supabase Integration', 'Image to Code', 'GitHub Sync', 'Instant Preview'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Lovable');

UPDATE ai_models SET
    description = '전 세계 모든 오픈소스 AI 모델(Llama 3, Mistral, FLUX 등)과 데이터셋이 모여 있는 "AI계의 깃허브(GitHub)".',
    website_url = 'https://huggingface.co/',
    pricing_model = 'Open Source (기본 무료) + Paid Compute',
    pricing_info = '종량제 (PRO 계정 월 $9, 또는 GPU 사용 시간당 과금).',
    free_tier_note = '모델/데이터셋 다운로드 무제한, Spaces(CPU/기본 GPU) 호스팅 무료. (대부분의 기능이 무료).',
    pricing_plans = '[{"plan": "Free", "target": "모든 개발자", "features": "모델 호스팅, 다운로드, CPU Spaces 무료", "price": "무료"}, {"plan": "PRO", "target": "헤비 유저", "features": "ZeroGPU(무료 GPU 할당량 증가), 커뮤니티 배지", "price": "$9/월"}, {"plan": "Enterprise", "target": "기업", "features": "프라이빗 허브, SSO, 보안 강화", "price": "$20/인/월"}, {"plan": "Inference", "target": "서비스 배포", "features": "전용 GPU(A100, H100 등) 사용료", "price": "시간당 과금"}]'::jsonb,
    pros = ARRAY['모든 모델이 있다: Llama 3, Mistral, Stable Diffusion 등 최신 오픈소스 모델이 나오면 가장 먼저 올라오는 곳입니다.', 'Spaces (데모): 코드를 몰라도 ''Spaces'' 탭에 가면 최신 AI 모델을 웹에서 바로 체험해볼 수 있는 데모 앱들이 가득합니다.', 'Transformers: 허깅페이스가 만든 파이썬 라이브러리(`transformers`)는 AI 개발의 표준이나 다름없어 호환성이 최고입니다.', 'ZeroGPU: PRO 회원이 되거나 운이 좋으면, 고가의 GPU를 무료로 할당받아 모델을 돌려볼 수 있습니다.'],
    cons = ARRAY['개발자 중심: UI와 사용법이 철저히 개발자에게 맞춰져 있어, 일반인이 "그냥 챗봇 쓰고 싶다"고 들어가면 뭘 해야 할지 모릅니다.', '컴퓨팅 비용: 무거운 모델을 직접 돌리거나 서비스하려면 비싼 GPU 비용을 내야 합니다 (Inference Endpoints).'],
    key_features = '[{"name": "Models", "description": "100만 개 이상의 오픈소스 AI 모델 호스팅 및 공유"}, {"name": "Datasets", "description": "자연어, 이미지, 오디오 등 다양한 학습용 데이터셋"}, {"name": "Spaces", "description": "Streamlit/Gradio로 만든 AI 웹 데모 호스팅 (무료 GPU 지원)"}, {"name": "Inference Endpoints", "description": "클릭 몇 번으로 나만의 AI API 서버 구축"}, {"name": "Transformers Lib", "description": "모델을 쉽게 불러오고 사용하는 파이썬 라이브러리"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ AI 개발자", "reason": "모델을 찾고, 파인튜닝하고, 배포하는 모든 과정의 필수 코스."}, {"target": "✅ 얼리어답터", "reason": "\"어제 나온 따끈따끈한 AI 모델\"을 누구보다 먼저 써보고 싶은 분 (Spaces 활용)."}, {"target": "✅ 데이터 분석가", "reason": "학습용 데이터셋(Datasets)이 필요할 때 가장 먼저 찾아야 할 곳."}], "not_recommended": [{"target": "❌ 완전 비개발자", "reason": "코딩 없이 완성된 AI 서비스(ChatGPT 같은)를 원한다면 맞지 않습니다. 여긴 재료 시장입니다."}]}'::jsonb,
    usage_tips = ARRAY['라이선스 확인: 모델마다 ''상업적 이용 가능(Apache 2.0)'', ''연구용만 가능(Non-commercial)'' 등 라이선스가 다르니 꼭 확인하고 쓰세요.', 'Space 절전: 무료 Space는 일정 시간 사용하지 않으면 ''Sleep'' 모드로 들어갑니다. 다시 깨우는 데 시간이 걸릴 수 있습니다.'],
    privacy_info = '{"description": "프라이빗 리포지토리: 기업용이나 개인용으로 비공개(Private) 저장소를 만들 수 있으며, 이 경우 데이터는 외부에 공개되지 않습니다."}'::jsonb,
    alternatives = '[{"name": "GitHub", "description": "코드는 깃허브, 모델은 허깅페이스 (상호 보완 관계)"}, {"name": "Kaggle", "description": "데이터셋과 경진대회(Competition) 위주라면 더 적합"}]'::jsonb,
    media_info = '[{"title": "What is Hugging Face?", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Optional", "platforms": ["Web", "Python Library (Transformers)"], "target_audience": "AI 개발자, 데이터 사이언티스트, 오픈소스 모델을 찾고 돌려보고 싶은 분"}'::jsonb,
    features = ARRAY['Models', 'Datasets', 'Spaces', 'Inference Endpoints', 'Transformers Lib']
WHERE name = 'Hugging Face';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Hugging Face', '전 세계 모든 오픈소스 AI 모델(Llama 3, Mistral, FLUX 등)과 데이터셋이 모여 있는 "AI계의 깃허브(GitHub)".', 'https://huggingface.co/',
    'Open Source (기본 무료) + Paid Compute', '종량제 (PRO 계정 월 $9, 또는 GPU 사용 시간당 과금).', '모델/데이터셋 다운로드 무제한, Spaces(CPU/기본 GPU) 호스팅 무료. (대부분의 기능이 무료).',
    '[{"plan": "Free", "target": "모든 개발자", "features": "모델 호스팅, 다운로드, CPU Spaces 무료", "price": "무료"}, {"plan": "PRO", "target": "헤비 유저", "features": "ZeroGPU(무료 GPU 할당량 증가), 커뮤니티 배지", "price": "$9/월"}, {"plan": "Enterprise", "target": "기업", "features": "프라이빗 허브, SSO, 보안 강화", "price": "$20/인/월"}, {"plan": "Inference", "target": "서비스 배포", "features": "전용 GPU(A100, H100 등) 사용료", "price": "시간당 과금"}]'::jsonb, ARRAY['모든 모델이 있다: Llama 3, Mistral, Stable Diffusion 등 최신 오픈소스 모델이 나오면 가장 먼저 올라오는 곳입니다.', 'Spaces (데모): 코드를 몰라도 ''Spaces'' 탭에 가면 최신 AI 모델을 웹에서 바로 체험해볼 수 있는 데모 앱들이 가득합니다.', 'Transformers: 허깅페이스가 만든 파이썬 라이브러리(`transformers`)는 AI 개발의 표준이나 다름없어 호환성이 최고입니다.', 'ZeroGPU: PRO 회원이 되거나 운이 좋으면, 고가의 GPU를 무료로 할당받아 모델을 돌려볼 수 있습니다.'], ARRAY['개발자 중심: UI와 사용법이 철저히 개발자에게 맞춰져 있어, 일반인이 "그냥 챗봇 쓰고 싶다"고 들어가면 뭘 해야 할지 모릅니다.', '컴퓨팅 비용: 무거운 모델을 직접 돌리거나 서비스하려면 비싼 GPU 비용을 내야 합니다 (Inference Endpoints).'], '[{"name": "Models", "description": "100만 개 이상의 오픈소스 AI 모델 호스팅 및 공유"}, {"name": "Datasets", "description": "자연어, 이미지, 오디오 등 다양한 학습용 데이터셋"}, {"name": "Spaces", "description": "Streamlit/Gradio로 만든 AI 웹 데모 호스팅 (무료 GPU 지원)"}, {"name": "Inference Endpoints", "description": "클릭 몇 번으로 나만의 AI API 서버 구축"}, {"name": "Transformers Lib", "description": "모델을 쉽게 불러오고 사용하는 파이썬 라이브러리"}]'::jsonb,
    '{"recommended": [{"target": "✅ AI 개발자", "reason": "모델을 찾고, 파인튜닝하고, 배포하는 모든 과정의 필수 코스."}, {"target": "✅ 얼리어답터", "reason": "\"어제 나온 따끈따끈한 AI 모델\"을 누구보다 먼저 써보고 싶은 분 (Spaces 활용)."}, {"target": "✅ 데이터 분석가", "reason": "학습용 데이터셋(Datasets)이 필요할 때 가장 먼저 찾아야 할 곳."}], "not_recommended": [{"target": "❌ 완전 비개발자", "reason": "코딩 없이 완성된 AI 서비스(ChatGPT 같은)를 원한다면 맞지 않습니다. 여긴 재료 시장입니다."}]}'::jsonb, ARRAY['라이선스 확인: 모델마다 ''상업적 이용 가능(Apache 2.0)'', ''연구용만 가능(Non-commercial)'' 등 라이선스가 다르니 꼭 확인하고 쓰세요.', 'Space 절전: 무료 Space는 일정 시간 사용하지 않으면 ''Sleep'' 모드로 들어갑니다. 다시 깨우는 데 시간이 걸릴 수 있습니다.'], '{"description": "프라이빗 리포지토리: 기업용이나 개인용으로 비공개(Private) 저장소를 만들 수 있으며, 이 경우 데이터는 외부에 공개되지 않습니다."}'::jsonb,
    '[{"name": "GitHub", "description": "코드는 깃허브, 모델은 허깅페이스 (상호 보완 관계)"}, {"name": "Kaggle", "description": "데이터셋과 경진대회(Competition) 위주라면 더 적합"}]'::jsonb, '[{"title": "What is Hugging Face?", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Optional", "platforms": ["Web", "Python Library (Transformers)"], "target_audience": "AI 개발자, 데이터 사이언티스트, 오픈소스 모델을 찾고 돌려보고 싶은 분"}'::jsonb,
    ARRAY['Models', 'Datasets', 'Spaces', 'Inference Endpoints', 'Transformers Lib'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Hugging Face');

UPDATE ai_models SET
    description = 'AI 장기기억(Long-term Memory)의 핵심인 ''벡터 데이터베이스''를 서버 관리 없이 API로 간편하게 제공하는 매니지드 서비스.',
    website_url = 'https://www.pinecone.io/',
    pricing_model = 'Freemium (무료 + 종량제)',
    pricing_info = 'Serverless(종량제) 모델 기준 월 기본료 없음 (사용량만큼 과금).',
    free_tier_note = 'Starter Plan 무료. (1개 프로젝트, 최대 100,000 벡터 저장 가능). 학습 및 테스트용으로 충분.',
    pricing_plans = '[{"plan": "Starter", "target": "입문자", "features": "1개 인덱스, 10만 벡터, 공유 하드웨어", "price": "무료"}, {"plan": "Serverless", "target": "실무자", "features": "무제한 인덱스, 사용량 기반 과금(Read/Write Unit)", "price": "종량제"}, {"plan": "Pod-based", "target": "기존 기업", "features": "전용 하드웨어(Pod) 할당, 고정 비용 예측 가능", "price": "시간당 과금"}]'::jsonb,
    pros = ARRAY['Serverless (핵심): 2024년 도입된 서버리스 아키텍처 덕분에, 미리 서버(Pod)를 띄워놓고 돈을 낼 필요가 없습니다. 쓴 만큼만 내면 되어 비용 효율이 압도적입니다.', '초고속 검색: 수십억 개의 데이터 중에서 가장 유사한 문맥을 밀리초(ms) 단위로 찾아냅니다. (RAG 성능의 핵심).', '관리 불필요: 인프라 구축, 스케일링, 업데이트를 파인콘이 알아서 하므로 개발자는 코드만 짜면 됩니다.', '하이브리드 검색: 키워드 검색(BM25)과 의미 검색(Vector)을 결합하여 정확도를 높이는 기능을 자체 지원합니다.'],
    cons = ARRAY['비용 예측: 서버리스 모델은 트래픽이 폭증하면 요금이 예상보다 많이 나올 수 있어 모니터링이 필요합니다.', '로컬 불가: 클라우드 전용 서비스이므로, 완전히 폐쇄된 로컬망(On-premise)에서는 사용할 수 없습니다. (ChromaDB 등으로 대체 필요).'],
    key_features = '[{"name": "Vector Search", "description": "텍스트/이미지를 벡터로 변환해 유사도 검색"}, {"name": "Serverless Architecture", "description": "사용량에 따라 자동 스케일링되는 비용 효율적 구조"}, {"name": "Hybrid Search", "description": "시맨틱(의미) + 키워드 검색 결합"}, {"name": "Metadata Filtering", "description": "\"2025년 이후 데이터 중에서만 찾아줘\" 같은 필터링"}, {"name": "Multitenancy", "description": "하나의 인덱스에서 여러 사용자의 데이터를 안전하게 격리"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ RAG 개발자", "reason": "\"우리 회사 매뉴얼을 AI에게 학습시켜서 질문에 답하게 하고 싶다\"는 분."}, {"target": "✅ 추천 시스템", "reason": "사용자 취향과 가장 유사한 상품을 찾아 추천하고 싶은 쇼핑몰 개발자."}, {"target": "✅ 서버 관리 귀차니즘", "reason": "DB 튜닝이나 샤딩 같은 복잡한 인프라 관리 없이 API로 끝내고 싶은 분."}], "not_recommended": [{"target": "❌ 완전 무료", "reason": "상용 서비스 단계에서 무료로 계속 쓰고 싶다면 오픈소스(Chroma, Milvus)를 직접 구축해야 합니다."}, {"target": "❌ 오프라인", "reason": "인터넷이 안 되는 환경에서는 작동하지 않습니다."}]}'::jsonb,
    usage_tips = ARRAY['Dimension 일치: 임베딩 모델(OpenAI 등)의 벡터 차원수(Dimension)와 파인콘 인덱스 설정이 다르면 에러가 납니다. (예: 1536 vs 768).', '무료 인덱스 삭제: 무료(Starter) 인덱스는 7일간 사용 안 하면 자동 삭제됩니다. 중요한 데이터는 백업하거나 유료로 전환하세요.'],
    privacy_info = '{"description": "보안: SOC 2 Type II 인증을 받았으며, 엔터프라이즈 플랜은 PrivateLink 연결을 지원합니다."}'::jsonb,
    alternatives = '[{"name": "ChromaDB", "description": "로컬에 설치해서 무료로 쓸 수 있는 가장 인기 있는 오픈소스 벡터 DB"}, {"name": "Weaviate", "description": "다양한 모듈과 커스텀이 가능한 오픈소스 DB"}]'::jsonb,
    media_info = '[{"title": "Introduction to Pinecone Serverless", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "API (Python", "Node.js 등)"], "target_audience": "RAG(검색 증강 생성) 시스템을 구축하려는 AI 개발자, 데이터 엔지니어"}'::jsonb,
    features = ARRAY['Vector Search', 'Serverless Architecture', 'Hybrid Search', 'Metadata Filtering', 'Multitenancy']
WHERE name = 'Pinecone';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Pinecone', 'AI 장기기억(Long-term Memory)의 핵심인 ''벡터 데이터베이스''를 서버 관리 없이 API로 간편하게 제공하는 매니지드 서비스.', 'https://www.pinecone.io/',
    'Freemium (무료 + 종량제)', 'Serverless(종량제) 모델 기준 월 기본료 없음 (사용량만큼 과금).', 'Starter Plan 무료. (1개 프로젝트, 최대 100,000 벡터 저장 가능). 학습 및 테스트용으로 충분.',
    '[{"plan": "Starter", "target": "입문자", "features": "1개 인덱스, 10만 벡터, 공유 하드웨어", "price": "무료"}, {"plan": "Serverless", "target": "실무자", "features": "무제한 인덱스, 사용량 기반 과금(Read/Write Unit)", "price": "종량제"}, {"plan": "Pod-based", "target": "기존 기업", "features": "전용 하드웨어(Pod) 할당, 고정 비용 예측 가능", "price": "시간당 과금"}]'::jsonb, ARRAY['Serverless (핵심): 2024년 도입된 서버리스 아키텍처 덕분에, 미리 서버(Pod)를 띄워놓고 돈을 낼 필요가 없습니다. 쓴 만큼만 내면 되어 비용 효율이 압도적입니다.', '초고속 검색: 수십억 개의 데이터 중에서 가장 유사한 문맥을 밀리초(ms) 단위로 찾아냅니다. (RAG 성능의 핵심).', '관리 불필요: 인프라 구축, 스케일링, 업데이트를 파인콘이 알아서 하므로 개발자는 코드만 짜면 됩니다.', '하이브리드 검색: 키워드 검색(BM25)과 의미 검색(Vector)을 결합하여 정확도를 높이는 기능을 자체 지원합니다.'], ARRAY['비용 예측: 서버리스 모델은 트래픽이 폭증하면 요금이 예상보다 많이 나올 수 있어 모니터링이 필요합니다.', '로컬 불가: 클라우드 전용 서비스이므로, 완전히 폐쇄된 로컬망(On-premise)에서는 사용할 수 없습니다. (ChromaDB 등으로 대체 필요).'], '[{"name": "Vector Search", "description": "텍스트/이미지를 벡터로 변환해 유사도 검색"}, {"name": "Serverless Architecture", "description": "사용량에 따라 자동 스케일링되는 비용 효율적 구조"}, {"name": "Hybrid Search", "description": "시맨틱(의미) + 키워드 검색 결합"}, {"name": "Metadata Filtering", "description": "\"2025년 이후 데이터 중에서만 찾아줘\" 같은 필터링"}, {"name": "Multitenancy", "description": "하나의 인덱스에서 여러 사용자의 데이터를 안전하게 격리"}]'::jsonb,
    '{"recommended": [{"target": "✅ RAG 개발자", "reason": "\"우리 회사 매뉴얼을 AI에게 학습시켜서 질문에 답하게 하고 싶다\"는 분."}, {"target": "✅ 추천 시스템", "reason": "사용자 취향과 가장 유사한 상품을 찾아 추천하고 싶은 쇼핑몰 개발자."}, {"target": "✅ 서버 관리 귀차니즘", "reason": "DB 튜닝이나 샤딩 같은 복잡한 인프라 관리 없이 API로 끝내고 싶은 분."}], "not_recommended": [{"target": "❌ 완전 무료", "reason": "상용 서비스 단계에서 무료로 계속 쓰고 싶다면 오픈소스(Chroma, Milvus)를 직접 구축해야 합니다."}, {"target": "❌ 오프라인", "reason": "인터넷이 안 되는 환경에서는 작동하지 않습니다."}]}'::jsonb, ARRAY['Dimension 일치: 임베딩 모델(OpenAI 등)의 벡터 차원수(Dimension)와 파인콘 인덱스 설정이 다르면 에러가 납니다. (예: 1536 vs 768).', '무료 인덱스 삭제: 무료(Starter) 인덱스는 7일간 사용 안 하면 자동 삭제됩니다. 중요한 데이터는 백업하거나 유료로 전환하세요.'], '{"description": "보안: SOC 2 Type II 인증을 받았으며, 엔터프라이즈 플랜은 PrivateLink 연결을 지원합니다."}'::jsonb,
    '[{"name": "ChromaDB", "description": "로컬에 설치해서 무료로 쓸 수 있는 가장 인기 있는 오픈소스 벡터 DB"}, {"name": "Weaviate", "description": "다양한 모듈과 커스텀이 가능한 오픈소스 DB"}]'::jsonb, '[{"title": "Introduction to Pinecone Serverless", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "API (Python", "Node.js 등)"], "target_audience": "RAG(검색 증강 생성) 시스템을 구축하려는 AI 개발자, 데이터 엔지니어"}'::jsonb,
    ARRAY['Vector Search', 'Serverless Architecture', 'Hybrid Search', 'Metadata Filtering', 'Multitenancy'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Pinecone');

UPDATE ai_models SET
    description = 'LLM 앱 개발 프레임워크인 ''LangChain'' 팀이 만든 도구로, AI가 내놓은 답변 과정을 추적(Tracing)하고 테스트/평가하는 LLM Ops 플랫폼.',
    website_url = 'https://smith.langchain.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $39 (Plus / 연간 결제 시).',
    free_tier_note = 'Developer Plan 무료. (개인용, 월 5,000 Trace). 소규모 프로젝트 디버깅에 충분.',
    pricing_plans = '[{"plan": "Developer", "target": "개인", "features": "5,000 Trace/월, 14일 데이터 보관", "price": "무료"}, {"plan": "Plus", "target": "팀/스타트업", "features": "Trace 무제한(종량제), 팀 협업, 400일 보관", "price": "$39/월"}, {"plan": "Enterprise", "target": "대기업", "features": "보안 강화, SLA, 전담 지원", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['투명한 디버깅: "AI가 왜 이런 답변을 했지?" 궁금할 때, 프롬프트 입력부터 최종 출력까지 모든 단계(Chain)를 엑스레이처럼 보여줍니다.', 'Prompt Playground: 웹상에서 프롬프트를 수정하고 바로 테스트해서 결과가 어떻게 바뀌는지 비교해볼 수 있습니다.', 'Dataset & Testing: 골든 데이터셋(모범 답안)을 만들어두고, 모델을 업데이트할 때마다 점수가 떨어지지 않는지 자동 평가할 수 있습니다.', 'LangChain 최적화: 랭체인으로 개발했다면 코드 한 줄만 추가하면 바로 연동됩니다.'],
    cons = ARRAY['종속성: LangChain을 쓰지 않는 프로젝트에서도 쓸 수 있지만, 랭체인 환경에서 가장 강력합니다.', '비용 증가: 트래픽이 많은 서비스라면 Trace(로그) 비용이 생각보다 많이 나올 수 있습니다.'],
    key_features = '[{"name": "Tracing", "description": "LLM 호출의 입력/출력/시간/비용 시각화"}, {"name": "Prompt Hub", "description": "프롬프트 버전 관리 및 공유"}, {"name": "Evaluation", "description": "데이터셋 기반 자동 평가(채점) 실행"}, {"name": "Annotation", "description": "답변 품질에 대해 사람이 피드백(좋아요/싫어요) 남기기"}, {"name": "Monitoring", "description": "토큰 사용량 및 에러율 대시보드"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ AI 앱 개발자", "reason": "챗봇이 가끔 헛소리(Hallucination)를 하는데 원인을 못 찾겠는 분."}, {"target": "✅ 프롬프트 엔지니어", "reason": "프롬프트 A/B 테스트 결과를 체계적으로 관리하고 싶은 분."}, {"target": "✅ 품질 관리", "reason": "RAG 시스템의 검색 정확도를 정량적으로 측정하고 싶은 팀."}], "not_recommended": [{"target": "❌ 단순 사용자", "reason": "개발자가 아니라면 이 복잡한 로그 데이터가 아무 의미 없습니다."}, {"target": "❌ 로컬 로깅", "reason": "모든 로그를 내 서버에만 남겨야 한다면 LangFuse(Self-hosted)가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['API Key 노출: LangSmith API Key는 서버 환경변수에만 저장하세요. 클라이언트(프론트엔드) 코드에 넣으면 해킹당합니다.', 'Trace 필터링: 모든 호출을 다 기록하면 무료 용량이 금방 찹니다. 개발 단계(Dev)만 기록하고 운영(Prod)은 샘플링하는 전략이 필요합니다.'],
    privacy_info = '{"description": "민감 정보: 로그에 사용자의 개인정보(PII)가 남지 않도록 마스킹 처리가 필요할 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "LangFuse", "description": "오픈소스 기반으로 자가 호스팅이 가능한 강력한 경쟁자"}, {"name": "Arize Phoenix", "description": "LLM 관측 및 평가에 특화된 툴"}]'::jsonb,
    media_info = '[{"title": "LangSmith Walkthrough", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "LLM 앱이 왜 엉뚱한 답을 했는지 디버깅하고 싶은 개발자"}'::jsonb,
    features = ARRAY['Tracing', 'Prompt Hub', 'Evaluation', 'Annotation', 'Monitoring']
WHERE name = 'LangSmith';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'LangSmith', 'LLM 앱 개발 프레임워크인 ''LangChain'' 팀이 만든 도구로, AI가 내놓은 답변 과정을 추적(Tracing)하고 테스트/평가하는 LLM Ops 플랫폼.', 'https://smith.langchain.com/',
    'Freemium (무료 + 유료 구독)', '월 $39 (Plus / 연간 결제 시).', 'Developer Plan 무료. (개인용, 월 5,000 Trace). 소규모 프로젝트 디버깅에 충분.',
    '[{"plan": "Developer", "target": "개인", "features": "5,000 Trace/월, 14일 데이터 보관", "price": "무료"}, {"plan": "Plus", "target": "팀/스타트업", "features": "Trace 무제한(종량제), 팀 협업, 400일 보관", "price": "$39/월"}, {"plan": "Enterprise", "target": "대기업", "features": "보안 강화, SLA, 전담 지원", "price": "별도 문의"}]'::jsonb, ARRAY['투명한 디버깅: "AI가 왜 이런 답변을 했지?" 궁금할 때, 프롬프트 입력부터 최종 출력까지 모든 단계(Chain)를 엑스레이처럼 보여줍니다.', 'Prompt Playground: 웹상에서 프롬프트를 수정하고 바로 테스트해서 결과가 어떻게 바뀌는지 비교해볼 수 있습니다.', 'Dataset & Testing: 골든 데이터셋(모범 답안)을 만들어두고, 모델을 업데이트할 때마다 점수가 떨어지지 않는지 자동 평가할 수 있습니다.', 'LangChain 최적화: 랭체인으로 개발했다면 코드 한 줄만 추가하면 바로 연동됩니다.'], ARRAY['종속성: LangChain을 쓰지 않는 프로젝트에서도 쓸 수 있지만, 랭체인 환경에서 가장 강력합니다.', '비용 증가: 트래픽이 많은 서비스라면 Trace(로그) 비용이 생각보다 많이 나올 수 있습니다.'], '[{"name": "Tracing", "description": "LLM 호출의 입력/출력/시간/비용 시각화"}, {"name": "Prompt Hub", "description": "프롬프트 버전 관리 및 공유"}, {"name": "Evaluation", "description": "데이터셋 기반 자동 평가(채점) 실행"}, {"name": "Annotation", "description": "답변 품질에 대해 사람이 피드백(좋아요/싫어요) 남기기"}, {"name": "Monitoring", "description": "토큰 사용량 및 에러율 대시보드"}]'::jsonb,
    '{"recommended": [{"target": "✅ AI 앱 개발자", "reason": "챗봇이 가끔 헛소리(Hallucination)를 하는데 원인을 못 찾겠는 분."}, {"target": "✅ 프롬프트 엔지니어", "reason": "프롬프트 A/B 테스트 결과를 체계적으로 관리하고 싶은 분."}, {"target": "✅ 품질 관리", "reason": "RAG 시스템의 검색 정확도를 정량적으로 측정하고 싶은 팀."}], "not_recommended": [{"target": "❌ 단순 사용자", "reason": "개발자가 아니라면 이 복잡한 로그 데이터가 아무 의미 없습니다."}, {"target": "❌ 로컬 로깅", "reason": "모든 로그를 내 서버에만 남겨야 한다면 LangFuse(Self-hosted)가 낫습니다."}]}'::jsonb, ARRAY['API Key 노출: LangSmith API Key는 서버 환경변수에만 저장하세요. 클라이언트(프론트엔드) 코드에 넣으면 해킹당합니다.', 'Trace 필터링: 모든 호출을 다 기록하면 무료 용량이 금방 찹니다. 개발 단계(Dev)만 기록하고 운영(Prod)은 샘플링하는 전략이 필요합니다.'], '{"description": "민감 정보: 로그에 사용자의 개인정보(PII)가 남지 않도록 마스킹 처리가 필요할 수 있습니다."}'::jsonb,
    '[{"name": "LangFuse", "description": "오픈소스 기반으로 자가 호스팅이 가능한 강력한 경쟁자"}, {"name": "Arize Phoenix", "description": "LLM 관측 및 평가에 특화된 툴"}]'::jsonb, '[{"title": "LangSmith Walkthrough", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web"], "target_audience": "LLM 앱이 왜 엉뚱한 답을 했는지 디버깅하고 싶은 개발자"}'::jsonb,
    ARRAY['Tracing', 'Prompt Hub', 'Evaluation', 'Annotation', 'Monitoring'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'LangSmith');

UPDATE ai_models SET
    description = '"개발자를 위한 구글" — 스택오버플로우나 공식 문서를 뒤질 필요 없이, 코딩 질문에 특화된 답변과 최신 코드를 찾아주는 AI 검색 엔진.',
    website_url = 'https://www.phind.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $20 (Phind Pro).',
    free_tier_note = 'Phind-70B 모델 무제한. (GPT-4급 성능의 코딩 특화 모델). 하루 10회 정도 GPT-4o 등 타사 모델 사용 가능.',
    pricing_plans = '[{"plan": "Free", "target": "일반 개발자", "features": "Phind-70B 무제한, 빠른 검색, 기본 문맥", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "GPT-4o/Claude 3.5 무제한, Pair Programmer, 비공개 모드", "price": "$20/월"}, {"plan": "Team", "target": "조직", "features": "중앙 결제, 데이터 관리", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['개발자 특화: 일반 ChatGPT보다 최신 공식 문서(Docs)를 검색하는 능력이 탁월해, "어제 나온 라이브러리 사용법"도 정확히 알려줍니다.', 'Phind-70B: 무료로 제공되는 자체 모델(Phind-70B)이 코딩 성능 면에서 GPT-4에 버금갈 정도로 빠르고 똑똑합니다.', 'VS Code 연동: IDE 확장 프로그램을 설치하면, 에디터 안에서 바로 검색하고 코드를 가져올 수 있습니다.', '출처 표시: 답변에 사용된 StackOverflow나 깃허브 링크를 명확히 달아줍니다.'],
    cons = ARRAY['일반 상식: 코딩 외의 질문(요리, 여행 등)에는 ChatGPT보다 답변이 부실할 수 있습니다. (철저히 개발용).', '유료 차별: GPT-4o 같은 최상위 범용 모델을 무제한으로 쓰려면 결제가 필요합니다.'],
    key_features = '[{"name": "AI Search", "description": "개발자 질문에 최적화된 검색 엔진"}, {"name": "Phind-70B Model", "description": "코딩 특화 고성능 LLM (무료)"}, {"name": "Pair Programmer", "description": "VS Code 내에서 실시간 코딩 가이드 (Pro)"}, {"name": "Sources", "description": "답변의 근거가 되는 문서/커뮤니티 링크 제공"}, {"name": "Repo Context", "description": "내 깃허브 리포지토리를 연결해 문맥 파악 (Pro)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 디버깅 지옥", "reason": "에러 로그를 복사해서 붙여넣으면 해결책을 바로 찾고 싶은 분."}, {"target": "✅ 최신 기술", "reason": "Next.js 최신 버전처럼 공식 문서가 자주 바뀌는 기술을 쓰는 프론트엔드 개발자."}, {"target": "✅ 가성비", "reason": "GPT-4급 코딩 비서를 무료로 쓰고 싶은 학생."}], "not_recommended": [{"target": "❌ 비개발자", "reason": "코드를 다루지 않는다면 Perplexity나 ChatGPT가 더 범용적입니다."}]}'::jsonb,
    usage_tips = ARRAY['모델 확인: 검색창 아래에서 ''Phind-70B''를 쓰고 있는지 ''GPT-4''를 쓰고 있는지 확인하세요. 무료 유저는 GPT-4 횟수 제한이 있습니다.', '확장 프로그램: 웹사이트만 쓰지 말고 VS Code 익스텐션을 설치해야 ''복붙'' 시간을 줄일 수 있습니다.'],
    privacy_info = '{"description": "옵트아웃: 설정에서 내 검색 데이터를 학습에 쓰지 말라고 요청할 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "Perplexity", "description": "개발 외에 일반적인 검색까지 포함한다면"}, {"name": "GitHub Copilot", "description": "검색보다는 ''자동 완성''에 더 초점을 맞춘다면"}]'::jsonb,
    media_info = '[{"title": "Using Phind in VS Code", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Optional", "platforms": ["Web", "VS Code Extension"], "target_audience": "에러 해결책을 빨리 찾고 싶은 개발자, 최신 라이브러리 사용법이 궁금한 코더"}'::jsonb,
    features = ARRAY['AI Search', 'Phind-70B Model', 'Pair Programmer', 'Sources', 'Repo Context']
WHERE name = 'Phind';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Phind', '"개발자를 위한 구글" — 스택오버플로우나 공식 문서를 뒤질 필요 없이, 코딩 질문에 특화된 답변과 최신 코드를 찾아주는 AI 검색 엔진.', 'https://www.phind.com/',
    'Freemium (무료 + 유료 구독)', '월 $20 (Phind Pro).', 'Phind-70B 모델 무제한. (GPT-4급 성능의 코딩 특화 모델). 하루 10회 정도 GPT-4o 등 타사 모델 사용 가능.',
    '[{"plan": "Free", "target": "일반 개발자", "features": "Phind-70B 무제한, 빠른 검색, 기본 문맥", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "GPT-4o/Claude 3.5 무제한, Pair Programmer, 비공개 모드", "price": "$20/월"}, {"plan": "Team", "target": "조직", "features": "중앙 결제, 데이터 관리", "price": "별도 문의"}]'::jsonb, ARRAY['개발자 특화: 일반 ChatGPT보다 최신 공식 문서(Docs)를 검색하는 능력이 탁월해, "어제 나온 라이브러리 사용법"도 정확히 알려줍니다.', 'Phind-70B: 무료로 제공되는 자체 모델(Phind-70B)이 코딩 성능 면에서 GPT-4에 버금갈 정도로 빠르고 똑똑합니다.', 'VS Code 연동: IDE 확장 프로그램을 설치하면, 에디터 안에서 바로 검색하고 코드를 가져올 수 있습니다.', '출처 표시: 답변에 사용된 StackOverflow나 깃허브 링크를 명확히 달아줍니다.'], ARRAY['일반 상식: 코딩 외의 질문(요리, 여행 등)에는 ChatGPT보다 답변이 부실할 수 있습니다. (철저히 개발용).', '유료 차별: GPT-4o 같은 최상위 범용 모델을 무제한으로 쓰려면 결제가 필요합니다.'], '[{"name": "AI Search", "description": "개발자 질문에 최적화된 검색 엔진"}, {"name": "Phind-70B Model", "description": "코딩 특화 고성능 LLM (무료)"}, {"name": "Pair Programmer", "description": "VS Code 내에서 실시간 코딩 가이드 (Pro)"}, {"name": "Sources", "description": "답변의 근거가 되는 문서/커뮤니티 링크 제공"}, {"name": "Repo Context", "description": "내 깃허브 리포지토리를 연결해 문맥 파악 (Pro)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 디버깅 지옥", "reason": "에러 로그를 복사해서 붙여넣으면 해결책을 바로 찾고 싶은 분."}, {"target": "✅ 최신 기술", "reason": "Next.js 최신 버전처럼 공식 문서가 자주 바뀌는 기술을 쓰는 프론트엔드 개발자."}, {"target": "✅ 가성비", "reason": "GPT-4급 코딩 비서를 무료로 쓰고 싶은 학생."}], "not_recommended": [{"target": "❌ 비개발자", "reason": "코드를 다루지 않는다면 Perplexity나 ChatGPT가 더 범용적입니다."}]}'::jsonb, ARRAY['모델 확인: 검색창 아래에서 ''Phind-70B''를 쓰고 있는지 ''GPT-4''를 쓰고 있는지 확인하세요. 무료 유저는 GPT-4 횟수 제한이 있습니다.', '확장 프로그램: 웹사이트만 쓰지 말고 VS Code 익스텐션을 설치해야 ''복붙'' 시간을 줄일 수 있습니다.'], '{"description": "옵트아웃: 설정에서 내 검색 데이터를 학습에 쓰지 말라고 요청할 수 있습니다."}'::jsonb,
    '[{"name": "Perplexity", "description": "개발 외에 일반적인 검색까지 포함한다면"}, {"name": "GitHub Copilot", "description": "검색보다는 ''자동 완성''에 더 초점을 맞춘다면"}]'::jsonb, '[{"title": "Using Phind in VS Code", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Optional", "platforms": ["Web", "VS Code Extension"], "target_audience": "에러 해결책을 빨리 찾고 싶은 개발자, 최신 라이브러리 사용법이 궁금한 코더"}'::jsonb,
    ARRAY['AI Search', 'Phind-70B Model', 'Pair Programmer', 'Sources', 'Repo Context'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Phind');

UPDATE ai_models SET
    description = '코딩 없이 자연어로 "이메일 정리 비서 만들어줘"라고 하면, 역할을 수행하는 AI 에이전트를 공장에서 찍어내듯 생성하고 배포하는 플랫폼.',
    website_url = '(대표 예시) [https://agentfactory.ai](https://www.google.com/search?q=https://agentfactory.ai) (가상/대표 URL) 또는 유사 서비스(Smyte/Fine 등)',
    pricing_model = 'Freemium (토큰/실행 횟수 기반)',
    pricing_info = '월 $29 (Starter).',
    free_tier_note = '에이전트 1개 생성, 월 50회 실행 무료. 기본 툴(웹검색 등) 연동 가능.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "1 에이전트, 50회 실행/월", "price": "무료"}, {"plan": "Starter", "target": "개인/소팀", "features": "5 에이전트, 1,000회 실행, API 연동", "price": "$29/월"}, {"plan": "Business", "target": "기업", "features": "무제한 에이전트, 팀 공유, 화이트라벨링", "price": "$99/월"}]'::jsonb,
    pros = ARRAY['No-Code: 복잡한 파이썬 코딩 없이 "너는 친절한 CS 상담원이야"라고 설정만 하면 봇이 만들어집니다.', 'Tool Use: 에이전트에게 ''구글 검색'', ''이메일 발송'', ''PDF 읽기'' 같은 도구(Tool)를 쥐어줄 수 있어 실제 업무가 가능합니다.', '배포 용이: 만든 에이전트를 웹사이트 챗봇으로 심거나, 슬랙/디스코드 봇으로 바로 내보낼 수 있습니다.'],
    cons = ARRAY['복잡도 한계: 아주 정교한 에러 처리가 필요한 업무는 노코드 툴만으로는 한계가 있어 n8n 같은 툴과 병행해야 합니다.', '비용: 에이전트가 생각보다 토큰을 많이 써서, 사용량이 늘면 비용이 급격히 뜁니다.'],
    key_features = '[{"name": "Agent Builder", "description": "자연어 대화로 에이전트 성격 및 규칙 설정"}, {"name": "Knowledge Base", "description": "PDF, URL 등을 업로드해 에이전트에게 지식 주입"}, {"name": "Tool Integration", "description": "검색, 계산기, API 호출 등 도구 연결"}, {"name": "Multi-Agent", "description": "여러 에이전트가 협업하는 워크플로우 구성 (Pro)"}, {"name": "Publishing", "description": "웹 위젯, 슬랙, 카카오톡 등으로 봇 배포"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 운영 매니저", "reason": "반복되는 고객 문의를 1차로 걸러주는 챗봇을 직접 만들고 싶은 분."}, {"target": "✅ 콘텐츠 팀", "reason": "\"뉴스 검색해서 요약하고 블로그 글 초안 써주는 봇\"이 필요한 분."}, {"target": "✅ 프로토타이핑", "reason": "AI 서비스 기획을 빠르게 구현해서 검증해보고 싶은 기획자."}], "not_recommended": [{"target": "❌ 전문 개발자", "reason": "LangChain이나 AutoGen으로 직접 짜는 게 훨씬 자유도가 높습니다."}]}'::jsonb,
    usage_tips = ARRAY['지식 최신화: Knowledge Base에 올린 파일은 자동으로 업데이트되지 않습니다. 자료가 바뀌면 수동으로 다시 올려줘야 합니다.', '루프 주의: 에이전트끼리 대화하게 시키면 무한 루프에 빠져 크레딧을 탕진할 수 있으니 종료 조건을 명확히 하세요.'],
    privacy_info = '{"description": "샌드박스: 에이전트 실행 환경은 격리되어 있으며, 업로드된 문서는 벡터 데이터베이스에 암호화되어 저장됩니다."}'::jsonb,
    alternatives = '[{"name": "GPTs (OpenAI)", "description": "가장 쉽고 대중적인 에이전트 빌더 (단, ChatGPT 내에서만 작동)"}, {"name": "Flowise / LangFlow", "description": "시각적으로 노드를 연결해 만드는 로우코드 툴"}]'::jsonb,
    media_info = '[{"title": "How to build AI Agents in 5 minutes", "url": "https://www.youtube.com/ (관련 튜토리얼 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "사내 업무 자동화가 필요한 운영팀, 나만의 AI 봇을 만들고 싶은 기획자"}'::jsonb,
    features = ARRAY['Agent Builder', 'Knowledge Base', 'Tool Integration', 'Multi-Agent', 'Publishing']
WHERE name = 'Agent Factory';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Agent Factory', '코딩 없이 자연어로 "이메일 정리 비서 만들어줘"라고 하면, 역할을 수행하는 AI 에이전트를 공장에서 찍어내듯 생성하고 배포하는 플랫폼.', '(대표 예시) [https://agentfactory.ai](https://www.google.com/search?q=https://agentfactory.ai) (가상/대표 URL) 또는 유사 서비스(Smyte/Fine 등)',
    'Freemium (토큰/실행 횟수 기반)', '월 $29 (Starter).', '에이전트 1개 생성, 월 50회 실행 무료. 기본 툴(웹검색 등) 연동 가능.',
    '[{"plan": "Free", "target": "체험", "features": "1 에이전트, 50회 실행/월", "price": "무료"}, {"plan": "Starter", "target": "개인/소팀", "features": "5 에이전트, 1,000회 실행, API 연동", "price": "$29/월"}, {"plan": "Business", "target": "기업", "features": "무제한 에이전트, 팀 공유, 화이트라벨링", "price": "$99/월"}]'::jsonb, ARRAY['No-Code: 복잡한 파이썬 코딩 없이 "너는 친절한 CS 상담원이야"라고 설정만 하면 봇이 만들어집니다.', 'Tool Use: 에이전트에게 ''구글 검색'', ''이메일 발송'', ''PDF 읽기'' 같은 도구(Tool)를 쥐어줄 수 있어 실제 업무가 가능합니다.', '배포 용이: 만든 에이전트를 웹사이트 챗봇으로 심거나, 슬랙/디스코드 봇으로 바로 내보낼 수 있습니다.'], ARRAY['복잡도 한계: 아주 정교한 에러 처리가 필요한 업무는 노코드 툴만으로는 한계가 있어 n8n 같은 툴과 병행해야 합니다.', '비용: 에이전트가 생각보다 토큰을 많이 써서, 사용량이 늘면 비용이 급격히 뜁니다.'], '[{"name": "Agent Builder", "description": "자연어 대화로 에이전트 성격 및 규칙 설정"}, {"name": "Knowledge Base", "description": "PDF, URL 등을 업로드해 에이전트에게 지식 주입"}, {"name": "Tool Integration", "description": "검색, 계산기, API 호출 등 도구 연결"}, {"name": "Multi-Agent", "description": "여러 에이전트가 협업하는 워크플로우 구성 (Pro)"}, {"name": "Publishing", "description": "웹 위젯, 슬랙, 카카오톡 등으로 봇 배포"}]'::jsonb,
    '{"recommended": [{"target": "✅ 운영 매니저", "reason": "반복되는 고객 문의를 1차로 걸러주는 챗봇을 직접 만들고 싶은 분."}, {"target": "✅ 콘텐츠 팀", "reason": "\"뉴스 검색해서 요약하고 블로그 글 초안 써주는 봇\"이 필요한 분."}, {"target": "✅ 프로토타이핑", "reason": "AI 서비스 기획을 빠르게 구현해서 검증해보고 싶은 기획자."}], "not_recommended": [{"target": "❌ 전문 개발자", "reason": "LangChain이나 AutoGen으로 직접 짜는 게 훨씬 자유도가 높습니다."}]}'::jsonb, ARRAY['지식 최신화: Knowledge Base에 올린 파일은 자동으로 업데이트되지 않습니다. 자료가 바뀌면 수동으로 다시 올려줘야 합니다.', '루프 주의: 에이전트끼리 대화하게 시키면 무한 루프에 빠져 크레딧을 탕진할 수 있으니 종료 조건을 명확히 하세요.'], '{"description": "샌드박스: 에이전트 실행 환경은 격리되어 있으며, 업로드된 문서는 벡터 데이터베이스에 암호화되어 저장됩니다."}'::jsonb,
    '[{"name": "GPTs (OpenAI)", "description": "가장 쉽고 대중적인 에이전트 빌더 (단, ChatGPT 내에서만 작동)"}, {"name": "Flowise / LangFlow", "description": "시각적으로 노드를 연결해 만드는 로우코드 툴"}]'::jsonb, '[{"title": "How to build AI Agents in 5 minutes", "url": "https://www.youtube.com/ (관련 튜토리얼 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "사내 업무 자동화가 필요한 운영팀, 나만의 AI 봇을 만들고 싶은 기획자"}'::jsonb,
    ARRAY['Agent Builder', 'Knowledge Base', 'Tool Integration', 'Multi-Agent', 'Publishing'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Agent Factory');

UPDATE ai_models SET
    description = '"AI가 개발 팀원이 된다" — 복잡한 소프트웨어 엔지니어링 작업을 자율적으로 계획하고, 코드를 작성하고, 테스트까지 수행하는 마이크로소프트의 자율 AI 프레임워크.',
    website_url = 'https://www.google.com/search?q=https://github.com/microsoft/autodev) (오픈소스/연구 프로젝트 기반',
    pricing_model = 'Open Source (무료) / Enterprise Integration (유료)',
    pricing_info = '(상용 서비스화된 버전 사용 시) 기업 문의. 직접 구동 시 API 비용(OpenAI 등) 발생.',
    free_tier_note = '오픈소스 프레임워크 자체는 무료. (GitHub에서 다운로드 가능).',
    pricing_plans = '[{"plan": "Open Source", "target": "연구자/개발자", "features": "전체 코드 접근, 커스텀 에이전트 구성", "price": "무료"}, {"plan": "Enterprise", "target": "대기업", "features": "보안 컨테이너, 기술 지원, Azure 통합", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['완전 자율성: 단순 코드 추천(Copilot)을 넘어, "이 리포지토리의 보안 취약점을 다 찾아서 고쳐줘" 같은 복합적인 임무를 수행합니다.', 'Docker 통합: AI가 작성한 코드를 안전한 격리 환경(Docker)에서 실제로 돌려보고, 에러가 나면 스스로 고칩니다. (가장 큰 차별점).', 'Multi-Agent: ''기획자 AI'', ''코더 AI'', ''리뷰어 AI''가 서로 대화하며 협업하는 구조를 짤 수 있습니다.', 'MS 생태계: 마이크로소프트의 방대한 개발 도구 및 Azure 클라우드와 연동성이 뛰어납니다.'],
    cons = ARRAY['설치 난이도: 일반인이 설치해서 쓰기엔 매우 어렵습니다. (Docker, Python, API 설정 등 개발 지식 필수).', '비용 통제: 자율 에이전트가 며칠 동안 코드를 짜느라 API를 계속 호출하면 요금 폭탄을 맞을 수 있습니다.'],
    key_features = '[{"name": "Autonomous Coding", "description": "계획 수립 → 코드 작성 → 테스트 → 수정 반복"}, {"name": "Secure Execution", "description": "Docker 컨테이너 내에서 안전한 코드 실행 및 검증"}, {"name": "Multi-Agent Collaboration", "description": "역할별 에이전트 협업 시스템"}, {"name": "Context Awareness", "description": "전체 코드베이스 및 문서를 이해하고 작업"}, {"name": "Fine-tuning Support", "description": "특정 도메인(언어/프레임워크)에 특화된 튜닝 지원"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ DevOps 엔지니어", "reason": "CI/CD 파이프라인에 AI 검수 과정을 자동으로 넣고 싶은 분."}, {"target": "✅ AI 연구자", "reason": "LLM이 실제로 소프트웨어 개발을 어디까지 할 수 있는지 실험해보고 싶은 분."}, {"target": "✅ 사내 도구 팀", "reason": "우리 회사만의 자동화된 코딩 봇을 구축하고 싶은 팀."}], "not_recommended": [{"target": "❌ 일반 개발자", "reason": "당장 오늘 마감인 프로젝트를 도와줄 도구를 찾는다면 Cursor나 Copilot이 훨씬 실용적입니다. AutoDev는 ''시스템''을 구축하는 도구입니다."}]}'::jsonb,
    usage_tips = ARRAY['무한 루프: 에이전트가 문제를 해결 못하고 계속 시도만 하다가 API 비용만 날릴 수 있습니다. 반드시 ''최대 시도 횟수(Max Iterations)''를 설정하세요.', '보안 격리: AutoDev가 실행하는 코드가 내 로컬 파일을 맘대로 지우지 못하게 반드시 Docker 환경을 제대로 설정해야 합니다.'],
    privacy_info = '{"description": "로컬 제어: 사용자가 직접 서버를 띄우므로 코드가 외부로 유출될 위험을 통제할 수 있습니다. (Azure OpenAI 사용 시 엔터프라이즈 보안 적용)."}'::jsonb,
    alternatives = '[{"name": "Devin (Cognition)", "description": "상용화된 완전 자율 AI 소프트웨어 엔지니어 (비공개 베타/고가)"}, {"name": "OpenDevin", "description": "Devin의 오픈소스 대안 프로젝트"}]'::jsonb,
    media_info = '[{"title": "AutoDev: Automated AI-Driven Development", "url": "https://www.youtube.com/ (Microsoft Research 채널 확인)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "None", "platforms": ["Local", "Cloud", "IDE Integration"], "target_audience": "AI 에이전트 연구자, 자율 코딩 시스템을 구축하려는 엔지니어링 팀"}'::jsonb,
    features = ARRAY['Autonomous Coding', 'Secure Execution', 'Multi-Agent Collaboration', 'Context Awareness', 'Fine-tuning Support']
WHERE name = 'AutoDev';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'AutoDev', '"AI가 개발 팀원이 된다" — 복잡한 소프트웨어 엔지니어링 작업을 자율적으로 계획하고, 코드를 작성하고, 테스트까지 수행하는 마이크로소프트의 자율 AI 프레임워크.', 'https://www.google.com/search?q=https://github.com/microsoft/autodev) (오픈소스/연구 프로젝트 기반',
    'Open Source (무료) / Enterprise Integration (유료)', '(상용 서비스화된 버전 사용 시) 기업 문의. 직접 구동 시 API 비용(OpenAI 등) 발생.', '오픈소스 프레임워크 자체는 무료. (GitHub에서 다운로드 가능).',
    '[{"plan": "Open Source", "target": "연구자/개발자", "features": "전체 코드 접근, 커스텀 에이전트 구성", "price": "무료"}, {"plan": "Enterprise", "target": "대기업", "features": "보안 컨테이너, 기술 지원, Azure 통합", "price": "별도 문의"}]'::jsonb, ARRAY['완전 자율성: 단순 코드 추천(Copilot)을 넘어, "이 리포지토리의 보안 취약점을 다 찾아서 고쳐줘" 같은 복합적인 임무를 수행합니다.', 'Docker 통합: AI가 작성한 코드를 안전한 격리 환경(Docker)에서 실제로 돌려보고, 에러가 나면 스스로 고칩니다. (가장 큰 차별점).', 'Multi-Agent: ''기획자 AI'', ''코더 AI'', ''리뷰어 AI''가 서로 대화하며 협업하는 구조를 짤 수 있습니다.', 'MS 생태계: 마이크로소프트의 방대한 개발 도구 및 Azure 클라우드와 연동성이 뛰어납니다.'], ARRAY['설치 난이도: 일반인이 설치해서 쓰기엔 매우 어렵습니다. (Docker, Python, API 설정 등 개발 지식 필수).', '비용 통제: 자율 에이전트가 며칠 동안 코드를 짜느라 API를 계속 호출하면 요금 폭탄을 맞을 수 있습니다.'], '[{"name": "Autonomous Coding", "description": "계획 수립 → 코드 작성 → 테스트 → 수정 반복"}, {"name": "Secure Execution", "description": "Docker 컨테이너 내에서 안전한 코드 실행 및 검증"}, {"name": "Multi-Agent Collaboration", "description": "역할별 에이전트 협업 시스템"}, {"name": "Context Awareness", "description": "전체 코드베이스 및 문서를 이해하고 작업"}, {"name": "Fine-tuning Support", "description": "특정 도메인(언어/프레임워크)에 특화된 튜닝 지원"}]'::jsonb,
    '{"recommended": [{"target": "✅ DevOps 엔지니어", "reason": "CI/CD 파이프라인에 AI 검수 과정을 자동으로 넣고 싶은 분."}, {"target": "✅ AI 연구자", "reason": "LLM이 실제로 소프트웨어 개발을 어디까지 할 수 있는지 실험해보고 싶은 분."}, {"target": "✅ 사내 도구 팀", "reason": "우리 회사만의 자동화된 코딩 봇을 구축하고 싶은 팀."}], "not_recommended": [{"target": "❌ 일반 개발자", "reason": "당장 오늘 마감인 프로젝트를 도와줄 도구를 찾는다면 Cursor나 Copilot이 훨씬 실용적입니다. AutoDev는 ''시스템''을 구축하는 도구입니다."}]}'::jsonb, ARRAY['무한 루프: 에이전트가 문제를 해결 못하고 계속 시도만 하다가 API 비용만 날릴 수 있습니다. 반드시 ''최대 시도 횟수(Max Iterations)''를 설정하세요.', '보안 격리: AutoDev가 실행하는 코드가 내 로컬 파일을 맘대로 지우지 못하게 반드시 Docker 환경을 제대로 설정해야 합니다.'], '{"description": "로컬 제어: 사용자가 직접 서버를 띄우므로 코드가 외부로 유출될 위험을 통제할 수 있습니다. (Azure OpenAI 사용 시 엔터프라이즈 보안 적용)."}'::jsonb,
    '[{"name": "Devin (Cognition)", "description": "상용화된 완전 자율 AI 소프트웨어 엔지니어 (비공개 베타/고가)"}, {"name": "OpenDevin", "description": "Devin의 오픈소스 대안 프로젝트"}]'::jsonb, '[{"title": "AutoDev: Automated AI-Driven Development", "url": "https://www.youtube.com/ (Microsoft Research 채널 확인)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "None", "platforms": ["Local", "Cloud", "IDE Integration"], "target_audience": "AI 에이전트 연구자, 자율 코딩 시스템을 구축하려는 엔지니어링 팀"}'::jsonb,
    ARRAY['Autonomous Coding', 'Secure Execution', 'Multi-Agent Collaboration', 'Context Awareness', 'Fine-tuning Support'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'AutoDev');

UPDATE ai_models SET
    description = '여기저기 흩어진 채용 공고를 한곳에 모으고, AI가 이력서를 공고에 맞춰 자동으로 수정해 주는 올인원 취업/이직 관리 플랫폼.',
    website_url = 'https://www.tealhq.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $9 (Teal+ / 주 단위 결제) 또는 월 $29 (월 단위).',
    free_tier_note = '무제한 공고 저장(Job Tracker), 기본 이력서 빌더 사용 가능. (AI 기능은 횟수 제한).',
    pricing_plans = '[{"plan": "Free", "target": "취준생", "features": "공고 추적, 이력서 빌더, 기본 키워드 분석", "price": "무료"}, {"plan": "Teal+", "target": "적극 구직자", "features": "무제한 AI 이력서 수정, 커버레터 생성, 키워드 매칭", "price": "$9/주 또는 $29/월"}]'::jsonb,
    pros = ARRAY['Job Tracker: 링크드인, 인디드, 사람인 등 여러 사이트의 공고를 크롬 확장 프로그램 버튼 하나로 Teal 대시보드에 싹 긁어와서 관리할 수 있습니다. (엑셀 정리 해방).', 'Matching Score: 내 이력서와 채용 공고(JD)를 비교해서 "합격 확률 70점" 식으로 점수를 매겨주고, 부족한 키워드가 뭔지 알려줍니다.', 'AI Resume Builder: "이 공고에 맞춰서 내 경력 기술서를 다시 써줘"라고 하면, JD에 있는 키워드를 넣어서 AI가 문장을 다듬어줍니다.', 'Cover Letter: 이력서와 공고 내용을 바탕으로 맞춤형 커버 레터(자기소개서)를 1초 만에 써줍니다.'],
    cons = ARRAY['영어 최적화: AI가 이력서를 고쳐줄 때 영어로는 완벽하지만, 한국어 자소서는 문맥이 어색할 수 있어 번역기 도움이나 검수가 필요합니다.', '유료 유도: 점수 분석(Matching Mode) 등 핵심 기능이 유료(Teal+)에 묶여 있어, 본격적으로 쓰려면 결제가 필요합니다.'],
    key_features = '[{"name": "Job Tracker", "description": "모든 채용 사이트 공고 원클릭 저장 및 상태 관리(서류/면접/합격)"}, {"name": "AI Resume Builder", "description": "채용 공고 맞춤형 이력서 자동 수정 및 생성"}, {"name": "Keyword Analysis", "description": "JD에서 핵심 키워드 추출 및 내 이력서 매칭 분석"}, {"name": "Cover Letter Generator", "description": "공고별 맞춤형 커버 레터 생성"}, {"name": "Work Styles Test", "description": "나의 업무 성향을 파악하는 커리어 테스트 제공"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 해외 취업러", "reason": "영문 이력서(Resume)와 커버 레터를 써야 하는 분들에게는 필수템입니다."}, {"target": "✅ 다작 지원러", "reason": "50군데 이상 지원하면서 \"어디에 넣었더라?\" 헷갈리는 분 (Job Tracker)."}, {"target": "✅ 이직 준비", "reason": "지금 당장은 아니지만 좋은 공고를 미리 스크랩해두고 커리어 관리하고 싶은 분."}], "not_recommended": [{"target": "❌ 한국 공채", "reason": "한국 대기업 공채(자소설닷컴 스타일) 양식과는 맞지 않습니다. (자유 양식/경력직에 적합)."}, {"target": "❌ 모바일 유저", "reason": "PC 크롬 브라우저에서 확장 프로그램으로 쓸 때 진가가 발휘됩니다."}]}'::jsonb,
    usage_tips = ARRAY['결제 주기: Teal+는 ''주 단위($9)'' 결제 옵션이 있습니다. 단기간 집중해서 이직하고 끊기에 좋습니다. 장기전이라면 월 단위가 쌉니다.', 'PDF 파싱: 기존 이력서(PDF)를 업로드하면 AI가 내용을 인식하는데, 한글 파일은 깨질 수 있으니 텍스트를 복사해 넣는 게 안전합니다.'],
    privacy_info = '{"description": "개인정보: 이력서에는 민감한 정보가 많으므로, Teal은 사용자의 동의 없이 데이터를 제3자와 공유하지 않음을 명시합니다."}'::jsonb,
    alternatives = '[{"name": "Rezi (레지)", "description": "AI 이력서 작성에 더 특화된 툴 (ATS 통과 최적화)"}, {"name": "Notion (Template)", "description": "돈 안 쓰고 템플릿으로만 관리하고 싶다면"}]'::jsonb,
    media_info = '[{"title": "How to Use Teal to Land Your Dream Job", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "Chrome Extension"], "target_audience": "이직을 준비하는 직장인, 수십 군데 지원해야 하는 취준생"}'::jsonb,
    features = ARRAY['Job Tracker', 'AI Resume Builder', 'Keyword Analysis', 'Cover Letter Generator', 'Work Styles Test']
WHERE name = 'Teal';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Teal', '여기저기 흩어진 채용 공고를 한곳에 모으고, AI가 이력서를 공고에 맞춰 자동으로 수정해 주는 올인원 취업/이직 관리 플랫폼.', 'https://www.tealhq.com/',
    'Freemium (무료 + 유료 구독)', '월 $9 (Teal+ / 주 단위 결제) 또는 월 $29 (월 단위).', '무제한 공고 저장(Job Tracker), 기본 이력서 빌더 사용 가능. (AI 기능은 횟수 제한).',
    '[{"plan": "Free", "target": "취준생", "features": "공고 추적, 이력서 빌더, 기본 키워드 분석", "price": "무료"}, {"plan": "Teal+", "target": "적극 구직자", "features": "무제한 AI 이력서 수정, 커버레터 생성, 키워드 매칭", "price": "$9/주 또는 $29/월"}]'::jsonb, ARRAY['Job Tracker: 링크드인, 인디드, 사람인 등 여러 사이트의 공고를 크롬 확장 프로그램 버튼 하나로 Teal 대시보드에 싹 긁어와서 관리할 수 있습니다. (엑셀 정리 해방).', 'Matching Score: 내 이력서와 채용 공고(JD)를 비교해서 "합격 확률 70점" 식으로 점수를 매겨주고, 부족한 키워드가 뭔지 알려줍니다.', 'AI Resume Builder: "이 공고에 맞춰서 내 경력 기술서를 다시 써줘"라고 하면, JD에 있는 키워드를 넣어서 AI가 문장을 다듬어줍니다.', 'Cover Letter: 이력서와 공고 내용을 바탕으로 맞춤형 커버 레터(자기소개서)를 1초 만에 써줍니다.'], ARRAY['영어 최적화: AI가 이력서를 고쳐줄 때 영어로는 완벽하지만, 한국어 자소서는 문맥이 어색할 수 있어 번역기 도움이나 검수가 필요합니다.', '유료 유도: 점수 분석(Matching Mode) 등 핵심 기능이 유료(Teal+)에 묶여 있어, 본격적으로 쓰려면 결제가 필요합니다.'], '[{"name": "Job Tracker", "description": "모든 채용 사이트 공고 원클릭 저장 및 상태 관리(서류/면접/합격)"}, {"name": "AI Resume Builder", "description": "채용 공고 맞춤형 이력서 자동 수정 및 생성"}, {"name": "Keyword Analysis", "description": "JD에서 핵심 키워드 추출 및 내 이력서 매칭 분석"}, {"name": "Cover Letter Generator", "description": "공고별 맞춤형 커버 레터 생성"}, {"name": "Work Styles Test", "description": "나의 업무 성향을 파악하는 커리어 테스트 제공"}]'::jsonb,
    '{"recommended": [{"target": "✅ 해외 취업러", "reason": "영문 이력서(Resume)와 커버 레터를 써야 하는 분들에게는 필수템입니다."}, {"target": "✅ 다작 지원러", "reason": "50군데 이상 지원하면서 \"어디에 넣었더라?\" 헷갈리는 분 (Job Tracker)."}, {"target": "✅ 이직 준비", "reason": "지금 당장은 아니지만 좋은 공고를 미리 스크랩해두고 커리어 관리하고 싶은 분."}], "not_recommended": [{"target": "❌ 한국 공채", "reason": "한국 대기업 공채(자소설닷컴 스타일) 양식과는 맞지 않습니다. (자유 양식/경력직에 적합)."}, {"target": "❌ 모바일 유저", "reason": "PC 크롬 브라우저에서 확장 프로그램으로 쓸 때 진가가 발휘됩니다."}]}'::jsonb, ARRAY['결제 주기: Teal+는 ''주 단위($9)'' 결제 옵션이 있습니다. 단기간 집중해서 이직하고 끊기에 좋습니다. 장기전이라면 월 단위가 쌉니다.', 'PDF 파싱: 기존 이력서(PDF)를 업로드하면 AI가 내용을 인식하는데, 한글 파일은 깨질 수 있으니 텍스트를 복사해 넣는 게 안전합니다.'], '{"description": "개인정보: 이력서에는 민감한 정보가 많으므로, Teal은 사용자의 동의 없이 데이터를 제3자와 공유하지 않음을 명시합니다."}'::jsonb,
    '[{"name": "Rezi (레지)", "description": "AI 이력서 작성에 더 특화된 툴 (ATS 통과 최적화)"}, {"name": "Notion (Template)", "description": "돈 안 쓰고 템플릿으로만 관리하고 싶다면"}]'::jsonb, '[{"title": "How to Use Teal to Land Your Dream Job", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "Chrome Extension"], "target_audience": "이직을 준비하는 직장인, 수십 군데 지원해야 하는 취준생"}'::jsonb,
    ARRAY['Job Tracker', 'AI Resume Builder', 'Keyword Analysis', 'Cover Letter Generator', 'Work Styles Test'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Teal');

UPDATE ai_models SET
    description = 'GPT-4 기반의 AI가 이력서 문장을 대신 써주고, 디자인 템플릿 제공 및 ATS(채용 시스템) 통과 확률까지 분석해 주는 취업 치트키.',
    website_url = 'https://www.kickresume.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $19 (Premium / 월 결제 시) / 연 결제 시 월 $7 수준.',
    free_tier_note = '기본 템플릿 4개, 1개 이력서/커버레터 생성 무료. AI 작문 기능 제한적 체험.',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "템플릿 4개, 기본 웹사이트 제작, 제한적 다운로드", "price": "무료"}, {"plan": "Premium", "target": "취준생", "features": "35+ 템플릿, AI Writer 무제한, ATS 분석, 교정", "price": "$19/월"}]'::jsonb,
    pros = ARRAY['AI Writer: "마케터 경력 3년"이라고만 입력하면, "주도적으로 캠페인을 이끌어 ROI를 20% 증대시킴" 같은 전문적인 문장(Bullet points)을 AI가 써줍니다.', 'ATS Checker: 내 이력서가 채용 담당자의 필터링 시스템(ATS)을 통과할 수 있는지 점수로 알려주고, 부족한 키워드를 추천합니다.', 'Pyjama Jobs: 원격 근무(Remote Work) 전용 채용 공고를 매칭해 주는 기능이 내장되어 있습니다.', 'Personal Website: 이력서 내용을 바탕으로 클릭 한 번에 나만의 포트폴리오 웹사이트를 만들어줍니다.'],
    cons = ARRAY['유료 유도: 예쁜 템플릿이나 핵심 AI 기능은 대부분 Premium에 잠겨 있어, 제대로 쓰려면 결제가 필요합니다.', '영어 중심: 한국어 자소서보다는 영문 레주메 작성 시 표현력이 훨씬 뛰어납니다. (국내 공채보다는 외국계/해외취업용).'],
    key_features = '[{"name": "AI Resume Writer", "description": "직무별 맞춤 문장 자동 생성 (GPT-4)"}, {"name": "Resume Checker", "description": "이력서 점수 분석 및 개선 제안"}, {"name": "Cover Letter Generator", "description": "공고 내용에 맞춘 커버 레터 자동 작성"}, {"name": "Website Builder", "description": "이력서 기반 포트폴리오 사이트 생성"}, {"name": "Proofreading", "description": "원어민 전문가의 문법/표현 교정 (별도 유료)"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 해외 취업", "reason": "링크드인 프로필을 PDF 이력서로 예쁘게 변환하고 싶은 분."}, {"target": "✅ 영작 울렁증", "reason": "영어로 \"성과를 냈다\"를 어떻게 표현해야 있어 보일지 모르는 분."}, {"target": "✅ 디자인 똥손", "reason": "워드(Word)로 줄 맞추다가 스트레스받기 싫은 분."}], "not_recommended": [{"target": "❌ 국내 공채", "reason": "한국 대기업 지정 양식(hwp 등)에는 맞지 않습니다."}, {"target": "❌ 완전 무료", "reason": "돈 한 푼 안 쓰고 모든 기능을 쓰고 싶다면 Canva의 무료 이력서 템플릿이 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['구독 해지: 월 결제($19)보다는 연 결제($84)가 압도적으로 싸지만, 취업에 성공하면 바로 해지하는 걸 잊지 마세요.', '사진 첨부: 영미권 이력서에는 사진을 넣지 않는 게 관례입니다. 템플릿에 사진란이 있어도 끄는 게 좋습니다.'],
    privacy_info = '{"description": "공개 설정: 웹사이트 빌더로 만든 페이지는 공개될 수 있으니, 민감한 정보(집 주소, 전화번호) 노출에 주의하세요."}'::jsonb,
    alternatives = '[{"name": "Teal", "description": "이력서 작성뿐만 아니라 채용 공고 추적 관리에 더 강점"}, {"name": "Rezi", "description": "ATS 통과(합격률)에만 올인한 텍스트 중심 툴"}]'::jsonb,
    media_info = '[{"title": "Best AI Resume Builder - Kickresume", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "영문 이력서(Resume/CV)가 필요한 취준생, 글로벌 기업 지원자"}'::jsonb,
    features = ARRAY['AI Resume Writer', 'Resume Checker', 'Cover Letter Generator', 'Website Builder', 'Proofreading']
WHERE name = 'Kickresume';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Kickresume', 'GPT-4 기반의 AI가 이력서 문장을 대신 써주고, 디자인 템플릿 제공 및 ATS(채용 시스템) 통과 확률까지 분석해 주는 취업 치트키.', 'https://www.kickresume.com/',
    'Freemium (무료 + 유료 구독)', '월 $19 (Premium / 월 결제 시) / 연 결제 시 월 $7 수준.', '기본 템플릿 4개, 1개 이력서/커버레터 생성 무료. AI 작문 기능 제한적 체험.',
    '[{"plan": "Free", "target": "찍먹파", "features": "템플릿 4개, 기본 웹사이트 제작, 제한적 다운로드", "price": "무료"}, {"plan": "Premium", "target": "취준생", "features": "35+ 템플릿, AI Writer 무제한, ATS 분석, 교정", "price": "$19/월"}]'::jsonb, ARRAY['AI Writer: "마케터 경력 3년"이라고만 입력하면, "주도적으로 캠페인을 이끌어 ROI를 20% 증대시킴" 같은 전문적인 문장(Bullet points)을 AI가 써줍니다.', 'ATS Checker: 내 이력서가 채용 담당자의 필터링 시스템(ATS)을 통과할 수 있는지 점수로 알려주고, 부족한 키워드를 추천합니다.', 'Pyjama Jobs: 원격 근무(Remote Work) 전용 채용 공고를 매칭해 주는 기능이 내장되어 있습니다.', 'Personal Website: 이력서 내용을 바탕으로 클릭 한 번에 나만의 포트폴리오 웹사이트를 만들어줍니다.'], ARRAY['유료 유도: 예쁜 템플릿이나 핵심 AI 기능은 대부분 Premium에 잠겨 있어, 제대로 쓰려면 결제가 필요합니다.', '영어 중심: 한국어 자소서보다는 영문 레주메 작성 시 표현력이 훨씬 뛰어납니다. (국내 공채보다는 외국계/해외취업용).'], '[{"name": "AI Resume Writer", "description": "직무별 맞춤 문장 자동 생성 (GPT-4)"}, {"name": "Resume Checker", "description": "이력서 점수 분석 및 개선 제안"}, {"name": "Cover Letter Generator", "description": "공고 내용에 맞춘 커버 레터 자동 작성"}, {"name": "Website Builder", "description": "이력서 기반 포트폴리오 사이트 생성"}, {"name": "Proofreading", "description": "원어민 전문가의 문법/표현 교정 (별도 유료)"}]'::jsonb,
    '{"recommended": [{"target": "✅ 해외 취업", "reason": "링크드인 프로필을 PDF 이력서로 예쁘게 변환하고 싶은 분."}, {"target": "✅ 영작 울렁증", "reason": "영어로 \"성과를 냈다\"를 어떻게 표현해야 있어 보일지 모르는 분."}, {"target": "✅ 디자인 똥손", "reason": "워드(Word)로 줄 맞추다가 스트레스받기 싫은 분."}], "not_recommended": [{"target": "❌ 국내 공채", "reason": "한국 대기업 지정 양식(hwp 등)에는 맞지 않습니다."}, {"target": "❌ 완전 무료", "reason": "돈 한 푼 안 쓰고 모든 기능을 쓰고 싶다면 Canva의 무료 이력서 템플릿이 낫습니다."}]}'::jsonb, ARRAY['구독 해지: 월 결제($19)보다는 연 결제($84)가 압도적으로 싸지만, 취업에 성공하면 바로 해지하는 걸 잊지 마세요.', '사진 첨부: 영미권 이력서에는 사진을 넣지 않는 게 관례입니다. 템플릿에 사진란이 있어도 끄는 게 좋습니다.'], '{"description": "공개 설정: 웹사이트 빌더로 만든 페이지는 공개될 수 있으니, 민감한 정보(집 주소, 전화번호) 노출에 주의하세요."}'::jsonb,
    '[{"name": "Teal", "description": "이력서 작성뿐만 아니라 채용 공고 추적 관리에 더 강점"}, {"name": "Rezi", "description": "ATS 통과(합격률)에만 올인한 텍스트 중심 툴"}]'::jsonb, '[{"title": "Best AI Resume Builder - Kickresume", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "iOS", "Android"], "target_audience": "영문 이력서(Resume/CV)가 필요한 취준생, 글로벌 기업 지원자"}'::jsonb,
    ARRAY['AI Resume Writer', 'Resume Checker', 'Cover Letter Generator', 'Website Builder', 'Proofreading'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Kickresume');

UPDATE ai_models SET
    description = '구글 지메일(Gmail)을 메신저처럼 빠르고 똑똑하게 바꿔주는 AI 이메일 클라이언트. (구글 인박스(Inbox) 팀 출신이 만듦).',
    website_url = 'https://www.shortwave.com/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $7 (Standard / 연 결제 시) ~ $14 (Pro).',
    free_tier_note = '최근 90일간의 이메일 검색 및 AI 요약 무료. (오래된 메일은 검색 안 됨).',
    pricing_plans = '[{"plan": "Free", "target": "개인", "features": "90일 검색 제한, 기본 AI 요약", "price": "무료"}, {"plan": "Standard", "target": "직장인", "features": "전체 검색(Full History), 즉시 알림, AI 비서 강화", "price": "$7/월"}, {"plan": "Pro", "target": "헤비 유저", "features": "AI Assistant 심화(일정/검색), 대량 메일 처리", "price": "$14/월"}]'::jsonb,
    pros = ARRAY['AI Assistant: 채팅창에 "지난주에 김 과장이 보낸 파일 찾아줘"라고 하면, AI가 메일함을 뒤져서 찾아줍니다. (RAG 기술 적용).', 'Smart Summary: 긴 뉴스레터나 스레드를 한 줄로 요약해 주어 읽는 시간을 획기적으로 줄여줍니다.', 'AI Autocomplete: 답장을 쓸 때 내 말투를 학습해서 문장을 완성해 줍니다. (Ghost writing).', 'Speed: 지메일 웹보다 훨씬 빠르고 단축키가 잘 되어 있어 마우스 없이 키보드만으로 메일 처리가 가능합니다.'],
    cons = ARRAY['Gmail 전용: 아웃룩(Outlook)이나 다른 메일 서비스는 아직 지원하지 않습니다. 오직 구글 계정만 가능합니다.', '무료 제한: 무료 플랜의 ''90일 검색 제한''은 치명적입니다. 옛날 메일을 찾으려면 지메일로 다시 들어가야 합니다.'],
    key_features = '[{"name": "AI Summary", "description": "모든 이메일 스레드 자동 요약"}, {"name": "Conversational Search", "description": "자연어로 이메일 검색 및 질의응답"}, {"name": "Ghost AI", "description": "사용자의 작문 스타일을 모방한 답장 초안 작성"}, {"name": "Smart Bundles", "description": "뉴스레터, 프로모션 메일을 카테고리별로 묶음 처리"}, {"name": "Calendar Integration", "description": "이메일 내용을 바탕으로 일정 바로 등록"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 인박스 제로", "reason": "메일함을 깨끗하게 비우는 걸 목표로 하는 생산성 덕후."}, {"target": "✅ 영어 이메일", "reason": "영어 메일을 요약해서 보고, 영어 답장을 AI 도움 받아 쓰고 싶은 분."}, {"target": "✅ 과거 구글 인박스 팬", "reason": "구글이 없애버린 Inbox by Gmail의 UI를 그리워하는 분."}], "not_recommended": [{"target": "❌ 아웃룩 유저", "reason": "회사 메일이 MS Exchange라면 그림의 떡입니다."}, {"target": "❌ 무료 헤비 유저", "reason": "3달 전 메일 검색이 안 되는 건 업무용으로 무료 쓰기에 부적합합니다."}]}'::jsonb,
    usage_tips = ARRAY['서명 설정: Shortwave에서 보낸 메일 하단에 "Sent with Shortwave" 문구가 기본으로 붙을 수 있으니 설정에서 확인하고 지우세요.', '알림 설정: 중요한 메일만 알림을 받고 나머지는 묶음 처리(Bundle)하는 설정을 해야 조용한 업무 환경이 됩니다.'],
    privacy_info = '{"description": "보안: SOC 2 인증을 받았으며, AI 기능은 개인정보 보호를 위해 사용자의 데이터를 모델 학습(Training)에 사용하지 않는다고 명시합니다."}'::jsonb,
    alternatives = '[{"name": "Superhuman", "description": "더 빠르지만 더 비싼($30) 프리미엄 이메일 클라이언트"}, {"name": "Spark Mail", "description": "여러 계정(네이버, 아웃룩 등)을 한 번에 관리하고 싶다면"}]'::jsonb,
    media_info = '[{"title": "Introducing Shortwave AI Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Desktop"], "target_audience": "이메일 처리에 하루 1시간 이상 쓰는 직장인, 지메일 UI가 답답한 분"}'::jsonb,
    features = ARRAY['AI Summary', 'Conversational Search', 'Ghost AI', 'Smart Bundles', 'Calendar Integration']
WHERE name = 'Shortwave';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Shortwave', '구글 지메일(Gmail)을 메신저처럼 빠르고 똑똑하게 바꿔주는 AI 이메일 클라이언트. (구글 인박스(Inbox) 팀 출신이 만듦).', 'https://www.shortwave.com/',
    'Freemium (무료 + 유료 구독)', '월 $7 (Standard / 연 결제 시) ~ $14 (Pro).', '최근 90일간의 이메일 검색 및 AI 요약 무료. (오래된 메일은 검색 안 됨).',
    '[{"plan": "Free", "target": "개인", "features": "90일 검색 제한, 기본 AI 요약", "price": "무료"}, {"plan": "Standard", "target": "직장인", "features": "전체 검색(Full History), 즉시 알림, AI 비서 강화", "price": "$7/월"}, {"plan": "Pro", "target": "헤비 유저", "features": "AI Assistant 심화(일정/검색), 대량 메일 처리", "price": "$14/월"}]'::jsonb, ARRAY['AI Assistant: 채팅창에 "지난주에 김 과장이 보낸 파일 찾아줘"라고 하면, AI가 메일함을 뒤져서 찾아줍니다. (RAG 기술 적용).', 'Smart Summary: 긴 뉴스레터나 스레드를 한 줄로 요약해 주어 읽는 시간을 획기적으로 줄여줍니다.', 'AI Autocomplete: 답장을 쓸 때 내 말투를 학습해서 문장을 완성해 줍니다. (Ghost writing).', 'Speed: 지메일 웹보다 훨씬 빠르고 단축키가 잘 되어 있어 마우스 없이 키보드만으로 메일 처리가 가능합니다.'], ARRAY['Gmail 전용: 아웃룩(Outlook)이나 다른 메일 서비스는 아직 지원하지 않습니다. 오직 구글 계정만 가능합니다.', '무료 제한: 무료 플랜의 ''90일 검색 제한''은 치명적입니다. 옛날 메일을 찾으려면 지메일로 다시 들어가야 합니다.'], '[{"name": "AI Summary", "description": "모든 이메일 스레드 자동 요약"}, {"name": "Conversational Search", "description": "자연어로 이메일 검색 및 질의응답"}, {"name": "Ghost AI", "description": "사용자의 작문 스타일을 모방한 답장 초안 작성"}, {"name": "Smart Bundles", "description": "뉴스레터, 프로모션 메일을 카테고리별로 묶음 처리"}, {"name": "Calendar Integration", "description": "이메일 내용을 바탕으로 일정 바로 등록"}]'::jsonb,
    '{"recommended": [{"target": "✅ 인박스 제로", "reason": "메일함을 깨끗하게 비우는 걸 목표로 하는 생산성 덕후."}, {"target": "✅ 영어 이메일", "reason": "영어 메일을 요약해서 보고, 영어 답장을 AI 도움 받아 쓰고 싶은 분."}, {"target": "✅ 과거 구글 인박스 팬", "reason": "구글이 없애버린 Inbox by Gmail의 UI를 그리워하는 분."}], "not_recommended": [{"target": "❌ 아웃룩 유저", "reason": "회사 메일이 MS Exchange라면 그림의 떡입니다."}, {"target": "❌ 무료 헤비 유저", "reason": "3달 전 메일 검색이 안 되는 건 업무용으로 무료 쓰기에 부적합합니다."}]}'::jsonb, ARRAY['서명 설정: Shortwave에서 보낸 메일 하단에 "Sent with Shortwave" 문구가 기본으로 붙을 수 있으니 설정에서 확인하고 지우세요.', '알림 설정: 중요한 메일만 알림을 받고 나머지는 묶음 처리(Bundle)하는 설정을 해야 조용한 업무 환경이 됩니다.'], '{"description": "보안: SOC 2 인증을 받았으며, AI 기능은 개인정보 보호를 위해 사용자의 데이터를 모델 학습(Training)에 사용하지 않는다고 명시합니다."}'::jsonb,
    '[{"name": "Superhuman", "description": "더 빠르지만 더 비싼($30) 프리미엄 이메일 클라이언트"}, {"name": "Spark Mail", "description": "여러 계정(네이버, 아웃룩 등)을 한 번에 관리하고 싶다면"}]'::jsonb, '[{"title": "Introducing Shortwave AI Assistant", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Desktop"], "target_audience": "이메일 처리에 하루 1시간 이상 쓰는 직장인, 지메일 UI가 답답한 분"}'::jsonb,
    ARRAY['AI Summary', 'Conversational Search', 'Ghost AI', 'Smart Bundles', 'Calendar Integration'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Shortwave');

UPDATE ai_models SET
    description = '"세상에서 가장 빠른 이메일" — 0.1초의 딜레이도 허용하지 않는 속도와 강력한 AI 기능을 결합한 하이엔드 이메일 클라이언트.',
    website_url = 'https://superhuman.com/',
    pricing_model = 'Subscription (유료 전용)',
    pricing_info = '월 $30 (개인 / 연 결제 시 월 $25 수준).',
    free_tier_note = '무료 버전 없음.',
    pricing_plans = '[{"plan": "Member", "target": "전문가", "features": "모든 AI 기능, 무제한 속도, 단축키 마스터링", "price": "$30/월"}, {"plan": "Growth/Ent", "target": "기업", "features": "팀 공유 기능, 우선 지원", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['속도(Speed): 모든 동작이 100ms(0.1초) 이내에 반응하도록 설계되었습니다. 로딩 바를 볼 일이 없습니다.', 'Superhuman AI: "Instant Reply(즉시 답장)", "Auto Summarize(자동 요약)", "Ask AI(내 메일함 검색)" 기능이 매우 정교하고 빠릅니다.', '단축키: 마우스를 전혀 쓰지 않고 키보드 단축키만으로 메일을 읽고, 쓰고, 보내고, 분류할 수 있습니다. (게임 같은 조작감).', 'Outlook 지원: Shortwave와 달리 아웃룩 계정도 지원합니다.'],
    cons = ARRAY['가격: 이메일 앱 하나에 월 4만 원($30)을 태우는 건 일반인에게는 매우 비합리적입니다.', '진입 장벽: 단축키를 외우지 않으면 이 앱의 진가를 10%도 활용할 수 없습니다. (온보딩 교육이 있을 정도).'],
    key_features = '[{"name": "Instant Reply", "description": "AI가 맥락을 파악해 답장 초안을 즉시 작성"}, {"name": "Split Inbox", "description": "중요한 메일과 뉴스레터를 탭으로 자동 분리"}, {"name": "Snippet", "description": "자주 쓰는 문구를 단축키로 1초 만에 입력"}, {"name": "Read Status", "description": "상대방이 메일을 읽었는지 추적 (수신 확인)"}, {"name": "Ask AI", "description": "\"지난달 계약서 보낸 거 찾아줘\" 등 자연어 검색"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 경영진/임원", "reason": "시간당 가치가 매우 높아서 메일 처리 시간을 절반으로 줄이는 게 이득인 분."}, {"target": "✅ 키보드 워리어", "reason": "마우스 잡는 시간조차 아까운 개발자나 해커 성향의 유저."}, {"target": "✅ 얼리어답터", "reason": "실리콘밸리에서 가장 핫한 생산성 툴을 쓰고 있다는 만족감이 중요한 분."}], "not_recommended": [{"target": "❌ 일반 직장인", "reason": "회사에서 메일을 가끔 확인하는 정도라면 구글/아웃룩 기본 앱으로 충분합니다."}, {"target": "❌ 무료 선호", "reason": "유료 결제 없이는 설치조차 안 됩니다."}]}'::jsonb,
    usage_tips = ARRAY['수신 확인: 기본적으로 모든 메일에 수신 확인(Pixel)이 포함됩니다. 상대방이 이를 차단하거나 싫어할 수 있으니 설정에서 끌 수 있습니다.', '온보딩: 가입하면 직원이 1:1로 사용법을 알려주는 온보딩 세션이 있는데, 이걸 들어야 단축키를 제대로 배울 수 있습니다.'],
    privacy_info = '{"description": "보안: 구글의 보안 심사를 통과했으며, 데이터를 제3자에게 판매하지 않습니다. AI 기능 사용 시 데이터 활용 동의 여부를 확인하세요."}'::jsonb,
    alternatives = '[{"name": "Shortwave", "description": "지메일 사용자라면 훨씬 저렴한 AI 대안"}, {"name": "Spark Mail", "description": "깔끔한 디자인과 스마트 기능을 갖춘 대중적인 앱"}]'::jsonb,
    media_info = '[{"title": "Superhuman AI: The Future of Email", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Mac", "Windows"], "target_audience": "CEO, VC, 하루에 메일 100통 이상 처리하는 고소득 전문가"}'::jsonb,
    features = ARRAY['Instant Reply', 'Split Inbox', 'Snippet', 'Read Status', 'Ask AI']
WHERE name = 'Superhuman';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Superhuman', '"세상에서 가장 빠른 이메일" — 0.1초의 딜레이도 허용하지 않는 속도와 강력한 AI 기능을 결합한 하이엔드 이메일 클라이언트.', 'https://superhuman.com/',
    'Subscription (유료 전용)', '월 $30 (개인 / 연 결제 시 월 $25 수준).', '무료 버전 없음.',
    '[{"plan": "Member", "target": "전문가", "features": "모든 AI 기능, 무제한 속도, 단축키 마스터링", "price": "$30/월"}, {"plan": "Growth/Ent", "target": "기업", "features": "팀 공유 기능, 우선 지원", "price": "별도 문의"}]'::jsonb, ARRAY['속도(Speed): 모든 동작이 100ms(0.1초) 이내에 반응하도록 설계되었습니다. 로딩 바를 볼 일이 없습니다.', 'Superhuman AI: "Instant Reply(즉시 답장)", "Auto Summarize(자동 요약)", "Ask AI(내 메일함 검색)" 기능이 매우 정교하고 빠릅니다.', '단축키: 마우스를 전혀 쓰지 않고 키보드 단축키만으로 메일을 읽고, 쓰고, 보내고, 분류할 수 있습니다. (게임 같은 조작감).', 'Outlook 지원: Shortwave와 달리 아웃룩 계정도 지원합니다.'], ARRAY['가격: 이메일 앱 하나에 월 4만 원($30)을 태우는 건 일반인에게는 매우 비합리적입니다.', '진입 장벽: 단축키를 외우지 않으면 이 앱의 진가를 10%도 활용할 수 없습니다. (온보딩 교육이 있을 정도).'], '[{"name": "Instant Reply", "description": "AI가 맥락을 파악해 답장 초안을 즉시 작성"}, {"name": "Split Inbox", "description": "중요한 메일과 뉴스레터를 탭으로 자동 분리"}, {"name": "Snippet", "description": "자주 쓰는 문구를 단축키로 1초 만에 입력"}, {"name": "Read Status", "description": "상대방이 메일을 읽었는지 추적 (수신 확인)"}, {"name": "Ask AI", "description": "\"지난달 계약서 보낸 거 찾아줘\" 등 자연어 검색"}]'::jsonb,
    '{"recommended": [{"target": "✅ 경영진/임원", "reason": "시간당 가치가 매우 높아서 메일 처리 시간을 절반으로 줄이는 게 이득인 분."}, {"target": "✅ 키보드 워리어", "reason": "마우스 잡는 시간조차 아까운 개발자나 해커 성향의 유저."}, {"target": "✅ 얼리어답터", "reason": "실리콘밸리에서 가장 핫한 생산성 툴을 쓰고 있다는 만족감이 중요한 분."}], "not_recommended": [{"target": "❌ 일반 직장인", "reason": "회사에서 메일을 가끔 확인하는 정도라면 구글/아웃룩 기본 앱으로 충분합니다."}, {"target": "❌ 무료 선호", "reason": "유료 결제 없이는 설치조차 안 됩니다."}]}'::jsonb, ARRAY['수신 확인: 기본적으로 모든 메일에 수신 확인(Pixel)이 포함됩니다. 상대방이 이를 차단하거나 싫어할 수 있으니 설정에서 끌 수 있습니다.', '온보딩: 가입하면 직원이 1:1로 사용법을 알려주는 온보딩 세션이 있는데, 이걸 들어야 단축키를 제대로 배울 수 있습니다.'], '{"description": "보안: 구글의 보안 심사를 통과했으며, 데이터를 제3자에게 판매하지 않습니다. AI 기능 사용 시 데이터 활용 동의 여부를 확인하세요."}'::jsonb,
    '[{"name": "Shortwave", "description": "지메일 사용자라면 훨씬 저렴한 AI 대안"}, {"name": "Spark Mail", "description": "깔끔한 디자인과 스마트 기능을 갖춘 대중적인 앱"}]'::jsonb, '[{"title": "Superhuman AI: The Future of Email", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Mac", "Windows"], "target_audience": "CEO, VC, 하루에 메일 100통 이상 처리하는 고소득 전문가"}'::jsonb,
    ARRAY['Instant Reply', 'Split Inbox', 'Snippet', 'Read Status', 'Ask AI'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Superhuman');

UPDATE ai_models SET
    description = 'GPT-4, Claude 3.5, Gemini 등 최신 AI 모델을 하나의 사이드바에서 골라 쓸 수 있는 올인원 AI 브라우저 확장 프로그램.',
    website_url = 'https://monica.im/',
    pricing_model = 'Freemium (무료 + 유료 구독)',
    pricing_info = '월 $9.9 (Pro).',
    free_tier_note = '일일 40회 정도의 기본 채팅 무료. (GPT-4o 등 고급 모델은 횟수 제한이 더 빡빡함).',
    pricing_plans = '[{"plan": "Free", "target": "라이트 유저", "features": "일일 제한적 채팅, 기본 읽기/쓰기 기능", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "고급 모델(GPT-4/Claude) 넉넉한 쿼리, 이미지 생성", "price": "$9.9/월"}, {"plan": "Unlimited", "target": "전문가", "features": "무제한 고급 모델 쿼리, 전용 속도", "price": "$19.9/월"}]'::jsonb,
    pros = ARRAY['All-in-One Model: GPT-4o, Claude 3.5 Sonnet, Gemini 1.5 Pro 등 경쟁사의 유료 모델들을 모니카 하나 결제하면 다 쓸 수 있습니다. (가성비 갑).', 'Sidebar: 브라우저 옆에 항상 떠 있어서, 웹페이지 내용을 드래그하면 바로 번역하거나 요약해 줍니다. 탭을 왔다 갔다 할 필요가 없습니다.', 'Monica Bots: 특정 역할(번역가, 코딩 도우미, 여행 가이드)을 하는 봇을 원클릭으로 불러낼 수 있습니다.', '다양한 기능: PDF 요약, 유튜브 요약, 이미지 생성, 글쓰기 도구 등 AI로 할 수 있는 건 다 넣어놨습니다.'],
    cons = ARRAY['복잡한 UI: 기능이 너무 많아서 화면이 버튼으로 꽉 차 있어 처음엔 정신없을 수 있습니다.', '쿼리 제한: 유료 플랜이라도 ''고급 모델'' 사용 횟수에는 제한이 있을 수 있습니다. (무제한 플랜 확인 필요).'],
    key_features = '[{"name": "Model Switching", "description": "GPT-4o, Claude 3.5, Gemini 등 모델 선택 사용"}, {"name": "Web Summary", "description": "보고 있는 웹페이지/PDF 즉시 요약"}, {"name": "YouTube Summary", "description": "영상 타임라인별 내용 요약"}, {"name": "Writing Assistant", "description": "이메일, 트윗, 블로그 글 자동 작성"}, {"name": "Parallel Translate", "description": "웹페이지 원문과 번역문을 동시에 표시"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 모델 유목민", "reason": "챗지피티도 쓰고 싶고 클로드도 쓰고 싶은데 둘 다 결제하기엔 돈 아까운 분."}, {"target": "✅ 웹 서핑족", "reason": "해외 뉴스나 논문을 읽을 때 즉시 번역/요약이 필요한 분."}, {"target": "✅ 유튜브 요약", "reason": "영상을 다 볼 시간은 없고 핵심만 텍스트로 보고 싶은 분."}], "not_recommended": [{"target": "❌ 미니멀리스트", "reason": "브라우저가 깔끔한 걸 좋아한다면, 덕지덕지 붙는 기능이 거슬릴 수 있습니다."}, {"target": "❌ 깊이 있는 대화", "reason": "긴 문맥(Context)을 유지하며 심도 있는 프로젝트를 하기엔 전용 사이트(Claude.ai 등)가 더 안정적일 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['단축키 충돌: 모니카 호출 단축키(Cmd+M 등)가 다른 프로그램과 겹칠 수 있으니 설정에서 편한 키로 바꾸세요.', '모델 확인: 채팅창 상단에서 지금 쓰고 있는 모델이 ''GPT-3.5''인지 ''GPT-4''인지 확인하세요. 무료 쿼리를 아껴야 하니까요.'],
    privacy_info = '{"description": "페이지 접근: 브라우저 확장이므로 ''모든 웹사이트의 데이터 읽기'' 권한을 요구합니다. 민감한 금융 사이트에서는 확장을 끄는 것이 좋습니다."}'::jsonb,
    alternatives = '[{"name": "Liner", "description": "한국어 검색과 형광펜 기능에 더 특화된 툴"}, {"name": "Harpa AI", "description": "자동화 기능(모니터링)이 강력한 경쟁 확장 프로그램"}]'::jsonb,
    media_info = '[{"title": "Meet Monica: Your ChatGPT AI Copilot", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Chrome", "Edge", "Safari", "Mac", "Windows", "Mobile"], "target_audience": "웹 서핑을 하며 번역, 요약, 글쓰기를 한 번에 해결하고 싶은 모든 사람"}'::jsonb,
    features = ARRAY['Model Switching', 'Web Summary', 'YouTube Summary', 'Writing Assistant', 'Parallel Translate']
WHERE name = 'Monica';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Monica', 'GPT-4, Claude 3.5, Gemini 등 최신 AI 모델을 하나의 사이드바에서 골라 쓸 수 있는 올인원 AI 브라우저 확장 프로그램.', 'https://monica.im/',
    'Freemium (무료 + 유료 구독)', '월 $9.9 (Pro).', '일일 40회 정도의 기본 채팅 무료. (GPT-4o 등 고급 모델은 횟수 제한이 더 빡빡함).',
    '[{"plan": "Free", "target": "라이트 유저", "features": "일일 제한적 채팅, 기본 읽기/쓰기 기능", "price": "무료"}, {"plan": "Pro", "target": "헤비 유저", "features": "고급 모델(GPT-4/Claude) 넉넉한 쿼리, 이미지 생성", "price": "$9.9/월"}, {"plan": "Unlimited", "target": "전문가", "features": "무제한 고급 모델 쿼리, 전용 속도", "price": "$19.9/월"}]'::jsonb, ARRAY['All-in-One Model: GPT-4o, Claude 3.5 Sonnet, Gemini 1.5 Pro 등 경쟁사의 유료 모델들을 모니카 하나 결제하면 다 쓸 수 있습니다. (가성비 갑).', 'Sidebar: 브라우저 옆에 항상 떠 있어서, 웹페이지 내용을 드래그하면 바로 번역하거나 요약해 줍니다. 탭을 왔다 갔다 할 필요가 없습니다.', 'Monica Bots: 특정 역할(번역가, 코딩 도우미, 여행 가이드)을 하는 봇을 원클릭으로 불러낼 수 있습니다.', '다양한 기능: PDF 요약, 유튜브 요약, 이미지 생성, 글쓰기 도구 등 AI로 할 수 있는 건 다 넣어놨습니다.'], ARRAY['복잡한 UI: 기능이 너무 많아서 화면이 버튼으로 꽉 차 있어 처음엔 정신없을 수 있습니다.', '쿼리 제한: 유료 플랜이라도 ''고급 모델'' 사용 횟수에는 제한이 있을 수 있습니다. (무제한 플랜 확인 필요).'], '[{"name": "Model Switching", "description": "GPT-4o, Claude 3.5, Gemini 등 모델 선택 사용"}, {"name": "Web Summary", "description": "보고 있는 웹페이지/PDF 즉시 요약"}, {"name": "YouTube Summary", "description": "영상 타임라인별 내용 요약"}, {"name": "Writing Assistant", "description": "이메일, 트윗, 블로그 글 자동 작성"}, {"name": "Parallel Translate", "description": "웹페이지 원문과 번역문을 동시에 표시"}]'::jsonb,
    '{"recommended": [{"target": "✅ 모델 유목민", "reason": "챗지피티도 쓰고 싶고 클로드도 쓰고 싶은데 둘 다 결제하기엔 돈 아까운 분."}, {"target": "✅ 웹 서핑족", "reason": "해외 뉴스나 논문을 읽을 때 즉시 번역/요약이 필요한 분."}, {"target": "✅ 유튜브 요약", "reason": "영상을 다 볼 시간은 없고 핵심만 텍스트로 보고 싶은 분."}], "not_recommended": [{"target": "❌ 미니멀리스트", "reason": "브라우저가 깔끔한 걸 좋아한다면, 덕지덕지 붙는 기능이 거슬릴 수 있습니다."}, {"target": "❌ 깊이 있는 대화", "reason": "긴 문맥(Context)을 유지하며 심도 있는 프로젝트를 하기엔 전용 사이트(Claude.ai 등)가 더 안정적일 수 있습니다."}]}'::jsonb, ARRAY['단축키 충돌: 모니카 호출 단축키(Cmd+M 등)가 다른 프로그램과 겹칠 수 있으니 설정에서 편한 키로 바꾸세요.', '모델 확인: 채팅창 상단에서 지금 쓰고 있는 모델이 ''GPT-3.5''인지 ''GPT-4''인지 확인하세요. 무료 쿼리를 아껴야 하니까요.'], '{"description": "페이지 접근: 브라우저 확장이므로 ''모든 웹사이트의 데이터 읽기'' 권한을 요구합니다. 민감한 금융 사이트에서는 확장을 끄는 것이 좋습니다."}'::jsonb,
    '[{"name": "Liner", "description": "한국어 검색과 형광펜 기능에 더 특화된 툴"}, {"name": "Harpa AI", "description": "자동화 기능(모니터링)이 강력한 경쟁 확장 프로그램"}]'::jsonb, '[{"title": "Meet Monica: Your ChatGPT AI Copilot", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Chrome", "Edge", "Safari", "Mac", "Windows", "Mobile"], "target_audience": "웹 서핑을 하며 번역, 요약, 글쓰기를 한 번에 해결하고 싶은 모든 사람"}'::jsonb,
    ARRAY['Model Switching', 'Web Summary', 'YouTube Summary', 'Writing Assistant', 'Parallel Translate'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Monica');

UPDATE ai_models SET
    description = '검색어를 입력하면 단순한 답변이 아니라, AI가 실시간으로 조사하여 나만을 위한 맞춤형 위키 페이지(Sparkpage)를 만들어주는 차세대 검색 엔진.',
    website_url = 'https://www.genspark.ai/',
    pricing_model = 'Free (Beta) / Paid (Premium)',
    pricing_info = '월 $19.99 (Premium / 예상 가격, 변동 가능).',
    free_tier_note = '검색 및 Sparkpage(AI 페이지) 생성 무료. (베타 기간 동안 공격적인 무료 정책 유지 중).',
    pricing_plans = '[{"plan": "Free", "target": "일반 사용자", "features": "무제한 검색, Sparkpage 생성, 기본 모델", "price": "무료"}, {"plan": "Premium", "target": "헤비 유저", "features": "고급 모델(GPT-4o 등) 무제한, 심층 리서치", "price": "$19.99/월"}]'::jsonb,
    pros = ARRAY['Sparkpage: "오사카 3박 4일 여행 코스 짜줘"라고 하면, 단순히 텍스트로 답하는 게 아니라 지도, 영상, 맛집 정보가 담긴 예쁜 웹페이지를 하나 만들어줍니다. (Perplexity와의 차별점).', 'Autopilot Agent: AI 에이전트가 여러 웹사이트를 돌아다니며 정보를 교차 검증하고 취합합니다.', '신뢰성: 정보의 출처를 명확히 표시하고, 광고 없는 클린한 결과를 보여줍니다.', '큐레이션: 검색 결과가 블로그 글처럼 목차와 이미지로 구조화되어 있어 읽기 편합니다.'],
    cons = ARRAY['속도: 단순 텍스트 검색보다 페이지를 구성하는 데 시간이 조금 더 걸릴 수 있습니다 (몇 초 수준).', '최신성: 실시간 뉴스 속보보다는, 정돈된 정보(가이드, 리뷰)를 찾는 데 더 적합합니다.'],
    key_features = '[{"name": "Sparkpage Generator", "description": "검색어 기반 맞춤형 웹페이지 생성"}, {"name": "AI Parallel Search", "description": "여러 소스를 동시에 검색하여 정보 취합"}, {"name": "Comparison Table", "description": "제품/서비스 스펙 비교표 자동 생성"}, {"name": "Travel Guide", "description": "지도와 동선이 포함된 여행 가이드 생성"}, {"name": "Pros & Cons", "description": "리뷰 기반의 장단점 분석"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 여행 계획러", "reason": "맛집, 호텔, 관광지 정보를 한 페이지에 정리해서 동행인에게 공유하고 싶은 분."}, {"target": "✅ 쇼핑 고민", "reason": "\"아이폰 16 vs 갤럭시 S25 비교\"처럼 스펙 비교표와 리뷰 요약이 필요한 분."}, {"target": "✅ 리포트 작성", "reason": "특정 주제에 대해 깊이 있는 자료 조사가 필요한 학생/직장인."}], "not_recommended": [{"target": "❌ 단답형 검색", "reason": "\"오늘 날씨\", \"환율\" 같은 건 구글이나 네이버가 더 빠릅니다."}, {"target": "❌ 대화형 선호", "reason": "페이지를 읽는 것보다 채팅으로 묻고 답하는 걸 선호하면 ChatGPT나 Perplexity가 낫습니다."}]}'::jsonb,
    usage_tips = ARRAY['공유: 생성된 Sparkpage는 링크로 공유할 수 있습니다. 친구에게 설명할 때 링크 하나 던져주면 끝납니다.', '수정: AI가 만든 페이지 내용이 마음에 안 들면, 채팅으로 "이 부분 빼고 저렴한 맛집으로 바꿔줘"라고 수정 요청할 수 있습니다.'],
    privacy_info = '{"description": "출처: 모든 정보에는 각주가 달려 있어 원본 사이트를 확인할 수 있으며, 환각(거짓 정보)을 줄이기 위해 검색 결과에 기반합니다."}'::jsonb,
    alternatives = '[{"name": "Perplexity", "description": "더 빠르고 대화형 검색에 집중된 툴"}, {"name": "Arc Search", "description": "모바일에서 ''Browse for me'' 기능으로 유사한 경험 제공"}]'::jsonb,
    media_info = '[{"title": "Introducing Genspark", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "여행 계획을 짜거나, 제품 비교를 하거나, 특정 주제를 깊게 파고들고 싶은 사람"}'::jsonb,
    features = ARRAY['Sparkpage Generator', 'AI Parallel Search', 'Comparison Table', 'Travel Guide', 'Pros & Cons']
WHERE name = 'Genspark';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Genspark', '검색어를 입력하면 단순한 답변이 아니라, AI가 실시간으로 조사하여 나만을 위한 맞춤형 위키 페이지(Sparkpage)를 만들어주는 차세대 검색 엔진.', 'https://www.genspark.ai/',
    'Free (Beta) / Paid (Premium)', '월 $19.99 (Premium / 예상 가격, 변동 가능).', '검색 및 Sparkpage(AI 페이지) 생성 무료. (베타 기간 동안 공격적인 무료 정책 유지 중).',
    '[{"plan": "Free", "target": "일반 사용자", "features": "무제한 검색, Sparkpage 생성, 기본 모델", "price": "무료"}, {"plan": "Premium", "target": "헤비 유저", "features": "고급 모델(GPT-4o 등) 무제한, 심층 리서치", "price": "$19.99/월"}]'::jsonb, ARRAY['Sparkpage: "오사카 3박 4일 여행 코스 짜줘"라고 하면, 단순히 텍스트로 답하는 게 아니라 지도, 영상, 맛집 정보가 담긴 예쁜 웹페이지를 하나 만들어줍니다. (Perplexity와의 차별점).', 'Autopilot Agent: AI 에이전트가 여러 웹사이트를 돌아다니며 정보를 교차 검증하고 취합합니다.', '신뢰성: 정보의 출처를 명확히 표시하고, 광고 없는 클린한 결과를 보여줍니다.', '큐레이션: 검색 결과가 블로그 글처럼 목차와 이미지로 구조화되어 있어 읽기 편합니다.'], ARRAY['속도: 단순 텍스트 검색보다 페이지를 구성하는 데 시간이 조금 더 걸릴 수 있습니다 (몇 초 수준).', '최신성: 실시간 뉴스 속보보다는, 정돈된 정보(가이드, 리뷰)를 찾는 데 더 적합합니다.'], '[{"name": "Sparkpage Generator", "description": "검색어 기반 맞춤형 웹페이지 생성"}, {"name": "AI Parallel Search", "description": "여러 소스를 동시에 검색하여 정보 취합"}, {"name": "Comparison Table", "description": "제품/서비스 스펙 비교표 자동 생성"}, {"name": "Travel Guide", "description": "지도와 동선이 포함된 여행 가이드 생성"}, {"name": "Pros & Cons", "description": "리뷰 기반의 장단점 분석"}]'::jsonb,
    '{"recommended": [{"target": "✅ 여행 계획러", "reason": "맛집, 호텔, 관광지 정보를 한 페이지에 정리해서 동행인에게 공유하고 싶은 분."}, {"target": "✅ 쇼핑 고민", "reason": "\"아이폰 16 vs 갤럭시 S25 비교\"처럼 스펙 비교표와 리뷰 요약이 필요한 분."}, {"target": "✅ 리포트 작성", "reason": "특정 주제에 대해 깊이 있는 자료 조사가 필요한 학생/직장인."}], "not_recommended": [{"target": "❌ 단답형 검색", "reason": "\"오늘 날씨\", \"환율\" 같은 건 구글이나 네이버가 더 빠릅니다."}, {"target": "❌ 대화형 선호", "reason": "페이지를 읽는 것보다 채팅으로 묻고 답하는 걸 선호하면 ChatGPT나 Perplexity가 낫습니다."}]}'::jsonb, ARRAY['공유: 생성된 Sparkpage는 링크로 공유할 수 있습니다. 친구에게 설명할 때 링크 하나 던져주면 끝납니다.', '수정: AI가 만든 페이지 내용이 마음에 안 들면, 채팅으로 "이 부분 빼고 저렴한 맛집으로 바꿔줘"라고 수정 요청할 수 있습니다.'], '{"description": "출처: 모든 정보에는 각주가 달려 있어 원본 사이트를 확인할 수 있으며, 환각(거짓 정보)을 줄이기 위해 검색 결과에 기반합니다."}'::jsonb,
    '[{"name": "Perplexity", "description": "더 빠르고 대화형 검색에 집중된 툴"}, {"name": "Arc Search", "description": "모바일에서 ''Browse for me'' 기능으로 유사한 경험 제공"}]'::jsonb, '[{"title": "Introducing Genspark", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "여행 계획을 짜거나, 제품 비교를 하거나, 특정 주제를 깊게 파고들고 싶은 사람"}'::jsonb,
    ARRAY['Sparkpage Generator', 'AI Parallel Search', 'Comparison Table', 'Travel Guide', 'Pros & Cons'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Genspark');

UPDATE ai_models SET
    description = '영상만 찍으면 자막, 편집, 더빙, 심지어 눈 맞춤(Eye Contact)까지 AI가 알아서 해주는 숏폼 크리에이터의 필수 앱.',
    website_url = 'https://www.captions.ai/',
    pricing_model = 'Subscription (유료 중심)',
    pricing_info = '월 $13~15 (연간 결제 시).',
    free_tier_note = '앱 설치 후 제한된 기능 체험 가능하나, 워터마크가 붙거나 내보내기 제한이 있어 실사용엔 유료 구독이 필수적입니다.',
    pricing_plans = '[{"plan": "Free", "target": "체험", "features": "워터마크, 일부 AI 기능 제한", "price": "무료"}, {"plan": "Pro", "target": "크리에이터", "features": "AI Eye Contact, Lipdub, 자막 스타일링, 워터마크 제거", "price": "$13/월"}, {"plan": "Max", "target": "전문가", "features": "더 많은 생성 시간, 데스크톱 앱 사용", "price": "$30/월"}]'::jsonb,
    pros = ARRAY['AI Eye Contact: 대본을 읽느라 눈동자가 옆을 봐도, AI가 눈동자를 카메라 정면을 보도록 감쪽같이 수정해 줍니다. (가장 유명한 기능).', 'Lipdub (립덥): 한국어로 찍은 영상을 영어, 스페인어 등으로 더빙해주는데, 입모양까지 언어에 맞춰 바꿔줍니다.', 'AI Edit: 말실수한 부분(음, 어...)을 자동으로 잘라내고, 적절한 타이밍에 줌인/줌아웃 효과를 넣어 지루하지 않게 만듭니다.', 'AI Music: 영상 분위기에 맞는 배경음악을 저작권 걱정 없이 생성해 깔아줍니다.'],
    cons = ARRAY['유료 필수: 무료로는 사실상 제대로 된 영상을 뽑기 어렵습니다. 숏폼에 진심인 분들만 결제하세요.', '부자연스러움: Eye Contact 기능이 가끔 눈을 너무 부릅뜨게 만들어서 무서울 때가 있습니다 (강도 조절 필요).'],
    key_features = '[{"name": "AI Eye Contact", "description": "시선 교정 (프롬프터 독서 시 유용)"}, {"name": "AI Lipdub", "description": "다국어 번역 및 입모양 동기화"}, {"name": "Auto Captions", "description": "화려한 애니메이션 자막 자동 생성"}, {"name": "AI Trim", "description": "무음 구간 및 실수 구간 자동 삭제"}, {"name": "AI Music & Sound", "description": "영상에 맞는 BGM 및 효과음 자동 삽입"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 대본 리딩", "reason": "카메라 보고 말하는 게 어색해서 프롬프터를 읽어야 하는 분 (Eye Contact)."}, {"target": "✅ 글로벌 진출", "reason": "내 숏폼 영상을 외국어로 번역해서 전 세계에 뿌리고 싶은 분 (Lipdub)."}, {"target": "✅ 편집 초보", "reason": "컷편집, 자막, 효과음 넣는 게 너무 귀찮고 오래 걸리는 분."}], "not_recommended": [{"target": "❌ 긴 영상", "reason": "10분 이상의 유튜브 롱폼 영상 편집용으로는 무겁고 적합하지 않습니다. (숏폼 특화)."}, {"target": "❌ PC 편집", "reason": "모바일 앱에서 시작된 툴이라 PC 웹 버전보다는 모바일 앱 경험이 더 강력합니다."}]}'::jsonb,
    usage_tips = ARRAY['눈동자 조절: Eye Contact 기능을 쓸 때 적용 강도를 조절하세요. 100%로 하면 로봇처럼 보일 수 있습니다.', '자막 수정: AI 자막이 완벽하지 않으므로, 업로드 전에 오타나 띄어쓰기를 한 번 훑어봐야 합니다.'],
    privacy_info = '{"description": "클라우드 처리: 영상 처리를 위해 클라우드 서버로 업로드됩니다."}'::jsonb,
    alternatives = '[{"name": "Vrew", "description": "한국어 자막 편집과 AI 목소리 활용이 주력이라면 (PC 무료 기능 많음)"}, {"name": "CapCut", "description": "무료로 다양한 편집 효과를 쓰고 싶다면"}]'::jsonb,
    media_info = '[{"title": "Captions App: Your AI Video Creator", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["iOS", "Android", "Desktop (Web", "Mac)"], "target_audience": "틱톡/릴스/쇼츠 크리에이터, 카메라 울렁증이 있는 유튜버"}'::jsonb,
    features = ARRAY['AI Eye Contact', 'AI Lipdub', 'Auto Captions', 'AI Trim', 'AI Music & Sound']
WHERE name = 'Captions';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Captions', '영상만 찍으면 자막, 편집, 더빙, 심지어 눈 맞춤(Eye Contact)까지 AI가 알아서 해주는 숏폼 크리에이터의 필수 앱.', 'https://www.captions.ai/',
    'Subscription (유료 중심)', '월 $13~15 (연간 결제 시).', '앱 설치 후 제한된 기능 체험 가능하나, 워터마크가 붙거나 내보내기 제한이 있어 실사용엔 유료 구독이 필수적입니다.',
    '[{"plan": "Free", "target": "체험", "features": "워터마크, 일부 AI 기능 제한", "price": "무료"}, {"plan": "Pro", "target": "크리에이터", "features": "AI Eye Contact, Lipdub, 자막 스타일링, 워터마크 제거", "price": "$13/월"}, {"plan": "Max", "target": "전문가", "features": "더 많은 생성 시간, 데스크톱 앱 사용", "price": "$30/월"}]'::jsonb, ARRAY['AI Eye Contact: 대본을 읽느라 눈동자가 옆을 봐도, AI가 눈동자를 카메라 정면을 보도록 감쪽같이 수정해 줍니다. (가장 유명한 기능).', 'Lipdub (립덥): 한국어로 찍은 영상을 영어, 스페인어 등으로 더빙해주는데, 입모양까지 언어에 맞춰 바꿔줍니다.', 'AI Edit: 말실수한 부분(음, 어...)을 자동으로 잘라내고, 적절한 타이밍에 줌인/줌아웃 효과를 넣어 지루하지 않게 만듭니다.', 'AI Music: 영상 분위기에 맞는 배경음악을 저작권 걱정 없이 생성해 깔아줍니다.'], ARRAY['유료 필수: 무료로는 사실상 제대로 된 영상을 뽑기 어렵습니다. 숏폼에 진심인 분들만 결제하세요.', '부자연스러움: Eye Contact 기능이 가끔 눈을 너무 부릅뜨게 만들어서 무서울 때가 있습니다 (강도 조절 필요).'], '[{"name": "AI Eye Contact", "description": "시선 교정 (프롬프터 독서 시 유용)"}, {"name": "AI Lipdub", "description": "다국어 번역 및 입모양 동기화"}, {"name": "Auto Captions", "description": "화려한 애니메이션 자막 자동 생성"}, {"name": "AI Trim", "description": "무음 구간 및 실수 구간 자동 삭제"}, {"name": "AI Music & Sound", "description": "영상에 맞는 BGM 및 효과음 자동 삽입"}]'::jsonb,
    '{"recommended": [{"target": "✅ 대본 리딩", "reason": "카메라 보고 말하는 게 어색해서 프롬프터를 읽어야 하는 분 (Eye Contact)."}, {"target": "✅ 글로벌 진출", "reason": "내 숏폼 영상을 외국어로 번역해서 전 세계에 뿌리고 싶은 분 (Lipdub)."}, {"target": "✅ 편집 초보", "reason": "컷편집, 자막, 효과음 넣는 게 너무 귀찮고 오래 걸리는 분."}], "not_recommended": [{"target": "❌ 긴 영상", "reason": "10분 이상의 유튜브 롱폼 영상 편집용으로는 무겁고 적합하지 않습니다. (숏폼 특화)."}, {"target": "❌ PC 편집", "reason": "모바일 앱에서 시작된 툴이라 PC 웹 버전보다는 모바일 앱 경험이 더 강력합니다."}]}'::jsonb, ARRAY['눈동자 조절: Eye Contact 기능을 쓸 때 적용 강도를 조절하세요. 100%로 하면 로봇처럼 보일 수 있습니다.', '자막 수정: AI 자막이 완벽하지 않으므로, 업로드 전에 오타나 띄어쓰기를 한 번 훑어봐야 합니다.'], '{"description": "클라우드 처리: 영상 처리를 위해 클라우드 서버로 업로드됩니다."}'::jsonb,
    '[{"name": "Vrew", "description": "한국어 자막 편집과 AI 목소리 활용이 주력이라면 (PC 무료 기능 많음)"}, {"name": "CapCut", "description": "무료로 다양한 편집 효과를 쓰고 싶다면"}]'::jsonb, '[{"title": "Captions App: Your AI Video Creator", "url": "https://www.youtube.com/ (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["iOS", "Android", "Desktop (Web", "Mac)"], "target_audience": "틱톡/릴스/쇼츠 크리에이터, 카메라 울렁증이 있는 유튜버"}'::jsonb,
    ARRAY['AI Eye Contact', 'AI Lipdub', 'Auto Captions', 'AI Trim', 'AI Music & Sound'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Captions');

UPDATE ai_models SET
    description = '할 일(Task)과 일정(Calendar)을 입력하면, 마감 기한과 우선순위에 맞춰 "오늘 하루 스케줄을 AI가 자동으로 짜주는" 자율 주행 플래너.',
    website_url = 'https://www.usemotion.com/',
    pricing_model = 'Subscription (유료 전용)',
    pricing_info = '월 $19 (Individual / 연간 결제 시) / 월 $34 (월 결제 시).',
    free_tier_note = '7일 무료 체험(Trial) 제공. 체험 종료 후 자동 결제되므로 주의. (완전 무료 버전 없음).',
    pricing_plans = '[{"plan": "Individual", "target": "개인/프리랜서", "features": "AI 오토 스케줄링, 프로젝트 관리, 캘린더 통합", "price": "$19/월 (연간)"}, {"plan": "Team", "target": "조직", "features": "팀원 간 일정 조율, 프로젝트 할당, 업무 부하 관리", "price": "$12/인/월"}]'::jsonb,
    pros = ARRAY['Happiness Algorithm: "오늘 오후 2시 회의"가 갑자기 생기면, 그 시간에 하려던 ''보고서 작성'' 업무를 알아서 오후 4시나 내일 오전 빈 시간으로 옮겨줍니다. (가장 큰 강점).', 'Deep Work: 자잘한 미팅 사이에 낀 30분짜리 틈새 시간을 피하고, 2시간 이상 집중할 수 있는 덩어리 시간을 확보해 줍니다.', 'Booking: Calendly처럼 "내 가능한 시간 예약해" 링크를 상대방에게 보내 일정 잡는 기능이 포함되어 있습니다.', '통합: 할 일 목록(To-do)과 캘린더가 분리되지 않고 하나로 합쳐져 있어 "언제 할지"를 고민할 필요가 없습니다.'],
    cons = ARRAY['비싼 가격: 개인용 캘린더 앱 치고는 월 2~4만 원대로 비싼 편입니다.', '적응 기간: AI가 짜준 스케줄대로 움직이는 것에 익숙해지는 데 시간이 걸립니다. (통제권을 잃는 느낌이 들 수 있음).'],
    key_features = '[{"name": "Auto-Scheduling", "description": "마감일/소요시간 입력 시 최적의 시간 배정"}, {"name": "Rescheduling", "description": "일정이 밀리면 남은 업무 자동 재배치"}, {"name": "Meeting Scheduler", "description": "예약 링크 생성 및 가용 시간 공유"}, {"name": "Project Management", "description": "칸반 보드 및 리스트 뷰 지원"}, {"name": "Focus Time", "description": "방해 금지 모드 및 집중 시간 자동 확보"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ ADHD 성향", "reason": "우선순위를 못 정해서 하루 종일 딴짓하다가 야근하는 분. (AI가 \"지금 이거 해\"라고 정해줌)."}, {"target": "✅ 미팅 많은 직군", "reason": "회의 사이사이 비는 시간에 할 일을 자동으로 끼워 넣고 싶은 분."}, {"target": "✅ 프리랜서", "reason": "마감 기한(Deadline)이 여러 개인 프로젝트를 동시에 관리해야 하는 분."}], "not_recommended": [{"target": "❌ 단순 기록용", "reason": "그냥 일정만 적어두는 다이어리 용도라면 구글 캘린더나 노션이 낫습니다."}, {"target": "❌ 유동적 업무", "reason": "돌발 상황이 너무 많아 계획 자체가 무의미한 현장직."}]}'::jsonb,
    usage_tips = ARRAY['설정 디테일: 업무 시간(예: 9-6)을 정확히 설정해야 AI가 새벽 2시에 일을 배정하지 않습니다.', '쪼개기: "보고서 쓰기(4시간)" 통째로 넣기보다 "자료 조사(1시간)", "초안 작성(2시간)" 등으로 쪼개 넣어야 AI가 배치를 잘합니다.'],
    privacy_info = '{"description": "캘린더 접근: 구글/MS 캘린더의 읽기/쓰기 권한이 필요합니다. 보안이 엄격한 사내 계정은 연동이 막힐 수 있습니다."}'::jsonb,
    alternatives = '[{"name": "Reclaim.ai", "description": "구글 캘린더 중심의 자동 스케줄러 (개인 무료 플랜 있음)"}, {"name": "FlowSavvy", "description": "Motion의 저렴한 대안 (기능은 유사)"}]'::jsonb,
    media_info = '[{"title": "Motion: The AI Exec that manages your day", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Mac", "Windows", "Chrome Extension"], "target_audience": "ADHD 성향이 있는 분, 미팅과 할 일이 뒤섞여 관리가 안 되는 PM/프리랜서"}'::jsonb,
    features = ARRAY['Auto-Scheduling', 'Rescheduling', 'Meeting Scheduler', 'Project Management', 'Focus Time']
WHERE name = 'Motion';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Motion', '할 일(Task)과 일정(Calendar)을 입력하면, 마감 기한과 우선순위에 맞춰 "오늘 하루 스케줄을 AI가 자동으로 짜주는" 자율 주행 플래너.', 'https://www.usemotion.com/',
    'Subscription (유료 전용)', '월 $19 (Individual / 연간 결제 시) / 월 $34 (월 결제 시).', '7일 무료 체험(Trial) 제공. 체험 종료 후 자동 결제되므로 주의. (완전 무료 버전 없음).',
    '[{"plan": "Individual", "target": "개인/프리랜서", "features": "AI 오토 스케줄링, 프로젝트 관리, 캘린더 통합", "price": "$19/월 (연간)"}, {"plan": "Team", "target": "조직", "features": "팀원 간 일정 조율, 프로젝트 할당, 업무 부하 관리", "price": "$12/인/월"}]'::jsonb, ARRAY['Happiness Algorithm: "오늘 오후 2시 회의"가 갑자기 생기면, 그 시간에 하려던 ''보고서 작성'' 업무를 알아서 오후 4시나 내일 오전 빈 시간으로 옮겨줍니다. (가장 큰 강점).', 'Deep Work: 자잘한 미팅 사이에 낀 30분짜리 틈새 시간을 피하고, 2시간 이상 집중할 수 있는 덩어리 시간을 확보해 줍니다.', 'Booking: Calendly처럼 "내 가능한 시간 예약해" 링크를 상대방에게 보내 일정 잡는 기능이 포함되어 있습니다.', '통합: 할 일 목록(To-do)과 캘린더가 분리되지 않고 하나로 합쳐져 있어 "언제 할지"를 고민할 필요가 없습니다.'], ARRAY['비싼 가격: 개인용 캘린더 앱 치고는 월 2~4만 원대로 비싼 편입니다.', '적응 기간: AI가 짜준 스케줄대로 움직이는 것에 익숙해지는 데 시간이 걸립니다. (통제권을 잃는 느낌이 들 수 있음).'], '[{"name": "Auto-Scheduling", "description": "마감일/소요시간 입력 시 최적의 시간 배정"}, {"name": "Rescheduling", "description": "일정이 밀리면 남은 업무 자동 재배치"}, {"name": "Meeting Scheduler", "description": "예약 링크 생성 및 가용 시간 공유"}, {"name": "Project Management", "description": "칸반 보드 및 리스트 뷰 지원"}, {"name": "Focus Time", "description": "방해 금지 모드 및 집중 시간 자동 확보"}]'::jsonb,
    '{"recommended": [{"target": "✅ ADHD 성향", "reason": "우선순위를 못 정해서 하루 종일 딴짓하다가 야근하는 분. (AI가 \"지금 이거 해\"라고 정해줌)."}, {"target": "✅ 미팅 많은 직군", "reason": "회의 사이사이 비는 시간에 할 일을 자동으로 끼워 넣고 싶은 분."}, {"target": "✅ 프리랜서", "reason": "마감 기한(Deadline)이 여러 개인 프로젝트를 동시에 관리해야 하는 분."}], "not_recommended": [{"target": "❌ 단순 기록용", "reason": "그냥 일정만 적어두는 다이어리 용도라면 구글 캘린더나 노션이 낫습니다."}, {"target": "❌ 유동적 업무", "reason": "돌발 상황이 너무 많아 계획 자체가 무의미한 현장직."}]}'::jsonb, ARRAY['설정 디테일: 업무 시간(예: 9-6)을 정확히 설정해야 AI가 새벽 2시에 일을 배정하지 않습니다.', '쪼개기: "보고서 쓰기(4시간)" 통째로 넣기보다 "자료 조사(1시간)", "초안 작성(2시간)" 등으로 쪼개 넣어야 AI가 배치를 잘합니다.'], '{"description": "캘린더 접근: 구글/MS 캘린더의 읽기/쓰기 권한이 필요합니다. 보안이 엄격한 사내 계정은 연동이 막힐 수 있습니다."}'::jsonb,
    '[{"name": "Reclaim.ai", "description": "구글 캘린더 중심의 자동 스케줄러 (개인 무료 플랜 있음)"}, {"name": "FlowSavvy", "description": "Motion의 저렴한 대안 (기능은 유사)"}]'::jsonb, '[{"title": "Motion: The AI Exec that manages your day", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": false, "login_required": "Required", "platforms": ["Web", "iOS", "Android", "Mac", "Windows", "Chrome Extension"], "target_audience": "ADHD 성향이 있는 분, 미팅과 할 일이 뒤섞여 관리가 안 되는 PM/프리랜서"}'::jsonb,
    ARRAY['Auto-Scheduling', 'Rescheduling', 'Meeting Scheduler', 'Project Management', 'Focus Time'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Motion');

UPDATE ai_models SET
    description = '"디자인 감각 제로여도 괜찮아" — 슬라이드 내용을 입력하면 레이아웃, 색상, 정렬을 AI가 강제로(?) 예쁘게 맞춰주는 제약 기반 프레젠테이션 툴.',
    website_url = 'https://www.beautiful.ai/',
    pricing_model = 'Subscription (유료 전용)',
    pricing_info = '월 $12 (Pro / 연간 결제 시).',
    free_tier_note = '14일 무료 체험. (체험 종료 후 자동 결제). 간혹 프로젝트 1건당 일회성 결제($45) 옵션을 제공하기도 함.',
    pricing_plans = '[{"plan": "Pro", "target": "개인", "features": "무제한 슬라이드, AI 생성, PPT 내보내기", "price": "$12/월 (연간)"}, {"plan": "Team", "target": "조직", "features": "팀 라이브러리, 공유 테마, 중앙 결제", "price": "$40/인/월"}, {"plan": "Ad-hoc", "target": "급한 분", "features": "1개 프레젠테이션 생성 (월 구독 아님)", "price": "$45 (1회)"}]'::jsonb,
    pros = ARRAY['Smart Slide: 텍스트 상자를 추가하거나 이미지를 넣으면, 슬라이드 전체 레이아웃이 알아서 재조정됩니다. (줄 맞춤, 간격 조절 불필요).', 'DesignerBot: "스마트폰 시장 점유율에 대한 발표 자료 만들어줘"라고 입력하면, 목차부터 차트까지 포함된 초안 덱을 1분 만에 만듭니다.', '제약의 미학: 사용자가 디자인을 망치지 못하게 막습니다. 폰트 크기나 색상을 템플릿 규칙 안에서만 바꾸게 강제하여 통일성을 유지합니다.', '차트 애니메이션: 그래프 수치만 입력하면 아주 부드럽고 세련된 애니메이션이 자동으로 적용됩니다.'],
    cons = ARRAY['자유도 부족: "이 이미지를 딱 여기 1픽셀 옆에 두고 싶은데"가 안 됩니다. 정해진 그리드(Grid)에만 배치됩니다.', 'PPT 호환성: 파워포인트로 내보내기(Export)는 되지만, Beautiful.ai 특유의 스마트 기능이 PPT에서는 깨지거나 이미지로 변환될 수 있습니다.'],
    key_features = '[{"name": "DesignerBot", "description": "텍스트 프롬프트로 전체 슬라이드 덱 생성"}, {"name": "Smart Templates", "description": "내용을 넣으면 구조가 변하는 지능형 템플릿"}, {"name": "Stock Library", "description": "수백만 개의 무료 이미지, 아이콘, 영상 제공"}, {"name": "Analytics", "description": "공유한 링크를 누가 얼마나 봤는지 추적 (Pro)"}, {"name": "PowerPoint Export", "description": "편집 가능한 PPT 파일로 내보내기"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 영업 제안서", "reason": "깔끔하고 신뢰감 있는 디자인을 빠르게 뽑아야 하는 분."}, {"target": "✅ 디자인 똥손", "reason": "내가 만지면 PPT가 촌스러워지는 분 (AI가 색 조합을 다 해줌)."}, {"target": "✅ 스타트업 IR", "reason": "투자자에게 보여줄 세련된 피치덱이 필요한 대표님."}], "not_recommended": [{"target": "❌ 디자이너", "reason": "픽셀 단위의 정교한 배치가 필요한 분에게는 답답할 수 있습니다."}, {"target": "❌ 애니메이션 장인", "reason": "PPT의 화려한 화면 전환 효과를 100% 구현하고 싶은 분."}]}'::jsonb,
    usage_tips = ARRAY['월 결제 가격: 연간 결제 시 월 $12지만, 월 단위 결제(Monthly)를 선택하면 월 $45로 매우 비쌉니다. 장기 사용 시 무조건 연간이 유리합니다.', 'PPT 변환: PPT로 받으면 폰트가 깨질 수 있으니, 중요한 발표는 Beautiful.ai 뷰어 링크나 PDF를 쓰는 게 안전합니다.'],
    privacy_info = '{"description": "보안: 엔터프라이즈 플랜에서는 SSO 및 감사 로그를 지원합니다."}'::jsonb,
    alternatives = '[{"name": "Gamma", "description": "문서(Doc)처럼 쓰면 PPT가 되는 더 유연한 툴 (무료 체험 넉넉함)"}, {"name": "Canva", "description": "디자인 요소가 더 많고 자유도가 높은 툴"}]'::jsonb,
    media_info = '[{"title": "Beautiful.ai: The First AI Presentation Maker", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "PowerPoint Add-in"], "target_audience": "PPT 줄 맞춤에 시간 쓰기 싫은 직장인, 깔끔한 제안서가 필요한 영업팀"}'::jsonb,
    features = ARRAY['DesignerBot', 'Smart Templates', 'Stock Library', 'Analytics', 'PowerPoint Export']
WHERE name = 'Beautiful.ai';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Beautiful.ai', '"디자인 감각 제로여도 괜찮아" — 슬라이드 내용을 입력하면 레이아웃, 색상, 정렬을 AI가 강제로(?) 예쁘게 맞춰주는 제약 기반 프레젠테이션 툴.', 'https://www.beautiful.ai/',
    'Subscription (유료 전용)', '월 $12 (Pro / 연간 결제 시).', '14일 무료 체험. (체험 종료 후 자동 결제). 간혹 프로젝트 1건당 일회성 결제($45) 옵션을 제공하기도 함.',
    '[{"plan": "Pro", "target": "개인", "features": "무제한 슬라이드, AI 생성, PPT 내보내기", "price": "$12/월 (연간)"}, {"plan": "Team", "target": "조직", "features": "팀 라이브러리, 공유 테마, 중앙 결제", "price": "$40/인/월"}, {"plan": "Ad-hoc", "target": "급한 분", "features": "1개 프레젠테이션 생성 (월 구독 아님)", "price": "$45 (1회)"}]'::jsonb, ARRAY['Smart Slide: 텍스트 상자를 추가하거나 이미지를 넣으면, 슬라이드 전체 레이아웃이 알아서 재조정됩니다. (줄 맞춤, 간격 조절 불필요).', 'DesignerBot: "스마트폰 시장 점유율에 대한 발표 자료 만들어줘"라고 입력하면, 목차부터 차트까지 포함된 초안 덱을 1분 만에 만듭니다.', '제약의 미학: 사용자가 디자인을 망치지 못하게 막습니다. 폰트 크기나 색상을 템플릿 규칙 안에서만 바꾸게 강제하여 통일성을 유지합니다.', '차트 애니메이션: 그래프 수치만 입력하면 아주 부드럽고 세련된 애니메이션이 자동으로 적용됩니다.'], ARRAY['자유도 부족: "이 이미지를 딱 여기 1픽셀 옆에 두고 싶은데"가 안 됩니다. 정해진 그리드(Grid)에만 배치됩니다.', 'PPT 호환성: 파워포인트로 내보내기(Export)는 되지만, Beautiful.ai 특유의 스마트 기능이 PPT에서는 깨지거나 이미지로 변환될 수 있습니다.'], '[{"name": "DesignerBot", "description": "텍스트 프롬프트로 전체 슬라이드 덱 생성"}, {"name": "Smart Templates", "description": "내용을 넣으면 구조가 변하는 지능형 템플릿"}, {"name": "Stock Library", "description": "수백만 개의 무료 이미지, 아이콘, 영상 제공"}, {"name": "Analytics", "description": "공유한 링크를 누가 얼마나 봤는지 추적 (Pro)"}, {"name": "PowerPoint Export", "description": "편집 가능한 PPT 파일로 내보내기"}]'::jsonb,
    '{"recommended": [{"target": "✅ 영업 제안서", "reason": "깔끔하고 신뢰감 있는 디자인을 빠르게 뽑아야 하는 분."}, {"target": "✅ 디자인 똥손", "reason": "내가 만지면 PPT가 촌스러워지는 분 (AI가 색 조합을 다 해줌)."}, {"target": "✅ 스타트업 IR", "reason": "투자자에게 보여줄 세련된 피치덱이 필요한 대표님."}], "not_recommended": [{"target": "❌ 디자이너", "reason": "픽셀 단위의 정교한 배치가 필요한 분에게는 답답할 수 있습니다."}, {"target": "❌ 애니메이션 장인", "reason": "PPT의 화려한 화면 전환 효과를 100% 구현하고 싶은 분."}]}'::jsonb, ARRAY['월 결제 가격: 연간 결제 시 월 $12지만, 월 단위 결제(Monthly)를 선택하면 월 $45로 매우 비쌉니다. 장기 사용 시 무조건 연간이 유리합니다.', 'PPT 변환: PPT로 받으면 폰트가 깨질 수 있으니, 중요한 발표는 Beautiful.ai 뷰어 링크나 PDF를 쓰는 게 안전합니다.'], '{"description": "보안: 엔터프라이즈 플랜에서는 SSO 및 감사 로그를 지원합니다."}'::jsonb,
    '[{"name": "Gamma", "description": "문서(Doc)처럼 쓰면 PPT가 되는 더 유연한 툴 (무료 체험 넉넉함)"}, {"name": "Canva", "description": "디자인 요소가 더 많고 자유도가 높은 툴"}]'::jsonb, '[{"title": "Beautiful.ai: The First AI Presentation Maker", "url": "https://www.youtube.com/watch?v= (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "PowerPoint Add-in"], "target_audience": "PPT 줄 맞춤에 시간 쓰기 싫은 직장인, 깔끔한 제안서가 필요한 영업팀"}'::jsonb,
    ARRAY['DesignerBot', 'Smart Templates', 'Stock Library', 'Analytics', 'PowerPoint Export'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Beautiful.ai');

UPDATE ai_models SET
    description = '복잡한 기능 없이 주제만 입력하면 1분 안에 파워포인트(PPTX) 파일 구조를 잡아주는 초간편 AI 프레젠테이션 생성기.',
    website_url = 'https://autoppt.com/) (또는 유사 서비스',
    pricing_model = 'Freemium / Pay-per-download',
    pricing_info = '건당 결제 또는 저렴한 월 구독 (서비스별 상이, 보통 $5~9 수준).',
    free_tier_note = '가입 시 무료 생성 횟수(약 1~2회) 제공. 워터마크가 있거나 슬라이드 수 제한이 있을 수 있음.',
    pricing_plans = '[{"plan": "Free", "target": "찍먹파", "features": "기본 템플릿, 제한적 슬라이드 수", "price": "무료"}, {"plan": "Pro/Premium", "target": "학생/직장인", "features": "무제한 생성, 워터마크 제거, 더 많은 템플릿", "price": "소액 결제"}]'::jsonb,
    pros = ARRAY['심플함: 기능이 복잡한 Beautiful.ai나 Gamma와 달리, 딱 "주제 입력 -> PPT 파일 다운로드"에만 집중되어 있습니다.', 'PPTX 호환: 생성된 결과물이 파워포인트 파일(.pptx)로 바로 떨어지므로, 다운받아서 파워포인트에서 수정하기가 가장 편합니다.', '속도: 디자인 요소를 렌더링하는 시간이 짧아 결과물이 매우 빨리 나옵니다.'],
    cons = ARRAY['디자인 퀄리티: Beautiful.ai나 Gamma에 비해 디자인 세련미는 떨어질 수 있습니다. (기본 템플릿 수준).', '기능 제한: 차트 애니메이션이나 인터랙티브 기능은 거의 없습니다. 텍스트와 이미지를 배치해 주는 정도입니다.'],
    key_features = '[{"name": "Text to PPT", "description": "주제/개요 입력으로 PPT 자동 생성"}, {"name": "Outline Editor", "description": "생성 전 목차(Outline) 수정 가능"}, {"name": "Image Search", "description": "슬라이드 내용에 맞는 이미지 자동 검색 및 삽입"}, {"name": "Export to PPTX", "description": "파워포인트 원본 파일 다운로드"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 대학생 과제", "reason": "교양 과제용으로 빠르게 PPT 초안을 만들어야 할 때."}, {"target": "✅ 초안 작성", "reason": "\"백지공포증\" 때문에 첫 슬라이드 채우기가 힘든 분."}, {"target": "✅ 파워포인트 필수", "reason": "회사/학교 규정상 반드시 pptx 파일로 제출해야 하는 경우."}], "not_recommended": [{"target": "❌ 중요한 발표", "reason": "투자 유치나 대형 컨퍼런스용으로는 디자인 퀄리티가 부족합니다."}, {"target": "❌ 복잡한 데이터", "reason": "엑셀 데이터를 연동해서 차트를 그려야 한다면 Julius나 Beautiful.ai를 쓰세요."}]}'::jsonb,
    usage_tips = ARRAY['내용 검증: AI가 채워준 텍스트(본문)는 일반적인 내용일 뿐입니다. 반드시 본인의 구체적인 데이터나 사례로 내용을 갈아끼워야 합니다.', '이미지 저작권: 자동 삽입된 이미지의 저작권을 확인하거나, 본인이 가진 고화질 이미지로 교체하는 것을 추천합니다.'],
    privacy_info = '{"description": "일회성: 대부분의 간편 생성기는 데이터를 장기 보관하기보다 생성 및 다운로드에 초점을 맞춥니다."}'::jsonb,
    alternatives = '[{"name": "Gamma", "description": "디자인이 훨씬 예쁘고 웹 기반 발표도 가능한 상위 호환 툴"}, {"name": "SlidesAI.io", "description": "구글 슬라이드 안에서 바로 생성하고 싶다면"}]'::jsonb,
    media_info = '[{"title": "How to create PPT with AI in 1 minute", "url": "https://www.youtube.com/ (유사 튜토리얼 검색 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "PPT 목차와 초안 잡는 게 귀찮은 대학생, 급하게 발표 자료 뼈대가 필요한 분"}'::jsonb,
    features = ARRAY['Text to PPT', 'Outline Editor', 'Image Search', 'Export to PPTX']
WHERE name = 'Autoppt';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Autoppt', '복잡한 기능 없이 주제만 입력하면 1분 안에 파워포인트(PPTX) 파일 구조를 잡아주는 초간편 AI 프레젠테이션 생성기.', 'https://autoppt.com/) (또는 유사 서비스',
    'Freemium / Pay-per-download', '건당 결제 또는 저렴한 월 구독 (서비스별 상이, 보통 $5~9 수준).', '가입 시 무료 생성 횟수(약 1~2회) 제공. 워터마크가 있거나 슬라이드 수 제한이 있을 수 있음.',
    '[{"plan": "Free", "target": "찍먹파", "features": "기본 템플릿, 제한적 슬라이드 수", "price": "무료"}, {"plan": "Pro/Premium", "target": "학생/직장인", "features": "무제한 생성, 워터마크 제거, 더 많은 템플릿", "price": "소액 결제"}]'::jsonb, ARRAY['심플함: 기능이 복잡한 Beautiful.ai나 Gamma와 달리, 딱 "주제 입력 -> PPT 파일 다운로드"에만 집중되어 있습니다.', 'PPTX 호환: 생성된 결과물이 파워포인트 파일(.pptx)로 바로 떨어지므로, 다운받아서 파워포인트에서 수정하기가 가장 편합니다.', '속도: 디자인 요소를 렌더링하는 시간이 짧아 결과물이 매우 빨리 나옵니다.'], ARRAY['디자인 퀄리티: Beautiful.ai나 Gamma에 비해 디자인 세련미는 떨어질 수 있습니다. (기본 템플릿 수준).', '기능 제한: 차트 애니메이션이나 인터랙티브 기능은 거의 없습니다. 텍스트와 이미지를 배치해 주는 정도입니다.'], '[{"name": "Text to PPT", "description": "주제/개요 입력으로 PPT 자동 생성"}, {"name": "Outline Editor", "description": "생성 전 목차(Outline) 수정 가능"}, {"name": "Image Search", "description": "슬라이드 내용에 맞는 이미지 자동 검색 및 삽입"}, {"name": "Export to PPTX", "description": "파워포인트 원본 파일 다운로드"}]'::jsonb,
    '{"recommended": [{"target": "✅ 대학생 과제", "reason": "교양 과제용으로 빠르게 PPT 초안을 만들어야 할 때."}, {"target": "✅ 초안 작성", "reason": "\"백지공포증\" 때문에 첫 슬라이드 채우기가 힘든 분."}, {"target": "✅ 파워포인트 필수", "reason": "회사/학교 규정상 반드시 pptx 파일로 제출해야 하는 경우."}], "not_recommended": [{"target": "❌ 중요한 발표", "reason": "투자 유치나 대형 컨퍼런스용으로는 디자인 퀄리티가 부족합니다."}, {"target": "❌ 복잡한 데이터", "reason": "엑셀 데이터를 연동해서 차트를 그려야 한다면 Julius나 Beautiful.ai를 쓰세요."}]}'::jsonb, ARRAY['내용 검증: AI가 채워준 텍스트(본문)는 일반적인 내용일 뿐입니다. 반드시 본인의 구체적인 데이터나 사례로 내용을 갈아끼워야 합니다.', '이미지 저작권: 자동 삽입된 이미지의 저작권을 확인하거나, 본인이 가진 고화질 이미지로 교체하는 것을 추천합니다.'], '{"description": "일회성: 대부분의 간편 생성기는 데이터를 장기 보관하기보다 생성 및 다운로드에 초점을 맞춥니다."}'::jsonb,
    '[{"name": "Gamma", "description": "디자인이 훨씬 예쁘고 웹 기반 발표도 가능한 상위 호환 툴"}, {"name": "SlidesAI.io", "description": "구글 슬라이드 안에서 바로 생성하고 싶다면"}]'::jsonb, '[{"title": "How to create PPT with AI in 1 minute", "url": "https://www.youtube.com/ (유사 튜토리얼 검색 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web"], "target_audience": "PPT 목차와 초안 잡는 게 귀찮은 대학생, 급하게 발표 자료 뼈대가 필요한 분"}'::jsonb,
    ARRAY['Text to PPT', 'Outline Editor', 'Image Search', 'Export to PPTX'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Autoppt');

UPDATE ai_models SET
    description = '"가격 파괴자, 성능 괴물" — OpenAI o1급의 추론 능력(R1)과 GPT-4급 성능(V3)을 1/10도 안 되는 가격에 제공하는 중국발 오픈소스 AI 모델.',
    website_url = 'https://www.deepseek.com/',
    pricing_model = 'Free (Web Chat) / Ultra-low cost API',
    pricing_info = 'API 가격이 충격적으로 저렴함. (GPT-4o 대비 약 1/10 ~ 1/20 수준).',
    free_tier_note = '웹사이트(Chat)에서 DeepSeek-V3 및 DeepSeek-R1(추론 모델) 무료 사용. (트래픽 몰리면 대기).',
    pricing_plans = '[{"plan": "Chat (Web)", "target": "일반인", "features": "DeepSeek-V3/R1 모델 무료, 검색 기능 포함", "price": "무료"}, {"plan": "API", "target": "개발자", "features": "입력 $0.14 / 출력 $0.28 (1M 토큰당), 캐싱 할인", "price": "종량제 (초저가)"}]'::jsonb,
    pros = ARRAY['압도적 가성비: API 비용이 경쟁사(OpenAI, Anthropic) 대비 말도 안 되게 저렴합니다. 개발자들이 열광하는 이유 1순위입니다.', 'DeepSeek-R1 (Reasoning): OpenAI o1처럼 "생각하는 과정(Chain of Thought)"을 거쳐 답변하는 모델로, 수학/코딩/논리 문제에서 세계 최고 수준의 성능을 보여줍니다.', '코딩 능력: 개발자들 사이에서 "코딩은 딥시크가 GPT-4보다 낫다"는 평이 나올 정도로 코드 생성 및 디버깅 능력이 탁월합니다.', '오픈 웨이트: 모델의 가중치(Weights)를 공개하여, 기업이나 연구소가 자체 서버에 설치해(Self-hosted) 쓸 수 있습니다.'],
    cons = ARRAY['검열/보안 우려: 중국 기업(ByteDance 출신 등)이 개발했으므로, 정치적 이슈에 대한 검열이 있거나 기업 내부 데이터 보안에 대한 우려가 있을 수 있습니다.', '서버 불안정: 전 세계적으로 사용자가 폭주하여 API나 웹 채팅이 자주 터지거나 느려질 때가 있습니다. (2025/26 기준).'],
    key_features = '[{"name": "DeepSeek-V3", "description": "GPT-4o급 범용 고성능 챗봇"}, {"name": "DeepSeek-R1", "description": "심층 추론(Reasoning) 및 CoT 과정을 보여주는 모델"}, {"name": "Context Caching", "description": "자주 쓰는 프롬프트를 캐싱해 API 비용을 더 낮춤 (최대 90% 할인)"}, {"name": "FIM (Fill-In-the-Middle)", "description": "코드 중간을 채워넣는 기능 (코딩 보조에 최적)"}, {"name": "Web Search", "description": "실시간 웹 검색 결과를 반영한 답변"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 개발자", "reason": "Cursor, Windsurf 같은 IDE에 DeepSeek API를 연결해 코딩 비용을 90% 줄이고 싶은 분."}, {"target": "✅ 수학/과학도", "reason": "복잡한 수식을 증명하거나 논리 퀴즈를 풀어야 하는 분 (R1 모델)."}, {"target": "✅ 스타트업", "reason": "AI 서비스를 만들고 싶은데 API 비용이 부담되는 대표님."}], "not_recommended": [{"target": "❌ 보안 극민감", "reason": "국가 기밀이나 극비 기술을 다루는 곳이라면 사용을 재고하거나 로컬 설치를 권장합니다."}, {"target": "❌ 창의적 글쓰기", "reason": "팩트와 논리에는 강하지만, 감성적인 소설이나 에세이 작성은 Claude가 더 나을 수 있습니다."}]}'::jsonb,
    usage_tips = ARRAY['API 연동: Cursor 에디터 등에서 ''OpenAI Compatible'' 설정으로 DeepSeek API URL(`https://api.deepseek.com`)을 넣으면 바로 쓸 수 있습니다.', '생각 과정: R1 모델을 쓸 때 "생각 과정(Thought process)"이 길게 출력됩니다. 답만 보고 싶으면 이 부분을 접어두거나 건너뛰세요.'],
    privacy_info = '{"description": "서버 위치: 중국 및 글로벌 서버를 혼용할 수 있으므로, 민감 정보는 API보다는 로컬 설치(Ollama 등)를 통해 처리하는 것이 안전합니다."}'::jsonb,
    alternatives = '[{"name": "OpenAI o1 / o3", "description": "추론 능력의 원조 (성능은 비슷하거나 우위, 가격은 훨씬 비쌈)"}, {"name": "Claude 3.5 Sonnet", "description": "코딩과 글쓰기 밸런스가 가장 좋은 모델"}]'::jsonb,
    media_info = '[{"title": "DeepSeek-V3 & R1: The New King of Open Source AI?", "url": "https://www.youtube.com/ (리뷰 채널 검색 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Mobile App", "API"], "target_audience": "개발자(API 비용 절감), 이공계생(수학/코딩), 가성비 AI를 찾는 모든 사람"}'::jsonb,
    features = ARRAY['DeepSeek-V3', 'DeepSeek-R1', 'Context Caching', 'FIM (Fill-In-the-Middle)', 'Web Search']
WHERE name = 'DeepSeek';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'DeepSeek', '"가격 파괴자, 성능 괴물" — OpenAI o1급의 추론 능력(R1)과 GPT-4급 성능(V3)을 1/10도 안 되는 가격에 제공하는 중국발 오픈소스 AI 모델.', 'https://www.deepseek.com/',
    'Free (Web Chat) / Ultra-low cost API', 'API 가격이 충격적으로 저렴함. (GPT-4o 대비 약 1/10 ~ 1/20 수준).', '웹사이트(Chat)에서 DeepSeek-V3 및 DeepSeek-R1(추론 모델) 무료 사용. (트래픽 몰리면 대기).',
    '[{"plan": "Chat (Web)", "target": "일반인", "features": "DeepSeek-V3/R1 모델 무료, 검색 기능 포함", "price": "무료"}, {"plan": "API", "target": "개발자", "features": "입력 $0.14 / 출력 $0.28 (1M 토큰당), 캐싱 할인", "price": "종량제 (초저가)"}]'::jsonb, ARRAY['압도적 가성비: API 비용이 경쟁사(OpenAI, Anthropic) 대비 말도 안 되게 저렴합니다. 개발자들이 열광하는 이유 1순위입니다.', 'DeepSeek-R1 (Reasoning): OpenAI o1처럼 "생각하는 과정(Chain of Thought)"을 거쳐 답변하는 모델로, 수학/코딩/논리 문제에서 세계 최고 수준의 성능을 보여줍니다.', '코딩 능력: 개발자들 사이에서 "코딩은 딥시크가 GPT-4보다 낫다"는 평이 나올 정도로 코드 생성 및 디버깅 능력이 탁월합니다.', '오픈 웨이트: 모델의 가중치(Weights)를 공개하여, 기업이나 연구소가 자체 서버에 설치해(Self-hosted) 쓸 수 있습니다.'], ARRAY['검열/보안 우려: 중국 기업(ByteDance 출신 등)이 개발했으므로, 정치적 이슈에 대한 검열이 있거나 기업 내부 데이터 보안에 대한 우려가 있을 수 있습니다.', '서버 불안정: 전 세계적으로 사용자가 폭주하여 API나 웹 채팅이 자주 터지거나 느려질 때가 있습니다. (2025/26 기준).'], '[{"name": "DeepSeek-V3", "description": "GPT-4o급 범용 고성능 챗봇"}, {"name": "DeepSeek-R1", "description": "심층 추론(Reasoning) 및 CoT 과정을 보여주는 모델"}, {"name": "Context Caching", "description": "자주 쓰는 프롬프트를 캐싱해 API 비용을 더 낮춤 (최대 90% 할인)"}, {"name": "FIM (Fill-In-the-Middle)", "description": "코드 중간을 채워넣는 기능 (코딩 보조에 최적)"}, {"name": "Web Search", "description": "실시간 웹 검색 결과를 반영한 답변"}]'::jsonb,
    '{"recommended": [{"target": "✅ 개발자", "reason": "Cursor, Windsurf 같은 IDE에 DeepSeek API를 연결해 코딩 비용을 90% 줄이고 싶은 분."}, {"target": "✅ 수학/과학도", "reason": "복잡한 수식을 증명하거나 논리 퀴즈를 풀어야 하는 분 (R1 모델)."}, {"target": "✅ 스타트업", "reason": "AI 서비스를 만들고 싶은데 API 비용이 부담되는 대표님."}], "not_recommended": [{"target": "❌ 보안 극민감", "reason": "국가 기밀이나 극비 기술을 다루는 곳이라면 사용을 재고하거나 로컬 설치를 권장합니다."}, {"target": "❌ 창의적 글쓰기", "reason": "팩트와 논리에는 강하지만, 감성적인 소설이나 에세이 작성은 Claude가 더 나을 수 있습니다."}]}'::jsonb, ARRAY['API 연동: Cursor 에디터 등에서 ''OpenAI Compatible'' 설정으로 DeepSeek API URL(`https://api.deepseek.com`)을 넣으면 바로 쓸 수 있습니다.', '생각 과정: R1 모델을 쓸 때 "생각 과정(Thought process)"이 길게 출력됩니다. 답만 보고 싶으면 이 부분을 접어두거나 건너뛰세요.'], '{"description": "서버 위치: 중국 및 글로벌 서버를 혼용할 수 있으므로, 민감 정보는 API보다는 로컬 설치(Ollama 등)를 통해 처리하는 것이 안전합니다."}'::jsonb,
    '[{"name": "OpenAI o1 / o3", "description": "추론 능력의 원조 (성능은 비슷하거나 우위, 가격은 훨씬 비쌈)"}, {"name": "Claude 3.5 Sonnet", "description": "코딩과 글쓰기 밸런스가 가장 좋은 모델"}]'::jsonb, '[{"title": "DeepSeek-V3 & R1: The New King of Open Source AI?", "url": "https://www.youtube.com/ (리뷰 채널 검색 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web", "Mobile App", "API"], "target_audience": "개발자(API 비용 절감), 이공계생(수학/코딩), 가성비 AI를 찾는 모든 사람"}'::jsonb,
    ARRAY['DeepSeek-V3', 'DeepSeek-R1', 'Context Caching', 'FIM (Fill-In-the-Middle)', 'Web Search'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'DeepSeek');

UPDATE ai_models SET
    description = 'X(구 트위터)의 실시간 데이터를 독점적으로 학습하여, 가장 최신의 트렌드와 뉴스를 거침없이(Fun Mode) 답변해 주는 일론 머스크의 AI.',
    website_url = 'https://www.google.com/search?q=https://x.com/i/grok',
    pricing_model = 'Subscription (X Premium 포함)',
    pricing_info = '월 약 22,000원 (X Premium+ / 웹 결제 기준).',
    free_tier_note = '기본적으로 유료 전용 서비스입니다. (X Premium+ 구독자 대상).',
    pricing_plans = '[{"plan": "Basic/Premium", "target": "일반 유저", "features": "Grok 사용 불가 (일부 국가 제외)", "price": "-"}, {"plan": "Premium+", "target": "헤비 유저", "features": "Grok-2/3 무제한, 광고 제거, 긴 글 게시", "price": "월 2.2만 원"}]'::jsonb,
    pros = ARRAY['Real-time Access: 전 세계에서 일어나는 속보를 X(트위터) 실시간 피드에서 바로 긁어와 분석합니다. "지금 강남역 상황 어때?"에 가장 빨리 답합니다.', 'Fun Mode: "정치적 올바름(PC)"에 과도하게 얽매이지 않고, 풍자와 유머를 섞어 시원하게 답변하는 ''재미 모드''가 있습니다.', 'Image Generation: FLUX 모델 기반으로 텍스트를 입력하면 고퀄리티 이미지를 생성해 줍니다. (검열이 비교적 자유로움).', 'Grok Vision: 사진을 올리면 "이 짤방이 왜 웃긴 거야?" 같은 맥락을 해석해 줍니다.'],
    cons = ARRAY['비싼 가격: Grok 하나 쓰자고 X Premium+를 결제하기엔 가격 장벽이 높습니다.', '정보 편향: 트위터 유저들의 여론을 기반으로 하다 보니, 확인되지 않은 루머를 사실처럼 말할 위험이 있습니다.'],
    key_features = '[{"name": "Real-time News", "description": "X 게시물 기반 실시간 정보 검색 및 요약"}, {"name": "Fun/Regular Mode", "description": "답변 스타일(진지함/재미) 선택 가능"}, {"name": "Image Generation", "description": "텍스트로 이미지 생성 (FLUX 기반)"}, {"name": "Post Analysis", "description": "특정 트윗이나 계정의 성향 분석"}, {"name": "Code Assistant", "description": "파이썬, 자바스크립트 등 코딩 답변 가능"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 트렌드 마케터", "reason": "지금 당장 SNS에서 뜨는 이슈나 밈(Meme)을 파악해야 하는 분."}, {"target": "✅ 주식/코인 투자", "reason": "실시간 뉴스 속보와 대중의 반응(Sentiment)을 빨리 알고 싶은 분."}, {"target": "✅ 유머 감각", "reason": "딱딱한 AI 답변 말고, 친구처럼 비꼬거나 농담 따먹기 하는 AI를 원하는 분."}], "not_recommended": [{"target": "❌ 학술 연구", "reason": "논문 검색이나 팩트 체크가 중요한 엄근진한 작업에는 부적합합니다."}, {"target": "❌ SNS 비사용자", "reason": "트위터를 안 한다면 굳이 비싼 돈 내고 쓸 이유가 없습니다."}]}'::jsonb,
    usage_tips = ARRAY['팩트 체크: "실시간 정보"가 무조건 "사실"은 아닙니다. 트위터발 루머일 수 있으니 반드시 교차 검증하세요.', '결제 플랫폼: 아이폰 앱에서 결제하면 수수료 때문에 더 비쌉니다. 반드시 웹(PC)에서 결제하세요.'],
    privacy_info = '{"description": "X 데이터 학습: 사용자가 X에 올린 공개 게시물은 Grok의 학습 데이터로 사용될 수 있습니다. (설정에서 끄기 가능)."}'::jsonb,
    alternatives = '[{"name": "Perplexity", "description": "실시간 검색이 필요하지만 좀 더 정제된 뉴스 소스를 원한다면"}, {"name": "ChatGPT (Search)", "description": "오픈AI의 검색 기능을 활용한다면"}]'::jsonb,
    media_info = '[{"title": "Introducing Grok", "url": "https://www.youtube.com/ (xAI 공식 채널 확인 권장)", "platform": "X / YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web (X.com)", "Mobile App (X)"], "target_audience": "실시간 뉴스/여론 파악이 필요한 마케터, 검열 없는 답변을 원하는 사용자"}'::jsonb,
    features = ARRAY['Real-time News', 'Fun/Regular Mode', 'Image Generation', 'Post Analysis', 'Code Assistant']
WHERE name = 'Grok';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Grok', 'X(구 트위터)의 실시간 데이터를 독점적으로 학습하여, 가장 최신의 트렌드와 뉴스를 거침없이(Fun Mode) 답변해 주는 일론 머스크의 AI.', 'https://www.google.com/search?q=https://x.com/i/grok',
    'Subscription (X Premium 포함)', '월 약 22,000원 (X Premium+ / 웹 결제 기준).', '기본적으로 유료 전용 서비스입니다. (X Premium+ 구독자 대상).',
    '[{"plan": "Basic/Premium", "target": "일반 유저", "features": "Grok 사용 불가 (일부 국가 제외)", "price": "-"}, {"plan": "Premium+", "target": "헤비 유저", "features": "Grok-2/3 무제한, 광고 제거, 긴 글 게시", "price": "월 2.2만 원"}]'::jsonb, ARRAY['Real-time Access: 전 세계에서 일어나는 속보를 X(트위터) 실시간 피드에서 바로 긁어와 분석합니다. "지금 강남역 상황 어때?"에 가장 빨리 답합니다.', 'Fun Mode: "정치적 올바름(PC)"에 과도하게 얽매이지 않고, 풍자와 유머를 섞어 시원하게 답변하는 ''재미 모드''가 있습니다.', 'Image Generation: FLUX 모델 기반으로 텍스트를 입력하면 고퀄리티 이미지를 생성해 줍니다. (검열이 비교적 자유로움).', 'Grok Vision: 사진을 올리면 "이 짤방이 왜 웃긴 거야?" 같은 맥락을 해석해 줍니다.'], ARRAY['비싼 가격: Grok 하나 쓰자고 X Premium+를 결제하기엔 가격 장벽이 높습니다.', '정보 편향: 트위터 유저들의 여론을 기반으로 하다 보니, 확인되지 않은 루머를 사실처럼 말할 위험이 있습니다.'], '[{"name": "Real-time News", "description": "X 게시물 기반 실시간 정보 검색 및 요약"}, {"name": "Fun/Regular Mode", "description": "답변 스타일(진지함/재미) 선택 가능"}, {"name": "Image Generation", "description": "텍스트로 이미지 생성 (FLUX 기반)"}, {"name": "Post Analysis", "description": "특정 트윗이나 계정의 성향 분석"}, {"name": "Code Assistant", "description": "파이썬, 자바스크립트 등 코딩 답변 가능"}]'::jsonb,
    '{"recommended": [{"target": "✅ 트렌드 마케터", "reason": "지금 당장 SNS에서 뜨는 이슈나 밈(Meme)을 파악해야 하는 분."}, {"target": "✅ 주식/코인 투자", "reason": "실시간 뉴스 속보와 대중의 반응(Sentiment)을 빨리 알고 싶은 분."}, {"target": "✅ 유머 감각", "reason": "딱딱한 AI 답변 말고, 친구처럼 비꼬거나 농담 따먹기 하는 AI를 원하는 분."}], "not_recommended": [{"target": "❌ 학술 연구", "reason": "논문 검색이나 팩트 체크가 중요한 엄근진한 작업에는 부적합합니다."}, {"target": "❌ SNS 비사용자", "reason": "트위터를 안 한다면 굳이 비싼 돈 내고 쓸 이유가 없습니다."}]}'::jsonb, ARRAY['팩트 체크: "실시간 정보"가 무조건 "사실"은 아닙니다. 트위터발 루머일 수 있으니 반드시 교차 검증하세요.', '결제 플랫폼: 아이폰 앱에서 결제하면 수수료 때문에 더 비쌉니다. 반드시 웹(PC)에서 결제하세요.'], '{"description": "X 데이터 학습: 사용자가 X에 올린 공개 게시물은 Grok의 학습 데이터로 사용될 수 있습니다. (설정에서 끄기 가능)."}'::jsonb,
    '[{"name": "Perplexity", "description": "실시간 검색이 필요하지만 좀 더 정제된 뉴스 소스를 원한다면"}, {"name": "ChatGPT (Search)", "description": "오픈AI의 검색 기능을 활용한다면"}]'::jsonb, '[{"title": "Introducing Grok", "url": "https://www.youtube.com/ (xAI 공식 채널 확인 권장)", "platform": "X / YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web (X.com)", "Mobile App (X)"], "target_audience": "실시간 뉴스/여론 파악이 필요한 마케터, 검열 없는 답변을 원하는 사용자"}'::jsonb,
    ARRAY['Real-time News', 'Fun/Regular Mode', 'Image Generation', 'Post Analysis', 'Code Assistant'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Grok');

UPDATE ai_models SET
    description = '유럽의 자존심이자 오픈소스 AI의 최강자. 가벼우면서도 GPT-4급 성능을 내는 효율적인 모델과 챗봇 서비스 ''Le Chat''을 제공.',
    website_url = 'https://chat.mistral.ai/',
    pricing_model = 'Freemium (웹 챗 무료 + API 종량제)',
    pricing_info = 'API 사용 시 종량제 / Le Chat 유료 플랜(예상).',
    free_tier_note = 'Le Chat(르 챗) 서비스에서 Mistral Large 2, Codestral 등 최상위 모델을 무료로 사용 가능. (베타 기간 혜택).',
    pricing_plans = '[{"plan": "Le Chat (Free)", "target": "일반인", "features": "Mistral Large, Codestral 무료, 웹 검색", "price": "무료"}, {"plan": "La Plateforme", "target": "개발자", "features": "API 호출, 파인튜닝, 모델 선택", "price": "종량제"}, {"plan": "Enterprise", "target": "기업", "features": "사내 구축(On-premise), 보안 강화", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['Le Chat (무료): 경쟁사들이 월 $20 받는 수준의 고성능 모델(Mistral Large)을 웹사이트에서 공짜로 풀고 있습니다. (가성비 1위).', 'Codestral: 코딩에 특화된 모델 ''Codestral''을 선택하면, 코드 생성 및 디버깅 능력이 탁월합니다.', '효율성: 모델 사이즈 대비 성능이 압도적으로 좋아, 로컬(내 컴퓨터)에 설치해서 돌리기에 가장 적합한 모델들을 제공합니다.', '유럽 감성: 미국 기업(OpenAI, Google)과 달리 EU의 엄격한 개인정보 보호 기준을 준수하며, 다국어(유럽 언어) 처리에 강합니다.'],
    cons = ARRAY['부가 기능: ChatGPT처럼 ''음성 대화'', ''이미지 편집'' 같은 화려한 멀티모달 기능은 상대적으로 적습니다. (텍스트/코드 집중).', '생태계: GPTs(스토어) 같은 플러그인 생태계는 아직 부족합니다.'],
    key_features = '[{"name": "Le Chat", "description": "무료 웹 챗봇 인터페이스 (검색 기능 포함)"}, {"name": "Mistral Large", "description": "추론 및 상식 능력이 뛰어난 플래그십 모델"}, {"name": "Codestral", "description": "80개 프로그래밍 언어를 학습한 코딩 특화 모델"}, {"name": "Open Weights", "description": "모델 가중치를 공개하여 누구나 다운로드 가능 (일부 모델)"}, {"name": "Canvas", "description": "(최신) 코드를 별도 창에서 편집하고 미리보는 기능"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 무료 유저", "reason": "돈 내기 싫은데 GPT-4급 성능을 웹에서 쓰고 싶은 분."}, {"target": "✅ 개발자", "reason": "내 노트북(Mac M1/M2 등)에 LLM을 설치해서 오프라인으로 돌려보고 싶은 분 (Ollama와 궁합 최고)."}, {"target": "✅ 보안 중시", "reason": "미국 기업에 데이터를 넘기기 껄끄러운 유럽 비즈니스 관계자."}], "not_recommended": [{"target": "❌ 이미지 생성", "reason": "그림 그려주는 기능이 필요하면 미드저니나 달리로 가세요."}, {"target": "❌ 음성 비서", "reason": "말로 대화하는 기능은 아직 약합니다."}]}'::jsonb,
    usage_tips = ARRAY['모델 선택: Le Chat 채팅창에서 모델을 ''Large''나 ''Codestral''로 바꿀 수 있습니다. 코딩 질문은 꼭 Codestral로 하세요.', '로컬 설치: Mistral 모델을 다운받아 쓰려면 ''Ollama''나 ''LM Studio'' 같은 툴을 먼저 설치해야 합니다.'],
    privacy_info = '{"description": "GDPR 준수: 프랑스 기업으로 유럽 데이터 보호법을 철저히 따르며, 기업용 플랜은 학습 데이터 사용을 금지합니다."}'::jsonb,
    alternatives = '[{"name": "ChatGPT (OpenAI)", "description": "가장 무난하고 기능이 많은 대장주"}, {"name": "Claude (Anthropic)", "description": "문학적 글쓰기와 긴 문맥 처리에 강점"}]'::jsonb,
    media_info = '[{"title": "Mistral AI: The Open Weight Revolution", "url": "https://www.youtube.com/ (공식 채널/인터뷰 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Le Chat)", "API", "Local Run"], "target_audience": "개발자, 가성비 좋게 최신 모델을 쓰고 싶은 일반인, 오픈소스 지지자"}'::jsonb,
    features = ARRAY['Le Chat', 'Mistral Large', 'Codestral', 'Open Weights', 'Canvas']
WHERE name = 'Mistral';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Mistral', '유럽의 자존심이자 오픈소스 AI의 최강자. 가벼우면서도 GPT-4급 성능을 내는 효율적인 모델과 챗봇 서비스 ''Le Chat''을 제공.', 'https://chat.mistral.ai/',
    'Freemium (웹 챗 무료 + API 종량제)', 'API 사용 시 종량제 / Le Chat 유료 플랜(예상).', 'Le Chat(르 챗) 서비스에서 Mistral Large 2, Codestral 등 최상위 모델을 무료로 사용 가능. (베타 기간 혜택).',
    '[{"plan": "Le Chat (Free)", "target": "일반인", "features": "Mistral Large, Codestral 무료, 웹 검색", "price": "무료"}, {"plan": "La Plateforme", "target": "개발자", "features": "API 호출, 파인튜닝, 모델 선택", "price": "종량제"}, {"plan": "Enterprise", "target": "기업", "features": "사내 구축(On-premise), 보안 강화", "price": "별도 문의"}]'::jsonb, ARRAY['Le Chat (무료): 경쟁사들이 월 $20 받는 수준의 고성능 모델(Mistral Large)을 웹사이트에서 공짜로 풀고 있습니다. (가성비 1위).', 'Codestral: 코딩에 특화된 모델 ''Codestral''을 선택하면, 코드 생성 및 디버깅 능력이 탁월합니다.', '효율성: 모델 사이즈 대비 성능이 압도적으로 좋아, 로컬(내 컴퓨터)에 설치해서 돌리기에 가장 적합한 모델들을 제공합니다.', '유럽 감성: 미국 기업(OpenAI, Google)과 달리 EU의 엄격한 개인정보 보호 기준을 준수하며, 다국어(유럽 언어) 처리에 강합니다.'], ARRAY['부가 기능: ChatGPT처럼 ''음성 대화'', ''이미지 편집'' 같은 화려한 멀티모달 기능은 상대적으로 적습니다. (텍스트/코드 집중).', '생태계: GPTs(스토어) 같은 플러그인 생태계는 아직 부족합니다.'], '[{"name": "Le Chat", "description": "무료 웹 챗봇 인터페이스 (검색 기능 포함)"}, {"name": "Mistral Large", "description": "추론 및 상식 능력이 뛰어난 플래그십 모델"}, {"name": "Codestral", "description": "80개 프로그래밍 언어를 학습한 코딩 특화 모델"}, {"name": "Open Weights", "description": "모델 가중치를 공개하여 누구나 다운로드 가능 (일부 모델)"}, {"name": "Canvas", "description": "(최신) 코드를 별도 창에서 편집하고 미리보는 기능"}]'::jsonb,
    '{"recommended": [{"target": "✅ 무료 유저", "reason": "돈 내기 싫은데 GPT-4급 성능을 웹에서 쓰고 싶은 분."}, {"target": "✅ 개발자", "reason": "내 노트북(Mac M1/M2 등)에 LLM을 설치해서 오프라인으로 돌려보고 싶은 분 (Ollama와 궁합 최고)."}, {"target": "✅ 보안 중시", "reason": "미국 기업에 데이터를 넘기기 껄끄러운 유럽 비즈니스 관계자."}], "not_recommended": [{"target": "❌ 이미지 생성", "reason": "그림 그려주는 기능이 필요하면 미드저니나 달리로 가세요."}, {"target": "❌ 음성 비서", "reason": "말로 대화하는 기능은 아직 약합니다."}]}'::jsonb, ARRAY['모델 선택: Le Chat 채팅창에서 모델을 ''Large''나 ''Codestral''로 바꿀 수 있습니다. 코딩 질문은 꼭 Codestral로 하세요.', '로컬 설치: Mistral 모델을 다운받아 쓰려면 ''Ollama''나 ''LM Studio'' 같은 툴을 먼저 설치해야 합니다.'], '{"description": "GDPR 준수: 프랑스 기업으로 유럽 데이터 보호법을 철저히 따르며, 기업용 플랜은 학습 데이터 사용을 금지합니다."}'::jsonb,
    '[{"name": "ChatGPT (OpenAI)", "description": "가장 무난하고 기능이 많은 대장주"}, {"name": "Claude (Anthropic)", "description": "문학적 글쓰기와 긴 문맥 처리에 강점"}]'::jsonb, '[{"title": "Mistral AI: The Open Weight Revolution", "url": "https://www.youtube.com/ (공식 채널/인터뷰 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Web (Le Chat)", "API", "Local Run"], "target_audience": "개발자, 가성비 좋게 최신 모델을 쓰고 싶은 일반인, 오픈소스 지지자"}'::jsonb,
    ARRAY['Le Chat', 'Mistral Large', 'Codestral', 'Open Weights', 'Canvas'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Mistral');

UPDATE ai_models SET
    description = '엑셀, PPT, 워드 등 MS 오피스 프로그램에 내장되어 문서 작업을 자동화하고, 윈도우 OS까지 제어하는 마이크로소프트의 AI 비서.',
    website_url = 'https://copilot.microsoft.com/',
    pricing_model = 'Freemium (웹 무료 + 오피스 연동 유료)',
    pricing_info = '월 $20 (Copilot Pro / 개인) / 월 $30 (Copilot for M365 / 기업).',
    free_tier_note = '웹(copilot.microsoft.com) 및 엣지 브라우저에서 GPT-4, DALL-E 3 무료 사용. (오피스 앱 연동 불가).',
    pricing_plans = '[{"plan": "Free", "target": "일반인", "features": "웹 검색, GPT-4 대화, 이미지 생성, 오피스 연동 X", "price": "무료"}, {"plan": "Pro", "target": "개인/프리랜서", "features": "Word/Excel/PPT 내장 AI 사용, 우선 접속", "price": "$20/월"}, {"plan": "M365 (Biz)", "target": "기업", "features": "Teams 회의 요약, 사내 데이터(Graph) 연동, 보안", "price": "$30/인/월"}]'::jsonb,
    pros = ARRAY['오피스 통합 (핵심): 워드 문서를 엑셀로 보내고, 엑셀 표를 PPT 슬라이드로 만드는 작업이 말 한마디로 됩니다. (Pro 이상).', '기업 보안: M365 비즈니스 플랜은 사내 데이터가 외부로 유출되거나 AI 학습에 쓰이지 않도록 철저히 차단합니다.', '접근성: 윈도우 11 사용자라면 단축키(`Win+C`) 하나로 언제든 불러낼 수 있습니다.', '무료 혜택: 유료를 안 써도 웹 버전에서 GPT-4와 달리3(그림 그리기)를 공짜로 무제한급으로 쓸 수 있습니다.'],
    cons = ARRAY['느린 속도: 엑셀이나 PPT 내에서 코파일럿을 돌리면 분석하고 생성하는 데 시간이 꽤 걸립니다. (답답함 유발).', '오피스 별도 구매: Copilot Pro($20)를 결제해도 MS Office 프로그램(Microsoft 365 Personal 등) 구독이 따로 없으면 앱 내 기능을 못 씁니다. (이중 지출).'],
    key_features = '[{"name": "Word", "description": "문서 초안 작성, 요약, 문체 변경"}, {"name": "Excel", "description": "데이터 분석, 차트 생성, 수식 추천 (Python 통합)"}, {"name": "PowerPoint", "description": "텍스트 문서 기반으로 슬라이드 자동 생성"}, {"name": "Teams", "description": "실시간 회의 요약 및 놓친 대화 브리핑"}, {"name": "Outlook", "description": "긴 이메일 스레드 요약 및 답장 초안 작성"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 직장인", "reason": "\"이 워드 파일 내용으로 PPT 초안 만들어줘\"가 절실한 분."}, {"target": "✅ 엑셀 초보", "reason": "복잡한 함수 몰라도 \"매출 제일 높은 순서로 정렬하고 그래프 그려줘\"라고 말로 하고 싶은 분."}, {"target": "✅ 팀즈 사용자", "reason": "회의 늦게 들어갔을 때 \"지금까지 무슨 얘기 했어?\"라고 물어봐야 하는 분."}], "not_recommended": [{"target": "❌ 구글 워크스페이스", "reason": "회사에서 구글 독스/시트를 쓴다면 Gemini for Workspace가 맞습니다."}, {"target": "❌ 맥 유저", "reason": "맥용 오피스에서도 되긴 하지만, 윈도우만큼 OS 레벨의 통합 경험은 덜합니다."}]}'::jsonb,
    usage_tips = ARRAY['라이선스 확인: "회사에서 코파일럿 사줬다는데 왜 안 돼요?" -> IT 팀에서 내 계정에 라이선스를 할당했는지, 그리고 오피스 앱을 ''업데이트'' 했는지 확인하세요.', '새 파일: PPT 생성 기능은 기존 파일의 디자인을 유지하면서 내용을 추가하는 것보다, 새 파일을 만들 때 훨씬 잘 작동합니다.'],
    privacy_info = '{"description": "Commercial Data Protection: 기업용 플랜은 입력한 데이터가 저장되지 않고 AI 학습에도 쓰이지 않습니다. (무료 버전은 학습 가능성 있음)."}'::jsonb,
    alternatives = '[{"name": "Google Gemini", "description": "구글 문서/스프레드시트 사용자라면"}, {"name": "Gamma", "description": "PPT 디자인 퀄리티만 놓고 보면 코파일럿보다 예쁨"}]'::jsonb,
    media_info = '[{"title": "Microsoft Copilot: Your everyday AI companion", "url": "https://www.youtube.com/watch?v=S7xTBa93TX8 (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "Web", "iOS", "Android", "MS 365 Apps"], "target_audience": "엑셀, PPT로 밥 벌어먹고 사는 모든 직장인, 대학생"}'::jsonb,
    features = ARRAY['Word', 'Excel', 'PowerPoint', 'Teams', 'Outlook']
WHERE name = 'Microsoft Copilot';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Microsoft Copilot', '엑셀, PPT, 워드 등 MS 오피스 프로그램에 내장되어 문서 작업을 자동화하고, 윈도우 OS까지 제어하는 마이크로소프트의 AI 비서.', 'https://copilot.microsoft.com/',
    'Freemium (웹 무료 + 오피스 연동 유료)', '월 $20 (Copilot Pro / 개인) / 월 $30 (Copilot for M365 / 기업).', '웹(copilot.microsoft.com) 및 엣지 브라우저에서 GPT-4, DALL-E 3 무료 사용. (오피스 앱 연동 불가).',
    '[{"plan": "Free", "target": "일반인", "features": "웹 검색, GPT-4 대화, 이미지 생성, 오피스 연동 X", "price": "무료"}, {"plan": "Pro", "target": "개인/프리랜서", "features": "Word/Excel/PPT 내장 AI 사용, 우선 접속", "price": "$20/월"}, {"plan": "M365 (Biz)", "target": "기업", "features": "Teams 회의 요약, 사내 데이터(Graph) 연동, 보안", "price": "$30/인/월"}]'::jsonb, ARRAY['오피스 통합 (핵심): 워드 문서를 엑셀로 보내고, 엑셀 표를 PPT 슬라이드로 만드는 작업이 말 한마디로 됩니다. (Pro 이상).', '기업 보안: M365 비즈니스 플랜은 사내 데이터가 외부로 유출되거나 AI 학습에 쓰이지 않도록 철저히 차단합니다.', '접근성: 윈도우 11 사용자라면 단축키(`Win+C`) 하나로 언제든 불러낼 수 있습니다.', '무료 혜택: 유료를 안 써도 웹 버전에서 GPT-4와 달리3(그림 그리기)를 공짜로 무제한급으로 쓸 수 있습니다.'], ARRAY['느린 속도: 엑셀이나 PPT 내에서 코파일럿을 돌리면 분석하고 생성하는 데 시간이 꽤 걸립니다. (답답함 유발).', '오피스 별도 구매: Copilot Pro($20)를 결제해도 MS Office 프로그램(Microsoft 365 Personal 등) 구독이 따로 없으면 앱 내 기능을 못 씁니다. (이중 지출).'], '[{"name": "Word", "description": "문서 초안 작성, 요약, 문체 변경"}, {"name": "Excel", "description": "데이터 분석, 차트 생성, 수식 추천 (Python 통합)"}, {"name": "PowerPoint", "description": "텍스트 문서 기반으로 슬라이드 자동 생성"}, {"name": "Teams", "description": "실시간 회의 요약 및 놓친 대화 브리핑"}, {"name": "Outlook", "description": "긴 이메일 스레드 요약 및 답장 초안 작성"}]'::jsonb,
    '{"recommended": [{"target": "✅ 직장인", "reason": "\"이 워드 파일 내용으로 PPT 초안 만들어줘\"가 절실한 분."}, {"target": "✅ 엑셀 초보", "reason": "복잡한 함수 몰라도 \"매출 제일 높은 순서로 정렬하고 그래프 그려줘\"라고 말로 하고 싶은 분."}, {"target": "✅ 팀즈 사용자", "reason": "회의 늦게 들어갔을 때 \"지금까지 무슨 얘기 했어?\"라고 물어봐야 하는 분."}], "not_recommended": [{"target": "❌ 구글 워크스페이스", "reason": "회사에서 구글 독스/시트를 쓴다면 Gemini for Workspace가 맞습니다."}, {"target": "❌ 맥 유저", "reason": "맥용 오피스에서도 되긴 하지만, 윈도우만큼 OS 레벨의 통합 경험은 덜합니다."}]}'::jsonb, ARRAY['라이선스 확인: "회사에서 코파일럿 사줬다는데 왜 안 돼요?" -> IT 팀에서 내 계정에 라이선스를 할당했는지, 그리고 오피스 앱을 ''업데이트'' 했는지 확인하세요.', '새 파일: PPT 생성 기능은 기존 파일의 디자인을 유지하면서 내용을 추가하는 것보다, 새 파일을 만들 때 훨씬 잘 작동합니다.'], '{"description": "Commercial Data Protection: 기업용 플랜은 입력한 데이터가 저장되지 않고 AI 학습에도 쓰이지 않습니다. (무료 버전은 학습 가능성 있음)."}'::jsonb,
    '[{"name": "Google Gemini", "description": "구글 문서/스프레드시트 사용자라면"}, {"name": "Gamma", "description": "PPT 디자인 퀄리티만 놓고 보면 코파일럿보다 예쁨"}]'::jsonb, '[{"title": "Microsoft Copilot: Your everyday AI companion", "url": "https://www.youtube.com/watch?v=S7xTBa93TX8 (공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": true, "login_required": "Required", "platforms": ["Windows", "Web", "iOS", "Android", "MS 365 Apps"], "target_audience": "엑셀, PPT로 밥 벌어먹고 사는 모든 직장인, 대학생"}'::jsonb,
    ARRAY['Word', 'Excel', 'PowerPoint', 'Teams', 'Outlook'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Microsoft Copilot');

UPDATE ai_models SET
    description = '단순한 언어 이해(IQ)를 넘어, 목소리의 톤, 숨소리, 억양에서 감정(EQ)을 읽어내고 공감하며 대화하는 세계 최초의 ''공감형 음성 AI''.',
    website_url = 'https://www.hume.ai/',
    pricing_model = 'Usage-based (API 종량제) / Free Demo',
    pricing_info = 'API 호출 분당 과금 (가격 변동 가능, 통상 텍스트 모델보다 비쌈).',
    free_tier_note = '공식 웹사이트의 EVI (Empathic Voice Interface) 데모는 누구나 무료로 대화 가능. 개발자용 API는 가입 시 일정량의 무료 크레딧 제공.',
    pricing_plans = '[{"plan": "Demo (Web)", "target": "일반인", "features": "EVI 모델과 실시간 음성 대화 체험", "price": "무료"}, {"plan": "Developer", "target": "개발자", "features": "API 접근, 커스텀 보이스, 감정 데이터(JSON) 출력", "price": "종량제"}, {"plan": "Enterprise", "target": "기업", "features": "전용 인프라, SLA, 맞춤형 모델 튜닝", "price": "별도 문의"}]'::jsonb,
    pros = ARRAY['감정 인식(EQ): "나 괜찮아"라고 말해도 목소리가 떨리면, "목소리에 슬픔이 묻어나는데 정말 괜찮으신가요?"라고 되묻습니다. (소름 돋는 공감 능력).', 'EVI (Empathic Voice Interface): 텍스트를 거치지 않고 음성-to-음성으로 처리하는 엔드투엔드 모델이라 반응 속도가 빠르고, 말 끊기(Interruption)도 자연스럽습니다.', 'Prosody Analysis: 말의 리듬, 억양, 크기를 분석해 50가지 이상의 감정(기쁨, 불안, 지루함 등)을 수치로 보여줍니다.', '몰입감: 기계적인 TTS(음성 합성)가 아니라, 웃으면서 말하거나 한숨 쉬며 말하는 등 사람 같은 연기가 가능합니다.'],
    cons = ARRAY['비용: 일반 텍스트 LLM보다 연산 비용이 비싸서, 서비스에 도입하려면 예산 고려가 필요합니다.', '한국어: 한국어 대화도 가능하지만, 영어만큼 미묘한 감정선까지 완벽하게 캐치하는지는 테스트가 필요합니다.'],
    key_features = '[{"name": "EVI (Empathic Voice Interface)", "description": "실시간 감정 반응형 음성 대화"}, {"name": "Expression Measurement", "description": "목소리에서 53가지 감정 뉘앙스(기쁨, 당황, 차분함 등) 측정"}, {"name": "Voice-to-Voice", "description": "텍스트 변환 지연 없는 초저지연 대화"}, {"name": "Interruption Handling", "description": "사용자가 말을 끊으면 자연스럽게 멈추고 듣기"}, {"name": "Custom Voice", "description": "브랜드에 맞는 페르소나 및 목소리 설정"}]'::jsonb,
    recommendations = '{"recommended": [{"target": "✅ 멘탈 헬스케어", "reason": "심리 상담, 우울증 케어, 노인 말동무 AI 앱을 만드는 팀."}, {"target": "✅ 고객 센터", "reason": "화난 고객의 목소리를 감지해서 먼저 사과하거나 상담원에게 경고를 주는 시스템."}, {"target": "✅ 게임/메타버스", "reason": "NPC가 플레이어의 목소리 톤에 따라 기분 나빠하거나 좋아하는 반응을 보여야 할 때."}], "not_recommended": [{"target": "❌ 단순 정보 전달", "reason": "날씨나 뉴스만 딱딱하게 알려주는 비서가 필요하다면 시리나 구글 어시스턴트가 낫습니다."}, {"target": "❌ 텍스트 중심", "reason": "채팅만 할 거라면 Hume의 장점(음성 감정 분석)을 활용할 수 없습니다."}]}'::jsonb,
    usage_tips = ARRAY['마이크 환경: 주변이 시끄러우면 감정 분석 정확도가 떨어질 수 있습니다. 조용한 곳에서 테스트하세요.', '과몰입 주의: AI가 너무 공감을 잘해줘서 실제 사람처럼 느껴질 수 있습니다. (영화 ''HER'' 현실판).'],
    privacy_info = '{"description": "감정 데이터: 사용자의 목소리에서 추출한 감정 데이터는 서비스 개선에 활용될 수 있으나, 민감한 정보 보호를 위한 엔터프라이즈 옵션이 있습니다."}'::jsonb,
    alternatives = '[{"name": "OpenAI Realtime API (GPT-4o)", "description": "감정 표현이 가능하지만 Hume만큼 감정 ''분석''에 특화되진 않음"}, {"name": "Hume (Legacy Models)", "description": "얼굴 표정 분석 등 비전 모델도 보유하고 있음"}]'::jsonb,
    media_info = '[{"title": "Introducing EVI: The First Empathic Voice Interface", "url": "https://www.youtube.com/watch?v= (Hume AI 공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb,
    meta_info = '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web (Demo)", "iOS App", "API"], "target_audience": "헬스케어(심리상담) 앱 개발자, 고객 서비스(CS) 혁신 팀, AI와 깊은 대화를 원하는 얼리어답터"}'::jsonb,
    features = ARRAY['EVI (Empathic Voice Interface)', 'Expression Measurement', 'Voice-to-Voice', 'Interruption Handling', 'Custom Voice']
WHERE name = 'Hume AI';

INSERT INTO ai_models (
    name, description, website_url, 
    pricing_model, pricing_info, free_tier_note,
    pricing_plans, pros, cons, key_features,
    recommendations, usage_tips, privacy_info,
    alternatives, media_info, meta_info,
    features, search_tags, average_rating, rating_count, version
)
SELECT
    'Hume AI', '단순한 언어 이해(IQ)를 넘어, 목소리의 톤, 숨소리, 억양에서 감정(EQ)을 읽어내고 공감하며 대화하는 세계 최초의 ''공감형 음성 AI''.', 'https://www.hume.ai/',
    'Usage-based (API 종량제) / Free Demo', 'API 호출 분당 과금 (가격 변동 가능, 통상 텍스트 모델보다 비쌈).', '공식 웹사이트의 EVI (Empathic Voice Interface) 데모는 누구나 무료로 대화 가능. 개발자용 API는 가입 시 일정량의 무료 크레딧 제공.',
    '[{"plan": "Demo (Web)", "target": "일반인", "features": "EVI 모델과 실시간 음성 대화 체험", "price": "무료"}, {"plan": "Developer", "target": "개발자", "features": "API 접근, 커스텀 보이스, 감정 데이터(JSON) 출력", "price": "종량제"}, {"plan": "Enterprise", "target": "기업", "features": "전용 인프라, SLA, 맞춤형 모델 튜닝", "price": "별도 문의"}]'::jsonb, ARRAY['감정 인식(EQ): "나 괜찮아"라고 말해도 목소리가 떨리면, "목소리에 슬픔이 묻어나는데 정말 괜찮으신가요?"라고 되묻습니다. (소름 돋는 공감 능력).', 'EVI (Empathic Voice Interface): 텍스트를 거치지 않고 음성-to-음성으로 처리하는 엔드투엔드 모델이라 반응 속도가 빠르고, 말 끊기(Interruption)도 자연스럽습니다.', 'Prosody Analysis: 말의 리듬, 억양, 크기를 분석해 50가지 이상의 감정(기쁨, 불안, 지루함 등)을 수치로 보여줍니다.', '몰입감: 기계적인 TTS(음성 합성)가 아니라, 웃으면서 말하거나 한숨 쉬며 말하는 등 사람 같은 연기가 가능합니다.'], ARRAY['비용: 일반 텍스트 LLM보다 연산 비용이 비싸서, 서비스에 도입하려면 예산 고려가 필요합니다.', '한국어: 한국어 대화도 가능하지만, 영어만큼 미묘한 감정선까지 완벽하게 캐치하는지는 테스트가 필요합니다.'], '[{"name": "EVI (Empathic Voice Interface)", "description": "실시간 감정 반응형 음성 대화"}, {"name": "Expression Measurement", "description": "목소리에서 53가지 감정 뉘앙스(기쁨, 당황, 차분함 등) 측정"}, {"name": "Voice-to-Voice", "description": "텍스트 변환 지연 없는 초저지연 대화"}, {"name": "Interruption Handling", "description": "사용자가 말을 끊으면 자연스럽게 멈추고 듣기"}, {"name": "Custom Voice", "description": "브랜드에 맞는 페르소나 및 목소리 설정"}]'::jsonb,
    '{"recommended": [{"target": "✅ 멘탈 헬스케어", "reason": "심리 상담, 우울증 케어, 노인 말동무 AI 앱을 만드는 팀."}, {"target": "✅ 고객 센터", "reason": "화난 고객의 목소리를 감지해서 먼저 사과하거나 상담원에게 경고를 주는 시스템."}, {"target": "✅ 게임/메타버스", "reason": "NPC가 플레이어의 목소리 톤에 따라 기분 나빠하거나 좋아하는 반응을 보여야 할 때."}], "not_recommended": [{"target": "❌ 단순 정보 전달", "reason": "날씨나 뉴스만 딱딱하게 알려주는 비서가 필요하다면 시리나 구글 어시스턴트가 낫습니다."}, {"target": "❌ 텍스트 중심", "reason": "채팅만 할 거라면 Hume의 장점(음성 감정 분석)을 활용할 수 없습니다."}]}'::jsonb, ARRAY['마이크 환경: 주변이 시끄러우면 감정 분석 정확도가 떨어질 수 있습니다. 조용한 곳에서 테스트하세요.', '과몰입 주의: AI가 너무 공감을 잘해줘서 실제 사람처럼 느껴질 수 있습니다. (영화 ''HER'' 현실판).'], '{"description": "감정 데이터: 사용자의 목소리에서 추출한 감정 데이터는 서비스 개선에 활용될 수 있으나, 민감한 정보 보호를 위한 엔터프라이즈 옵션이 있습니다."}'::jsonb,
    '[{"name": "OpenAI Realtime API (GPT-4o)", "description": "감정 표현이 가능하지만 Hume만큼 감정 ''분석''에 특화되진 않음"}, {"name": "Hume (Legacy Models)", "description": "얼굴 표정 분석 등 비전 모델도 보유하고 있음"}]'::jsonb, '[{"title": "Introducing EVI: The First Empathic Voice Interface", "url": "https://www.youtube.com/watch?v= (Hume AI 공식 채널 확인 권장)", "platform": "YouTube"}]'::jsonb, '{"korean_support": "Partial", "login_required": "Required", "platforms": ["Web (Demo)", "iOS App", "API"], "target_audience": "헬스케어(심리상담) 앱 개발자, 고객 서비스(CS) 혁신 팀, AI와 깊은 대화를 원하는 얼리어답터"}'::jsonb,
    ARRAY['EVI (Empathic Voice Interface)', 'Expression Measurement', 'Voice-to-Voice', 'Interruption Handling', 'Custom Voice'], ARRAY[]::text[], 0.0, 0, '1.0'
WHERE NOT EXISTS (SELECT 1 FROM ai_models WHERE name = 'Hume AI');