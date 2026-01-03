-- Finalized AI Models Data Update (Optimized for JSON compatibility)
-- Updates pricing_info, features (search_tags), and comparison_data

-- 1. ChatGPT (ID: 81 check, but usually 1 or 41, using name match for safety)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Plus: $20/월 / Pro: $200/월 / Team: $25–30/월 / Enterprise: 영업팀 문의',
  features = ARRAY['대화형 AI', '텍스트 생성', '코딩 지원', '이미지 생성', '파일 분석', '웹 검색'],
  comparison_data = '{"cons": ["무료 버전 제한", "최신 정보 반영 딜레이"], "pros": ["범용 텍스트, 코딩, 학습까지 모두 커버", "가장 강력한 추론 능력", "방대한 플러그인 생태계"], "radar_chart": {"community": 5, "automation": 3.5, "ease_of_use": 4.5, "performance": 4.7, "korean_quality": 4.3, "value_for_money": 4}, "integrations": ["API", "Zapier", "Notion", "Slack", "Microsoft Teams"], "summary_text": "텍스트 작업과 학습 중심이라면 ChatGPT가 가장 균형 잡힌 선택입니다.", "target_users": ["대학생", "취준생", "일반 사용자"], "performance_score": 4.7, "security_features": ["Enterprise 플랜 제공", "데이터 암호화", "학습 데이터 옵트아웃"], "korean_support_score": 4.3, "learning_curve_score": 4.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'ChatGPT%';

-- 2. Gemini (ID: 82)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Advanced: $19.99/월',
  features = ARRAY['멀티모달 AI', '긴 컨텍스트', '이미지 분석', '코딩 지원', '텍스트 생성', '웹 검색'],
  comparison_data = '{"cons": ["일부 답변의 환각 현상", "한국어 뉘앙스 처리 부족"], "pros": ["Google 생태계(Docs, Gmail) 연동", "긴 컨텍스트 윈도우", "멀티모달 강점"], "radar_chart": {"community": 4, "automation": 4.5, "ease_of_use": 4.5, "performance": 4.3, "korean_quality": 3.8, "value_for_money": 4.2}, "integrations": ["Google Workspace", "Gmail", "Docs", "Sheets", "Drive"], "summary_text": "가성비와 Google 생태계 연동이 중요하다면 Gemini를 추천합니다.", "target_users": ["Google Workspace 사용자", "팀 협업"], "performance_score": 4.3, "security_features": ["Google 보안 표준", "데이터 학습 분리 정책"], "korean_support_score": 3.8, "learning_curve_score": 4.3, "cost_efficiency_score": 4.2}'::jsonb
WHERE name LIKE 'Gemini%' OR name LIKE 'Google Gemini%';

-- 3. Claude (ID: 83)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: $20/월 / Team: $25–30/월 / Enterprise: 영업팀 문의',
  features = ARRAY['대화형 AI', '코딩 지원', '문서 분석', '협업', '고급 추론', '자연스러운 글쓰기'],
  comparison_data = '{"cons": ["이미지 생성 기능 부재", "GPT 대비 부가 기능(플러그인 등) 적음"], "pros": ["매우 긴 컨텍스트 윈도우(긴 글 처리에 유리)", "자연스럽고 문학적인 문장 생성", "안전하고 윤리적인 답변"], "radar_chart": {"community": 4, "automation": 4, "ease_of_use": 4.7, "performance": 4.8, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["API", "Slack", "Notion"], "summary_text": "긴 논문이나 소설을 분석하고 요약하는 데 있어서는 타의 추종을 불허하는 성능을 보여줍니다.", "target_users": ["작가", "연구원", "긴 문서를 다루는 직장인"], "performance_score": 4.8, "korean_support_score": 4.5, "learning_curve_score": 4.7, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Claude%';

-- 4. Perplexity (ID: 84)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: $20/월',
  features = ARRAY['AI 검색', '실시간 정보', '소스 인용', '요약', '질문 답변', '정확한 정보'],
  comparison_data = '{"cons": ["창의적인 글쓰기 능력은 다소 부족", "복잡한 코딩 문제 해결력은 GPT-4 대비 낮음"], "pros": ["실시간 웹 검색 기반의 정확한 답변", "출처 표기로 신뢰성 높음", "빠른 검색 속도"], "radar_chart": {"community": 3.5, "automation": 3.5, "ease_of_use": 4.9, "performance": 4.7, "korean_quality": 4.8, "value_for_money": 4.5}, "integrations": ["Chrome Extension", "Mobile App"], "summary_text": "구글링의 시간을 혁신적으로 단축시켜주는, 출처를 알려주는 똑똑한 검색 비서입니다.", "target_users": ["대학생(리포트 자료 조사)", "기자", "시장 조사관"], "performance_score": 4.7, "korean_support_score": 4.8, "learning_curve_score": 4.9, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Perplexity%';

-- 5. Midjourney (ID: 85)
UPDATE public.ai_models
SET 
  pricing_info = 'Basic: $10/월 / Standard: $30/월 / Pro: $60/월',
  features = ARRAY['AI 이미지 생성', '고품질 아트', '다양한 스타일', '업스케일링', '변형 생성'],
  comparison_data = '{"cons": ["디스코드 기반이라 사용 편의성 낮음", "월 구독 필수", "정밀한 수정(Inpainting) 까다로움"], "pros": ["압도적인 예술적 이미지 퀄리티", "다양한 화풍 완벽 소화", "활발한 커뮤니티"], "radar_chart": {"community": 5, "automation": 2, "ease_of_use": 2.5, "performance": 4.9, "korean_quality": 2, "value_for_money": 3}, "integrations": ["Discord"], "summary_text": "사용법은 조금 어렵지만, 결과물의 퀄리티 하나만으로 모든 단점을 상쇄하는 최고의 이미지 생성 AI입니다.", "target_users": ["디자이너", "일러스트레이터", "콘텐츠 기획자"], "performance_score": 4.9, "korean_support_score": 2, "learning_curve_score": 2.5, "cost_efficiency_score": 3}'::jsonb
