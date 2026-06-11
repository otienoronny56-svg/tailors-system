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

async function checkRLS() {
    try {
        console.log("--- Checking RLS Status and Active Policies ---");
        
        // Query pg_tables to check if RLS is enabled (rowsecurity)
        const { data: tables, error: tablesErr } = await supabase.rpc('check_rls_status');
        
        if (tablesErr) {
            // If RPC doesn't exist, execute a custom SQL-like query using pg_catalog or query direct data
            console.log("RPC check_rls_status not defined. Trying query direct schema information...");
            
            // Let's run a direct query on pg_catalog via RPC if possible, or query table data to see if we can deduce RLS
            const { data: shops, error: shopsErr } = await supabase.from('shops').select('*');
            if (shopsErr) throw shopsErr;
            console.log(`Successfully fetched ${shops.length} shops with Service Role Key.`);
            console.log("Shops details:");
            console.table(shops.map(s => ({ id: s.id, name: s.name, organization_id: s.organization_id })));
            
            const { data: orgs, error: orgsErr } = await supabase.from('organizations').select('*');
            if (orgsErr) throw orgsErr;
            console.log(`Successfully fetched ${orgs.length} organizations with Service Role Key.`);
            console.log("Organizations:");
            console.table(orgs.map(o => ({ id: o.id, name: o.name })));

            const { data: profiles, error: profilesErr } = await supabase.from('user_profiles').select('*');
            if (profilesErr) throw profilesErr;
            console.log(`Successfully fetched ${profiles.length} user profiles with Service Role Key.`);
            console.table(profiles.map(p => ({ id: p.id, full_name: p.full_name, role: p.role, organization_id: p.organization_id })));
        } else {
            console.log("RLS Status from database:", tables);
        }
    } catch (err) {
        console.error("Error running RLS diagnostic:", err.message);
    }
}

checkRLS();
