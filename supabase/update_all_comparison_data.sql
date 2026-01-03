-- AI 도구별 Comparison Data 일괄 업데이트 스크립트

-- 1. Wrtn (뤼튼)
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.6,
  "cost_efficiency_score": 5.0,
  "korean_support_score": 5.0,
  "learning_curve_score": 4.8,
  "radar_chart": {
    "performance": 4.6,
    "community": 4.0,
    "value_for_money": 5.0,
    "korean_quality": 5.0,
    "ease_of_use": 4.8,
    "automation": 3.0
  },
  "pros": [
    "GPT-4 등 최신 모델 무료 제공",
    "한국어에 특화된 자연스러운 생성",
    "카카오톡 등 쉬운 접근성"
  ],
  "cons": [
    "전문적인 코딩 능력은 다소 부족",
    "복잡한 추론 시 속도 저하"
  ],
  "target_users": [
    "대학생",
    "일반인",
    "마케터"
  ],
  "security_features": [
    "개인정보 보호 필터링",
    "국내 보안 규정 준수"
  ],
  "integrations": [
    "Web",
    "App",
    "KakaoTalk"
  ],
  "summary_text": "무료로 강력한 AI 모델을 사용하고 싶다면 최고의 선택입니다. 한국어 작문에 강점이 있습니다."
}'::jsonb
WHERE name LIKE 'Wrtn%';

-- 2. Naver CLOVA X
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.4,
  "cost_efficiency_score": 4.8,
  "korean_support_score": 5.0,
  "learning_curve_score": 4.5,
  "radar_chart": {
    "performance": 4.4,
    "community": 3.5,
    "value_for_money": 4.8,
    "korean_quality": 5.0,
    "ease_of_use": 4.5,
    "automation": 4.0
  },
  "pros": [
    "가장 뛰어난 한국어/한국 문화 이해도",
    "네이버 서비스(쇼핑, 여행) 연동",
    "최신 한국 뉴스 반영"
  ],
  "cons": [
    "영어 및 코딩 능력은 GPT 대비 부족",
    "대화 턴 수 제한"
  ],
  "target_users": [
    "쇼핑/여행 검색 사용자",
    "블로거",
    "주부/직장인"
  ],
  "security_features": [
    "네이버 보안 인프라",
    "엄격한 데이터 관리"
  ],
  "integrations": [
    "네이버 검색",
    "네이버 쇼핑",
    "네이버 여행"
  ],
  "summary_text": "한국적인 맥락과 최신 정보가 필요할 때 가장 유용합니다. 네이버 생태계와 강력하게 연결됩니다."
}'::jsonb
WHERE name LIKE 'Naver CLOVA X%';

-- 3. Grammarly
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.7,
  "cost_efficiency_score": 3.5,
  "korean_support_score": 0,
  "learning_curve_score": 4.9,
  "radar_chart": {
    "performance": 4.7,
    "community": 4.0,
    "value_for_money": 3.5,
    "korean_quality": 0,
    "ease_of_use": 4.9,
    "automation": 4.5
  },
  "pros": [
    "업계 표준 수준의 영어 교정",
    "다양한 플랫폼(Word, Chrome 등) 지원",
    "톤 앤 매너 제안 기능"
  ],
  "cons": [
    "한국어 미지원",
    "유료 버전이 다소 비쌈"
  ],
  "target_users": [
    "유학생",
    "비즈니스 영어 사용자",
    "논문 작성자"
  ],
  "security_features": [
    "SOC 2 인증",
    "엔터프라이즈 보안"
  ],
  "integrations": [
    "MS Office",
    "Google Docs",
    "Browser Extension"
  ],
  "summary_text": "영어 글쓰기의 필수 동반자입니다. 문법 교정을 넘어 더 세련된 문장을 만들어줍니다."
}'::jsonb
WHERE name LIKE 'Grammarly%';

