-- Insert 10 Additional Workflows (Set 2)

-- 11. SEO & Content Strategy
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '블로그/제휴마케팅용 SEO 키워드 & 콘텐츠 전략 생성기',
  '검색 의도(User Intent)를 분석해 ''돈이 되는 키워드''와 콘텐츠 작성 순서를 자동으로 뽑아줍니다.',
  '블로그 글을 쓸 때 어떤 키워드를 잡아야 상단 노출이 될지 분석하기 어려울 때 유용합니다. AI가 "구매 의도"가 높은 키워드를 추출하여 수익성 높은 포스팅 주제를 제안합니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/SEO_Marketing_and_Content_Creation/Generate%20SEO%20Seed%20Keywords%20User%20Intent%20and%20Journey%20Stages.json',
  '[
    {"title": "Input Keyword", "description": "메인 주제 키워드를 입력합니다."},
    {"title": "Intent Analysis", "description": "AI가 검색 의도와 구매 가능성을 분석합니다."},
    {"title": "Strategy Gen", "description": "콘텐츠 작성 순서와 전략을 생성합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key'],
  ARRAY[]::text[]
);

-- 12. TradingView Chart Analysis
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials,
  warnings
) VALUES (
  '주식/코인 차트 분석 AI (TradingView + Vision)',
  '트레이딩뷰 차트 스크린샷을 입력하면, GPT-4 Vision이 기술적 분석을 수행하고 매매 전략을 제안합니다.',
  '차트를 볼 줄 모르는 초보자거나, 여러 종목을 빠르게 훑어보고 싶을 때 유용합니다. 차트 이미지를 시각적으로 분석하여 지지선, 저항선, 추세 패턴을 식별합니다.',
  'Medium',
  '15분',
  '[{"name": "n8n"}, {"name": "OpenAI"}, {"name": "TradingView"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1611974765270-ca12586343bb?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Analyze%20tradingview.com%20charts%20with%20GPT-4%20Vision.json',
  '[
    {"title": "Screenshot Input", "description": "차트 스크린샷을 업로드합니다."},
    {"title": "Vision Analysis", "description": "GPT-4 Vision이 차트 패턴을 분석합니다."},
    {"title": "Report", "description": "매매 전략과 분석 리포트를 제공합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key (Vision 모델)'],
  ARRAY[]::text[],
  ARRAY['투자의 참고 자료로만 활용해야 하며, AI의 분석을 맹신해서는 안 됩니다.']
);

-- 13. News to Shorts Script
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '뉴스 기사를 ''쇼츠(Shorts) 영상'' 대본으로 자동 변환',
  '해커뉴스나 특정 기사 링크를 가져와서, 유튜브 쇼츠나 틱톡에 올리기 좋은 형태의 영상 대본으로 바꿔줍니다.',
  '매일 콘텐츠 소재 찾고 대본 쓰기가 힘든 쇼츠 크리에이터에게 유용합니다. 화제가 되는 최신 뉴스를 자동으로 수집하여 흥미로운 대본을 작성해줍니다.',
  'Medium',
  '25분',
  '[{"name": "n8n"}, {"name": "Hacker News"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1611162616475-46b635cb6868?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Hacker%20News%20to%20Video%20Content.json',
  '[
    {"title": "Fetch News", "description": "Hacker News에서 인기 기사를 가져옵니다."},
    {"title": "Script Gen", "description": "쇼츠/틱톡 스타일에 맞춰 1분 내외의 대본을 작성합니다."},
    {"title": "Save/TTS", "description": "대본을 저장하거나 TTS로 변환(확장 가능)합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key'],
  ARRAY[]::text[]
);

-- 14. GA4 Data Analyst
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '구글 애널리틱스(GA4) 데이터 분석 비서',
  '"지난주 웹사이트 방문자 중 구매 전환율이 떨어진 이유가 뭐야?"라고 물으면 GA4 데이터를 분석해 원인을 찾아줍니다.',
  '복잡한 GA4 대시보드 대신 자연어로 질문하여 데이터를 추출하고 인사이트를 도출합니다. 마케터나 기획자의 보고서 작성 시간을 획기적으로 단축시켜줍니다.',
  'Complex',
  '40분',
  '[{"name": "n8n"}, {"name": "Google Analytics"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/SEO_Marketing_and_Content_Creation/Create%20a%20Google%20Analytics%20Data%20Analyst%20Assistant.json',
  '[
    {"title": "User Query", "description": "분석하고 싶은 내용을 질문합니다."},
    {"title": "Query Gen", "description": "질문을 GA4 쿼리로 변환합니다."},
    {"title": "Fetch Data", "description": "GA4 API를 통해 실제 데이터를 가져옵니다."},
    {"title": "Insight Report", "description": "데이터를 해석하여 답변을 제공합니다."}
  ]'::jsonb,
  ARRAY['Google Cloud Project (GA4 Data API)'],
  ARRAY[]::text[]
);

