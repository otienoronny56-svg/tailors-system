const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://ouuhirckiavcvgqlpriw.supabase.co';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA';

const sb = createClient(SUPABASE_URL, SERVICE_KEY);

async function main() {
    console.log("Checking if marketplace_likes table exists by querying it...");
    const { data, error } = await sb.from('marketplace_likes').select('*').limit(1);
    if (error) {
        console.log("Error querying table (might not exist):", error.message);
    } else {
        console.log("Table marketplace_likes exists. Data:", data);
    }
}

main().catch(console.error);
