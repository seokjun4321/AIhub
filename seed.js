import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("Supabase URL or Key is missing in .env file");
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: { autoRefreshToken: false, persistSession: false }
});

const seedDatabase = async () => {
  try {
    console.log('Start seeding...');

    // --- 1. 사용자(Profiles) 확인 ---
    const { data: users, error: userError } = await supabase.from('profiles').select('id');
    if (userError || !users || users.length === 0) {
      console.error('🔴 Error: No users found in "profiles" table.');
      console.log('🔵 Please sign up at least one user in your application before seeding.');
      return;
    }
    console.log(`✅ Found ${users.length} user(s). Seeding will proceed.`);
    const authorId = users[0].id;

    // --- 데이터 삭제 (순서 중요: 자식 -> 부모) ---
    console.log('Deleting existing data...');
    await supabase.from('recommendations').delete().neq('use_case_id', -1);
    await supabase.from('ratings').delete().neq('user_id', '00000000-0000-0000-0000-000000000000');
    await supabase.from('guides').delete().neq('id', -1);
    await supabase.from('comments').delete().neq('id', -1);
    await supabase.from('posts').delete().neq('id', -1);
    await supabase.from('use_cases').delete().neq('id', -1);
    await supabase.from('ai_models').delete().neq('id', -1);
    await supabase.from('categories').delete().neq('id', -1);
    console.log('Existing data deleted.');

    // --- 데이터 삽입 (순서 중요: 부모 -> 자식) ---
    console.log('Seeding new data...');
    
    // 1. categories (id 제거)
    const { data: seededCategories, error: catError } = await supabase.from('categories').insert([
      { name: '대화형 AI' }, { name: 'AI 검색' }, { name: '이미지 생성' },
      { name: '글쓰기 / 생산성' }, { name: '코딩 / 개발' }, { name: '영상 / 오디오' },
      { name: '자동화' }, { name: '디자인' },
    ]).select();
    if (catError) throw catError;
    console.log('Seeded categories.');

    // 2. ai_models (id 제거)
    const { data: seededModels, error: modelError } = await supabase.from('ai_models').insert([
      { name: 'ChatGPT', version: '4o', provider: 'OpenAI', description: '가장 범용적이고 강력한 대화형 AI' },
      { name: 'Gemini', version: '1.5 Pro', provider: 'Google', description: '긴 컨텍스트 이해와 멀티모달에 강점' },
      { name: 'Claude', version: '3 Opus', provider: 'Anthropic', description: '자연스러운 글쓰기와 분석 능력 탁월' },
      { name: 'Perplexity', version: 'Online', provider: 'Perplexity AI', description: '출처 기반의 신뢰도 높은 AI 검색 엔진' },
      { name: 'Midjourney', version: 'V6', provider: 'Midjourney, Inc.', description: '독보적인 예술성을 자랑하는 이미지 생성 AI' },
      { name: 'DALL-E', version: '3', provider: 'OpenAI', description: 'ChatGPT와 연동되는 쉬운 이미지 생성 AI' },
      { name: 'Adobe Firefly', version: 'Image 2', provider: 'Adobe', description: '상업적으로 안전한 이미지 생성 및 편집 AI' },
      { name: 'Stable Diffusion', version: '3', provider: 'Stability AI', description: '무한한 커스터마이징이 가능한 오픈소스 이미지 AI' },
      { name: 'Notion AI', version: 'Integrated', provider: 'Notion', description: '문서 작업의 모든 과정을 돕는 생산성 AI' },
      { name: 'Grammarly', version: 'Go', provider: 'Grammarly, Inc.', description: '단순 교정을 넘어 글의 톤과 스타일을 제안' },
      { name: 'Jasper', version: 'Brand Brain', provider: 'Jasper AI, Inc.', description: '브랜드 보이스에 특화된 비즈니스 콘텐츠 생성 AI' },
      { name: 'Copy.ai', version: 'Chat', provider: 'Copy.ai', description: '수많은 템플릿으로 마케팅 카피를 빠르게 생성' },
      { name: 'GitHub Copilot', version: 'Integrated', provider: 'GitHub / OpenAI', description: 'AI 페어 프로그래머. 개발 생산성 극대화' },
      { name: 'Replit', version: 'Core', provider: 'Replit', description: '설치 없는 클라우드 IDE와 AI 코딩 지원' },
      { name: 'Tabnine', version: 'Pro', provider: 'Tabnine', description: '나의 코딩 스타일을 학습하는 개인화 AI' },
      { name: 'Synthesia', version: 'Studio', provider: 'Synthesia', description: '텍스트 입력만으로 AI 아바타 영상 제작' },
      { name: 'ElevenLabs', version: 'V2', provider: 'ElevenLabs', description: '가장 사실적인 AI 음성 합성 및 목소리 복제' },
      { name: 'Suno', version: 'V3', provider: 'Suno', description: '가사와 스타일 입력만으로 노래를 작곡' },
      { name: 'Zapier', version: 'AI', provider: 'Zapier', description: '코딩 없이 여러 앱을 연결해 업무를 자동화' },
      { name: 'Canva', version: 'Magic Studio', provider: 'Canva', description: 'AI로 누구나 쉽게 전문가 수준의 디자인' },
    ]).select();
    if (modelError) throw modelError;
    console.log('Seeded ai_models.');

    // --- ID 맵 생성 ---
    const categoryMap = seededCategories.reduce((map, cat) => { map[cat.name] = cat.id; return map; }, {});
    const modelMap = seededModels.reduce((map, model) => { map[model.name] = model.id; return map; }, {});
    
    // 3. guides (id 제거 및 ID 맵 사용)
    const guidesData = [
      {
        ai_model_name: "ChatGPT", title: "ChatGPT 완벽 활용 가이드", description: "가입부터 프롬프트 작성, 실제 활용 사례까지 ChatGPT의 모든 것을 알려드립니다.", category_name: "대화형 AI", image_url: "/placeholder.svg",
        content: `
  #### **1. ChatGPT란 무엇인가요? (소개 및 핵심 특징)**
  - **소개:** **ChatGPT**는 OpenAI가 개발한 대화형 인공지능 모델입니다. 인간과 매우 유사한 방식으로 텍스트를 이해하고 생성할 수 있어, 단순 정보 검색부터 복잡한 문서 작성, 창의적인 아이디어 구상, 코딩까지 다양한 작업을 수행할 수 있습니다.
  - **개발사:** OpenAI
  - **핵심 특징:**
      - **뛰어난 언어 능력:** 문맥을 이해하고, 복잡한 질문에 논리적으로 답변하며, 다양한 스타일의 글을 생성합니다.
      - **방대한 지식:** 인터넷의 광범위한 데이터를 학습하여 거의 모든 주제에 대해 깊이 있는 정보를 제공합니다.
      - **다재다능함 (Versatility):** 글쓰기, 코딩, 번역, 요약, 아이디어 생성 등 활용 분야가 무궁무진합니다.
      - **멀티모달 (GPT-4o):** 최신 버전은 텍스트뿐만 아니라 이미지, 음성까지 이해하고 상호작용할 수 있습니다.
  - **가격 정책:**
      - **무료 버전 (GPT-3.5, GPT-4o 일부):** 기본적인 대화와 작업 수행이 가능하지만, 사용량 제한이 있을 수 있습니다.
      - **Plus (유료, 월 $20):** 더 뛰어난 성능의 최신 모델(GPT-4o)을 우선적으로 사용하며, 이미지 생성, 데이터 분석 등 고급 기능을 제한 없이 사용할 수 있습니다.
  #### **2. 초보자를 위한 시작하기 (Getting Started)**
  - **1. 회원가입:** [chat.openai.com](https://chat.openai.com) 에 접속하여 구글, 애플, 또는 이메일 계정으로 간편하게 가입합니다.
  - **2. 화면 구성:**
      - **채팅창 (중앙):** 이곳에 질문이나 명령(프롬프트)을 입력합니다.
      - **채팅 목록 (왼쪽):** 이전 대화 기록이 저장되어 언제든지 다시 이어서 대화를 나눌 수 있습니다.
  - **3. 첫 프롬프트 입력:** 채팅창에 간단한 질문을 입력하고 Enter 키를 눌러보세요. 예를 들어, "AIHub 프로젝트에 대한 블로그 글 아이디어 5개만 추천해줘" 라고 입력해보세요. ChatGPT가 즉시 답변을 생성하는 것을 확인할 수 있습니다.
  #### **3. 프로처럼 쓰는 법 (프롬프트 엔지니어링)**
  - **핵심 원칙:** ChatGPT의 성능은 사용자의 질문(프롬프트) 수준에 따라 크게 달라집니다. 좋은 답변을 얻기 위한 4가지 핵심 원칙(**R-C-T-F**)을 기억하세요.
  - **1. 역할 부여 (Role):** ChatGPT에게 특정 전문가의 역할을 부여하면, 그에 맞는 전문적인 답변을 생성합니다.
      - **Bad:** \`AIHub 마케팅 문구 써줘.\`
      - **Good:** \`너는 20년 경력의 IT 전문 마케터야. AIHub 서비스의 핵심 가치를 담아, 잠재 고객을 사로잡을 수 있는 광고 헤드라인 3개를 작성해줘.\`
  - **2. 맥락 제공 (Context):** 내가 처한 상황과 배경을 구체적으로 설명하면, 더 정확하고 개인화된 답변을 얻을 수 있습니다.
      - **Bad:** \`파이썬 코드 에러 고쳐줘.\`
      - **Good:** \`나는 지금 파이썬으로 웹 스크래핑 코드를 짜고 있어. 아래 코드에서 'requests' 라이브러리를 사용해 특정 URL의 데이터를 가져오려는데, 자꾸 403 Forbidden 에러가 발생해. 원인이 뭘까?\`
  - **3. 명확한 작업 지시 (Task):** 무엇을 원하는지 명확하고 단계별로 지시해야 합니다.
      - **Bad:** \`AI에 대해 설명해줘.\`
      - **Good:** \`AI의 역사에 대해 설명해줘. 1) 1950년대 초기 개념부터, 2) 튜링 테스트, 3) 딥러닝의 발전 순서로 나누어 각각 3문장 이내로 요약해줘.\`
  - **4. 형식 지정 (Format):** 원하는 결과물의 형식을 지정하면, 그대로 정리해서 보여줍니다.
      - **Bad:** \`경쟁사 분석해줘.\`
      - **Good:** \`AI 추천 서비스 시장의 경쟁사 3곳(A, B, C)을 분석해줘. 결과는 '회사명', '핵심 기능', '장점', '단점'을 컬럼으로 하는 마크다운 테이블 형식으로 정리해줘.\`
  #### **4. 실제 활용 사례 (Use Cases)**
  - **개발자:** 복잡한 알고리즘 구현 방법 질문, 코드 리팩토링 제안, 에러 메시지 분석 및 해결책 요청, 테스트 코드 자동 생성
  - **마케터:** 광고 카피, SNS 콘텐츠, 블로그 포스트, 이메일 뉴스레터 초안 작성, 타겟 고객 분석
  - **학생/연구원:** 어려운 논문 요약 및 핵심 개념 설명, 리포트 목차 구성, 발표 자료 아이디어 구상
  - **일상:** 해외 여행 계획 세우기, 이사 체크리스트 작성, 연말정산 방법 질문, 복잡한 보험 약관 쉽게 풀어서 설명 요청
  `
      },
      {
        ai_model_name: "Gemini", title: "Google Gemini 시작하기", description: "Google 검색과 연동되는 강력한 AI, Gemini의 기초부터 고급 활용법까지 알아봅니다.", category_name: "대화형 AI", image_url: "/placeholder.svg",
        content: `
  #### **1. Gemini란 무엇인가요? (소개 및 핵심 특징)**
  - **소개:** **Gemini**는 Google이 개발한 차세대 멀티모달 인공지능 모델입니다. 텍스트, 이미지, 오디오, 비디오 등 다양한 유형의 정보를 동시에 이해하고 처리할 수 있도록 설계되어, 복잡한 추론과 창의적인 작업에 강점을 보입니다.
  - **개발사:** Google
  - **핵심 특징:**
      - **멀티모달 네이티브:** 처음부터 텍스트, 이미지, 코드 등 다양한 데이터를 함께 학습하여, 유형에 관계없이 정보를 통합적으로 이해하고 추론합니다.
      - **강력한 추론 능력:** 방대한 데이터와 복잡한 코드 기반의 정보를 분석하고, 논리적인 문제 해결 능력이 뛰어납니다.
      - **Google 생태계 연동:** Google 검색의 최신 정보에 실시간으로 접근할 수 있으며, Google Workspace(Docs, Sheets 등)와 연동하여 생산성을 극대화할 수 있습니다.
      - **긴 컨텍스트 처리 (1.5 Pro):** 최대 100만 토큰에 달하는 방대한 양의 정보를 한 번에 처리하여, 긴 문서나 코드베이스 전체를 이해하고 요약, 분석하는 데 탁월합니다.
  - **가격 정책:**
      - **무료 버전 (Gemini 1.5 Pro 일부):** 강력한 성능의 모델을 무료로 체험할 수 있으며, 사용량에 일부 제한이 있습니다.
      - **Advanced (유료, Google One AI Premium):** 가장 뛰어난 성능의 모델을 사용하며, Google Docs, Sheets 등에서 AI 기능을 확장하여 사용할 수 있습니다.
  #### **2. 초보자를 위한 시작하기 (Getting Started)**
  - **1. 접속:** [gemini.google.com](https://gemini.google.com) 에 접속하여 Google 계정으로 로그인합니다. 별도의 회원가입이 필요 없습니다.
  - **2. 화면 구성:** ChatGPT와 유사한 직관적인 인터페이스를 가지고 있습니다. 중앙의 입력창에 프롬프트를 입력하고, 왼쪽에서 이전 대화 기록을 관리할 수 있습니다.
  - **3. 파일 업로드:** Gemini의 가장 큰 장점 중 하나는 파일 업로드 기능입니다. 이미지, 오디오 파일, PDF 문서 등을 직접 업로드하고 관련 질문을 할 수 있습니다. 예를 들어, 회의록 PDF를 올리고 "이 회의의 핵심 결정사항 3가지를 요약해줘" 라고 요청해보세요.
  #### **3. 프로처럼 쓰는 법 (Gemini 활용 팁)**
  - **1. 최신 정보와 결합하기:** Gemini는 Google 검색과 연동되어 실시간 정보에 접근할 수 있습니다.
      - **Good:** \`최근 발표된 애플의 실적 보고서를 요약하고, 주가에 미칠 영향에 대해 분석해줘.\`
  - **2. 이미지와 텍스트를 함께 질문하기:** 복잡한 다이어그램이나 그래프 이미지를 업로드하고, 그 의미를 텍스트로 질문하여 분석을 요청할 수 있습니다.
      - **Good:** \`(스마트폰 판매량 그래프 이미지를 올린 후) 이 그래프를 분석하고, A사와 B사의 시장 점유율 변화에 대한 원인을 설명해줘.\`
  - **3. 긴 문서나 코드 요약/분석 (1.5 Pro):** 수백 페이지의 논문이나 복잡한 소스코드 전체를 업로드하고 핵심 내용을 파악하거나 개선점을 찾을 수 있습니다.
      - **Good:** \`(100페이지 분량의 PDF 논문을 올린 후) 이 논문의 연구 방법론과 핵심 결론을 각각 5줄로 요약해줘.\`
      - **Good:** \`(프로젝트 전체 코드를 압축해서 올린 후) 이 코드베이스에서 잠재적인 성능 병목 현상을 일으킬 수 있는 부분을 찾아주고, 개선 방안을 제안해줘.\`
  - **4. Google Workspace 확장 프로그램 활용:** 유료 버전을 사용한다면, Gmail에서 메일 초안을 작성하거나, Google Docs에서 글의 스타일을 바꾸는 등 다양한 생산성 작업을 자동화할 수 있습니다.
  #### **4. 실제 활용 사례 (Use Cases)**
  - **개발자:** 전체 코드베이스를 기반으로 한 리팩토링 제안, API 문서 분석 및 사용 예제 코드 생성, 복잡한 시스템 아키텍처 설계
  - **기획자/분석가:** 시장 조사 보고서, 사용자 피드백 등 대량의 텍스트 데이터를 분석하고 인사이트 도출, 이미지로 된 설문조사 결과 분석
  - **콘텐츠 제작자:** 영상 스크립트를 기반으로 한 요약본 및 블로그 글 생성, 이미지 콘텐츠에 대한 설명 텍스트 자동 생성
  - **학생:** 강의 전체 녹음 파일을 올리고 핵심 내용 요약, 복잡한 과학 다이어그램에 대한 설명 요청
  `
      },
    ];

    const guidesToSeed = guidesData.map(g => ({
        ai_model_id: modelMap[g.ai_model_name],
        title: g.title,
        description: g.description,
        category_id: categoryMap[g.category_name],
        author_id: authorId,
        image_url: g.image_url,
        content: g.content,
    }));

    const { error: guideError } = await supabase.from('guides').insert(guidesToSeed);
    if (guideError) throw guideError;
    console.log('Seeded guides.');

    // 4. use_cases (id 제거 및 ID 맵 사용)
    const useCasesToSeed = [
        { category_name: '코딩 / 개발', situation: '코딩하다 막혔을 때 🤯', summary: '복잡한 에러, 새로운 로직 구현... 전문가의 도움이 필요하다면?' },
        { category_name: '코딩 / 개발', situation: '새 프로젝트를 시작할 때 🏗️', summary: '기술 스택 선정부터 전체 아키텍처 설계까지, 막막하다면?' },
        { category_name: '글쓰기 / 생산성', situation: '블로그, 리포트 초안을 쓸 때 📝', summary: '글의 뼈대를 잡고, 자연스러운 문장으로 내용을 채우고 싶다면?' },
    ].map(uc => ({
        category_id: categoryMap[uc.category_name],
        situation: uc.situation,
        summary: uc.summary,
    }));
    const { data: seededUseCases, error: useCaseError } = await supabase.from('use_cases').insert(useCasesToSeed).select();
    if (useCaseError) throw useCaseError;
    console.log('Seeded use_cases.');
    
    // --- Use Case ID 맵 생성 ---
    const useCaseMap = seededUseCases.reduce((map, uc) => { map[uc.situation] = uc.id; return map; }, {});

    // 5. recommendations (ID 맵 사용)
    const recommendationsToSeed = [
        { use_case_situation: '코딩하다 막혔을 때 🤯', ai_model_name: 'GitHub Copilot', reason: 'IDE와 통합되어 코드의 맥락을 이해하고 즉시 해결책을 제안합니다.' },
        { use_case_situation: '새 프로젝트를 시작할 때 🏗️', ai_model_name: 'Claude', reason: '방대한 문서를 한 번에 이해하고, 체계적인 구조를 제안하는 데 탁월!' },
        { use_case_situation: '블로그, 리포트 초안을 쓸 때 📝', ai_model_name: 'Notion AI', reason: '창의적이고 완성도 높은 긴 글 생성에 강점을 보입니다!' },
    ].map(r => ({
        use_case_id: useCaseMap[r.use_case_situation],
        ai_model_id: modelMap[r.ai_model_name],
        reason: r.reason
    }));
    const { error: recError } = await supabase.from('recommendations').insert(recommendationsToSeed);
    if (recError) throw recError;
    console.log('Seeded recommendations.');
    
    // 6. posts (id 제거)
    const postsToSeed = [
      { title: 'AI 추천해주는 사이트 어디가 좋나요?', content: '참고할 만한 다른 좋은 사이트가 있을까요?', author_id: authorId },
      { title: 'Vite + React에서 Supabase 연동 질문', content: 'RLS를 켜니 데이터가 안 불러와집니다.', author_id: authorId },
    ];
    const { error: postError } = await supabase.from('posts').insert(postsToSeed);
    if (postError) throw postError;
    console.log('Seeded posts.');
    
    console.log('✅ Seeding finished successfully!');

  } catch (error) {
    console.error('🔴 An error occurred during seeding:', error);
  }
};

seedDatabase();