const fs = require('fs');

const file = 'C:/Users/ronny/Desktop/tailors project/app.js';
let appJs = fs.readFileSync(file, 'utf8');

// Normalize line endings for reliable matching
appJs = appJs.replace(/\r\n/g, '\n');

const oldModalDisplay = `            const bodyContainer = modalContent.querySelector('#client-details-body').parentElement;
            if (bodyContainer) {
                bodyContainer.style.flex = '1';
                bodyContainer.style.overflowY = 'auto';
                bodyContainer.style.overflowX = 'hidden';
            }`;

const newModalDisplay = `            modalContent.style.overflowY = 'auto';`;

appJs = appJs.replace(oldModalDisplay, newModalDisplay);

fs.writeFileSync(file, appJs);
console.log('Successfully fixed app.js crash');
