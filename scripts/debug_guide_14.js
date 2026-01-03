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

const debugGuide14 = async () => {
    const { data, error } = await supabase
        .from('guides')
        .select('requirements, core_principles')
        .eq('id', 14)
        .single();

    if (error) console.error(error);
    else console.log(JSON.stringify(data, null, 2));
};

debugGuide14();
