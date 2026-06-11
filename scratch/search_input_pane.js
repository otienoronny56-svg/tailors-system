const fs = require('fs');
const path = require('path');

function searchDir(dir) {
    const files = fs.readdirSync(dir);
    files.forEach(file => {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            if (file !== 'node_modules' && file !== '.git') {
                searchDir(fullPath);
            }
        } else if (file.endsWith('.js') || file.endsWith('.html') || file.endsWith('.css')) {
            const content = fs.readFileSync(fullPath, 'utf8');
            if (content.includes('msg-input-pane') || content.includes('chat-input-pane-container')) {
                console.log(`Found in: ${fullPath}`);
                // Print lines
                const lines = content.split('\n');
                lines.forEach((line, idx) => {
                    if (line.includes('msg-input-pane') || line.includes('chat-input-pane-container')) {
                        console.log(`  ${idx + 1}: ${line.trim()}`);
                    }
                });
            }
        }
    });
}

searchDir('.');
