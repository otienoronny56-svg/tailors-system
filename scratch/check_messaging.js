const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function main() {
    console.log("\n=== 1. Recent marketplace_inquiries ===");
    const { data: inqs, error: e1 } = await supabase
        .from('marketplace_inquiries')
        .select('id, client_name, client_email, shop_id, created_at')
        .order('created_at', { ascending: false })
        .limit(5);
    if (e1) console.error('Error:', e1.message);
    else console.table(inqs);

    console.log("\n=== 2. Recent messages ===");
    const { data: msgs, error: e2 } = await supabase
        .from('messages')
        .select('id, inquiry_id, sender_id, recipient_id, message_text, created_at')
        .order('created_at', { ascending: false })
        .limit(10);
    if (e2) console.error('Error:', e2.message);
    else console.table(msgs);

    console.log("\n=== 3. user_profiles (owners/clients) ===");
    const { data: profiles, error: e3 } = await supabase
        .from('user_profiles')
        .select('id, role, email, shop_id, organization_id, full_name')
        .limit(10);
    if (e3) console.error('Error:', e3.message);
    else console.table(profiles);

    console.log("\n=== 4. Shops ===");
    const { data: shops, error: e4 } = await supabase
        .from('shops')
        .select('id, name, organization_id')
        .limit(5);
    if (e4) console.error('Error:', e4.message);
    else console.table(shops);
}

main().catch(console.error);
