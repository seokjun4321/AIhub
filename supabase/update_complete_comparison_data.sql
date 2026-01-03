-- 모든 AI 도구 Comparison Data 일괄 업데이트 (ID 83 ~ 121)

-- 83. Claude (Anthropic)
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.8, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.7,
  "radar_chart": { "performance": 4.8, "community": 4.0, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 4.7, "automation": 4.0 },
  "pros": ["매우 긴 컨텍스트 윈도우(긴 글 처리에 유리)", "자연스럽고 문학적인 문장 생성", "안전하고 윤리적인 답변"],
  "cons": ["이미지 생성 기능 부재", "GPT 대비 부가 기능(플러그인 등) 적음"],
  "target_users": ["작가", "연구원", "긴 문서를 다루는 직장인"],
  "integrations": ["API", "Slack", "Notion"],
  "summary_text": "긴 논문이나 소설을 분석하고 요약하는 데 있어서는 타의 추종을 불허하는 성능을 보여줍니다."
}'::jsonb WHERE id = 83;

-- 84. Perplexity
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.7, "cost_efficiency_score": 4.5, "korean_support_score": 4.8, "learning_curve_score": 4.9,
  "radar_chart": { "performance": 4.7, "community": 3.5, "value_for_money": 4.5, "korean_quality": 4.8, "ease_of_use": 4.9, "automation": 3.5 },
  "pros": ["실시간 웹 검색 기반의 정확한 답변", "출처 표기로 신뢰성 높음", "빠른 검색 속도"],
  "cons": ["창의적인 글쓰기 능력은 다소 부족", "복잡한 코딩 문제 해결력은 GPT-4 대비 낮음"],
  "target_users": ["대학생(리포트 자료 조사)", "기자", "시장 조사관"],
  "integrations": ["Chrome Extension", "Mobile App"],
  "summary_text": "구글링의 시간을 혁신적으로 단축시켜주는, 출처를 알려주는 똑똑한 검색 비서입니다."
}'::jsonb WHERE id = 84;

-- 85. Midjourney
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.9, "cost_efficiency_score": 3.0, "korean_support_score": 2.0, "learning_curve_score": 2.5,
  "radar_chart": { "performance": 4.9, "community": 5.0, "value_for_money": 3.0, "korean_quality": 2.0, "ease_of_use": 2.5, "automation": 2.0 },
  "pros": ["압도적인 예술적 이미지 퀄리티", "다양한 화풍 완벽 소화", "활발한 커뮤니티"],
  "cons": ["디스코드 기반이라 사용 편의성 낮음", "월 구독 필수", "정밀한 수정(Inpainting) 까다로움"],
  "target_users": ["디자이너", "일러스트레이터", "콘텐츠 기획자"],
  "integrations": ["Discord"],
  "summary_text": "사용법은 조금 어렵지만, 결과물의 퀄리티 하나만으로 모든 단점을 상쇄하는 최고의 이미지 생성 AI입니다."
}'::jsonb WHERE id = 85;

-- 86. DALL-E 3
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 4.0, "korean_support_score": 4.8, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.5, "community": 4.0, "value_for_money": 4.0, "korean_quality": 4.8, "ease_of_use": 5.0, "automation": 4.0 },
  "pros": ["ChatGPT와 대화하듯 쉽게 이미지 생성", "복잡한 지시사항도 잘 이해함", "한글 프롬프트 인식 우수"],
  "cons": ["미드저니 대비 사실적인 묘사력 부족", "생성된 이미지 퀄리티 편차 존재"],
  "target_users": ["블로거", "마케터", "초보 사용자"],
  "integrations": ["ChatGPT", "Microsoft Bing"],
  "summary_text": "가장 쉽고 편하게 이미지를 만들고 싶다면 최고의 선택입니다. 챗봇에게 말하듯 그리면 됩니다."
}'::jsonb WHERE id = 86;

