const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/supabaseKey:\s*"([^"]+)"/); // Use anon key

if (!urlMatch || !keyMatch) {
    console.error("Could not load config keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function checkAnonQuery() {
    try {
        console.log("Querying 'shops' table as ANONYMOUS user...");
        const { data, error } = await supabase.from('shops').select('id, name, organization_id');
        if (error) throw error;
        console.log(`Query returned ${data.length} shops.`);
        if (data.length > 0) {
            console.log("❌ SECURITY WARNING: Anonymous user fetched shops! Row Level Security (RLS) is NOT enforcing isolation.");
            console.table(data);
        } else {
            console.log("✅ RLS successfully blocked anonymous access (0 shops returned).");
        }
    } catch (err) {
        console.error("Error during anon query:", err.message);
    }
}

checkAnonQuery();
