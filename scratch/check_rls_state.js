const { createClient } = require('@supabase/supabase-js');

// Use service role to check what's in the table
const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function main() {
    console.log("\n=== marketplace_inquiries (all, service role) ===");
    const { data: inqs, error } = await supabase
        .from('marketplace_inquiries')
        .select('id, client_name, client_email, shop_id, created_at')
        .order('created_at', { ascending: false })
        .limit(10);
    if (error) console.error('Error:', error.message);
    else console.table(inqs);

    // Test with anon key (simulates what a logged-in client sees via RLS)
    console.log("\n=== Testing with anon key (simulates client RLS) ===");
    const anonClient = createClient(
        "https://ouuhirckiavcvgqlpriw.supabase.co",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MTYyNDUsImV4cCI6MjA4OTQ5MjI0NX0.l5diE9bfcRQo8ZSMsAx-alG89GFifGA11hA059zDhXM"
    );
    const { data: anonInqs, error: anonErr } = await anonClient
        .from('marketplace_inquiries')
        .select('id, client_name, client_email')
        .limit(5);
    console.log("Anon result:", anonErr ? `ERROR: ${anonErr.message}` : `Got ${anonInqs?.length} rows`);

    console.log("\n=== messages table (all, service role) ===");
    const { data: msgs, error: msgErr } = await supabase
        .from('messages')
        .select('id, sender_id, recipient_id, message_text, created_at')
        .order('created_at', { ascending: false })
        .limit(5);
    if (msgErr) console.error('Error:', msgErr.message);
    else console.table(msgs);
}

main().catch(console.error);
