const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], { auth: { persistSession: false } });

async function getMsgs() {
    const { data: profile } = await supabase.from('user_profiles').select('id').eq('email', 'titusombese@gmail.com').single();
    if (!profile) return console.log("No profile");
    
    const { data: messages, error } = await supabase
        .from('messages')
        .select('*')
        .or(`sender_id.eq.${profile.id},recipient_id.eq.${profile.id}`)
        .order('created_at', { ascending: true });

    if (error) console.error(error);
    else messages.forEach(m => console.log(m.message_text));
}
getMsgs();
