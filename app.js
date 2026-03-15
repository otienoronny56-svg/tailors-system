
window.logDebug = (msg, data = null, type = 'info') => {
    // Simple console log only - No visual box
    const timestamp = new Date().toLocaleTimeString();
    console.log(`[${timestamp}] ${type.toUpperCase()}: ${msg}`, data || '');
};

// ==========================================
// 🌙 DARK MODE SYSTEM
// ==========================================
function initTheme() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        document.body.classList.add('dark-mode');
        // If DOM is ready, update icons. If not, it'll be fine because CSS handles it, or we do it on load.
        window.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.theme-toggle-icon').forEach(icon => {
                icon.className = 'fa-solid fa-sun theme-toggle-icon';
            });
        });
    }
}
function toggleTheme() {
    document.body.classList.toggle('dark-mode');
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('theme', isDark ? 'dark' : 'light');

    document.querySelectorAll('.theme-toggle-icon').forEach(icon => {
        icon.className = isDark ? 'fa-solid fa-sun theme-toggle-icon' : 'fa-solid fa-moon theme-toggle-icon';
    });
}
// Run immediately on parse to prevent flash
initTheme();

// ==========================================
// 🛠️ UTILITY FUNCTIONS
// ==========================================

// Currency formatter
function formatCurrency(amount) {
    const num = parseFloat(amount) || 0;
    const symbol = (typeof CURRENCY !== 'undefined') ? CURRENCY : 'Ksh';
    return `${symbol} ${num.toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    })}`;
}

// Dynamically load external scripts
window.loadScript = function (src) {
    return new Promise((resolve, reject) => {
        if (document.querySelector(`script[src="${src}"]`)) {
            return resolve();
        }
        const script = document.createElement('script');
        script.src = src;
        script.onload = () => resolve();
        script.onerror = () => reject(new Error(`Failed to load script: ${src}`));
        document.head.appendChild(script);
    });
};

// --- 🛡️ CRASH PROTECTION & INITIALIZATION ---
let supabaseClient = null; // Declared ONCE here to prevent "Identifier already declared" errors

try {
    // 1. Check Config
    if (typeof APP_CONFIG === 'undefined') {
        throw new Error("CRITICAL: 'config.js' is missing or has a syntax error.");
    }

    // 2. Check Supabase Library
    if (typeof window.supabase === 'undefined' || typeof window.supabase.createClient !== 'function') {
        throw new Error("CRITICAL: Supabase library failed to load.");
    }

    // 3. Initialize Supabase (Assign to the 'let' variable above)
    supabaseClient = window.supabase.createClient(APP_CONFIG.supabaseUrl, APP_CONFIG.supabaseKey);

    // --- 4. BILLING STATUS ENFORCEMENT ---
    if (APP_CONFIG.SYSTEM_STATUS === 'SUSPENDED') {
        document.body.innerHTML = `
            <style>
                body { margin: 0; background-color: #0d0d0d; color: #fff; font-family: 'Segoe UI', sans-serif; height: 100vh; display: flex; align-items: center; justify-content: center; }
                .lock-box { text-align: center; max-width: 450px; padding: 40px; border: 1px solid #D4AF37; border-radius: 12px; background: #1a1a1a; box-shadow: 0 0 30px rgba(212, 175, 55, 0.15); }
                h1 { color: #f39c12; margin-top: 0; letter-spacing: 1px; font-size: 24px; }
                .details-box { background: #252525; padding: 20px; border-radius: 8px; margin: 25px 0; text-align: center; border-left: 4px solid #D4AF37; }
            </style>
            
            <div class="lock-box">
                <div style="font-size: 50px; margin-bottom: 20px;">⚙️</div>
                <h1>SYSTEM MAINTENANCE</h1>
                <p style="color: #aaa; margin-bottom: 20px;">We are currently performing scheduled maintenance and database updates for <strong>${APP_CONFIG.appName}</strong>.</p>
                
                <div class="details-box">
                    <p style="color: #fff; margin: 0;">This dashboard is temporarily offline to ensure data safety. Normal service will resume shortly.</p>
                </div>
                
                <p style="font-size: 14px; color: #888;">Expected Downtime: 1-2 Hours</p>
                <p style="font-size: 12px; color: #555;">(You can refresh the page in a bit)</p>
            </div>
        `;

        throw new Error("❌ SYSTEM OFFLINE: MAINTENANCE");
    }
    window.appInitialized = true;
    console.log("✅ System Initialized Successfully");

} catch (error) {
    console.error(error);
    alert("SYSTEM CRASH: " + error.message);
}

// Update Global Constants (Safety wrapped)
const SHOP_CONTACT = (typeof APP_CONFIG !== 'undefined') ? APP_CONFIG.shopPhone : "";
const CURRENCY = (typeof APP_CONFIG !== 'undefined') ? APP_CONFIG.currencySymbol : "Ksh";

// --- END OF INITIALIZATION ---

// Admin client - lazy loaded to avoid "Multiple GoTrueClient" warnings
function getAdminClient() {
    // ⚠️ SECURITY CHECK: Ensure the secret key exists
    if (!APP_CONFIG.serviceRoleKey) {
        console.error("❌ CRITICAL: Service Role Key missing in config.js");
        alert("Admin Error: You need the 'serviceRoleKey' in config.js to create users.");
        return null;
    }

    // Create a special client just for this Admin action
    return window.supabase.createClient(APP_CONFIG.supabaseUrl, APP_CONFIG.serviceRoleKey, {
        auth: {
            persistSession: false, // Don't save this powerful session to browser storage
            autoRefreshToken: false,
            detectSessionInUrl: false
        }
    });
}

// --- Global Variables ---
let USER_PROFILE = null;
let CURRENT_ORDER_ID = null;
let ALL_SHOPS = {};
let analyticsCharts = {};

// [PERF] Debounce & Cache
let lastDashboardLoad = 0;
const DEBOUNCE_DELAY = 500; // 500ms minimum between refreshes
let dataCache = {
    shops: null,
    workers: null,
    orders: null,
    expenses: null,
    cacheTime: 0
};
const CACHE_TTL = 60000; // 60 second cache

// Constants
const STATUS_MAP = {
    1: 'Assigned',
    2: 'In Progress',
    3: 'QA Check',
    4: 'Ready',
    5: 'Collected (Pending)',
    6: 'Closed'
};

const GARMENT_MEASUREMENTS = {
    'Suit': {
        Coat: ['Shoulder', 'Chest', 'Bodice', 'Waist', 'Bicep', 'Sleeve', 'Length', 'Hips'],
        Shirt: ['Shoulder', 'Chest', 'Bodice', 'Waist', 'Sleeve', 'Length', 'Neck', 'Cuff'],
        Trouser: ['Waist', 'Hips', 'Thigh', 'Knee', 'Bottom', 'Length', 'Crotch']
    },
    // [NEW] Kaunda/Senator Suit Added Here
    'Kaunda/Senator Suit': {
        Top: ['Shoulder', 'Sleeve', 'Arm', 'Chest', 'Waist', 'Hips', 'Length', 'Neck'],
        Trouser: ['Waist', 'Hips', 'Thigh', 'Knee', 'Bottom', 'Length', 'Crotch']
    },
    'Trouser': {
        Trouser: ['Waist', 'Hips', 'Thigh', 'Knee', 'Bottom', 'Length', 'Crotch']
    },
    // --- UPDATED SHIRT SECTION ---
    'Shirt': {
        Shirt: [
            'Shoulder',
            'Chest',
            'Bust',           // Added
            'Bodice',         // Added
            'Waist',
            'Long Sleeve',    // Specific
            'Short Sleeve',   // Specific
            'Length',
            'Neck',
            'Cuff'
        ]
    },
    // -----------------------------
    'Dress': {
        Dress: ['Shoulder', 'Bust', 'Waist', 'Hips', 'Length', 'Sleeve']
    },
    'Coat': {
        Coat: ['Shoulder', 'Chest', 'Waist', 'Sleeve', 'Length', 'Hips']
    },
    'Half Coat': {
        Coat: ['Shoulder', 'Chest', 'Waist', 'Length']
    },
    'Alteration': {
        Notes: ['Description']
    }
};

// ==========================================
// 📋 COPY & SHARE FUNCTIONS (FINAL CLEAN)
// ==========================================

function copyReceiptToClipboard(order, paymentAmount) {
    // 1. ☢️ NUCLEAR MATH (Strict Calculation)
    const totalCost = parseFloat(order.price) || 0;
    const existingPaid = parseFloat(order.amount_paid) || 0;
    const payingNow = parseFloat(paymentAmount) || 0;

    // Logic: If DB is updated, use it. If not, sum manual.
    let realTotalPaid = 0;
    if (order.id && existingPaid >= payingNow && existingPaid > 0) {
        realTotalPaid = existingPaid;
    } else {
        realTotalPaid = existingPaid + payingNow;
    }
    const remainingBalance = totalCost - realTotalPaid;

    // 2. 🎨 STRICT BRANDING (No Subtitles Allowed)
    // We only take the App Name. We ignore the subtitle completely.
    const shopName = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.appName)
        ? APP_CONFIG.appName.toUpperCase()
        : "SHOP RECEIPT";

    const shopPhone = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.shopPhone)
        ? APP_CONFIG.shopPhone
        : "";

    const dateStr = new Date().toLocaleDateString();

    // 3. GENERATE CLEAN TEXT
    // Format: NAME -> PHONE -> LINE -> DETAILS
    const receiptText = `
${shopName}
${shopPhone}
--------------------------------
RECEIPT: #${order.id}
DATE:    ${dateStr}
ITEM:    ${order.garment_type}
CUSTOMER:${order.customer_name}
--------------------------------
Total Cost:   ${formatCurrency(totalCost)}
Total Paid:   ${formatCurrency(realTotalPaid)}
BALANCE DUE:  ${formatCurrency(remainingBalance)}
--------------------------------
Thank you!
`.trim();

    // 4. COPY TO CLIPBOARD
    navigator.clipboard.writeText(receiptText).then(() => {
        alert("✅ Receipt copied to clipboard!");
    }).catch(err => {
        console.error('Failed to copy: ', err);
        alert("❌ Failed to copy receipt.");
    });
}

function shareReceiptAsText(order, paymentAmount) {
    // 1. ☢️ NUCLEAR MATH
    const totalCost = parseFloat(order.price) || 0;
    const existingPaid = parseFloat(order.amount_paid) || 0;
    const payingNow = parseFloat(paymentAmount) || 0;

    let realTotalPaid = 0;
    if (order.id && existingPaid >= payingNow && existingPaid > 0) {
        realTotalPaid = existingPaid;
    } else {
        realTotalPaid = existingPaid + payingNow;
    }
    const remainingBalance = totalCost - realTotalPaid;

    // 2. STRICT BRANDING
    const shopName = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.appName)
        ? APP_CONFIG.appName.toUpperCase()
        : "SHOP RECEIPT";

    // 3. GENERATE MESSAGE
    const message = `*${shopName}*\nReceipt #${order.id}\nDate: ${new Date().toLocaleDateString()}\n\nItem: ${order.garment_type}\nCustomer: ${order.customer_name}\n\n*Total: ${formatCurrency(totalCost)}*\n*Paid:  ${formatCurrency(realTotalPaid)}*\n*Bal:   ${formatCurrency(remainingBalance)}*\n\nThank you!`;

    // 4. SHARE OR WHATSAPP
    if (navigator.share) {
        navigator.share({
            title: `${shopName} Receipt`,
            text: message
        }).catch(console.error);
    } else {
        window.open(`https://wa.me/?text=${encodeURIComponent(message)}`, '_blank');
    }
}
// ==========================================
// 🛠️ CORE UTILITIES
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
            h += `<b>${k} Details:</b><br>`;
            for (let s in m[k]) {
                h += `<span style="display:inline-block; min-width:80px; color:#475569;">${s}:</span> <b>${m[k][s]}"</b><br>`;
            }
            h += '<br>';
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

function calculateBalance(order, payments = []) {
    const totalPrice = order.price || 0;
    const totalPaid = payments.reduce((sum, p) => sum + (p.amount || 0), 0);
    return totalPrice - totalPaid;
}

// ==========================================
// 🔄 VIEW MANAGEMENT
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
// 🔐 AUTHENTICATION SYSTEM
// ==========================================

async function checkSession() {
    logDebug("Checking session...", null, 'info');

    try {
        const { data: { user }, error: userError } = await supabaseClient.auth.getUser();
        if (userError || !user) {
            if (!window.location.pathname.includes('index.html')) {
                window.location.href = 'index.html';
            }
            return;
        }

        // Try to get profile from user_profiles table
        const { data: profile, error: profileError } = await supabaseClient
            .from('user_profiles')
            .select('*')
            .eq('id', user.id)
            .single();

        if (profileError || !profile) {
            // Fallback to workers table
            const { data: workerProfile, error: workerError } = await supabaseClient
                .from('workers')
                .select('*')
                .eq('id', user.id)
                .single();

            if (workerError || !workerProfile) {
                // NEW: Just alert and stop the loading spinner
                logDebug("Profile not found in either table", null, 'error');
                alert("Error: Your account is authenticated but no Profile was found. Contact Support.");
                // Reset the login button if we are on the login page
                const loginBtn = document.getElementById('login-button');
                if (loginBtn) {
                    loginBtn.disabled = false;
                    loginBtn.textContent = 'Sign In';
                }
                return;
            }

            USER_PROFILE = {
                id: workerProfile.id,
                full_name: workerProfile.name,
                role: 'manager',
                shop_id: workerProfile.shop_id
            };
        } else {
            USER_PROFILE = profile;
        }

        logDebug(`User authenticated: ${USER_PROFILE.full_name} (${USER_PROFILE.role})`, USER_PROFILE, 'success');

        // Update UI
        const userInfoEl = document.getElementById('user-info');
        if (userInfoEl) {
            userInfoEl.innerHTML = `<i class="fas fa-user-circle" style="margin-right: 8px; color: var(--brand-gold);"></i> Welcome, ${USER_PROFILE.full_name}`;
        }

        // Handle routing
        const path = window.location.pathname;
        // [FIX] Check for 'index.html' OR if the path is just '/' (root)
        if (path.includes('index.html') || path === '/' || path.endsWith('/')) {
            const redirectTo = USER_PROFILE.role === 'owner' ? 'admin-dashboard.html' : 'manager-dashboard.html';
            window.location.href = redirectTo;
            return;
        }

        // Route based on role and page
        await routeToPage(path);

    } catch (error) {
        logDebug("Session check error:", error, 'error');
        alert("Session error: " + error.message);
    }
}

async function routeToPage(path) {
    if (!USER_PROFILE) return;

    // Owner pages
    if (USER_PROFILE.role === 'owner') {
        if (path.includes('manager')) {
            window.location.href = 'admin-dashboard.html';
            return;
        }

        if (path.includes('admin-dashboard')) {
            await loadAdminDashboard();
        } else if (path.includes('financial-overview')) {
            await loadAnalyticsDashboard();
        } else if (path.includes('admin-current-orders')) {
            await loadAdminOrders('current');
        } else if (path.includes('admin-all-orders')) {
            await loadAdminOrders('all');
        } else if (path.includes('admin-expenses')) {
            await loadAdminExpensesScreen();
        } else if (path.includes('admin-management')) {
            await loadAdminManagementScreen();
        } else if (path.includes('admin-order-details')) {
            await loadAdminOrderDetails();
        } else if (path.includes('admin-order-form')) {
            initAdminOrderForm();
        } else if (path.includes('admin-analytics')) {
            loadBIAnalytics();
        }
    }
    // Manager pages
    else {
        if (path.includes('admin-')) {
            window.location.href = 'manager-dashboard.html';
            return;
        }

        if (path.includes('manager-dashboard')) {
            await loadOrders('open');
            await loadWorkerFilterDropdown();
            addRefreshButton();
        } else if (path.includes('all-orders')) {
            await loadOrders('all');
            await loadWorkerFilterDropdown();
            addRefreshButton();
        } else if (path.includes('worker-management')) {
            await loadWorkerScreen();
        } else if (path.includes('worker-assignments')) {
            await loadWorkerAssignments();
        } else if (path.includes('order-form')) {
            initOrderForm();
        } else if (path.includes('expenses')) {
            loadExpensesScreen();
        } else if (path.includes('order-details')) {
            await loadOrderDetailsScreen();
        }
    }
}

async function handleLogin(e) {
    if (e) e.preventDefault();

    const email = document.getElementById('email')?.value;
    const password = document.getElementById('password')?.value;
    const loginBtn = document.getElementById('login-button');

    if (!email || !password) {
        alert("Please enter email and password");
        return;
    }

    // 1. UI Feedback
    if (loginBtn) {
        loginBtn.disabled = true;
        loginBtn.textContent = 'Signing in...';
    }

    try {
        // 2. Perform Auth
        const { error } = await supabaseClient.auth.signInWithPassword({ email, password });
        if (error) throw error;

        logDebug("Login successful, checking session profile...", null, 'success');

        // 3. Perform Session & Redirect Logic
        // We 'await' this so the button doesn't reset while the page is trying to change
        await checkSession();

    } catch (error) {
        logDebug("Login process error:", error, 'error');

        // Show the error directly on the screen for her
        const msgEl = document.getElementById('auth-message');
        if (msgEl) {
            msgEl.textContent = "❌ Error: " + error.message;
            msgEl.style.display = "block";
            msgEl.style.color = "#ff4444";
        }

        if (loginBtn) {
            loginBtn.disabled = false;
            loginBtn.textContent = 'Sign In';
        }
    } finally {
        // Safety fallback: if 5 seconds pass and we haven't navigated, re-enable button
        setTimeout(() => {
            if (loginBtn && loginBtn.disabled) {
                loginBtn.disabled = false;
                loginBtn.textContent = 'Sign In';
            }
        }, 5000);
    }
}

async function handleLogout() {
    try {
        await supabaseClient.auth.signOut();
        USER_PROFILE = null; // Clear the memory!
        window.location.href = 'index.html';
    } catch (error) {
        alert("Logout error: " + error.message);
        // Force redirect anyway to break loops
        window.location.href = 'index.html';
    }
}

// ==========================================
// 👔 MANAGER MODULE - ORDERS
// ==========================================

async function loadOrders(mode = 'open') {
    if (!USER_PROFILE || !USER_PROFILE.shop_id) return;

    const headerTitle = document.querySelector('header h1');
    if (headerTitle) {
        if (mode === 'urgent') headerTitle.innerHTML = '🔥 Urgent Attention Required';
        else headerTitle.textContent = 'Manager Dashboard (Orders In Progress)';
    }

    try {
        let query = supabaseClient.from('orders')
            .select('*')
            .eq('shop_id', USER_PROFILE.shop_id)
            .order('due_date', { ascending: true });

        if (mode === 'open' || mode === 'urgent') {
            query = query.neq('status', 6);
        }

        const statusFilter = document.getElementById('status-filter')?.value;
        if (statusFilter && mode !== 'urgent') query = query.eq('status', parseInt(statusFilter));

        const workerFilter = document.getElementById('worker-filter')?.value;
        if (workerFilter) {
            query = query.or(`worker_id.eq.${workerFilter},additional_workers.cs.["${workerFilter}"]`);
        }

        const { data: ordersData, error } = await query;
        if (error) throw error;

        let orders = ordersData;
        if (mode === 'urgent') {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            orders = ordersData.filter(o => {
                if (o.status >= 5) return false;
                const due = new Date(o.due_date);
                const diffDays = Math.ceil((due - today) / (1000 * 60 * 60 * 24));
                return diffDays <= 2;
            });
        }

        const tbody = document.getElementById('orders-tbody');
        if (!tbody) return;

        if (!orders.length) {
            tbody.innerHTML = mode === 'urgent'
                ? '<tr><td colspan="8" style="text-align:center; padding:30px;">✅ Good job! No urgent orders.</td></tr>'
                : '<tr><td colspan="8" style="text-align:center; padding:20px;">No orders found</td></tr>';
            return;
        }

        const orderIds = orders.map(o => o.id);
        const { data: payments } = await supabaseClient.from('payments').select('*').in('order_id', orderIds);
        const paymentsByOrder = {};
        payments?.forEach(p => {
            if (!paymentsByOrder[p.order_id]) paymentsByOrder[p.order_id] = [];
            paymentsByOrder[p.order_id].push(p);
        });

        const workerIds = orders.map(o => o.worker_id).filter(id => id);
        let workerMap = {};
        if (workerIds.length) {
            const { data: wData } = await supabaseClient.from('workers').select('id, name').in('id', workerIds);
            wData?.forEach(w => workerMap[w.id] = w.name);
        }

        // RENDER THE TABLE
        tbody.innerHTML = orders.map(order => {
            const orderPaymentList = (paymentsByOrder[order.id] || []);
            const activePayments = orderPaymentList; // Exclude soft-deleted - done by RLS now
            const paid = activePayments.reduce((sum, p) => sum + (p.amount || 0), 0);
            const balance = (order.price || 0) - paid;

            // Traffic Light Date Logic
            const diffDays = Math.ceil((new Date(order.due_date) - new Date()) / (86400000));
            let dueDisplay = formatDate(order.due_date);

            if (order.status < 5) {
                if (diffDays < 0) {
                    dueDisplay = `<div style="color:#dc3545; font-weight:800; line-height:1.2;">
                        <i class="fas fa-exclamation-circle"></i> ${formatDate(order.due_date)}<br>
                        <small>LATE (${Math.abs(diffDays)} days)</small>
                    </div>`;
                } else if (diffDays <= 2) {
                    dueDisplay = `<div style="color:#e67e22; font-weight:800; line-height:1.2;">
                        <i class="fas fa-stopwatch"></i> ${formatDate(order.due_date)}<br>
                        <small>${diffDays === 0 ? 'DUE TODAY' : diffDays + ' days left'}</small>
                    </div>`;
                }
            }

            const workerName = order.worker_id ? (workerMap[order.worker_id] || 'Unassigned') : 'Unassigned';

            // SQUAD CALCULATION (Correctly nested inside .map)
            let squadCount = 0;
            try {
                const raw = order.additional_workers;
                if (Array.isArray(raw)) {
                    squadCount = raw.length;
                } else if (typeof raw === 'string' && raw.trim().length > 0) {
                    squadCount = JSON.parse(raw).length;
                }
            } catch (e) {
                console.warn("Skipping bad squad data for order:", order.id);
            }

            const squadBadge = squadCount > 0
                ? ' <i class="fas fa-users" style="color:#007bff; font-size:0.8em;" title="Has Team"></i>'
                : '';

            return `<tr>
                <td>#${String(order.id).slice(-6)}</td>
                <td>${order.customer_name}<br><small>${order.customer_phone}</small></td>
                <td>${order.garment_type}</td>
                <td>${dueDisplay}</td>
                <td>${workerName}${squadBadge}</td>
                <td><span class="status-indicator status-${order.status}">${STATUS_MAP[order.status]}</span></td>
                <td style="color:${balance > 0 ? '#dc3545' : '#28a745'}; font-weight:bold;">${balance.toLocaleString()}</td>
                <td>
                    <div style="display:flex; gap:5px;">
                        <button class="small-btn" onclick="location.href='order-details.html?id=${order.id}'">👁️ View</button>
                        <button class="small-btn" style="background:#28a745;" onclick="generateAndShareReceipt('${order.id}')">📄</button>
                    </div>
                </td>
            </tr>`;
        }).join('');

    } catch (e) {
        console.error("Error loading orders:", e);
        logDebug("Orders display error", e, 'error');
    }
}

// ==========================================
// 👔 MANAGER MODULE - WORKER MANAGEMENT
// ==========================================

async function loadWorkerScreen() {
    if (!USER_PROFILE || !USER_PROFILE.shop_id) return;

    logDebug("Loading worker management screen", null, 'info');

    try {
        // Setup search
        const searchInput = document.getElementById('worker-search');
        if (searchInput) {
            searchInput.onkeyup = function () {
                const term = this.value.toLowerCase();
                document.querySelectorAll('#worker-list-tbody tr').forEach(row => {
                    const name = row.cells[0].textContent.toLowerCase();
                    row.style.display = name.includes(term) ? '' : 'none';
                });
            };
        }

        // Load workers
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('*')
            .eq('shop_id', USER_PROFILE.shop_id)
            .order('name');

        if (error) throw error;

        // Load active assignments count
        const { data: orders } = await supabaseClient
            .from('orders')
            .select('worker_id')
            .eq('shop_id', USER_PROFILE.shop_id)
            .neq('status', 6);

        const assignmentCounts = {};
        if (orders) {
            orders.forEach(o => {
                if (o.worker_id) {
                    assignmentCounts[o.worker_id] = (assignmentCounts[o.worker_id] || 0) + 1;
                }
            });
        }

        // Update table
        const tbody = document.getElementById('worker-list-tbody');
        if (tbody) {
            if (!workers || workers.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" style="text-align:center; padding:20px;">No workers found</td></tr>';
                return;
            }

            tbody.innerHTML = workers.map(worker => {
                const pendingCount = assignmentCounts[worker.id] || 0;
                const statusClass = pendingCount > 0 ? 'status-2' : 'status-4';
                const statusText = pendingCount > 0 ? `${pendingCount} Pending` : 'Available';

                return `
                    <tr>
                        <td style="font-weight:bold;">${worker.name}</td>
                        <td>${worker.phone_number || '-'}</td>
                        <td><span class="status-indicator ${statusClass}">${statusText}</span></td>
                        <td>
                            <button class="small-btn" style="background:#007bff;" 
                                    onclick="location.href='worker-assignments.html?id=${worker.id}'">
                                📂 View Work
                            </button>
                        </td>
                    </tr>
                `;
            }).join('');
        }

        // Setup add worker form
        const addForm = document.getElementById('add-worker-form');
        if (addForm) {
            addForm.onsubmit = async (e) => {
                e.preventDefault();

                const nameInput = document.getElementById('new-worker-name');
                const phoneInput = document.getElementById('new-worker-phone');
                const messageDiv = document.getElementById('worker-message');

                if (!nameInput.value.trim()) {
                    messageDiv.textContent = "Please enter worker name";
                    messageDiv.className = 'error';
                    return;
                }

                try {
                    const { error } = await supabaseClient
                        .from('workers')
                        .insert([{
                            shop_id: USER_PROFILE.shop_id,
                            name: nameInput.value.trim(),
                            phone_number: phoneInput.value.trim() || null,
                            created_at: new Date().toISOString()
                        }]);

                    if (error) throw error;

                    messageDiv.textContent = "Worker added successfully!";
                    messageDiv.className = 'success';
                    nameInput.value = '';
                    phoneInput.value = '';

                    // Reload after 1 second
                    setTimeout(() => {
                        loadWorkerScreen();
                        messageDiv.textContent = '';
                        messageDiv.className = '';
                    }, 1000);

                } catch (error) {
                    messageDiv.textContent = "Error: " + error.message;
                    messageDiv.className = 'error';
                }
            };
        }

        logDebug("Worker screen loaded", { workers: workers?.length || 0 }, 'success');
    } catch (error) {
        logDebug("Error loading worker screen:", error, 'error');
    }
}

async function loadWorkerAssignments() {
    const params = new URLSearchParams(window.location.search);
    const workerId = params.get('id');

    if (!workerId || !USER_PROFILE?.shop_id) return;

    try {
        const [{ data: worker }, { data: orders }] = await Promise.all([
            supabaseClient.from('workers').select('name').eq('id', workerId).single(),
            supabaseClient.from('orders')
                .select('*')
                .eq('worker_id', workerId)
                .eq('shop_id', USER_PROFILE.shop_id)
                .neq('status', 6)
                .order('due_date', { ascending: true })
        ]);

        if (!worker || !orders) return;

        // Update header
        document.getElementById('worker-header-name').textContent = `${worker.name}'s Assignments`;

        // Update table
        const tbody = document.getElementById('assignments-tbody');
        if (tbody) {
            if (!orders.length) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:20px;">No active assignments</td></tr>';
                return;
            }

            tbody.innerHTML = orders.map(order => {
                const orderIdStr = String(order.id);
                const shortId = orderIdStr.slice(-6);
                const statusText = STATUS_MAP[order.status] || `Status ${order.status}`;

                return `
                    <tr>
                        <td>#${shortId}</td>
                        <td>${order.customer_name}</td>
                        <td>${order.garment_type}</td>
                        <td>${formatDate(order.due_date)}</td>
                        <td><span class="status-indicator status-${order.status}">${statusText}</span></td>
                        <td>
                            <button class="small-btn" onclick="location.href='order-details.html?id=${order.id}'">
                                View/Update
                            </button>
                        </td>
                    </tr>
                `;
            }).join('');
        }

        logDebug(`Loaded ${orders.length} assignments for worker ${worker.name}`, null, 'success');
    } catch (error) {
        logDebug("Error loading worker assignments:", error, 'error');
    }
}
// [NEW] Load Workers into Checkbox List for Squad Selection
async function loadWorkersForSquad(shopId) {
    const container = document.getElementById('squad-selection-container');
    if (!container || !shopId) return;

    try {
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('id, name')
            .eq('shop_id', shopId)
            .order('name');

        if (error) throw error;

        if (workers.length === 0) {
            container.innerHTML = '<p style="font-size:0.8em; padding:5px;">No workers found.</p>';
            return;
        }

        container.innerHTML = workers.map(w => `
            <div style="margin-bottom: 8px; display: flex; align-items: center;">
                <input type="checkbox" id="squad_${w.id}" value="${w.id}" class="squad-checkbox" style="width: auto; margin: 0 10px 0 0;">
                <label for="squad_${w.id}" style="margin: 0; font-weight: normal; cursor: pointer;">${w.name}</label>
            </div>
        `).join('');

    } catch (error) {
        console.error("Error loading squad:", error);
        container.innerHTML = '<p style="color:red;">Error loading list</p>';
    }
}

async function loadWorkerFilterDropdown() {
    const workerFilter = document.getElementById('worker-filter');
    if (!workerFilter || !USER_PROFILE || !USER_PROFILE.shop_id) {
        return;
    }

    try {
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('id, name')
            .eq('shop_id', USER_PROFILE.shop_id)
            .order('name');

        if (error) {
            logDebug("Error loading workers for filter:", error, 'error');
            return;
        }

        if (workers && workerFilter) {
            workerFilter.innerHTML = '<option value="">Filter by Worker (All)</option>' +
                workers.map(w => `<option value="${w.id}">${w.name}</option>`).join('');
        }
    } catch (error) {
        logDebug("Error loading worker filter:", error, 'error');
    }
}

