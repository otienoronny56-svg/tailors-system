const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const initJs = fs.readFileSync('C:/Users/ronny/Desktop/tailors project/js/core/init.js', 'utf8');
const supabaseUrl = initJs.match(/SUPABASE_URL\s*=\s*'([^']+)'/)[1];
const supabaseKey = initJs.match(/SUPABASE_ANON_KEY\s*=\s*'([^']+)'/)[1];
const supabase = createClient(supabaseUrl, supabaseKey);
supabase.rpc('execute_sql', { sql_query: "SELECT policyname, cmd, qual, with_check FROM pg_policies WHERE tablename = 'messages';" }).then(console.log);
