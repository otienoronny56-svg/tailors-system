const fs = require('fs');

try {
    const html = fs.readFileSync('admin-messages.html', 'utf8');
    const scriptRegex = /<script>([\s\S]*?)<\/script>/gi;
    let match;
    let index = 1;
    while ((match = scriptRegex.exec(html)) !== null) {
        const js = match[1];
        console.log(`Checking script block ${index}...`);
        try {
            // Use Function to test syntax
            new Function(js);
            console.log(`✅ Script block ${index} parses successfully!`);
        } catch (e) {
            console.error(`❌ Syntax error in script block ${index}:`, e.message);
        }
        index++;
    }
} catch (err) {
    console.error(err);
}
