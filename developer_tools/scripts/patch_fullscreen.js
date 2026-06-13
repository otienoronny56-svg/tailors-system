const fs = require('fs');

const file = 'C:/Users/ronny/Desktop/tailors project/app.js';
let appJs = fs.readFileSync(file, 'utf8');

// Normalize line endings
appJs = appJs.replace(/\r\n/g, '\n');

const oldStyles = `        const modalContent = modal.querySelector('.modal-content');
        if(modalContent) {
            modalContent.style.width = '90%';
            modalContent.style.maxWidth = '1000px';
            modalContent.style.height = '90vh';
            modalContent.style.display = 'flex';
            modalContent.style.flexDirection = 'column';
            modalContent.style.padding = '30px';
            
            modalContent.style.overflowY = 'auto';
        }

        modal.style.display = 'flex';
        modal.style.alignItems = 'center';
        modal.style.justifyContent = 'center';`;

const newStyles = `        const modalContent = modal.querySelector('.modal-content');
        if(modalContent) {
            modalContent.style.width = '100vw';
            modalContent.style.maxWidth = '100vw';
            modalContent.style.height = '100vh';
            modalContent.style.maxHeight = '100vh';
            modalContent.style.display = 'flex';
            modalContent.style.flexDirection = 'column';
            modalContent.style.padding = '40px 60px'; // Generous padding for full screen
            modalContent.style.borderRadius = '0';
            modalContent.style.margin = '0';
            modalContent.style.border = 'none';
            modalContent.style.boxShadow = 'none';
            modalContent.style.overflowY = 'auto';
        }

        modal.style.display = 'block';
        modal.style.padding = '0';
        modal.style.background = '#f8fafc'; // Solid background to act as a full page
        modal.style.zIndex = '99999'; // Ensure it covers everything including sidebar`;

if (appJs.includes(oldStyles)) {
    appJs = appJs.replace(oldStyles, newStyles);
    fs.writeFileSync(file, appJs);
    console.log('Successfully applied FULL SCREEN styling to client details');
} else {
    console.log('Could not find the target string. Using regex fallback...');
    // regex fallback
    appJs = appJs.replace(/const modalContent = modal\.querySelector\('\.modal-content'\);[\s\S]*?modal\.style\.justifyContent = 'center';/, newStyles);
    fs.writeFileSync(file, appJs);
    console.log('Successfully applied FULL SCREEN styling using regex fallback');
}
