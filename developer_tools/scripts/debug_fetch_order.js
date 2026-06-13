const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const urlMatch = configText.match(/supabaseUrl:\s*["']([^"']+)["']/);
const keyMatch = configText.match(/supabaseKey:\s*["']([^"']+)["']/);

if (!urlMatch || !keyMatch) {
    console.error("Could not parse config.js");
    process.exit(1);
}

const supabaseUrl = urlMatch[1];
const supabaseKey = keyMatch[1];
const supabase = createClient(supabaseUrl, supabaseKey);

async function run() {
    const { data, error } = await supabase.from('orders').select('id').limit(1);
    if (error) console.error(error);
    else console.log("ORDER_ID:" + data[0].id);
}
run();
