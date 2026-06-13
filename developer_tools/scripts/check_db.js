const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

// Read config.js to extract keys (quick regex hack)
const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (urlMatch && keyMatch) {
    const supabaseUrl = urlMatch[1];
    const supabaseKey = keyMatch[1];
    const supabase = createClient(supabaseUrl, supabaseKey);

    async function checkData() {
        const { data, error } = await supabase.from('clients').select('name, measurements_history').limit(5);
        if (error) {
            console.error("Error:", error);
            return;
        }
        console.log(JSON.stringify(data, null, 2));
    }
    checkData();
} else {
    console.log("Could not find keys");
}
