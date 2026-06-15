const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const { createClient } = require('@supabase/supabase-js');

async function checkSchema() {
    if (!keyMatch || !urlMatch) {
        console.log("Could not find keys");
        return;
    }
    const supabase = createClient(urlMatch[1], keyMatch[1]);
    const { data, error } = await supabase.from('messages').select('*').limit(1);
    if (error) {
        console.error("Error:", error);
    } else {
        console.log("Columns:", data.length > 0 ? Object.keys(data[0]) : "No data to infer schema");
    }
}
checkSchema();