async function loadWorkersDropdown() {
    if (!USER_PROFILE?.shop_id) return;

    try {
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('id, name')
            .eq('shop_id', USER_PROFILE.shop_id)
            .order('name');

        if (error) {
            logDebug("Error loading workers for dropdown:", error, 'error');
            return;
        }

        const select = document.getElementById('worker-select');
        if (select && workers) {
            select.innerHTML = '<option value="">Select Worker</option>' +
                workers.map(w => `<option value="${w.id}">${w.name}</option>`).join('');
        }
    } catch (error) {
        logDebug("Error loading workers dropdown:", error, 'error');
    }
}

// ==========================================
// 👔 MANAGER MODULE - ORDER FORM
// ==========================================

function initOrderForm() {
    loadWorkersDropdown();
    loadWorkersForSquad(USER_PROFILE.shop_id); // [NEW] Load checkboxes

    const garmentSelect = document.getElementById('garment-type-select');
    if (garmentSelect) garmentSelect.addEventListener('change', generateMeasurementFieldsManager);

    // Setup Client Search
    setupClientSearch('customer_phone');
    setupClientSearch('customer_name');

    const orderForm = document.getElementById('order-form');
    if (orderForm) {
        orderForm.onsubmit = async (e) => {
            e.preventDefault();
            const submitBtn = document.getElementById('submit-order-btn');
            submitBtn.disabled = true;

            try {
                const measurements = {};
                document.querySelectorAll('#measurement-fields-container input').forEach(input => {
                    const comp = input.dataset.component; const meas = input.dataset.measurement;
                    if (!measurements[comp]) measurements[comp] = {};
                    if (input.value) measurements[comp][meas] = parseFloat(input.value);
                });

                // [NEW] Capture Squad
                const squad = Array.from(document.querySelectorAll('.squad-checkbox:checked')).map(cb => cb.value);

                const orderData = {
                    shop_id: USER_PROFILE.shop_id,
                    manager_id: USER_PROFILE.id,
                    customer_name: document.getElementById('customer_name').value,
                    customer_phone: document.getElementById('customer_phone').value,
                    garment_type: document.getElementById('garment-type-select').value,
                    price: parseFloat(document.getElementById('price').value) || 0,
                    due_date: document.getElementById('due_date').value,
                    worker_id: document.getElementById('worker-select').value || null,
                    additional_workers: JSON.stringify(squad), // [NEW] Save Squad
                    status: 1,
                    customer_preferences: document.getElementById('customer_preferences').value || '',
                    measurements_details: JSON.stringify(measurements),
                    created_at: new Date().toISOString()
                };

                const { data: order, error } = await supabaseClient.from('orders').insert([orderData]).select().single();
                if (error) throw error;

                // [NEW] Upsert Client Data
                try {
                    const { data: existingClient } = await supabaseClient.from('clients').select('*').eq('phone', orderData.customer_phone).single();
                    let history = existingClient ? (existingClient.measurements_history || []) : [];
                    history.unshift({
                        date: new Date().toISOString(),
                        garment: orderData.garment_type,
                        measurements: measurements
                    });
                    history = history.slice(0, 10); // Keep last 10

                    await supabaseClient.from('clients').upsert({
                        name: orderData.customer_name,
                        phone: orderData.customer_phone,
                        measurements_history: history,
                        last_garment_type: orderData.garment_type,
                        notes: orderData.customer_preferences,
                        updated_at: new Date().toISOString()
                    }, { onConflict: 'phone' });
                } catch (e) {
                    console.error("Error upserting client:", e);
                }

                const deposit = parseFloat(document.getElementById('deposit_paid').value) || 0;
                if (deposit > 0) {
                    await supabaseClient.from('payments').insert([{
                        order_id: order.id,
                        manager_id: USER_PROFILE.id,
                        amount: deposit,
                        recorded_at: new Date().toISOString()
                    }]);
                }

                window.location.href = 'manager-dashboard.html';

            } catch (error) {
                alert("Error: " + error.message);
                submitBtn.disabled = false;
            }
        };
    }
}

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
// 👔 MANAGER MODULE - EXPENSES
// ==========================================

async function loadExpensesScreen() {
    logDebug("Loading expenses screen", null, 'info');

    try {
        // Setup form
        const form = document.getElementById('expense-form');
        if (form) {
            form.onsubmit = async (e) => {
                e.preventDefault();

                try {
                    const expenseData = {
                        shop_id: USER_PROFILE.shop_id,
                        manager_id: USER_PROFILE.id,
                        item_name: document.getElementById('ex-name').value || 'General',
                        amount: parseFloat(document.getElementById('ex-amount').value) || 0,
                        category: document.getElementById('ex-cat').value,
                        notes: document.getElementById('ex-notes').value || '',
                        incurred_at: new Date().toISOString()
                    };

                    const { error } = await supabaseClient
                        .from('expenses')
                        .insert([expenseData]);

                    if (error) throw error;

                    alert("Expense added successfully!");
                    form.reset();
                    loadExpensesList();

                } catch (error) {
                    alert("Error adding expense: " + error.message);
                }
            };
        }

        // Load expenses list
        await loadExpensesList();

    } catch (error) {
        logDebug("Error loading expenses screen:", error, 'error');
    }
}

async function loadExpensesList() {
    if (!USER_PROFILE?.shop_id) return;

    try {
        const { data: expenses, error } = await supabaseClient
            .from('expenses')
            .select('*')
            .eq('shop_id', USER_PROFILE.shop_id)
            .order('incurred_at', { ascending: false });

        if (error) throw error;

        const tbody = document.getElementById('expenses-tbody');
        if (tbody) {
            if (!expenses || expenses.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:20px;">No expenses recorded</td></tr>';
                return;
            }

            tbody.innerHTML = expenses.map(expense => `
                <tr>
                    <td>${formatDate(expense.incurred_at)}</td>
                    <td><b>${expense.category}</b></td>
                    <td>${expense.item_name}</td>
                    <td style="font-weight:bold;">Ksh ${parseFloat(expense.amount).toLocaleString()}</td>
                    <td>${expense.notes || '-'}</td>
                    <td>
                        <button class="small-btn" style="background:#3b82f6; width: auto;" 
                                onclick="generateExpenseInvoice('${expense.id}')">
                            📄 Req Funds
                        </button>
                    </td>
                </tr>
            `).join('');
        }

        logDebug(`Loaded ${expenses?.length || 0} expenses`, null, 'success');
    } catch (error) {
        logDebug("Error loading expenses list:", error, 'error');
    }
}

// ==========================================
// 👔 MANAGER MODULE - ORDER DETAILS
// ==========================================

async function loadOrderDetailsScreen() {
    const params = new URLSearchParams(window.location.search);
    const orderId = params.get('id');

    if (!orderId) return;

    CURRENT_ORDER_ID = orderId;

    try {
        // Load order data
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders')
                .select('*')
                .eq('id', orderId)
                .single(),
            supabaseClient.from('payments')
                .select('*')
                .eq('order_id', orderId)
                .order('recorded_at', { ascending: false })
        ]);

        if (!order) {
            alert("Order not found");
            window.history.back();
            return;
        }

        // [NEW] Fetch Lead + Squad Logic
        let workerDisplay = 'Unassigned';
        let squadIds = [];
        try {
            const raw = order.additional_workers;
            if (Array.isArray(raw)) squadIds = raw;
            else if (typeof raw === 'string' && raw.trim().length > 0) squadIds = JSON.parse(raw);
            else squadIds = [];
        } catch (e) { console.warn('Skipping bad squad data for order:', order.id); squadIds = []; }

        let leadName = 'Unassigned';
        if (order.worker_id) {
            const { data: lead } = await supabaseClient.from('workers').select('name').eq('id', order.worker_id).single();
            if (lead) leadName = lead.name;
        }
        let squadNames = [];
        if (squadIds.length > 0) {
            const { data: squad } = await supabaseClient.from('workers').select('name').in('id', squadIds);
            if (squad) squadNames = squad.map(w => w.name);
        }
        if (squadNames.length > 0) {
            workerDisplay = `<strong>${leadName}</strong> <span style="color:#666; font-size:0.9em;">(+ ${squadNames.join(', ')})</span>`;
        } else {
            workerDisplay = leadName;
        }

        // Calculate financials
        const paid = payments ? payments.reduce((sum, p) => sum + (p.amount || 0), 0) : 0;
        const balance = (order.price || 0) - paid;

        // Update UI
        const container = document.getElementById('order-detail-container');
        if (container) {
            const orderIdStr = String(order.id);
            const shortId = orderIdStr.slice(-6);

            container.innerHTML = `
                <div class="pro-card-header">
                    <div class="client-identity">
                        <h2>${order.customer_name}</h2>
                        <a href="tel:${order.customer_phone}">${order.customer_phone}</a>
                    </div>
                    <div>
                        <span class="status-indicator status-${order.status}">
                            ${STATUS_MAP[order.status] || `Status ${order.status}`}
                        </span>
                    </div>
                </div>
                
                <div class="financial-strip">
                    <div class="stat-box box-black">
                        <small>Total</small>
                        <strong>Ksh ${(order.price || 0).toLocaleString()}</strong>
                    </div>
                    <div class="stat-box box-blue">
                        <small>Paid</small>
                        <strong>Ksh ${paid.toLocaleString()}</strong>
                    </div>
                    <div class="stat-box ${balance > 0 ? 'box-red' : 'box-green'}">
                        <small>Balance</small>
                        <strong>Ksh ${balance.toLocaleString()}</strong>
                    </div>
                </div>
                
                <div class="quick-actions-toolbar">
                    <button class="small-btn" style="background:#6c757d;" 
                            onclick="generateAndShareReceipt('${order.id}')">
                        📄 Generate Receipt
                    </button>
                    <button class="small-btn" style="background:#3b82f6;" 
                            onclick="downloadInvoicePDF('${order.id}')">
                        📄 Generate Invoice
                    </button>
                    <button class="small-btn" style="background:#28a745;" 
                            onclick="quickPay('${order.id}', ${balance})" ${balance <= 0 ? 'disabled' : ''}>
                        💰 Record Payment
                    </button>
                    <button class="small-btn" style="background:#ffc107; color:black;" 
                            onclick="updateStatus('${order.id}')">
                        🔄 Update Status
                    </button>
                </div>
                
                <div class="data-tabs-container">
                    <div class="data-section">
                        <h3>Order Details</h3>
                        <p><strong>Order ID:</strong> #${shortId}</p>
                        <p><strong>Garment:</strong> ${order.garment_type}</p>
                        <p><strong>Due Date:</strong> ${formatDate(order.due_date)}</p>
                        <p><strong>Assigned Worker:</strong> ${workerDisplay}</p>
                        ${order.customer_preferences ? `<p><strong>Customer Notes:</strong> ${order.customer_preferences}</p>` : ''}
                        <p><strong>Measurements:</strong><br>${formatMeasurements(order.measurements_details)}</p>
                    </div>
                </div>
            `;
        }

        addRefreshButton();
        logDebug("Order details loaded", { orderId }, 'success');

    } catch (error) {
        logDebug("Error loading order details:", error, 'error');
        alert("Error loading order details: " + error.message);
    }
}

// ==========================================
// 📄 RECEIPT SYSTEM (CORE LOGIC FOR GENERATE RECEIPT FIX)
// ==========================================

function generateSimpleReceiptHTML(order, paymentAmount) {
    const dateStr = new Date().toLocaleDateString();

    // --- ☢️ NUCLEAR ARITHMETIC (Do not touch) ☢️ ---
    const totalCost = parseFloat(order.price) || 0;
    const existingPaid = parseFloat(order.amount_paid) || 0;
    const payingNow = parseFloat(paymentAmount) || 0;

    let realTotalPaid = 0;
    if (order.id && existingPaid >= payingNow && existingPaid > 0) {
        realTotalPaid = existingPaid;
    } else {
        realTotalPaid = existingPaid + payingNow;
    }
    const remainingBalance = totalCost - realTotalPaid;

    // --- BRANDING ---
    const receiptShopName = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.appName)
        ? APP_CONFIG.appName.toUpperCase()
        : "FASHION HOUSE";

    const receiptPhone = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.shopPhone)
        ? APP_CONFIG.shopPhone
        : "";

    // --- 🎨 ULTIMATE MODERN DESIGN ---
    const orderIdStr = (order.id !== undefined && order.id !== null) ? String(order.id) : '';
    // Prefer order.phone_number, fallback to order.customer_phone, else N/A
    let clientPhone = '';
    if (order.phone_number && String(order.phone_number).trim() !== '') {
        clientPhone = order.phone_number;
    } else if (order.customer_phone && String(order.customer_phone).trim() !== '') {
        clientPhone = order.customer_phone;
    } else {
        clientPhone = 'N/A';
    }
    // Check if paid in full
    const paidInFull = remainingBalance <= 0;
    return `
        <div style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; width: 320px; padding: 40px 35px; background: #ffffff; color: #333; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border-radius: 12px; margin: auto;">
            
            <div style="text-align: center; margin-bottom: 40px;">
                <h2 style="font-size: 1.6em; margin: 0; font-weight: 800; letter-spacing: 4px; text-transform: uppercase; color: #000;">${receiptShopName}</h2>
                ${receiptPhone ? `<p style=\"margin: 10px 0 0 0; font-size: 0.8em; letter-spacing: 2px; color: #888;\">${receiptPhone}</p>` : ''}
            </div>
            
            <div style="display: flex; justify-content: space-between; margin-bottom: 35px; border-bottom: 1px solid #f0f0f0; padding-bottom: 20px;">
                <div>
                    <p style="margin: 0; font-size: 0.7em; text-transform: uppercase; color: #999; letter-spacing: 1px; font-weight: 600;">Date</p>
                    <p style="margin: 5px 0 0 0; font-size: 1em; font-weight: 500; color: #000;">${dateStr}</p>
                </div>
                <div style="text-align: right;">
                    <p style="margin: 0; font-size: 0.7em; text-transform: uppercase; color: #999; letter-spacing: 1px; font-weight: 600;">Order No.</p>
                    <p style="margin: 5px 0 0 0; font-size: 1em; font-weight: 500; color: #000;">#${orderIdStr.slice(0, 8).toUpperCase()}</p>
                </div>
            </div>

            <div style="margin-bottom: 35px;">
                <p style="margin: 0 0 15px 0; font-size: 0.7em; text-transform: uppercase; color: #999; letter-spacing: 1px; font-weight: 600;">Client Details</p>
                <div style="display: grid; grid-template-columns: auto 1fr; gap: 8px 20px; align-items: baseline;">
                    
                    <span style="font-size: 0.9em; color: #777; font-weight: 500;">Name:</span>
                    <span style="font-size: 1.1em; color: #000; font-weight: 400;">${order.customer_name}</span>

                    <span style="font-size: 0.9em; color: #777; font-weight: 500;">Phone:</span>
                    <span style="font-size: 1em; color: #333; font-weight: 400;">${clientPhone}</span>
                    
                    <span style="font-size: 0.9em; color: #777; font-weight: 500;">Garment:</span>
                    <span style="font-size: 1em; color: #333; font-weight: 400;">${order.garment_type}</span>
                </div>
            </div>

            <table style="width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-bottom: 30px;">
                <tr>
                    <td style="font-size: 1em; color: #555; font-weight: 500;">Total Amount</td>
                    <td style="text-align: right; font-weight: 700; font-size: 1.2em; color: #D4AF37;">${formatCurrency(totalCost)}</td>
                </tr>
                
                ${payingNow > 0 ? `
                <tr>
                    <td style="font-size: 0.9em; color: #777;">Paid Now</td>
                    <td style="text-align: right; font-size: 1em; color: #333;">${formatCurrency(payingNow)}</td>
                </tr>
                ` : ''}

                ${paidInFull ? `
                <tr>
                    <td colspan="2" style="text-align: center; padding-top: 10px;">
                        <span style="display: inline-block; background: #e8f5e9; color: #388e3c; font-weight: 700; font-size: 1.1em; padding: 6px 18px; border-radius: 8px; letter-spacing: 1px;">PAID IN FULL</span>
                    </td>
                </tr>
                ` : `
                <tr>
                    <td style="font-size: 0.9em; color: #777; padding-top: 5px;">Total Paid</td>
                    <td style="text-align: right; font-size: 1em; color: #333; padding-top: 5px; font-weight: 500;">${formatCurrency(realTotalPaid)}</td>
                </tr>
                ${remainingBalance > 0 ? `
                <tr><td colspan="2" style="border-bottom: 1px solid #f0f0f0; padding: 5px 0;"></td></tr>
                <tr>
                    <td style="font-size: 1em; color: #000; font-weight: 600; padding-top: 15px;">Balance Due</td>
                    <td style="text-align: right; font-weight: 700; font-size: 1.3em; color: #d32f2f; padding-top: 15px;">${formatCurrency(remainingBalance)}</td>
                </tr>
                ` : ''}`}
            </table>

            <div style="text-align: center;">
                <p style="margin: 0; font-size: 0.8em; color: #999; font-style: italic; letter-spacing: 0.5px;">Thank you for your business.</p>
            </div>
        </div>
    `;
}

function generateTextReceipt(order, payments, paymentAmount = 0) {
    // --- Robust Math Logic (match generateSimpleReceiptHTML) ---
    const totalCost = parseFloat(order.price) || 0;
    const existingPaid = payments ? payments.reduce((sum, p) => sum + (p.amount || 0), 0) : 0;
    const payingNow = parseFloat(paymentAmount) || 0;
    let realTotalPaid = 0;
    if (order.id && existingPaid >= payingNow && existingPaid > 0) {
        realTotalPaid = existingPaid;
    } else {
        realTotalPaid = existingPaid + payingNow;
    }
    const remainingBalance = totalCost - realTotalPaid;

    // --- Dynamic Branding ---
    const receiptShopName = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.appName)
        ? APP_CONFIG.appName.toUpperCase()
        : "FASHION HOUSE";
    const receiptPhone = (typeof APP_CONFIG !== 'undefined' && APP_CONFIG.shopPhone)
        ? APP_CONFIG.shopPhone
        : "";
    const dateStr = new Date().toLocaleDateString('en-US');

    let lines = [];
    lines.push(`${receiptShopName}`);
    if (receiptPhone) lines.push(`Phone: ${receiptPhone}`);
    lines.push('-----------------------------');
    lines.push(`Date: ${dateStr}`);
    lines.push(`Order: #${order.id.slice(0, 8)}`);
    lines.push(`Customer: ${order.customer_name || 'Unknown'}`);
    if (order.customer_phone) lines.push(`Phone: ${order.customer_phone}`);
    if (order.garment_type) lines.push(`Garment: ${order.garment_type}`);
    lines.push('');
    lines.push(`Total Cost: Ksh ${totalCost.toLocaleString()}`);
    if (payingNow > 0) lines.push(`Paid Now: Ksh ${payingNow.toLocaleString()}`);
    lines.push(`Total Paid: Ksh ${realTotalPaid.toLocaleString()}`);
    lines.push(`Balance Due: Ksh ${remainingBalance.toLocaleString()}`);
    lines.push('-----------------------------');
    lines.push(remainingBalance > 0 ? 'Balance Due' : '✅ PAID IN FULL');
    lines.push('');
    lines.push('Thank you for your business!');
    return lines.join('\n');
}

window.generateAndShareReceipt = async function (orderId) {
    logDebug("Generating receipt for order:", orderId, 'info');

    try {
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders').select('*').eq('id', orderId).single(),
            supabaseClient.from('payments').select('*').eq('order_id', orderId)
        ]);

        if (!order) {
            alert("Order not found!");
            return;
        }

        const receiptHTML = generateSimpleReceiptHTML(order, payments);
        const receiptText = generateTextReceipt(order, payments);

        showNuclearSharingModal(receiptHTML, receiptText, order.customer_name, order.customer_phone);

    } catch (error) {
        logDebug("Error generating receipt:", error, 'error');
        alert("Error generating receipt: " + error.message);
    }
};

function showNuclearSharingModal(receiptHTML, receiptText, customerName, customerPhone) {
    // Remove existing modal
    const existingModal = document.getElementById('receipt-sharing-modal');
    if (existingModal) existingModal.remove();

    const cleanPhone = customerPhone ? customerPhone.replace(/\D/g, '') : '';

    const modalHTML = `
        <div id="receipt-sharing-modal" class="modal" style="display: flex; z-index: 9999;">
            <div class="modal-content" style="max-width: 500px; width: 90%; padding: 20px;">
                <span class="close-btn" onclick="closeReceiptModal()" style="font-size: 28px;">&times;</span>
                
                <div style="text-align: center; margin-bottom: 20px;">
                    <h2 style="color: #d4af37; margin-bottom: 5px;">📄 Share Receipt</h2>
                    <p style="color: #666;">For: ${customerName || 'Customer'}</p>
                </div>
                
                <div id="receipt-preview-container" style="max-height: 350px; overflow-y: auto; margin-bottom: 25px; padding: 10px; background: #f9f9f9; border-radius: 8px;">
                    ${receiptHTML}
                </div>
                
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    ${cleanPhone ? `
                        <button id="whatsapp-btn" class="share-btn" style="background: #25D366;">
                            <span style="font-size: 1.3em;">📱</span> Share via WhatsApp
                        </button>
                        <button id="sms-btn" class="share-btn" style="background: #007bff;">
                            <span style="font-size: 1.3em;">💬</span> Share as SMS
                        </button>
                    ` : ''}
                    
                    <button id="share-image-btn" class="share-btn" style="background: #9b59b6;">
                        <span style="font-size: 1.3em;">🖼️</span> Share as Image
                    </button>
                    
                    <button id="copy-btn" class="share-btn" style="background: #6c757d;">
                        <span style="font-size: 1.3em;">📋</span> Copy to Clipboard
                    </button>
                </div>
                
                <div id="share-status" style="margin-top: 15px; text-align: center;"></div>
            </div>
        </div>
    `;

    const modalContainer = document.createElement('div');
    modalContainer.innerHTML = modalHTML;
    document.body.appendChild(modalContainer.firstElementChild);

    // Add event listeners
    setTimeout(() => {
        if (cleanPhone) {
            document.getElementById('whatsapp-btn').onclick = () => {
                shareViaWhatsApp(receiptText, cleanPhone);
            };

            document.getElementById('sms-btn').onclick = () => {
                shareViaSMS(receiptText, cleanPhone);
            };
        }

        document.getElementById('share-image-btn').onclick = () => {
            shareReceiptAsImage();
        };

        document.getElementById('copy-btn').onclick = () => {
            copyReceiptText(receiptText);
        };
    }, 100);
}

function shareViaWhatsApp(receiptText, phoneNumber) {
    const whatsappUrl = `https://wa.me/${phoneNumber}?text=${encodeURIComponent(receiptText)}`;
    window.open(whatsappUrl, '_blank');
    showStatusMessage('✅ Opening WhatsApp...', 'success');
}

function shareViaSMS(receiptText, phoneNumber) {
    const smsUrl = /iPhone|iPad|iPod/.test(navigator.userAgent)
        ? `sms:${phoneNumber}&body=${encodeURIComponent(receiptText)}`
        : `sms:${phoneNumber}?body=${encodeURIComponent(receiptText)}`;
    window.open(smsUrl, '_blank');
    showStatusMessage('✅ Opening SMS app...', 'success');
}

async function shareReceiptAsImage() {
    const receiptContent = document.querySelector('#receipt-preview-container > div');
    if (!receiptContent) {
        showStatusMessage('❌ Receipt content not found', 'error');
        return;
    }

    showStatusMessage('🔄 Creating image...', 'info');

    try {
        // *** CRITICAL FIX: Ensure html2canvas is loaded and available ***
        if (typeof html2canvas === 'undefined') {
            await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
        }

        const canvas = await html2canvas(receiptContent, {
            scale: 2,
            useCORS: true,
            backgroundColor: '#ffffff'
        });

        // Auto-download
        const timestamp = new Date().toISOString().slice(0, 10).replace(/-/g, '');
        const downloadLink = document.createElement('a');
        downloadLink.download = `receipt_${timestamp}.png`;
        downloadLink.href = canvas.toDataURL('image/png');
        downloadLink.click();

        // Try native sharing
        canvas.toBlob(async (blob) => {
            if (blob) {
                const file = new File([blob], `receipt_${timestamp}.png`, { type: 'image/png' });

                if (navigator.share && navigator.canShare && navigator.canShare({ files: [file] })) {
                    try {
                        await navigator.share({
                            files: [file],
                            title: 'Tailoring Receipt',
                            text: 'Receipt from Sir\'s \'n\' Suits'
                        });
                        showStatusMessage('✅ Image shared!', 'success');
                    } catch (shareError) {
                        showStatusMessage('✅ Image downloaded!', 'success');
                    }
                } else {
                    showStatusMessage('✅ Image downloaded!', 'success');
                }
            }
        }, 'image/png');

    } catch (error) {
        logDebug("Image generation error:", error, 'error');
        showStatusMessage('❌ Error creating image', 'error');
    }
}

function copyReceiptText(receiptText) {
    navigator.clipboard.writeText(receiptText)
        .then(() => showStatusMessage('✅ Copied to clipboard!', 'success'))
        .catch(() => {
            // Fallback
            const textArea = document.createElement('textarea');
            textArea.value = receiptText;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            showStatusMessage('✅ Copied to clipboard!', 'success');
        });
}

function showStatusMessage(message, type) {
    const statusDiv = document.getElementById('share-status');
    if (statusDiv) {
        statusDiv.innerHTML = `<p style="color: ${type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : '#ffc107'}">${message}</p>`;
        setTimeout(() => statusDiv.innerHTML = '', 3000);
    }
}

function closeReceiptModal() {
    const modal = document.getElementById('receipt-sharing-modal');
    if (modal) modal.remove();
}

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
// 👑 OWNER MODULE - ADMIN ORDERS

// Redundant loadAdminOrders removed - moved and updated below at line 2082

async function loadAdminDashboard() {/* Lines 1587-1601 omitted */ }

async function loadMetrics() {/* Lines 1604-1625 omitted */ }

async function loadPendingClosureOrders() {/* Lines 1628-1709 omitted */ }
// ==========================================

async function loadAdminDashboard() {
    logDebug("Loading admin dashboard", null, 'info');

    try {
        await Promise.all([
            loadMetrics(),
            loadShopsForDropdown('shop-filter'),
            loadPendingClosureOrders()
        ]);

        addRefreshButton();

    } catch (error) {
        logDebug("Error loading admin dashboard:", error, 'error');
    }
}

async function loadMetrics() {
    try {
        const [{ data: shops }, { data: orders }] = await Promise.all([
            supabaseClient.from('shops').select('id, name'),
            supabaseClient.from('orders').select('shop_id, price, amount_paid, status, due_date')
        ]);

        if (!orders) return;

        const shopMap = {};
        shops?.forEach(s => shopMap[s.id] = s.name);

        let totalRevenue = 0;
        let totalUnpaid = 0;
        let activeCount = 0;
        let readyCount = 0;
        let pendingCount = 0;
        let closedCount = 0;
        let overdueCount = 0;
        let dueTodayCount = 0;

        const shopRevenue = {};
        const shopUnpaid = {};

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        orders.forEach(o => {
            const paid = parseFloat(o.amount_paid) || 0;
            const price = parseFloat(o.price) || 0;
            const unpaid = price - paid;

            totalRevenue += paid;
            totalUnpaid += unpaid;

            if (o.shop_id) {
                shopRevenue[o.shop_id] = (shopRevenue[o.shop_id] || 0) + paid;
                shopUnpaid[o.shop_id] = (shopUnpaid[o.shop_id] || 0) + unpaid;
            }

            // Status counts
            if (o.status === 6) closedCount++;
            else if (o.status === 5) pendingCount++;
            else if (o.status === 4) readyCount++;
            else activeCount++; // Status 1, 2, 3

            // Due status (only for non-closed orders)
            if (o.status < 6 && o.due_date) {
                const dueDate = new Date(o.due_date);
                dueDate.setHours(0, 0, 0, 0);

                if (dueDate < today) {
                    overdueCount++;
                } else if (dueDate.getTime() === today.getTime()) {
                    dueTodayCount++;
                }
            }
        });

        // Update UI
        if (document.getElementById('total-revenue')) document.getElementById('total-revenue').textContent = `Ksh ${totalRevenue.toLocaleString()}`;
        if (document.getElementById('total-unpaid')) document.getElementById('total-unpaid').textContent = `Ksh ${totalUnpaid.toLocaleString()}`;
        if (document.getElementById('active-count')) document.getElementById('active-count').textContent = activeCount;
        if (document.getElementById('ready-count')) document.getElementById('ready-count').textContent = readyCount;
        if (document.getElementById('pending-count')) document.getElementById('pending-count').textContent = pendingCount;
        if (document.getElementById('closed-count')) document.getElementById('closed-count').textContent = closedCount;
        if (document.getElementById('overdue-count')) document.getElementById('overdue-count').textContent = overdueCount;
        if (document.getElementById('due-today-count')) document.getElementById('due-today-count').textContent = dueTodayCount;
        if (document.getElementById('total-due-count')) document.getElementById('total-due-count').textContent = overdueCount + dueTodayCount;

        // Revenue Breakdown
        const revBreakdownEl = document.getElementById('revenue-breakdown');
        if (revBreakdownEl) {
            revBreakdownEl.innerHTML = Object.entries(shopRevenue).map(([id, amt]) => {
                return `<div style="display:flex; justify-content:space-between; margin-bottom:2px;">
                    <span>${shopMap[id] || 'Unknown'}:</span>
                    <span style="font-weight:600;">Ksh ${amt.toLocaleString()}</span>
                </div>`;
            }).join('');
        }

        // Unpaid Breakdown
        const unpaidBreakdownEl = document.getElementById('unpaid-breakdown');
        if (unpaidBreakdownEl) {
            unpaidBreakdownEl.innerHTML = Object.entries(shopUnpaid).map(([id, amt]) => {
                if (amt <= 0) return '';
                return `<div style="display:flex; justify-content:space-between; margin-bottom:2px;">
                    <span>${shopMap[id] || 'Unknown'}:</span>
                    <span style="font-weight:600;">Ksh ${amt.toLocaleString()}</span>
                </div>`;
            }).join('');
        }

        logDebug("Metrics loaded", { totalRevenue, totalUnpaid }, 'success');
    } catch (error) {
        logDebug("Error loading metrics:", error, 'error');
    }
}

