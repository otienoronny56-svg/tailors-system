const { createClient } = require('@supabase/supabase-js');

const sb = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function main() {
    // 1. Check all inquiries and their client_email values
    console.log("\n=== All marketplace_inquiries ===");
    const { data: inqs, error: e1 } = await sb
        .from('marketplace_inquiries')
        .select('id, client_name, client_email, shop_id, created_at')
        .order('created_at', { ascending: false })
        .limit(15);
    if (e1) console.error(e1.message);
    else {
        inqs.forEach(i => console.log(`  ${i.client_name} | email: "${i.client_email}" | shop: ${i.shop_id}`));
    }

    // 2. Check auth.users emails
    console.log("\n=== auth.users emails ===");
    const { data: { users }, error: e2 } = await sb.auth.admin.listUsers();
    if (e2) console.error(e2.message);
    else {
        users.forEach(u => console.log(`  id: ${u.id} | email: "${u.email}" | provider: ${u.app_metadata?.provider}`));
    }

    // 3. Cross-check: find inquiries where client_email matches a real auth user
    console.log("\n=== Email match check ===");
    if (inqs && users) {
        const authEmails = users.map(u => u.email?.toLowerCase());
        inqs.forEach(inq => {
            const match = authEmails.includes(inq.client_email?.toLowerCase());
            console.log(`  "${inq.client_email}" → ${match ? '✅ MATCHES auth user' : '❌ NO auth user match'}`);
        });
    }

    // 4. Check RLS enabled on table
    console.log("\n=== RLS check via pg_tables ===");
    const { data: rls, error: e3 } = await sb.rpc('exec_sql', { 
        query: "SELECT tablename, rowsecurity FROM pg_tables WHERE schemaname='public' AND tablename IN ('marketplace_inquiries','messages','shops','user_profiles')"
    });
    if (e3) console.log("No exec_sql RPC (expected). Skipping RLS meta-check.");
    else console.table(rls);
}

main().catch(console.error);
