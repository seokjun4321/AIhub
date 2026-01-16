-- Insert 9 Remaining Workflows

-- 2. Citation Helper
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
  '논문/리포트 작성용 인용구(Citation) 포함 답변기',
  '질문에 답할 때, 참고한 PDF 문서의 정확한 출처(페이지/문단)를 함께 표기해 주어 리포트 작성 시 유용합니다.',
  'ChatGPT가 써준 내용은 출처가 불분명해서 과제에 그대로 쓰기 어렵습니다(Hallucination). 이 워크플로우는 RAG 기술을 활용해 "이 문장은 문서의 어디에서 가져왔음"을 명시하여 신뢰성 있는 답변을 제공합니다.',
  'Complex',
  '30분',
  '[{"name": "n8n"}, {"name": "OpenAI"}, {"name": "Pinecone"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/Chat%20with%20PDF%20docs%20using%20AI%20(quoting%20sources).json',
  '[
    {"title": "Document Loader", "description": "참고 문헌(PDF)을 로드합니다."},
    {"title": "Pinecone Indexing", "description": "문서 내용을 벡터 DB에 인덱싱합니다."},
    {"title": "Retriever", "description": "질문과 관련된 문서를 검색합니다."},
    {"title": "Chain", "description": "검색된 내용을 바탕으로 인용구와 함께 답변을 생성합니다."}
  ]'::jsonb,
  ARRAY['Pinecone API Key', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 3. Notion Knowledge Base AI
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
  'Notion 지식 베이스 AI 비서 (개인 과외 선생님)',
  '내 Notion에 정리된 모든 강의 노트와 자료를 학습한 AI가 내 질문에 맞춰 내 노트 내용을 찾아 답변합니다.',
  'Notion에 정리는 열심히 했는데, 막상 필요할 때 어디 있는지 못 찾을 때가 많습니다. "지난 학기 경제학 수업 때 교수님이 강조한 거 찾아줘"라고 물어보면 Notion을 검색 후 요약해줍니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "Notion"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Notion/Notion%20knowledge%20base%20AI%20assistant.json',
  '[
    {"title": "Search Notion", "description": "Notion 데이터베이스에서 키워드를 검색합니다."},
    {"title": "AI Agent", "description": "검색된 페이지 내용을 읽고 사용자의 질문 의도에 맞춰 요약합니다."},
    {"title": "Output", "description": "답변을 출력합니다 (텔레그램, 슬랙 등 연결 가능)."}
  ]'::jsonb,
  ARRAY['Notion API Integration Token', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 4. Deep Research Agent
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
  '심층 리서치 에이전트 (졸업논문/프로젝트용)',
  '하나의 주제에 대해 웹을 깊이 있게 탐색(Deep Dive)하여 방대한 자료를 수집하고 분석 리포트를 작성합니다.',
  '논문 주제 조사를 위해 수십 개의 탭을 열고 닫으며 시간을 낭비하지 마세요. 에이전트가 스스로 구글링 -> 링크 접속 -> 내용 분석 -> 추가 검색을 반복하며 심층 보고서를 작성합니다.',
  'Complex',
  '40분',
  '[{"name": "n8n"}, {"name": "Apify"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1555421689-d68471e189f2?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Host%20Your%20Own%20AI%20Deep%20Research%20Agent%20with%20n8n,%20Apify%20and%20OpenAI%20o3.json',
  '[
    {"title": "Input", "description": "연구 주제를 입력합니다."},
    {"title": "Agent Loop", "description": "정보가 충분할 때까지 검색과 분석을 반복합니다."},
    {"title": "Apify Execution", "description": "Google Search Results Scraper를 실행하여 정보를 수집합니다."}
  ]'::jsonb,
  ARRAY['Apify API Token', 'OpenAI API Key'],
  ARRAY[]::text[],
  ARRAY['API 호출량이 많을 수 있으므로 비용 관리에 주의해야 합니다.']
);

-- 5. Google Drive AI Assistant
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
  'Google Drive 파일 연동 AI 어시스턴트',
  '구글 드라이브에 저장된 팀플 자료나 수업 자료를 AI가 직접 열어보고 내용을 파악해 도와줍니다.',
  '팀플 자료가 구글 드라이브 여기저기에 흩어져 있어 내용 파악이 힘들 때 유용합니다. 파일명이나 내용을 AI가 인식하여 필요한 문서를 찾아주거나 내용을 요약해줍니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "Google Drive"}, {"name": "Google Sheets"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1620912189868-38f0c97d6209?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Google_Drive_and_Google_Sheets/Build%20an%20OpenAI%20Assistant%20with%20Google%20Drive%20Integration.json',
  '[
    {"title": "Google Drive Trigger", "description": "파일 업로드 또는 요청 시 실행됩니다."},
    {"title": "File Download", "description": "n8n이 파일을 읽을 수 있도록 다운로드합니다."},
    {"title": "AI Assistant", "description": "파일 내용을 컨텍스트로 대화를 수행합니다."}
  ]'::jsonb,
  ARRAY['Google Drive OAuth2 Credentials', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 6. Resume/CV Parser
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
  '이력서/CV 자동 파싱 및 PDF 생성 (취업 준비)',
  '내 이력을 텍스트로 적거나 기존 이력서를 넣으면, Vision AI가 이를 분석해 표준화된 형식이나 새로운 디자인의 PDF로 만들어줍니다.',
  '지원하는 회사마다 이력서 포맷을 조금씩 수정하기가 번거로울 때 사용합니다. 핵심 경력 데이터만 있으면 AI가 형식을 갖춰서 정리해 줍니다.',
  'Medium',
  '25분',
  '[{"name": "n8n"}, {"name": "OpenAI"}, {"name": "Gotenberg"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/CV%20Resume%20PDF%20Parsing%20with%20Multimodal%20Vision%20AI.json',
  '[
    {"title": "File Input", "description": "기존 이력서(이미지/PDF)를 업로드합니다."},
    {"title": "Vision AI Analysis", "description": "이미지에서 텍스트 구조화 및 데이터를 추출합니다."},
    {"title": "JSON to PDF", "description": "추출된 데이터를 깔끔한 템플릿에 맞춰 PDF로 변환합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key (Vision 모델)'],
  ARRAY[]::text[]
);

-- 7. LinkedIn Networking
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
  'Notion + OpenAI로 LinkedIn 네트워킹 자동화',
  '관심 있는 회사나 멘토의 LinkedIn 프로필 정보를 Notion에 정리하고, 맞춤형 콜드 메일(DM) 초안을 작성합니다.',
  '인턴십 지원을 위해 인사담당자에게 보낼 메시지를 매번 새로 쓰기 어려울 때 유용합니다. Notion에 "이름, 회사, 직무"만 적으면 AI가 정중한 커피챗 요청 메시지를 작성해줍니다.',
  'Medium',
  '15분',
  '[{"name": "n8n"}, {"name": "Notion"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1611944212129-29990460f15d?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Notion/Automate%20LinkedIn%20Outreach%20with%20Notion%20and%20OpenAI.json',
  '[
    {"title": "Notion Input", "description": "대상자 정보(이름, 회사, 직무)를 입력합니다."},
    {"title": "AI Draft Gen", "description": "입력 정보를 바탕으로 맞춤형 메시지 초안을 생성합니다."},
    {"title": "Update Notion", "description": "생성된 메시지를 Notion에 다시 저장합니다."}
  ]'::jsonb,
  ARRAY['Notion API Key', 'OpenAI API Key'],
  ARRAY[]::text[]
);