WHERE name LIKE 'Midjourney%';

-- 6. DALL-E (ID: 86)
UPDATE public.ai_models
SET 
  pricing_info = 'ChatGPT Plus 포함 / API: $0.04–0.08/이미지',
  features = ARRAY['AI 이미지 생성', '텍스트 to 이미지', '고품질 생성', '다양한 스타일', 'ChatGPT 연동'],
  comparison_data = '{"cons": ["미드저니 대비 사실적인 묘사력 부족", "생성된 이미지 퀄리티 편차 존재"], "pros": ["ChatGPT와 대화하듯 쉽게 이미지 생성", "복잡한 지시사항도 잘 이해함", "한글 프롬프트 인식 우수"], "radar_chart": {"community": 4, "automation": 4, "ease_of_use": 5, "performance": 4.5, "korean_quality": 4.8, "value_for_money": 4}, "integrations": ["ChatGPT", "Microsoft Bing"], "summary_text": "가장 쉽고 편하게 이미지를 만들고 싶다면 최고의 선택입니다. 챗봇에게 말하듯 그리면 됩니다.", "target_users": ["블로거", "마케터", "초보 사용자"], "performance_score": 4.5, "korean_support_score": 4.8, "learning_curve_score": 5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'DALL-E%';

-- 7. Adobe Firefly (ID: 87)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료(제한) / Premium: $4.99/월',
  features = ARRAY['AI 이미지 생성', '벡터 생성', '영상 합성', '고급 디자인', '상업적 사용'],
  comparison_data = '{"cons": ["예술적 창의성은 미드저니보다 낮음", "Adobe 구독 필요"], "pros": ["저작권 문제없는 안전한 이미지 생성", "포토샵/일러스트레이터와 강력한 연동", "텍스트 효과 생성 탁월"], "radar_chart": {"community": 3.5, "automation": 4.5, "ease_of_use": 4.5, "performance": 4.4, "korean_quality": 4.5, "value_for_money": 4}, "integrations": ["Photoshop", "Illustrator", "Express"], "summary_text": "저작권 걱정 없이 상업적으로 이용 가능한 이미지를 포토샵 안에서 바로 생성하세요.", "target_users": ["현업 디자이너", "상업용 이미지 제작자"], "performance_score": 4.4, "korean_support_score": 4.5, "learning_curve_score": 4.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Adobe Firefly%';

-- 8. Stable Diffusion (ID: 88)
UPDATE public.ai_models
SET 
  pricing_info = 'Local: 무료 / DreamStudio: $10/1000 credits',
  features = ARRAY['오픈소스 AI', '이미지 생성', '커스터마이징', '로컬 실행', 'API 제공'],
  comparison_data = '{"cons": ["고사양 PC 필요", "설치 및 설정 매우 어려움", "학습 곡선 가파름"], "pros": ["완전 무료(오픈소스)", "설치형으로 무제한 생성 가능", "가장 세밀한 제어 가능(ControlNet 등)"], "radar_chart": {"community": 5, "automation": 4, "ease_of_use": 1.5, "performance": 4.6, "korean_quality": 3, "value_for_money": 5}, "integrations": ["Automatic1111", "ComfyUI"], "summary_text": "배우기는 어렵지만, 익숙해지면 비용 없이 가장 자유롭게 이미지를 생성할 수 있습니다.", "target_users": ["AI 연구자", "고급 사용자", "게임 개발자"], "performance_score": 4.6, "korean_support_score": 3, "learning_curve_score": 1.5, "cost_efficiency_score": 5}'::jsonb
WHERE name LIKE 'Stable Diffusion%';

-- 9. Notion AI (ID: 89)
UPDATE public.ai_models
SET 
  pricing_info = 'Add-on: $8/월 / Plus: $10/월',
  features = ARRAY['생산성 도구', '텍스트 생성', '요약', '번역', '협업', '데이터베이스'],
  comparison_data = '{"cons": ["별도 요금제", "복잡한 추론 능력은 부족"], "pros": ["노션 워크스페이스 내장", "회의록 정리 및 번역에 탁월", "문서 톤 앤 매너 변경 용이"], "radar_chart": {"community": 4.5, "automation": 3.5, "ease_of_use": 4.8, "performance": 4.3, "korean_quality": 4.7, "value_for_money": 4}, "integrations": ["Notion"], "summary_text": "노션에 작성된 글을 다듬고 요약하는 데 최적화된 업무 보조 비서입니다.", "target_users": ["노션 사용자", "PM", "대학생"], "performance_score": 4.3, "korean_support_score": 4.7, "learning_curve_score": 4.8, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Notion AI%';

-- 10. Grammarly (ID: 90)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 기본 / Premium: $12–30/월',
  features = ARRAY['문법 검사', '스타일 개선', '표절 방지', '톤 조정', '실시간 수정'],
  comparison_data = '{"cons": ["한국어 미지원", "프리미엄 가격 부담"], "pros": ["세계 최고의 영문법 교정", "다양한 플랫폼 지원", "문체/톤 교정"], "radar_chart": {"community": 4, "automation": 4.5, "ease_of_use": 5, "performance": 4.7, "korean_quality": 0, "value_for_money": 3.5}, "integrations": ["MS Word", "Google Docs", "Browser"], "summary_text": "영어 이메일이나 논문을 쓸 때, 원어민처럼 매끄러운 문장을 만들어 드립니다.", "target_users": ["영어 논문 작성자", "유학생", "비즈니스맨"], "performance_score": 4.7, "korean_support_score": 0, "learning_curve_score": 5, "cost_efficiency_score": 3.5}'::jsonb
