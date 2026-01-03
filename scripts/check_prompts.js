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

const checkPrompts = async () => {
    const guideId = 14;

    // 1. Get step IDs
    const { data: steps } = await supabase
        .from('guide_steps')
        .select('id, content')
        .eq('guide_id', guideId);

    if (!steps || steps.length === 0) {
        console.log('No steps found.');
        return;
    }

    const stepIds = steps.map(s => s.id);

    // 2. Check guide_prompts
    const { data: prompts } = await supabase
        .from('guide_prompts')
        .select('*')
        .in('step_id', stepIds);

    console.log(`Found ${prompts?.length || 0} prompts in guide_prompts table.`);
    if (prompts && prompts.length > 0) {
        console.log('Sample prompt:', prompts[0]);
    }

    // 3. Check for specific keywords in markdown content
    const stepsWithMarkdownPrompts = steps.filter(s =>
        s.content && (s.content.includes('Prompt') || s.content.includes('프롬프트'))
    );

    console.log(`Found ${stepsWithMarkdownPrompts.length} steps with 'Prompt' or '프롬프트' in markdown content.`);
    if (stepsWithMarkdownPrompts.length > 0) {
        console.log('Sample markdown content (first 200 chars):', stepsWithMarkdownPrompts[0].content.substring(0, 200));
    }
};

checkPrompts();
