const { createClient } = require('@supabase/supabase-js');

const sb = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

// Simulate exactly what client-dashboard.html does with anonKey (client session)
const anonSb = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MTYyNDUsImV4cCI6MjA4OTQ5MjI0NX0.l5diE9bfcRQo8ZSMsAx-alG89GFifGA11hA059zDhXM"
);

async function main() {
    // Test 1: simple select without joins (does RLS block?)
    console.log("\n=== TEST 1: marketplace_inquiries without join (anon) ===");
    const { data: t1, error: e1 } = await anonSb
        .from('marketplace_inquiries')
        .select('id, client_name, client_email')
        .eq('client_email', 'janeogwanganyango@gmail.com');
    console.log("Result:", e1 ? `❌ ERROR: ${e1.message}` : `Got ${t1?.length} rows`);

    // Test 2: with shops join (does shops RLS block the join?)
    console.log("\n=== TEST 2: marketplace_inquiries WITH shops join (anon) ===");
    const { data: t2, error: e2 } = await anonSb
        .from('marketplace_inquiries')
        .select('id, client_name, shops(id, name, profile_image)')
        .eq('client_email', 'janeogwanganyango@gmail.com');
    console.log("Result:", e2 ? `❌ ERROR: ${e2.message}` : `Got ${t2?.length} rows | shops join: ${JSON.stringify(t2?.[0]?.shops)}`);

    // Test 3: with marketplace_listings join
    console.log("\n=== TEST 3: marketplace_inquiries WITH marketplace_listings join (anon) ===");
    const { data: t3, error: e3 } = await anonSb
        .from('marketplace_inquiries')
        .select('id, client_name, marketplace_listings(title)')
        .eq('client_email', 'janeogwanganyango@gmail.com');
    console.log("Result:", e3 ? `❌ ERROR: ${e3.message}` : `Got ${t3?.length} rows | listings join: ${JSON.stringify(t3?.[0]?.marketplace_listings)}`);

    // Test 4: the EXACT query from client-dashboard.html
    console.log("\n=== TEST 4: EXACT query from client-dashboard.html (anon) ===");
    const { data: t4, error: e4 } = await anonSb
        .from('marketplace_inquiries')
        .select('*, shops(id, name, profile_image, location_name), marketplace_listings(title, image_urls)')
        .eq('client_email', 'janeogwanganyango@gmail.com');
    console.log("Result:", e4 ? `❌ ERROR: ${e4.message} | CODE: ${e4.code} | HINT: ${e4.hint}` : `Got ${t4?.length} rows`);

    // Test 5: Check marketplace_listings table directly
    console.log("\n=== TEST 5: marketplace_listings direct query (anon) ===");
    const { data: t5, error: e5 } = await anonSb
        .from('marketplace_listings')
        .select('id, title, status')
        .limit(3);
    console.log("Result:", e5 ? `❌ ERROR: ${e5.message}` : `Got ${t5?.length} rows`);
    
    // Test 6: Check messages table (anon)
    console.log("\n=== TEST 6: messages direct query (anon) ===");
    const { data: t6, error: e6 } = await anonSb
        .from('messages')
        .select('id')
        .limit(3);
    console.log("Result:", e6 ? `❌ ERROR: ${e6.message}` : `Got ${t6?.length} rows`);
}

main().catch(console.error);