-- 8. LINE Assistant
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
  'LINE으로 Google Calendar & Gmail 관리',
  '한국/일본 대학생들이 많이 쓰는 LINE 메신저에서 "내일 수업 일정 알려줘"라고 하면 구글 캘린더를 확인해 답장합니다.',
  '캘린더 앱을 켜는 것조차 귀찮고, 읽지 않은 중요 메일을 놓칠 때 유용합니다. 가장 자주 쓰는 메신저(LINE)를 개인 비서로 활용하세요.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "LINE"}, {"name": "Google Calendar"}, {"name": "Gmail"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1550063873-ab792950096b?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Other_Integrations_and_Use_Cases/LINE%20Assistant%20with%20Google%20Calendar%20and%20Gmail%20Integration.json',
  '[
    {"title": "Message Receive", "description": "LINE 메시지를 수신합니다."},
    {"title": "Intent Analysis", "description": "일정 확인인지, 메일 확인인지 의도를 파악합니다."},
    {"title": "Fetch Data", "description": "Google Calendar 또는 Gmail에서 정보를 가져옵니다."},
    {"title": "Reply", "description": "확인된 정보를 LINE으로 답장합니다."}
  ]'::jsonb,
  ARRAY['LINE Channel Access Token', 'Google Cloud API Key'],
  ARRAY[]::text[]
);

-- 9. Google Sheets Sentiment Analysis
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
  'Google Sheets 설문 응답 요약 및 감성 분석',
  '구글 폼으로 받은 학생들의 피드백이나 가입 신청서를 AI가 읽고 "긍정/부정"을 판단하거나 핵심 내용을 3줄로 요약해 시트에 다시 적어줍니다.',
  '수백 개의 설문 주관식 응답을 일일이 읽고 분류하는 시간을 아껴줍니다. AI가 자동으로 "건의사항", "불만", "칭찬" 등으로 태깅하고 요약해줍니다.',
  'Simple',
  '15분',
  '[{"name": "n8n"}, {"name": "Google Sheets"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1543286386-713df548e9cc?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Google_Drive_and_Google_Sheets/Summarize%20Google%20Sheets%20form%20feedback%20via%20OpenAI_s%20GPT-4.json',
  '[
    {"title": "Google Sheets Trigger", "description": "새 행이 추가되면(폼 제출 시) 실행됩니다."},
    {"title": "OpenAI Analysis", "description": "피드백을 요약하고 감정을 분석합니다."},
    {"title": "Update Sheet", "description": "분석 결과를 옆 칸에 자동으로 기입합니다."}
  ]'::jsonb,
  ARRAY['OpenAI API Key'],
  ARRAY[]::text[]
);

-- 10. YouTube to X
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
  'YouTube 영상을 X(트위터) 홍보글로 변환',
  '동아리 홍보 영상이나 브이로그를 유튜브에 올리면, 자동으로 매력적인 홍보 멘트를 생성해 X(구 트위터)에 게시합니다.',
  '영상 편집하느라 지쳐서 SNS 홍보글 쓸 힘이 없을 때 사용하세요. 영상 제목과 설명란을 참고해 AI가 이목을 끄는 홍보 트윗을 작성하고 자동으로 포스팅합니다.',
  'Simple',
  '10분',
  '[{"name": "n8n"}, {"name": "YouTube"}, {"name": "X (Twitter)"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1611162617474-5b21e879e113?auto=format&fit=crop&q=80&w=1000',
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Post%20New%20YouTube%20Videos%20to%20X.json',
  '[
    {"title": "YouTube Trigger", "description": "새 영상이 업로드되면 실행됩니다."},
    {"title": "Draft Tweet", "description": "영상 정보를 바탕으로 홍보 멘트를 생성합니다."},
    {"title": "Post to X", "description": "X(트위터)에 자동으로 게시합니다."}
  ]'::jsonb,
  ARRAY['YouTube Data API', 'X (Twitter) Developer API'],
  ARRAY[]::text[]
);
