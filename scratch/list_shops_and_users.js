const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('js/core/config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (!urlMatch || !keyMatch) {
    console.error("Could not load config keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function check() {
    console.log("--- Shops ---");
    const { data: shops } = await supabase.from('shops').select('id, name, organization_id');
    console.log(JSON.stringify(shops, null, 2));

    console.log("--- User Profiles ---");
    const { data: profiles } = await supabase.from('user_profiles').select('id, email, full_name, role, organization_id, shop_id');
    console.log(JSON.stringify(profiles, null, 2));
}
check();