WHERE name LIKE 'Grammarly%';

-- 11. Jasper (ID: 91)
UPDATE public.ai_models
SET 
  pricing_info = 'Creator: $39/월 / Pro: $59/월',
  features = ARRAY['마케팅 콘텐츠', '블로그 포스트', '소셜미디어', '이메일', '광고 카피', '브랜드 보이스'],
  comparison_data = '{"cons": ["비싼 가격 정책", "일반 사용자에게는 과분한 기능"], "pros": ["마케팅 카피라이팅 특화", "브랜드 보이스 설정 가능", "다양한 템플릿 제공"], "radar_chart": {"community": 3.5, "automation": 4.5, "ease_of_use": 4, "performance": 4.5, "korean_quality": 4, "value_for_money": 3}, "integrations": ["Surfer SEO", "Chrome Extension"], "summary_text": "팔리는 글쓰기가 필요하다면, 마케터를 위해 훈련된 Jasper가 정답입니다.", "target_users": ["마케터", "광고 기획자", "콘텐츠 에디터"], "performance_score": 4.5, "korean_support_score": 4, "learning_curve_score": 4, "cost_efficiency_score": 3}'::jsonb
WHERE name LIKE 'Jasper%';

-- 12. Copy.ai (ID: 92)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 체험 / Pro: $35–49/월',
  features = ARRAY['AI 카피라이팅', '마케팅 텍스트', '소셜미디어', '이메일', '제품 설명', '템플릿'],
  comparison_data = '{"cons": ["깊이 있는 글쓰기는 부족", "한국어 뉘앙스 가끔 어색"], "pros": ["마케팅 문구 무료 생성(제한적)", "직관적인 인터페이스", "빠른 블로그 포스트 작성"], "radar_chart": {"community": 3, "automation": 4, "ease_of_use": 4.8, "performance": 4.2, "korean_quality": 4, "value_for_money": 4.5}, "integrations": ["Zapier"], "summary_text": "인스타그램 캡션이나 블로그 주제가 떠오르지 않을 때 아이러니를 해소해줍니다.", "target_users": ["소상공인", "SNS 마케터", "초보 블로거"], "performance_score": 4.2, "korean_support_score": 4, "learning_curve_score": 4.8, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Copy.ai%';

-- 13. GitHub Copilot (ID: 93)
UPDATE public.ai_models
SET 
  pricing_info = 'Student: 무료 / Individual: $10/월 / Business: $19/월',
  features = ARRAY['AI 코드 완성', '멀티 언어', 'IDE 통합', '자동완성', '보안', '페어 프로그래밍'],
  comparison_data = '{"cons": ["전체 프로젝트 맥락 이해는 아직 발전 중", "기업용 유료"], "pros": ["VS Code 완벽 통합", "놀라운 코드 자동 완성 정확도", "학생 무료"], "radar_chart": {"community": 5, "automation": 5, "ease_of_use": 4.5, "performance": 4.8, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["VS Code", "JetBrains", "Visual Studio"], "summary_text": "타자를 칠 필요를 없게 만드는, 개발자의 생산성을 2배로 늘려주는 코딩 파트너입니다.", "target_users": ["개발자", "컴공과 학생"], "performance_score": 4.8, "korean_support_score": 4.5, "learning_curve_score": 4.5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'GitHub Copilot%';

-- 14. Replit (ID: 94)
UPDATE public.ai_models
SET 
  pricing_info = 'Starter: 무료 / Core: $20/월',
  features = ARRAY['온라인 IDE', 'AI 코딩', '협업', '배포', '데이터베이스', '클라우드'],
  comparison_data = '{"cons": ["대규모 프로젝트에는 부적합", "브라우저 의존성"], "pros": ["설치 없는 온라인 코딩 환경", "AI가 코드 설명/수정/생성", "실시간 협업 가능"], "radar_chart": {"community": 4.5, "automation": 4.2, "ease_of_use": 4.8, "performance": 4.3, "korean_quality": 4, "value_for_money": 4.8}, "integrations": ["Github Import"], "summary_text": "개발 환경 설정 없이 바로 코딩하고 AI의 도움을 받아 배포까지 한 번에 가능합니다.", "target_users": ["코딩 입문자", "학생", "프로토타이핑"], "performance_score": 4.3, "korean_support_score": 4, "learning_curve_score": 4.8, "cost_efficiency_score": 4.8}'::jsonb
WHERE name LIKE 'Replit%';

-- 15. Tabnine (ID: 95)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 기본 / Pro: $9/월 / Enterprise: $39/월',
  features = ARRAY['AI 코드 완성', '자동완성', '멀티 언어', '팀 협업', '보안', '개인화'],
  comparison_data = '{"cons": ["Copilot 대비 추론 능력 다소 낮음", "무료 버전 기능 제한"], "pros": ["높은 프라이버시(로컬 모델 지원)", "기업 보안에 강함", "다양한 IDE 지원"], "radar_chart": {"community": 3.5, "automation": 4.5, "ease_of_use": 4.5, "performance": 4.2, "korean_quality": 3.5, "value_for_money": 4}, "integrations": ["VS Code", "IntelliJ", "Eclipse"], "summary_text": "내 코드가 외부로 유출될 걱정 없이 안전하게 AI 코딩 자동완성을 사용하세요.", "target_users": ["보안이 중요한 기업 개발자", "오프라인 코딩"], "performance_score": 4.2, "korean_support_score": 3.5, "learning_curve_score": 4.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Tabnine%';

