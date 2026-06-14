const fs = require('fs');
const configContent = fs.readFileSync('../../js/core/config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey:\s*\"([^\"]+)\"/);
const urlMatch = configContent.match(/supabaseUrl:\s*\"([^\"]+)\"/);
const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(urlMatch[1], keyMatch[1], {auth: {persistSession: false}});
supabase.auth.admin.listUsers().then(async res => {
  const user = res.data.users.find(u => u.email === 'titusombese@gmail.com');
  if (user) {
    console.log("Found TITUS in auth.users:", user.id);
    const { error } = await supabase.from('user_profiles').insert([{
      id: user.id,
      email: 'titusombese@gmail.com',
      full_name: 'Titus Ombese',
      role: 'client'
    }]);
    if (error) {
      console.error("Error inserting profile:", error);
    } else {
      console.log("SUCCESSFULLY inserted Titus profile!");
    }
  } else {
    console.log("Titus not found in auth.users");
  }
});
