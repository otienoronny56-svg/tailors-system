const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const url = configText.match(/supabaseUrl:\s*['\"]([^'\"]+)['\"]/)[1];
const key = configText.match(/serviceRoleKey:\s*['\"]([^'\"]+)['\"]/)[1];

const supabase = createClient(url, key);

async function check() {
    // 1. Get shop info
    const { data: shop, error: shopErr } = await supabase
        .from('shops')
        .select('*')
        .eq('id', '17ed20e4-2ce6-484d-833f-08222717fe9c')
        .single();
    if (shopErr) {
        console.error("Shop Err:", shopErr);
        return;
    }
    console.log("SHOP:", JSON.stringify(shop, null, 2));

    // 2. Get user profiles for that organization
    const { data: profiles, error: profErr } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('organization_id', shop.organization_id);
    if (profErr) console.error("Prof Err:", profErr);
    else console.log("PROFILES:", JSON.stringify(profiles, null, 2));
}
check();