-- 16. Synthesia (ID: 96)
UPDATE public.ai_models
SET 
  pricing_info = 'Starter: $22/월 / Creator: $67/월',
  features = ARRAY['AI 동영상', '아바타 생성', '음성 합성', '다국어', '자동화', '텍스트 to 비디오'],
  comparison_data = '{"cons": ["가격이 비쌈", "아직은 미세한 표정의 어색함 존재"], "pros": ["실사 같은 AI 아바타 생성", "다국어 립싱크 자연스러움", "PPT로 영상 만들기 가능"], "radar_chart": {"community": 3, "automation": 4.5, "ease_of_use": 4.5, "performance": 4.6, "korean_quality": 4.5, "value_for_money": 4}, "integrations": ["PowerPoint"], "summary_text": "카메라와 마이크 없이 텍스트만 입력하면 전문적인 발표 영상을 만들어줍니다.", "target_users": ["기업 교육 담당자", "마케터", "유튜버"], "performance_score": 4.6, "korean_support_score": 4.5, "learning_curve_score": 4.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Synthesia%';

-- 17. ElevenLabs (ID: 97)
UPDATE public.ai_models
SET 
  pricing_info = 'Starter: $4.17/월 / Creator: $11/월 / Pro: $82.5/월',
  features = ARRAY['AI 음성 합성', '음성 복제', '다국어', '고품질 오디오', 'API 제공', '목소리 복제'],
  comparison_data = '{"cons": ["무료 제공량 적음", "생성 속도에 따른 비용 발생"], "pros": ["가장 자연스러운 AI 목소리 생성", "감정 표현/숨소리까지 구현", "적은 샘플로 목소리 복제"], "radar_chart": {"community": 4, "automation": 4.5, "ease_of_use": 4.8, "performance": 4.9, "korean_quality": 4.8, "value_for_money": 4}, "integrations": ["API"], "summary_text": "사람인지 AI인지 구분이 불가능할 정도의 감정이 담긴 목소리를 생성합니다.", "target_users": ["오디오북 제작자", "유튜버", "게임 개발자"], "performance_score": 4.9, "korean_support_score": 4.8, "learning_curve_score": 4.8, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'ElevenLabs%';

-- 18. Suno (ID: 98)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: $10/월 / Premium: $30/월',
  features = ARRAY['AI 음악 생성', '멜로디 생성', '가사 생성', '다양한 장르', '고품질 오디오', '음악 작곡'],
  comparison_data = '{"cons": ["세밀한 편집 불가", "상업적 이용 시 유료 구독 필요"], "pros": ["텍스트로 작사/작곡/보컬까지 한번에", "높은 음악적 퀄리티", "한글 가사 지원 우수"], "radar_chart": {"community": 4.5, "automation": 4.8, "ease_of_use": 5, "performance": 4.8, "korean_quality": 4.5, "value_for_money": 5}, "integrations": ["Discord", "Web"], "summary_text": "음악을 전혀 몰라도 나만의 노래를 1분 만에 뚝딱 만들어내는 마법 같은 도구입니다.", "target_users": ["콘텐츠 크리에이터", "작곡 취미생", "기념일 선물"], "performance_score": 4.8, "korean_support_score": 4.5, "learning_curve_score": 5, "cost_efficiency_score": 5}'::jsonb
WHERE name LIKE 'Suno%';

-- 19. Zapier (ID: 99)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Starter: $29.99/월 / Professional: $73.50/월',
  features = ARRAY['자동화', '워크플로우', '앱 연동', '데이터 동기화', 'API 연결', '업무 자동화'],
  comparison_data = '{"cons": ["복잡한 워크플로우 구성 시 어려움", "사용량 많으면 비쌈"], "pros": ["6000개 이상의 앱 연동", "노코드 자동화의 최강자", "AI 기능 추가로 작성 자동화"], "radar_chart": {"community": 5, "automation": 5, "ease_of_use": 3.5, "performance": 4.5, "korean_quality": 3.5, "value_for_money": 4}, "integrations": ["Gmail", "Slack", "Notion", "Sheets"], "summary_text": "반복되는 귀찮은 업무들을 서로 연결해서 자동으로 처리해주는 업무 자동화의 허브입니다.", "target_users": ["업무 자동화 담당자", "마케터", "스타트업"], "performance_score": 4.5, "korean_support_score": 3.5, "learning_curve_score": 3.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Zapier%';

-- 20. Canva (ID: 100)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: $12.99/월 / Team: $14.99/월',
  features = ARRAY['디자인 도구', 'AI 템플릿', '이미지 생성', '협업', '브랜드킷', 'Magic Studio'],
  comparison_data = '{"cons": ["전문적인 디자인 툴보다는 기능 제한", "일부 고급 소재 유료"], "pros": ["디자인 템플릿 최다 보유", "Magic Studio 등 AI 기능 대거 탑재", "팀 협업 용이"], "radar_chart": {"community": 5, "automation": 4, "ease_of_use": 5, "performance": 4.7, "korean_quality": 5, "value_for_money": 4.8}, "integrations": ["SNS", "Google Drive"], "summary_text": "디자이너가 없어도 전문가 수준의 카드뉴스, PPT, 포스터를 가장 쉽게 만들 수 있습니다.", "target_users": ["마케터", "소상공인", "학생", "프리랜서"], "performance_score": 4.7, "korean_support_score": 5, "learning_curve_score": 5, "cost_efficiency_score": 4.8}'::jsonb