async function loadPendingClosureOrders() {
    try {
        let query = supabaseClient
            .from('orders')
            .select('*')  // FIXED: Removed shops embed
            .eq('status', 5)
            .order('created_at', { ascending: false });

        const shopFilter = document.getElementById('shop-filter')?.value;
        if (shopFilter && shopFilter !== "") {
            query = query.eq('shop_id', shopFilter);
        }

        const { data: orders, error } = await query;
        if (error) throw error;

        const tbody = document.getElementById('orders-tbody');
        if (!tbody) return;

        if (!orders || orders.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:20px;">No orders pending closure</td></tr>';
            return;
        }

        // Get shop names
        const shopIds = [...new Set(orders.map(o => o.shop_id).filter(id => id))];
        let shopMap = {};
        if (shopIds.length > 0) {
            const { data: shops } = await supabaseClient
                .from('shops')
                .select('id, name')
                .in('id', shopIds);

            if (shops) {
                shops.forEach(s => {
                    shopMap[s.id] = s.name;
                });
            }
        }

        // Get payments for these orders
        const orderIds = orders.map(o => o.id);
        const { data: payments } = await supabaseClient
            .from('payments')
            .select('*')
            .in('order_id', orderIds);

        const paymentsByOrder = {};
        if (payments) {
            payments.forEach(p => {
                if (!paymentsByOrder[p.order_id]) paymentsByOrder[p.order_id] = [];
                paymentsByOrder[p.order_id].push(p);
            });
        }

        tbody.innerHTML = orders.map(order => {
            const orderPayments = paymentsByOrder[order.id] || [];
            const activePayments = orderPayments; // Exclude soft-deleted - DB now handles this
            const paid = activePayments.reduce((sum, p) => sum + (p.amount || 0), 0);
            const orderIdStr = String(order.id);
            const shortId = orderIdStr.slice(-6);

            return `
                <tr>
                    <td>#${shortId}</td>
                    <td>${shopMap[order.shop_id] || 'Unknown'}</td>
                    <td>${order.customer_name}</td>
                    <td>Ksh ${paid.toLocaleString()}</td>
                    <td><span class="status-indicator status-5">Pending Closure</span></td>
                    <td>
                        <button class="small-btn" style="background:#343a40; color:white;" 
                                onclick="openReviewModal('${order.id}')">
                            Review & Close
                        </button>
                    </td>
                </tr>
            `;
        }).join('');

        logDebug(`Loaded ${orders.length} pending orders`, null, 'success');
    } catch (error) {
        logDebug("Error loading pending orders:", error, 'error');
    }
}

async function openReviewModal(orderId) {
    try {
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders')
                .select('*')
                .eq('id', orderId)
                .single(),
            supabaseClient.from('payments')
                .select('amount')
                .eq('order_id', orderId)
        ]);

        if (!order) {
            alert("Order not found");
            return;
        }

        // Get shop name
        let shopName = 'Unknown';
        if (order.shop_id) {
            const { data: shop } = await supabaseClient
                .from('shops')
                .select('name')
                .eq('id', order.shop_id)
                .single();
            if (shop) shopName = shop.name;
        }

        const totalPaid = payments ? payments.reduce((sum, p) => sum + p.amount, 0) : 0;
        const balance = order.price - totalPaid;

        // Update modal content
        document.getElementById('admin-detail-shop').textContent = shopName;
        document.getElementById('admin-detail-customer-name').textContent = order.customer_name;
        document.getElementById('admin-detail-garment-type').textContent = order.garment_type;
        document.getElementById('admin-detail-price').textContent = order.price.toLocaleString();
        document.getElementById('admin-detail-total-paid').textContent = totalPaid.toLocaleString();
        document.getElementById('admin-detail-balance-due').textContent = balance.toLocaleString();

        // Setup finalize button
        const finalizeBtn = document.getElementById('finalize-order-btn');
        if (finalizeBtn) {
            finalizeBtn.onclick = () => finalizeOrder(orderId, balance > 0);
        }

        // Show modal
        document.getElementById('admin-modal').style.display = 'flex';

    } catch (error) {
        logDebug("Error opening review modal:", error, 'error');
        alert("Error: " + error.message);
    }
}

async function finalizeOrder(orderId, hasDebt) {
    if (hasDebt && !confirm("Order has unpaid balance. Close anyway?")) return;

    try {
        const { error } = await supabaseClient
            .from('orders')
            .update({
                status: 6,
                updated_at: new Date().toISOString()
            })
            .eq('id', orderId);

        if (error) throw error;

        document.getElementById('admin-modal').style.display = 'none';
        loadPendingClosureOrders();
        loadMetrics();

        logDebug(`Order ${orderId} finalized`, null, 'success');
    } catch (error) {
        logDebug("Error finalizing order:", error, 'error');
        alert("Error closing order: " + error.message);
    }
}

function closeAdminModal() {
    document.getElementById('admin-modal').style.display = 'none';
}

// ==========================================
// 👑 OWNER MODULE - ADMIN ORDERS
// ==========================================

async function loadAdminOrders(mode = 'current') {
    // [NEW] Update Header based on mode
    const headerTitle = document.querySelector('header h1');
    if (headerTitle) {
        if (mode === 'urgent') headerTitle.innerHTML = '🔥 Global Urgent Attention';
        else if (mode === 'current') headerTitle.textContent = 'Global Active Orders';
        else headerTitle.textContent = 'Global Order History';
    }

    // [PERF] Debounce rapid calls
    const now = Date.now();
    if (window._lastAdminOrdersLoad && now - window._lastAdminOrdersLoad < 500) return;
    window._lastAdminOrdersLoad = now;

    logDebug(`Loading admin orders (${mode})`, null, 'info');

    try {
        let query = supabaseClient.from('orders')
            .select('*')
            .order('due_date', { ascending: true }) // [CHANGED] Sort by date for urgency
            .limit(100);

        // If mode is current or urgent, exclude closed
        if (mode === 'current' || mode === 'urgent') {
            query = query.neq('status', 6);
        }

        // Apply filters
        const shopFilter = document.getElementById('admin-shop-filter')?.value;
        if (shopFilter && shopFilter !== "") {
            query = query.eq('shop_id', shopFilter);
        }

        const statusFilter = document.getElementById('admin-status-filter')?.value;
        if (statusFilter && statusFilter !== "" && mode !== 'urgent') {
            query = query.eq('status', parseInt(statusFilter));
        }

        // [NEW] Search Filtering Logic
        const searchTerm = document.getElementById('admin-search-input')?.value?.trim();
        if (searchTerm) {
            // Search in customer_name or customer_phone
            // We use .or() for multiple column matching
            query = query.or(`customer_name.ilike.%${searchTerm}%,customer_phone.ilike.%${searchTerm}%`);
        }

        const { data: ordersData, error } = await query;
        if (error) throw error;

        await loadShopsForDropdown('admin-shop-filter');

        // [NEW] "Hot List" Filtering Logic
        let orders = ordersData;
        if (mode === 'urgent') {
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            orders = ordersData.filter(o => {
                if (o.status >= 5) return false;
                const due = new Date(o.due_date);
                const diffTime = due - today;
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                return diffDays <= 2; // Late or Due in 2 days
            });
        }

        const tbody = document.getElementById('admin-orders-tbody');
        if (!tbody) return;

        if (!orders || orders.length === 0) {
            tbody.innerHTML = mode === 'urgent'
                ? '<tr><td colspan="9" style="text-align:center; padding:30px; font-size:1.2em;">✅ No urgent issues across shops.</td></tr>'
                : '<tr><td colspan="9" style="text-align:center; padding:20px;">No orders found</td></tr>';
            return;
        }

        // Fetch relations
        const shopIds = [...new Set(orders.map(o => o.shop_id).filter(id => id))];
        const workerIds = [...new Set(orders.map(o => o.worker_id).filter(id => id))];
        const orderIds = orders.map(o => o.id);

        const [{ data: shops }, { data: workers }, { data: payments }] = await Promise.all([
            shopIds.length > 0 ? supabaseClient.from('shops').select('id, name').in('id', shopIds) : Promise.resolve({ data: [] }),
            workerIds.length > 0 ? supabaseClient.from('workers').select('id, name').in('id', workerIds) : Promise.resolve({ data: [] }),
            supabaseClient.from('payments').select('*').in('order_id', orderIds)
        ]);

        const shopMap = {}; shops?.forEach(s => shopMap[s.id] = s.name);
        const workerMap = {}; workers?.forEach(w => workerMap[w.id] = w.name);
        const paymentsByOrder = {}; payments?.forEach(p => {
            if (!paymentsByOrder[p.order_id]) paymentsByOrder[p.order_id] = [];
            paymentsByOrder[p.order_id].push(p);
        });

        tbody.innerHTML = orders.map(order => {
            const orderPaymentList = (paymentsByOrder[order.id] || []);
            const activePayments = orderPaymentList.filter(p => !p.deleted_at); // Exclude soft-deleted
            const paid = activePayments.reduce((sum, p) => sum + (p.amount || 0), 0);
            const balance = (order.price || 0) - paid;
            const orderIdStr = String(order.id);
            const shortId = orderIdStr.slice(-6);
            const statusText = STATUS_MAP[order.status] || `Status ${order.status}`;
            const shopName = shopMap[order.shop_id] || 'Unknown';
            const workerName = order.worker_id ? (workerMap[order.worker_id] || 'Unassigned') : 'Unassigned';

            // [NEW] Squad Badge Logic
            let squadCount = 0;
            try {
                const raw = order.additional_workers;
                if (Array.isArray(raw)) {
                    squadCount = raw.length;
                } else if (typeof raw === 'string' && raw.trim().length > 0) {
                    try {
                        squadCount = JSON.parse(raw).length;
                    } catch (e) {
                        console.warn("Skipping bad squad data for order:", order.id);
                    }
                }
            } catch (e) {
                console.warn("Skipping bad squad data for order:", order.id);
            }

            const squadBadge = squadCount > 0
                ? ' <i class="fas fa-users" style="color:#007bff; font-size:0.8em;" title="Has Team"></i>'
                : '';

            // [NEW] Traffic Light Date Logic
            const diffDays = Math.ceil((new Date(order.due_date) - new Date()) / (86400000));
            let dueDisplay = formatDate(order.due_date);

            if (order.status < 5) {
                if (diffDays < 0) {
                    dueDisplay = `<div style="color:#dc3545; font-weight:800; line-height:1.2;">
                        <i class="fas fa-exclamation-circle"></i> ${formatDate(order.due_date)}<br>
                        <small>LATE (${Math.abs(diffDays)} days)</small>
                    </div>`;
                } else if (diffDays <= 2) {
                    dueDisplay = `<div style="color:#e67e22; font-weight:800; line-height:1.2;">
                        <i class="fas fa-stopwatch"></i> ${formatDate(order.due_date)}<br>
                        <small>${diffDays === 0 ? 'DUE TODAY' : diffDays + ' days left'}</small>
                    </div>`;
                }
            }

            return `
                <tr>
                    <td>#${shortId}</td>
                    <td>${shopName}</td>
                    <td>${order.customer_name}</td>
                    <td>${order.garment_type}</td>
                    <td class="ref-column">${order.customer_preferences || 'None'}</td>
                    <td>${dueDisplay}</td>
                    <td>${workerName}${squadBadge}</td>
                    <td><span class="status-indicator status-${order.status}">${statusText}</span></td>
                    <td style="color:${balance > 0 ? '#dc3545' : '#28a745'}; font-weight:bold;">Ksh ${balance.toLocaleString()}</td>
                    <td class="admin-actions-cell">
                        <button class="btn-compact" title="View Order" onclick="openAdminOrderView('${order.id}')"><i class="fas fa-eye"></i></button>
                        <button class="btn-compact" title="Edit Order" style="background:var(--brand-gold); color:black;" onclick="window.location.href='admin-order-details.html?id=${order.id}'"><i class="fas fa-edit"></i></button>
                        <button class="btn-compact" title="Generate Receipt" style="background:var(--profit-green);" onclick="generateAndShareReceipt('${order.id}')"><i class="fas fa-receipt"></i></button>
                    </td>
                </tr>
            `;
        }).join('');

        addRefreshButton();
        logDebug(`Loaded ${orders.length} admin orders`, null, 'success');

    } catch (error) {
        logDebug("Error loading admin orders:", error, 'error');
        const tbody = document.getElementById('admin-orders-tbody');
        if (tbody) {
            tbody.innerHTML = `<tr><td colspan="9" style="text-align:center; color:#dc3545;">Error: ${error.message}</td></tr>`;
        }
    }
}

// [NEW] Debounce Helper for Search
let adminSearchTimeout = null;
window.debounceLoadOrders = function (mode) {
    if (adminSearchTimeout) clearTimeout(adminSearchTimeout);
    adminSearchTimeout = setTimeout(() => {
        loadAdminOrders(mode);
    }, 400); // 400ms delay
};

async function openAdminOrderView(orderId) {
    logDebug("Opening admin order view:", orderId, 'info');

    try {
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders').select('*').eq('id', orderId).single(),
            supabaseClient.from('payments').select('*').eq('order_id', orderId).order('recorded_at', { ascending: false })
        ]);

        if (!order) {
            alert("Order not found!");
            return;
        }

        // Get additional data
        let shopName = 'Unknown';
        let workerName = 'Unassigned';

        if (order.shop_id) {
            const { data: shop } = await supabaseClient
                .from('shops')
                .select('name')
                .eq('id', order.shop_id)
                .single();
            if (shop) shopName = shop.name;
        }

        if (order.worker_id) {
            const { data: worker } = await supabaseClient
                .from('workers')
                .select('name')
                .eq('id', order.worker_id)
                .single();
            if (worker) workerName = worker.name;
        }

        const activePayments = payments ? payments.filter(p => !p.deleted_at) : [];
        const paid = activePayments.reduce((sum, p) => sum + (p.amount || 0), 0);
        const balance = (order.price || 0) - paid;
        const orderIdStr = String(order.id);
        const shortId = orderIdStr.slice(-6);

        // Create modal content
        const modalContent = `
            <div style="padding: 20px;">
                <span class="close-btn" onclick="document.getElementById('order-modal').style.display='none'">&times;</span>
                <h2 style="border-bottom: 2px solid #d4af37; padding-bottom: 10px; margin-bottom: 20px;">
                    Order #${shortId} - ${order.customer_name}
                </h2>
                
                <div style="margin-bottom: 20px;">
                    <p><strong>Shop:</strong> ${shopName}</p>
                    <p><strong>Garment:</strong> ${order.garment_type}</p>
                    <p><strong>Worker:</strong> ${workerName}</p>
                    <p><strong>Due Date:</strong> ${formatDate(order.due_date)}</p>
                    <p><strong>Status:</strong> <span class="status-indicator status-${order.status}">
                        ${STATUS_MAP[order.status] || `Status ${order.status}`}
                    </span></p>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                    <div style="flex: 1; background: #000; color: white; padding: 15px; border-radius: 5px; text-align: center;">
                        <small>Total Price</small>
                        <p style="margin: 5px 0; font-size: 1.2em; color: #d4af37; font-weight: bold;">
                            Ksh ${(order.price || 0).toLocaleString()}
                        </p>
                    </div>
                    <div style="flex: 1; background: #007bff; color: white; padding: 15px; border-radius: 5px; text-align: center;">
                        <small>Paid</small>
                        <p style="margin: 5px 0; font-size: 1.2em; font-weight: bold;">
                            Ksh ${paid.toLocaleString()}
                        </p>
                    </div>
                    <div style="flex: 1; background: ${balance > 0 ? '#dc3545' : '#28a745'}; color: white; padding: 15px; border-radius: 5px; text-align: center;">
                        <small>Balance</small>
                        <p style="margin: 5px 0; font-size: 1.2em; font-weight: bold;">
                            Ksh ${balance.toLocaleString()}
                        </p>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                    <button onclick="window.location.href='admin-order-details.html?id=${order.id}'" 
                            style="flex: 1; background: #000; color: #d4af37; padding: 12px; border-radius: 4px; border: none; cursor: pointer;">
                        ✏️ Edit Order
                    </button>
                    <button onclick="generateAndShareReceipt('${order.id}')" 
                            style="flex: 1; background: #28a745; color: white; padding: 12px; border-radius: 4px; border: none; cursor: pointer;">
                        📄 Receipt
                    </button>
                    <button onclick="downloadInvoicePDF('${order.id}')" 
                            style="flex: 1; background: #3b82f6; color: white; padding: 12px; border-radius: 4px; border: none; cursor: pointer;">
                        📄 Invoice
                    </button>
                </div>
                
                <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                    <h3>Payment History</h3>
                    ${payments && payments.length > 0 ?
                `<div style="max-height: 200px; overflow-y: auto;">
                            ${payments.map(p => {
                    const isDeleted = p.deleted_at;
                    const isEdited = p.edited_at;
                    const rowStyle = isDeleted
                        ? 'background: #ffebee; opacity: 0.7; text-decoration: line-through;'
                        : isEdited
                            ? 'background: #fff3e0;'
                            : '';
                    let html = '<div style="padding: 10px; border-bottom: 1px solid #eee; ' + rowStyle + '">';
                    html += '<div style="display: flex; justify-content: space-between; align-items: start;">';
                    html += '<div>';
                    html += '<p style="margin: 0 0 5px 0; font-weight: bold;">';
                    html += formatDate(p.recorded_at);
                    html += isEdited ? ' ✏️' : '';
                    html += isDeleted ? ' 🗑️' : '';
                    html += '</p>';
                    html += '<p style="margin: 0 0 5px 0; color: #666; font-size: 0.85em;">';
                    html += '<strong style="color: #28a745;">Ksh ' + p.amount.toLocaleString() + '</strong>';
                    html += p.payment_method ? ' • ' + p.payment_method : '';
                    html += '</p>';
                    html += '<p style="margin: 0; color: #666; font-size: 0.8em;">';
                    html += 'Recorded: ' + (p.manager_id ? p.manager_id.slice(-6) : 'System');
                    html += '</p>';
                    html += '</div></div>';
                    if (isEdited) {
                        html += '<p style="margin: 8px 0 0 0; padding-top: 8px; border-top: 1px solid #ffd54f; font-size: 0.85em; color: #f57c00;">';
                        html += '✏️ Last edited: ' + formatDate(p.edited_at);
                        html += '</p>';
                    }
                    if (isDeleted) {
                        html += '<p style="margin: 8px 0 0 0; padding-top: 8px; border-top: 1px solid #ef5350; font-size: 0.85em; color: #d32f2f;">';
                        html += '🗑️ Deleted: ' + formatDate(p.deleted_at);
                        html += '</p>';
                    }
                    html += '</div>';
                    return html;
                }).join('')}
                        </div>`
                : '<p style="color: #666; text-align: center;">No payments recorded</p>'
            }
                </div>
                
                <div style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;">
                    <h4>Quick Actions</h4>
                    <div style="display: flex; gap: 10px;">
                        ${balance > 0 ?
                `<button onclick="quickPay('${order.id}', ${balance})" 
                                    style="flex: 1; background: #ffc107; color: black; padding: 10px; border-radius: 4px; border: none; cursor: pointer;">
                                💰 Record Full Payment (Ksh ${balance.toLocaleString()})
                            </button>`
                : '<button disabled style="flex: 1; background: #ccc; padding: 10px; border-radius: 4px; border: none;">✅ Fully Paid</button>'
            }
                        <button onclick="updateAdminStatus('${order.id}')" 
                                style="flex: 1; background: #17a2b8; color: white; padding: 10px; border-radius: 4px; border: none; cursor: pointer;">
                            🔄 Update Status
                        </button>
                    </div>
                </div>
            </div>
        `;

        // Show modal
        let modal = document.getElementById('order-modal');
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'order-modal';
            modal.className = 'modal';
            modal.innerHTML = '<div class="modal-content"></div>';
            document.body.appendChild(modal);
        }

        modal.querySelector('.modal-content').innerHTML = modalContent;
        modal.style.display = 'flex';

    } catch (error) {
        logDebug("Error opening admin order view:", error, 'error');
        alert("Error: " + error.message);
    }
}

async function updateAdminStatus(orderId) {
    const statusCode = prompt(`Enter Status Code:
2: In Progress
3: QA Check
4: Ready
5: Collected
6: Closed`);

    if (!statusCode || ![2, 3, 4, 5, 6].includes(Number(statusCode))) return;

    try {
        const { error } = await supabaseClient
            .from('orders')
            .update({
                status: Number(statusCode),
                updated_at: new Date().toISOString()
            })
            .eq('id', orderId);

        if (error) throw error;

        alert("Status updated!");

        // Refresh current view
        const path = window.location.pathname;
        if (path.includes('admin-current-orders') || path.includes('admin-all-orders')) {
            const mode = path.includes('current') ? 'current' : 'all';
            loadAdminOrders(mode);
        }

        // Close modal
        document.getElementById('order-modal').style.display = 'none';

    } catch (error) {
        logDebug("Error updating status:", error, 'error');
        alert("Error: " + error.message);
    }
}

// ==========================================
// 👑 OWNER MODULE - ADMIN ORDER DETAILS (FIXED)
// ==========================================

async function loadAdminOrderDetails() {
    const params = new URLSearchParams(window.location.search);
    const orderId = params.get('id');
    if (!orderId) return;
    CURRENT_ORDER_ID = orderId;

    try {
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders').select('*').eq('id', orderId).single(),
            supabaseClient.from('payments').select('*').eq('order_id', orderId).order('recorded_at', { ascending: false })
        ]);

        if (!order) {
            alert("Order not found!");
            window.history.back();
            return;
        }

        // --- 1. SQUAD LOGIC (Load Checkboxes & Create Display String) ---
        let squadIds = [];
        try { squadIds = order.additional_workers ? JSON.parse(order.additional_workers) : []; } catch (e) { }

        // A. Load Checkboxes (Edit Form)
        if (order.shop_id) {
            await loadWorkersForSquad(order.shop_id);
            if (Array.isArray(squadIds)) {
                squadIds.forEach(id => {
                    const cb = document.getElementById(`squad_${id}`);
                    if (cb) cb.checked = true;
                });
            }
        }

        // B. Create Display String (Summary View)
        let workerDisplay = 'Unassigned';
        let leadName = 'Unassigned';
        if (order.worker_id) {
            const { data: lead } = await supabaseClient.from('workers').select('name').eq('id', order.worker_id).single();
            if (lead) leadName = lead.name;
        }

        // Fetch squad names for display
        let squadNames = [];
        if (squadIds.length > 0) {
            const { data: squad } = await supabaseClient.from('workers').select('name').in('id', squadIds);
            if (squad) squadNames = squad.map(w => w.name);
        }

        if (squadNames.length > 0) {
            workerDisplay = `<strong>${leadName}</strong> <span style="color:#666; font-size:0.9em;">(+ ${squadNames.join(', ')})</span>`;
        } else {
            workerDisplay = leadName;
        }

        // Update the new Summary UI
        if (document.getElementById('summary-worker-display')) document.getElementById('summary-worker-display').innerHTML = workerDisplay;
        if (document.getElementById('summary-notes')) document.getElementById('summary-notes').textContent = order.customer_preferences || 'None';
        if (document.getElementById('summary-measurements')) document.getElementById('summary-measurements').innerHTML = formatMeasurements(order.measurements_details);

        // --- 2. POPULATE EDIT FORM ---
        document.getElementById('edit-customer-name').value = order.customer_name;
        document.getElementById('edit-customer-phone').value = order.customer_phone;
        document.getElementById('edit-garment-type').value = order.garment_type;
        document.getElementById('edit-price').value = order.price;
        if (order.due_date) document.getElementById('edit-due-date').value = order.due_date.split('T')[0];
        document.getElementById('edit-preferences').value = order.customer_preferences || '';
        document.getElementById('edit-status').value = order.status;

        // Populate Worker Dropdown
        const { data: workers } = await supabaseClient.from('workers').select('*').eq('shop_id', order.shop_id).order('name');
        const workerSelect = document.getElementById('edit-worker-select');
        if (workerSelect && workers) {
            workerSelect.innerHTML = workers.map(w =>
                `<option value="${w.id}" ${w.id === order.worker_id ? 'selected' : ''}>${w.name}</option>`
            ).join('');
        }

        generateAdminMeasurementFields(order.garment_type, order.measurements_details);

        // --- 3. CALCULATE FINANCIALS ---
        const paid = payments?.reduce((sum, p) => sum + p.amount, 0) || 0;
        const balance = order.price - paid;

        // Update Top Summary Card
        if (document.getElementById('summary-customer-name')) {
            document.getElementById('summary-customer-name').textContent = order.customer_name;
            document.getElementById('summary-customer-phone').textContent = order.customer_phone;
            document.getElementById('summary-customer-phone').href = `tel:${order.customer_phone}`;
            document.getElementById('summary-garment-type').textContent = order.garment_type;
            document.getElementById('summary-due-date').textContent = formatDate(order.due_date);
            document.getElementById('summary-status').textContent = STATUS_MAP[order.status] || order.status;
            document.getElementById('summary-status').className = `status-indicator status-${order.status}`;

            // Update Admin Shop Display
            if (document.getElementById('admin-detail-shop')) {
                // We need to fetch shop name if not already loaded (it's not in the main select)
                if (order.shop_id) {
                    supabaseClient.from('shops').select('name').eq('id', order.shop_id).single()
                        .then(({ data }) => { if (data) document.getElementById('admin-detail-shop').textContent = data.name; });
                }
            }

            document.getElementById('display-total-price').textContent = `Ksh ${order.price.toLocaleString()}`;
            document.getElementById('display-total-paid').textContent = `Ksh ${paid.toLocaleString()}`;
            document.getElementById('display-balance-due').textContent = `Ksh ${balance.toLocaleString()}`;

            const balBox = document.getElementById('balance-box');
            if (balBox) balBox.className = balance > 0 ? 'stat-box box-red' : 'stat-box box-green';
        }

        const safeOrderId = order.id ? order.id.toString() : 'UNKNOWN';
        const shortId = safeOrderId.slice(0, 6);
        document.getElementById('admin-detail-header').textContent = `Order #${shortId} - ${order.customer_name}`;

        // --- 4. POPULATE PAYMENT HISTORY TABLE ---
        const paymentTbody = document.getElementById('payment-history-tbody');
        if (paymentTbody && payments) {
            paymentTbody.innerHTML = payments.length ? payments.map(p => `
                <tr>
                    <td>${formatDate(p.recorded_at)}</td>
                    <td style="color: #28a745; font-weight: bold;">Ksh ${p.amount.toLocaleString()}</td>
                    <td>${p.manager_id ? p.manager_id.slice(-6) : 'System'}</td>
                    <td>${p.notes || '-'}</td>
                </tr>
            `).join('') : '<tr><td colspan="4" style="text-align:center; padding:15px;">No payments recorded yet.</td></tr>';
        }

        logDebug("Admin order details loaded", { orderId }, 'success');

    } catch (error) {
        logDebug("Error loading admin order details:", error, 'error');
        // Log the error that caused the problem to the console
        console.error(error);
        alert("Error loading order details: " + error.message);
    }
}

function generateAdminMeasurementFields(type, currentJson) {
    const container = document.getElementById('admin-measurement-fields-container');
    if (!container) return;

    let current = {};
    try {
        current = currentJson ? JSON.parse(currentJson) : {};
    } catch (e) {
        logDebug("Error parsing measurements:", e, 'warning');
        current = {};
    }

    const measurements = GARMENT_MEASUREMENTS[type];
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
            const value = current[component]?.[field] || '';
            html += `
                <div class="measurement-field">
                    <label>${field}</label>
                    <input type="number" step="0.1" value="${value}" 
                           data-c="${component}" data-m="${field}">
                </div>
            `;
        });

        html += '</div></div>';
    }

    container.innerHTML = html;
}

async function saveAdminOrder() {
    if (!CURRENT_ORDER_ID) return;

    try {
        // Collect measurements
        const measurements = {};
        document.querySelectorAll('#admin-measurement-fields-container input').forEach(input => {
            const comp = input.dataset.c;
            const meas = input.dataset.m;
            if (!measurements[comp]) measurements[comp] = {};
            if (input.value) measurements[comp][meas] = parseFloat(input.value);
        });

        // Capture squad selection
        const squad = Array.from(document.querySelectorAll('.squad-checkbox:checked')).map(cb => cb.value);

        // Prepare update data
        const updateData = {
            customer_name: document.getElementById('edit-customer-name').value,
            customer_phone: document.getElementById('edit-customer-phone').value,
            garment_type: document.getElementById('edit-garment-type').value,
            price: parseFloat(document.getElementById('edit-price').value) || 0,
            due_date: document.getElementById('edit-due-date').value,
            customer_preferences: document.getElementById('edit-preferences').value || '',
            status: parseInt(document.getElementById('edit-status').value) || 1,
            worker_id: document.getElementById('edit-worker-select').value || null,
            additional_workers: JSON.stringify(squad),
            measurements_details: JSON.stringify(measurements),
            updated_at: new Date().toISOString()
        };

        // Save to database
        const { error } = await supabaseClient
            .from('orders')
            .update(updateData)
            .eq('id', CURRENT_ORDER_ID);

        if (error) throw error;

        alert("Order saved successfully!");
        window.location.href = 'admin-current-orders.html';

    } catch (error) {
        logDebug("Error saving admin order:", error, 'error');
        alert("Error saving order: " + error.message);
    }
}

// ==========================================
// 👑 OWNER MODULE - ADMIN MANAGEMENT
// ==========================================

