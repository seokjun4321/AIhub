-- Insert Additional 9 Workflows (Citation Set)

INSERT INTO public.preset_workflows (
    title, one_liner, description, complexity, duration, apps, author, download_url, steps, requirements, warnings, created_at, price, platform, import_info
) VALUES 
-- 2. 논문/리포트 작성용 인용구(Citation) 포함 답변기
(
    '논문/리포트 작성용 인용구(Citation) 포함 답변기',
    '질문에 답할 때, 참고한 PDF 문서의 정확한 출처(페이지/문단)를 함께 표기해 주어 리포트 작성 시 유용합니다.',
    '- **문제:** ChatGPT가 써준 내용은 출처가 불분명해서 과제에 그대로 쓰기 어려움(Hallucination 위험).
- **해결책:** RAG 기술을 활용해 "이 문장은 문서의 어디에서 가져왔음"을 명시하여 신뢰도 확보.',
    'Complex',
    '30분',
    '[{"name": "OpenAI"}, {"name": "Pinecone"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/Chat%20with%20PDF%20docs%20using%20AI%20(quoting%20sources).json',
    '[
        {"title": "Document Loader", "description": "참고 문헌(PDF) 로드 및 텍스트 청킹(Chunking)."},
        {"title": "Pinecone (Upsert)", "description": "문서 내용을 벡터 DB에 인덱싱하여 저장."},
        {"title": "Retriever", "description": "질문과 관련된 문서를 검색."},
        {"title": "Chain (Generate)", "description": "검색된 내용을 바탕으로 답변을 작성하되, 소스 출처를 명시하도록 프롬프트 제어."}
    ]'::jsonb,
    ARRAY['Pinecone API Key (무료 티어 사용 가능)', 'OpenAI API Key'],
    ARRAY['Pinecone 웹사이트에서 미리 ''Index''를 생성해 두어야 오류가 나지 않습니다.', '벡터 차원(Dimension) 수는 사용하는 임베딩 모델(예: text-embedding-3-small은 1536)과 일치해야 합니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사.
2. n8n 캔버스에 붙여넣기.
3. Pinecone 노드에서 Index 이름 설정.'
),

-- 3. Notion 지식 베이스 AI 비서 (개인 과외 선생님)
(
    'Notion 지식 베이스 AI 비서 (개인 과외 선생님)',
    '내 Notion에 정리된 모든 강의 노트와 자료를 학습한 AI가 내 질문에 맞춰 내 노트 내용을 찾아 답변합니다.',
    '- **문제:** Notion에 정리는 열심히 했는데, 막상 필요할 때 어디 있는지 못 찾거나 내용이 방대해 다시 읽기 귀찮음.
- **해결책:** "지난 학기 경제학 수업 때 교수님이 강조한 거 찾아줘"라고 하면 Notion 검색 후 요약.',
    'Medium',
    '20분',
    '[{"name": "Notion"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Notion/Notion%20knowledge%20base%20AI%20assistant.json',
    '[
        {"title": "Chat Trigger", "description": "사용자 질문 입력."},
        {"title": "Search Notion", "description": "Notion 데이터베이스에서 질문 키워드로 검색 수행."},
        {"title": "AI Agent", "description": "검색된 페이지 내용을 읽고 사용자의 질문 의도에 맞춰 요약 및 답변 구성."},
        {"title": "Output", "description": "최종 답변 출력 (텔레그램, 슬랙 등 연결 가능)."}
    ]'::jsonb,
    ARRAY['Notion API Integration Token (Internal Integration 생성 필요)', 'OpenAI API Key'],
    ARRAY['Notion API 연결 시, 해당 데이터베이스 페이지 우측 상단 `...` 메뉴에서 `Connections`에 내 통합(Integration)을 추가해야 합니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사.
2. n8n 캔버스에 붙여넣기.
3. Notion 노드에서 검색할 데이터베이스 ID 연결.'
),

