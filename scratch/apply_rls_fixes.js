// Apply RLS fixes directly via Supabase REST API (using service role)
const https = require('https');

const SUPABASE_URL = 'https://ouuhirckiavcvgqlpriw.supabase.co';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA';

// All SQL statements to run (one at a time via RPC)
const statements = [
    // Fix marketplace_inquiries - allow clients to read their OWN inquiries
    `DROP POLICY IF EXISTS "Clients Read Own Inquiries" ON public.marketplace_inquiries`,
    `DROP POLICY IF EXISTS "Shop Owners Read Inquiries" ON public.marketplace_inquiries`,
    `DROP POLICY IF EXISTS "Anon Insert Inquiries" ON public.marketplace_inquiries`,
    `DROP POLICY IF EXISTS "Auth Insert Inquiries" ON public.marketplace_inquiries`,
    
    // Clients can read inquiries where their email matches
    `CREATE POLICY "Clients Read Own Inquiries" ON public.marketplace_inquiries FOR SELECT TO authenticated USING (client_email = (SELECT email FROM auth.users WHERE id = auth.uid()))`,
    
    // Shop owners/managers can read inquiries to their shops
    `CREATE POLICY "Shop Owners Read Inquiries" ON public.marketplace_inquiries FOR SELECT TO authenticated USING (EXISTS (SELECT 1 FROM public.shops s JOIN public.user_profiles up ON up.organization_id = s.organization_id WHERE s.id = shop_id AND up.id = auth.uid() AND up.role IN ('owner', 'manager', 'superadmin')))`,
    
    // Anyone can insert inquiries
    `DROP POLICY IF EXISTS "Anon Insert Inquiries" ON public.marketplace_inquiries`,
    `CREATE POLICY "Anon Insert Inquiries" ON public.marketplace_inquiries FOR INSERT TO anon WITH CHECK (true)`,
    `DROP POLICY IF EXISTS "Auth Insert Inquiries" ON public.marketplace_inquiries`,
    `CREATE POLICY "Auth Insert Inquiries" ON public.marketplace_inquiries FOR INSERT TO authenticated WITH CHECK (true)`,
    
    // Fix shops table RLS - allow all authenticated users to read shops
    `DROP POLICY IF EXISTS "Public Read Shops" ON public.shops`,
    `CREATE POLICY "Public Read Shops" ON public.shops FOR SELECT TO authenticated USING (true)`,
    `DROP POLICY IF EXISTS "Anon Read Shops" ON public.shops`,
    `CREATE POLICY "Anon Read Shops" ON public.shops FOR SELECT TO anon USING (true)`,
    
    // Fix user_profiles - allow all authenticated to read (needed for recipient lookup)
    `DROP POLICY IF EXISTS "Public Read Profiles" ON public.user_profiles`,
    `CREATE POLICY "Public Read Profiles" ON public.user_profiles FOR SELECT TO authenticated USING (true)`,
    
    // Fix messages RLS
    `DROP POLICY IF EXISTS "Users Insert Own Messages" ON public.messages`,
    `DROP POLICY IF EXISTS "Users Read Own Chat Threads" ON public.messages`,
    `DROP POLICY IF EXISTS "Superadmin Full Access Messages" ON public.messages`,
    `DROP POLICY IF EXISTS "Shop Owners Read Inquiry Messages" ON public.messages`,
    `CREATE POLICY "Users Insert Own Messages" ON public.messages FOR INSERT TO authenticated WITH CHECK (auth.uid() = sender_id)`,
    `CREATE POLICY "Users Read Own Chat Threads" ON public.messages FOR SELECT TO authenticated USING (auth.uid() = sender_id OR auth.uid() = recipient_id OR EXISTS (SELECT 1 FROM public.marketplace_inquiries mi JOIN public.shops s ON s.id = mi.shop_id JOIN public.user_profiles up ON up.organization_id = s.organization_id WHERE mi.id = messages.inquiry_id AND up.id = auth.uid() AND up.role IN ('owner', 'manager', 'superadmin')))`,
    `CREATE POLICY "Superadmin Full Access Messages" ON public.messages FOR ALL USING (EXISTS (SELECT 1 FROM public.user_profiles WHERE id = auth.uid() AND role = 'superadmin'))`,
];

function runSQL(sql) {
    return new Promise((resolve, reject) => {
        const body = JSON.stringify({ query: sql });
        const options = {
            hostname: 'ouuhirckiavcvgqlpriw.supabase.co',
            path: '/rest/v1/rpc/exec_sql',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'apikey': SERVICE_KEY,
                'Authorization': `Bearer ${SERVICE_KEY}`,
                'Content-Length': Buffer.byteLength(body)
            }
        };

        const req = https.request(options, res => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => resolve({ status: res.statusCode, body: data }));
        });
        req.on('error', reject);
        req.write(body);
        req.end();
    });
}

// Try using pg library or supabase admin SDK approach instead
const { createClient } = require('@supabase/supabase-js');
const sb = createClient(SUPABASE_URL, SERVICE_KEY);

async function main() {
    console.log("Attempting to apply RLS fixes via Supabase RPC...\n");
    
    // Check if exec_sql RPC exists
    const { data, error } = await sb.rpc('exec_sql', { query: "SELECT 1 as test" });
    if (error) {
        console.log("No exec_sql RPC available. You must run the SQL manually in Supabase.");
        console.log("\n=== COPY THIS SQL AND RUN IN SUPABASE SQL EDITOR ===");
        console.log("URL: https://supabase.com/dashboard/project/ouuhirckiavcvgqlpriw/sql/new\n");
        console.log(statements.join(';\n') + ';');
        return;
    }
    
    // Run each statement
    for (const sql of statements) {
        try {
            const { error: e } = await sb.rpc('exec_sql', { query: sql });
            if (e) {
                console.log(`⚠️  ${sql.substring(0, 60)}... → ${e.message}`);
            } else {
                console.log(`✅ ${sql.substring(0, 60)}...`);
            }
        } catch(err) {
            console.log(`❌ Error: ${err.message}`);
        }
    }
    console.log("\nDone!");
}

main().catch(console.error);