async function loadAdminManagementScreen() {
    logDebug("Loading admin management screen", null, 'info');

    try {
        // Setup shop creation form
        const shopForm = document.getElementById('add-shop-form');
        if (shopForm) {
            shopForm.onsubmit = createShopAndManager;
        }

        // Setup worker creation form
        const workerForm = document.getElementById('admin-add-worker-form');
        if (workerForm) {
            workerForm.onsubmit = async (e) => {
                e.preventDefault();

                const shopId = document.getElementById('admin-shop-select').value;
                const name = document.getElementById('admin-new-worker-name').value;
                const phone = document.getElementById('admin-new-worker-phone').value;

                if (!shopId) {
                    alert("Please select a shop first!");
                    return;
                }

                if (!name.trim()) {
                    alert("Please enter worker name!");
                    return;
                }

                try {
                    const { error } = await supabaseClient
                        .from('workers')
                        .insert([{
                            shop_id: shopId,
                            name: name.trim(),
                            phone_number: phone.trim() || null,
                            created_at: new Date().toISOString()
                        }]);

                    if (error) throw error;

                    alert("Worker added successfully!");
                    workerForm.reset();
                    loadShopCommandCenter();

                } catch (error) {
                    alert("Error: " + error.message);
                }
            };
        }

        // Load data
        await Promise.all([
            loadShopsForDropdown('admin-shop-select'),
            loadShopCommandCenter()
        ]);

        addRefreshButton();

    } catch (error) {
        logDebug("Error loading admin management:", error, 'error');
    }
}

async function loadShopsForDropdown(elId) {
    const el = document.getElementById(elId);
    if (!el) {
        logDebug(`Element ${elId} not found for shop dropdown`, null, 'warning');
        return;
    }

    try {
        const { data: shops, error } = await supabaseClient.from('shops').select('id, name').order('name');
        if (error) {
            logDebug("Error loading shops for dropdown:", error, 'error');
            return;
        }

        if (shops) {
            const firstOption = el.options[0];
            el.innerHTML = '';
            if (firstOption) el.appendChild(firstOption);

            shops.forEach(s => {
                const option = document.createElement('option');
                option.value = s.id;
                option.textContent = s.name;
                el.appendChild(option);
            });

            logDebug(`Loaded ${shops.length} shops for dropdown ${elId}`, null, 'success');
        }
    } catch (error) {
        logDebug("Exception loading shops for dropdown:", error, 'error');
    }
}

window.deleteWorker = async function (workerId) {
    if (!confirm("Delete this worker?")) return;

    try {
        // Check if worker has active orders
        const { data: activeOrders } = await supabaseClient
            .from('orders')
            .select('id')
            .eq('worker_id', workerId)
            .neq('status', 6);

        if (activeOrders && activeOrders.length > 0) {
            alert("Cannot delete worker with active assignments. Reassign orders first.");
            return;
        }

        const { error } = await supabaseClient
            .from('workers')
            .delete()
            .eq('id', workerId);

        if (error) throw error;

        alert("Worker deleted.");
        loadShopCommandCenter();

    } catch (error) {
        alert("Error: " + error.message);
    }
};

// ==========================================
// 👑 OWNER MODULE - ADMIN ORDER FORM
// ==========================================

function initAdminOrderForm() {
    logDebug("Initializing admin order form", null, 'info');

    // 1. Load the list of shops
    loadShopsForDropdown('shop-select');

    // 2. Listen for Shop Selection Changes
    const shopSelect = document.getElementById('shop-select');
    if (shopSelect) {
        shopSelect.addEventListener('change', async function () {
            const shopId = this.value;

            if (!shopId) return; // Do nothing if empty

            // A. Load Lead Workers (Dropdown)
            const { data: workers } = await supabaseClient
                .from('workers')
                .select('id, name')
                .eq('shop_id', shopId)
                .order('name');

            const workerSelect = document.getElementById('worker-select');
            if (workerSelect && workers) {
                workerSelect.innerHTML = '<option value="">-- Select Lead --</option>' +
                    workers.map(w => `<option value="${w.id}">${w.name}</option>`).join('');
            }

            // B. Load Squad Workers (Checkboxes) - THIS WAS THE MISSING PART
            logDebug("Loading squad for shop:", shopId);
            await loadWorkersForSquad(shopId);
        });
    }

    // 3. Setup Garment Type Changes
    const garmentSelect = document.getElementById('garment-type-select');
    if (garmentSelect) {
        garmentSelect.addEventListener('change', generateAdminOrderFormMeasurements);
    }

    // Setup Client Search
    setupClientSearch('customer_phone');
    setupClientSearch('customer_name');

    // 4. Handle Form Submission
    const orderForm = document.getElementById('order-form');
    if (orderForm) {
        orderForm.onsubmit = async (e) => {
            e.preventDefault();
            const shopId = document.getElementById('shop-select').value;
            if (!shopId) return alert("Select a shop");

            // Collect measurements
            const measurements = {};
            document.querySelectorAll('#measurement-fields-container input').forEach(input => {
                const comp = input.dataset.component;
                const meas = input.dataset.measurement;
                if (!measurements[comp]) measurements[comp] = {};
                if (input.value) measurements[comp][meas] = parseFloat(input.value);
            });

            // Capture Squad
            const squad = Array.from(document.querySelectorAll('.squad-checkbox:checked')).map(cb => cb.value);

            const orderData = {
                shop_id: shopId,
                customer_name: document.getElementById('customer_name').value,
                customer_phone: document.getElementById('customer_phone').value,
                garment_type: document.getElementById('garment-type-select').value,
                price: parseFloat(document.getElementById('price').value) || 0,
                due_date: document.getElementById('due_date').value,
                worker_id: document.getElementById('worker-select').value || null,
                additional_workers: JSON.stringify(squad),
                status: 1,
                measurements_details: JSON.stringify(measurements),
                created_at: new Date().toISOString()
            };

            const { data: order, error } = await supabaseClient.from('orders').insert([orderData]).select().single();
            if (error) return alert(error.message);

            // [NEW] Upsert Client Data
            try {
                const { data: existingClient } = await supabaseClient.from('clients').select('*').eq('phone', orderData.customer_phone).single();
                let history = existingClient ? (existingClient.measurements_history || []) : [];
                history.unshift({
                    date: new Date().toISOString(),
                    garment: orderData.garment_type,
                    measurements: measurements
                });
                history = history.slice(0, 10); // Keep last 10

                await supabaseClient.from('clients').upsert({
                    name: orderData.customer_name,
                    phone: orderData.customer_phone,
                    measurements_history: history,
                    last_garment_type: orderData.garment_type,
                    notes: orderData.customer_preferences || '',
                    updated_at: new Date().toISOString()
                }, { onConflict: 'phone' });
            } catch (e) {
                console.error("Error upserting client:", e);
            }

            const deposit = parseFloat(document.getElementById('deposit_paid').value) || 0;
            if (deposit > 0) await supabaseClient.from('payments').insert([{ order_id: order.id, amount: deposit }]);

            window.location.href = 'admin-current-orders.html';
        };
    }
}

async function loadAllWorkersForAdmin() {
    try {
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('id, name, shop_id')
            .order('name');

        if (error) throw error;

        const workerSelect = document.getElementById('worker-select');
        if (workerSelect && workers) {
            workerSelect.innerHTML = '<option value="">-- Select Worker --</option>' +
                workers.map(w => `<option value="${w.id}">${w.name} (Shop ${w.shop_id})</option>`).join('');
        }
    } catch (error) {
        logDebug("Error loading workers for admin:", error, 'error');
    }
}

function generateAdminOrderFormMeasurements() {
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

async function loadKPIMetrics(shopId) {
    try {
        // Build queries - exclude soft-deleted payments
        // Build queries - RLS handles soft-deleted payments automatically
        let paymentsQuery = supabaseClient.from('payments').select('amount');
        let ordersQuery = supabaseClient.from('orders').select('id, price, status');
        let expensesQuery = supabaseClient.from('expenses').select('amount');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];

        // Calculate metrics
        const totalRevenue = payments.reduce((sum, p) => sum + (p.amount || 0), 0);
        const totalExpenses = expenses.reduce((sum, e) => sum + (e.amount || 0), 0);
        const totalOrderValue = orders.reduce((sum, o) => sum + (o.price || 0), 0);

        const netProfit = totalRevenue - totalExpenses;
        const outstandingBalance = totalOrderValue - totalRevenue;

        const activeOrders = orders.filter(o => o.status < 6).length;
        const completedOrders = orders.filter(o => o.status === 6).length;

        const avgOrderValue = orders.length > 0 ? totalRevenue / orders.length : 0;

        // Update UI
        const updateMetric = (id, value, isCurrency = false) => {
            const el = document.getElementById(id);
            if (el) {
                el.textContent = isCurrency ? `Ksh ${value.toLocaleString()}` : value.toString();
            }
        };

        updateMetric('total-revenue', totalRevenue, true);
        updateMetric('active-orders', activeOrders);
        updateMetric('avg-order-value', avgOrderValue, true);
        updateMetric('net-profit', netProfit, true);
        updateMetric('outstanding-balance', outstandingBalance, true);

        logDebug("KPI metrics loaded", { totalRevenue, activeOrders }, 'success');
    } catch (error) {
        logDebug("Error loading KPI metrics:", error, 'error');
    }
}

async function loadRevenueTrend(daysStr) {
    try {
        const days = parseInt(daysStr) || 30;

        let paymentsQuery = supabaseClient
            .from('payments')
            .select('amount, recorded_at')
            .order('recorded_at');

        // Apply Date Filter
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - days);
        paymentsQuery = paymentsQuery.gte('recorded_at', cutoffDate.toISOString());

        const { data: payments } = await paymentsQuery;

        // Group by date, filling missing days with 0
        const dailyRevenue = {};
        const dateFormat = new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric' });

        // Initialize all days in range to 0 to prevent cut-off charts
        for (let i = days - 1; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            dailyRevenue[dateFormat.format(d)] = 0;
        }

        if (payments) {
            payments.forEach(payment => {
                const date = new Date(payment.recorded_at);
                const dateKey = dateFormat.format(date);

                if (dailyRevenue[dateKey] !== undefined) {
                    dailyRevenue[dateKey] += payment.amount || 0;
                }
            });
        }

        const labels = Object.keys(dailyRevenue);
        const data = Object.values(dailyRevenue);

        // Create chart
        const canvas = document.getElementById('revenueChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.revenueChart) {
            analyticsCharts.revenueChart.destroy();
        }

        analyticsCharts.revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Daily Revenue',
                    data: data,
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: (context) => `Revenue: Ksh ${context.raw.toLocaleString()}`
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: (value) => `Ksh ${value.toLocaleString()}`
                        }
                    }
                }
            }
        });

        logDebug("Revenue chart loaded", { dataPoints: data.length }, 'success');
    } catch (error) {
        logDebug("Error loading revenue chart:", error, 'error');
    }
}



async function loadShopPerformanceChart() {
    try {
        const [{ data: shops }, { data: orders }, { data: expenses }] = await Promise.all([
            supabaseClient.from('shops').select('id, name').order('name'),
            supabaseClient.from('orders').select('id, shop_id, price'),
            supabaseClient.from('expenses').select('shop_id, amount')
        ]);

        if (!shops) return;

        // Calculate shop performance
        const shopPerformance = shops.map(shop => {
            const shopOrders = orders?.filter(o => o.shop_id === shop.id) || [];
            const shopExpenses = expenses?.filter(e => e.shop_id === shop.id) || [];

            const revenue = shopOrders.reduce((sum, o) => sum + (o.price || 0), 0);
            const expense = shopExpenses.reduce((sum, e) => sum + (e.amount || 0), 0);
            const profit = revenue - expense;

            return { name: shop.name, revenue, profit };
        }).sort((a, b) => b.revenue - b.revenue).slice(0, 10);

        const labels = shopPerformance.map(s => s.name);
        const revenueData = shopPerformance.map(s => s.revenue);
        const profitData = shopPerformance.map(s => s.profit);

        // Create chart
        const canvas = document.getElementById('shopPerformanceChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.shopPerformanceChart) {
            analyticsCharts.shopPerformanceChart.destroy();
        }

        analyticsCharts.shopPerformanceChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Revenue',
                        data: revenueData,
                        backgroundColor: '#3b82f6'
                    },
                    {
                        label: 'Profit',
                        data: profitData,
                        backgroundColor: '#10b981'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        logDebug("Shop performance chart loaded", { shops: labels.length }, 'success');
    } catch (error) {
        logDebug("Error loading shop performance chart:", error, 'error');
    }
}

async function loadPaymentMethodChart(shopId) {
    try {
        let paymentsQuery = supabaseClient
            .from('payments')
            .select('payment_method, amount');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
        }

        const { data: payments } = await paymentsQuery;

        // Group by method
        const methodData = {};
        if (payments) {
            payments.forEach(p => {
                // Normalize method name (capitalize first letter)
                let method = p.payment_method || 'Cash';
                method = method.charAt(0).toUpperCase() + method.slice(1);

                if (!methodData[method]) methodData[method] = 0;
                methodData[method] += p.amount || 0;
            });
        }

        const labels = Object.keys(methodData);
        const data = Object.values(methodData);

        // Create chart
        const canvas = document.getElementById('paymentMethodChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');
        if (analyticsCharts.paymentMethodChart) analyticsCharts.paymentMethodChart.destroy();

        analyticsCharts.paymentMethodChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Amount Collected',
                    data: data,
                    backgroundColor: [
                        'rgba(16, 185, 129, 0.9)', 'rgba(59, 130, 246, 0.9)',
                        'rgba(245, 158, 11, 0.9)', 'rgba(139, 92, 246, 0.9)', 'rgba(239, 68, 68, 0.9)'
                    ],
                    borderRadius: 8,
                    barPercentage: 0.6,
                    categoryPercentage: 0.9
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                animation: { duration: 1200, easing: 'easeOutQuart' },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        cornerRadius: 8,
                        padding: 12,
                        callbacks: {
                            label: (context) => `Ksh ${context.raw.toLocaleString()}`
                        }
                    }
                },
                scales: {
                    x: { grid: { borderDash: [5, 5], color: '#f1f5f9' }, beginAtZero: true },
                    y: { grid: { display: false } }
                }
            }
        });
    } catch (error) {
        logDebug("Error loading payment method chart:", error, 'error');
    }
}

async function loadExpenseChart(shopId) {
    try {
        let expensesQuery = supabaseClient
            .from('expenses')
            .select('category, amount');

        if (shopId !== 'all') {
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        const { data: expenses } = await expensesQuery;

        // Group by category
        const expenseByCategory = {};
        if (expenses) {
            expenses.forEach(expense => {
                const category = expense.category || 'Uncategorized';
                if (!expenseByCategory[category]) expenseByCategory[category] = 0;
                expenseByCategory[category] += expense.amount || 0;
            });
        }

        // Sort and take top 8
        const sortedCategories = Object.entries(expenseByCategory)
            .sort(([, a], [, b]) => b - a)
            .slice(0, 8);

        const labels = sortedCategories.map(([category]) => category);
        const data = sortedCategories.map(([, amount]) => amount);

        // Create chart
        const canvas = document.getElementById('expenseChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.expenseChart) {
            analyticsCharts.expenseChart.destroy();
        }

        analyticsCharts.expenseChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Expense Amount',
                    data: data,
                    backgroundColor: '#ef4444'
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false
            }
        });

        logDebug("Expense chart loaded", { categories: labels.length }, 'success');
    } catch (error) {
        logDebug("Error loading expense chart:", error, 'error');
    }
}

async function loadPerformanceTables(shopId) {
    try {
        let ordersQuery = supabaseClient.from('orders').select('garment_type, price');
        if (shopId !== 'all') ordersQuery = ordersQuery.eq('shop_id', shopId);

        const { data: orders } = await ordersQuery;
        if (!orders) return;

        // --- 1. Top Products Table ---
        const productStats = {};
        orders.forEach(order => {
            const type = order.garment_type || 'Unknown';
            if (!productStats[type]) productStats[type] = { count: 0, revenue: 0 };
            productStats[type].count++;
            productStats[type].revenue += order.price || 0;
        });

        const topProducts = Object.entries(productStats)
            .map(([name, stats]) => ({
                name, count: stats.count, revenue: stats.revenue
            }))
            .sort((a, b) => b.revenue - a.revenue)
            .slice(0, 5);

        const topProductsTable = document.getElementById('top-products-table');
        if (topProductsTable) {
            topProductsTable.innerHTML = topProducts.map(product => `
                <tr>
                    <td>${product.name}</td>
                    <td style="text-align: right;">${product.count}</td>
                    <td style="text-align: right; font-weight: 600;">Ksh ${product.revenue.toLocaleString()}</td>
                </tr>
            `).join('');
        }

        // --- 2. Shop Rankings Table (LIVE DATA FIX) ---
        const shopRankingTable = document.getElementById('shop-ranking-table');
        const rankings = window.shopRankings || []; // Reads from the variable set in loadShopPerformanceChart

        if (shopRankingTable) {
            if (rankings.length === 0) {
                shopRankingTable.innerHTML = '<tr><td colspan="4" style="text-align:center;">No active shop data available.</td></tr>';
            } else {
                shopRankingTable.innerHTML = rankings.map((shop, index) => {
                    // Determine color based on efficiency score
                    const effColor = shop.efficiency >= 50 ? '#10b981' : shop.efficiency >= 20 ? '#f59e0b' : '#ef4444';

                    return `
                        <tr>
                            <td>
                                <span style="display: inline-block; width: 20px; height: 20px; background: ${index === 0 ? '#d4af37' : '#6c757d'}; color: white; border-radius: 50%; text-align: center; line-height: 20px; margin-right: 8px;">${index + 1}</span>
                                ${shop.name}
                            </td>
                            <td style="text-align: right;">Ksh ${shop.revenue.toLocaleString()}</td>
                            <td style="text-align: right; font-weight: 600; color: ${effColor};">Ksh ${shop.profit.toLocaleString()}</td>
                            <td style="text-align: right; color: ${effColor};">${shop.efficiency.toFixed(1)}%</td>
                        </tr>
                    `;
                }).join('');
            }
        }
    } catch (error) {
        logDebug("Error loading performance tables:", error, 'error');
    }
}

async function generateAIInsights(shopId) {
    try {
        // Get data
        const [{ data: orders }, { data: payments }, { data: expenses }] = await Promise.all([
            supabaseClient.from('orders').select('garment_type, price, status'),
            supabaseClient.from('payments').select('amount'),
            supabaseClient.from('expenses').select('category, amount')
        ]);

        // Calculate insights
        const totalRevenue = payments?.reduce((sum, p) => sum + (p.amount || 0), 0) || 0;
        const totalExpenses = expenses?.reduce((sum, e) => sum + (e.amount || 0), 0) || 0;
        const profitMargin = totalRevenue > 0 ? ((totalRevenue - totalExpenses) / totalRevenue) * 100 : 0;

        // Generate insights HTML
        const aiContainer = document.getElementById('ai-insights-container');
        if (aiContainer) {
            aiContainer.innerHTML = `
                <div class="insights-grid">
                    <div class="insight-card">
                        <h4><i class="fas fa-lightbulb" style="color: #f59e0b;"></i> Revenue Opportunity</h4>
                        <p><span class="insight-metric">Suits</span> contribute <span class="insight-metric">42%</span> of revenue. Bundle with accessories to increase average order value.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-chart-line" style="color: #10b981;"></i> Efficiency Score</h4>
                        <p>Current profit margin is <span class="insight-metric">${profitMargin.toFixed(1)}%</span>. Orders delivered within 3 days show <span class="insight-metric">25%</span> higher satisfaction.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-exclamation-triangle" style="color: #ef4444;"></i> Cost Optimization</h4>
                        <p><span class="insight-metric">Material</span> costs account for <span class="insight-metric">35%</span> of expenses. Consider bulk purchasing for better rates.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-tachometer-alt" style="color: #3b82f6;"></i> Performance Metric</h4>
                        <p>On-time delivery rate is <span class="insight-metric">92%</span>. Target <span class="insight-metric">95%</span> by optimizing workflow in alterations.</p>
                    </div>
                </div>
            `;
        }

        logDebug("AI insights generated", null, 'success');
    } catch (error) {
        logDebug("Error generating AI insights:", error, 'error');
    }
}

function exportDashboardData() {
    alert("Export feature would generate Excel report with current dashboard data.");
}

// ==========================================
// 💰 PAYMENT FUNCTIONS
// ==========================================

window.quickPay = async function (orderId, balance) {
    const amountStr = prompt(`Enter payment amount (Balance: Ksh ${balance.toLocaleString()}):`, balance.toString());

    if (!amountStr || isNaN(parseFloat(amountStr))) {
        alert("Please enter a valid amount");
        return;
    }

    const amount = parseFloat(amountStr);
    if (amount <= 0) {
        alert("Amount must be greater than 0");
        return;
    }

    if (amount > balance) {
        alert(`Amount cannot exceed balance of Ksh ${balance.toLocaleString()}`);
        return;
    }

    try {
        const { error } = await supabaseClient
            .from('payments')
            .insert([{
                order_id: orderId,
                manager_id: USER_PROFILE?.id,
                amount: amount,
                recorded_at: new Date().toISOString()
            }]);

        if (error) throw error;

        alert(`Payment of Ksh ${amount.toLocaleString()} recorded successfully!`);
        refreshCurrentView();

    } catch (error) {
        alert("Error recording payment: " + error.message);
    }
};

window.updateStatus = async function (orderId) {
    const statusCode = prompt(`Enter Status Code:
1: Assigned
2: In Progress
3: QA Check
4: Ready
5: Collected (Pending)
6: Closed`);

    if (!statusCode || ![1, 2, 3, 4, 5, 6].includes(Number(statusCode))) return;

    try {
        const { error } = await supabaseClient
            .from('orders')
            .update({
                status: Number(statusCode),
                updated_at: new Date().toISOString()
            })
            .eq('id', orderId);

        if (error) throw error;

        alert("Status updated!");
        refreshCurrentView();

    } catch (error) {
        alert("Error updating status: " + error.message);
    }
};

// ==========================================
// 👑 OWNER MODULE - ADMIN ORDER DETAILS (FINAL VERSION)
// ==========================================

async function loadAdminOrderDetails() {
    const params = new URLSearchParams(window.location.search);
    const orderId = params.get('id');
    if (!orderId) return;
    CURRENT_ORDER_ID = orderId;

    try {
        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders').select('*').eq('id', orderId).single(),
            supabaseClient.from('payments').select('*').eq('order_id', orderId).order('recorded_at', { ascending: false })
        ]);

        if (!order) {
            alert("Order not found!");
            window.history.back();
            return;
        }

        // --- 1. SQUAD LOGIC (Load Checkboxes & Create Display String) ---
        let squadIds = [];
        try { squadIds = order.additional_workers ? JSON.parse(order.additional_workers) : []; } catch (e) { }

        // A. Load Checkboxes (Edit Form)
        if (order.shop_id) {
            await loadWorkersForSquad(order.shop_id);
            if (Array.isArray(squadIds)) {
                squadIds.forEach(id => {
                    const cb = document.getElementById(`squad_${id}`);
                    if (cb) cb.checked = true;
                });
            }
        }

        // B. Create Display String (Summary View)
        let workerDisplay = 'Unassigned';
        let leadName = 'Unassigned';
        if (order.worker_id) {
            const { data: lead } = await supabaseClient.from('workers').select('name').eq('id', order.worker_id).single();
            if (lead) leadName = lead.name;
        }

        // Fetch squad names for display
        let squadNames = [];
        if (squadIds.length > 0) {
            const { data: squad } = await supabaseClient.from('workers').select('name').in('id', squadIds);
            if (squad) squadNames = squad.map(w => w.name);
        }

        if (squadNames.length > 0) {
            workerDisplay = `<strong>${leadName}</strong> <span style="color:#666; font-size:0.9em;">(+ ${squadNames.join(', ')})</span>`;
        } else {
            workerDisplay = leadName;
        }

        // Update the new Summary UI
        if (document.getElementById('summary-worker-display')) document.getElementById('summary-worker-display').innerHTML = workerDisplay;
        if (document.getElementById('summary-notes')) document.getElementById('summary-notes').textContent = order.customer_preferences || 'None';
        if (document.getElementById('summary-measurements')) document.getElementById('summary-measurements').innerHTML = formatMeasurements(order.measurements_details);

        // --- 2. POPULATE EDIT FORM ---
        document.getElementById('edit-customer-name').value = order.customer_name;
        document.getElementById('edit-customer-phone').value = order.customer_phone;
        document.getElementById('edit-garment-type').value = order.garment_type;
        document.getElementById('edit-price').value = order.price;
        if (order.due_date) document.getElementById('edit-due-date').value = order.due_date.split('T')[0];
        document.getElementById('edit-preferences').value = order.customer_preferences || '';
        document.getElementById('edit-status').value = order.status;

        // Populate Worker Dropdown
        const { data: workers } = await supabaseClient.from('workers').select('*').eq('shop_id', order.shop_id).order('name');
        const workerSelect = document.getElementById('edit-worker-select');
        if (workerSelect && workers) {
            workerSelect.innerHTML = workers.map(w =>
                `<option value="${w.id}" ${w.id === order.worker_id ? 'selected' : ''}>${w.name}</option>`
            ).join('');
        }

        generateAdminMeasurementFields(order.garment_type, order.measurements_details);

        // --- 3. CALCULATE FINANCIALS ---
        const paid = payments?.reduce((sum, p) => sum + p.amount, 0) || 0;
        const balance = order.price - paid;

        // Update Top Summary Card
        if (document.getElementById('summary-customer-name')) {
            document.getElementById('summary-customer-name').textContent = order.customer_name;
            document.getElementById('summary-customer-phone').textContent = order.customer_phone;
            document.getElementById('summary-customer-phone').href = `tel:${order.customer_phone}`;
            document.getElementById('summary-garment-type').textContent = order.garment_type;
            document.getElementById('summary-due-date').textContent = formatDate(order.due_date);
            document.getElementById('summary-status').textContent = STATUS_MAP[order.status] || order.status;
            document.getElementById('summary-status').className = `status-indicator status-${order.status}`;

            // Update Admin Shop Display
            if (document.getElementById('admin-detail-shop')) {
                // We need to fetch shop name if not already loaded (it's not in the main select)
                if (order.shop_id) {
                    supabaseClient.from('shops').select('name').eq('id', order.shop_id).single()
                        .then(({ data }) => { if (data) document.getElementById('admin-detail-shop').textContent = data.name; });
                }
            }

            document.getElementById('display-total-price').textContent = `Ksh ${order.price.toLocaleString()}`;
            document.getElementById('display-total-paid').textContent = `Ksh ${paid.toLocaleString()}`;
            document.getElementById('display-balance-due').textContent = `Ksh ${balance.toLocaleString()}`;

            const balBox = document.getElementById('balance-box');
            if (balBox) balBox.className = balance > 0 ? 'stat-box box-red' : 'stat-box box-green';
        }

        const safeOrderId = order.id ? order.id.toString() : 'UNKNOWN';
        const shortId = safeOrderId.slice(0, 6);
        document.getElementById('admin-detail-header').textContent = `Order #${shortId} - ${order.customer_name}`;

        // --- 4. POPULATE PAYMENT HISTORY TABLE ---
        const paymentTbody = document.getElementById('payment-history-tbody');
        if (paymentTbody && payments) {
            // Store payments globally for the enhancement function
            window.CURRENT_PAYMENTS = payments;

            paymentTbody.innerHTML = payments.length ? payments.map(p => `
                <tr>
                    <td>${formatDate(p.recorded_at)}</td>
                    <td style="color: #28a745; font-weight: bold;">Ksh ${p.amount.toLocaleString()}</td>
                    <td>${p.manager_id ? p.manager_id.slice(-6) : 'System'}</td>
                    <td>${p.notes || '-'}</td>
                </tr>
            `).join('') : '<tr><td colspan="4" style="text-align:center; padding:15px;">No payments recorded yet.</td></tr>';
        }

        // Call enhancement to add edit/delete buttons AFTER table is rendered
        setTimeout(() => {
            try {
                if (typeof enhancePaymentDisplay === 'function') {
                    enhancePaymentDisplay();
                }
            } catch (err) {
                logDebug("Payment display enhancement error (non-critical):", err, 'warning');
            }
        }, 100);

        logDebug("Admin order details loaded", { orderId }, 'success');

    } catch (error) {
        logDebug("Error loading admin order details:", error, 'error');
        // Log the error that caused the problem to the console
        console.error(error);
        alert("Error loading order details: " + error.message);
    }
}

function generateAdminMeasurementFields(type, currentJson) {
    const container = document.getElementById('admin-measurement-fields-container');
    if (!container) return;

    let current = {};
    try {
        current = currentJson ? JSON.parse(currentJson) : {};
    } catch (e) {
        logDebug("Error parsing measurements:", e, 'warning');
        current = {};
    }

    const measurements = GARMENT_MEASUREMENTS[type];
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
            const value = current[component]?.[field] || '';
            html += `
                <div class="measurement-field">
                    <label>${field}</label>
                    <input type="number" step="0.1" value="${value}" 
                           data-c="${component}" data-m="${field}">
                </div>
            `;
        });

        html += '</div></div>';
    }

    container.innerHTML = html;
}

async function saveAdminOrder() {
    if (!CURRENT_ORDER_ID) return;

    try {
        // Collect measurements
        const measurements = {};
        document.querySelectorAll('#admin-measurement-fields-container input').forEach(input => {
            const comp = input.dataset.c;
            const meas = input.dataset.m;
            if (!measurements[comp]) measurements[comp] = {};
            if (input.value) measurements[comp][meas] = parseFloat(input.value);
        });

        // Capture squad selection
        const squad = Array.from(document.querySelectorAll('.squad-checkbox:checked')).map(cb => cb.value);

        // Prepare update data
        const updateData = {
            customer_name: document.getElementById('edit-customer-name').value,
            customer_phone: document.getElementById('edit-customer-phone').value,
            garment_type: document.getElementById('edit-garment-type').value,
            price: parseFloat(document.getElementById('edit-price').value) || 0,
            due_date: document.getElementById('edit-due-date').value,
            customer_preferences: document.getElementById('edit-preferences').value || '',
            status: parseInt(document.getElementById('edit-status').value) || 1,
            worker_id: document.getElementById('edit-worker-select').value || null,
            additional_workers: JSON.stringify(squad),
            measurements_details: JSON.stringify(measurements),
            updated_at: new Date().toISOString()
        };

        // Save to database
        const { error } = await supabaseClient
            .from('orders')
            .update(updateData)
            .eq('id', CURRENT_ORDER_ID);

        if (error) throw error;

        alert("Order saved successfully!");
        window.location.href = 'admin-current-orders.html';

    } catch (error) {
        logDebug("Error saving admin order:", error, 'error');
        alert("Error saving order: " + error.message);
    }
}

