const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const supabaseUrl = "https://ouuhirckiavcvgqlpriw.supabase.co";
const supabaseKey = "sb_publishable_cwzaqLI3RB-h_ZxVY2xFMA_bUgp5UcU";
const supabase = createClient(supabaseUrl, supabaseKey);

const sql = fs.readFileSync('C:/Users/ronny/Desktop/tailors project/nuclear_rls.sql', 'utf8');

supabase.rpc('execute_sql', { sql_query: sql }).then(res => {
    console.log("RPC result:", res);
}).catch(console.error);