-- 87. Adobe Firefly
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.4, "cost_efficiency_score": 4.0, "korean_support_score": 4.5, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.4, "community": 3.5, "value_for_money": 4.0, "korean_quality": 4.5, "ease_of_use": 4.5, "automation": 4.5 },
  "pros": ["저작권 문제없는 안전한 이미지 생성", "포토샵/일러스트레이터와 강력한 연동", "텍스트 효과 생성 탁월"],
  "cons": ["예술적 창의성은 미드저니보다 낮음", "Adobe 구독 필요"],
  "target_users": ["현업 디자이너", "상업용 이미지 제작자"],
  "integrations": ["Photoshop", "Illustrator", "Express"],
  "summary_text": "저작권 걱정 없이 상업적으로 이용 가능한 이미지를 포토샵 안에서 바로 생성하세요."
}'::jsonb WHERE id = 87;

-- 88. Stable Diffusion
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.6, "cost_efficiency_score": 5.0, "korean_support_score": 3.0, "learning_curve_score": 1.5,
  "radar_chart": { "performance": 4.6, "community": 5.0, "value_for_money": 5.0, "korean_quality": 3.0, "ease_of_use": 1.5, "automation": 4.0 },
  "pros": ["완전 무료(오픈소스)", "설치형으로 무제한 생성 가능", "가장 세밀한 제어 가능(ControlNet 등)"],
  "cons": ["고사양 PC 필요", "설치 및 설정 매우 어려움", "학습 곡선 가파름"],
  "target_users": ["AI 연구자", "고급 사용자", "게임 개발자"],
  "integrations": ["Automatic1111", "ComfyUI"],
  "summary_text": "배우기는 어렵지만, 익숙해지면 비용 없이 가장 자유롭게 이미지를 생성할 수 있습니다."
}'::jsonb WHERE id = 88;

-- 89. Notion AI
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.3, "cost_efficiency_score": 4.0, "korean_support_score": 4.7, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.3, "community": 4.5, "value_for_money": 4.0, "korean_quality": 4.7, "ease_of_use": 4.8, "automation": 3.5 },
  "pros": ["노션 워크스페이스 내장", "회의록 정리 및 번역에 탁월", "문서 톤 앤 매너 변경 용이"],
  "cons": ["별도 요금제", "복잡한 추론 능력은 부족"],
  "target_users": ["노션 사용자", "PM", "대학생"],
  "integrations": ["Notion"],
  "summary_text": "노션에 작성된 글을 다듬고 요약하는 데 최적화된 업무 보조 비서입니다."
}'::jsonb WHERE id = 89;

-- 90. Grammarly
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.7, "cost_efficiency_score": 3.5, "korean_support_score": 0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.7, "community": 4.0, "value_for_money": 3.5, "korean_quality": 0, "ease_of_use": 5.0, "automation": 4.5 },
  "pros": ["세계 최고의 영문법 교정", "다양한 플랫폼 지원", "문체/톤 교정"],
  "cons": ["한국어 미지원", "프리미엄 가격 부담"],
  "target_users": ["영어 논문 작성자", "유학생", "비즈니스맨"],
  "integrations": ["MS Word", "Google Docs", "Browser"],
  "summary_text": "영어 이메일이나 논문을 쓸 때, 원어민처럼 매끄러운 문장을 만들어 드립니다."
}'::jsonb WHERE id = 90;

-- 91. Jasper
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 3.0, "korean_support_score": 4.0, "learning_curve_score": 4.0,
  "radar_chart": { "performance": 4.5, "community": 3.5, "value_for_money": 3.0, "korean_quality": 4.0, "ease_of_use": 4.0, "automation": 4.5 },
  "pros": ["마케팅 카피라이팅 특화", "브랜드 보이스 설정 가능", "다양한 템플릿 제공"],
  "cons": ["비싼 가격 정책", "일반 사용자에게는 과분한 기능"],
  "target_users": ["마케터", "광고 기획자", "콘텐츠 에디터"],
  "integrations": ["Surfer SEO", "Chrome Extension"],
  "summary_text": "팔리는 글쓰기가 필요하다면, 마케터를 위해 훈련된 Jasper가 정답입니다."
}'::jsonb WHERE id = 91;

