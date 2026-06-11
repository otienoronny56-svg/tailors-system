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

async function testDuplicateInsert() {
    try {
        // 1. Fetch organizations
        const { data: orgs, error: orgErr } = await supabase.from('organizations').select('*');
        if (orgErr) throw orgErr;
        console.log("Orgs available:", orgs);

        if (orgs.length < 2) {
            console.log("Need at least 2 organizations to test tenant isolation. Creating a temp org...");
            const { data: newOrg, error: newOrgErr } = await supabase
                .from('organizations')
                .insert([{ name: 'Temp Test Org 2' }])
                .select();
            if (newOrgErr) throw newOrgErr;
            orgs.push(newOrg[0]);
        }

        const org1 = orgs[0].id;
        const org2 = orgs[1].id;
        const testPhone = '9999999999';

        // Clean up previous test clients
        await supabase.from('clients').delete().eq('phone', testPhone);

        console.log("Inserting client 1 under Org 1...");
        const { data: c1, error: e1 } = await supabase
            .from('clients')
            .insert([{ organization_id: org1, phone: testPhone, name: 'Client A' }])
            .select();
        if (e1) {
            console.error("Insert 1 failed:", e1.message);
        } else {
            console.log("Insert 1 success:", c1);
        }

        console.log("Inserting client 2 under Org 2 with SAME phone...");
        const { data: c2, error: e2 } = await supabase
            .from('clients')
            .insert([{ organization_id: org2, phone: testPhone, name: 'Client B' }])
            .select();
        
        if (e2) {
            console.error("Insert 2 failed (Constraint active):", e2.message, e2.code);
        } else {
            console.log("Insert 2 success (Multi-tenant scoped!):", c2);
        }

        // Clean up test clients
        await supabase.from('clients').delete().eq('phone', testPhone);

    } catch (err) {
        console.error("Test failed:", err.message);
    }
}

testDuplicateInsert();
