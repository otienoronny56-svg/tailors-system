const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/ronny/Desktop/tailors project';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const superadminFiles = [
    'superadmin-dashboard.html',
    'superadmin-orgs.html',
    'superadmin-users-list.html',
    'superadmin-users.html'
];

const targetLogoRegex = /<h1\s+class="sidebar-logo">TAILOR\s+<span\s+class="sidebar-n">SYSTEM<\/span><\/h1>/gi;
const targetSubRegex = /<span\s+class="sidebar-subtitle">LOADING\s+PORTAL\.\.\.<\/span>/gi;

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;

    if (superadminFiles.includes(file)) {
        // Hardcode Superadmin branding statically
        if (targetLogoRegex.test(content)) {
            content = content.replace(targetLogoRegex, '<h1 class="sidebar-logo">TAILORS.CO.KE</h1>');
            modified = true;
        }
        if (targetSubRegex.test(content)) {
            content = content.replace(targetSubRegex, '<span class="sidebar-subtitle">SAAS CONTROL</span>');
            modified = true;
        }
    } else {
        // Non-superadmin pages: use empty placeholders to avoid layout shifts & prevent leaks
        if (targetLogoRegex.test(content)) {
            content = content.replace(targetLogoRegex, '<h1 class="sidebar-logo">&nbsp;</h1>');
            modified = true;
        }
        if (targetSubRegex.test(content)) {
            content = content.replace(targetSubRegex, '<span class="sidebar-subtitle">&nbsp;</span>');
            modified = true;
        }
    }

    if (modified) {
        fs.writeFileSync(filePath, content);
        console.log(`Patched final visual branding in ${file}`);
    }
});
console.log("Final visual fixes applied successfully!");
