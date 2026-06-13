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
    const { data, error } = await supabase.from('order_accessories').select('*');
    if (error) console.error(error);
    else console.log("ACC_ROWS:" + data.length);
}
run();