-- 15. Financial Doc Assistant
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '재무제표/금융 문서 분석 어시스턴트',
  '복잡한 PDF 재무제표나 분기 보고서를 업로드하면, Qdrant에 저장해두고 "이번 분기 영업이익률 추이가 어때?" 같은 질문에 답합니다.',
  '경쟁사 실적 분석 보고서를 쓰거나, 투자할 기업의 재정 건전성을 빠르게 파악할 때 유용합니다. 방대한 금융 문서를 벡터 DB에 저장하여 정확한 수치를 찾아냅니다.',
  'Complex',
  '45분',
  '[{"name": "n8n"}, {"name": "Qdrant"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Build%20a%20Financial%20Documents%20Assistant%20with%20Qdrant.json',
  '[
    {"title": "PDF Upload", "description": "재무제표나 보고서 PDF를 업로드합니다."},
    {"title": "Vectorize", "description": "문서 내용을 임베딩하여 Qdrant에 저장합니다."},
    {"title": "Analysis Chain", "description": "금융 관련 질문에 대해 정확한 수치를 찾아 답변합니다."}
  ]'::jsonb,
  ARRAY['Qdrant API Key', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 16. BannerBear Generator
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  'SNS 광고 배너 대량 생산 공장 (BannerBear)',
  '엑셀이나 텍스트로 문구만 입력하면, BannerBear API를 통해 인스타그램/페이스북 광고 이미지를 수십 장씩 찍어냅니다.',
  '디자인 대행이나 내 사업 홍보 시 유용합니다. 반복적인 배너 제작 작업을 자동화하여 텍스트 입력만으로 고품질 이미지를 대량 생산할 수 있습니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "BannerBear"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1561070791-2526d30994b5?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Speed%20Up%20Social%20Media%20Banners%20with%20BannerBear.json',
  '[
    {"title": "Data Input", "description": "배너에 들어갈 문구 리스트를 입력합니다."},
    {"title": "BannerBear API", "description": "템플릿에 맞춰 이미지를 생성합니다."},
    {"title": "Result", "description": "생성된 이미지 URL을 반환하거나 저장합니다."}
  ]'::jsonb,
  ARRAY['BannerBear API Key'],
  ARRAY[]::text[]
);

