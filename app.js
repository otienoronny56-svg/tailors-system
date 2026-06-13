// ==========================================
// ðŸ“‹ COPY & SHARE FUNCTIONS (FINAL CLEAN)
// ==========================================




// ==========================================
// ðŸ› ï¸ CORE UTILITIES
// ==========================================
// ==========================================

function initDebugger() { }

function formatMeasurements(json) {
    try {
        if (!json || json === '{}') return 'No measurements recorded';

        let m = JSON.parse(json);
        // Handle double-encoded JSON from legacy migrations
        if (typeof m === 'string') {
            try { m = JSON.parse(m); } catch (e) { }
        }

        let h = '';
        for (let k in m) {
            h += `<div style="break-inside: avoid; margin-bottom: 15px; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0; width: 100%;">
                    <b style="color: var(--brand-navy); font-size: 0.9em; text-transform: uppercase; border-bottom: 2px solid var(--brand-gold); padding-bottom: 5px; display: inline-block; margin-bottom: 12px; width: 100%;">${k} Details</b><br>`;
            for (let s in m[k]) {
                h += `<div style="display: flex; border-bottom: 1px dashed #cbd5e1; padding: 6px 0;">
                        <span style="color:#64748b; font-size: 0.95em; width: 150px; display: inline-block;">${s}</span> 
                        <b style="color:var(--brand-navy); font-size: 0.95em;">${m[k][s]}"</b>
                      </div>`;
            }
            h += '</div>';
        }
        return h || 'No measurements';
    } catch (e) {
        return 'Invalid measurement data';
    }
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        });
    } catch (e) {
        return 'Invalid date';
    }
}



// ==========================================
// ðŸ”„ VIEW MANAGEMENT
// ==========================================

function refreshCurrentView() {
    const path = window.location.pathname;
    logDebug(`Refreshing view for: ${path}`, null, 'info');

    if (path.includes('manager-dashboard')) {
        loadOrders('open');
    } else if (path.includes('all-orders')) {
        loadOrders('all');
    } else if (path.includes('admin-current-orders')) {
        loadAdminOrders('current');
    } else if (path.includes('admin-orders')) {
        loadAdminOrders('current');
    } else if (path.includes('admin-all-orders')) {
        loadAdminOrders('all');
    } else if (path.includes('admin-dashboard')) {
        loadAdminDashboard();
    } else if (path.includes('order-details')) {
        if (USER_PROFILE?.role === 'owner') {
            loadAdminOrderDetails();
        } else {
            loadOrderDetailsScreen();
        }
    } else if (path.includes('admin-order-details')) {
        loadAdminOrderDetails();
    } else if (path.includes('financial-overview')) {
        loadAnalyticsDashboard();
    } else if (path.includes('admin-management')) {
        loadAdminManagementScreen();
    } else if (path.includes('admin-clients')) {
        loadClients();
    } else if (path.includes('admin-inventory')) {
        loadInventoryScreen();
    } else if (path.includes('worker-management')) {
        loadWorkerScreen();
    } else if (path.includes('admin-expenses')) {
        loadAdminExpensesScreen();
    } else if (path.includes('expenses')) {
        loadExpensesScreen();
    } else if (path.includes('worker-assignments')) {
        loadWorkerAssignments();
    } else if (path.includes('order-form')) {
        if (USER_PROFILE?.role === 'owner') {
            initAdminOrderForm();
        } else {
            initOrderForm();
        }
    } else if (path.includes('admin-analytics')) {
        loadBIAnalytics();
    }
}

function addRefreshButton() {
    // Refresh buttons are now built into header HTML, so this function is kept for compatibility
    // but no longer adds the button programmatically
}

// ==========================================
// ðŸ‘‘ SUPERADMIN MODULE
// ==========================================











