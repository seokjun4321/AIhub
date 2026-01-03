import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
    console.error("Supabase URL or Key is missing in .env file");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
    auth: { autoRefreshToken: false, persistSession: false }
});

const updateMetadata = async () => {
    try {
        console.log('Start updating metadata for Guide 14...');

        const guideId = 14;
        const requirements = [
            "ChatGPT 계정",
            "Kling AI 계정 (무료)",
            "Hailuo AI 계정 (무료)",
            "영상 편집 프로그램 (CapCut 등)"
        ];
        const corePrinciples = [
            "AI는 도구일 뿐, 감독은 나다",
            "프롬프트는 한 번에 완벽할 수 없다 (반복 개선)",
            "기술보다 스토리가 중요하다"
        ];

        const { error } = await supabase
            .from('guides')
            .update({
                requirements: requirements,
                core_principles: corePrinciples
            })
            .eq('id', guideId);

        if (error) {
            console.error('Error updating guide metadata:', error);
        } else {
            console.log('Successfully updated requirements and core_principles for Guide 14.');
        }

    } catch (err) {
        console.error('Update failed:', err);
    }
};

updateMetadata();
