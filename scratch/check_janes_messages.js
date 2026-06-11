const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const url = configText.match(/supabaseUrl:\s*['\"]([^'\"]+)['\"]/)[1];
const key = configText.match(/serviceRoleKey:\s*['\"]([^'\"]+)['\"]/)[1];

const supabase = createClient(url, key);

async function check() {
    const { data: msgs, error } = await supabase
        .from('messages')
        .select('*')
        .eq('sender_id', 'f42cda7c-a018-438e-8ee9-ee817640d087');
    if (error) console.error(error);
    else console.log("JANE'S MESSAGES:", JSON.stringify(msgs, null, 2));
}
check();
