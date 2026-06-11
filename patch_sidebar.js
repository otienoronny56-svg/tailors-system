const fs = require('fs');

const dashboardPath = 'C:/Users/ronny/Desktop/tailors project/admin-dashboard.html';
const clientsPath = 'C:/Users/ronny/Desktop/tailors project/admin-clients.html';

const dashHtml = fs.readFileSync(dashboardPath, 'utf8');
const clientsHtml = fs.readFileSync(clientsPath, 'utf8');

// Extract sidebar from admin-dashboard
const sidebarRegex = /<aside class="sidebar" id="sidebar">[\s\S]*?<\/aside>/;
let sidebarContent = dashHtml.match(sidebarRegex)[0];

// In the sidebar content, remove class="active" from admin-dashboard.html link
sidebarContent = sidebarContent.replace('<a href="admin-dashboard.html" id="nav-dashboard" class="active">', '<a href="admin-dashboard.html" id="nav-dashboard">');

// Add class="active" to the admin-clients.html link
sidebarContent = sidebarContent.replace('<a href="admin-clients.html" id="nav-clients">', '<a href="admin-clients.html" id="nav-clients" class="active">');

// Now find the old sidebar in admin-clients.html
const oldSidebarRegex = /<aside class="sidebar">[\s\S]*?<\/aside>/;

// Replace old sidebar with new sidebar
const newClientsHtml = clientsHtml.replace(oldSidebarRegex, sidebarContent);

fs.writeFileSync(clientsPath, newClientsHtml);
console.log('Successfully patched the sidebar in admin-clients.html');
