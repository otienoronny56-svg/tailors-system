const fs = require('fs');
const path = require('path');

const dir = path.join(__dirname, 'views', 'superadmin');
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

files.forEach(file => {
    const filePath = path.join(dir, file);
    let content = fs.readFileSync(filePath, 'utf8');

    // Replace the entire <nav> block with an empty <nav>
    const newContent = content.replace(/<nav>[\s\S]*?<\/nav>/, '<nav></nav>');
    
    if (newContent !== content) {
        fs.writeFileSync(filePath, newContent);
        console.log(`Cleared nav for ${file}`);
    }
});
