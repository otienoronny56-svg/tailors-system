const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/ronny/Desktop/tailors project';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const targetLogoRegex = /<h1\s+class="sidebar-logo">EPHRAIMS\s+<span\s+class="sidebar-n">BESPOKE<\/span><\/h1>/gi;
const targetSubRegex = /<span\s+class="sidebar-subtitle">BY\s+(RONNY|GEORGE)<\/span>/gi;

const replacementLogo = `<h1 class="sidebar-logo">TAILOR <span class="sidebar-n">SYSTEM</span></h1>`;
const replacementSub = `<span class="sidebar-subtitle">LOADING PORTAL...</span>`;

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    let modified = false;

    if (targetLogoRegex.test(content)) {
        content = content.replace(targetLogoRegex, replacementLogo);
        modified = true;
    }
    if (targetSubRegex.test(content)) {
        content = content.replace(targetSubRegex, replacementSub);
        modified = true;
    }

    if (modified) {
        fs.writeFileSync(filePath, content);
        console.log(`Patched placeholder in ${file}`);
    }
});
console.log("Placeholder patching completed successfully!");