-- 4. 심층 리서치 에이전트 (졸업논문/프로젝트용)
(
    '심층 리서치 에이전트 (졸업논문/프로젝트용)',
    '하나의 주제에 대해 웹을 깊이 있게 탐색(Deep Dive)하여 방대한 자료를 수집하고 분석 리포트를 작성합니다.',
    '- **문제:** 논문 주제 조사를 위해 수십 개의 탭을 열고 닫으며 시간을 낭비함. 단순 검색으로는 깊이 있는 정보를 얻기 힘듦.
- **해결책:** 에이전트가 스스로 구글링 -> 링크 접속 -> 내용 분석 -> 추가 검색을 반복(Loop)하며 심층 보고서 작성.',
    'Complex',
    '40분',
    '[{"name": "Apify"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Host%20Your%20Own%20AI%20Deep%20Research%20Agent%20with%20n8n,%20Apify%20and%20OpenAI%20o3.json',
    '[
        {"title": "Input", "description": "연구 주제 및 깊이(Depth) 설정."},
        {"title": "Agent Loop", "description": "정보가 충분할 때까지 ''검색 -> 읽기 -> 판단'' 과정을 반복."},
        {"title": "Apify (Google Search Scraper)", "description": "실제 웹 검색 및 결과 파싱 수행."},
        {"title": "Generate Report", "description": "수집된 정보를 종합하여 마크다운 형식의 보고서 생성."}
    ]'::jsonb,
    ARRAY['Apify API Token (무료 크레딧 확인 필요)', 'OpenAI API Key'],
    ARRAY['반복 루프가 돌기 때문에 API 호출 비용이 빠르게 증가할 수 있습니다. 테스트 시에는 반복 횟수를 제한하세요.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. Apify 콘솔에서 `Google Search Results Scraper` 액터 빌드 후 토큰 입력.'
),

-- 5. Google Drive 파일 연동 AI 어시스턴트
(
    'Google Drive 파일 연동 AI 어시스턴트',
    '구글 드라이브에 저장된 팀플 자료나 수업 자료를 AI가 직접 열어보고 내용을 파악해 도와줍니다.',
    '- **문제:** 팀플 자료가 구글 드라이브 폴더 여기저기에 흩어져 있어, 파일 내용을 일일이 열어보지 않으면 파악이 힘듦.
- **해결책:** 파일명이나 내용을 AI가 인식하여 필요한 문서를 찾아주거나 내용을 요약해줌.',
    'Medium',
    '20분',
    '[{"name": "Google Drive"}, {"name": "Google Sheets"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Google_Drive_and_Google_Sheets/Build%20an%20OpenAI%20Assistant%20with%20Google%20Drive%20Integration.json',
    '[
        {"title": "Trigger", "description": "채팅으로 질문을 받거나 특정 시간 트리거."},
        {"title": "Google Drive (List/Search)", "description": "사용자의 질문과 관련된 파일 검색."},
        {"title": "File Download", "description": "n8n이 파일 내용을 읽을 수 있도록 바이너리 다운로드."},
        {"title": "AI Assistant", "description": "파일의 텍스트를 추출하여 Context로 삼고 답변 생성."}
    ]'::jsonb,
    ARRAY['Google Drive OAuth2 Credentials', 'OpenAI API Key'],
    ARRAY['n8n 서버의 메모리 설정에 따라 대용량 파일 다운로드 시 에러가 발생할 수 있습니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. 구글 드라이브 노드 인증 연결.'
),

