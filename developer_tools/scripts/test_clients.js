const { createClient } = require('@supabase/supabase-js');

// Read config.js to get URL and Key
const fs = require('fs');
const configContent = fs.readFileSync('config.js', 'utf8');

// Simple regex extraction
const urlMatch = configContent.match(/supabaseUrl\s*:\s*['"]([^'"]+)['"]/);
const keyMatch = configContent.match(/supabaseKey\s*:\s*['"]([^'"]+)['"]/);

if (!urlMatch || !keyMatch) {
    console.error("Could not parse config.js");
    process.exit(1);
}

const supabaseUrl = urlMatch[1];
const supabaseKey = keyMatch[1];

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkClients() {
    console.log("Querying clients table select *...");
    const { data, error } = await supabase
        .from('clients')
        .select('*')
        .limit(1);

    if (error) {
        console.error("❌ Error selecting clients:", error);
    } else {
        console.log("✅ Success! First row:", data);
        if (data && data.length > 0) {
            console.log("Columns:", Object.keys(data[0]));
        } else {
            console.log("No rows found. Let's try to trigger a column error by ordering by a guess or fetching OpenAPI.");
        }
    }
}

checkClients();
