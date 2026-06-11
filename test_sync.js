const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (urlMatch && keyMatch) {
    const supabaseUrl = urlMatch[1];
    const serviceRoleKey = keyMatch[1];
    const supabase = createClient(supabaseUrl, serviceRoleKey);

    async function runDiagnostics() {
        console.log("--- Supabase Diagnostics ---");
        
        // Find Ephraims Bespoke Shop
        const { data: shops } = await supabase
            .from('shops')
            .select('id, name, organization_id');
        console.log("All Registered Shops:", JSON.stringify(shops, null, 2));

        // Find Owner User Profile
        const { data: profiles } = await supabase
            .from('user_profiles')
            .select('id, email, role, organization_id, shop_id');
        console.log("User Profiles:", JSON.stringify(profiles, null, 2));
    }
    
    runDiagnostics();
} else {
    console.log("Could not load credentials");
}
