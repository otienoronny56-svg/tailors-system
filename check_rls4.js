const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const config = fs.readFileSync('C:/Users/ronny/Desktop/tailors project/js/core/config.js', 'utf8');
const supabaseUrl = config.match(/supabaseUrl:\s*"([^"]+)"/)[1];
const supabaseKey = config.match(/supabaseKey:\s*"([^"]+)"/)[1];
const supabase = createClient(supabaseUrl, supabaseKey);
supabase.rpc('execute_sql', { sql_query: `
DROP POLICY IF EXISTS "Super Admins Manage All Blogs" ON public.blogs;
CREATE POLICY "Super Admins Manage All Blogs" 
ON public.blogs FOR ALL 
USING (get_user_role() = 'superadmin')
WITH CHECK (get_user_role() = 'superadmin');
` }).then(console.log).catch(console.error);