WHERE name LIKE 'Canva%';

-- 21. Wrtn (ID: 101)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: 11,900원/월',
  features = ARRAY['자소서 작성', '블로그 포스팅', '보고서 생성', 'AI 검색', '챗봇'],
  comparison_data = '{"cons": ["복잡한 코딩/추론은 GPT 원본보다 약함", "생성 속도가 때때로 느림"], "pros": ["GPT-4 등 최신 모델 무료 사용", "완벽한 한국어 지원 및 현지화", "메신저처럼 쉬운 접근성"], "radar_chart": {"community": 4, "automation": 3, "ease_of_use": 5, "performance": 4.6, "korean_quality": 5, "value_for_money": 5}, "integrations": ["Web", "App", "KakaoTalk"], "summary_text": "비싼 구독료 없이 최신 AI 모델을 한국 환경에 맞게 무료로 쓸 수 있는 국민 AI 서비스입니다.", "target_users": ["대학생", "직장인", "일반 사용자"], "performance_score": 4.6, "korean_support_score": 5, "learning_curve_score": 5, "cost_efficiency_score": 5}'::jsonb
WHERE name LIKE 'Wrtn%';

-- 22. QuillBot (ID: 102)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 제한 / Premium: $8.33/월',
  features = ARRAY['패러프레이징', '문법 검사', '요약', '인용 생성', '표절 검사'],
  comparison_data = '{"cons": ["한국어 미지원", "단순 요약 외 기능 부족"], "pros": ["문장 재구성(Paraphrasing) 최고 성능", "표절 회피에 유용", "다양한 문체 선택 가능"], "radar_chart": {"community": 4, "automation": 4, "ease_of_use": 4.8, "performance": 4.4, "korean_quality": 0, "value_for_money": 4.5}, "integrations": ["Chrome", "Word"], "summary_text": "영어 문장이 딱딱하거나 반복될 때, 같은 뜻의 다른 문장으로 매끄럽게 바꿔줍니다.", "target_users": ["영어 논문 작성자", "유학생", "글로벌 마케터"], "performance_score": 4.4, "korean_support_score": 0, "learning_curve_score": 4.8, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'QuillBot%';

-- 23. CopyKiller (ID: 103)
UPDATE public.ai_models
SET 
  pricing_info = 'Lite: 무료 / Pro: 9,900원/건 / Users: 16,500원/월',
  features = ARRAY['표절 검사', 'AI 글 탐지', '참고문헌 검증'],
  comparison_data = '{"cons": ["유료(건당 결제)", "표절 검사 외 기능 없음"], "pros": ["국내 DB 최다 보유로 정확한 표절 검사", "AI 작성 글 탐지 기능", "참고문헌 올바른 표기법 제공"], "radar_chart": {"community": 3, "automation": 3, "ease_of_use": 5, "performance": 4.2, "korean_quality": 5, "value_for_money": 3.5}, "integrations": ["Web"], "summary_text": "과제 제출 전 필수 코스. 표절률을 확인하고 안전하게 리포트를 제출하세요.", "target_users": ["대학생(과제)", "논문 투고자"], "performance_score": 4.2, "korean_support_score": 5, "learning_curve_score": 5, "cost_efficiency_score": 3.5}'::jsonb
WHERE name LIKE 'CopyKiller%';

-- 24. Gamma (ID: 104)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Plus: $8/월 / Pro: $15/월',
  features = ARRAY['자동 PPT 생성', '웹페이지 제작', '디자인 레이아웃', '이미지 생성'],
  comparison_data = '{"cons": ["레이아웃 세부 수정이 제한적", "한글 폰트 다양성 부족"], "pros": ["주제만 입력하면 PPT 디자인까지 자동 완성", "세련된 레이아웃 제공", "웹 공유 용이"], "radar_chart": {"community": 3.5, "automation": 4.8, "ease_of_use": 4.8, "performance": 4.3, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["PPT Export", "PDF"], "summary_text": "PPT 빈 화면 공포증 해결사. 내용만 적으면 디자인은 알아서 완성됩니다.", "target_users": ["발표가 잦은 직장인", "대학생", "강사"], "performance_score": 4.3, "korean_support_score": 4.5, "learning_curve_score": 4.8, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Gamma%';

-- 25. Tome (ID: 105)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 500 Credits / Pro: $16/월',
  features = ARRAY['스토리텔링 프레젠테이션', '내러티브 구성', '시각 자료 생성'],
  comparison_data = '{"cons": ["전통적인 PPT 형식과는 다소 차이", "유료화 정책 강화"], "pros": ["스토리텔링 중심의 슬라이드 생성", "DALL-E 연동 이미지 자동 삽입", "모바일에 최적화된 뷰"], "radar_chart": {"community": 3, "automation": 4.5, "ease_of_use": 4.5, "performance": 4.2, "korean_quality": 4, "value_for_money": 4}, "integrations": ["Web Share"], "summary_text": "단순한 발표 자료를 넘어 하나의 이야기를 담은 웹북 형태의 프레젠테이션을 만듭니다.", "target_users": ["스타트업 피칭", "포트폴리오 제작자"], "performance_score": 4.2, "korean_support_score": 4, "learning_curve_score": 4.5, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Tome%';

