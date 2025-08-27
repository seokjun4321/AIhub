// seed.js
import { createClient } from '@supabase/supabase-js';
import 'dotenv/config'; // .env 파일을 읽기 위해 필요

// .env 파일에서 Supabase 정보를 가져옵니다.
const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_PUBLISHABLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error("Supabase URL or Key is missing in .env file");
}

const supabase = createClient(supabaseUrl, supabaseKey);

const guidesToSeed = [
  {
    title: "ChatGPT 초보자를 위한 완벽 가이드",
    description: "가입부터 프롬프트 작성, 실제 활용 사례까지 모든 것을 알려드립니다.",
    category: "기초",
    author: "AIHub 에디터",
    imageUrl: "/placeholder.svg"
  },
  {
    title: "Midjourney로 10분 만에 실사 이미지 만들기",
    description: "상상하는 모든 것을 현실적인 이미지로 만드는 비법을 배워보세요.",
    category: "이미지 생성",
    author: "김석준",
    imageUrl: "/placeholder.svg"
  },
  {
    title: "개발자를 위한 GitHub Copilot 활용법",
    description: "코드 자동 완성부터 디버깅까지, 개발 생산성을 2배로 높여보세요.",
    category: "코딩",
    author: "AI 전문가",
    imageUrl: "/placeholder.svg"
  },
  {
    title: "웹 개발을 위한 lovable.dev 활용법",
    description: "코드 자동 완성부터 디버깅까지, 개발 생산성을 2배로 높여보세요.",
    category: "웹개발",
    author: "웹돌이",
    imageUrl: "/placeholder.svg"
  },
];

const seedDatabase = async () => {
  console.log('Seeding database...');

  // 기존 데이터를 모두 삭제합니다 (선택사항).
  const { error: deleteError } = await supabase.from('guides').delete().neq('id', 0);
  if (deleteError) {
    console.error('Error deleting existing data:', deleteError);
    return;
  }
  console.log('Existing data deleted.');

  // 새로운 데이터를 한 번에 insert 합니다.
  const { data, error } = await supabase.from('guides').insert(guidesToSeed);

  if (error) {
    console.error('Error seeding data:', error);
  } else {
    console.log('Database seeded successfully!');
  }
};

seedDatabase();