async function updateLastSeen() {
    if (!USER_PROFILE || !USER_PROFILE.id) return;

    // Throttle: Only update if last update was more than 1 minute ago
    const lastUpdate = localStorage.getItem('last_seen_update');
    const now = Date.now();
    if (lastUpdate && (now - parseInt(lastUpdate)) < 60000) return;

    try {
        await supabaseClient
            .from('user_profiles')
            .update({ last_seen_at: new Date().toISOString() })
            .eq('id', USER_PROFILE.id);
        
        localStorage.setItem('last_seen_update', now.toString());
    } catch (err) {
        console.error("Heartbeat error:", err);
    }
}



function getRelativeTime(date) {
    const now = new Date();
    const diff = Math.floor((now - date) / 1000);
    
    if (diff < 60) return 'Just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    if (diff < 604800) return `${Math.floor(diff / 86400)}d ago`;
    return date.toLocaleDateString();
}





;

;

;

;

// ==========================================
// ðŸ‘” MANAGER MODULE - ORDERS
// ==========================================



// ==========================================
// ðŸ‘” MANAGER MODULE - WORKER MANAGEMENT
// ==========================================




// [NEW] Load Workers into Checkbox List for Squad Selection






// ==========================================
// ðŸ‘” MANAGER MODULE - ORDER FORM
// ==========================================



function generateMeasurementFieldsManager() {
    const garmentType = document.getElementById('garment-type-select').value;
    const container = document.getElementById('measurement-fields-container');
    const fieldset = document.getElementById('measurement-fieldset');

    if (!container || !garmentType) return;

    if (fieldset) {
        fieldset.style.display = 'block';
    }

    const measurements = GARMENT_MEASUREMENTS[garmentType];
    if (!measurements) {
        container.innerHTML = '<p>No measurements needed for this garment type.</p>';
        return;
    }

    let html = '';
    for (const [component, fields] of Object.entries(measurements)) {
        html += `<div class="measurement-group">
            <h4>${component}</h4>
            <div class="measurement-fields">`;

        fields.forEach(field => {
            html += `
                <div class="measurement-field">
                    <label>${field}</label>
                    <input type="number" step="0.1" placeholder="inches" 
                           data-component="${component}" data-measurement="${field}">
                </div>
            `;
        });

        html += '</div></div>';
    }
    container.innerHTML = html;

    // [NEW] Intelligently auto-fill measurements if there's a selected client with history for this garment
    if (window.CURRENT_SELECTED_CLIENT) {
        autoFillMeasurementsIfAvailable('measurement-fields-container', garmentType);
    }
}

// ==========================================
// ðŸ‘” MANAGER MODULE - EXPENSES
// ==========================================





// ==========================================
// ðŸ‘” MANAGER MODULE - ORDER DETAILS
// ==========================================



// ==========================================
// ðŸ“„ RECEIPT SYSTEM (CORE LOGIC FOR GENERATE RECEIPT FIX)
// ==========================================





;















async function loadScript(src) {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}

// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDERS

// Redundant loadAdminOrders removed - moved and updated below at line 2082






// ==========================================













// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDERS
// ==========================================



// [NEW] Tracking Link Sharing Function



// [NEW] Debounce Helper for Search
let adminSearchTimeout = null;
;





// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDER DETAILS (FIXED)
// ==========================================







// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN MANAGEMENT
// ==========================================





;

// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDER FORM
// ==========================================

























// ==========================================
// ðŸ’° PAYMENT FUNCTIONS
// ==========================================

;

;

// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDER DETAILS (FINAL VERSION)
// ==========================================









// ==========================================
// ðŸ“„ INVOICING ENGINE â€” NUCLEAR REWRITE
// Uses window.open + browser print (pixel-perfect, no html2canvas bugs)
// ==========================================

/**
 * Builds a complete, standalone print-ready HTML page for invoices & requisitions.
 * Opens it in a new window and triggers the browser's print dialog.
 */


/**
 * Opens the invoice in a new window and triggers the browser print dialog.
 * Works for both expense requisitions and order invoices.
 */


// â”€â”€â”€ EXPENSE REQUISITION â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

;

// â”€â”€â”€ ORDER INVOICE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

