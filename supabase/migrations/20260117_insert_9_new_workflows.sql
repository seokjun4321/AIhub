-- Insert 9 new workflows (Revised Data)

INSERT INTO public.preset_workflows (
    title, one_liner, description, complexity, duration, apps, author, download_url, steps, requirements, warnings, created_at, price, platform, import_info
) VALUES 
-- 1. 블로그/제휴마케팅용 SEO 키워드 자동 생성기
(
    '블로그/제휴마케팅용 SEO 키워드 자동 생성기',
    '주제(Seed Keyword) 하나만 입력하면 검색 의도와 구매 가능성을 분석해 ''돈이 되는 키워드'' 리스트를 뽑아줍니다.',
    '- **문제:** 블로그 수익화를 하려는데, 경쟁은 적고 검색량은 많은 ''황금 키워드''를 찾기가 너무 어려움.
- **해결책:** AI 페르소나를 SEO 전문가로 설정하여, 단순 키워드 나열이 아닌 ''사용자 의도(Intent)''와 ''여정 단계(Journey Stage)''를 포함한 전략적 키워드를 도출.',
    'Medium',
    '15분',
    '[{"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Generate%20SEO%20Seed%20Keywords%20Using%20AI.json',
    '[
        {"title": "Manual Trigger", "description": "분석하고 싶은 메인 주제(예: \"캠핑 의자\") 입력."},
        {"title": "AI Agent (Assignment)", "description": "\"너는 SEO 전문가다\" 역할 부여 및 JSON 출력 설정."},
        {"title": "Code Parsing", "description": "AI 출력을 엑셀/구글 시트용 구조화된 데이터로 변환."},
        {"title": "Output", "description": "화면 출력 또는 시트 저장."}
    ]'::jsonb,
    ARRAY['OpenAI API Key (GPT-4 권장)'],
    ARRAY['GPT-3.5보다는 GPT-4를 써야 논리력이 좋습니다.', '한 번에 너무 많은 키워드 요청 시 응답이 잘릴 수 있습니다.', 'JSON Output 모드 확인 필요.'],
    NOW(),
    0,
    'n8n',
    '1. 위 GitHub 링크 접속 후 ''Copy raw file'' 버튼 클릭.
2. n8n 캔버스에서 `Ctrl+V`.
3. OpenAI 노드를 열어 내 API Credential 선택.'
),

-- 2. 송장(Invoice) 데이터 자동 추출 및 엑셀 정리
(
    '송장(Invoice) 데이터 자동 추출 및 엑셀 정리',
    '거래처에서 받은 PDF 송장 파일을 넣으면, LlamaParse 기술을 써서 금액, 날짜, 품목을 엑셀로 정리해 줍니다.',
    '- **문제:** 매월 말 정산 시즌마다 수십 개의 PDF 영수증을 열어보며 엑셀에 타이핑하는 단순 반복 업무 발생.
- **해결책:** 복잡한 표가 포함된 PDF도 텍스트로 완벽히 변환한 뒤, GPT가 핵심 데이터(공급가액, 세액 등)만 추출하여 시트에 기입.',
    'Medium',
    '20분',
    '[{"name": "LlamaParse"}, {"name": "OpenAI"}, {"name": "Google Sheets"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/Invoice%20data%20extraction%20with%20LlamaParse%20and%20OpenAI.json',
    '[
        {"title": "Trigger", "description": "이메일 첨부파일 수신 또는 로컬 폴더 감지."},
        {"title": "HTTP Request (LlamaParse)", "description": "PDF를 LlamaParse API로 전송하여 마크다운 변환."},
        {"title": "OpenAI (Extraction)", "description": "텍스트에서 날짜, 업체명, 총액을 JSON으로 추출."},
        {"title": "Google Sheets", "description": "추출된 데이터를 시트 행에 추가."}
    ]'::jsonb,
    ARRAY['LlamaCloud API Key (무료 티어 가능)', 'OpenAI API Key', 'Google Sheets OAuth2'],
    ARRAY['보안 중요 문서는 로컬 LLM 사용 고려.', 'LlamaParse 무료 사용량 초과 시 비용 발생 가능.', '특이한 영수증 형식은 프롬프트 수정 필요.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. LlamaCloud API 키 발급 후 HTTP Request 헤더 입력.'
),

