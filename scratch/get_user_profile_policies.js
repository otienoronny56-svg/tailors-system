const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configText = fs.readFileSync('config.js', 'utf8');
const url = configText.match(/supabaseUrl:\s*['\"]([^'\"]+)['\"]/)[1];
const key = configText.match(/serviceRoleKey:\s*['\"]([^'\"]+)['\"]/)[1];

const supabase = createClient(url, key);

async function run() {
    const { data, error } = await supabase.rpc('execute_sql', { 
        sql_query: "SELECT schemaname, tablename, policyname, roles, cmd, qual, with_check FROM pg_policies WHERE tablename = 'user_profiles';"
    });
    if (error) {
        // Fallback to querying pg_policies via standard query if execute_sql is not defined
        const { data: d, error: e } = await supabase.from('pg_policies').select('*').eq('tablename', 'user_profiles');
        console.log("Fallback pg_policies:", d, e);
    } else {
        console.log("POLICES:", data);
    }
}
run();