-- 26. Vrew (ID: 106)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Light: 7,900원/월 / Standard: 13,900원/월',
  features = ARRAY['자동 자막 생성', '영상 편집', 'AI 더빙', '음성 인식'],
  comparison_data = '{"cons": ["전문 편집 툴(프리미어) 대비 효과 부족", "무거운 파일 작업 시 버벅임"], "pros": ["음성 인식으로 자동 자막 생성 최고봉", "워드처럼 쉬운 영상 컷 편집", "무료 기능 강력함"], "radar_chart": {"community": 4, "automation": 4.8, "ease_of_use": 4.9, "performance": 4.5, "korean_quality": 5, "value_for_money": 5}, "integrations": ["YouTube", "Premiere XML"], "summary_text": "자막 작업 시간을 1/10로 줄여줍니다. 말하는 영상 편집에는 대체 불가능한 도구입니다.", "target_users": ["유튜버", "숏폼 크리에이터", "영상 편집 초보"], "performance_score": 4.5, "korean_support_score": 5, "learning_curve_score": 4.9, "cost_efficiency_score": 5}'::jsonb
WHERE name LIKE 'Vrew%';

-- 27. Runway (ID: 107)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Standard: $12/월 / Pro: $28/월',
  features = ARRAY['Text-to-Video', 'Image-to-Video', '객체 제거', '배경 교체', '스타일 변경'],
  comparison_data = '{"cons": ["고급 기능은 비싼 유료 플랜", "높은 사양 요구", "사용법 익히기 필요"], "pros": ["영상 배경 지우기/교체 등 AI 매직 툴", "텍스트로 동영상 생성(Gen-2)", "웹 기반 전문 편집"], "radar_chart": {"community": 3.5, "automation": 4.5, "ease_of_use": 3.5, "performance": 4.4, "korean_quality": 3, "value_for_money": 3.5}, "integrations": ["Web"], "summary_text": "영화 CG급의 효과를 AI로 손쉽게 구현할 수 있는 차세대 영상 창작 스튜디오입니다.", "target_users": ["영상 디자이너", "영화 제작자", "아티스트"], "performance_score": 4.4, "korean_support_score": 3, "learning_curve_score": 3.5, "cost_efficiency_score": 3.5}'::jsonb
WHERE name LIKE 'Runway%';

-- 28. Naver CLOVA Note (ID: 108)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료',
  features = ARRAY['음성인식', '텍스트 변환', 'AI 요약', '회의록 생성'],
  comparison_data = '{"cons": ["녹음 파일 업로드 용량 제한", "민감 정보 보안 우려"], "pros": ["한국어 음성 인식률 현존 최고", "화자 구분 및 타임라인 제공", "핵심 내용 AI 요약"], "radar_chart": {"community": 3.5, "automation": 4.5, "ease_of_use": 5, "performance": 4.8, "korean_quality": 5, "value_for_money": 5}, "integrations": ["Mobile App", "Web"], "summary_text": "녹음만 켜두면 알아서 받아적고, 누가 말했는지 구분하고, 요약까지 해줍니다.", "target_users": ["대학생(강의 녹음)", "기자", "회의록 작성자"], "performance_score": 4.8, "korean_support_score": 5, "learning_curve_score": 5, "cost_efficiency_score": 5}'::jsonb
WHERE name LIKE 'Naver CLOVA Note%';

-- 29. Liner (ID: 109)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 기본 / Pro: $11.67/월',
  features = ARRAY['웹 검색', 'PDF 분석', '하이라이트', '출처 기반 답변', 'AI 코파일럿'],
  comparison_data = '{"cons": ["무료 버전 검색 제한", "심심한 UI"], "pros": ["믿을 수 있는 출처 기반 답변", "PDF/웹페이지 형광펜 하이라이트", "유튜브 영상 요약"], "radar_chart": {"community": 3.5, "automation": 3.5, "ease_of_use": 4.8, "performance": 4.3, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["Chrome Extension"], "summary_text": "정보의 바다에서 믿을 수 있는 알짜 정보만 형광펜으로 칠해 떠먹여 줍니다.", "target_users": ["대학생(리포트)", "연구자", "자기계발러"], "performance_score": 4.3, "korean_support_score": 4.5, "learning_curve_score": 4.8, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Liner%';

-- 30. ChatPDF (ID: 110)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 제한 / Plus: $5/월',
  features = ARRAY['PDF 업로드', 'AI 채팅', '질문답변', '문서 분석'],
  comparison_data = '{"cons": ["이미지/표 인식 능력 부족", "파일 크기 제한"], "pros": ["PDF 파일 업로드 후 즉시 대화 가능", "논문/전공서적 요약 탁월", "가입 없이 사용 가능(제한적)"], "radar_chart": {"community": 3, "automation": 3.5, "ease_of_use": 5, "performance": 4.2, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["Web"], "summary_text": "수백 페이지의 논문이나 보고서를 업로드하고 궁금한 것만 물어보세요.", "target_users": ["대학원생", "논문 읽는 직장인"], "performance_score": 4.2, "korean_support_score": 4.5, "learning_curve_score": 5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'ChatPDF%';

-- 31. DeepL (ID: 111)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Starter: $8.74/월 / Advanced: $28.74/월',
  features = ARRAY['고품질 번역', 'DeepL Write', '용어집', '보안 번역'],
  comparison_data = '{"cons": ["지원 언어 수 구글보다 적음", "무료 버전 글자수 제한"], "pros": ["현존 최고 수준의 자연스러운 번역", "문맥과 뉘앙스 파악 우수", "문서 파일 통째로 번역"], "radar_chart": {"community": 4, "automation": 4, "ease_of_use": 5, "performance": 4.9, "korean_quality": 4.9, "value_for_money": 4.5}, "integrations": ["Chrome", "Desktop App"], "summary_text": "번역기 말투가 아닌, 사람이 쓴 것처럼 자연스러운 번역이 필요할 때 필수입니다.", "target_users": ["번역가", "무역 종사자", "해외 논문 독자"], "performance_score": 4.9, "korean_support_score": 4.9, "learning_curve_score": 5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'DeepL%';