-- 92. Copy.ai
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 4.5, "korean_support_score": 4.0, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.2, "community": 3.0, "value_for_money": 4.5, "korean_quality": 4.0, "ease_of_use": 4.8, "automation": 4.0 },
  "pros": ["마케팅 문구 무료 생성(제한적)", "직관적인 인터페이스", "빠른 블로그 포스트 작성"],
  "cons": ["깊이 있는 글쓰기는 부족", "한국어 뉘앙스 가끔 어색"],
  "target_users": ["소상공인", "SNS 마케터", "초보 블로거"],
  "integrations": ["Zapier"],
  "summary_text": "인스타그램 캡션이나 블로그 주제가 떠오르지 않을 때 아이러니를 해소해줍니다."
}'::jsonb WHERE id = 92;

-- 93. GitHub Copilot
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.8, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.8, "community": 5.0, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 4.5, "automation": 5.0 },
  "pros": ["VS Code 완벽 통합", "놀라운 코드 자동 완성 정확도", "학생 무료"],
  "cons": ["전체 프로젝트 맥락 이해는 아직 발전 중", "기업용 유료"],
  "target_users": ["개발자", "컴공과 학생"],
  "integrations": ["VS Code", "JetBrains", "Visual Studio"],
  "summary_text": "타자를 칠 필요를 없게 만드는, 개발자의 생산성을 2배로 늘려주는 코딩 파트너입니다."
}'::jsonb WHERE id = 93;

-- 94. Replit
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.3, "cost_efficiency_score": 4.8, "korean_support_score": 4.0, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.3, "community": 4.5, "value_for_money": 4.8, "korean_quality": 4.0, "ease_of_use": 4.8, "automation": 4.2 },
  "pros": ["설치 없는 온라인 코딩 환경", "AI가 코드 설명/수정/생성", "실시간 협업 가능"],
  "cons": ["대규모 프로젝트에는 부적합", "브라우저 의존성"],
  "target_users": ["코딩 입문자", "학생", "프로토타이핑"],
  "integrations": ["Github Import"],
  "summary_text": "개발 환경 설정 없이 바로 코딩하고 AI의 도움을 받아 배포까지 한 번에 가능합니다."
}'::jsonb WHERE id = 94;

-- 95. Tabnine
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 4.0, "korean_support_score": 3.5, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.2, "community": 3.5, "value_for_money": 4.0, "korean_quality": 3.5, "ease_of_use": 4.5, "automation": 4.5 },
  "pros": ["높은 프라이버시(로컬 모델 지원)", "기업 보안에 강함", "다양한 IDE 지원"],
  "cons": ["Copilot 대비 추론 능력 다소 낮음", "무료 버전 기능 제한"],
  "target_users": ["보안이 중요한 기업 개발자", "오프라인 코딩"],
  "integrations": ["VS Code", "IntelliJ", "Eclipse"],
  "summary_text": "내 코드가 외부로 유출될 걱정 없이 안전하게 AI 코딩 자동완성을 사용하세요."
}'::jsonb WHERE id = 95;

-- 96. Synthesia
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.6, "cost_efficiency_score": 4.0, "korean_support_score": 4.5, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.6, "community": 3.0, "value_for_money": 4.0, "korean_quality": 4.5, "ease_of_use": 4.5, "automation": 4.5 },
  "pros": ["실사 같은 AI 아바타 생성", "다국어 립싱크 자연스러움", "PPT로 영상 만들기 가능"],
  "cons": ["가격이 비쌈", "아직은 미세한 표정의 어색함 존재"],
  "target_users": ["기업 교육 담당자", "마케터", "유튜버"],
  "integrations": ["PowerPoint"],
  "summary_text": "카메라와 마이크 없이 텍스트만 입력하면 전문적인 발표 영상을 만들어줍니다."
}'::jsonb WHERE id = 96;

