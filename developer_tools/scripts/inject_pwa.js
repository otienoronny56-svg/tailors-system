const fs = require('fs');
const path = require('path');

// 1. Inject manifest into all HTML files
const dir = './';
const files = fs.readdirSync(dir);

let htmlFilesUpdated = 0;
files.forEach(file => {
    if (file.endsWith('.html')) {
        let content = fs.readFileSync(file, 'utf8');
        if (!content.includes('manifest.json')) {
            content = content.replace('</head>', '    <link rel="manifest" href="manifest.json">\n</head>');
            fs.writeFileSync(file, content);
            console.log('Injected manifest into ' + file);
            htmlFilesUpdated++;
        }
    }
});
console.log(`Updated ${htmlFilesUpdated} HTML files.`);

// 2. Append SW registration to app.js
const appJsPath = './app.js';
if (fs.existsSync(appJsPath)) {
    let appJsContent = fs.readFileSync(appJsPath, 'utf8');
    if (!appJsContent.includes('serviceWorker.register')) {
        const swCode = `\n\n// --- PWA Service Worker Registration ---
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').then(registration => {
      console.log('SW registered: ', registration);
    }).catch(registrationError => {
      console.log('SW registration failed: ', registrationError);
    });
  });
}\n`;
        fs.appendFileSync(appJsPath, swCode);
        console.log('Appended SW registration to app.js');
    }
}