-- 6. 이력서/CV 자동 파싱 및 PDF 생성 (취업 준비)
(
    '이력서/CV 자동 파싱 및 PDF 생성 (취업 준비)',
    '내 이력을 텍스트로 적거나 기존 이력서를 넣으면, Vision AI가 이를 분석해 표준화된 형식이나 새로운 디자인의 PDF로 만들어줍니다.',
    '- **문제:** 지원하는 회사마다 이력서 포맷을 조금씩 수정해야 하는데, 워드 파일 수정이 번거롭고 디자인이 깨짐.
- **해결책:** 핵심 경력 데이터만 있으면 AI가 형식을 갖춰서 정리해 주고 깔끔한 PDF로 변환.',
    'Medium',
    '25분',
    '[{"name": "OpenAI"}, {"name": "Gotenberg"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/CV%20Resume%20PDF%20Parsing%20with%20Multimodal%20Vision%20AI.json',
    '[
        {"title": "File Input", "description": "기존 이력서(이미지/PDF) 업로드."},
        {"title": "Vision AI (OpenAI)", "description": "이력서 이미지에서 텍스트 구조화(이름, 학력, 경력 등) 및 데이터 추출."},
        {"title": "HTML Template", "description": "추출된 데이터를 미리 준비된 HTML/CSS 템플릿에 주입."},
        {"title": "Convert to PDF", "description": "완성된 HTML을 PDF 파일로 변환하여 다운로드 제공."}
    ]'::jsonb,
    ARRAY['OpenAI API Key (GPT-4o 등 이미지 인식이 가능한 모델 필수)'],
    ARRAY['Vision 모델은 일반 텍스트 모델보다 토큰 비용이 비쌉니다.', 'PDF 생성을 위해 n8n 내장 노드나 외부 API(Gotenberg 등) 설정이 필요할 수 있습니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.'
),

-- 7. Notion + OpenAI로 LinkedIn 네트워킹 자동화
(
    'Notion + OpenAI로 LinkedIn 네트워킹 자동화',
    '관심 있는 회사나 멘토의 LinkedIn 프로필 정보를 Notion에 정리하고, 맞춤형 콜드 메일(DM) 초안을 작성합니다.',
    '- **문제:** 인턴십 지원을 위해 인사담당자에게 보낼 메시지를 매번 새로 쓰기 어렵고, 누구에게 보냈는지 관리가 안 됨.
- **해결책:** Notion 데이터베이스에 "이름, 회사, 직무"만 적으면 AI가 정중한 커피챗 요청 메시지를 작성해 줌.',
    'Medium',
    '15분',
    '[{"name": "Notion"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Notion/Automate%20LinkedIn%20Outreach%20with%20Notion%20and%20OpenAI.json',
    '[
        {"title": "Notion Trigger", "description": "데이터베이스에 새로운 항목(사람)이 추가되면 실행."},
        {"title": "Read Data", "description": "이름, 직무, 회사명, 관심사 등의 속성값 읽기."},
        {"title": "OpenAI", "description": "\"이 사람에게 커피챗을 요청하는 정중한 300자 내외 메시지를 써줘\" 프롬프트 실행."},
        {"title": "Update Notion", "description": "생성된 메시지 초안을 Notion 페이지 본문이나 속성에 업데이트."}
    ]'::jsonb,
    ARRAY['Notion API Key', 'OpenAI API Key'],
    ARRAY['Notion 속성 이름(Name, Company 등)이 워크플로우 설정과 정확히 일치해야 합니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. Notion 데이터베이스 ID 연결.'
),

-- 8. LINE으로 Google Calendar & Gmail 관리
(
    'LINE으로 Google Calendar & Gmail 관리',
    '한국/일본 대학생들이 많이 쓰는 LINE 메신저에서 "내일 수업 일정 알려줘"라고 하면 구글 캘린더를 확인해 답장합니다.',
    '- **문제:** 캘린더 앱을 켜는 것조차 귀찮고, 읽지 않은 중요 메일을 자주 놓침.
- **해결책:** 가장 자주 쓰는 메신저(LINE)를 개인 비서로 활용하여 접근성 향상.',
    'Medium',
    '20분',
    '[{"name": "LINE"}, {"name": "Google Calendar"}, {"name": "Gmail"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Other_Integrations_and_Use_Cases/LINE%20Assistant%20with%20Google%20Calendar%20and%20Gmail%20Integration.json',
    '[
        {"title": "Webhook (LINE)", "description": "라인 서버에서 보내주는 메시지 수신."},
        {"title": "Router/If", "description": "사용자가 \"일정\"을 물었는지 \"메일\"을 물었는지 키워드 판단."},
        {"title": "Google Calendar/Gmail", "description": "요청에 맞는 데이터(내일 일정, 안 읽은 메일) 조회."},
        {"title": "HTTP Request (Reply)", "description": "라인 API 포맷에 맞춰 답변 메시지 전송."}
    ]'::jsonb,
    ARRAY['LINE Developers Console (Channel Access Token 및 Secret)', 'Google Cloud (Calendar/Gmail API 권한)'],
    ARRAY['LINE 봇은 무료 플랜에서 월 메시지 전송량 제한이 있으나 개인 용도로는 충분합니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. LINE Developers 콘솔에서 Webhook URL(n8n 주소) 등록 필수.'
),