-- 97. ElevenLabs
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.9, "cost_efficiency_score": 4.0, "korean_support_score": 4.8, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.9, "community": 4.0, "value_for_money": 4.0, "korean_quality": 4.8, "ease_of_use": 4.8, "automation": 4.5 },
  "pros": ["가장 자연스러운 AI 목소리 생성", "감정 표현/숨소리까지 구현", "적은 샘플로 목소리 복제"],
  "cons": ["무료 제공량 적음", "생성 속도에 따른 비용 발생"],
  "target_users": ["오디오북 제작자", "유튜버", "게임 개발자"],
  "integrations": ["API"],
  "summary_text": "사람인지 AI인지 구분이 불가능할 정도의 감정이 담긴 목소리를 생성합니다."
}'::jsonb WHERE id = 97;

-- 98. Suno
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.8, "cost_efficiency_score": 5.0, "korean_support_score": 4.5, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.8, "community": 4.5, "value_for_money": 5.0, "korean_quality": 4.5, "ease_of_use": 5.0, "automation": 4.8 },
  "pros": ["텍스트로 작사/작곡/보컬까지 한번에", "높은 음악적 퀄리티", "한글 가사 지원 우수"],
  "cons": ["세밀한 편집 불가", "상업적 이용 시 유료 구독 필요"],
  "target_users": ["콘텐츠 크리에이터", "작곡 취미생", "기념일 선물"],
  "integrations": ["Discord", "Web"],
  "summary_text": "음악을 전혀 몰라도 나만의 노래를 1분 만에 뚝딱 만들어내는 마법 같은 도구입니다."
}'::jsonb WHERE id = 98;

-- 99. Zapier
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 4.0, "korean_support_score": 3.5, "learning_curve_score": 3.5,
  "radar_chart": { "performance": 4.5, "community": 5.0, "value_for_money": 4.0, "korean_quality": 3.5, "ease_of_use": 3.5, "automation": 5.0 },
  "pros": ["6000개 이상의 앱 연동", "노코드 자동화의 최강자", "AI 기능 추가로 작성 자동화"],
  "cons": ["복잡한 워크플로우 구성 시 어려움", "사용량 많으면 비쌈"],
  "target_users": ["업무 자동화 담당자", "마케터", "스타트업"],
  "integrations": ["Gmail", "Slack", "Notion", "Sheets"],
  "summary_text": "반복되는 귀찮은 업무들을 서로 연결해서 자동으로 처리해주는 업무 자동화의 허브입니다."
}'::jsonb WHERE id = 99;

-- 100. Canva
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.7, "cost_efficiency_score": 4.8, "korean_support_score": 5.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.7, "community": 5.0, "value_for_money": 4.8, "korean_quality": 5.0, "ease_of_use": 5.0, "automation": 4.0 },
  "pros": ["디자인 템플릿 최다 보유", "Magic Studio 등 AI 기능 대거 탑재", "팀 협업 용이"],
  "cons": ["전문적인 디자인 툴보다는 기능 제한", "일부 고급 소재 유료"],
  "target_users": ["마케터", "소상공인", "학생", "프리랜서"],
  "integrations": ["SNS", "Google Drive"],
  "summary_text": "디자이너가 없어도 전문가 수준의 카드뉴스, PPT, 포스터를 가장 쉽게 만들 수 있습니다."
}'::jsonb WHERE id = 100;

-- 101. Wrtn
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.6, "cost_efficiency_score": 5.0, "korean_support_score": 5.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.6, "community": 4.0, "value_for_money": 5.0, "korean_quality": 5.0, "ease_of_use": 5.0, "automation": 3.0 },
  "pros": ["GPT-4 등 최신 모델 무료 사용", "완벽한 한국어 지원 및 현지화", "메신저처럼 쉬운 접근성"],
  "cons": ["복잡한 코딩/추론은 GPT 원본보다 약함", "생성 속도가 때때로 느림"],
  "target_users": ["대학생", "직장인", "일반 사용자"],
  "integrations": ["Web", "App", "KakaoTalk"],
  "summary_text": "비싼 구독료 없이 최신 AI 모델을 한국 환경에 맞게 무료로 쓸 수 있는 국민 AI 서비스입니다."
}'::jsonb WHERE id = 101;

