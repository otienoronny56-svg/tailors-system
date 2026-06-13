const fs = require('fs');

const file = 'C:/Users/ronny/Desktop/tailors project/app.js';
let appJs = fs.readFileSync(file, 'utf8');

appJs = appJs.replace(/<div style="max-height: 450px; overflow-y: auto; padding-right: 5px;">/g, 
                      '<div style="flex: 1; overflow-y: auto; padding-right: 5px;">');

fs.writeFileSync(file, appJs);
console.log('Successfully removed 450px max-height constraint from history container');
