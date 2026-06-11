const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (!urlMatch || !keyMatch) {
    console.error("Could not load config keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function checkMessageKeys() {
    const { data } = await supabase.from('messages').select('*').limit(1);
    if (data && data[0]) {
        console.log("Keys returned by Supabase:", Object.keys(data[0]));
        console.log("Message example:", data[0]);
    } else {
        console.log("No messages found.");
    }
}
checkMessageKeys();
