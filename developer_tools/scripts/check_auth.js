const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*\"([^\"]+)\"/);
const urlMatch = configContent.match(/supabaseUrl:\s*\"([^\"]+)\"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], {auth: {persistSession: false}});
supabase.auth.admin.listUsers().then(res => {
  const user = res.data.users.find(u => u.email === 'titusombese@gmail.com');
  console.log("TITUS AUTH ID:", user ? user.id : 'NOT_FOUND');
});
