const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (urlMatch && keyMatch) {
    const supabaseUrl = urlMatch[1];
    const supabaseKey = keyMatch[1];
    const supabase = createClient(supabaseUrl, supabaseKey);

    async function verifyTables() {
        console.log("Verifying tables on Supabase...");
        
        // 1. Check marketplace_inquiries
        const { data: inqData, error: inqError } = await supabase
            .from('marketplace_inquiries')
            .select('*')
            .limit(1);
            
        if (inqError) {
            console.log("❌ marketplace_inquiries table check failed:", inqError.message);
        } else {
            console.log("✅ marketplace_inquiries table exists! Found rows:", inqData.length);
        }

        // 2. Check messages
        const { data: msgData, error: msgError } = await supabase
            .from('messages')
            .select('*')
            .limit(1);
            
        if (msgError) {
            console.log("❌ messages table check failed:", msgError.message);
        } else {
            console.log("✅ messages table exists! Found rows:", msgData.length);
        }
    }
    verifyTables();
} else {
    console.log("Could not find keys");
}
