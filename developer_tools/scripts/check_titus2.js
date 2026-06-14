const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], { auth: { persistSession: false } });

async function showTitus() {
    const { data, error } = await supabase
        .from('marketplace_inquiries')
        .select('id, client_email, client_name, shop_id, listing_id, message, created_at')
        .ilike('client_email', '%titus%')
        .order('created_at', { ascending: true });

    if (error) { console.error(error); return; }
    console.log(`Titus inquiries: ${data.length}`);
    data.forEach(d => console.log(`  id=${d.id} | listing=${d.listing_id} | shop=${d.shop_id} | at=${d.created_at}`));
}
showTitus();