-- 4. Notion AI
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.3,
  "cost_efficiency_score": 4.0,
  "korean_support_score": 4.5,
  "learning_curve_score": 4.2,
  "radar_chart": {
    "performance": 4.3,
    "community": 4.5,
    "value_for_money": 4.0,
    "korean_quality": 4.5,
    "ease_of_use": 4.2,
    "automation": 3.0
  },
  "pros": [
    "노션 내에서 바로 사용 가능 (워크플로우 단축)",
    "문서 요약 및 번역에 탁월",
    "데이터 정리 및 표 생성 용이"
  ],
  "cons": [
    "별도 구독 필요 ($10/월)",
    "전문적인 창작/추론 능력은 GPT-4보다 낮음"
  ],
  "target_users": [
    "노션 헤비 유저",
    "PM/기획자",
    "대학생"
  ],
  "security_features": [
    "노션 데이터 정책 준수",
    "HTTPS 암호화"
  ],
  "integrations": [
    "Notion Pages",
    "Notion Databases"
  ],
  "summary_text": "노션을 이미 쓰고 있다면 생산성을 배로 늘려주는 최고의 애드온입니다."
}'::jsonb
WHERE name LIKE 'Notion AI%';

-- 5. Midjourney
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.9,
  "cost_efficiency_score": 3.0,
  "korean_support_score": 2.0,
  "learning_curve_score": 2.5,
  "radar_chart": {
    "performance": 4.9,
    "community": 5.0,
    "value_for_money": 3.0,
    "korean_quality": 2.0,
    "ease_of_use": 2.5,
    "automation": 2.0
  },
  "pros": [
    "압도적인 예술적 퀄리티",
    "활발한 커뮤니티와 프롬프트 공유",
    "독창적인 스타일 구현"
  ],
  "cons": [
    "Discord를 통해서만 사용 가능 (사용성 낮음)",
    "월 구독 필수 (무료 없음)",
    "원하는 구도 정밀 제어가 어려움"
  ],
  "target_users": [
    "디자이너",
    "아티스트",
    "콘텐츠 크리에이터"
  ],
  "security_features": [
    "NSFW 필터",
    "개인정보 블러 처리"
  ],
  "integrations": [
    "Discord"
  ],
  "summary_text": "가장 아름답고 예술적인 이미지를 원한다면 대체 불가한 1순위 도구입니다."
}'::jsonb
WHERE name LIKE 'Midjourney%';

-- 6. GitHub Copilot
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.8,
  "cost_efficiency_score": 4.5,
  "korean_support_score": 4.0,
  "learning_curve_score": 4.5,
  "radar_chart": {
    "performance": 4.8,
    "community": 5.0,
    "value_for_money": 4.5,
    "korean_quality": 4.0,
    "ease_of_use": 4.5,
    "automation": 5.0
  },
  "pros": [
    "IDE와 완벽한 통합 (VS Code 등)",
    "압도적인 코드 자동완성 생산성",
    "학생 무료 지원"
  ],
  "cons": [
    "전체 프로젝트 구조 파악은 아직 미흡",
    "기업용은 유료"
  ],
  "target_users": [
    "개발자",
    "컴퓨터공학 전공생",
    "데이터 사이언티스트"
  ],
  "security_features": [
    "코드 스니펫 비매칭 옵션",
    "엔터프라이즈 보안"
  ],
  "integrations": [
    "VS Code",
    "JetBrains",
    "Visual Studio"
  ],
  "summary_text": "개발자라면 선택이 아닌 필수. 코딩 속도와 즐거움을 동시에 높여줍니다."
}'::jsonb
WHERE name LIKE 'GitHub Copilot%';

