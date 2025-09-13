-- AI 도구 종합 데이터 업데이트 마이그레이션
-- 대학생 특화 AI 도구 정보로 업데이트

-- 1. 기존 데이터 정리
DELETE FROM public.ratings;
DELETE FROM public.ai_models;

-- 2. 카테고리 업데이트
DELETE FROM public.categories;
INSERT INTO public.categories (name, description) VALUES
('대화형 AI', '질문 답변, 텍스트 생성, 요약, 번역 등 대화형 AI 도구'),
('글쓰기 & 교정', '문법 교정, 패러프레이징, 표절 검사 등 글쓰기 도구'),
('노트 & 협업', '노트 작성, 협업, 프로젝트 관리 도구'),
('발표 & 디자인', 'PPT 제작, 디자인, 프레젠테이션 도구'),
('이미지 & 영상 생성', 'AI 이미지/영상 생성 및 편집 도구'),
('영상 편집 & 음성', '영상 편집, 자막 생성, 음성 변환 도구'),
('연구 & 학습', '논문 분석, 번역, 학습 도구'),
('외국어 학습', '언어 학습, 발음 교정 도구'),
('개발 & 코딩', '코딩, 프로그래밍, 개발 도구'),
('취업 준비', '자소서, 면접, 취업 준비 도구'),
('국내 특화 AI', '한국어 특화, 국내 서비스 AI 도구')
ON CONFLICT (name) DO NOTHING;

-- 3. AI 도구 데이터 추가
INSERT INTO public.ai_models (
  name, 
  description, 
  provider, 
  model_type, 
  pricing_info, 
  features, 
  use_cases, 
  limitations, 
  website_url, 
  api_documentation_url, 
  average_rating, 
  rating_count,
  logo_url
) VALUES
-- 대화형 AI
(
  'ChatGPT',
  'OpenAI의 대화형 AI 모델로 질문 답변, 텍스트 생성, 요약, 번역, 코딩 등 다양한 작업을 수행할 수 있습니다.',
  'OpenAI',
  '대화형 AI',
  '무료(GPT-3.5) / 유료 Plus(월 $20, GPT-4o 최신 모델)',
  ARRAY['질문 답변', '텍스트 생성', '요약', '번역', '코딩', '브레인스토밍'],
  ARRAY['과제/리포트 작성', '아이디어 브레인스토밍', '발표 스크립트 작성', '코드 스니펫 생성', '개념 설명'],
  ARRAY['2021년 이후 정보 부족', '실시간 정보 접근 제한', '개인정보 보호 필요'],
  'https://chat.openai.com',
  'https://platform.openai.com/docs',
  4.8,
  1250,
  'https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg'
),
(
  'Wrtn (뤼튼)',
  '한국어 특화 생성형 AI로 자소서, 블로그, 보고서 템플릿과 AI 검색 기능을 제공합니다.',
  'Wrtn Technologies',
  '대화형 AI',
  '무료(GPT-4 등 최신 모델 포함 대부분 기능)',
  ARRAY['한국어 특화', '자소서 템플릿', '블로그 작성', '보고서 템플릿', 'AI 검색', '영어 회화 연습'],
  ARRAY['자소서/취업 준비', '한국형 리포트 작성', '감상문 글쓰기', '영어 회화 연습'],
  ARRAY['한국어 특화로 영어 작업 제한', '신규 서비스로 기능 제한'],
  'https://wrtn.ai',
  'https://help.wrtn.ai',
  4.6,
  890,
  'https://wrtn.ai/favicon.ico'
),
(
  'Naver CLOVA X',
  '네이버의 대화형 AI로 최신 정보 검색과 네이버 서비스 연동 기능을 제공합니다.',
  'NAVER',
  '대화형 AI',
  '무료(네이버 계정 로그인)',
  ARRAY['최신 정보 검색', '네이버 서비스 연동', '한국어 특화', '국내 정보'],
  ARRAY['국내 자료 조사', '한국 관련 최신 뉴스/정책/트렌드', '팀플 장소 예약', '맛집 검색'],
  ARRAY['네이버 계정 필요', '국내 정보에 특화'],
  'https://clova.naver.com',
  'https://developers.naver.com/docs/clova',
  4.4,
  650,
  'https://clova.naver.com/favicon.ico'
),

