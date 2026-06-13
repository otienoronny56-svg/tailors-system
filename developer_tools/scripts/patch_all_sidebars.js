const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/ronny/Desktop/tailors project';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const dashHtml = fs.readFileSync(path.join(dir, 'admin-dashboard.html'), 'utf8');
const sidebarRegex = /<aside class="sidebar"[^>]*>[\s\S]*?<\/aside>/;
const match = dashHtml.match(sidebarRegex);
if (!match) {
    console.error("Could not find sidebar in admin-dashboard.html");
    process.exit(1);
}

const baseSidebar = match[0];

files.forEach(file => {
    // Skip the dashboard itself
    if (file === 'admin-dashboard.html') return;

    let content = fs.readFileSync(path.join(dir, file), 'utf8');
    
    if (sidebarRegex.test(content)) {
        // Customize the active link
        let customSidebar = baseSidebar.replace(/class="active"/g, ''); // remove all active classes
        
        // Try to figure out which link should be active based on the filename
        let targetId = '';
        if (file.includes('order')) targetId = 'nav-orders';
        else if (file.includes('client')) targetId = 'nav-clients';
        else if (file.includes('inventory') || file.includes('listing')) targetId = 'nav-inventory';
        else if (file.includes('finance') || file.includes('analytic') || file.includes('expense') || file.includes('transaction')) targetId = 'nav-finance';
        else if (file.includes('message')) targetId = 'nav-messages';

        if (targetId) {
            customSidebar = customSidebar.replace(`id="${targetId}"`, `id="${targetId}" class="active"`);
        }

        content = content.replace(sidebarRegex, customSidebar);
        fs.writeFileSync(path.join(dir, file), content);
        console.log(`Patched sidebar in ${file}`);
    }
});
