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

async function checkInqMessages() {
    const inqId = '9138a931-505d-4574-8897-5115f89c3c7a';
    console.log(`Querying messages for inquiry_id = ${inqId}...`);
    const { data, error } = await supabase
        .from('messages')
        .select('*')
        .eq('inquiry_id', inqId)
        .order('created_at', { ascending: true });
    
    if (error) {
        console.error("Error:", error);
    } else {
        console.log(`Found ${data.length} messages:`);
        data.forEach(m => {
            console.log(`[${m.created_at}] Sender: ${m.sender_id} -> Recipient: ${m.recipient_id} : ${m.message_text}`);
        });
    }
}

checkInqMessages();