-- 3. 인스타그램 & 틱톡 숏폼 자동 업로드 (드라이브 연동)
(
    '인스타그램 & 틱톡 숏폼 자동 업로드 (드라이브 연동)',
    '구글 드라이브 특정 폴더에 영상 파일을 넣기만 하면, 인스타그램 릴스와 틱톡에 자동으로 게시됩니다.',
    '- **문제:** 부업으로 SNS 채널을 운영 중인데, PC에서 편집하고 폰으로 옮겨서 각각 올리는 과정이 귀찮아 업로드를 미루게 됨.
- **해결책:** 클라우드 폴더를 ''업로드 슬롯''으로 활용하여 멀티 채널 배포 자동화.',
    'Simple',
    '15분',
    '[{"name": "Google Drive"}, {"name": "Instagram"}, {"name": "TikTok"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Google_Drive_and_Google_Sheets/Upload%20to%20Instagram%20and%20Tiktok%20from%20Google%20Drive.json',
    '[
        {"title": "Google Drive Trigger", "description": "폴더 내 ''새 파일 생성'' 감지."},
        {"title": "Download File", "description": "영상 파일 바이너리 다운로드."},
        {"title": "Instagram Video Post", "description": "비즈니스 계정 ID와 영상 연결."},
        {"title": "TikTok Upload", "description": "틱톡 노드에 연결하여 업로드."}
    ]'::jsonb,
    ARRAY['Google Drive OAuth2 Client', 'Instagram/Facebook Business API', 'TikTok for Business API'],
    ARRAY['인스타그램 비즈니스/크리에이터 계정 필수.', '영상 규격(9:16 등) 준수 필요.', '틱톡 API 인증 까다로울 수 있음.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. 구글 드라이브 노드에서 감시할 폴더 ID 지정.'
),

-- 4. Gmail 자동 라벨링 및 중요도 분류 (이메일 비서)
(
    'Gmail 자동 라벨링 및 중요도 분류 (이메일 비서)',
    '쏟아지는 메일들을 AI가 읽고 "뉴스레터", "청구서", "긴급 업무" 등으로 라벨을 붙여 정리해 줍니다.',
    '- **문제:** 하루에 100통 넘게 오는 이메일 때문에 중요한 거래처 연락을 놓치거나 스팸 속에 파묻힘.
- **해결책:** 수신함에 들어오는 즉시 AI가 내용을 판단하여 태그(라벨)를 부착.',
    'Simple',
    '10분',
    '[{"name": "Gmail"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Gmail_and_Email_Automation/Basic%20Automatic%20Gmail%20Email%20Labelling%20with%20OpenAI%20and%20Gmail%20API.json',
    '[
        {"title": "Gmail Trigger", "description": "읽지 않은 메일 수신 이벤트."},
        {"title": "OpenAI (Classify)", "description": "메일 내용을 [업무, 광고, 청구서, 개인] 중 하나로 분류."},
        {"title": "Switch/If", "description": "AI 분류 결과에 따라 분기."},
        {"title": "Gmail (Modify Label)", "description": "해당 메일에 라벨 추가."}
    ]'::jsonb,
    ARRAY['Google Gmail OAuth2 Credentials', 'OpenAI API Key'],
    ARRAY['Gmail에서 라벨을 미리 만들어 두어야 합니다.', '민감 정보 마스킹 필요 가능성.', '뉴스레터 등은 필터로 먼저 거르는 것 권장.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. Gmail 노드 인증 후 라벨 ID 매핑.'
),

