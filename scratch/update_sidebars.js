const fs = require('fs');
const path = require('path');

const targetFiles = [
    'admin-dashboard.html',
    'admin-orders.html',
    'financial-overview.html',
    'admin-clients.html',
    'admin-expenses.html',
    'admin-transactions.html',
    'admin-analytics.html',
    'admin-inventory.html',
    'admin-listings.html',
    'admin-messages.html',
    'admin-management.html',
    'admin-order-form.html',
    'admin-order-details.html'
];

const dir = 'c:/Users/ronny/Desktop/tailors project';

// Map of file names to their active nav element IDs
const activeNavMap = {
    'admin-dashboard.html': 'nav-dashboard',
    'admin-orders.html': 'nav-orders',
    'admin-clients.html': 'nav-clients',
    'admin-messages.html': 'nav-messages',
    'admin-inventory.html': 'nav-inventory',
    'admin-listings.html': 'nav-listings',
    'financial-overview.html': 'nav-finance',
    'admin-analytics.html': 'nav-analytics',
    'admin-transactions.html': 'nav-transactions',
    'admin-expenses.html': 'nav-expenses',
    'admin-order-form.html': 'nav-new-order'
};

function getSidebarHtml(activeId) {
    return `            <nav>
                <a href="admin-dashboard.html" id="nav-dashboard"${activeId === 'nav-dashboard' ? ' class="active"' : ''}><i class="fas fa-crown" style="margin-right: 8px;"></i> Admin Dashboard</a>
                
                <a href="admin-orders.html" id="nav-orders"${activeId === 'nav-orders' ? ' class="active"' : ''}><i class="fas fa-folder-open" style="margin-right: 8px;"></i> Global Orders</a>
                
                <div class="sidebar-dropdown">
                    <button class="dropdown-trigger" onclick="toggleSidebarDropdown(this)">
                        <span><i class="fas fa-address-book" style="margin-right: 8px;"></i> Clients & Inbox</span>
                        <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </button>
                    <div class="dropdown-content">
                        <a href="admin-clients.html" id="nav-clients"${activeId === 'nav-clients' ? ' class="active"' : ''}><i class="fas fa-users" style="margin-right: 8px;"></i> Client Database</a>
                        <a href="admin-messages.html" id="nav-messages"${activeId === 'nav-messages' ? ' class="active"' : ''}><i class="fas fa-comments" style="margin-right: 8px;"></i> Messages Inbox</a>
                    </div>
                </div>

                <div class="sidebar-dropdown">
                    <button class="dropdown-trigger" onclick="toggleSidebarDropdown(this)">
                        <span><i class="fas fa-boxes-stacked" style="margin-right: 8px;"></i> Products & Stock</span>
                        <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </button>
                    <div class="dropdown-content">
                        <a href="admin-inventory.html" id="nav-inventory"${activeId === 'nav-inventory' ? ' class="active"' : ''}><i class="fas fa-box-open" style="margin-right: 8px;"></i> Inventory</a>
                        <a href="admin-listings.html" id="nav-listings"${activeId === 'nav-listings' ? ' class="active"' : ''}><i class="fas fa-tags" style="margin-right: 8px;"></i> Marketplace Catalog</a>
                    </div>
                </div>

                <div class="sidebar-dropdown">
                    <button class="dropdown-trigger" onclick="toggleSidebarDropdown(this)">
                        <span><i class="fas fa-wallet" style="margin-right: 8px;"></i> Finance & Analytics</span>
                        <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </button>
                    <div class="dropdown-content">
                        <a href="financial-overview.html" id="nav-finance"${activeId === 'nav-finance' ? ' class="active"' : ''}><i class="fas fa-chart-line" style="margin-right: 8px;"></i> Financial Overview</a>
                        <a href="admin-analytics.html" id="nav-analytics"${activeId === 'nav-analytics' ? ' class="active"' : ''}><i class="fas fa-chart-bar" style="margin-right: 8px;"></i> BI Analytics & AI</a>
                        <a href="admin-transactions.html" id="nav-transactions"${activeId === 'nav-transactions' ? ' class="active"' : ''}><i class="fas fa-list-ul" style="margin-right: 8px;"></i> Transactions</a>
                        <a href="admin-expenses.html" id="nav-expenses"${activeId === 'nav-expenses' ? ' class="active"' : ''}><i class="fas fa-file-invoice-dollar" style="margin-right: 8px;"></i> Expenses</a>
                    </div>
                </div>

                <a href="admin-order-form.html" class="nav-cta" id="nav-new-order"${activeId === 'nav-new-order' ? ' class="active"' : ''}><i class="fas fa-plus" style="margin-right: 8px;"></i> New Global Order</a>

                <a href="#" id="logout-btn"><i class="fas fa-sign-out-alt" style="margin-right: 8px;"></i> Logout</a>
            </nav>
            <script>
                if (typeof window.toggleSidebarDropdown !== 'function') {
                    window.toggleSidebarDropdown = function(button) {
                        const event = window.event || (arguments.length > 1 ? arguments[1] : null);
                        if (event) {
                            event.alreadyHandledDropdown = true;
                        }
                        const dropdown = button.closest('.sidebar-dropdown');
                        if (dropdown) {
                            dropdown.classList.toggle('open');
                        }
                    };
                }
            </script>`;
}

const gearIconHtml = `                        <button onclick="location.href='admin-management.html'" title="Management & Setup"
                            style="background: white; border: 1px solid #e2e8f0; color: #475569; width: 42px; height: 42px; border-radius: 8px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.05); transition: all 0.2s; display: flex; align-items: center; justify-content: center; font-size: 1.1em;"
                            onmouseover="this.style.background='#f8fafc'; this.style.color='#0f172a'; this.style.transform='translateY(-1px)'"
                            onmouseout="this.style.background='white'; this.style.color='#475569'; this.style.transform='translateY(0)'">
                            <i class="fa-solid fa-cog"></i>
                        </button>\n`;

targetFiles.forEach(file => {
    const filePath = path.join(dir, file);
    if (!fs.existsSync(filePath)) {
        console.log(`Skipping missing file: ${file}`);
        return;
    }

    let content = fs.readFileSync(filePath, 'utf8');

    // 1. Replace Navigation Menu Block
    const activeId = activeNavMap[file] || '';
    const newSidebar = getSidebarHtml(activeId);
    
    // We regex match the `<nav>` tag and replace it
    content = content.replace(/<nav>[\s\S]*?<\/nav>/, newSidebar);

    // 2. Add Gear Icon next to toggleTheme button if not already present
    if (content.includes('toggleTheme()') && !content.includes("href='admin-management.html'") && !content.includes('admin-management.html')) {
        // Find toggleTheme button tag block
        content = content.replace(/(<button\s+onclick="toggleTheme\(\)"[\s\S]*?<\/button>)/, gearIconHtml + '$1');
    } else if (content.includes('toggleTheme') && !content.includes('admin-management.html')) {
        content = content.replace(/(<button[^>]+toggleTheme[^>]+>[\s\S]*?<\/button>)/, gearIconHtml + '$1');
    }

    // 3. Update bottom nav from admin-current-orders.html to admin-orders.html
    content = content.replace(/href="admin-current-orders\.html"/g, 'href="admin-orders.html"');
    content = content.replace(/<span>Active<\/span>/g, '<span>Orders<\/span>');
    content = content.replace(/<span>Active Orders<\/span>/g, '<span>Orders<\/span>');

    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully updated ${file}`);
});