-- 102. QuillBot
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.4, "cost_efficiency_score": 4.5, "korean_support_score": 0, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.4, "community": 4.0, "value_for_money": 4.5, "korean_quality": 0, "ease_of_use": 4.8, "automation": 4.0 },
  "pros": ["문장 재구성(Paraphrasing) 최고 성능", "표절 회피에 유용", "다양한 문체 선택 가능"],
  "cons": ["한국어 미지원", "단순 요약 외 기능 부족"],
  "target_users": ["영어 논문 작성자", "유학생", "글로벌 마케터"],
  "integrations": ["Chrome", "Word"],
  "summary_text": "영어 문장이 딱딱하거나 반복될 때, 같은 뜻의 다른 문장으로 매끄럽게 바꿔줍니다."
}'::jsonb WHERE id = 102;

-- 103. CopyKiller
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 3.5, "korean_support_score": 5.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.2, "community": 3.0, "value_for_money": 3.5, "korean_quality": 5.0, "ease_of_use": 5.0, "automation": 3.0 },
  "pros": ["국내 DB 최다 보유로 정확한 표절 검사", "AI 작성 글 탐지 기능", "참고문헌 올바른 표기법 제공"],
  "cons": ["유료(건당 결제)", "표절 검사 외 기능 없음"],
  "target_users": ["대학생(과제)", "논문 투고자"],
  "integrations": ["Web"],
  "summary_text": "과제 제출 전 필수 코스. 표절률을 확인하고 안전하게 리포트를 제출하세요."
}'::jsonb WHERE id = 103;

-- 104. Gamma
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.3, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.3, "community": 3.5, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 4.8, "automation": 4.8 },
  "pros": ["주제만 입력하면 PPT 디자인까지 자동 완성", "세련된 레이아웃 제공", "웹 공유 용이"],
  "cons": ["레이아웃 세부 수정이 제한적", "한글 폰트 다양성 부족"],
  "target_users": ["발표가 잦은 직장인", "대학생", "강사"],
  "integrations": ["PPT Export", "PDF"],
  "summary_text": "PPT 빈 화면 공포증 해결사. 내용만 적으면 디자인은 알아서 완성됩니다."
}'::jsonb WHERE id = 104;

-- 105. Tome
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 4.0, "korean_support_score": 4.0, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.2, "community": 3.0, "value_for_money": 4.0, "korean_quality": 4.0, "ease_of_use": 4.5, "automation": 4.5 },
  "pros": ["스토리텔링 중심의 슬라이드 생성", "DALL-E 연동 이미지 자동 삽입", "모바일에 최적화된 뷰"],
  "cons": ["전통적인 PPT 형식과는 다소 차이", "유료화 정책 강화"],
  "target_users": ["스타트업 피칭", "포트폴리오 제작자"],
  "integrations": ["Web Share"],
  "summary_text": "단순한 발표 자료를 넘어 하나의 이야기를 담은 웹북 형태의 프레젠테이션을 만듭니다."
}'::jsonb WHERE id = 105;

-- 106. Vrew
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 5.0, "korean_support_score": 5.0, "learning_curve_score": 4.9,
  "radar_chart": { "performance": 4.5, "community": 4.0, "value_for_money": 5.0, "korean_quality": 5.0, "ease_of_use": 4.9, "automation": 4.8 },
  "pros": ["음성 인식으로 자동 자막 생성 최고봉", "워드처럼 쉬운 영상 컷 편집", "무료 기능 강력함"],
  "cons": ["전문 편집 툴(프리미어) 대비 효과 부족", "무거운 파일 작업 시 버벅임"],
  "target_users": ["유튜버", "숏폼 크리에이터", "영상 편집 초보"],
  "integrations": ["YouTube", "Premiere XML"],
  "summary_text": "자막 작업 시간을 1/10로 줄여줍니다. 말하는 영상 편집에는 대체 불가능한 도구입니다."
}'::jsonb WHERE id = 106;

