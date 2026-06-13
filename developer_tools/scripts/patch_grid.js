const fs = require('fs');

const file = 'C:/Users/ronny/Desktop/tailors project/app.js';
let appJs = fs.readFileSync(file, 'utf8');

// The original grid layout for the measurement history cards was:
// grid-template-columns: 1fr 1fr;
appJs = appJs.replace(/grid-template-columns: 1fr 1fr;/g, 'grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));');

fs.writeFileSync(file, appJs);
console.log('Successfully updated grid layout for measurement cards to support 3 or more in one row.');
