const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const urlMatch = configText.match(/supabaseUrl:\s*["']([^"']+)["']/);
const keyMatch = configText.match(/serviceRoleKey:\s*["']([^"']+)["']/);

if (!urlMatch || !keyMatch) {
    console.error("Could not parse keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function run() {
    const { data, error } = await supabase.from('organizations').select('*').limit(1);
    if (error) {
        console.error(error);
    } else if (data && data[0]) {
        console.log("ORG_KEYS:" + Object.keys(data[0]).join(','));
    } else {
        console.log("No data found in organizations table");
    }
}
run();