-- 5. SNS 광고 배너 대량 생산 (BannerBear)
(
    'SNS 광고 배너 대량 생산 (BannerBear)',
    '텍스트(카피라이팅)만 리스트로 입력하면, 디자인 템플릿에 맞춰 인스타그램/페이스북용 이미지 수십 장을 자동 생성합니다.',
    '- **문제:** 카드뉴스나 광고 소재를 만들 때, 문구만 바꾸면 되는데 포토샵을 켜서 일일이 저장하는 게 비효율적임.
- **해결책:** API를 통해 텍스트와 배경 이미지만 교체하여 대량의 디자인 파일 렌더링.',
    'Medium',
    '20분',
    '[{"name": "BannerBear"}, {"name": "n8n Table"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Speed%20Up%20Social%20Media%20Banners%20With%20BannerBear.com.json',
    '[
        {"title": "Data Source", "description": "문구가 들어있는 시트나 테이블 준비."},
        {"title": "BannerBear (Create Image)", "description": "템플릿 선택 및 텍스트 레이어 매핑."},
        {"title": "Wait", "description": "이미지 생성 완료 대기."},
        {"title": "HTTP Request/Drive", "description": "생성된 이미지 다운로드."}
    ]'::jsonb,
    ARRAY['BannerBear API Key (Project ID 필요)'],
    ARRAY['BannerBear 유료/무료 체험 확인.', '한글 폰트 업로드 필요.', '디자인 퀄리티는 템플릿에 의존.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. BannerBear 웹사이트에서 템플릿 생성 후 API 키 입력.'
),