-- 17. Tax Code Assistant
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '세법(Tax Code) 질의응답 봇',
  '매년 바뀌는 복잡한 세법 개정안 PDF를 학습시켜, "접대비 한도가 얼마야?" 같은 실무 질문에 즉답하는 봇을 만듭니다.',
  '세무/노무 관련 업무나 개인 사업자에게 유용합니다. 사내 규정집을 학습시켜 ''사내 규정 봇''으로도 응용 가능하여 반복적인 질의응답 업무를 줄여줍니다.',
  'Complex',
  '30분',
  '[{"name": "n8n"}, {"name": "Qdrant"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1586486855514-8c633cc6fd38?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/OpenAI_and_LLMs/Build%20a%20Tax%20Code%20Assistant%20with%20Vector%20Store.json',
  '[
    {"title": "Doc Load", "description": "세법 개정안이나 규정집 PDF를 로드합니다."},
    {"title": "RAG Setup", "description": "문서를 청킹(Chunking)하여 벡터 DB에 저장합니다."},
    {"title": "Q&A System", "description": "사용자 질문에 대해 법령을 근거로 답변합니다."}
  ]'::jsonb,
  ARRAY['Qdrant/Pinecone Key', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 18. Property Survey AI
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '부동산 매물 조사 및 리포트 자동화',
  '부동산 현장 사진과 메모를 입력하면, AI가 이를 종합하여 "매물 상태 보고서"나 "임장 후기 블로그 글"을 작성해 줍니다.',
  '부동산 임장기 블로그나 에어비앤비 호스트에게 유용합니다. 현장 사진을 Vision AI로 분석하고 메모를 보완하여 매력적인 매물 설명글을 작성합니다.',
  'Medium',
  '30분',
  '[{"name": "n8n"}, {"name": "OpenAI"}, {"name": "Notion"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Enrich%20Property%20Inventory%20Surveys%20with%20Multimodal%20AI.json',
  '[
    {"title": "Input", "description": "현장 사진과 메모를 업로드합니다."},
    {"title": "Multimodal Analysis", "description": "사진 내 시설 상태 등을 파악합니다."},
    {"title": "Report Gen", "description": "종합 리포트 또는 블로그 글을 생성합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key'],
  ARRAY[]::text[]
);

-- 19. Job Listing Scraper
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '경쟁사/채용 공고 모니터링 스크래퍼',
  '해커뉴스나 채용 사이트를 주기적으로 긁어와서, 특정 기술 스택(예: n8n, Python)을 쓰는 회사를 찾아내 엑셀에 정리합니다.',
  '이직 준비나 영업 기회 발굴에 유용합니다. 개발자를 뽑는 회사를 찾아내어 솔루션 영업 대상을 확보하거나 이직 기회를 포착할 수 있습니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "Google Sheets"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Web_Scraping/Hacker%20News%20Job%20Listing%20Scraper.json',
  '[
    {"title": "Fetch Listings", "description": "채용 사이트의 공고 목록을 가져옵니다."},
    {"title": "Filter", "description": "특정 키워드(기술 스택 등)로 필터링합니다."},
    {"title": "Save", "description": "Google Sheets에 회사 정보를 저장합니다."}
  ]'::jsonb,
  ARRAY[]::text[],
  ARRAY[]::text[]
);

-- 20. Customer Sentiment Analysis
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials
) VALUES (
  '고객 리뷰 감성 분석 및 자동 분류 (CS 업무)',
  '쇼핑몰 리뷰나 고객 피드백을 수집해 Qdrant에 저장하고, 긍정/부정 비율을 분석하거나 "배송 불만"만 따로 추출하여 보고합니다.',
  '수천 개의 리뷰를 일일이 읽기 힘든 CS팀이나 상품 기획자에게 유용합니다. 제품 결함 관련 리뷰만 모아서 개발팀에 전달하는 등 피드백 관리 업무를 자동화합니다.',
  'Medium',
  '25분',
  '[{"name": "n8n"}, {"name": "Qdrant"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Customer%20Insights%20with%20Qdrant%20Vector%20Store.json',
  '[
    {"title": "Fetch Reviews", "description": "리뷰 데이터를 수집합니다."},
    {"title": "Analysis", "description": "긍정/부정, 카테고리(배송, 품질 등)를 분류합니다."},
    {"title": "Report", "description": "분석 결과를 대시보드나 리포트로 만듭니다."}
  ]'::jsonb,
  ARRAY['Qdrant API Key', 'OpenAI API Key'],
  ARRAY[]::text[]
);
