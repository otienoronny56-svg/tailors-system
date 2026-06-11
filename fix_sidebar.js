const fs = require('fs');
let c = fs.readFileSync('app.js', 'utf8');

const target = `            // Case A: User is assigned to a specific shop (Manager)
            if (USER_PROFILE.shop_id) {
                const { data: shop } = await supabaseClient
                    .from('shops')
                    .select('name')
                    .eq('id', USER_PROFILE.shop_id)
                    .maybeSingle();
                if (shop && shop.name) mainTitle = shop.name;
            } 
            // Case B: User is an Owner (Global) - fetch Organization Name or Smart Default
            else if (USER_PROFILE.role === 'owner') {
                // If organization_id is NULL, try to guess the primary org
                let org = null;
                if (USER_PROFILE.organization_id) {
                    const { data } = await supabaseClient.from('organizations').select('id, name').eq('id', USER_PROFILE.organization_id).maybeSingle();
                    org = data;
                } else {
                    const { data } = await supabaseClient.from('organizations').select('id, name').order('created_at', { ascending: true }).limit(1).maybeSingle();
                    org = data;
                }

                if (org) {
                    mainTitle = org.name;
                    // Smart Default: If there's only ONE shop in this org, use that name instead
                    const { data: shops } = await supabaseClient.from('shops').select('name').eq('organization_id', org.id);
                    if (shops && shops.length === 1) {
                        mainTitle = shops[0].name;
                    }
                }
            }`;

const replacement = `            // Case: Always use Organization Name if available to maintain consistent top-left branding
            if (USER_PROFILE.organization_id) {
                const { data: org } = await supabaseClient.from('organizations').select('id, name').eq('id', USER_PROFILE.organization_id).maybeSingle();
                if (org && org.name) {
                    mainTitle = org.name;
                }
            }`;

if (c.includes(target)) {
    c = c.replace(target, replacement);
    fs.writeFileSync('app.js', c);
    console.log("Successfully patched app.js");
} else {
    console.log("Target not found!");
}
