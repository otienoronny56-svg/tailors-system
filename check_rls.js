const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const config = fs.readFileSync('C:/Users/ronny/Desktop/tailors project/js/config.js', 'utf8');
const supabaseUrl = config.match(/SUPABASE_URL\s*=\s*'([^']+)'/)[1];
const supabaseKey = config.match(/SUPABASE_ANON_KEY\s*=\s*'([^']+)'/)[1];
const supabase = createClient(supabaseUrl, supabaseKey);
supabase.rpc('execute_sql', { sql_query: "SELECT policyname, cmd, qual, with_check FROM pg_policies WHERE tablename = 'messages';" }).then(console.log);
