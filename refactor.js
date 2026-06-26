const fs = require('fs');

let content = fs.readFileSync('C:/Users/ronny/Desktop/tailors project/js/features/management.js', 'utf8');

// Replace getAdminClient usages
content = content.replace(/const adminClient = getAdminClient\(\);/g, 'const adminClient = window.supabaseClient;');
content = content.replace(/const admin = getAdminClient\(\);/g, 'const admin = window.supabaseClient;');
content = content.replace(/if \(!adminClient\) throw new Error\([^)]+\);/g, '');
content = content.replace(/if \(!adminClient\) return;/g, '');

content = content.replace(
    /const { data: authUser, error: authError } = await adminClient\.auth\.admin\.createUser\(([\s\S]*?)\);/g,
    `const { data: edgeData, error: authError } = await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'createUser', payload: $1 } });
        const authUser = edgeData ? edgeData.data.user : null;`
);

content = content.replace(
    /const { data: user, error: authError } = await admin\.auth\.admin\.createUser\(([\s\S]*?)\);/g,
    `const { data: edgeData, error: authError } = await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'createUser', payload: $1 } });
        const user = edgeData ? edgeData.data.user : null;`
);

content = content.replace(
    /const { data: authUser, error: authErr } = await adminClient\.auth\.admin\.createUser\(([\s\S]*?)\);/g,
    `const { data: edgeData, error: authErr } = await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'createUser', payload: $1 } });
        const authUser = edgeData ? edgeData.data.user : null;`
);

// deleteUser:
content = content.replace(
    /await admin\.auth\.admin\.deleteUser\(mgr\.id\);/g,
    `await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'deleteUser', payload: { id: mgr.id } } });`
);

// updateUserById:
content = content.replace(
    /const { data, error } = await adminClient\.auth\.admin\.updateUserById\((.*?),\s*\{(.*?)\}\);/g,
    `const { data: edgeData, error } = await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'updateUserById', payload: { id: $1, $2 } } });\n        const data = edgeData ? edgeData.data : null;`
);

// listUsers:
content = content.replace(
    /adminClient\.auth\.admin\.listUsers\(\)/g,
    `window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'listUsers' } }).then(res => ({ data: res.data ? res.data.data : null, error: res.error }))`
);

// getUserById:
content = content.replace(
    /const { data, error } = await adminClient\.auth\.admin\.getUserById\((.*?)\);/g,
    `const { data: edgeData, error } = await window.supabaseClient.functions.invoke('admin-proxy', { body: { action: 'getUserById', payload: { id: $1 } } });\n                        const data = edgeData ? edgeData.data : null;`
);

fs.writeFileSync('C:/Users/ronny/Desktop/tailors project/js/features/management.js', content);
console.log("Refactored management.js");