-- 107. Runway
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.4, "cost_efficiency_score": 3.5, "korean_support_score": 3.0, "learning_curve_score": 3.5,
  "radar_chart": { "performance": 4.4, "community": 3.5, "value_for_money": 3.5, "korean_quality": 3.0, "ease_of_use": 3.5, "automation": 4.5 },
  "pros": ["영상 배경 지우기/교체 등 AI 매직 툴", "텍스트로 동영상 생성(Gen-2)", "웹 기반 전문 편집"],
  "cons": ["고급 기능은 비싼 유료 플랜", "높은 사양 요구", "사용법 익히기 필요"],
  "target_users": ["영상 디자이너", "영화 제작자", "아티스트"],
  "integrations": ["Web"],
  "summary_text": "영화 CG급의 효과를 AI로 손쉽게 구현할 수 있는 차세대 영상 창작 스튜디오입니다."
}'::jsonb WHERE id = 107;

-- 108. Naver CLOVA Note
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.8, "cost_efficiency_score": 5.0, "korean_support_score": 5.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.8, "community": 3.5, "value_for_money": 5.0, "korean_quality": 5.0, "ease_of_use": 5.0, "automation": 4.5 },
  "pros": ["한국어 음성 인식률 현존 최고", "화자 구분 및 타임라인 제공", "핵심 내용 AI 요약"],
  "cons": ["녹음 파일 업로드 용량 제한", "민감 정보 보안 우려"],
  "target_users": ["대학생(강의 녹음)", "기자", "회의록 작성자"],
  "integrations": ["Mobile App", "Web"],
  "summary_text": "녹음만 켜두면 알아서 받아적고, 누가 말했는지 구분하고, 요약까지 해줍니다."
}'::jsonb WHERE id = 108;

-- 109. Liner
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.3, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.3, "community": 3.5, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 4.8, "automation": 3.5 },
  "pros": ["믿을 수 있는 출처 기반 답변", "PDF/웹페이지 형광펜 하이라이트", "유튜브 영상 요약"],
  "cons": ["무료 버전 검색 제한", "심심한 UI"],
  "target_users": ["대학생(리포트)", "연구자", "자기계발러"],
  "integrations": ["Chrome Extension"],
  "summary_text": "정보의 바다에서 믿을 수 있는 알짜 정보만 형광펜으로 칠해 떠먹여 줍니다."
}'::jsonb WHERE id = 109;

-- 110. ChatPDF
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.2, "community": 3.0, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 5.0, "automation": 3.5 },
  "pros": ["PDF 파일 업로드 후 즉시 대화 가능", "논문/전공서적 요약 탁월", "가입 없이 사용 가능(제한적)"],
  "cons": ["이미지/표 인식 능력 부족", "파일 크기 제한"],
  "target_users": ["대학원생", "논문 읽는 직장인"],
  "integrations": ["Web"],
  "summary_text": "수백 페이지의 논문이나 보고서를 업로드하고 궁금한 것만 물어보세요."
}'::jsonb WHERE id = 110;

-- 111. DeepL
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.9, "cost_efficiency_score": 4.5, "korean_support_score": 4.9, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.9, "community": 4.0, "value_for_money": 4.5, "korean_quality": 4.9, "ease_of_use": 5.0, "automation": 4.0 },
  "pros": ["현존 최고 수준의 자연스러운 번역", "문맥과 뉘앙스 파악 우수", "문서 파일 통째로 번역"],
  "cons": ["지원 언어 수 구글보다 적음", "무료 버전 글자수 제한"],
  "target_users": ["번역가", "무역 종사자", "해외 논문 독자"],
  "integrations": ["Chrome", "Desktop App"],
  "summary_text": "번역기 말투가 아닌, 사람이 쓴 것처럼 자연스러운 번역이 필요할 때 필수입니다."
}'::jsonb WHERE id = 111;

