const fs = require('fs');
const path = require('path');

function walkDir(dir) {
    let files = [];
    const items = fs.readdirSync(dir);
    for (const item of items) {
        if (item === 'node_modules' || item === '.git') continue;
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        if (stat.isDirectory()) {
            files = files.concat(walkDir(fullPath));
        } else if (fullPath.endsWith('.html') || fullPath.endsWith('sw.js')) {
            files.push(fullPath);
        }
    }
    return files;
}

const htmlFiles = walkDir(__dirname);
let count = 0;
const newVersion = '1781434537376';
for (const file of htmlFiles) {
    let content = fs.readFileSync(file, 'utf8');
    if (content.includes('v=1781434537375')) {
        content = content.replace(/v=1781434537375/g, `v=${newVersion}`);
        fs.writeFileSync(file, content);
        count++;
    }
}
console.log(`Updated cache buster to ${newVersion} in ${count} files.`);
