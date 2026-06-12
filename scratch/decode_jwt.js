const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const keyMatch = configContent.match(/serviceRoleKey\s*:\s*['"]([^'"]+)['"]/);

if (keyMatch) {
    const jwt = keyMatch[1];
    const parts = jwt.split('.');
    if (parts.length === 3) {
        const payload = Buffer.from(parts[1], 'base64').toString('utf8');
        console.log("Decoded Service Role Key JWT payload:");
        console.log(JSON.stringify(JSON.parse(payload), null, 2));
    }
} else {
    console.log("No serviceRoleKey found");
}