-- 112. Speak
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.7, "cost_efficiency_score": 4.0, "korean_support_score": 5.0, "learning_curve_score": 4.8,
  "radar_chart": { "performance": 4.7, "community": 3.5, "value_for_money": 4.0, "korean_quality": 5.0, "ease_of_use": 4.8, "automation": 4.0 },
  "pros": ["AI와 끊임없이 프리토킹 가능", "실시간 발음/문법 교정", "한국인에게 최적화된 커리큘럼"],
  "cons": ["유료 구독 필수", "초보자에게는 대화가 부담스러울 수 있음"],
  "target_users": ["영어 회화 학습자", "오픽/토스 준비생"],
  "integrations": ["Mobile App"],
  "summary_text": "원어민 튜터 없이도 24시간 영어로 수다 떨며 회화 실력을 늘릴 수 있습니다."
}'::jsonb WHERE id = 112;

-- 113. ELSA Speak
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 4.2, "korean_support_score": 4.5, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.5, "community": 3.5, "value_for_money": 4.2, "korean_quality": 4.5, "ease_of_use": 4.5, "automation": 4.0 },
  "pros": ["정밀한 발음 분석 및 교정", "억양/강세 코칭 특화", "다양한 상황별 롤플레잉"],
  "cons": ["발음 교정 외 회화 기능은 스픽보다 약함", "유료 기능 위주"],
  "target_users": ["발음 교정 희망자", "면접 준비생"],
  "integrations": ["Mobile App"],
  "summary_text": "내 영어 발음의 문제점을 정확히 집어내고 원어민처럼 교정해주는 AI 발음 코치입니다."
}'::jsonb WHERE id = 113;

-- 114. Haijob (하이잡)
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.0, "cost_efficiency_score": 4.2, "korean_support_score": 5.0, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.0, "community": 2.5, "value_for_money": 4.2, "korean_quality": 5.0, "ease_of_use": 4.5, "automation": 3.5 },
  "pros": ["한국형 면접 질문 대량 보유", "AI 화상 면접 시뮬레이션", "시선 처리/표정 분석"],
  "cons": ["일부 기능 유료", "모바일 앱 완성도 다소 아쉬움"],
  "target_users": ["취준생", "이직 준비자"],
  "integrations": ["Web", "Mobile"],
  "summary_text": "혼자 연습하기 힘든 면접, AI 면접관과 함께 실전처럼 연습하고 피드백 받으세요."
}'::jsonb WHERE id = 114;

-- 115. inFACE
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.1, "cost_efficiency_score": 4.0, "korean_support_score": 5.0, "learning_curve_score": 4.3,
  "radar_chart": { "performance": 4.1, "community": 2.5, "value_for_money": 4.0, "korean_quality": 5.0, "ease_of_use": 4.3, "automation": 3.5 },
  "pros": ["AI 역량검사(게임 등) 대비 최적화", "자소서 AI 분석 제공", "기업별 맞춤 분석"],
  "cons": ["UI가 다소 올드함", "유료 결제 필요"],
  "target_users": ["AI 역량검사 응시자", "공기업 준비생"],
  "integrations": ["Web"],
  "summary_text": "AI 역량검사가 처음이라면, inFACE로 미리 체험하고 전략을 세우세요."
}'::jsonb WHERE id = 115;

-- 116. Flow (Microsoft Flow / Power Automate 가정)
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.4, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 3.0,
  "radar_chart": { "performance": 4.4, "community": 3.5, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 3.0, "automation": 5.0 },
  "pros": ["MS 오피스(엑셀, 팀즈)와 강력한 연동", "복잡한 비즈니스 로직 자동화", "보안성 우수"],
  "cons": ["초보자에게는 매우 어려움", "기업 계정 필요"],
  "target_users": ["사무직 직장인", "ERP 관리자"],
  "integrations": ["Microsoft 365"],
  "summary_text": "엑셀, 이메일, 팀즈를 연결해서 반복 업무를 버튼 하나로 끝내게 해줍니다."
}'::jsonb WHERE id = 116;

