const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'views', 'superadmin', 'superadmin-users-list.html');
let content = fs.readFileSync(filePath, 'utf8');

content = content.replace(/#user-search\s*\{[\s\S]*?\}/, `#user-search {
            padding: 12px 15px !important;
            border-radius: 8px !important;
            font-family: inherit;
            border: 1px solid var(--glass-border) !important;
        }
        .dark-mode #user-search { background: rgba(6, 12, 24, 0.6) !important; }`);

content = content.replace(/\.user-table th\s*\{[\s\S]*?\}/, `.user-table th {
            font-weight: 700;
            border: none !important;
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 1px;
            padding: 12px 15px !important;
            text-align: left;
            white-space: normal !important;
        }
        .dark-mode .user-table th {
            background: rgba(6, 12, 24, 0.6) !important;
            color: var(--brand-gold) !important;
        }`);

content = content.replace(/\.user-table tbody tr\s*\{[\s\S]*?\}/, `.user-table tbody tr {
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            background: var(--card-bg) !important;
        }
        .dark-mode .user-table tbody tr {
            background: rgba(17, 34, 64, 0.5) !important;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }`);

content = content.replace(/\.user-table tbody tr:hover\s*\{[\s\S]*?\}/, `.user-table tbody tr:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        }
        .dark-mode .user-table tbody tr:hover {
            background: rgba(17, 34, 64, 0.85) !important;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }`);

content = content.replace(/\.user-table td\s*\{[\s\S]*?\}/, `.user-table td {
            padding: 12px 15px !important;
            border: none !important;
            color: var(--text-color) !important;
            vertical-align: middle;
            background: transparent !important;
            white-space: normal !important;
        }
        .dark-mode .user-table td {
            color: var(--brand-slate) !important;
        }`);

content = content.replace(/\.user-table td div:last-child\s*\{[\s\S]*?\}/, `.user-table td div:last-child {
            font-size: 0.95em !important;
            font-weight: 500;
        }
        .dark-mode .user-table td div:last-child {
            color: var(--brand-slate) !important;
        }`);

fs.writeFileSync(filePath, content);
console.log("Fixed leaks.");
