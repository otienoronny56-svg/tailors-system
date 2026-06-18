const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('c:/Users/ronny/Desktop/tailors project/js/core/config.js', 'utf8');
const url = configText.match(/supabaseUrl:\s*['"]([^'"]+)['"]/)[1];
const key = configText.match(/serviceRoleKey:\s*['"]([^'"]+)['"]/)[1];

const supabase = createClient(url, key);

async function checkListingsShops() {
    const { data: listings } = await supabase.from('marketplace_listings').select('id, shop_id, status');
    
    // Group listings by shop_id
    const shopCounts = {};
    for (const listing of listings) {
        if (!shopCounts[listing.shop_id]) shopCounts[listing.shop_id] = 0;
        shopCounts[listing.shop_id]++;
    }
    console.log("Listings count by shop_id:", shopCounts);
    
    // Compare with existing shops
    const { data: shops } = await supabase.from('shops').select('id, name');
    const validShopIds = shops.map(s => s.id);
    
    console.log("Valid shop IDs:", validShopIds);
}
checkListingsShops();