;



// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN MANAGEMENT
// ==========================================

















;

// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN ORDER FORM
// ==========================================







// ==========================================
// ðŸ‘‘ OWNER MODULE - ADMIN EXPENSES
// ==========================================















// ==========================================
// ðŸš€ MODERN BI & ANALYTICS MODULE
// ==========================================


























// ==========================================
// ðŸ’° PAYMENT FUNCTIONS
// ==========================================

;

;

// ==========================================
// ðŸ APPLICATION INITIALIZATION
// ==========================================




window.addEventListener('DOMContentLoaded', function () {
    // --- 🎨 AUTO-BRANDING (Master Template Feature) ---
    if (typeof APP_CONFIG !== 'undefined') {
        // B. Update Dashboard Sidebar (Initial guess from config)
        updateSidebarBranding();

        // C. Update Login Screen (If on login page) [NEW FIX]
        const loginName = document.getElementById('dynamic-login-name');
        if (loginName) {
            loginName.textContent = APP_CONFIG.appName;
            loginName.style.fontSize = "1.8em";
        }

        const loginSubtitle = document.getElementById('dynamic-login-subtitle');
        if (loginSubtitle) loginSubtitle.textContent = APP_CONFIG.appSubtitle;
    }

    logDebug("DOM loaded, initializing application", null, 'info');

    // Initialize debugger (now just for compatibility)
    initDebugger();

    // Setup login form
    const loginForm = document.getElementById('auth-form');
    if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);
    }

    // Enable login button
    const loginBtn = document.getElementById('login-button');
    if (loginBtn) {
        loginBtn.disabled = false;
        loginBtn.textContent = 'Sign In';
    }

    // Setup logout button
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }

    // Setup new order button (manager)
    const addOrderBtn = document.getElementById('add-order-btn');
    if (addOrderBtn) {
        addOrderBtn.addEventListener('click', (e) => {
            e.preventDefault();
            window.location.href = '/views/manager/order-form.html';
        });
    }

    // Setup filters
    const filterIds = [
        'admin-shop-filter', 'admin-status-filter',
        'financial-shop-filter', 'shop-filter',
        'status-filter', 'worker-filter'
    ];

    filterIds.forEach(id => {
        const filter = document.getElementById(id);
        if (filter) {
            filter.addEventListener('change', () => {
                const path = window.location.pathname;

                if (id.includes('financial')) {
                    loadAnalyticsDashboard();
                }
                else if (id.includes('admin')) {
                    if (id === 'admin-shop-filter') {
                        const shopSelect = document.getElementById('admin-shop-filter');
                        const selectedText = shopSelect.options[shopSelect.selectedIndex]?.text;
                        if (selectedText && !selectedText.includes('All')) {
                            updateSidebarBranding(selectedText);
                        } else {
                            updateSidebarBranding(); // Reset to default
                        }
                    }
                    if (path.includes('current-orders')) {
                        loadAdminOrders('current');
                    } else if (path.includes('all-orders')) {
                        loadAdminOrders('all');
                    }
                }
                else if (id.includes('shop-filter') && !id.includes('admin')) {
                    loadPendingClosureOrders();
                }
                else if (id.includes('status-filter') || id.includes('worker-filter')) {
                    if (path.includes('manager-dashboard')) {
                        loadOrders('open');
                    }
                    else if (path.includes('all-orders') && !path.includes('admin')) {
                        loadOrders('all');
                    }
                }
            });
        }
    });

    // Load session
    checkSession();

    // FIX 2: Explicitly attach core functions to window to prevent "ReferenceError: XXX is not defined"
    window.refreshCurrentView = refreshCurrentView;
    window.generateAndShareReceipt = generateAndShareReceipt;
    window.saveAdminOrder = saveAdminOrder;
    window.downloadOrderPDF = downloadOrderPDF;
    window.deleteOrder = deleteOrder;
    window.openResetPasswordModal = openResetPasswordModal;
    window.handlePasswordReset = handlePasswordReset;
    window.fireManager = fireManager;
    window.deleteShop = deleteShop;
    window.deleteWorker = deleteWorker;
    window.closeAdminModal = closeAdminModal;
    window.handleLogin = handleLogin;
    window.handleLogout = handleLogout;

    logDebug("Application initialized successfully", null, 'success');
});

