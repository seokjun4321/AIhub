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
  console.log('Start seeding...');

  // --- 1. 사용자(Profiles) 확인 ---
  const { data: users, error: userError } = await supabase.from('profiles').select('id, username');
  if (userError || !users || users.length === 0) {
    console.error('🔴 Error: No users found in "profiles" table.');
    console.log('🔵 Please sign up at least one user in your application before seeding.');
    return; // 사용자가 없으면 스크립트 중단
  }
  console.log(`✅ Found ${users.length} user(s). Seeding will proceed.`);
  const authorId = users[0].id; // 첫 번째 사용자를 모든 콘텐츠의 저자로 지정

  // --- 2. ai_families ---
  await supabase.from('ai_families').upsert([
    { id: 1, name: 'ChatGPT', provider: 'OpenAI' },
    { id: 2, name: 'Gemini', provider: 'Google' },
    { id: 3, name: 'Claude', provider: 'Anthropic' },
  ]);
  console.log('Seeded ai_families.');

  // --- 3. ai_models ---
  await supabase.from('ai_models').upsert([
    { id: 101, family_id: 1, version_name: '4o', full_name: 'ChatGPT 4o' },
    { id: 202, family_id: 2, version_name: 'Advanced', full_name: 'Gemini Advanced' },
    { id: 301, family_id: 3, version_name: '3 Opus', full_name: 'Claude 3 Opus' },
  ]);
  console.log('Seeded ai_models.');

  // --- 4. guides (ai_model_id 참조) ---
  await supabase.from('guides').upsert([
    { id: 1, title: 'ChatGPT 초보자를 위한 완벽 가이드', description: '가입부터 프롬프트 작성까지 모든 것을 알려드립니다.', category: '기초', author: 'AIHub 에디터', ai_model_id: 101, imageUrl: "/placeholder.svg" },
    { id: 2, title: 'Gemini Advanced를 활용한 고급 디버깅 기술', description: '코드 자동 완성부터 디버깅까지, 개발 생산성을 2배로 높여보세요.', category: '웹개발', author: '웹돌이', ai_model_id: 202, imageUrl: "/placeholder.svg" },
  ]);
  console.log('Seeded guides.');

  // --- 5. use_cases ---
  await supabase.from('use_cases').upsert([
      { id: 1, category: '개발', situation: '코딩하다 막혔을 때 🤯', summary: '복잡한 에러, 새로운 로직 구현... 전문가의 도움이 필요하다면?' },
      { id: 2, category: '개발', situation: '새 프로젝트를 시작할 때 🏗️', summary: '기술 스택 선정부터 전체 아키텍처 설계까지, 막막하다면?' },
      { id: 3, category: '글쓰기', situation: '블로그, 리포트 초안을 쓸 때 📝', summary: '글의 뼈대를 잡고, 자연스러운 문장으로 내용을 채우고 싶다면?' },
  ]);
  console.log('Seeded use_cases.');

  // --- 6. recommendations ---
  await supabase.from('recommendations').upsert([
    { use_case_id: 1, ai_model_id: 202, reason: '뛰어난 논리력과 방대한 코드로 복잡한 문제 해결에 최적화!' },
    { use_case_id: 2, ai_model_id: 301, reason: '방대한 문서를 한 번에 이해하고, 체계적인 구조를 제안하는 데 탁월!' },
    { use_case_id: 3, ai_model_id: 101, reason: '창의적이고 완성도 높은 긴 글 생성에 강점을 보입니다!' },
  ]);
  console.log('Seeded recommendations.');
  
  // --- 7. posts (커뮤니티) ---
  await supabase.from('posts').upsert([
    { id: 1, title: 'AI 추천해주는 사이트 어디가 좋나요?', content: '참고할 만한 다른 좋은 사이트가 있을까요?', author_id: authorId },
    { id: 2, title: 'Vite + React에서 Supabase 연동 질문', content: 'RLS를 켜니 데이터가 안 불러와집니다.', author_id: authorId },
  ]);
  console.log('Seeded posts.');
  
  console.log('✅ Seeding finished successfully!');
};

seedDatabase();