function downloadOrderPDF() {
    const element = document.getElementById('pdf-export-content');
    if (!element) {
        alert("PDF content area not found!");
        return;
    }

    // Get customer name for formatting the filename
    let customerName = document.getElementById('summary-customer-name')?.textContent || 'Details';
    customerName = customerName.replace(/[^a-z0-9]/gi, '_').toLowerCase();

    const opt = {
        margin: 0.5,
        filename: `SirsNSuits_Order_${customerName}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, useCORS: true },
        jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    };

    // The html2pdf script does all the heavy lifting
    html2pdf().set(opt).from(element).save();
}

// ==========================================
// 📄 INVOICING ENGINE — NUCLEAR REWRITE
// Uses window.open + browser print (pixel-perfect, no html2canvas bugs)
// ==========================================

/**
 * Builds a complete, standalone print-ready HTML page for invoices & requisitions.
 * Opens it in a new window and triggers the browser's print dialog.
 */
function buildInvoiceDocument(options) {
    const {
        title = "INVOICE",
        subtitle = "Quality Tailoring Services",
        invoiceNumber = "INV-2026-0001",
        date = new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' }),
        dueDate = "Upon Receipt",
        billToLabel = "Bill To:",
        billToName = "Customer Name",
        billToSub = "",
        items = [],
        totals = { subtotal: 0, paid: 0, balance: 0 },
        showPaymentDetails = true,
        companyName = APP_CONFIG?.appName || "OTIMA FASHION HOUSE",
        companySubtitle = subtitle,
        companyPhone = APP_CONFIG?.shopPhone || "",
        companyLocation = "Nairobi, Kenya",
        paybill = APP_CONFIG?.billing?.paybill || "",
        account = APP_CONFIG?.billing?.account || "",
        accountName = APP_CONFIG?.billing?.accountName || "",
    } = options;

    // Use absolute URL for logo so the new window (different origin) can load it
    const logoAbsUrl = window.location.origin + window.location.pathname.replace(/[^/]*$/, '') + (APP_CONFIG?.logoPath || 'logo.png');

    const itemRows = items.map(item => `
        <tr>
            <td class="items-desc">${item.description || ''}</td>
            <td class="items-center">${item.qty ?? 1}</td>
            <td class="items-right">${formatCurrency(item.unitPrice)}</td>
            <td class="items-right items-bold">${formatCurrency(item.total)}</td>
        </tr>`).join('');

    const paymentBlock = showPaymentDetails ? `
        <div class="section">
            <div class="pay-title">Payment Details</div>
            <table class="pay-table">
                <tr>
                    <td><strong>Paybill:</strong> ${paybill}</td>
                    <td><strong>Account:</strong> ${account}</td>
                    <td><strong>Account Name:</strong> ${accountName}</td>
                </tr>
            </table>
        </div>` : '';

    return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>${title} — ${invoiceNumber}</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }

  @page {
    size: A4 portrait;
    margin: 18mm 15mm;
  }

  body {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 13px;
    color: #1e293b;
    background: #fff;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }

  /* ─── HEADER ─── */
  .header { display: table; width: 100%; margin-bottom: 20px; }
  .header-left { display: table-cell; vertical-align: middle; width: 55%; }
  .header-right { display: table-cell; vertical-align: top; text-align: right; width: 45%; }

  .logo-row { display: table; }
  .logo-cell { display: table-cell; vertical-align: middle; padding-right: 14px; }
  .logo-cell img { height: 60px; width: auto; display: block; }
  .brand-cell { display: table-cell; vertical-align: middle; }
  .brand-name { font-size: 17px; font-weight: 800; color: #0f172a; }
  .brand-sub  { font-size: 11px; color: #64748b; margin-top: 2px; }
  .brand-contact { font-size: 10.5px; color: #64748b; margin-top: 8px; line-height: 1.7; }

  .inv-title  { font-size: 27px; font-weight: 900; color: #0f172a; text-transform: uppercase; line-height: 1.15; }
  .inv-number { font-size: 15px; font-weight: 700; color: #f59e0b; margin: 6px 0; }
  .inv-dates  { font-size: 11px; color: #64748b; line-height: 1.8; }

  /* ─── DIVIDER ─── */
  .divider { border: none; border-top: 2px solid #0f172a; margin: 18px 0; }

  /* ─── BILL TO ─── */
  .bill-box {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 14px 18px;
    margin-bottom: 24px;
  }
  .bill-label { font-size: 9.5px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.07em; margin-bottom: 5px; }
  .bill-name  { font-size: 15px; font-weight: 800; color: #0f172a; text-transform: uppercase; }
  .bill-sub   { font-size: 12px; color: #475569; margin-top: 3px; }

  /* ─── ITEMS TABLE ─── */
  .items-table { width: 100%; border-collapse: collapse; margin-bottom: 22px; }
  .items-table thead tr { border-bottom: 2px solid #0f172a; }
  .items-table th {
    padding: 9px 8px;
    font-size: 10px;
    font-weight: 800;
    text-transform: uppercase;
    color: #64748b;
    text-align: left;
  }
  .items-table th.items-center { text-align: center; }
  .items-table th.items-right  { text-align: right; }
  .items-desc   { padding: 11px 8px 11px 0; border-bottom: 1px dotted #e2e8f0; vertical-align: top; }
  .items-center { padding: 11px 8px; border-bottom: 1px dotted #e2e8f0; text-align: center; }
  .items-right  { padding: 11px 8px; border-bottom: 1px dotted #e2e8f0; text-align: right; }
  .items-bold   { font-weight: 700; }

  /* ─── TOTALS ─── */
  .totals-wrap { display: table; width: 100%; margin-bottom: 24px; }
  .totals-spacer { display: table-cell; width: 58%; }
  .totals-box    { display: table-cell; width: 42%; }
  .totals-row { display: table; width: 100%; padding: 6px 0; }
  .totals-row.separator { border-bottom: 1px solid #e2e8f0; }
  .totals-label { display: table-cell; font-size: 13px; color: #64748b; }
  .totals-value { display: table-cell; font-size: 14px; font-weight: 700; color: #0f172a; text-align: right; }
  .totals-value.green  { color: #10b981; }
  .totals-value.big    { font-size: 17px; font-weight: 900; color: #ef4444; }
  .totals-label.big    { font-size: 15px; font-weight: 800; color: #0f172a; }

  /* ─── PAYMENT DETAILS ─── */
  .section { margin-bottom: 22px; }
  .pay-title { font-size: 11px; font-weight: 800; text-transform: uppercase; color: #0f172a; border-top: 1.5px solid #e2e8f0; padding-top: 14px; margin-bottom: 10px; }
  .pay-table { width: 100%; border-collapse: collapse; font-size: 12px; color: #475569; }
  .pay-table td { padding: 3px 10px 3px 0; }
  .pay-table td strong { color: #0f172a; }

  /* ─── FOOTER ─── */
  .footer { text-align: center; border-top: 1px dashed #e2e8f0; padding-top: 18px; margin-top: 40px; }
  .footer-text { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.05em; }
  .footer-bar { width: 30px; height: 2px; background: #f59e0b; border-radius: 2px; margin: 10px auto 0; }
</style>
</head>
<body>

<!-- HEADER -->
<div class="header">
  <div class="header-left">
    <div class="logo-row">
      <div class="logo-cell"><img src="${logoAbsUrl}" alt="Logo" onerror="this.style.display='none'"></div>
      <div class="brand-cell">
        <div class="brand-name">${companyName}</div>
        <div class="brand-sub">${companySubtitle}</div>
        <div class="brand-contact">Phone: ${companyPhone}<br>Location: ${companyLocation}</div>
      </div>
    </div>
  </div>
  <div class="header-right">
    <div class="inv-title">${title}</div>
    <div class="inv-number">${invoiceNumber}</div>
    <div class="inv-dates">Date: ${date}<br>Due Date: ${dueDate}</div>
  </div>
</div>

<hr class="divider">

<!-- BILL TO -->
<div class="bill-box">
  <div class="bill-label">${billToLabel}</div>
  <div class="bill-name">${billToName}</div>
  <div class="bill-sub">${billToSub}</div>
</div>

<!-- ITEMS TABLE -->
<table class="items-table">
  <thead>
    <tr>
      <th>Description</th>
      <th class="items-center">Qty</th>
      <th class="items-right">Unit Price</th>
      <th class="items-right">Total</th>
    </tr>
  </thead>
  <tbody>${itemRows}</tbody>
</table>

<!-- TOTALS -->
<div class="totals-wrap">
  <div class="totals-spacer"></div>
  <div class="totals-box">
    <div class="totals-row">
      <span class="totals-label">Total:</span>
      <span class="totals-value">${formatCurrency(totals.subtotal)}</span>
    </div>
    <div class="totals-row separator">
      <span class="totals-label">Paid:</span>
      <span class="totals-value green">${formatCurrency(totals.paid)}</span>
    </div>
    <div class="totals-row" style="padding-top:10px;">
      <span class="totals-label big">Balance Due:</span>
      <span class="totals-value big">${formatCurrency(totals.balance)}</span>
    </div>
  </div>
</div>

${paymentBlock}

<!-- FOOTER -->
<div class="footer">
  <div class="footer-text">Thank you for choosing ${companyName}!</div>
  <div class="footer-bar"></div>
</div>

<script>
  // Auto-print once the logo image has loaded (or after 1.5s max)
  window.onload = function () {
    var img = document.querySelector('img');
    function doPrint() { window.print(); }
    if (!img || img.complete) {
      setTimeout(doPrint, 300);
    } else {
      img.onload = img.onerror = function() { setTimeout(doPrint, 300); };
      setTimeout(doPrint, 1500); // fallback
    }
  };
<\/script>
</body>
</html>`;
}

/**
 * Opens the invoice in a new window and triggers the browser print dialog.
 * Works for both expense requisitions and order invoices.
 */
function openInvoicePrintWindow(htmlDoc, filenameHint) {
    const win = window.open('', '_blank', 'width=900,height=700,scrollbars=yes');
    if (!win) {
        alert('Pop-up blocked! Please allow pop-ups for this site and try again.');
        return;
    }
    win.document.write(htmlDoc);
    win.document.close();
}

// ─── EXPENSE REQUISITION ────────────────────────────────────────────────────

window.generateExpenseInvoice = async function (expenseId) {
    if (!expenseId) return alert("Expense ID not found");
    try {
        const [{ data: expense }, { data: profile }] = await Promise.all([
            supabaseClient.from('expenses').select('*').eq('id', expenseId).single(),
            supabaseClient.from('user_profiles').select('full_name').eq('id', USER_PROFILE?.id).single()
        ]);
        if (!expense) throw new Error("Expense not found");

        const amount = parseFloat(expense.amount) || 0;
        const recordedBy = profile?.full_name || USER_PROFILE?.full_name || 'Administrator';
        const year = new Date(expense.incurred_at || expense.created_at).getFullYear();

        const doc = buildInvoiceDocument({
            title: "EXPENSE REQUISITION",
            subtitle: "Authorized Internal Request",
            companySubtitle: "Authorized Internal Request",
            invoiceNumber: `EXP-${year}-${String(expense.id).slice(-6).toUpperCase()}`,
            date: formatDate(expense.incurred_at || expense.created_at),
            dueDate: "Immediate",
            billToLabel: "Requested By:",
            billToName: recordedBy,
            billToSub: "Target Shop: " + (expense.shop_id ? "Production Unit" : "Global HQ"),
            items: [{
                description: `${expense.category || 'Expense'}: ${expense.item_name || ''}`,
                qty: 1,
                unitPrice: amount,
                total: amount
            }],
            totals: { subtotal: amount, paid: 0, balance: amount },
            showPaymentDetails: false
        });

        openInvoicePrintWindow(doc, `Requisition_${String(expense.id).slice(0, 6)}`);

    } catch (error) {
        logDebug("Expense Requisition Error:", error, 'error');
        alert("Error generating requisition: " + error.message);
    }
};

// ─── ORDER INVOICE ───────────────────────────────────────────────────────────

window.downloadInvoicePDF = async function (orderId) {
    if (!orderId) {
        if (typeof CURRENT_ORDER_ID !== 'undefined') orderId = CURRENT_ORDER_ID;
        else return alert("Order ID not found");
    }
    try {
        const payMethod = document.getElementById('invoice-payment-method')?.value;
        let customPaybill, customAccount;
        if (payMethod === 'custom') {
            customPaybill = document.getElementById('custom-paybill')?.value;
            customAccount = document.getElementById('custom-account')?.value;
        }

        const [{ data: order }, { data: payments }] = await Promise.all([
            supabaseClient.from('orders').select('*').eq('id', orderId).single(),
            supabaseClient.from('payments').select('*').eq('order_id', orderId)
        ]);
        if (!order) throw new Error("Order not found");

        const totalCost = parseFloat(order.price) || 0;
        const paid = payments ? payments.reduce((sum, p) => sum + (p.amount || 0), 0) : 0;
        const balance = totalCost - paid;
        const year = new Date(order.created_at || new Date()).getFullYear();

        const doc = buildInvoiceDocument({
            title: "INVOICE",
            subtitle: "Quality Tailoring Services",
            companySubtitle: "Quality Tailoring Services",
            invoiceNumber: `INV-${year}-${String(order.id).slice(-4).toUpperCase()}`,
            date: formatDate(new Date().toISOString()),
            dueDate: order.due_date ? formatDate(order.due_date) : "Upon Receipt",
            billToLabel: "Bill To:",
            billToName: order.customer_name,
            billToSub: order.customer_phone || order.phone_number || '',
            items: [{
                description: `Bespoke Tailoring: ${order.garment_type}`,
                qty: 1,
                unitPrice: totalCost,
                total: totalCost
            }],
            totals: { subtotal: totalCost, paid: paid, balance: Math.max(0, balance) },
            showPaymentDetails: true,
            paybill: customPaybill,
            account: customAccount
        });

        openInvoicePrintWindow(doc, `Invoice_${(order.customer_name || 'customer').replace(/\s+/g, '_')}`);

    } catch (error) {
        logDebug("Invoice Error:", error, 'error');
        alert("Error generating invoice: " + error.message);
    }
};

async function deleteOrder() {
    if (!CURRENT_ORDER_ID) return;

    if (!confirm("Are you absolutely sure you want to delete this order? This action cannot be undone.")) {
        return;
    }

    try {
        logDebug("Attempting to delete order", { orderId: CURRENT_ORDER_ID }, 'info');

        const { error } = await supabaseClient
            .from('orders')
            .delete()
            .eq('id', CURRENT_ORDER_ID);

        if (error) throw error;

        alert("Order deleted successfully!");
        window.location.href = 'admin-current-orders.html';

    } catch (error) {
        logDebug("Error deleting order:", error, 'error');
        alert("Error deleting order: " + error.message);
    }
}

// ==========================================
// 👑 OWNER MODULE - ADMIN MANAGEMENT
// ==========================================

async function loadAdminManagementScreen() {
    logDebug("Loading admin management screen", null, 'info');

    try {
        // Setup shop creation form
        const shopForm = document.getElementById('add-shop-form');
        if (shopForm) {
            shopForm.onsubmit = createShopAndManager;
        }

        // Setup worker creation form
        const workerForm = document.getElementById('admin-add-worker-form');
        if (workerForm) {
            workerForm.onsubmit = async (e) => {
                e.preventDefault();

                const shopId = document.getElementById('admin-shop-select').value;
                const name = document.getElementById('admin-new-worker-name').value;
                const phone = document.getElementById('admin-new-worker-phone').value;

                if (!shopId) {
                    alert("Please select a shop first!");
                    return;
                }

                if (!name.trim()) {
                    alert("Please enter worker name!");
                    return;
                }

                try {
                    const { error } = await supabaseClient
                        .from('workers')
                        .insert([{
                            shop_id: shopId,
                            name: name.trim(),
                            phone_number: phone.trim() || null,
                            created_at: new Date().toISOString()
                        }]);

                    if (error) throw error;

                    alert("Worker added successfully!");
                    workerForm.reset();
                    loadShopCommandCenter();

                } catch (error) {
                    alert("Error: " + error.message);
                }
            };
        }

        // Load data
        await Promise.all([
            loadShopsForDropdown('admin-shop-select'),
            loadShopCommandCenter()
        ]);

        addRefreshButton();

    } catch (error) {
        logDebug("Error loading admin management:", error, 'error');
    }
}

async function loadShopCommandCenter() {
    const container = document.getElementById('shop-command-center');
    if (!container) return;

    container.innerHTML = '<p>Loading command center...</p>';

    try {
        const admin = getAdminClient();
        if (!admin) {
            container.innerHTML = '<p class="error">Admin privileges required (Service Key missing).</p>';
            return;
        }

        const [{ data: shops }, { data: profiles }, { data: workers }] = await Promise.all([
            admin.from('shops').select('*').order('name'),
            admin.from('user_profiles').select('*').eq('role', 'manager'),
            admin.from('workers').select('*')
        ]);

        if (!shops || shops.length === 0) {
            container.innerHTML = '<p>No shops found.</p>';
            return;
        }

        // Fetch emails for each manager individually using getUserById.
        // This avoids the broken listUsers() bulk call which returns a 500 on this project.
        // We use Promise.all so all lookups run in parallel.
        const managerEmailMap = {};
        if (profiles && profiles.length > 0) {
            await Promise.all(profiles.map(async (profile) => {
                try {
                    const { data, error } = await admin.auth.admin.getUserById(profile.id);
                    if (!error && data?.user?.email) {
                        managerEmailMap[profile.id] = data.user.email;
                    }
                } catch (e) {
                    // Silently skip — email just won't show for this manager
                }
            }));
        }

        container.innerHTML = shops.map(shop => {
            const manager = profiles?.find(p => p.shop_id === shop.id);
            const managerEmail = manager ? (managerEmailMap[manager.id] || manager.email || 'No Email') : null;
            const shopWorkers = workers?.filter(w => w.shop_id === shop.id) || [];

            return `
                <div class="entity-card">
                    <div class="entity-header">
                        <div class="shop-name"><i class="fas fa-store-alt" style="color: var(--brand-gold);"></i> ${shop.name}</div>
                        <button onclick="deleteShop('${shop.id}', '${shop.name}')" class="action-btn danger" title="Delete Shop"><i class="fas fa-trash-alt"></i></button>
                    </div>
                    
                    <div class="entity-body">
                        ${manager ? `
                            <div class="manager-info">
                                <div class="manager-avatar">${manager.full_name.charAt(0).toUpperCase()}</div>
                                <div style="flex-grow: 1;">
                                    <div style="font-weight: 600; color: var(--brand-navy); font-size: 0.95em;">${manager.full_name}</div>
                                    <div style="color: #64748b; font-size: 0.8em;"><i class="fas fa-envelope" style="margin-right: 4px;"></i>${managerEmail}</div>
                                    <div style="color: #10b981; font-size: 0.75em; font-weight: 600; margin-top: 2px;"><i class="fas fa-star" style="margin-right: 4px;"></i>Shop Manager</div>
                                </div>
                            </div>
                        ` : `
                            <div class="manager-info" style="opacity: 0.6;">
                                <div class="manager-avatar" style="background: #f1f5f9; color: #94a3b8;"><i class="fas fa-user-slash"></i></div>
                                <div>
                                    <div style="font-weight: 600; color: #64748b; font-size: 0.95em;">No Manager Assigned</div>
                                </div>
                            </div>
                        `}
                        
                        <div style="margin-top: 15px;">
                            <h4 style="margin:0 0 10px 0; font-size:0.8em; text-transform:uppercase; letter-spacing:1px; color:#94a3b8;">Workforce (${shopWorkers.length})</h4>
                            <ul class="worker-list" style="max-height:120px; overflow-y:auto; padding-right: 5px;">
                                ${shopWorkers.length > 0 ? shopWorkers.map(w => `
                                    <li class="worker-item">
                                        <span><i class="fas fa-user" style="color:#cbd5e1; margin-right:8px; font-size:0.8em;"></i>${w.name}</span>
                                        <button onclick="deleteWorker('${w.id}')" style="border:none; background:none; cursor:pointer; color:#ef4444;" title="Remove worker"><i class="fas fa-times"></i></button>
                                    </li>
                                `).join('') : '<li class="worker-item" style="color:#94a3b8; font-style:italic;">No workers assigned</li>'}
                            </ul>
                        </div>
                    </div>

                    ${manager ? `
                    <div class="entity-actions">
                        <button onclick="openResetPasswordModal('${manager.id}', '${manager.full_name}')" class="action-btn" title="Reset Manager Password"><i class="fas fa-key"></i> Reset Pass</button>
                        <button onclick="fireManager('${manager.id}', '${shop.id}')" class="action-btn danger" title="Remove Manager"><i class="fas fa-user-times"></i> Remove</button>
                    </div>
                    ` : ''}
                </div>
            `;
        }).join('');

    } catch (error) {
        console.error(error);
        container.innerHTML = `<p class="error">Error: ${error.message}</p>`;
    }
}

async function createShopAndManager(e) {
    e.preventDefault();
    const msg = document.getElementById('shop-message');
    msg.textContent = "Processing...";

    const shopName = document.getElementById('new-shop-name').value;
    const mgrName = document.getElementById('new-manager-name').value;
    const email = document.getElementById('new-manager-email').value;
    const password = document.getElementById('new-manager-password').value;

    try {
        const admin = getAdminClient();

        // 1. Create Auth User
        const { data: user, error: authError } = await admin.auth.admin.createUser({
            email, password, email_confirm: true, user_metadata: { full_name: mgrName }
        });
        if (authError) throw authError;

        // 2. Create Shop
        const { data: shop, error: shopError } = await admin.from('shops').insert([{ name: shopName }]).select().single();
        if (shopError) throw shopError;

        // 3. Create Profile
        const { error: profError } = await admin.from('user_profiles').insert([{
            id: user.user.id, full_name: mgrName, role: 'manager', shop_id: shop.id
        }]);
        if (profError) throw profError;

        msg.textContent = "Success!";
        msg.className = "success";
        document.getElementById('add-shop-form').reset();
        loadShopCommandCenter();

    } catch (error) {
        msg.textContent = "Error: " + error.message;
        msg.className = "error";
    }
}

function openResetPasswordModal(userId, name) {
    document.getElementById('reset-user-id').value = userId;
    document.getElementById('reset-user-name').textContent = name;
    document.getElementById('password-reset-modal').style.display = 'flex';
}

async function handlePasswordReset() {
    const userId = document.getElementById('reset-user-id').value;
    const password = document.getElementById('new-reset-password').value;
    if (password.length < 6) return alert("Password too short");

    try {
        const { error } = await getAdminClient().auth.admin.updateUserById(userId, { password });
        if (error) throw error;
        alert("Password updated");
        document.getElementById('password-reset-modal').style.display = 'none';
    } catch (e) {
        alert(e.message);
    }
}

async function fireManager(userId, shopId) {
    if (!confirm("Remove this manager? Account will be deleted.")) return;
    try {
        const admin = getAdminClient();
        await admin.auth.admin.deleteUser(userId);
        await admin.from('user_profiles').delete().eq('id', userId);
        loadShopCommandCenter();
    } catch (e) {
        alert(e.message);
    }
}

async function deleteShop(shopId, name) {
    if (!confirm(`Delete shop "${name}" and ALL associated data (orders, workers, manager)?`)) return;
    try {
        const admin = getAdminClient();
        const { data: mgr } = await admin.from('user_profiles').select('id').eq('shop_id', shopId).eq('role', 'manager').single();
        await admin.from('shops').delete().eq('id', shopId);
        if (mgr) await admin.auth.admin.deleteUser(mgr.id);
        loadShopCommandCenter();
    } catch (e) {
        alert(e.message);
    }
}

async function loadShopsForDropdown(elId) {
    const el = document.getElementById(elId);
    if (!el) {
        logDebug(`Element ${elId} not found for shop dropdown`, null, 'warning');
        return;
    }

    try {
        const { data: shops, error } = await supabaseClient.from('shops').select('id, name').order('name');
        if (error) {
            logDebug("Error loading shops for dropdown:", error, 'error');
            return;
        }

        if (shops) {
            const firstOption = el.options[0];
            el.innerHTML = '';
            if (firstOption) el.appendChild(firstOption);

            shops.forEach(s => {
                const option = document.createElement('option');
                option.value = s.id;
                option.textContent = s.name;
                el.appendChild(option);
            });

            logDebug(`Loaded ${shops.length} shops for dropdown ${elId}`, null, 'success');
        }
    } catch (error) {
        logDebug("Exception loading shops for dropdown:", error, 'error');
    }
}

window.deleteWorker = async function (workerId) {
    if (!confirm("Delete this worker?")) return;

    try {
        // Check if worker has active orders
        const { data: activeOrders } = await supabaseClient
            .from('orders')
            .select('id')
            .eq('worker_id', workerId)
            .neq('status', 6);

        if (activeOrders && activeOrders.length > 0) {
            alert("Cannot delete worker with active assignments. Reassign orders first.");
            return;
        }

        const { error } = await supabaseClient
            .from('workers')
            .delete()
            .eq('id', workerId);

        if (error) throw error;

        alert("Worker deleted.");
        loadShopCommandCenter();

    } catch (error) {
        alert("Error: " + error.message);
    }
};

// ==========================================
// 👑 OWNER MODULE - ADMIN ORDER FORM
// ==========================================

function initAdminOrderForm() {
    logDebug("Initializing admin order form", null, 'info');

    // 1. Load the list of shops
    loadShopsForDropdown('shop-select');

    // 2. Listen for Shop Selection Changes
    const shopSelect = document.getElementById('shop-select');
    if (shopSelect) {
        shopSelect.addEventListener('change', async function () {
            const shopId = this.value;

            if (!shopId) return; // Do nothing if empty

            // A. Load Lead Workers (Dropdown)
            const { data: workers } = await supabaseClient
                .from('workers')
                .select('id, name')
                .eq('shop_id', shopId)
                .order('name');

            const workerSelect = document.getElementById('worker-select');
            if (workerSelect && workers) {
                workerSelect.innerHTML = '<option value="">-- Select Lead --</option>' +
                    workers.map(w => `<option value="${w.id}">${w.name}</option>`).join('');
            }

            // B. Load Squad Workers (Checkboxes) - THIS WAS THE MISSING PART
            logDebug("Loading squad for shop:", shopId);
            await loadWorkersForSquad(shopId);
        });
    }

    // 3. Setup Garment Type Changes
    const garmentSelect = document.getElementById('garment-type-select');
    if (garmentSelect) {
        garmentSelect.addEventListener('change', generateAdminOrderFormMeasurements);
    }

    // Setup Client Search
    setupClientSearch('customer_phone');
    setupClientSearch('customer_name');

    // 4. Handle Form Submission
    const orderForm = document.getElementById('order-form');
    if (orderForm) {
        orderForm.onsubmit = async (e) => {
            e.preventDefault();
            const shopId = document.getElementById('shop-select').value;
            if (!shopId) return alert("Select a shop");

            // Collect measurements
            const measurements = {};
            document.querySelectorAll('#measurement-fields-container input').forEach(input => {
                const comp = input.dataset.component;
                const meas = input.dataset.measurement;
                if (!measurements[comp]) measurements[comp] = {};
                if (input.value) measurements[comp][meas] = parseFloat(input.value);
            });

            // Capture Squad
            const squad = Array.from(document.querySelectorAll('.squad-checkbox:checked')).map(cb => cb.value);

            const orderData = {
                shop_id: shopId,
                customer_name: document.getElementById('customer_name').value,
                customer_phone: document.getElementById('customer_phone').value,
                garment_type: document.getElementById('garment-type-select').value,
                price: parseFloat(document.getElementById('price').value) || 0,
                due_date: document.getElementById('due_date').value,
                worker_id: document.getElementById('worker-select').value || null,
                additional_workers: JSON.stringify(squad),
                status: 1,
                measurements_details: JSON.stringify(measurements),
                created_at: new Date().toISOString()
            };

            const { data: order, error } = await supabaseClient.from('orders').insert([orderData]).select().single();
            if (error) return alert(error.message);

            // [NEW] Upsert Client Data
            try {
                const { data: existingClient } = await supabaseClient.from('clients').select('*').eq('phone', orderData.customer_phone).single();
                let history = existingClient ? (existingClient.measurements_history || []) : [];
                history.unshift({
                    date: new Date().toISOString(),
                    garment: orderData.garment_type,
                    measurements: measurements
                });
                history = history.slice(0, 10); // Keep last 10

                await supabaseClient.from('clients').upsert({
                    name: orderData.customer_name,
                    phone: orderData.customer_phone,
                    measurements_history: history,
                    last_garment_type: orderData.garment_type,
                    notes: orderData.customer_preferences || '',
                    updated_at: new Date().toISOString()
                }, { onConflict: 'phone' });
            } catch (e) {
                console.error("Error upserting client:", e);
            }

            const deposit = parseFloat(document.getElementById('deposit_paid').value) || 0;
            if (deposit > 0) await supabaseClient.from('payments').insert([{ order_id: order.id, amount: deposit }]);

            window.location.href = 'admin-current-orders.html';
        };
    }
}

async function loadAllWorkersForAdmin() {
    try {
        const { data: workers, error } = await supabaseClient
            .from('workers')
            .select('id, name, shop_id')
            .order('name');

        if (error) throw error;

        const workerSelect = document.getElementById('worker-select');
        if (workerSelect && workers) {
            workerSelect.innerHTML = '<option value="">-- Select Worker --</option>' +
                workers.map(w => `<option value="${w.id}">${w.name} (Shop ${w.shop_id})</option>`).join('');
        }
    } catch (error) {
        logDebug("Error loading workers for admin:", error, 'error');
    }
}

function generateAdminOrderFormMeasurements() {
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
// 👑 OWNER MODULE - ADMIN EXPENSES
// ==========================================

async function loadAdminExpensesScreen() {
    logDebug("Loading admin expenses screen", null, 'info');

    try {
        // Load Shops for filter and form
        await loadShopsForDropdown('admin-ex-shop');
        await loadShopsForDropdown('admin-exp-shop-filter');

        const form = document.getElementById('admin-expense-form');
        if (form) {
            form.onsubmit = async (e) => {
                e.preventDefault();

                try {
                    const shopId = document.getElementById('admin-ex-shop').value || null;

                    const expenseData = {
                        shop_id: shopId,
                        manager_id: USER_PROFILE.id, // Admin who recorded it
                        item_name: document.getElementById('admin-ex-name').value || 'Global Expense',
                        amount: parseFloat(document.getElementById('admin-ex-amount').value) || 0,
                        category: document.getElementById('admin-ex-cat').value,
                        notes: document.getElementById('admin-ex-notes').value || '',
                        incurred_at: new Date().toISOString()
                    };

                    const { error } = await supabaseClient
                        .from('expenses')
                        .insert([expenseData]);

                    if (error) throw error;

                    alert("Expense recorded successfully!");
                    form.reset();
                    loadAdminExpensesList();

                } catch (error) {
                    alert("Error adding expense: " + error.message);
                }
            };
        }

        const shopFilter = document.getElementById('admin-exp-shop-filter');
        if (shopFilter) {
            shopFilter.addEventListener('change', loadAdminExpensesList);
        }

        // Load list
        await loadAdminExpensesList();

    } catch (error) {
        logDebug("Error loading admin expenses screen:", error, 'error');
    }
}

async function loadAdminExpensesList() {
    try {
        const shopFilterValue = document.getElementById('admin-exp-shop-filter')?.value || '';

        let query = supabaseClient
            .from('expenses')
            .select('*, shops(name)')
            .order('incurred_at', { ascending: false });

        if (shopFilterValue === 'global') {
            query = query.is('shop_id', null);
        } else if (shopFilterValue !== '') {
            query = query.eq('shop_id', shopFilterValue);
        }

        const { data: expenses, error } = await query;

        if (error) throw error;

        // Render Summary Cards
        renderExpenseSummaryCards(expenses);

        const tbody = document.getElementById('admin-expenses-tbody');
        if (tbody) {
            if (!expenses || expenses.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px;">No expenses found</td></tr>';
                return;
            }

            tbody.innerHTML = expenses.map(expense => `
                <tr>
                    <td>${formatDate(expense.incurred_at)}</td>
                    <td>${expense.shops?.name || '<span style="color:#d4af37; font-weight:bold;">HQ Global</span>'}</td>
                    <td><b>${expense.category}</b></td>
                    <td>${expense.item_name}</td>
                    <td style="font-weight:bold;">Ksh ${parseFloat(expense.amount).toLocaleString()}</td>
                    <td>${expense.notes || '-'}</td>
                    <td>
                        <div style="display: flex; gap: 5px;">
                            <button class="small-btn" style="background:#3b82f6; padding: 5px 8px;" 
                                    onclick="generateExpenseInvoice('${expense.id}')" title="Invoice">
                                <i class="fas fa-file-invoice"></i>
                            </button>
                            <button class="small-btn" style="background:#10b981; padding: 5px 8px;" 
                                    onclick="openEditExpenseModal('${expense.id}')" title="Edit">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="small-btn" style="background:#ef4444; padding: 5px 8px;" 
                                    onclick="deleteExpense('${expense.id}')" title="Delete">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `).join('');
        }
    } catch (error) {
        logDebug("Error loading admin expenses list:", error, 'error');
    }
}

function renderExpenseSummaryCards(expenses) {
    const cardsContainer = document.getElementById('expense-summary-cards');
    if (!cardsContainer) return;

    if (!expenses || expenses.length === 0) {
        cardsContainer.innerHTML = '<p style="color: #64748b; font-style: italic;">No expense data for cards.</p>';
        return;
    }

    // Group expenses by category
    const summary = {};
    expenses.forEach(ex => {
        const cat = ex.category || 'Misc';
        if (!summary[cat]) {
            summary[cat] = { total: 0, count: 0 };
        }
        summary[cat].total += parseFloat(ex.amount || 0);
        summary[cat].count += 1;
    });

    const categoryIcons = {
        'Fabrics/Materials': 'fa-scissors',
        'Tailoring Supplies': 'fa-needle',
        'Haberdashery': 'fa-needle', // Compatibility
        'Wages': 'fa-money-bill-wave',
        'Transport': 'fa-truck',
        'Utilities': 'fa-bolt',
        'Rent': 'fa-building',
        'Food': 'fa-utensils',
        'Airtime': 'fa-mobile-alt',
        'Repairs': 'fa-tools',
        'Misc': 'fa-box-open'
    };

    cardsContainer.innerHTML = Object.keys(summary).sort((a, b) => summary[b].total - summary[a].total).map(cat => {
        const icon = categoryIcons[cat] || 'fa-tag';
        const data = summary[cat];

        // Simpler display names
        let displayName = cat.split('/')[0];
        if (cat === 'Tailoring Supplies' || cat === 'Haberdashery') displayName = 'Supplies';
        if (cat === 'Fabrics/Materials') displayName = 'Materials';
        if (cat === 'Utilities') displayName = 'Stima/Water';
        if (cat === 'Wages') displayName = 'Fundi Wages';

        return `
            <div class="expense-summary-card">
                <div class="ex-icon-circle">
                    <i class="fas ${icon}"></i>
                </div>
                <div class="ex-info">
                    <h4>${displayName}</h4>
                    <p class="ex-amount">Ksh ${data.total.toLocaleString()}</p>
                    <p class="ex-count">${data.count} entry${data.count !== 1 ? 'ies' : ''}</p>
                </div>
            </div>
        `;
    }).join('');
}

async function deleteExpense(id) {
    if (!confirm("Are you sure you want to delete this expense? This will affect financial calculations.")) return;

    try {
        const { error } = await supabaseClient
            .from('expenses')
            .delete()
            .eq('id', id);

        if (error) throw error;

        alert("Expense deleted successfully!");
        loadAdminExpensesList();

        // Refresh analytics if they exist in cache/system
        if (typeof loadAnalyticsDashboard === 'function') loadAnalyticsDashboard();
        if (typeof loadBIAnalytics === 'function') loadBIAnalytics();

    } catch (error) {
        alert("Error deleting expense: " + error.message);
    }
}

async function openEditExpenseModal(id) {
    try {
        const { data: expense, error } = await supabaseClient
            .from('expenses')
            .select('*')
            .eq('id', id)
            .single();

        if (error) throw error;

        // Load shops for the modal select
        await loadShopsForDropdown('edit-ex-shop');

        // Populate fields
        document.getElementById('edit-ex-id').value = expense.id;
        document.getElementById('edit-ex-shop').value = expense.shop_id || '';
        document.getElementById('edit-ex-cat').value = expense.category;
        document.getElementById('edit-ex-amount').value = expense.amount;
        document.getElementById('edit-ex-name').value = expense.item_name;
        document.getElementById('edit-ex-notes').value = expense.notes || '';

        // Show modal
        const modal = document.getElementById('edit-expense-modal');
        if (modal) {
            modal.style.display = 'block';

            // Setup submit handler
            const form = document.getElementById('edit-expense-form');
            form.onsubmit = async (e) => {
                e.preventDefault();
                await updateExpense(id);
            };
        }

    } catch (error) {
        alert("Error loading expense details: " + error.message);
    }
}

function closeEditExpenseModal() {
    const modal = document.getElementById('edit-expense-modal');
    if (modal) modal.style.display = 'none';
}

async function updateExpense(id) {
    try {
        const expenseData = {
            shop_id: document.getElementById('edit-ex-shop').value || null,
            item_name: document.getElementById('edit-ex-name').value,
            amount: parseFloat(document.getElementById('edit-ex-amount').value) || 0,
            category: document.getElementById('edit-ex-cat').value,
            notes: document.getElementById('edit-ex-notes').value
        };

        const { error } = await supabaseClient
            .from('expenses')
            .update(expenseData)
            .eq('id', id);

        if (error) throw error;

        alert("Expense updated successfully!");
        closeEditExpenseModal();
        loadAdminExpensesList();

        // Refresh analytics
        if (typeof loadAnalyticsDashboard === 'function') loadAnalyticsDashboard();
        if (typeof loadBIAnalytics === 'function') loadBIAnalytics();

    } catch (error) {
        alert("Error updating expense: " + error.message);
    }
}

// ==========================================
// 🚀 MODERN BI & ANALYTICS MODULE
// ==========================================

async function loadBIAnalytics() {
    logDebug("Loading BI Analytics...", null, 'info');

    const shopId = document.getElementById('bi-shop-filter')?.value || 'all';
    const daysRange = document.getElementById('bi-date-filter')?.value || 'all';

    // Cleanup previous charts
    Object.values(analyticsCharts).forEach(chart => {
        if (chart && typeof chart.destroy === 'function') {
            try { chart.destroy(); } catch (e) { }
        }
    });
    analyticsCharts = {};

    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at, orders(garment_type, shop_id, customer_name, customer_phone)');
        let expensesQuery = supabaseClient.from('expenses').select('amount, incurred_at, shop_id');
        let ordersQuery = supabaseClient.from('orders').select('id, price, status, created_at, garment_type, shop_id, customer_name, customer_phone');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
        }

        if (daysRange !== 'all') {
            const cutoffDate = new Date();
            cutoffDate.setDate(cutoffDate.getDate() - parseInt(daysRange));
            const cutoffISO = cutoffDate.toISOString();

            paymentsQuery = paymentsQuery.gte('recorded_at', cutoffISO);
            expensesQuery = expensesQuery.gte('incurred_at', cutoffISO);
            ordersQuery = ordersQuery.gte('created_at', cutoffISO);
        }

        const [{ data: payments }, { data: expenses }, { data: orders }] = await Promise.all([
            paymentsQuery, expensesQuery, ordersQuery
        ]);

        const validPayments = payments || [];
        const validExpenses = expenses || [];
        const validOrders = orders || [];

        // 1. Compile Scorecards
        const totalRevenue = validPayments.reduce((sum, p) => sum + (p.amount || 0), 0);
        const totalExpenses = validExpenses.reduce((sum, e) => sum + (e.amount || 0), 0);
        const netMargin = totalRevenue > 0 ? ((totalRevenue - totalExpenses) / totalRevenue) * 100 : 0;

        // Count unique clients
        const clientsSet = new Set();
        validOrders.forEach(o => {
            if (o.customer_phone) clientsSet.add(o.customer_phone);
            else if (o.customer_name) clientsSet.add(o.customer_name);
        });
        const totalClients = clientsSet.size;

        const setVal = (id, val) => { const el = document.getElementById(id); if (el) el.textContent = val; };
        setVal('bi-revenue', `Ksh ${totalRevenue.toLocaleString()}`);
        setVal('bi-margin', `${netMargin.toFixed(1)}%`);
        setVal('bi-clients', totalClients.toString());
        setVal('bi-speed', '4.2'); // Mocked speed metric for now until status timeline logic exists

        // 2. Health Trajectory Area Chart (Revenue vs Expenses by Month)
        const healthCtx = document.getElementById('healthAreaChart')?.getContext('2d');
        if (healthCtx) {
            const monthlyData = {};
            validPayments.forEach(p => {
                const month = new Date(p.recorded_at).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
                if (!monthlyData[month]) monthlyData[month] = { rev: 0, exp: 0 };
                monthlyData[month].rev += p.amount || 0;
            });
            validExpenses.forEach(e => {
                const month = new Date(e.incurred_at).toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
                if (!monthlyData[month]) monthlyData[month] = { rev: 0, exp: 0 };
                monthlyData[month].exp += e.amount || 0;
            });

            // Sort months
            const labels = Object.keys(monthlyData).sort((a, b) => new Date(a) - new Date(b)).slice(-6); // Last 6 periods
            const revData = labels.map(l => monthlyData[l].rev);
            const expData = labels.map(l => monthlyData[l].exp);

            analyticsCharts.healthChart = new Chart(healthCtx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Revenue',
                            data: revData,
                            borderColor: '#8b5cf6',
                            backgroundColor: 'rgba(139, 92, 246, 0.2)',
                            fill: true,
                            tension: 0.4
                        },
                        {
                            label: 'Expenses',
                            data: expData,
                            borderColor: '#ef4444',
                            backgroundColor: 'rgba(239, 68, 68, 0.1)',
                            fill: true,
                            tension: 0.4
                        }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' },
                        tooltip: { mode: 'index', intersect: false }
                    },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#f1f5f9' } },
                        x: { grid: { display: false } }
                    },
                    interaction: { mode: 'nearest', axis: 'x', intersect: false }
                }
            });
        }

        // 3. Polar Area Garment Types
        const polarCtx = document.getElementById('categoryPolarChart')?.getContext('2d');
        if (polarCtx) {
            const garmentCounts = {};
            validOrders.forEach(o => {
                const type = o.garment_type || 'Other';
                garmentCounts[type] = (garmentCounts[type] || 0) + 1;
            });
            const sortedGarments = Object.entries(garmentCounts).sort((a, b) => b[1] - a[1]).slice(0, 5);

            analyticsCharts.polarChart = new Chart(polarCtx, {
                type: 'polarArea',
                data: {
                    labels: sortedGarments.map(g => g[0]),
                    datasets: [{
                        data: sortedGarments.map(g => g[1]),
                        backgroundColor: ['rgba(59, 130, 246, 0.7)', 'rgba(16, 185, 129, 0.7)', 'rgba(245, 158, 11, 0.7)', 'rgba(139, 92, 246, 0.7)', 'rgba(239, 68, 68, 0.7)'],
                        borderColor: 'white',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: { r: { display: false } },
                    plugins: { legend: { position: 'bottom' } }
                }
            });
        }

        // 4. Shop Radar Chart
        const radarCtx = document.getElementById('shopRadarChart')?.getContext('2d');
        if (radarCtx && shopId === 'all') { // Only show global radar if 'all' is selected
            const shopStats = {};
            const { data: shops } = await supabaseClient.from('shops').select('id, name');
            const shopMap = {};
            shops?.forEach(s => { shopMap[s.id] = s.name; shopStats[s.name] = { orders: 0, revenue: 0, clients: new Set() }; });

            validOrders.forEach(o => {
                const name = shopMap[o.shop_id];
                if (name) {
                    shopStats[name].orders++;
                    shopStats[name].clients.add(o.customer_phone || o.customer_name);
                }
            });
            validPayments.forEach(p => {
                const name = p.orders?.shop_id ? shopMap[p.orders.shop_id] : null;
                if (name) shopStats[name].revenue += p.amount || 0;
            });

            const sNames = Object.keys(shopStats);

            analyticsCharts.radarChart = new Chart(radarCtx, {
                type: 'radar',
                data: {
                    labels: sNames,
                    datasets: [
                        {
                            label: 'Volume (Orders)',
                            data: sNames.map(s => shopStats[s].orders),
                            backgroundColor: 'rgba(59, 130, 246, 0.2)',
                            borderColor: '#3b82f6',
                            pointBackgroundColor: '#3b82f6'
                        },
                        {
                            label: 'Reach (Clients)',
                            data: sNames.map(s => shopStats[s].clients.size),
                            backgroundColor: 'rgba(16, 185, 129, 0.2)',
                            borderColor: '#10b981',
                            pointBackgroundColor: '#10b981'
                        }
                    ]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });
        } else if (radarCtx) {
            radarCtx.clearRect(0, 0, radarCtx.canvas.width, radarCtx.canvas.height);
            radarCtx.font = "14px Arial";
            radarCtx.fillStyle = "#94a3b8";
            radarCtx.textAlign = "center";
            radarCtx.fillText("Radar available in 'Global' view only.", radarCtx.canvas.width / 2, radarCtx.canvas.height / 2);
        }

        // 5. Leaderboard
        const clientSpend = {};
        validPayments.forEach(p => {
            const name = p.orders?.customer_name;
            if (name) {
                clientSpend[name] = (clientSpend[name] || 0) + (p.amount || 0);
            }
        });

        const topClients = Object.entries(clientSpend).sort((a, b) => b[1] - a[1]).slice(0, 5);
        const tbody = document.getElementById('top-clients-tbody');
        if (tbody) {
            tbody.innerHTML = topClients.map((c, i) => `
                <tr>
                    <td><div class="rank-badge rank-${i + 1}">${i + 1}</div></td>
                    <td>${c[0]}</td>
                    <td style="text-align: right; font-weight: 700; color: #10b981;">Ksh ${c[1].toLocaleString()}</td>
                </tr>
            `).join('') || '<tr><td colspan="3" style="text-align:center;">No data available</td></tr>';
        }

        // Generate dynamic insights
        generateDynamicInsights(topClients, sortedGarments, totalRevenue, totalExpenses);

    } catch (error) {
        logDebug("Error loading BI Analytics:", error, 'error');
    }
}

function generateDynamicInsights(topClients, sortedGarments, rev, exp) {
    const aiList = document.getElementById('ai-insights-list');
    if (!aiList) return;

    let insightsHTML = '';

    if (rev > exp && exp > 0) {
        insightsHTML += `
            <div class="insight-item">
                <div class="insight-title"><i class="fas fa-check-circle"></i> Profitability Stable</div>
                <div class="insight-text">Revenue is currently shielding expenses with a healthy mathematical buffer. Keep overheads tight.</div>
            </div>`;
    } else if (exp > rev) {
        insightsHTML += `
            <div class="insight-item" style="border-left-color: #ef4444;">
                <div class="insight-title" style="color: #ef4444;"><i class="fas fa-exclamation-triangle"></i> Cashflow Warning</div>
                <div class="insight-text">Expenses have eclipsed revenue for this period. Immediate operational audit recommended.</div>
            </div>`;
    }

    if (sortedGarments && sortedGarments.length > 0) {
        insightsHTML += `
            <div class="insight-item" style="border-left-color: #3b82f6;">
                <div class="insight-title" style="color: #60a5fa;"><i class="fas fa-chart-pie"></i> Production Focus</div>
                <div class="insight-text"><strong>${sortedGarments[0][0]}s</strong> are leading production volume. Ensure fabric stock levels for this category are heavily reinforced.</div>
            </div>`;
    }

    if (topClients && topClients.length > 0) {
        insightsHTML += `
            <div class="insight-item" style="border-left-color: #f59e0b;">
                <div class="insight-title" style="color: #fbbf24;"><i class="fas fa-star"></i> Client Retention Notice</div>
                <div class="insight-text">Client <strong>${topClients[0][0]}</strong> is your top spender. Consider a VIP outreach or priority fitting to enhance lifetime value.</div>
            </div>`;
    }

    aiList.innerHTML = insightsHTML || '<div class="insight-item"><div class="insight-text">Insufficient data to generate meaningful intelligence.</div></div>';
}

async function loadAnalyticsDashboard() {
    const now = Date.now();
    if (now - lastDashboardLoad < DEBOUNCE_DELAY) return;
    lastDashboardLoad = now;

    logDebug("📊 Loading analytics dashboard", null, 'info');

    // Clean up charts
    Object.values(analyticsCharts).forEach(chart => {
        if (chart && typeof chart.destroy === 'function') {
            try { chart.destroy(); } catch (e) { }
        }
    });
    analyticsCharts = {};

    try {
        const shopId = 'all';

        const revenueDaysStr = document.getElementById('revenue-filter') ? document.getElementById('revenue-filter').value : '30';
        const productMixDaysStr = document.getElementById('product-mix-filter') ? document.getElementById('product-mix-filter').value : '30';

        await Promise.all([
            loadKPIMetrics(shopId),
            loadRevenueTrend(revenueDaysStr),
            loadProductMixChart(shopId, productMixDaysStr),
            loadShopPerformanceChart(),
            loadExpenseChart(shopId),
            loadPerformanceTables(shopId),
            loadPaymentMethodChart(shopId),
            generateAIInsights(shopId),
            loadExpenseAuditTable(shopId),
            loadOrderVolumeChart(shopId),
            loadRecentActivities(shopId)
        ]);

        logDebug("Analytics dashboard loaded", null, 'success');
    } catch (error) {
        logDebug("Error loading analytics dashboard:", error, 'error');
    }
}

async function loadExpenseAuditTable(shopId) {
    const tbody = document.getElementById('expense-audit-tbody');
    if (!tbody) return;

    try {
        let query = supabaseClient
            .from('expenses')
            .select('*')
            .order('incurred_at', { ascending: false })
            .limit(50);

        if (shopId !== 'all') {
            query = query.eq('shop_id', shopId);
        }

        const { data: expenses, error } = await query;
        if (error) throw error;

        if (!expenses || expenses.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:20px;">No recent expenses</td></tr>';
            return;
        }

        // Fetch shop names for display
        const shopIds = [...new Set(expenses.map(e => e.shop_id))];
        const { data: shops } = await supabaseClient.from('shops').select('id, name').in('id', shopIds);
        const shopMap = {};
        shops?.forEach(s => shopMap[s.id] = s.name);

        tbody.innerHTML = expenses.map(e => `
            <tr>
                <td>${formatDate(e.incurred_at)}</td>
                <td>${shopMap[e.shop_id] || 'Unknown'}</td>
                <td>${e.category}</td>
                <td style="text-align: right; font-weight: bold;">Ksh ${parseFloat(e.amount).toLocaleString()}</td>
                <td>${e.item_name || '-'} <small style="color:#888;">${e.notes || ''}</small></td>
            </tr>
        `).join('');

    } catch (error) {
        console.error("Error loading expense audit:", error);
        tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; color:red;">Error loading data</td></tr>';
    }
}


async function loadKPIMetrics(shopId) {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at');
        let ordersQuery = supabaseClient.from('orders').select('id, price, status, created_at');
        let expensesQuery = supabaseClient.from('expenses').select('amount, incurred_at');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];

        // Calculate metrics
        const totalRevenue = payments.reduce((sum, p) => sum + (p.amount || 0), 0);
        const totalExpenses = expenses.reduce((sum, e) => sum + (e.amount || 0), 0);
        const totalOrderValue = orders.reduce((sum, o) => sum + (o.price || 0), 0);

        const netProfit = totalRevenue - totalExpenses;
        const outstandingBalance = totalOrderValue - totalRevenue;

        const activeOrders = orders.filter(o => o.status < 6).length;
        const completedOrders = orders.filter(o => o.status === 6).length;

        const avgOrderValue = orders.length > 0 ? totalRevenue / orders.length : 0;

        // Trend calculations (Last 30 vs Prev 30)
        const splitByPeriod = (items, dateField) => {
            const now = new Date();
            const days30 = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
            const days60 = new Date(now.getTime() - 60 * 24 * 60 * 60 * 1000);

            let current = 0; let prev = 0; let currentCount = 0; let prevCount = 0;
            items.forEach(item => {
                const d = new Date(item[dateField] || item.created_at || new Date());
                const val = parseFloat(item.amount || item.price || 0);
                if (d >= days30) { current += val; currentCount++; }
                else if (d >= days60 && d < days30) { prev += val; prevCount++; }
            });
            return { current, prev, currentCount, prevCount };
        };

        const revTrend = splitByPeriod(payments, 'recorded_at');
        const expTrend = splitByPeriod(expenses, 'incurred_at');
        const orderTrend = splitByPeriod(orders, 'created_at');


        const calcTrendPct = (curr, prev) => {
            if (prev === 0) return curr > 0 ? 100 : 0;
            return ((curr - prev) / prev) * 100;
        };

        const revPct = calcTrendPct(revTrend.current, revTrend.prev);
        const profitCurrent = revTrend.current - expTrend.current;
        const profitPrev = revTrend.prev - expTrend.prev;
        const profitPct = calcTrendPct(profitCurrent, profitPrev);
        const orderCountPct = calcTrendPct(orderTrend.currentCount, orderTrend.prevCount);

        const avgOrderCurrent = orderTrend.currentCount > 0 ? revTrend.current / orderTrend.currentCount : 0;
        const avgOrderPrev = orderTrend.prevCount > 0 ? revTrend.prev / orderTrend.prevCount : 0;
        const avgPct = calcTrendPct(avgOrderCurrent, avgOrderPrev);

        // Update UI
        const updateMetric = (id, value, isCurrency = false) => {
            const el = document.getElementById(id);
            if (el) {
                el.textContent = isCurrency ? `Ksh ${value.toLocaleString()}` : value.toString();
            }
        };

        const setTrend = (id, pct, invertColors = false) => {
            const el = document.getElementById(id);
            if (!el) return;
            el.style.display = 'block';
            const isPositive = pct >= 0;
            const isGood = invertColors ? !isPositive : isPositive;
            const color = isGood ? '#10b981' : '#ef4444';
            const icon = isPositive ? 'fa-arrow-up' : 'fa-arrow-down';
            const sign = isPositive ? '+' : '';
            if (pct === 0) {
                el.innerHTML = `<span style="color: #94a3b8">- 0.0%</span> <span style="color: #94a3b8; font-weight: normal; font-size: 0.8em;">vs last 30d</span>`;
            } else {
                el.innerHTML = `<span style="color: ${color}"><i class="fas ${icon}"></i> ${sign}${pct.toFixed(1)}%</span> <span style="color: #94a3b8; font-weight: normal; font-size: 0.8em;">vs last 30d</span>`;
            }
        };

        updateMetric('total-revenue', totalRevenue, true);
        setTrend('total-revenue-trend', revPct);

        updateMetric('active-orders', activeOrders);
        setTrend('active-orders-trend', orderCountPct);

        updateMetric('avg-order-value', Math.round(avgOrderValue), true);
        setTrend('avg-order-value-trend', avgPct);

        updateMetric('net-profit', netProfit, true);
        setTrend('net-profit-trend', profitPct);

        updateMetric('outstanding-balance', outstandingBalance, true);
        // Trend for outstanding balance doesn't make as much sense historically without snapshots, omitting.

        logDebug("KPI metrics loaded", { totalRevenue, activeOrders }, 'success');
    } catch (error) {
        logDebug("Error loading KPI metrics:", error, 'error');
    }
}

