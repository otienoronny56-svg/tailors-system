const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (urlMatch && keyMatch) {
    const supabaseUrl = urlMatch[1];
    const supabaseKey = keyMatch[1];
    const supabase = createClient(supabaseUrl, supabaseKey);

    async function listProfiles() {
        console.log("Fetching profiles...");
        const { data: profiles, error: pError } = await supabase
            .from('user_profiles')
            .select('id, full_name, role, shop_id, organization_id');
            
        if (pError) {
            console.error("Profiles error:", pError.message);
            return;
        }
        console.log("Profiles in DB:");
        console.log(JSON.stringify(profiles, null, 2));

        console.log("\nFetching recent auth users...");
        const { data: users, error: uError } = await supabase.auth.admin.listUsers();
        if (uError) {
            console.error("Auth Users error:", uError.message);
            return;
        }
        console.log("Auth Users:");
        console.log(users.users.map(u => ({ id: u.id, email: u.email, metadata: u.user_metadata })));
    }
    listProfiles();
} else {
    console.log("Keys not found");
}