// Clean up charts on page unload
window.addEventListener('beforeunload', function () {
    Object.values(analyticsCharts).forEach(chart => {
        if (chart && typeof chart.destroy === 'function') {
            try {
                chart.destroy();
            } catch (e) {
                // Ignore
            }
        }
    });
});

// ==========================================
// 💰 PAYMENT EDITING FUNCTIONS
// ==========================================

let SELECTED_PAYMENT_ID = null; // Track which payment is being edited









// Close modal when clicking outside of it
window.addEventListener('click', (e) => {
    const modal = document.getElementById('payment-edit-modal');
    if (e.target === modal) {
        closePaymentModal();
    }
});

// ==========================================
// 💰 PAYMENT DISPLAY ENHANCEMENT
// ==========================================
// This function transforms the payment history display to add edit/delete buttons


// Override the original loadAdminOrderDetails to call our enhancement
const originalLoadAdminOrderDetails = loadAdminOrderDetails;
;

// ==========================================
// 🚀 NEW ANALYTICS FEATURES
// ==========================================












// ============================================
// CUSTOM INVOICE GENERATOR (Admin Dashboard)
// ============================================

window.openCustomInvoiceModal = function () {
    const modal = document.getElementById('custom-invoice-modal');
    if (modal) {
        // Pre-fill today's date
        document.getElementById('ci-date').value = new Date().toISOString().split('T')[0];
        modal.style.display = 'flex';
    }
};

window.closeCustomInvoiceModal = function () {
    const modal = document.getElementById('custom-invoice-modal');
    if (modal) {
        modal.style.display = 'none';
        // Clear form
        document.getElementById('ci-billed-to').value = '';
        document.getElementById('ci-description').value = '';
        document.getElementById('ci-amount').value = '';
        document.getElementById('ci-notes').value = '';
    }
};