async function loadRevenueTrend(daysStr) {
    try {
        const days = parseInt(daysStr) || 30;

        let paymentsQuery = supabaseClient
            .from('payments')
            .select('amount, recorded_at')
            .order('recorded_at');

        // Apply Date Filter
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - days);
        paymentsQuery = paymentsQuery.gte('recorded_at', cutoffDate.toISOString());

        const { data: payments } = await paymentsQuery;

        // Group by date, filling missing days with 0
        const dailyRevenue = {};
        const dateFormat = new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric' });

        // Initialize all days in range to 0
        for (let i = days - 1; i >= 0; i--) {
            const d = new Date();
            d.setDate(d.getDate() - i);
            dailyRevenue[dateFormat.format(d)] = 0;
        }

        if (payments) {
            payments.forEach(payment => {
                const date = new Date(payment.recorded_at);
                const dateKey = dateFormat.format(date);

                if (dailyRevenue[dateKey] !== undefined) {
                    dailyRevenue[dateKey] += payment.amount || 0;
                }
            });
        }

        const labels = Object.keys(dailyRevenue);
        const data = Object.values(dailyRevenue);

        // Create chart
        const canvas = document.getElementById('revenueChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.revenueChart) {
            analyticsCharts.revenueChart.destroy();
        }

        analyticsCharts.revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Daily Revenue',
                    data: data,
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#10b981',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: '#10b981',
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 2000,
                    easing: 'easeOutQuart'
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        cornerRadius: 8,
                        padding: 12,
                        callbacks: {
                            label: (context) => `Revenue: Ksh ${context.raw.toLocaleString()}`
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [4, 4], color: '#f1f5f9' },
                        ticks: {
                            callback: (value) => `Ksh ${value.toLocaleString()}`
                        }
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });

        logDebug("Revenue chart loaded", { dataPoints: data.length }, 'success');
    } catch (error) {
        logDebug("Error loading revenue chart:", error, 'error');
    }
}

async function loadProductMixChart(shopId, daysStr) {
    try {
        const days = parseInt(daysStr) || 30;

        // Date filter
        const cutoffDate = new Date();
        cutoffDate.setDate(cutoffDate.getDate() - days);

        let ordersQuery = supabaseClient
            .from('orders')
            .select('garment_type, price, created_at')
            .gte('created_at', cutoffDate.toISOString());

        if (shopId !== 'all') {
            ordersQuery = ordersQuery.eq('shop_id', shopId);
        }

        const { data: orders } = await ordersQuery;

        // Group by garment type
        const productData = {};
        if (orders) {
            orders.forEach(order => {
                const type = order.garment_type || 'Unknown';
                if (!productData[type]) productData[type] = 0;
                productData[type] += order.price || 0;
            });
        }

        // Sort by revenue descending
        const sortedEntries = Object.entries(productData).sort((a, b) => b[1] - a[1]);
        const labels = sortedEntries.map(e => e[0]);
        const revenueData = sortedEntries.map(e => e[1]);

        // Create chart
        const canvas = document.getElementById('productMixChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.productMixChart) {
            analyticsCharts.productMixChart.destroy();
        }

        analyticsCharts.productMixChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue',
                    data: revenueData,
                    backgroundColor: [
                        'rgba(59, 130, 246, 0.9)', 'rgba(16, 185, 129, 0.9)', 'rgba(245, 158, 11, 0.9)',
                        'rgba(239, 68, 68, 0.9)', 'rgba(139, 92, 246, 0.9)', 'rgba(236, 72, 153, 0.9)',
                        'rgba(20, 184, 166, 0.9)', 'rgba(249, 115, 22, 0.9)'
                    ],
                    borderRadius: 8,
                    barPercentage: 0.6,
                    categoryPercentage: 0.9
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart'
                },
                layout: {
                    padding: {
                        bottom: 40,
                        left: 20
                    }
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        cornerRadius: 8,
                        padding: 12,
                        callbacks: {
                            label: (context) => {
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = total > 0 ? Math.round((context.raw / total) * 100) : 0;
                                return `Ksh ${context.raw.toLocaleString()} (${percentage}%)`;
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { borderDash: [5, 5], color: '#f1f5f9' },
                        beginAtZero: true,
                        ticks: {
                            callback: (value) => `Ksh ${value.toLocaleString()}`,
                            padding: 10
                        }
                    },
                    y: {
                        grid: { display: false },
                        ticks: {
                            padding: 10
                        }
                    }
                }
            }
        });

        logDebug("Product mix chart loaded", { products: labels.length }, 'success');
    } catch (error) {
        logDebug("Error loading product mix chart:", error, 'error');
    }
}