-- 6. ''휴먼 인 더 루프'' 이메일 응답 시스템 (CS/영업)
(
    '''휴먼 인 더 루프'' 이메일 응답 시스템 (CS/영업)',
    '고객 문의에 대해 AI가 초안을 작성하면, 담당자가 내용을 확인하고 ''승인'' 버튼을 눌렀을 때만 발송되는 안전한 시스템입니다.',
    '- **문제:** AI 챗봇을 도입하고 싶지만, 고객에게 이상한 말을 할까 봐(Hallucination) 100% 자동화가 두려움.
- **해결책:** AI는 ''초안 작성''만 하고, 최종 발송 권한은 사람에게 두어 안정성과 효율성을 모두 확보.',
    'Medium',
    '25분',
    '[{"name": "Gmail"}, {"name": "OpenAI"}, {"name": "n8n Form"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Gmail_and_Email_Automation/A%20Very%20Simple%20_Human%20in%20the%20Loop_%20Email%20Response%20System%20Using%20AI%20and%20IMAP.json',
    '[
        {"title": "Email Trigger", "description": "문의 메일 수신."},
        {"title": "OpenAI", "description": "답장 초안 작성."},
        {"title": "Approval Node (n8n Form)", "description": "담당자에게 승인 요청 링크 전송."},
        {"title": "Wait for Trigger", "description": "승인 시 이메일 발송."}
    ]'::jsonb,
    ARRAY['Email Credentials (Gmail/Outlook)', 'OpenAI API Key'],
    ARRAY['n8n 인스턴스 외부 접근 가능해야 함(Tunnel/Cloud).', '승인 대기 시간 타임아웃 주의.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. Approval Form URL을 자신에게 보내도록 설정.'
),

-- 7. PDF 문서 비교 분석 (Gemini vs Claude)
(
    'PDF 문서 비교 분석 (Gemini vs Claude)',
    '계약서나 중요 보고서를 Gemini와 Claude 두 AI에게 동시에 읽히고, 교차 검증하여 핵심 내용을 요약합니다.',
    '- **문제:** 하나의 AI 모델만 쓰면 정보를 빼먹거나 거짓말을 할 수 있어 불안함.
- **해결책:** 서로 다른 두 모델의 결과를 비교하여 정확도 향상.',
    'Medium',
    '20분',
    '[{"name": "Google Gemini"}, {"name": "Anthropic Claude"}, {"name": "PDF Loader"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/PDF_and_Document_Processing/Extract%20and%20process%20information%20directly%20from%20PDF%20using%20Claude%20and%20Gemini.json',
    '[
        {"title": "File Upload", "description": "PDF 파일 업로드."},
        {"title": "Text Extraction", "description": "PDF 텍스트 변환."},
        {"title": "Parallel Execution", "description": "Gemini와 Claude에게 동시 요청."},
        {"title": "Merge & Compare", "description": "두 AI 답변 종합."}
    ]'::jsonb,
    ARRAY['Google Gemini API Key', 'Anthropic API Key'],
    ARRAY['Claude 유료 가능성.', 'PDF 페이지 수 토큰 제한 주의.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. 각 모델 노드에 API 키 연결.'
),

-- 8. 경쟁사 SNS 리드(Lead) 확보 및 영업 메일 생성
(
    '경쟁사 SNS 리드(Lead) 확보 및 영업 메일 생성',
    '트위터 등에서 경쟁사 제품에 불만을 표한 사용자를 찾아내고, 우리 제품을 제안하는 영업 메일 초안을 작성합니다.',
    '- **문제:** 잠재 고객을 찾기 위해 SNS를 하루 종일 뒤지는 것은 비효율적임.
- **해결책:** "느리다", "오류", "비싸다" 같은 키워드와 경쟁사 이름을 함께 검색하여 불만 고객 자동 포착.',
    'Medium',
    '20분',
    '[{"name": "Twitter(X)"}, {"name": "OpenAI"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Instagram_Twitter_Social_Media/Social%20Media%20Analysis%20and%20Automated%20Email%20Generation.json',
    '[
        {"title": "Twitter Search", "description": "경쟁사 계정/브랜드명 검색."},
        {"title": "Sentiment Analysis", "description": "게시글 감정 분석(긍정/부정)."},
        {"title": "If Node", "description": "부정적 글만 필터링."},
        {"title": "Generative AI", "description": "영업 메일 초안 작성."}
    ]'::jsonb,
    ARRAY['X (Twitter) API Key (Basic Tier 이상)', 'OpenAI API Key'],
    ARRAY['X API 무료 제한 주의.', '무분별한 DM 발송 주의.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.
2. Twitter API v2 설정 필요.'
),

-- 9. 주식/코인 차트 분석 AI (TradingView + Vision)
(
    '주식/코인 차트 분석 AI (TradingView + Vision)',
    '트레이딩뷰 차트 스크린샷이나 이미지 URL을 입력하면, GPT-4 Vision이 추세선과 패턴을 분석해 줍니다.',
    '- **문제:** 여러 종목의 차트를 기술적으로 분석하려면 시간이 오래 걸리고 주관이 개입됨.
- **해결책:** 시각 정보를 이해하는 AI에게 객관적인 패턴 분석(헤드앤숄더, 지지선 등)을 맡김.',
    'Medium',
    '15분',
    '[{"name": "OpenAI (Vision)"}, {"name": "HTTP Request"}]'::jsonb,
    'enescingoz (GitHub)',
    'https://github.com/enescingoz/awesome-n8n-templates/blob/main/AI_Research_RAG_and_Data_Analysis/Analyze%20tradingview.com%20charts%20with%20Chrome%20extension%2C%20N8N%20and%20OpenAI.json',
    '[
        {"title": "Input", "description": "차트 이미지 URL 또는 파일."},
        {"title": "HTTP Request", "description": "이미지 바이너리 가져오기."},
        {"title": "OpenAI (Vision)", "description": "이미지와 함께 분석 프롬프트 전송."},
        {"title": "Notify", "description": "분석 결과 메신저 전송."}
    ]'::jsonb,
    ARRAY['OpenAI API Key (Vision 지원 모델 필수)'],
    ARRAY['투자의 보조 도구일 뿐입니다.', '고화질 이미지 사용 시 비용 증가.'],
    NOW(),
    0,
    'n8n',
    '1. GitHub Raw 코드 복사 및 n8n 붙여넣기.'
);
