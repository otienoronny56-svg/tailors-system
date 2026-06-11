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

async function checkProfile() {
    const userId = '7f174a52-ea0b-4867-8c90-eb0bcc1bb7d5';
    console.log(`Checking profile for user ${userId}...`);
    const { data: profile, error } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle();

    if (error) {
        console.error("Error fetching profile:", error);
    } else {
        console.log("Profile details:", profile);
    }
}

checkProfile();