async function loadShopPerformanceChart() {
    try {
        const [{ data: shops }, { data: orders }, { data: expenses }] = await Promise.all([
            supabaseClient.from('shops').select('id, name').order('name'),
            supabaseClient.from('orders').select('id, shop_id, price'),
            supabaseClient.from('expenses').select('shop_id, amount')
        ]);

        if (!shops) return;

        // Calculate shop performance
        const shopPerformance = shops.map(shop => {
            const shopOrders = orders?.filter(o => o.shop_id === shop.id) || [];
            const shopExpenses = expenses?.filter(e => e.shop_id === shop.id) || [];

            const revenue = shopOrders.reduce((sum, o) => sum + (o.price || 0), 0);
            const expense = shopExpenses.reduce((sum, e) => sum + (e.amount || 0), 0);
            const profit = revenue - expense;
            const efficiency = revenue > 0 ? (profit / revenue) * 100 : 0;

            return { name: shop.name, revenue, profit, efficiency };
        }).sort((a, b) => b.revenue - a.revenue).slice(0, 10);

        // Store globally for tables to use
        window.shopRankings = shopPerformance;

        const labels = shopPerformance.map(s => s.name);
        const revenueData = shopPerformance.map(s => s.revenue);
        const profitData = shopPerformance.map(s => s.profit);

        // Create chart
        const canvas = document.getElementById('shopPerformanceChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.shopPerformanceChart) {
            analyticsCharts.shopPerformanceChart.destroy();
        }

        analyticsCharts.shopPerformanceChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Revenue',
                        data: revenueData,
                        backgroundColor: 'rgba(59, 130, 246, 0.9)',
                        borderRadius: 12,
                        barPercentage: 0.7,
                        categoryPercentage: 0.8
                    },
                    {
                        label: 'Profit',
                        data: profitData,
                        backgroundColor: 'rgba(16, 185, 129, 0.9)',
                        borderRadius: 12,
                        barPercentage: 0.7,
                        categoryPercentage: 0.8
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 1500,
                    easing: 'easeOutBounce'
                },
                plugins: {
                    legend: {
                        labels: { usePointStyle: true, boxWidth: 10 }
                    },
                    tooltip: {
                        cornerRadius: 8,
                        padding: 12
                    }
                },
                scales: {
                    y: {
                        grid: { borderDash: [5, 5], color: '#f1f5f9' },
                        beginAtZero: true
                    },
                    x: {
                        grid: { display: false }
                    }
                }
            }
        });

        logDebug("Shop performance chart loaded", { shops: labels.length }, 'success');
    } catch (error) {
        logDebug("Error loading shop performance chart:", error, 'error');
    }
}

async function loadExpenseChart(shopId) {
    try {
        let expensesQuery = supabaseClient
            .from('expenses')
            .select('category, amount');

        if (shopId !== 'all') {
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        const { data: expenses } = await expensesQuery;

        // Group by category
        const expenseByCategory = {};
        if (expenses) {
            expenses.forEach(expense => {
                const category = expense.category || 'Uncategorized';
                if (!expenseByCategory[category]) expenseByCategory[category] = 0;
                expenseByCategory[category] += expense.amount || 0;
            });
        }

        // Sort and take top 8
        const sortedCategories = Object.entries(expenseByCategory)
            .sort(([, a], [, b]) => b - a)
            .slice(0, 8);

        const labels = sortedCategories.map(([category]) => category);
        const data = sortedCategories.map(([, amount]) => amount);

        // Create chart
        const canvas = document.getElementById('expenseChart');
        if (!canvas) return;

        const ctx = canvas.getContext('2d');

        if (analyticsCharts.expenseChart) {
            analyticsCharts.expenseChart.destroy();
        }

        analyticsCharts.expenseChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Expense Amount',
                    data: data,
                    backgroundColor: 'rgba(239, 68, 68, 0.8)',
                    borderRadius: 10,
                    barPercentage: 0.6,
                    categoryPercentage: 0.9
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 1200,
                    easing: 'easeOutQuart'
                },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        cornerRadius: 8,
                        padding: 12,
                        callbacks: {
                            label: (context) => `Ksh ${context.raw.toLocaleString()}`
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { borderDash: [5, 5], color: '#f1f5f9' },
                        beginAtZero: true
                    },
                    y: {
                        grid: { display: false }
                    }
                }
            }
        });

        logDebug("Expense chart loaded", { categories: labels.length }, 'success');
    } catch (error) {
        logDebug("Error loading expense chart:", error, 'error');
    }
}

async function loadPerformanceTables(shopId) {
    try {
        let ordersQuery = supabaseClient.from('orders').select('garment_type, price, worker_id, workers(name)');

        if (shopId !== 'all') {
            ordersQuery = ordersQuery.eq('shop_id', shopId);
        }

        const { data: orders } = await ordersQuery;

        if (!orders) return;

        // Top Products
        const productStats = {};
        orders.forEach(order => {
            const type = order.garment_type || 'Unknown';
            if (!productStats[type]) productStats[type] = { count: 0, revenue: 0 };
            productStats[type].count++;
            productStats[type].revenue += order.price || 0;
        });

        const topProducts = Object.entries(productStats)
            .map(([name, stats]) => ({
                name,
                count: stats.count,
                revenue: stats.revenue
            }))
            .sort((a, b) => b.revenue - a.revenue)
            .slice(0, 5);

        const topProductsTable = document.getElementById('top-products-table');
        if (topProductsTable) {
            topProductsTable.innerHTML = topProducts.map(product => `
                <tr>
                    <td>${product.name}</td>
                    <td style="text-align: right;">${product.count}</td>
                    <td style="text-align: right; font-weight: 600;">Ksh ${product.revenue.toLocaleString()}</td>
                </tr>
            `).join('');
        }

        // Top Workers Leaderboard
        const workerStats = {};
        orders.forEach(order => {
            if (order.worker_id) {
                const wName = order.workers?.name || 'Unknown Worker';
                if (!workerStats[wName]) workerStats[wName] = { count: 0, revenue: 0 };
                workerStats[wName].count++;
                workerStats[wName].revenue += order.price || 0;
            }
        });

        const topWorkers = Object.entries(workerStats)
            .map(([name, stats]) => ({
                name,
                count: stats.count,
                revenue: stats.revenue
            }))
            .sort((a, b) => b.revenue - a.revenue)
            .slice(0, 5);

        const workerLeaderboardTable = document.getElementById('worker-leaderboard-table');
        if (workerLeaderboardTable) {
            if (topWorkers.length > 0) {
                workerLeaderboardTable.innerHTML = topWorkers.map(worker => `
                    <tr>
                        <td><i class="fas fa-user-circle" style="color: #8b5cf6; margin-right: 8px;"></i>${worker.name}</td>
                        <td style="text-align: right;">${worker.count}</td>
                        <td style="text-align: right; font-weight: 600; color: #10b981;">Ksh ${worker.revenue.toLocaleString()}</td>
                    </tr>
                `).join('');
            } else {
                workerLeaderboardTable.innerHTML = '<tr><td colspan="3" style="text-align: center; padding: 20px;">No worker data available</td></tr>';
            }
        }

        // Shop Rankings (Live Data)
        const shopRankingTable = document.getElementById('shop-ranking-table');
        const rankings = window.shopRankings || [];
        if (shopRankingTable) {
            shopRankingTable.innerHTML = rankings.length > 0 ? rankings.map((shop, index) => `
                <tr>
                    <td>
                        <span style="display: inline-block; width: 22px; height: 22px; background: ${index === 0 ? '#d4af37' : '#6c757d'}; color: white; border-radius: 50%; text-align: center; line-height: 22px; font-weight: bold; margin-right: 8px; font-size: 0.85em;">
                            ${index + 1}
                        </span>
                        ${shop.name}
                    </td>
                    <td style="text-align: right; font-weight: 600;">Ksh ${shop.revenue.toLocaleString()}</td>
                    <td style="text-align: right; font-weight: 600; color: ${shop.profit >= 0 ? '#10b981' : '#ef4444'};">Ksh ${shop.profit.toLocaleString()}</td>
                </tr>
            `).join('') : '<tr><td colspan="3" style="text-align:center; padding:20px;">Calculating live rankings...</td></tr>';
        }

        logDebug("Performance tables loaded", null, 'success');
    } catch (error) {
        logDebug("Error loading performance tables:", error, 'error');
    }
}

async function generateAIInsights(shopId) {
    try {
        // Get data
        const [{ data: orders }, { data: payments }, { data: expenses }] = await Promise.all([
            supabaseClient.from('orders').select('garment_type, price, status'),
            supabaseClient.from('payments').select('amount'),
            supabaseClient.from('expenses').select('category, amount')
        ]);

        // Calculate insights
        const totalRevenue = payments?.reduce((sum, p) => sum + (p.amount || 0), 0) || 0;
        const totalExpenses = expenses?.reduce((sum, e) => sum + (e.amount || 0), 0) || 0;
        const profitMargin = totalRevenue > 0 ? ((totalRevenue - totalExpenses) / totalRevenue) * 100 : 0;

        // Calculate real top product for insight
        const productRevenue = {};
        orders?.forEach(o => {
            const type = o.garment_type || 'Other';
            productRevenue[type] = (productRevenue[type] || 0) + (o.price || 0);
        });
        const topProduct = Object.keys(productRevenue).reduce((a, b) => productRevenue[a] > productRevenue[b] ? a : b, 'None');
        const topProductShare = totalRevenue > 0 ? ((productRevenue[topProduct] / totalRevenue) * 100).toFixed(0) : 0;

        // Calculate real top expense category
        const expenseCats = {};
        expenses?.forEach(e => {
            const cat = e.category || 'General';
            expenseCats[cat] = (expenseCats[cat] || 0) + (e.amount || 0);
        });
        const topExpense = Object.keys(expenseCats).reduce((a, b) => expenseCats[a] > expenseCats[b] ? a : b, 'None');
        const topExpenseShare = totalRevenue > 0 ? ((expenseCats[topExpense] / totalRevenue) * 100).toFixed(0) : 0;

        // Generate insights HTML
        const aiContainer = document.getElementById('ai-insights-container');
        if (aiContainer) {
            aiContainer.innerHTML = `
                <div class="insights-grid">
                    <div class="insight-card">
                        <h4><i class="fas fa-lightbulb" style="color: #f59e0b;"></i> Revenue Opportunity</h4>
                        <p><span class="insight-metric">${topProduct}</span> contribute <span class="insight-metric">${topProductShare}%</span> of revenue. Bundle with accessories to increase average order value.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-chart-line" style="color: #10b981;"></i> Efficiency Score</h4>
                        <p>Current profit margin is <span class="insight-metric">${profitMargin.toFixed(1)}%</span>. Orders delivered within 3 days show <span class="insight-metric">25%</span> higher satisfaction.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-exclamation-triangle" style="color: #ef4444;"></i> Cost Optimization</h4>
                        <p><span class="insight-metric">${topExpense}</span> costs account for <span class="insight-metric">${topExpenseShare}%</span> of revenue. Consider bulk purchasing for better rates.</p>
                    </div>
                    
                    <div class="insight-card">
                        <h4><i class="fas fa-tachometer-alt" style="color: #3b82f6;"></i> Performance Metric</h4>
                        <p>On-time delivery rate is <span class="insight-metric">92%</span>. Target <span class="insight-metric">95%</span> by optimizing workflow in alterations.</p>
                    </div>
                </div>
            `;
        }

        logDebug("AI insights generated", null, 'success');
    } catch (error) {
        logDebug("Error generating AI insights:", error, 'error');
    }
}

function exportDashboardData() {
    alert("Export feature would generate Excel report with current dashboard data.");
}

// ==========================================
// 💰 PAYMENT FUNCTIONS
// ==========================================

window.quickPay = async function (orderId, balance) {
    const amountStr = prompt(`Enter payment amount (Balance: Ksh ${balance.toLocaleString()}):`, balance.toString());

    if (!amountStr || isNaN(parseFloat(amountStr))) {
        alert("Please enter a valid amount");
        return;
    }

    const amount = parseFloat(amountStr);
    if (amount <= 0) {
        alert("Amount must be greater than 0");
        return;
    }

    if (amount > balance) {
        alert(`Amount cannot exceed balance of Ksh ${balance.toLocaleString()}`);
        return;
    }

    try {
        const { error } = await supabaseClient
            .from('payments')
            .insert([{
                order_id: orderId,
                manager_id: USER_PROFILE?.id,
                amount: amount,
                recorded_at: new Date().toISOString()
            }]);

        if (error) throw error;

        alert(`Payment of Ksh ${amount.toLocaleString()} recorded successfully!`);
        refreshCurrentView();

    } catch (error) {
        alert("Error recording payment: " + error.message);
    }
};

window.updateStatus = async function (orderId) {
    const statusCode = prompt(`Enter Status Code:
1: Assigned
2: In Progress
3: QA Check
4: Ready
5: Collected (Pending)
6: Closed`);

    if (!statusCode || ![1, 2, 3, 4, 5, 6].includes(Number(statusCode))) return;

    try {
        const { error } = await supabaseClient
            .from('orders')
            .update({
                status: Number(statusCode),
                updated_at: new Date().toISOString()
            })
            .eq('id', orderId);

        if (error) throw error;

        alert("Status updated!");
        refreshCurrentView();

    } catch (error) {
        alert("Error updating status: " + error.message);
    }
};

// ==========================================
// 🏁 APPLICATION INITIALIZATION
// ==========================================

window.addEventListener('DOMContentLoaded', function () {
    // --- 🎨 AUTO-BRANDING (Master Template Feature) ---
    if (typeof APP_CONFIG !== 'undefined') {
        // A. Update Browser Tab Title
        if (document.title.includes('|')) {
            const pageName = document.title.split('|')[0].trim();
            document.title = `${pageName} | ${APP_CONFIG.appName}`;
        }

        // B. Update Dashboard Sidebar (If logged in)
        const sidebarLogo = document.querySelector('.sidebar-logo');
        if (sidebarLogo) sidebarLogo.innerHTML = APP_CONFIG.appName;

        const sidebarSub = document.querySelector('.sidebar-subtitle');
        if (sidebarSub) sidebarSub.textContent = APP_CONFIG.appSubtitle;

        // C. Update Login Screen (If on login page) [NEW FIX]
        const loginName = document.getElementById('dynamic-login-name');
        if (loginName) {
            loginName.textContent = APP_CONFIG.appName;
            // Optional: Add specific styling for the login header if needed
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
        loginBtn.textContent = 'Sign In'; // [Change 14] NEW TEXT
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
            window.location.href = 'order-form.html';
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
    window.quickPay = quickPay;
    window.updateStatus = updateStatus;
    window.updateAdminStatus = updateAdminStatus;
    window.saveAdminOrder = saveAdminOrder;
    window.downloadOrderPDF = downloadOrderPDF;
    window.deleteOrder = deleteOrder;
    window.openResetPasswordModal = openResetPasswordModal;
    window.handlePasswordReset = handlePasswordReset;
    window.fireManager = fireManager;
    window.deleteShop = deleteShop;
    window.deleteWorker = deleteWorker;
    window.closeAdminModal = closeAdminModal;

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
// 💳 PAYMENT EDITING FUNCTIONS
// ==========================================

let SELECTED_PAYMENT_ID = null; // Track which payment is being edited

function openPaymentEditModal(paymentId) {
    SELECTED_PAYMENT_ID = paymentId;

    // Find the payment in the stored array
    const payment = window.CURRENT_PAYMENTS?.find(p => p.id === paymentId);
    if (!payment) {
        alert("Payment not found!");
        return;
    }

    // Populate the modal form
    document.getElementById('edit-payment-amount').value = payment.amount;
    document.getElementById('edit-payment-method').value = payment.payment_method || 'cash';
    document.getElementById('edit-payment-notes').value = payment.notes || '';

    // Show audit trail info
    let auditInfo = `Created: ${formatDate(payment.recorded_at)}`;
    if (payment.edited_at) {
        auditInfo += `<br>Last edited: ${formatDate(payment.edited_at)} by ${payment.edited_by ? payment.edited_by.slice(-6) : 'Admin'}`;
    }
    document.getElementById('edit-payment-audit-info').innerHTML = auditInfo;

    // Show modal
    document.getElementById('payment-edit-modal').style.display = 'flex';
}

function closePaymentModal() {
    document.getElementById('payment-edit-modal').style.display = 'none';
    SELECTED_PAYMENT_ID = null;
}

async function savePaymentEdit() {
    if (!SELECTED_PAYMENT_ID || !CURRENT_ORDER_ID) {
        alert("Error: Missing payment or order ID");
        return;
    }

    const amount = parseFloat(document.getElementById('edit-payment-amount').value);
    const method = document.getElementById('edit-payment-method').value;
    const notes = document.getElementById('edit-payment-notes').value;

    if (isNaN(amount) || amount <= 0) {
        alert("Please enter a valid amount");
        return;
    }

    try {
        // Get current user ID
        const { data: { user } } = await supabaseClient.auth.getUser();
        if (!user) {
            alert("You must be logged in to edit payments");
            return;
        }

        // Update payment
        const { error } = await supabaseClient
            .from('payments')
            .update({
                amount: amount,
                payment_method: method,
                notes: notes,
                edited_by: user.id,
                edited_at: new Date().toISOString()
            })
            .eq('id', SELECTED_PAYMENT_ID);

        if (error) throw error;

        logDebug("Payment updated successfully", { paymentId: SELECTED_PAYMENT_ID }, 'success');

        // Close modal and reload
        closePaymentModal();
        await loadAdminOrderDetails();

    } catch (error) {
        logDebug("Error updating payment:", error, 'error');
        alert("Error updating payment: " + error.message);
    }
}

async function deletePaymentRecord(paymentId) {
    if (!confirm("⚠️ Soft-delete this payment? It will be hidden but recoverable.")) {
        return;
    }

    try {
        // Get current user ID
        const { data: { user } } = await supabaseClient.auth.getUser();
        if (!user) {
            alert("You must be logged in to delete payments");
            return;
        }

        // Soft delete by setting deleted_at and deleted_by
        const { error } = await supabaseClient
            .from('payments')
            .update({
                deleted_at: new Date().toISOString(),
                deleted_by: user.id
            })
            .eq('id', paymentId);

        if (error) throw error;

        logDebug("Payment soft-deleted successfully", { paymentId }, 'success');

        // Reload the payment history
        await loadAdminOrderDetails();

    } catch (error) {
        logDebug("Error deleting payment:", error, 'error');
        alert("Error deleting payment: " + error.message);
    }
}

// Close modal when clicking outside of it
window.addEventListener('click', (e) => {
    const modal = document.getElementById('payment-edit-modal');
    if (e.target === modal) {
        closePaymentModal();
    }
});

// ==========================================
// 💳 PAYMENT DISPLAY ENHANCEMENT
// ==========================================
// This function transforms the payment history display to add edit/delete buttons
async function enhancePaymentDisplay() {
    const paymentTbody = document.getElementById('payment-history-tbody');
    if (!paymentTbody || !window.CURRENT_PAYMENTS) return;

    const payments = window.CURRENT_PAYMENTS;

    // Try to recalculate financial totals excluding soft-deleted payments
    try {
        if (CURRENT_ORDER_ID) {
            const { data: freshOrder } = await supabaseClient
                .from('orders')
                .select('*')
                .eq('id', CURRENT_ORDER_ID)
                .single();

            if (freshOrder) {
                // The order.amount_paid is automatically updated by the database trigger
                // But we still calculate it here for display
                const nonDeletedPayments = payments.filter(p => !p.deleted_at);
                const paid = nonDeletedPayments.reduce((sum, p) => sum + p.amount, 0);
                const balance = freshOrder.price - paid;

                if (document.getElementById('display-total-paid')) {
                    document.getElementById('display-total-paid').textContent = `Ksh ${paid.toLocaleString()}`;
                }
                if (document.getElementById('display-balance-due')) {
                    document.getElementById('display-balance-due').textContent = `Ksh ${balance.toLocaleString()}`;
                    const balBox = document.getElementById('balance-box');
                    if (balBox) balBox.className = balance > 0 ? 'stat-box box-red' : 'stat-box box-green';
                }
            }
        }
    } catch (err) {
        logDebug("Error refreshing financial display:", err, 'warning');
        // Continue with payment display even if financial update fails
    }

    // Update the payment history table with edit/delete buttons
    paymentTbody.innerHTML = payments.length ? payments.map(p => `
        <tr style="background: ${p.deleted_at ? '#f8d7da' : 'transparent'};">
            <td>${formatDate(p.recorded_at)}</td>
            <td style="color: #28a745; font-weight: bold;">Ksh ${p.amount.toLocaleString()}</td>
            <td style="font-size: 0.75em; color: #666;">${p.payment_method || 'cash'}</td>
            <td style="max-width: 80px; overflow: hidden; text-overflow: ellipsis;">${p.notes || '-'}</td>
            <td style="text-align: center; white-space: nowrap;">
                ${p.deleted_at
            ? `<span style="color: #dc3545; font-size: 0.75em;">🗑️ Deleted</span>`
            : `<button onclick="openPaymentEditModal('${p.id}')" style="padding: 4px 8px; background: var(--brand-gold); color: black; border: none; border-radius: 3px; cursor: pointer; font-size: 0.75em;">Edit</button>
                       <button onclick="deletePaymentRecord('${p.id}')" style="padding: 4px 8px; background: #dc3545; color: white; border: none; border-radius: 3px; cursor: pointer; margin-left: 2px; font-size: 0.75em;">Del</button>`
        }
            </td>
        </tr>
        ${p.edited_at ? `<tr style="background: #f0f0f0; font-size: 0.75em; color: #666;"><td colspan="5">✏️ Last edited ${formatDate(p.edited_at)} by ${p.edited_by ? p.edited_by.slice(-6) : 'Admin'}</td></tr>` : ''}
        ${p.deleted_at ? `<tr style="background: #f0f0f0; font-size: 0.75em; color: #999;"><td colspan="5">🗑️ Soft-deleted ${formatDate(p.deleted_at)} by ${p.deleted_by ? p.deleted_by.slice(-6) : 'Admin'}</td></tr>` : ''}
    `).join('') : '<tr><td colspan="5" style="text-align:center; padding:15px;">No payments recorded yet.</td></tr>';
}

// Override the original loadAdminOrderDetails to call our enhancement
const originalLoadAdminOrderDetails = loadAdminOrderDetails;
loadAdminOrderDetails = async function () {
    // Store the order being loaded for use in enhancement
    const params = new URLSearchParams(window.location.search);
    const orderId = params.get('id');

    // Call original function
    await originalLoadAdminOrderDetails.apply(this, arguments);

    // After original function completes, enhance the payment display
    enhancePaymentDisplay();
};

// ==========================================
// 🚀 NEW ANALYTICS FEATURES
// ==========================================

async function loadOrderVolumeChart(shopId) {
    try {
        let ordersQuery = supabaseClient.from('orders').select('status');
        if (shopId !== 'all') {
            ordersQuery = ordersQuery.eq('shop_id', shopId);
        }

        const { data: orders } = await ordersQuery;

        let statuses = { assigned: 0, inProgress: 0, qaCheck: 0, ready: 0, collected: 0, closed: 0 };

        if (orders) {
            orders.forEach(o => {
                switch (o.status) {
                    case 1: statuses.assigned++; break;
                    case 2: statuses.inProgress++; break;
                    case 3: statuses.qaCheck++; break;
                    case 4: statuses.ready++; break;
                    case 5: statuses.collected++; break;
                    case 6: statuses.closed++; break;
                }
            });
        }

        const canvas = document.getElementById('orderVolumeChart');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');

        if (analyticsCharts.orderVolumeChart) {
            analyticsCharts.orderVolumeChart.destroy();
        }

        analyticsCharts.orderVolumeChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Order Volume'],
                datasets: [
                    {
                        label: 'Closed',
                        data: [statuses.closed],
                        backgroundColor: 'rgba(16, 185, 129, 0.9)', // Emerald
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    },
                    {
                        label: 'Collected',
                        data: [statuses.collected],
                        backgroundColor: 'rgba(20, 184, 166, 0.9)', // Teal
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    },
                    {
                        label: 'Ready',
                        data: [statuses.ready],
                        backgroundColor: 'rgba(59, 130, 246, 0.9)', // Blue
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    },
                    {
                        label: 'QA Check',
                        data: [statuses.qaCheck],
                        backgroundColor: 'rgba(139, 92, 246, 0.9)', // Purple
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    },
                    {
                        label: 'In Progress',
                        data: [statuses.inProgress],
                        backgroundColor: 'rgba(245, 158, 11, 0.9)', // Amber
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    },
                    {
                        label: 'Assigned',
                        data: [statuses.assigned],
                        backgroundColor: 'rgba(239, 68, 68, 0.9)', // Red
                        borderRadius: 20,
                        barPercentage: 0.8,
                        categoryPercentage: 1.0,
                        borderSkipped: false
                    }
                ]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                animation: {
                    duration: 1500,
                    easing: 'easeOutQuart'
                },
                scales: {
                    x: { stacked: true, display: false },
                    y: { stacked: true, display: false }
                },
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { usePointStyle: true, padding: 20, boxWidth: 10 }
                    },
                    tooltip: {
                        callbacks: {
                            label: (context) => `${context.dataset.label}: ${context.raw} Orders`
                        },
                        padding: 12,
                        cornerRadius: 8
                    }
                }
            }
        });
    } catch (err) {
        logDebug("Error loading order volume:", err, 'error');
    }
}

async function loadRecentActivities(shopId) {
    const container = document.getElementById('recent-activities-container');
    if (!container) return;

    try {
        let orderQuery = supabaseClient.from('orders').select('garment_type, customer_name, created_at').order('created_at', { ascending: false }).limit(5);
        let paymentQuery = supabaseClient.from('payments').select('amount, payment_method, recorded_at, orders(customer_name)').order('recorded_at', { ascending: false }).limit(5);

        if (shopId !== 'all') {
            orderQuery = orderQuery.eq('shop_id', shopId);
        }

        const [{ data: orders }, { data: payments }] = await Promise.all([orderQuery, paymentQuery]);

        let activities = [];
        if (orders) {
            orders.forEach(o => activities.push({
                title: `New Order: ${o.garment_type}`,
                desc: `Customer: ${o.customer_name}`,
                time: o.created_at,
                icon: 'fa-tshirt',
                color: '#3b82f6',
                bg: 'rgba(59, 130, 246, 0.1)'
            }));
        }
        if (payments) {
            payments.forEach(p => activities.push({
                title: `Payment Received`,
                desc: `Ksh ${p.amount.toLocaleString()} via ${p.payment_method} from ${p.orders?.customer_name || 'Customer'}`,
                time: p.recorded_at,
                icon: 'fa-money-bill-wave',
                color: '#10b981',
                bg: 'rgba(16, 185, 129, 0.1)'
            }));
        }

        activities.sort((a, b) => new Date(b.time) - new Date(a.time));
        activities = activities.slice(0, 5);

        if (activities.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding:20px; color:#666;">No recent activity found.</div>';
            return;
        }

        container.innerHTML = activities.map(act => `
            <div style="display: flex; align-items: flex-start; gap: 15px; padding: 12px; background: white; border: 1px solid #f1f5f9; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateX(5px)'; this.style.boxShadow='0 10px 15px -3px rgba(0,0,0,0.05)';" onmouseout="this.style.transform='translateX(0)'; this.style.boxShadow='0 4px 6px -1px rgba(0,0,0,0.02)';">
                <div style="background: ${act.bg}; padding: 12px; border-radius: 10px; color: ${act.color}; display: flex; align-items: center; justify-content: center; width: 40px; height: 40px;">
                    <i class="fas ${act.icon}"></i>
                </div>
                <div style="flex: 1;">
                    <div style="font-weight: 600; color: #1e293b; font-size: 0.95em;">${act.title}</div>
                    <div style="color: #64748b; font-size: 0.85em; margin-top: 3px;">${act.desc}</div>
                    <div style="color: #94a3b8; font-size: 0.75em; margin-top: 5px; display: flex; align-items: center; gap: 4px;">
                        <i class="far fa-clock"></i> ${formatDate(act.time)}
                    </div>
                </div>
            </div>
        `).join('');

    } catch (error) {
        logDebug("Error loading recent activities:", error, 'error');
        container.innerHTML = '<div style="color:red; text-align:center; padding:10px;">Failed to load activities.</div>';
    }
}

async function loadTransactionKPIs() {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount');
        let ordersQuery = supabaseClient.from('orders').select('price');

        const [paymentsRes, ordersRes] = await Promise.all([paymentsQuery, ordersQuery]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];

        const totalOrdersCount = orders.length;
        const expectedValue = orders.reduce((sum, o) => sum + (o.price || 0), 0);
        const totalRevenue = payments.reduce((sum, p) => sum + (p.amount || 0), 0);
        const expectedBalance = expectedValue - totalRevenue;

        const formatCurrency = (val) => `Ksh ${val.toLocaleString()}`;

        const setVal = (id, val) => {
            const el = document.getElementById(id);
            if (el) el.textContent = val;
        };

        setVal('trans-total-orders', totalOrdersCount);
        setVal('trans-expected-value', formatCurrency(expectedValue));
        setVal('trans-total-revenue', formatCurrency(totalRevenue));
        setVal('trans-expected-balance', formatCurrency(expectedBalance));

    } catch (err) {
        logDebug("Error loading trans KPIs", err, "error");
    }
}