-- 9. Google Sheets 설문 응답 요약 및 감성 분석 (동아리/학생회)
(
    'Google Sheets 설문 응답 요약 및 감성 분석 (동아리/학생회)',
    '구글 폼으로 받은 학생들의 피드백이나 가입 신청서를 AI가 읽고 "긍정/부정"을 판단하거나 핵심 내용을 3줄로 요약해 시트에 다시 적어줍니다.',
    '- **문제:** 학생회나 동아리에서 수백 개의 설문 주관식 응답을 받으면 일일이 읽고 분류하는 ''단순 노가다''가 발생.
- **해결책:** AI가 자동으로 "건의사항", "불만", "칭찬" 등으로 태깅하고 요약하여 통계 내기 쉽게 만듦.',
    'Simple',
    '15분',
    '[{"name": "Google Sheets"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Google_Drive_and_Google_Sheets/Summarize%20Google%20Sheets%20form%20feedback%20via%20OpenAI_s%20GPT-4.json',
    '[
        {"title": "Google Sheets Trigger", "description": "시트에 새 행이 추가되면(폼 제출 시) 실행."},
        {"title": "Set Data", "description": "분석할 텍스트(응답 내용) 지정."},
        {"title": "OpenAI", "description": "\"이 피드백을 한 문장으로 요약하고, 감정을 [긍정, 부정, 중립] 중 하나로만 출력해\" 프롬프트 실행."},
        {"title": "Update Sheet", "description": "분석 결과(요약, 감정)를 해당 행의 빈 열(Column)에 기입."}
    ]'::jsonb,
    ARRAY['Google Sheets OAuth2 Credentials', 'OpenAI API Key'],
    ARRAY['구글 시트의 첫 번째 행(헤더)에 ''요약'', ''감정'' 같은 열을 미리 만들어 두어야 합니다.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. 구글 시트 노드에서 파일 ID와 시트 이름 선택.'
),

-- 10. YouTube 영상을 X(트위터) 홍보글로 변환
(
    'YouTube 영상을 X(트위터) 홍보글로 변환',
    '동아리 홍보 영상이나 브이로그를 유튜브에 올리면, 자동으로 매력적인 홍보 멘트를 생성해 X(구 트위터)에 게시합니다.',
    '- **문제:** 영상 편집하느라 지쳐서 SNS 홍보글 쓸 힘이 없고, 단순 링크 공유는 조회수가 안 나옴.
- **해결책:** 영상 제목과 설명란을 참고해 AI가 "어그로" 끌리는 홍보 트윗과 해시태그를 자동 작성 및 포스팅.',
    'Simple',
    '10분',
    '[{"name": "YouTube"}, {"name": "X (Twitter)"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Post%20New%20YouTube%20Videos%20to%20X.json',
    '[
        {"title": "YouTube Trigger", "description": "내 채널에 ''새 동영상''이 올라오면 감지."},
        {"title": "OpenAI", "description": "영상 제목과 설명을 바탕으로 트위터 감성(짧고 임팩트 있게)의 홍보글 작성. 해시태그 포함."},
        {"title": "X (Post Tweet)", "description": "작성된 텍스트와 영상 링크를 트윗으로 게시."},
        {"title": "(선택) Telegram/Discord", "description": "\"업로드 완료!\" 알림 전송."}
    ]'::jsonb,
    ARRAY['YouTube Data API', 'X (Twitter) Developer API', 'OpenAI API Key'],
    ARRAY['X(트위터) 무료 API는 쓰기 제한이 엄격하므로, 하루에 너무 많은 트윗을 보내지 않도록 주의하세요.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub 링크의 Raw JSON 복사 및 n8n 붙여넣기.
2. 각 노드의 인증 정보 연결.'
);