-- 글쓰기 & 교정
(
  'Grammarly',
  'AI 기반 영문법, 철자, 구두점 교정 및 스타일 제안을 제공하는 글쓰기 도구입니다.',
  'Grammarly, Inc.',
  '글쓰기 & 교정',
  '무료(기본 교정) / Premium(월 $12~, 고급 기능)',
  ARRAY['영문법 교정', '철자 검사', '구두점 교정', '스타일 제안', '학술적 글쓰기'],
  ARRAY['영어 과제 작성', '영문 에세이 교정', '영문 이력서 작성', '영어 논문 작성'],
  ARRAY['영어에만 특화', '고급 기능은 유료', '학습 곡선 존재'],
  'https://www.grammarly.com',
  'https://developers.grammarly.com',
  4.5,
  1200,
  'https://static.grammarly.com/assets/files/grammarly_logo.png'
),
(
  'QuillBot',
  'AI 기반 영문 패러프레이징, 문법 검사, 요약, 인용 생성을 제공하는 글쓰기 도구입니다.',
  'Learneo, Inc.',
  '글쓰기 & 교정',
  '무료(제한 기능) / Premium(월 $8.33~, 무제한 기능)',
  ARRAY['패러프레이징', '문법 검사', '요약', '인용 생성', '다양한 영어 표현'],
  ARRAY['리포트/논문 작성', '표절률 감소', '영어 표현 학습', '영어 아티클 요약'],
  ARRAY['무료 버전 제한', '영어에만 특화'],
  'https://quillbot.com',
  'https://docs.quillbot.com',
  4.3,
  800,
  'https://quillbot.com/favicon.ico'
),
(
  'CopyKiller (카피킬러)',
  '국내 최다 데이터 기반 표절 검사와 AI 글 탐지 기능을 제공하는 표절 검사 도구입니다.',
  '(주)무하유',
  '글쓰기 & 교정',
  '무료(체험판) / 유료(건당/기간제 구매)',
  ARRAY['표절 검사', 'AI 글 탐지', '참고문헌 인용', 'GPT 킬러 기능'],
  ARRAY['리포트 제출 전 검사', '졸업논문 표절 검사', '참고문헌 인용 확인'],
  ARRAY['유료 서비스', '한국어 특화'],
  'https://www.copykiller.co.kr',
  'https://www.copykiller.co.kr/guide',
  4.2,
  450,
  'https://www.copykiller.co.kr/favicon.ico'
),

-- 노트 & 협업
(
  'Notion AI',
  'Notion에 내장된 AI로 페이지 요약, 글 작성, 브레인스토밍, 번역 기능을 제공합니다.',
  'Notion Labs, Inc.',
  '노트 & 협업',
  '무료(제한) / Business Plan(월 $20~, 학생/교육자 Plus 플랜 무료)',
  ARRAY['페이지 요약', '글 작성', '브레인스토밍', '번역', 'Notion 통합'],
  ARRAY['팀플/협업', '회의록 자동 요약', '강의 노트 정리', '팀 지식 베이스 구축'],
  ARRAY['Notion 구독 필요', '학습 곡선', '제한된 무료 사용량'],
  'https://www.notion.so/product/ai',
  'https://developers.notion.com',
  4.4,
  900,
  'https://upload.wikimedia.org/wikipedia/commons/4/45/Notion_app_logo.png'
),

