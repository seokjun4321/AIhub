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

const deletePrompts = async () => {
    const guideId = 14;
    console.log('Fetching steps for guide 14...');

    const { data: steps } = await supabase
        .from('guide_steps')
        .select('id')
        .eq('guide_id', guideId);

    if (!steps || steps.length === 0) {
        console.log('No steps found.');
        return;
    }

    const stepIds = steps.map(s => s.id);
    console.log('Target step IDs:', stepIds);

    const { data: deleted, error } = await supabase
        .from('guide_prompts')
        .delete()
        .in('step_id', stepIds)
        .select();

    if (error) {
        console.error('Error deleting prompts:', error);
    } else {
        console.log(`Successfully deleted ${deleted?.length || 0} prompts.`);
    }
};

deletePrompts();
