-- Insert Telegram Chat with PDF Workflow
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  platform,
  complexity,
  duration,
  apps,
  import_info,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  warnings
) VALUES (
  'Telegram으로 PDF 문서와 대화하기 (시험 공부용)',
  '강의 자료(PDF)를 업로드하고 텔레그램으로 질문하면, AI가 문서 내용을 바탕으로 즉시 답변해 줍니다.',
  E'**개요**\n\n- **문제:** 시험 기간에 두꺼운 전공 서적이나 PDF 강의안을 일일이 찾아보며 공부하기 번거로움.\n- **해결책:** 텔레그램 채팅방에 PDF를 던져두고, 이동 중이나 침대에서 "이 개념이 뭐였지?"라고 물어보면 답변함.\n\n**필요한 인증 정보**\n\n- Telegram Bot Token\n- OpenAI API Key',
  'n8n',
  'Medium',
  '20분',
  '[{"name": "Telegram"}, {"name": "OpenAI"}, {"name": "Pinecone"}]'::jsonb,
  E'**임포트 방법**\n\n1. [Telegram chat with PDF.json](https://github.com/enescingoz/awesome-n8n-templates/blob/main/Telegram/Telegram%20chat%20with%20PDF.json) 링크 접속 후 ''Copy raw file'' 클릭.\n2. n8n 에디터 `Ctrl+V`.',
  'enescingoz (GitHub)',
  'https://placehold.co/600x400?text=Telegram+PDF+Workflow', -- Placeholder for diagram
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Telegram/Telegram%20chat%20with%20PDF.json',
  '[
    {"title": "Telegram Trigger", "description": "봇에게 파일이나 메시지가 오면 실행."},
    {"title": "PDF Loader", "description": "업로드된 PDF 파일을 텍스트로 변환."},
    {"title": "Vector Store", "description": "텍스트를 임베딩하여 메모리에 저장."},
    {"title": "AI Agent", "description": "질문과 관련 있는 텍스트 조각을 찾아 답변 생성 후 전송."}
  ]'::jsonb,
  ARRAY['Telegram Bot Token', 'OpenAI API Key'],
  ARRAY['PDF 파일 크기가 크면 처리 시간이 길어질 수 있습니다.']
);