-- 발표 & 디자인
(
  'Gamma',
  '프롬프트로 발표 자료, 문서, 웹페이지를 자동 생성하는 AI 프레젠테이션 도구입니다.',
  'Gamma App',
  '발표 & 디자인',
  '무료(400 크레딧) / Plus(월 $8~, 무제한 생성)',
  ARRAY['PPT 자동 생성', '웹페이지 생성', '문서 생성', '템플릿 제공'],
  ARRAY['PPT 제작', '포트폴리오 제작', '프로젝트 결과물 공유'],
  ARRAY['크레딧 제한', '고급 기능은 유료'],
  'https://gamma.app',
  'https://gamma.app/docs',
  4.3,
  600,
  'https://gamma.app/favicon.ico'
),
(
  'Canva',
  '방대한 템플릿 기반 온라인 디자인 도구로 AI Magic Studio 기능을 제공합니다.',
  'Canva',
  '발표 & 디자인',
  '무료(대부분 핵심 기능) / Pro(월 $12.99~, 프리미엄 기능)',
  ARRAY['템플릿 기반 디자인', 'AI Magic Studio', '영상 편집', '자동 자막', '배경음악'],
  ARRAY['공모전 포스터', '동아리 홍보물', '카드뉴스', 'PPT 템플릿', '영상 편집'],
  ARRAY['고급 기능은 유료', '인터넷 연결 필요'],
  'https://www.canva.com',
  'https://www.canva.com/developers',
  4.6,
  1500,
  'https://static.canva.com/web/images/favicon.ico'
),
(
  'Tome',
  '스토리텔링 특화 AI 프레젠테이션 생성기로 논리적 흐름의 발표 자료를 만듭니다.',
  'Magical Tome, Inc.',
  '발표 & 디자인',
  '무료(500 크레딧) / Pro(월 $16~, 무제한 기능)',
  ARRAY['스토리텔링 프레젠테이션', '논리적 흐름', '시각화', '기획안 제작'],
  ARRAY['발표 자료 제작', '창업 아이템 기획', '프로젝트 제안서', '스토리텔링 발표'],
  ARRAY['크레딧 제한', '고급 기능은 유료'],
  'https://tome.app',
  'https://tome.app/docs',
  4.2,
  400,
  'https://tome.app/favicon.ico'
),

-- 이미지 & 영상 생성
(
  'Midjourney',
  'Discord 기반 고품질 예술적 이미지 생성 AI로 독창적인 이미지를 만들 수 있습니다.',
  'Midjourney, Inc.',
  '이미지 & 영상 생성',
  '유료 전용(월 $10~ Basic Plan, 생성량별 요금제)',
  ARRAY['고품질 이미지 생성', '예술적 스타일', 'Discord 기반', '다양한 스타일'],
  ARRAY['PPT/디자인용 이미지', '창작 활동', '디자인 과제', '공모전용 아트'],
  ARRAY['Discord에서만 사용', '학습 곡선 존재', '저작권 이슈 가능성', '유료 전용'],
  'https://www.midjourney.com',
  'https://docs.midjourney.com',
  4.9,
  1200,
  'https://upload.wikimedia.org/wikipedia/commons/4/4a/Midjourney_Emblem.png'
),
(
  'Stable Diffusion',
  '오픈소스 이미지 생성 AI로 사용자 모델 미세조정이 가능합니다.',
  'Stability AI',
  '이미지 & 영상 생성',
  '무료(오픈소스, 개인 PC 설치) / 유료(DreamStudio 크레딧 기반)',
  ARRAY['오픈소스', '모델 미세조정', '로컬 실행', '다양한 모델'],
  ARRAY['UI/UX 시안', '제품 목업', '건축 시각화', '데이터 시각화', '연구용 이미지'],
  ARRAY['고사양 하드웨어 필요', '학습 곡선', '설치 복잡성'],
  'https://stablediffusionweb.com',
  'https://github.com/Stability-AI/stablediffusion',
  4.4,
  800,
  'https://stablediffusionweb.com/favicon.ico'
),

-- 영상 편집 & 음성
(
  'Vrew',
  'AI 자동 자막 생성, 텍스트 기반 영상 편집, AI 목소리 더빙 기능을 제공합니다.',
  'VoyagerX',
  '영상 편집 & 음성',
  '무료(월 120분 음성 분석) / Light(연 $104.99~)',
  ARRAY['자동 자막 생성', '텍스트 기반 편집', 'AI 목소리 더빙', '음성-텍스트 변환'],
  ARRAY['강의록 정리', '발표 영상 제작', '숏폼 과제', '외국어 학습'],
  ARRAY['월 사용량 제한', '고급 기능은 유료'],
  'https://vrew.voyagerx.ai',
  'https://vrew.voyagerx.ai/docs',
  4.3,
  500,
  'https://vrew.voyagerx.ai/favicon.ico'
),
(
  'Runway',
  '텍스트/이미지로 영상 생성하고 전문적인 AI 영상 편집 기능을 제공합니다.',
  'Runway AI, Inc.',
  '영상 편집 & 음성',
  '무료(125 크레딧, 워터마크) / Standard(월 $12~)',
  ARRAY['텍스트-영상 생성', '이미지-영상 생성', '전문 영상 편집', '객체 제거', '배경 교체'],
  ARRAY['공모전용 영상', '시각 효과 제작', '인트로 영상', '미디어 과제'],
  ARRAY['크레딧 제한', '고급 기능은 유료', '고사양 하드웨어 필요'],
  'https://runwayml.com',
  'https://runwayml.com/docs',
  4.2,
  400,
  'https://runwayml.com/static/images/runway-logo.png'
),

