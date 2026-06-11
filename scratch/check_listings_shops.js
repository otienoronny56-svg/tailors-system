const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function main() {
    console.log("\n=== Shops ===");
    const { data: shops } = await supabase.from('shops').select('id, name, organization_id');
    console.table(shops);

    console.log("\n=== marketplace_listings with shop join ===");
    const { data: listings, error } = await supabase
        .from('marketplace_listings')
        .select('id, title, shop_id, status, shops(name)')
        .limit(20);
    if (error) console.error('Error:', error.message);
    else {
        listings.forEach(l => {
            console.log(`Title: "${l.title}" | shop_id: ${l.shop_id} | shops.name: ${l.shops?.name || 'NULL'} | status: ${l.status}`);
        });
    }
}

main().catch(console.error);
