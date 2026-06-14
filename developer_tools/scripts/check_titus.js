const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*\"([^\"]+)\"/);
const urlMatch = configContent.match(/supabaseUrl:\s*\"([^\"]+)\"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], {auth: {persistSession: false}});
supabase.from('user_profiles').select('*').eq('email', 'titusombese@gmail.com').then(res => console.log(JSON.stringify(res, null, 2)));