-- 연구 & 학습
(
  'Liner',
  'AI 리서치 엔진으로 웹페이지/PDF/유튜브 하이라이트와 신뢰성 기반 답변을 제공합니다.',
  '(주)라이너',
  '연구 & 학습',
  '무료(기본 기능) / Pro(월 $11.67~, 무제한 하이라이트)',
  ARRAY['AI 리서치', '웹페이지 하이라이트', 'PDF 분석', '유튜브 하이라이트', '신뢰성 기반 답변'],
  ARRAY['논문/리포트 작성', '영어 논문 한국어 요약', '학술 자료 검색', '과제 신뢰도 향상'],
  ARRAY['무료 버전 제한', '한국어 지원 제한'],
  'https://liner.ai',
  'https://liner.ai/docs',
  4.1,
  300,
  'https://liner.ai/favicon.ico'
),
(
  'ChatPDF',
  'PDF 업로드 후 문서 내용과 AI 채팅할 수 있는 PDF 분석 도구입니다.',
  'ChatPDF',
  '연구 & 학습',
  '무료(하루 2개 파일, 120페이지 제한) / Plus(월 $5~)',
  ARRAY['PDF 업로드', 'AI 채팅', '문서 분석', '핵심 정보 파악'],
  ARRAY['원서/논문 분석', '전공 교재 이해', '리포트 참고 자료 분석'],
  ARRAY['일일 사용량 제한', '페이지 수 제한'],
  'https://www.chatpdf.com',
  'https://www.chatpdf.com/docs',
  4.0,
  250,
  'https://www.chatpdf.com/favicon.ico'
),
(
  'DeepL',
  '신경망 기반 고품질 번역기로 학술적 뉘앙스를 보존한 정확한 번역을 제공합니다.',
  'DeepL SE',
  '연구 & 학습',
  '무료(제한) / Pro(월 $8.74~, 무제한 번역)',
  ARRAY['고품질 번역', '학술적 뉘앙스 보존', '다국어 지원', 'DeepL Write'],
  ARRAY['해외 자료 리서치', '영문 과제 작성', '전문 텍스트 번역'],
  ARRAY['무료 버전 제한', '인터넷 연결 필요'],
  'https://www.deepl.com',
  'https://www.deepl.com/docs-api',
  4.7,
  1000,
  'https://www.deepl.com/favicon.ico'
),

-- 외국어 학습
(
  'Speak (스픽)',
  'AI 음성인식 영어 스피킹 훈련과 실전 회화 연습을 제공하는 언어 학습 도구입니다.',
  'Speakeasy Labs',
  '외국어 학습',
  '유료 전용(연 129,000원~, 7일 무료 체험)',
  ARRAY['AI 음성인식', '스피킹 훈련', '실전 회화', '발음 교정'],
  ARRAY['교환학생 준비', '어학연수 준비', '영어 발표/면접', '말하기 울렁증 극복'],
  ARRAY['유료 전용', '영어에만 특화'],
  'https://www.speak.com',
  'https://www.speak.com/docs',
  4.5,
  600,
  'https://www.speak.com/favicon.ico'
),
(
  'ELSA Speak',
  '발음 교정 특화 AI 영어 학습 도구로 원어민과 비교 분석을 제공합니다.',
  'ELSA, Corp.',
  '외국어 학습',
  '무료(제한) / Pro(월 $11.99~ 또는 연 $74.99~)',
  ARRAY['발음 교정', '원어민 비교', '한국인 취약 발음', '발표 연습'],
  ARRAY['발음 교정', '영어 발표 연습', '자신감 있는 전달'],
  ARRAY['무료 버전 제한', '영어에만 특화'],
  'https://elsaspeak.com',
  'https://elsaspeak.com/docs',
  4.3,
  500,
  'https://elsaspeak.com/favicon.ico'
),

