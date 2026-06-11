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

async function checkInquiries() {
    try {
        console.log("--- Marketplace Inquiries ---");
        const { data: inqs, error: inqErr } = await supabase
            .from('marketplace_inquiries')
            .select('id, client_name, client_email, client_phone, message, created_at, shop_id');
        if (inqErr) throw inqErr;
        console.table(inqs);

        console.log("--- Latest 10 Messages ---");
        const { data: msgs, error: msgErr } = await supabase
            .from('messages')
            .select('id, inquiry_id, sender_id, recipient_id, message_text, created_at')
            .order('created_at', { ascending: false })
            .limit(10);
        if (msgErr) throw msgErr;
        console.table(msgs);

    } catch (err) {
        console.error("Error checking database:", err.message);
    }
}

checkInquiries();
