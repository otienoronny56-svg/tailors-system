const fs = require('fs');
const path = require('path');

const dir = 'C:/Users/ronny/Desktop/tailors project';
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const targetSuffixRegex = /\s*\|\s*(Tailors\s+System|SaaS\s+Control)/gi;

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');
    
    if (targetSuffixRegex.test(content)) {
        content = content.replace(targetSuffixRegex, '');
        fs.writeFileSync(filePath, content);
        console.log(`Removed title suffix in ${file}`);
    }
});
console.log("Title suffix removal completed successfully!");