-- 32. Speak (ID: 112)
UPDATE public.ai_models
SET 
  pricing_info = 'Premium: 12,400원/월 / Premium Plus: 23,200원/월',
  features = ARRAY['AI 음성인식', '스피킹 훈련', '즉각 피드백', '상황별 회화'],
  comparison_data = '{"cons": ["유료 구독 필수", "초보자에게는 대화가 부담스러울 수 있음"], "pros": ["AI와 끊임없이 프리토킹 가능", "실시간 발음/문법 교정", "한국인에게 최적화된 커리큘럼"], "radar_chart": {"community": 3.5, "automation": 4, "ease_of_use": 4.8, "performance": 4.7, "korean_quality": 5, "value_for_money": 4}, "integrations": ["Mobile App"], "summary_text": "원어민 튜터 없이도 24시간 영어로 수다 떨며 회화 실력을 늘릴 수 있습니다.", "target_users": ["영어 회화 학습자", "오픽/토스 준비생"], "performance_score": 4.7, "korean_support_score": 5, "learning_curve_score": 4.8, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'Speak%';

-- 33. ELSA Speak (ID: 113)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 / Pro: $11.99/월 / Premium: $19.99/분기',
  features = ARRAY['발음 분석', '억양 교정', '강세 훈련', '리듬 학습'],
  comparison_data = '{"cons": ["발음 교정 외 회화 기능은 스픽보다 약함", "유료 기능 위주"], "pros": ["정밀한 발음 분석 및 교정", "억양/강세 코칭 특화", "다양한 상황별 롤플레잉"], "radar_chart": {"community": 3.5, "automation": 4, "ease_of_use": 4.5, "performance": 4.5, "korean_quality": 4.5, "value_for_money": 4.2}, "integrations": ["Mobile App"], "summary_text": "내 영어 발음의 문제점을 정확히 집어내고 원어민처럼 교정해주는 AI 발음 코치입니다.", "target_users": ["발음 교정 희망자", "면접 준비생"], "performance_score": 4.5, "korean_support_score": 4.5, "learning_curve_score": 4.5, "cost_efficiency_score": 4.2}'::jsonb
WHERE name LIKE 'ELSA Speak%';

-- 34. Haijob (ID: 114)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 무료 체험 / 유료: 건당 결제',
  features = ARRAY['AI 면접 질문 생성', '영상 모의 면접', 'AI 피드백', '자소서 기반 질문'],
  comparison_data = '{"cons": ["일부 기능 유료", "모바일 앱 완성도 다소 아쉬움"], "pros": ["한국형 면접 질문 대량 보유", "AI 화상 면접 시뮬레이션", "시선 처리/표정 분석"], "radar_chart": {"community": 2.5, "automation": 3.5, "ease_of_use": 4.5, "performance": 4, "korean_quality": 5, "value_for_money": 4.2}, "integrations": ["Web", "Mobile"], "summary_text": "혼자 연습하기 힘든 면접, AI 면접관과 함께 실전처럼 연습하고 피드백 받으세요.", "target_users": ["취준생", "이직 준비자"], "performance_score": 4, "korean_support_score": 5, "learning_curve_score": 4.5, "cost_efficiency_score": 4.2}'::jsonb
WHERE name LIKE 'Haijob%';

-- 35. inFACE (ID: 115)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 제휴 대학 무료 / 유료: 개별 구매',
  features = ARRAY['자소서 작성', 'AI 첨삭', '면접 연습', '빅데이터 분석', 'E-GPT 첨삭'],
  comparison_data = '{"cons": ["UI가 다소 올드함", "유료 결제 필요"], "pros": ["AI 역량검사(게임 등) 대비 최적화", "자소서 AI 분석 제공", "기업별 맞춤 분석"], "radar_chart": {"community": 2.5, "automation": 3.5, "ease_of_use": 4.3, "performance": 4.1, "korean_quality": 5, "value_for_money": 4}, "integrations": ["Web"], "summary_text": "AI 역량검사가 처음이라면, inFACE로 미리 체험하고 전략을 세우세요.", "target_users": ["AI 역량검사 응시자", "공기업 준비생"], "performance_score": 4.1, "korean_support_score": 5, "learning_curve_score": 4.3, "cost_efficiency_score": 4}'::jsonb
WHERE name LIKE 'inFACE%';

-- 36. Flow (ID: 116)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 300인 이하 / Business: 6,000원/월',
  features = ARRAY['프로젝트 관리', '실시간 메신저', '화상회의', '파일 공유', '간트차트'],
  comparison_data = '{"cons": ["초보자에게는 매우 어려움", "기업 계정 필요"], "pros": ["MS 오피스(엑셀, 팀즈)와 강력한 연동", "복잡한 비즈니스 로직 자동화", "보안성 우수"], "radar_chart": {"community": 3.5, "automation": 5, "ease_of_use": 3, "performance": 4.4, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["Microsoft 365"], "summary_text": "엑셀, 이메일, 팀즈를 연결해서 반복 업무를 버튼 하나로 끝내게 해줍니다.", "target_users": ["사무직 직장인", "ERP 관리자"], "performance_score": 4.4, "korean_support_score": 4.5, "learning_curve_score": 3, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Flow%' OR name LIKE 'Microsoft Power Automate%';