-- 117. MyMap.ai
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.2, "cost_efficiency_score": 4.5, "korean_support_score": 4.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.2, "community": 3.0, "value_for_money": 4.5, "korean_quality": 4.0, "ease_of_use": 5.0, "automation": 4.5 },
  "pros": ["채팅만 하면 깔끔한 마인드맵 생성", "아이디어 구조화에 최적", "비주얼 싱킹 도구"],
  "cons": ["복잡한 기능은 부족", "무료 크레딧 제한"],
  "target_users": ["기획자", "학생(개념 정리)", "브레인스토밍"],
  "integrations": ["Web"],
  "summary_text": "복잡한 생각이나 아이디어를 AI가 순식간에 깔끔한 지도(Map)로 그려줍니다."
}'::jsonb WHERE id = 117;

-- 118. Whimsical
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.3, "cost_efficiency_score": 4.5, "korean_support_score": 4.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.3, "community": 3.5, "value_for_money": 4.5, "korean_quality": 4.0, "ease_of_use": 5.0, "automation": 4.0 },
  "pros": ["AI로 마인드맵/플로우차트 자동 생성", "매우 직관적이고 예쁜 UI", "협업 기능 강력"],
  "cons": ["AI 기능은 보조적인 역할", "한글 폰트 아쉬움"],
  "target_users": ["PM/PO", "UX 디자이너", "기획자"],
  "integrations": ["Web", "Figma"],
  "summary_text": "기획서나 프로세스 흐름도를 그릴 때, AI가 초안을 잡아주어 시간을 아껴줍니다."
}'::jsonb WHERE id = 118;

-- 119. Naver CLOVA X
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.5, "cost_efficiency_score": 4.8, "korean_support_score": 5.0, "learning_curve_score": 4.5,
  "radar_chart": { "performance": 4.5, "community": 3.5, "value_for_money": 4.8, "korean_quality": 5.0, "ease_of_use": 4.5, "automation": 4.0 },
  "pros": ["한국 문화/최신 트렌드 완벽 이해", "네이버 쇼핑/주식 등 실시간 정보 연동", "가장 한국적인 답변"],
  "cons": ["코딩이나 영어 능력은 GPT 대비 약함", "대화 턴 수 제한"],
  "target_users": ["한국인 사용자", "쇼핑/정보 검색", "블로거"],
  "integrations": ["Naver"],
  "summary_text": "한국 맛집, 뉴스, 쇼핑 정보는 CLOVA X가 가장 정확하고 빠르게 알려줍니다."
}'::jsonb WHERE id = 119;

-- 120. UPDF AI
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.1, "cost_efficiency_score": 4.5, "korean_support_score": 5.0, "learning_curve_score": 5.0,
  "radar_chart": { "performance": 4.1, "community": 2.5, "value_for_money": 4.5, "korean_quality": 5.0, "ease_of_use": 5.0, "automation": 3.5 },
  "pros": ["PDF 편집 프로그램 내장 AI", "문서 요약/번역/설명 올인원", "가성비 좋음"],
  "cons": ["전문적인 AI 엔진보다는 성능 낮음", "설치형 프로그램"],
  "target_users": ["사무직", "대학생"],
  "integrations": ["Win/Mac App"],
  "summary_text": "PDF를 보면서 바로 요약하고 수정까지 할 수 있는 가성비 좋은 문서 도구입니다."
}'::jsonb WHERE id = 120;

-- 121. Cursor
UPDATE public.ai_models SET comparison_data = '{
  "performance_score": 4.9, "cost_efficiency_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.2,
  "radar_chart": { "performance": 4.9, "community": 4.5, "value_for_money": 4.5, "korean_quality": 4.5, "ease_of_use": 4.2, "automation": 5.0 },
  "pros": ["VS Code 포크로 적응 쉬움", "프로젝트 전체 코드베이스 이해", "터미널 에러 수정 탁월"],
  "cons": ["유료 구독(Pro) 필수적", "일부 확장 프로그램 호환성 이슈"],
  "target_users": ["풀스택 개발자", "코딩 입문자"],
  "integrations": ["VS Code Extension 호환"],
  "summary_text": "현재 가장 핫한 AI 코드 에디터. 단순 생성을 넘어 프로젝트 전체를 이해하고 코딩합니다."
}'::jsonb WHERE id = 121;
