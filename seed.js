// seed.js
import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

// .env 파일에서 Supabase 정보를 가져옵니다.
const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("Supabase URL or Key is missing in .env file");
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

// --- 가이드 시딩 함수 ---
const seedGuides = async () => {
    console.log('Seeding guides...');
    
    // 1. 가이드 데이터를 함수 안으로 이동 (더 좋은 구조)
    const guidesToSeed = [
      {
        title: "ChatGPT 초보자를 위한 완벽 가이드",
        description: "가입부터 프롬프트 작성, 실제 활용 사례까지 모든 것을 알려드립니다.",
        category: "기초",
        author: "AIHub 에디터",
        imageUrl: "/placeholder.svg",
        content: "🚀 ChatGPT 초보자를 위한 완벽 가이드"
      },
      {
        title: "웹 개발을 위한 lovable.dev 활용법",
        description: "코드 자동 완성부터 디버깅까지, 개발 생산성을 2배로 높여보세요.",
        category: "웹개발",
        author: "웹돌이",
        imageUrl: "/placeholder.svg",
        content: "이 AI로 지금 보고 계시는 웹사이트도 만들었습니다."
      },
    ];

    const { error: deleteError } = await supabase.from('guides').delete().neq('id', 0);
    if (deleteError) {
        console.error('Error deleting existing guides:', deleteError);
        return;
    }
    console.log('Existing guides deleted.');

    const { error } = await supabase.from('guides').insert(guidesToSeed);
    if (error) {
        console.error('Error seeding guides:', error);
    } else {
        console.log('Guides seeded successfully!');
    }
}

// --- 커뮤니티 게시글 시딩 함수 ---
const seedPosts = async () => {
  console.log('Seeding posts...');

  const { data: users, error: userError } = await supabase.from('profiles').select('id, username');
  if (userError || !users || users.length === 0) {
    console.error('Error fetching users or no users found:', userError);
    console.log('Please sign up at least one user before seeding posts.');
    return;
  }
  console.log(`Found ${users.length} users to assign as authors.`);

  const postsToSeed = [
    {
      title: "AI 추천해주는 사이트 어디가 좋나요?",
      content: "제가 지금 AI 추천 사이트를 만들고 있는데, 참고할 만한 다른 좋은 사이트가 있을까요? 특히 UI가 깔끔한 곳이면 좋겠습니다.",
      author_id: users[Math.floor(Math.random() * users.length)].id,
      author_username: users[Math.floor(Math.random() * users.length)].username,
    },
    {
      title: "Vite + React에서 Supabase 연동 시 RLS 정책 질문",
      content: "Row Level Security를 켜니까 갑자기 데이터가 안 불러와집니다. SELECT 정책을 어떻게 설정해야 모든 사람이 글을 볼 수 있나요?",
      author_id: users[Math.floor(Math.random() * users.length)].id,
      author_username: users[Math.floor(Math.random() * users.length)].username,
    },
  ];

  const { error: deleteError } = await supabase.from('posts').delete().neq('id', 0);
  if (deleteError) {
    console.error('Error deleting existing posts:', deleteError);
    return;
  }
  console.log('Existing posts deleted.');

  const { error: insertError } = await supabase.from('posts').insert(postsToSeed);
  if (insertError) {
    console.error('Error seeding posts:', insertError);
  } else {
    console.log('Posts seeded successfully!');
  }
};

const seedDatabase = async () => {
  await seedGuides();
  await seedPosts();
};

seedDatabase();