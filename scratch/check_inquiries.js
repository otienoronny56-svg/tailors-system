const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const url = configText.match(/supabaseUrl:\s*['\"]([^'\"]+)['\"]/)[1];
const key = configText.match(/serviceRoleKey:\s*['\"]([^'\"]+)['\"]/)[1];

const supabase = createClient(url, key);

async function check() {
    const { data: inqs, error: inqErr } = await supabase.from('marketplace_inquiries').select('*').order('created_at', { ascending: false }).limit(5);
    if (inqErr) console.error("Inq Error:", inqErr);
    else console.log("LATEST INQUIRIES:", JSON.stringify(inqs, null, 2));

    const { data: msgs, error: msgErr } = await supabase.from('messages').select('*').order('created_at', { ascending: false }).limit(5);
    if (msgErr) console.error("Msg Error:", msgErr);
    else console.log("LATEST MESSAGES:", JSON.stringify(msgs, null, 2));
}
check();