-- 개발 & 코딩
(
  'GitHub Copilot',
  'IDE 통합 AI 페어 프로그래머로 코드 자동 완성과 함수 생성을 제공합니다.',
  'GitHub (Microsoft)',
  '개발 & 코딩',
  '유료 Pro(월 $10), 학생은 GitHub Student Developer Pack으로 무료',
  ARRAY['코드 자동 완성', '함수 생성', 'IDE 통합', '다국어 지원', '컨텍스트 이해'],
  ARRAY['코딩 과제/프로젝트', '새 라이브러리 학습', '알고리즘 공부', '개발 시간 단축'],
  ARRAY['인터넷 연결 필요', '개인정보 보호 우려', '학습 데이터 의존성'],
  'https://github.com/features/copilot',
  'https://docs.github.com/en/copilot',
  4.7,
  2000,
  'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'
),
(
  'Replit',
  '브라우저 기반 온라인 IDE로 AI 앱 생성과 코드 디버깅 기능을 제공합니다.',
  'Replit, Inc.',
  '개발 & 코딩',
  '무료 Starter(공개 프로젝트) / Core(월 $20~, 비공개, 강력한 AI)',
  ARRAY['온라인 IDE', 'AI 앱 생성', '코드 디버깅', '실시간 협업', '다양한 언어 지원'],
  ARRAY['코딩 입문', '팀 프로젝트', '웹앱 프로토타입', '프로그램 설치 없이 학습'],
  ARRAY['인터넷 연결 필요', '고급 기능은 유료'],
  'https://replit.com',
  'https://docs.replit.com',
  4.4,
  800,
  'https://replit.com/favicon.ico'
),

-- 취업 준비
(
  'Haijob (하이잡)',
  '자소서 기반 AI 면접 예상 질문, 영상 모의 면접, AI 피드백을 제공하는 취업 준비 도구입니다.',
  '(주)포지큐브',
  '취업 준비',
  '무료(체험권) / 유료(이용권 구매)',
  ARRAY['자소서 기반 면접 질문', '영상 모의 면접', 'AI 피드백', '시선/목소리 분석'],
  ARRAY['AI/영상 면접 연습', '직무 면접 대비', '자소서 기반 꼬리 질문', '압박 질문 대비'],
  ARRAY['유료 서비스', '한국어 특화'],
  'https://haijob.co.kr',
  'https://haijob.co.kr/guide',
  4.2,
  300,
  'https://haijob.co.kr/favicon.ico'
),
(
  'inFACE',
  '10만+ 합격 자소서 빅데이터를 활용한 자소서 작성/평가/첨삭과 AI 모의면접을 제공합니다.',
  '(주)에듀스',
  '취업 준비',
  '유료(대학 제휴시 재학생/졸업생 무료 가능, 개별 구매 가능)',
  ARRAY['자소서 작성/평가/첨삭', '합격 자소서 빅데이터', 'AI 모의면접', 'AI 역량검사'],
  ARRAY['자소서 첨삭', 'AI 역량검사 대비', '주제 적합성 분석', '역량 부합도 분석'],
  ARRAY['유료 서비스', '대학 제휴 필요'],
  'https://www.inface.co.kr',
  'https://www.inface.co.kr/guide',
  4.1,
  250,
  'https://www.inface.co.kr/favicon.ico'
),

-- 국내 특화 AI
(
  'Naver CLOVA Note',
  'AI 음성인식 기반 녹음/텍스트 변환과 핵심 내용 요약 기능을 제공합니다.',
  'NAVER',
  '국내 특화 AI',
  '무료(월 600분 변환)',
  ARRAY['음성-텍스트 변환', '핵심 내용 요약', '한국어 특화', '녹음 기능'],
  ARRAY['강의 복습', '팀플 회의록', '장시간 강의 녹음', '키워드 검색'],
  ARRAY['월 사용량 제한', '한국어 특화'],
  'https://clova.naver.com/note',
  'https://developers.naver.com/docs/clova',
  4.3,
  400,
  'https://clova.naver.com/favicon.ico'
),
(
  'UPDF AI',
  'PDF 통합 관리 프로그램으로 AI 내용 요약/설명/번역/채팅 기능을 제공합니다.',
  'Superace Software',
  '국내 특화 AI',
  '무료(제한 기능) / 유료(연 45,900원~, AI 기능 포함)',
  ARRAY['PDF 관리', 'AI 요약/설명', '번역', '채팅', '한국어 특화'],
  ARRAY['전공 교재 PDF 분석', '리포트 참고 자료', '어려운 개념 설명', 'PDF 기반 질문'],
  ARRAY['고급 기능은 유료', '한국어 특화'],
  'https://updf.ai',
  'https://updf.ai/docs',
  4.0,
  200,
  'https://updf.ai/favicon.ico'
);