-- 37. MyMap.ai (ID: 117)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 5 Credits / Pro: 유료',
  features = ARRAY['마인드맵 생성', '순서도 제작', '시간 계획', '웹 검색 연동', 'AI 대화'],
  comparison_data = '{"cons": ["복잡한 기능은 부족", "무료 크레딧 제한"], "pros": ["채팅만 하면 깔끔한 마인드맵 생성", "아이디어 구조화에 최적", "비주얼 싱킹 도구"], "radar_chart": {"community": 3, "automation": 4.5, "ease_of_use": 5, "performance": 4.2, "korean_quality": 4, "value_for_money": 4.5}, "integrations": ["Web"], "summary_text": "복잡한 생각이나 아이디어를 AI가 순식간에 깔끔한 지도(Map)로 그려줍니다.", "target_users": ["기획자", "학생(개념 정리)", "브레인스토밍"], "performance_score": 4.2, "korean_support_score": 4, "learning_curve_score": 5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'MyMap.ai%';

-- 38. Whimsical (ID: 118)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 3 Boards / Pro: $10/월',
  features = ARRAY['플로우차트', '와이어프레임', '마인드맵', '칸반보드', '협업'],
  comparison_data = '{"cons": ["AI 기능은 보조적인 역할", "한글 폰트 아쉬움"], "pros": ["AI로 마인드맵/플로우차트 자동 생성", "매우직관적이고 예쁜 UI", "협업 기능 강력"], "radar_chart": {"community": 3.5, "automation": 4, "ease_of_use": 5, "performance": 4.3, "korean_quality": 4, "value_for_money": 4.5}, "integrations": ["Web", "Figma"], "summary_text": "기획서나 프로세스 흐름도를 그릴 때, AI가 초안을 잡아주어 시간을 아껴줍니다.", "target_users": ["PM/PO", "UX 디자이너", "기획자"], "performance_score": 4.3, "korean_support_score": 4, "learning_curve_score": 5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Whimsical%';

-- 39. Naver CLOVA X (ID: 119 - Duplicate check? Use name)
UPDATE public.ai_models
SET 
  pricing_info = 'Beta: 무료',
  features = ARRAY['대화형 AI', '실시간 정보 검색', '네이버 서비스 연동', '쇼핑/예약'],
  comparison_data = '{"cons": ["코딩이나 영어 능력은 GPT 대비 약함", "대화 턴 수 제한"], "pros": ["한국 문화/최신 트렌드 완벽 이해", "네이버 쇼핑/주식 등 실시간 정보 연동", "가장 한국적인 답변"], "radar_chart": {"community": 3.5, "automation": 4, "ease_of_use": 4.5, "performance": 4.5, "korean_quality": 5, "value_for_money": 4.8}, "integrations": ["Naver"], "summary_text": "한국 맛집, 뉴스, 쇼핑 정보는 CLOVA X가 가장 정확하고 빠르게 알려줍니다.", "target_users": ["한국인 사용자", "쇼핑/정보 검색", "블로거"], "performance_score": 4.5, "korean_support_score": 5, "learning_curve_score": 4.5, "cost_efficiency_score": 4.8}'::jsonb
WHERE name LIKE 'Naver CLOVA X%' OR name = 'CLOVA X';

-- 40. UPDF AI (ID: 120)
UPDATE public.ai_models
SET 
  pricing_info = 'Free: 제한 / Pro: 45,900원/년',
  features = ARRAY['PDF 편집', 'AI 요약', 'AI 채팅', '번역', '주석', '변환'],
  comparison_data = '{"cons": ["전문적인 AI 엔진보다는 성능 낮음", "설치형 프로그램"], "pros": ["PDF 편집 프로그램 내장 AI", "문서 요약/번역/설명 올인원", "가성비 좋음"], "radar_chart": {"community": 2.5, "automation": 3.5, "ease_of_use": 5, "performance": 4.1, "korean_quality": 5, "value_for_money": 4.5}, "integrations": ["Win/Mac App"], "summary_text": "PDF를 보면서 바로 요약하고 수정까지 할 수 있는 가성비 좋은 문서 도구입니다.", "target_users": ["사무직", "대학생"], "performance_score": 4.1, "korean_support_score": 5, "learning_curve_score": 5, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'UPDF AI%';

-- 41. Cursor (ID: 121)
UPDATE public.ai_models
SET 
  pricing_info = 'Hobby: Free / Pro: $20/월 / Business: $40/월',
  features = ARRAY['AI 자동완성', '리팩터링 및 테스트 생성', '코드 리뷰·PR 초안', '에이전트 실행', '레포지토리·터미널 작업', '대화형 편집'],
  comparison_data = '{"cons": ["유료 구독(Pro) 필수적", "일부 확장 프로그램 호환성 이슈"], "pros": ["VS Code 포크로 적응 쉬움", "프로젝트 전체 코드베이스 이해", "터미널 에러 수정 탁월"], "radar_chart": {"community": 4.5, "automation": 5, "ease_of_use": 4.2, "performance": 4.9, "korean_quality": 4.5, "value_for_money": 4.5}, "integrations": ["VS Code Extension 호환"], "summary_text": "현재 가장 핫한 AI 코드 에디터. 단순 생성을 넘어 프로젝트 전체를 이해하고 코딩합니다.", "target_users": ["풀스택 개발자", "코딩 입문자"], "performance_score": 4.9, "korean_support_score": 4.5, "learning_curve_score": 4.2, "cost_efficiency_score": 4.5}'::jsonb
WHERE name LIKE 'Cursor%';