-- 7. DeepL (업데이트 확인용)
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.8,
  "cost_efficiency_score": 4.5,
  "korean_support_score": 4.9,
  "learning_curve_score": 4.8,
  "radar_chart": {
    "performance": 4.8,
    "community": 3.5,
    "value_for_money": 4.5,
    "korean_quality": 4.9,
    "ease_of_use": 4.8,
    "automation": 3.5
  },
  "pros": [
    "자연스러운 뉘앙스 번역 최고봉",
    "문서 파일 통번역 지원",
    "Pro 버전 API 지원"
  ],
  "cons": [
    "무료 버전 글자제한",
    "번역 외 기능 없음"
  ],
  "target_users": [
    "전문 번역가",
    "비즈니스맨",
    "연구자"
  ],
  "security_features": [
    "데이터 암호화 (Pro)",
    "즉시 삭제 정책 (Pro)"
  ],
  "integrations": [
    "Chrome Extension",
    "Desktop App"
  ],
  "summary_text": "파파고보다 더 자연스러운, 뉘앙스를 살리는 번역이 필요할 때 최고의 솔루션입니다."
}'::jsonb
WHERE name LIKE 'DeepL%';

-- 8. Vrew
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.2,
  "cost_efficiency_score": 5.0,
  "korean_support_score": 5.0,
  "learning_curve_score": 4.7,
  "radar_chart": {
    "performance": 4.2,
    "community": 3.0,
    "value_for_money": 5.0,
    "korean_quality": 5.0,
    "ease_of_use": 4.7,
    "automation": 4.5
  },
  "pros": [
    "문서 편집하듯 쉬운 컷 편집",
    "음성 인식 자동 자막 생성 최고",
    "무료 기능이 매우 강력함"
  ],
  "cons": [
    "전문적인 영상 효과에는 한계",
    "고사양 영상 처리 시 무거움"
  ],
  "target_users": [
    "유튜버",
    "강사",
    "숏폼 크리에이터"
  ],
  "security_features": [
    "로컬 프로젝트 저장 지원"
  ],
  "integrations": [
    "YouTube 업로드",
    "Premiere Pro 내보내기"
  ],
  "summary_text": "자막 노가다에서 해방되고 싶다면 무조건 써야 할 영상 편집 도구입니다."
}'::jsonb
WHERE name LIKE 'Vrew%';

-- 9. Gamma
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.3,
  "cost_efficiency_score": 4.5,
  "korean_support_score": 4.5,
  "learning_curve_score": 4.8,
  "radar_chart": {
    "performance": 4.3,
    "community": 3.0,
    "value_for_money": 4.5,
    "korean_quality": 4.5,
    "ease_of_use": 4.8,
    "automation": 4.8
  },
  "pros": [
    "PPT 초안 작성 속도 혁명적으로 단축",
    "깔끔하고 세련된 디자인 자동 적용",
    "웹 게시 용이"
  ],
  "cons": [
    "디테일한 레이아웃 수정이 어려움",
    "한국어 폰트 다양성 부족"
  ],
  "target_users": [
    "직장인",
    "대학생",
    "영업직"
  ],
  "security_features": [
    "문서 비공개 설정"
  ],
  "integrations": [
    "PowerPoint Export",
    "PDF Export"
  ],
  "summary_text": "발표 자료 만들 시간이 없다면 Gamma가 1분 만에 초안을 완성해줍니다."
}'::jsonb
WHERE name LIKE 'Gamma%';

-- 10. Naver CLOVA Note
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.6,
  "cost_efficiency_score": 5.0,
  "korean_support_score": 5.0,
  "learning_curve_score": 4.9,
  "radar_chart": {
    "performance": 4.6,
    "community": 3.0,
    "value_for_money": 5.0,
    "korean_quality": 5.0,
    "ease_of_use": 4.9,
    "automation": 4.5
  },
  "pros": [
    "독보적인 한국어 음성 인식률",
    "화자 분리 기능 탁월",
    "핵심 요약 기능 제공"
  ],
  "cons": [
    "월 사용량 시간 제한",
    "녹음 파일 보안 이슈(민감 정보)"
  ],
  "target_users": [
    "대학생 (강의)",
    "기자",
    "회의가 많은 직장인"
  ],
  "security_features": [
    "개인정보 비식별화 처리 노력을 함"
  ],
  "integrations": [
    "Zoom 연동"
  ],
  "summary_text": "강의와 회의 기록의 필수품. 한국어 음성 기록에 있어서는 대체제가 없습니다."
}'::jsonb
WHERE name LIKE 'Naver CLOVA Note%';