-- 4. 샘플 평점 데이터 추가
INSERT INTO public.ratings (user_id, ai_model_id, rating, review) VALUES
-- ChatGPT 리뷰들
('00000000-0000-0000-0000-000000000001', 1, 5, '과제 작성에 정말 도움이 됩니다. 복잡한 개념을 쉽게 설명해주고, 리포트 개요도 잘 만들어줘요.'),
('00000000-0000-0000-0000-000000000002', 1, 4, '코딩 도움을 받을 때 정말 유용하지만, 때로는 부정확한 코드를 제안하기도 합니다.'),
('00000000-0000-0000-0000-000000000003', 1, 5, '팀플 아이디어 브레인스토밍에 최고입니다. 창의적인 아이디어를 많이 얻을 수 있어요.'),

-- Wrtn 리뷰들
('00000000-0000-0000-0000-000000000001', 2, 5, '한국어 특화라서 자소서 작성에 정말 좋습니다. 한국형 표현을 잘 사용해줘요.'),
('00000000-0000-0000-0000-000000000004', 2, 4, '무료로 GPT-4를 사용할 수 있어서 좋지만, 아직 기능이 제한적이에요.'),
('00000000-0000-0000-0000-000000000005', 2, 5, '영어 회화 연습 기능이 무료라서 정말 좋습니다. 발음도 잘 알려줘요.'),

-- Grammarly 리뷰들
('00000000-0000-0000-0000-000000000002', 4, 5, '영문 에세이 작성할 때 필수입니다. 문법 오류를 정확히 잡아줘요.'),
('00000000-0000-0000-0000-000000000003', 4, 4, '무료 버전도 충분히 유용하지만, 고급 기능은 유료라서 아쉬워요.'),
('00000000-0000-0000-0000-000000000006', 4, 5, '영문 이력서 작성할 때 정말 도움이 됩니다. 전문적인 표현도 제안해줘요.'),

-- GitHub Copilot 리뷰들
('00000000-0000-0000-0000-000000000002', 22, 5, '학생이라 무료로 사용할 수 있어서 정말 좋습니다. 코딩 속도가 2배 빨라졌어요.'),
('00000000-0000-0000-0000-000000000003', 22, 4, '대부분 정확하지만 때로는 이상한 코드를 제안하기도 합니다.'),
('00000000-0000-0000-0000-000000000006', 22, 5, '알고리즘 공부할 때 힌트를 많이 받을 수 있어서 좋습니다.'),

-- Midjourney 리뷰들
('00000000-0000-0000-0000-000000000001', 10, 5, 'PPT용 이미지를 만들 때 정말 유용합니다. 저작권 걱정 없이 사용할 수 있어요.'),
('00000000-0000-0000-0000-000000000004', 10, 4, '학습 곡선이 있지만 결과물이 정말 훌륭합니다.'),
('00000000-0000-0000-0000-000000000005', 10, 5, '디자인 과제할 때 필수 도구입니다. 창의적인 이미지를 많이 만들 수 있어요.');

-- 5. 평점 재계산
SELECT recalculate_ai_model_rating(1);
SELECT recalculate_ai_model_rating(2);
SELECT recalculate_ai_model_rating(3);
SELECT recalculate_ai_model_rating(4);
SELECT recalculate_ai_model_rating(5);
SELECT recalculate_ai_model_rating(6);
SELECT recalculate_ai_model_rating(7);
SELECT recalculate_ai_model_rating(8);
SELECT recalculate_ai_model_rating(9);
SELECT recalculate_ai_model_rating(10);
SELECT recalculate_ai_model_rating(11);
SELECT recalculate_ai_model_rating(12);
SELECT recalculate_ai_model_rating(13);
SELECT recalculate_ai_model_rating(14);
SELECT recalculate_ai_model_rating(15);
SELECT recalculate_ai_model_rating(16);
SELECT recalculate_ai_model_rating(17);
SELECT recalculate_ai_model_rating(18);
SELECT recalculate_ai_model_rating(19);
SELECT recalculate_ai_model_rating(20);
SELECT recalculate_ai_model_rating(21);
SELECT recalculate_ai_model_rating(22);
SELECT recalculate_ai_model_rating(23);
SELECT recalculate_ai_model_rating(24);
SELECT recalculate_ai_model_rating(25);
SELECT recalculate_ai_model_rating(26);
SELECT recalculate_ai_model_rating(27);