window.generateCustomInvoice = async function () {
    try {
        const billedTo = document.getElementById('ci-billed-to').value.trim();
        const description = document.getElementById('ci-description').value.trim();
        const amountStr = document.getElementById('ci-amount').value;
        const dateVal = document.getElementById('ci-date').value;
        const notes = document.getElementById('ci-notes').value.trim();

        if (!billedTo || !description || !amountStr || !dateVal) {
            return alert("Please fill in all required fields.");
        }

        const amount = parseFloat(amountStr);
        const dateStr = new Date(dateVal).toLocaleDateString();
        const shopName = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.appName) ? APP_CONFIG.appName.toUpperCase() : "FASHION HOUSE";
        const invoiceId = 'CUST-' + Math.floor(Math.random() * 1000000).toString().padStart(6, '0');

        // Build HTML
        const invoiceHTML = `
            <div id="temp-custom-invoice-container" style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding: 40px; color: #333; background: #fff;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; border-bottom: 2px solid #333; padding-bottom: 20px;">
                    <div style="display: flex; gap: 15px; align-items: center;">
                        ${(typeof APP_CONFIG !== 'undefined' && APP_CONFIG.logoPath) ? `<img src="${APP_CONFIG.logoPath}" alt="Logo" style="height: 60px; width: auto; object-fit: contain;">` : ''}
                        <div>
                            <h1 style="margin: 0; font-size: 2em; letter-spacing: 2px; color: #000;">${shopName}</h1>
                            <p style="margin: 5px 0 0 0; color: #666;">Official Invoice</p>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <h2 style="margin: 0; font-size: 1.8em; color: #3b82f6; text-transform: uppercase;">INVOICE</h2>
                        <p style="margin: 5px 0 2px 0;"><strong>Date:</strong> ${dateStr}</p>
                        <p style="margin: 0;"><strong>Invoice:</strong> #${invoiceId}</p>
                    </div>
                </div>

                <div style="margin-bottom: 40px;">
                    <h3 style="margin: 0 0 10px 0; color: #666; font-size: 0.9em; text-transform: uppercase;">Billed To:</h3>
                    <p style="margin: 0; font-size: 1.2em; font-weight: bold;">${billedTo}</p>
                </div>

                <table style="width: 100%; border-collapse: collapse; margin-bottom: 30px;">
                    <thead>
                        <tr style="background: #f8fafc; border-bottom: 2px solid #cbd5e1;">
                            <th style="padding: 12px; text-align: left; font-weight: bold; color: #475569;">Description</th>
                            <th style="padding: 12px; text-align: right; font-weight: bold; color: #475569;">Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="padding: 15px 12px; border-bottom: 1px solid #e2e8f0; font-weight: 500;">${description}</td>
                            <td style="padding: 15px 12px; border-bottom: 1px solid #e2e8f0; text-align: right; font-weight: bold;">${formatCurrency(amount)}</td>
                        </tr>
                        ${notes ? `
                        <tr>
                            <td colspan="2" style="padding: 10px 12px; border-bottom: 1px solid #e2e8f0; font-style: italic; color: #64748b; font-size: 0.9em;">
                                Notes: ${notes}
                            </td>
                        </tr>
                        ` : ''}
                    </tbody>
                </table>

                <div style="display: flex; justify-content: flex-end;">
                    <table style="width: 300px; border-collapse: collapse;">
                        <tr>
                            <td style="padding: 15px 12px; font-weight: bold; font-size: 1.2em; color: #0f172a;">Total Due:</td>
                            <td style="padding: 15px 12px; text-align: right; font-weight: bold; font-size: 1.2em; color: #0f172a;">${formatCurrency(amount)}</td>
                        </tr>
                    </table>
                </div>

                <div style="margin-top: 60px; padding-top: 20px; border-top: 1px solid #e2e8f0; text-align: center; color: #64748b; font-size: 0.9em;">
                    <p style="margin: 0;">Thank you for your business.</p>
                </div>
            </div>
        `;

        // Inject temporarily into DOM to print
        const wrapper = document.createElement('div');
        wrapper.innerHTML = invoiceHTML;
        wrapper.style.position = 'absolute';
        wrapper.style.left = '-9999px';
        document.body.appendChild(wrapper);

        const element = wrapper.firstElementChild;
        let cName = billedTo.replace(/[^a-z0-9]/gi, '_').toLowerCase();

        const opt = {
            margin: 0.3,
            filename: `Invoice_${cName}_${invoiceId}.pdf`,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: {
                scale: 3,
                useCORS: true,
                width: 680,
                windowWidth: 700
            },
            jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
        };

        // Download and cleanup
        if (typeof html2canvas === 'undefined' || typeof html2pdf === 'undefined') {
            await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
            await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js');
        }

        const btn = document.querySelector('#custom-invoice-modal button[type="submit"]');
        const origText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generating...';
        btn.disabled = true;

        // NUCLEAR FIX: Wait for assets
        try {
            if (document.fonts) await document.fonts.ready;
            // Small layout settle delay
            await new Promise(r => setTimeout(r, 400));
        } catch (e) { console.error("Asset wait error", e); }

        await html2pdf().set(opt).from(element).save();

        btn.innerHTML = origText;
        btn.disabled = false;

        document.body.removeChild(wrapper);
        closeCustomInvoiceModal();

    } catch (error) {
        logDebug("Error generating custom invoice", error, 'error');
        alert("An error occurred while generating the invoice.");
        const btn = document.querySelector('#custom-invoice-modal button[type="submit"]');
        if (btn) {
            btn.innerHTML = '<i class="fas fa-download"></i> Download PDF Invoice';
            btn.disabled = false;
        }
    }
};

// ==========================================
// 👔 OWNER MODULE - MANAGEMENT & SETUP
// ==========================================















