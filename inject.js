const fs = require('fs');

const marketplacePath = 'C:/Users/ronny/Desktop/tailors project/views/client/marketplace.html';
const dashboardPath = 'C:/Users/ronny/Desktop/tailors project/views/client/client-dashboard.html';

const mktHtml = fs.readFileSync(marketplacePath, 'utf8');
const dashboardHtml = fs.readFileSync(dashboardPath, 'utf8');

const startIndex = mktHtml.indexOf('<!-- AI Style Assistant Chatbot -->');
const endIndex = mktHtml.indexOf('</body>', startIndex);

const aiBlock = mktHtml.substring(startIndex, endIndex);

const finalHtml = dashboardHtml.replace('</body>', aiBlock + '\n</body>');
fs.writeFileSync(dashboardPath, finalHtml);
console.log('Injected successfully!');
