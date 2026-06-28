const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'views', 'superadmin', 'superadmin-dashboard.html');
let content = fs.readFileSync(filePath, 'utf8');

// Remove inline dark colors that break dark mode
content = content.replace(/color:\s*#0f172a\s*!important;/g, '');
content = content.replace(/color:\s*#0f172a;/g, '');

// Also ensure dark-mode-text class is doing its job, or remove it since CSS handles it
content = content.replace(/class="dark-mode-text"/g, '');

// Fix the subtitle visibility in inject_sleek.js
const sleekScriptPath = path.join(__dirname, 'inject_sleek.js');
let sleekScript = fs.readFileSync(sleekScriptPath, 'utf8');
sleekScript = sleekScript.replace('.sidebar-subtitle { display: none !important; }', '/* .sidebar-subtitle { display: none !important; } */');
fs.writeFileSync(sleekScriptPath, sleekScript);

fs.writeFileSync(filePath, content);
console.log("Colors fixed.");