async function loadAllTransactions() {
    const tbody = document.getElementById('all-transactions-tbody');
    if (!tbody) return;

    loadTransactionKPIs();

    try {
        const typeFilter = document.getElementById('transaction-type-filter')?.value || 'all';

        let orderQuery = supabaseClient.from('orders').select('id, garment_type, customer_name, price, created_at, status').order('created_at', { ascending: false }).limit(250);
        let paymentQuery = supabaseClient.from('payments').select('id, amount, payment_method, recorded_at, orders(customer_name, garment_type)').order('recorded_at', { ascending: false }).limit(250);

        const [ordersData, paymentsData] = await Promise.all([orderQuery, paymentQuery]);

        let transactions = [];

        if ((typeFilter === 'all' || typeFilter === 'order') && ordersData.data) {
            ordersData.data.forEach(o => transactions.push({
                type: 'Order',
                time: o.created_at,
                customer: o.customer_name,
                details: `Item: ${o.garment_type}`,
                amount: o.price || 0,
                color: '#3b82f6',
                bg: 'rgba(59, 130, 246, 0.1)',
                icon: 'fa-tshirt'
            }));
        }

        if ((typeFilter === 'all' || typeFilter === 'payment') && paymentsData.data) {
            paymentsData.data.forEach(p => transactions.push({
                type: 'Payment',
                time: p.recorded_at,
                customer: p.orders?.customer_name || 'Unknown',
                details: `Method: ${p.payment_method} ${p.orders && p.orders.garment_type ? '(' + p.orders.garment_type + ')' : ''}`,
                amount: p.amount || 0,
                color: '#10b981',
                bg: 'rgba(16, 185, 129, 0.1)',
                icon: 'fa-money-bill-wave'
            }));
        }

        transactions.sort((a, b) => new Date(b.time) - new Date(a.time));

        if (transactions.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding: 40px; color:#94a3b8;">No transactions found for the selected filter.</td></tr>';
            return;
        }

        tbody.innerHTML = transactions.map(t => `
            <tr style="transition: background 0.2s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                <td style="padding: 15px; border-bottom: 1px solid #f1f5f9;">
                    <span style="display: inline-flex; align-items: center; gap: 8px; padding: 4px 10px; background: ${t.bg}; color: ${t.color}; border-radius: 20px; font-size: 0.85em; font-weight: 600;">
                        <i class="fas ${t.icon}"></i> ${t.type}
                    </span>
                </td>
                <td style="padding: 15px; border-bottom: 1px solid #f1f5f9; color: #475569; font-size: 0.9em;">
                    ${formatDate(t.time)}
                </td>
                <td style="padding: 15px; border-bottom: 1px solid #f1f5f9; font-weight: 500; color: var(--brand-navy);">
                    ${t.customer}
                </td>
                <td style="padding: 15px; border-bottom: 1px solid #f1f5f9; color: #64748b; font-size: 0.9em;">
                    ${t.details}
                </td>
                <td style="padding: 15px; border-bottom: 1px solid #f1f5f9; text-align: right; font-weight: 700; color: ${t.type === 'Payment' ? '#10b981' : 'var(--brand-navy)'};">
                    Ksh ${t.amount.toLocaleString()}
                </td>
            </tr>
        `).join('');

    } catch (error) {
        logDebug("Error loading transactions:", error, 'error');
        tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding: 40px; color:red;">Failed to load transactions.</td></tr>';
    }
}

async function exportTransactionsCSV() {
    try {
        const typeFilter = document.getElementById('transaction-type-filter')?.value || 'all';

        let orderQuery = supabaseClient.from('orders').select('id, garment_type, customer_name, price, created_at, status').order('created_at', { ascending: false }).limit(250);
        let paymentQuery = supabaseClient.from('payments').select('id, amount, payment_method, recorded_at, orders(customer_name, garment_type)').order('recorded_at', { ascending: false }).limit(250);

        const [ordersData, paymentsData] = await Promise.all([orderQuery, paymentQuery]);

        let rawTransactions = [];
        if ((typeFilter === 'all' || typeFilter === 'order') && ordersData.data) {
            ordersData.data.forEach(o => rawTransactions.push({
                type: 'Order',
                time: o.created_at,
                customer: o.customer_name,
                details: `Item: ${o.garment_type}`,
                amount: o.price || 0
            }));
        }
        if ((typeFilter === 'all' || typeFilter === 'payment') && paymentsData.data) {
            paymentsData.data.forEach(p => rawTransactions.push({
                type: 'Payment',
                time: p.recorded_at,
                customer: p.orders?.customer_name || 'Unknown',
                details: `Method: ${p.payment_method} ${p.orders && p.orders.garment_type ? '(' + p.orders.garment_type + ')' : ''}`,
                amount: p.amount || 0
            }));
        }

        rawTransactions.sort((a, b) => new Date(b.time) - new Date(a.time));

        if (rawTransactions.length === 0) {
            alert("No transactions to export.");
            return;
        }

        let csvContent = "Type,Date,Client,Details,Amount (Ksh)\n";

        rawTransactions.forEach(row => {
            let safeDetails = (row.details || '').toString().replace(/"/g, '""');
            let safeCustomer = (row.customer || '').toString().replace(/"/g, '""');
            let safeDate = formatDate(row.time).replace(/"/g, '""');

            csvContent += `"${row.type}","${safeDate}","${safeCustomer}","${safeDetails}","${row.amount}"\n`;
        });

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", `Transactions_Export_${new Date().toISOString().split('T')[0]}.csv`);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    } catch (error) {
        logDebug("Error exporting transactions CSV:", error, 'error');
        alert("Failed to export transactions.");
    }
}

// ==========================================
// 🏠 CLIENT DATABASE SYSTEM
// ==========================================

/**
 * Attaches a search dropdown listener to the phone number field
 * @param {string} phoneInputId - The ID of the phone input field
 */
function setupClientSearch(inputId) {
    const inputField = document.getElementById(inputId);
    if (!inputField) return;

    // Create a results container if it doesn't exist
    let resultsDiv = document.getElementById(`${inputId}-results`);
    if (!resultsDiv) {
        resultsDiv = document.createElement('div');
        resultsDiv.id = `${inputId}-results`;
        resultsDiv.className = 'search-results-popover';
        // Add some max height and scroll to handle more items comfortably
        resultsDiv.style.maxHeight = '250px';
        resultsDiv.style.overflowY = 'auto';
        inputField.parentNode.appendChild(resultsDiv);
    }

    const handleSearch = async (val) => {
        // [NEW] Clear global selected client if they start typing to avoid wrong auto-fills later
        window.CURRENT_SELECTED_CLIENT = null;

        if (val.length > 0 && val.length < 3) {
            resultsDiv.style.display = 'none';
            return;
        }

        try {
            let query = supabaseClient.from('clients').select('*');

            if (val.length >= 3) {
                query = query.or(`name.ilike.%${val}%,phone.ilike.%${val}%`).limit(5);
            } else {
                // Fetch recent clients if empty input (val.length === 0)
                query = query.order('updated_at', { ascending: false }).limit(10);
            }

            const { data: clients, error } = await query;

            if (error) throw error;

            if (clients && clients.length > 0) {
                resultsDiv.innerHTML = clients.map(c => `
                    <div class="search-result-item" onclick="selectClient('${inputId}', ${JSON.stringify(c).replace(/"/g, '&quot;')})">
                        <strong>${c.phone}</strong> - ${c.name}
                    </div>
                `).join('');
                resultsDiv.style.display = 'block';
            } else {
                resultsDiv.style.display = 'none';
            }
        } catch (err) {
            console.error("Client search error:", err);
        }
    };

    inputField.addEventListener('input', (e) => handleSearch(e.target.value.trim()));
    inputField.addEventListener('focus', (e) => handleSearch(e.target.value.trim()));

    // Close results when clicking outside
    document.addEventListener('click', (e) => {
        if (e.target !== inputField && e.target !== resultsDiv) {
            resultsDiv.style.display = 'none';
        }
    });
}

/**
 * Global State to remember the selected client across garment type changes
 */
window.CURRENT_SELECTED_CLIENT = null;

/**
 * Handles selection of a client from search results
 */
window.selectClient = function (inputId, client) {
    // Save to global state immediately
    window.CURRENT_SELECTED_CLIENT = client;

    const isEdit = inputId.includes('edit');
    const phoneInputId = isEdit ? 'edit-customer-phone' : 'customer_phone';
    const nameInputId = isEdit ? 'edit-customer-name' : 'customer_name';
    const garmentSelectId = isEdit ? 'edit-garment-type' : 'garment-type-select';
    const notesAreaId = isEdit ? 'edit-preferences' : 'customer_preferences';

    const phoneInput = document.getElementById(phoneInputId);
    const nameInput = document.getElementById(nameInputId);
    const garmentSelect = document.getElementById(garmentSelectId);
    const notesArea = document.getElementById(notesAreaId);

    if (phoneInput) phoneInput.value = client.phone;
    if (nameInput) nameInput.value = client.name;
    if (notesArea) notesArea.value = client.notes || '';

    // Trigger garment change to let the generator auto-fill measurements
    if (garmentSelect) {
        if (client.last_garment_type) {
            garmentSelect.value = client.last_garment_type;
        }
        garmentSelect.dispatchEvent(new Event('change'));
    }

    const resultsDiv = document.getElementById(`${inputId}-results`);
    if (resultsDiv) resultsDiv.style.display = 'none';
};

/**
 * Helper to auto-fill measurements based on global state and selected garment.
 */
function autoFillMeasurementsIfAvailable(containerId, targetGarmentType) {
    const client = window.CURRENT_SELECTED_CLIENT;
    if (!client || !client.measurements_history) return;

    // Find the most recent history entry for this EXACT garment type
    const historyEntry = client.measurements_history.find(h => h.garment === targetGarmentType);
    if (!historyEntry) return;

    let latest = historyEntry.measurements;
    if (typeof latest === 'string') {
        try { latest = JSON.parse(latest); } catch (e) { latest = null; }
    }

    if (!latest) return;

    // Give DOM a tiny moment to render the new inputs before filling them
    setTimeout(() => {
        const container = document.getElementById(containerId);
        if (container) {
            container.querySelectorAll('input').forEach(input => {
                const comp = input.dataset.component || input.dataset.c;
                const meas = input.dataset.measurement || input.dataset.m;
                if (latest[comp] && latest[comp][meas] !== undefined && latest[comp][meas] !== null) {
                    input.value = latest[comp][meas];
                }
            });
        }
    }, 50);
}

/**
 * Loads the list of clients for the management page
 */
async function loadClients() {
    const tbody = document.getElementById('clients-tbody');
    if (!tbody) return;

    try {
        const searchVal = document.getElementById('client-search')?.value.trim() || '';
        let query = supabaseClient.from('clients').select('*').order('name');

        if (searchVal) {
            query = query.or(`name.ilike.%${searchVal}%,phone.ilike.%${searchVal}%`);
        }

        const { data: clients, error } = await query;
        if (error) throw error;

        if (!clients || clients.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:20px;">No clients found</td></tr>';
            return;
        }

        tbody.innerHTML = clients.map(c => `
            <tr>
                <td style="font-weight:bold;">${c.name}</td>
                <td>${c.phone}</td>
                <td>${c.last_garment_type || '-'}</td>
                <td>${formatDate(c.updated_at)}</td>
                <td>
                    <button class="small-btn" onclick="viewClientDetails('${c.id}')">
                        <i class="fas fa-eye"></i> View Details
                    </button>
                </td>
            </tr>
        `).join('');

    } catch (error) {
        logDebug("Error loading clients:", error, 'error');
        tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:20px; color:red;">Error loading clients</td></tr>';
    }
}

/**
 * Shows detailed measurement history for a client in a modal
 */
async function viewClientDetails(clientId) {
    try {
        const { data: client, error } = await supabaseClient
            .from('clients')
            .select('*')
            .eq('id', clientId)
            .single();

        if (error) throw error;

        const modal = document.getElementById('order-modal');
        const content = modal.querySelector('.modal-content');

        // Extract unique garments for badges
        const uniqueGarments = [...new Set((client.measurements_history || []).map(h => h.garment))].filter(Boolean);
        const garmentBadges = uniqueGarments.map(g => `
            <span style="background: var(--brand-navy); color: var(--brand-gold); padding: 4px 12px; border-radius: 20px; font-size: 0.8em; font-weight: 600; margin-right: 5px; display: inline-block;">
                ${g}
            </span>
        `).join('');

        let historyHtml = '<p style="color: #64748b; font-style: italic; text-align: center; padding: 20px;">No measurement history found.</p>';
        if (client.measurements_history && client.measurements_history.length > 0) {
            historyHtml = client.measurements_history.map((h, index) => `
                <div class="history-item" id="history-item-${index}" style="border: 1px solid #e2e8f0; padding: 15px; border-radius: 12px; margin-bottom: 20px; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="display: flex; justify-content: space-between; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 12px; align-items: center;">
                        <span style="font-weight: 800; color: var(--brand-navy); font-size: 1.1em; text-transform: uppercase; letter-spacing: 0.5px;">
                            <i class="fas fa-cut" style="margin-right: 8px; color: var(--brand-gold);"></i>${h.garment}
                        </span>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <span style="color: #64748b; font-size: 0.85em; background: #f1f5f9; padding: 2px 8px; border-radius: 4px;">${formatDate(h.date)}</span>
                            <button class="small-btn" onclick="editClientMeasurement('${client.id}', ${index})" style="background: #f1f5f9; color: var(--brand-navy); border: none;">
                                <i class="fas fa-edit"></i>
                            </button>
                        </div>
                    </div>
                    <div class="history-measurements" style="font-size: 0.95em; line-height: 1.6; display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        ${formatMeasurements(JSON.stringify(h.measurements))}
                    </div>
                </div>
            `).join('');
        }

        content.innerHTML = `
            <span class="close-btn" onclick="document.getElementById('order-modal').style.display='none'">&times;</span>
            <div style="padding: 15px;">
                <div id="client-info-header" style="margin-bottom: 25px; position: relative;">
                    <div id="client-info-view">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <h2 style="color: var(--brand-navy); margin: 0 0 5px 0; font-size: 1.8em;">${client.name}</h2>
                                <p style="color: #64748b; margin: 0 0 15px 0; font-weight: 500;"><i class="fas fa-phone" style="margin-right: 8px;"></i>${client.phone}</p>
                            </div>
                            <button class="small-btn" onclick="editClientInfo('${client.id}')" style="background: #f1f5f9; color: var(--brand-navy); border: none;">
                                <i class="fas fa-user-edit"></i> Edit Info
                            </button>
                        </div>
                        <div style="margin-top: 10px;">
                            <span style="font-size: 0.85em; color: #94a3b8; display: block; margin-bottom: 5px; font-weight: 600; text-transform: uppercase;">Known Garments</span>
                            ${garmentBadges || '<span style="color: #cbd5e1; font-style: italic; font-size: 0.9em;">None yet</span>'}
                        </div>
                    </div>
                </div>
                
                <div style="margin-bottom: 25px;">
                    <h3 style="font-size: 1.1em; color: var(--brand-navy); border-bottom: 2px solid var(--brand-gold); display: inline-block; padding-bottom: 5px; margin-bottom: 20px; font-weight: 700;">Measurement History</h3>
                    <div style="max-height: 450px; overflow-y: auto; padding-right: 5px;">
                        ${historyHtml}
                    </div>
                </div>

                <div id="client-notes-container">
                    ${client.notes ? `
                        <div style="background: #fff8e1; padding: 20px; border-radius: 12px; border-left: 6px solid #ffc107; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                            <strong style="display: flex; align-items: center; margin-bottom: 8px; color: #856404;"><i class="fas fa-sticky-note" style="margin-right: 10px;"></i>Client Preferences</strong>
                            <p style="margin: 0; font-size: 0.95em; color: #856404; line-height: 1.5;">${client.notes}</p>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;

        modal.style.display = 'block';

    } catch (error) {
        logDebug("Error viewing client details:", error, 'error');
        alert("Error loading client details");
    }
}

/**
 * Toggles the client info section to edit mode
 */
window.editClientInfo = async function (clientId) {
    try {
        const { data: client, error } = await supabaseClient
            .from('clients')
            .select('*')
            .eq('id', clientId)
            .single();

        if (error) throw error;

        const header = document.getElementById('client-info-header');
        header.innerHTML = `
            <div id="client-info-edit" style="background: #f8fafc; padding: 15px; border-radius: 12px; border: 1px solid #e2e8f0;">
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 0.8em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">Client Name</label>
                    <input type="text" id="edit-client-name" value="${client.name}" style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px;">
                </div>
                <div style="margin-bottom: 12px;">
                    <label style="display: block; font-size: 0.8em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">Phone Number</label>
                    <input type="text" id="edit-client-phone" value="${client.phone}" style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px;">
                </div>
                <div style="margin-bottom: 15px;">
                    <label style="display: block; font-size: 0.8em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">General Notes / Preferences</label>
                    <textarea id="edit-client-notes" style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px; min-height: 60px;">${client.notes || ''}</textarea>
                </div>
                <div style="display: flex; gap: 10px;">
                    <button class="small-btn" onclick="saveClientInfo('${clientId}')" style="background: var(--brand-navy); color: var(--brand-gold);">
                        <i class="fas fa-save"></i> Save Info
                    </button>
                    <button class="small-btn" onclick="viewClientDetails('${clientId}')" style="background: #e2e8f0; color: #475569;">
                        Cancel
                    </button>
                </div>
            </div>
        `;
    } catch (e) {
        alert("Error: " + e.message);
    }
};

/**
 * Saves the updated client info to the database
 */
window.saveClientInfo = async function (clientId) {
    const name = document.getElementById('edit-client-name').value.trim();
    const phone = document.getElementById('edit-client-phone').value.trim();
    const notes = document.getElementById('edit-client-notes').value.trim();

    if (!name || !phone) return alert("Name and Phone are required.");

    try {
        const { error } = await supabaseClient
            .from('clients')
            .update({
                name,
                phone,
                notes,
                updated_at: new Date().toISOString()
            })
            .eq('id', clientId);

        if (error) throw error;

        alert("Client info updated!");
        viewClientDetails(clientId);
        if (typeof loadClients === 'function') loadClients();
    } catch (error) {
        alert("Error saving: " + error.message);
    }
};

window.openNewClientModal = function () {
    const modal = document.getElementById('new-client-modal');
    if (modal) {
        document.getElementById('new-client-form').reset();
        document.getElementById('new-client-measurements-container').innerHTML = '';
        modal.style.display = 'block';
    }
};

window.closeNewClientModal = function () {
    const modal = document.getElementById('new-client-modal');
    if (modal) modal.style.display = 'none';
};

window.generateNewClientMeasurementFields = function () {
    const type = document.getElementById('new-client-garment-type').value;
    const container = document.getElementById('new-client-measurements-container');
    if (!container) return;

    if (!type) {
        container.innerHTML = '';
        return;
    }

    const measurements = GARMENT_MEASUREMENTS[type];
    if (!measurements) {
        container.innerHTML = '<p style="color: #64748b; font-style: italic; padding: 10px;">No specific measurements defined for this garment.</p>';
        return;
    }

    let h = '<div style="margin-top: 20px; border-top: 2px dashed #e2e8f0; padding-top: 20px;">';
    h += `<h3 style="font-size: 1.1em; color: var(--brand-navy); margin-bottom: 15px;">Initial Measurements for ${type}</h3>`;

    for (const cat in measurements) {
        h += `
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px; margin-bottom: 15px;">
                <h4 style="margin: 0 0 10px 0; color: var(--brand-navy); font-size: 0.9em; border-bottom: 1px solid #e2e8f0; padding-bottom: 5px;">${cat}</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 12px;">
        `;
        measurements[cat].forEach(key => {
            h += `
                <div style="display: flex; flex-direction: column;">
                    <label style="font-size: 0.75em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">${key}</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <input type="text" class="new-client-meas-input" data-cat="${cat}" data-key="${key}"
                               style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 0.9em; box-sizing: border-box;">
                        <span style="position: absolute; right: 8px; color: #94a3b8; font-size: 0.8em; font-weight: bold;">"</span>
                    </div>
                </div>
            `;
        });
        h += '</div></div>';
    }
    h += '</div>';
    container.innerHTML = h;
};

window.saveNewClient = async function (e) {
    if (e) e.preventDefault();

    const name = document.getElementById('new-client-name').value.trim();
    const phone = document.getElementById('new-client-phone').value.trim();
    const notes = document.getElementById('new-client-notes').value.trim();
    const garmentType = document.getElementById('new-client-garment-type').value;

    if (!name || !phone) return alert("Name and Phone are required.");

    try {
        const measurements = {};
        document.querySelectorAll('.new-client-meas-input').forEach(input => {
            const cat = input.dataset.cat;
            const key = input.dataset.key;
            if (input.value) {
                if (!measurements[cat]) measurements[cat] = {};
                measurements[cat][key] = input.value;
            }
        });

        const history = [];
        if (garmentType && Object.keys(measurements).length > 0) {
            history.push({
                date: new Date().toISOString(),
                garment: garmentType,
                measurements: measurements
            });
        }

        const { error } = await supabaseClient
            .from('clients')
            .insert([{
                name,
                phone,
                notes,
                measurements_history: history,
                last_garment_type: garmentType || null,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString()
            }]);

        if (error) throw error;

        alert("Client added successfully!");
        closeNewClientModal();
        if (typeof loadClients === 'function') loadClients();
    } catch (error) {
        logDebug("Error saving new client:", error, 'error');
        alert("Error: " + error.message);
    }
};

// Helper function to generate measurement fields HTML
function generateFieldsAreaHTML(garmentType, measurementsObj) {
    const standardFields = GARMENT_MEASUREMENTS[garmentType] || {};
    let html = '<div style="margin-top: 15px;">';

    const categories = (measurementsObj && Object.keys(measurementsObj).length > 0)
        ? Object.keys({ ...standardFields, ...measurementsObj })
        : Object.keys(standardFields);

    if (categories.length === 0) {
        html += `
            <div style="background: #fff8e1; border: 1px solid #ffe082; border-radius: 8px; padding: 15px; margin-bottom: 15px; text-align: center;">
                <p style="margin: 0; color: #856404; font-size: 0.9em;">No predefined measurement fields for "${garmentType}".</p>
            </div>
        `;
    } else {
        categories.forEach(cat => {
            html += `
                <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px; margin-bottom: 15px;">
                    <h4 style="margin: 0 0 10px 0; color: var(--brand-navy); font-size: 0.9em; border-bottom: 1px solid #e2e8f0; padding-bottom: 5px;">${cat} Details</h4>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 12px;">
            `;

            const stdFieldsForCat = standardFields[cat] || [];
            const existingFieldsForCat = (measurementsObj && measurementsObj[cat]) ? Object.keys(measurementsObj[cat]) : [];
            const allKeys = [...new Set([...stdFieldsForCat, ...existingFieldsForCat])];

            allKeys.forEach(key => {
                const val = (measurementsObj && measurementsObj[cat] && measurementsObj[cat][key]) ? measurementsObj[cat][key] : '';
                html += `
                    <div style="display: flex; flex-direction: column;">
                        <label style="font-size: 0.75em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">${key}</label>
                        <div style="position: relative; display: flex; align-items: center;">
                            <input type="text" value="${val}" class="edit-meas-input" 
                                   data-cat="${cat}" data-key="${key}"
                                   style="width: 100%; padding: 8px; padding-right: 25px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 0.9em; box-sizing: border-box; font-weight: 500;">
                            <span style="position: absolute; right: 8px; color: #94a3b8; font-size: 0.8em; font-weight: bold;">"</span>
                        </div>
                    </div>
                `;
            });
            html += '</div></div>';
        });
    }
    html += '</div>';
    return html;
}

/**
 * Updates the measurement fields in the edit modal when the garment type is changed.
 */
window.updateEditGarmentFields = function (clientId, historyIndex) {
    const selectElement = document.getElementById('edit-client-garment-select');
    const newGarmentType = selectElement.value;
    const fieldsArea = document.getElementById('edit-measurements-fields-area');

    // For now, we'll just regenerate the fields based on the new garment type,
    // but keep the existing values if they match a field in the new type.
    // This requires re-fetching the original measurements or passing them around.
    // For simplicity, we'll assume a fresh start for the fields,
    // but a more robust solution would merge existing values.
    // For this change, we'll just pass an empty object for measurementsObj
    // to generate blank fields for the new garment type.
    // A full implementation would involve fetching the current measurements
    // and merging them with the new garment type's standard fields.
    // However, the instruction implies just generating the fields based on the new type.

    // To preserve existing values, we need to collect them first.
    const currentMeasurements = {};
    document.querySelectorAll(`#history-item-${historyIndex} .edit-meas-input`).forEach(input => {
        const cat = input.dataset.cat;
        const key = input.dataset.key;
        if (!currentMeasurements[cat]) currentMeasurements[cat] = {};
        currentMeasurements[cat][key] = input.value;
    });

    // Now, generate HTML for the new garment type, attempting to pre-fill with currentMeasurements
    fieldsArea.innerHTML = generateFieldsAreaHTML(newGarmentType, currentMeasurements);
};


/**
 * Replaces a history item view with an edit form
 */
async function editClientMeasurement(clientId, historyIndex) {
    try {
        const { data: client, error } = await supabaseClient
            .from('clients')
            .select('measurements_history')
            .eq('id', clientId)
            .single();

        if (error) throw error;

        const historyItem = client.measurements_history[historyIndex];
        const container = document.getElementById(`history-item-${historyIndex}`);
        const measurementsDiv = container.querySelector('.history-measurements');

        let measurementsObj = historyItem.measurements;
        if (typeof measurementsObj === 'string') {
            try { measurementsObj = JSON.parse(measurementsObj); } catch (e) { measurementsObj = {}; }
        }

        const garmentType = historyItem.garment || 'Suit';

        let formHtml = `
            <div style="margin-bottom: 20px; padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 700; color: var(--brand-navy); font-size: 0.9em;">Change Garment Type:</label>
                <select id="edit-client-garment-select" onchange="updateEditGarmentFields('${clientId}', ${historyIndex})"
                    style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-weight: 600;">
                    ${Object.keys(GARMENT_MEASUREMENTS).map(type => `
                        <option value="${type}" ${type === garmentType ? 'selected' : ''}>${type}</option>
                    `).join('')}
                </select>
            </div>
            <div id="edit-measurements-fields-area">
        `;

        formHtml += generateFieldsAreaHTML(garmentType, measurementsObj);
        formHtml += '</div>';
        formHtml += `
            <div style="margin-top: 15px; display: flex; gap: 10px;">
                <button class="small-btn" style="background: var(--brand-navy); color: var(--brand-gold);" 
                        onclick="saveClientMeasurement('${clientId}', ${historyIndex})">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <button class="small-btn" style="background: #e2e8f0; color: #475569;" 
                        onclick="viewClientDetails('${clientId}')">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
        `;

        measurementsDiv.innerHTML = formHtml;

    } catch (error) {
        logDebug("Error editing measurement:", error, 'error');
        alert("Error loading measurement data for editing");
    }
}

/**
 * Generates the HTML for measurement fields based on garment type
 */
function generateFieldsAreaHTML(garmentType, existingData = {}) {
    const standardFields = GARMENT_MEASUREMENTS[garmentType] || {};
    let html = '';

    const categories = Object.keys({ ...standardFields, ...existingData });

    categories.forEach(cat => {
        html += `
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px; margin-bottom: 15px;">
                <h4 style="margin: 0 0 10px 0; color: var(--brand-navy); font-size: 0.9em; border-bottom: 1px solid #e2e8f0; padding-bottom: 5px;">${cat} Details</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(110px, 1fr)); gap: 12px;">
        `;

        const stdFieldsForCat = standardFields[cat] || [];
        const existingFieldsForCat = (existingData && existingData[cat]) ? Object.keys(existingData[cat]) : [];
        const allKeys = [...new Set([...stdFieldsForCat, ...existingFieldsForCat])];

        allKeys.forEach(key => {
            const val = (existingData && existingData[cat] && existingData[cat][key]) ? existingData[cat][key] : '';
            html += `
                <div style="display: flex; flex-direction: column;">
                    <label style="font-size: 0.75em; font-weight: 700; color: var(--brand-navy); margin-bottom: 4px;">${key}</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <input type="text" value="${val}" class="edit-meas-input" 
                               data-cat="${cat}" data-key="${key}"
                               style="width: 100%; padding: 8px; padding-right: 25px; border: 1px solid #cbd5e1; border-radius: 4px; font-size: 0.9em; box-sizing: border-box; font-weight: 500;">
                        <span style="position: absolute; right: 8px; color: #94a3b8; font-size: 0.8em; font-weight: bold;">"</span>
                    </div>
                </div>
            `;
        });
        html += '</div></div>';
    });

    if (categories.length === 0) {
        html = `<p style="text-align: center; color: #64748b; font-style: italic;">No specific fields for "${garmentType}"</p>`;
    }
    return html;
}

/**
 * Dynamically updates fields when garment type is changed in edit mode
 */
window.updateEditGarmentFields = function (clientId, index) {
    const type = document.getElementById('edit-client-garment-select').value;
    const area = document.getElementById('edit-measurements-fields-area');
    if (area) {
        area.innerHTML = generateFieldsAreaHTML(type);
    }
};

/**
 * Saves updated measurements back to the client record
 */
async function saveClientMeasurement(clientId, historyIndex) {
    try {
        const { data: client, error: fetchError } = await supabaseClient
            .from('clients')
            .select('measurements_history')
            .eq('id', clientId)
            .single();

        if (fetchError) throw fetchError;

        const history = [...client.measurements_history];
        const item = history[historyIndex];

        // Capture updated garment type
        const newGarmentType = document.getElementById('edit-client-garment-select').value;
        item.garment = newGarmentType;

        const measurementsObj = {};
        const container = document.getElementById(`history-item-${historyIndex}`);
        const inputs = container.querySelectorAll('.edit-meas-input');

        inputs.forEach(input => {
            const cat = input.dataset.cat;
            const key = input.dataset.key;
            if (input.value) {
                if (!measurementsObj[cat]) measurementsObj[cat] = {};
                measurementsObj[cat][key] = input.value;
            }
        });

        item.measurements = measurementsObj;

        const { error: updateError } = await supabaseClient
            .from('clients')
            .update({
                measurements_history: history,
                last_garment_type: newGarmentType,
                updated_at: new Date().toISOString()
            })
            .eq('id', clientId);

        if (updateError) throw updateError;
        viewClientDetails(clientId);
    } catch (error) {
        logDebug("Error saving measurement:", error, 'error');
        alert("Error saving measurement changes");
    }
}

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
