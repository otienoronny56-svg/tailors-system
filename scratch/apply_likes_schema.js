const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const SUPABASE_URL = 'https://ouuhirckiavcvgqlpriw.supabase.co';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA';

const sb = createClient(SUPABASE_URL, SERVICE_KEY);

async function main() {
    console.log("Reading create_likes_table.sql...");
    const sqlPath = path.join(__dirname, '../database/schemas/create_likes_table.sql');
    const sql = fs.readFileSync(sqlPath, 'utf8');

    console.log("Running SQL schema on Supabase...");
    const { data, error } = await sb.rpc('exec_sql', { query: sql });
    if (error) {
        console.error("Error executing SQL:", error);
    } else {
        console.log("SQL executed successfully:", data);
    }
}

main().catch(console.error);
