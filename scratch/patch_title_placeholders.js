const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/ronny/Desktop/tailors project';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const targetTitleRegex = /\|\s*Ephraims\s+Bespoke/gi;
const replacementTitle = '| Tailors System';

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    if (targetTitleRegex.test(content)) {
        content = content.replace(targetTitleRegex, replacementTitle);
        fs.writeFileSync(filePath, content);
        console.log(`Patched title in ${file}`);
    }
});
console.log("Title patching completed successfully!");
