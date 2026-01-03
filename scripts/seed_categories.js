import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false }
});

const seedCategories = async () => {
    const categories = [
        { name: '글쓰기 & 교정', description: '에세이, 리포트, 논문 작성 및 교정' },
        { name: '취업 준비', description: '이력서, 자소서, 면접 준비' },
        { name: '연구 & 학습', description: '자료 조사, 개념 학습, 요약' },
        { name: '개발 & 코딩', description: '코드 작성, 디버깅, 아키텍처 설계' },
        { name: '콘텐츠 제작', description: '영상, 이미지, 블로그 포스팅' } // Added extra for Guide 14
    ];

    console.log('Seeding categories...');

    for (const cat of categories) {
        // Check if exists
        const { data: existing } = await supabase
            .from('categories')
            .select('id')
            .eq('name', cat.name)
            .single();

        if (!existing) {
            const { data, error } = await supabase
                .from('categories')
                .insert(cat)
                .select()
                .single();

            if (error) console.error(`Error creating ${cat.name}:`, error);
            else console.log(`Created category: ${cat.name} (${data.id})`);
        } else {
            console.log(`Category exists: ${cat.name} (${existing.id})`);
        }
    }

    // Assign Guides
    // Guide 13: Essay -> 글쓰기 & 교정
    await updateGuideCategory(13, '글쓰기 & 교정');

    // Guide 14: Video -> 콘텐츠 제작
    await updateGuideCategory(14, '콘텐츠 제작');

    // Guide 10, 11: Foundation -> 연구 & 학습 (temporary)
    await updateGuideCategory(10, '연구 & 학습');
    await updateGuideCategory(11, '연구 & 학습');

    // Guide 15: Prompt Eng -> 연구 & 학습
    await updateGuideCategory(15, '연구 & 학습');

    console.log('Done.');
};

async function updateGuideCategory(guideId, categoryName) {
    const { data: cat } = await supabase
        .from('categories')
        .select('id')
        .eq('name', categoryName)
        .single();

    if (cat) {
        const { error } = await supabase
            .from('guides')
            .update({ category_id: cat.id })
            .eq('id', guideId);

        if (error) console.error(`Failed to update guide ${guideId}:`, error);
        else console.log(`Updated guide ${guideId} to ${categoryName}`);
    }
}

seedCategories();
