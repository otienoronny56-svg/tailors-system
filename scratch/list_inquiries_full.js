const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (!urlMatch || !keyMatch) {
    console.error("Could not load config keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function inspect() {
    const { data: inqs, error } = await supabase.from('marketplace_inquiries').select('*');
    if (error) {
        console.error(error);
    } else {
        console.log(JSON.stringify(inqs, null, 2));
    }
}
inspect();
