const fs = require('fs');
const path = require('path');

const filePath = 'c:/Users/ronny/Desktop/tailors project/app.js';
let content = fs.readFileSync(filePath, 'utf8');

// 1. Sidebar Dropdown double-trigger prevention fix
const dropdownOld = `window.toggleSidebarDropdown = function(button) {
    const dropdown = button.closest('.sidebar-dropdown');
    if (dropdown) {
        dropdown.classList.toggle('open');
    }
};`;

const dropdownNew = `window.toggleSidebarDropdown = function(button) {
    const event = window.event || (arguments.length > 1 ? arguments[1] : null);
    if (event) {
        event.alreadyHandledDropdown = true;
    }
    const dropdown = button.closest('.sidebar-dropdown');
    if (dropdown) {
        dropdown.classList.toggle('open');
    }
};

document.addEventListener('click', function(e) {
    const trigger = e.target.closest('.dropdown-trigger');
    if (trigger) {
        e.preventDefault();
        if (e.alreadyHandledDropdown) {
            return;
        }
        e.alreadyHandledDropdown = true;
        window.toggleSidebarDropdown(trigger);
    }
});`;

if (content.includes(dropdownOld)) {
    content = content.replace(dropdownOld, dropdownNew);
    console.log("Successfully replaced toggleSidebarDropdown and click listener");
} else {
    // If already modified or line endings differ, we do regex match
    const regex = new RegExp(dropdownOld.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/\s+/g, '\\s+'));
    if (regex.test(content)) {
        content = content.replace(regex, dropdownNew);
        console.log("Successfully replaced toggleSidebarDropdown (regex fallback)");
    } else {
        console.log("toggleSidebarDropdown target not found!");
    }
}

// 2. loadBIAnalytics query join fix
const queryOld = `let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at, shop_id').is('deleted_at', null).eq('organization_id', USER_PROFILE.organization_id);`;
const queryNew = `let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at, shop_id, orders(customer_name, shop_id)').is('deleted_at', null).eq('organization_id', USER_PROFILE.organization_id);`;

if (content.includes(queryOld)) {
    content = content.replace(queryOld, queryNew);
    console.log("Successfully updated loadBIAnalytics Supabase query");
} else {
    const regex = new RegExp(queryOld.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/\s+/g, '\\s+'));
    if (regex.test(content)) {
        content = content.replace(regex, queryNew);
        console.log("Successfully updated loadBIAnalytics Supabase query (regex fallback)");
    } else {
        console.log("loadBIAnalytics query target not found!");
    }
}

// 3. First loadKPIMetrics fix
const firstKpiOld = `async function loadKPIMetrics(shopId) {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount').is('deleted_at', null);
        let ordersQuery = supabaseClient.from('orders').select('id, price, status');
        let expensesQuery = supabaseClient.from('expenses').select('amount');
        let accessoriesQuery = supabaseClient.from('order_accessories').select('price, quantity');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes, accRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery,
            accessoriesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];
        const accessories = accRes.data || [];`;

const firstKpiNew = `async function loadKPIMetrics(shopId) {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at, shop_id').is('deleted_at', null).eq('organization_id', USER_PROFILE.organization_id);
        let ordersQuery = supabaseClient.from('orders').select('id, price, status, created_at, shop_id').eq('organization_id', USER_PROFILE.organization_id);
        let expensesQuery = supabaseClient.from('expenses').select('amount, incurred_at, shop_id').eq('organization_id', USER_PROFILE.organization_id);
        let accessoriesQuery = supabaseClient.from('order_accessories').select('price, quantity, order_id');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes, accRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery,
            accessoriesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];
        
        const orderIds = new Set(orders.map(o => o.id));
        const accessories = (accRes.data || []).filter(a => orderIds.has(a.order_id));`;

// 4. Second loadKPIMetrics fix
const secondKpiOld = `async function loadKPIMetrics(shopId) {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at').is('deleted_at', null).eq('organization_id', USER_PROFILE.organization_id);
        let ordersQuery = supabaseClient.from('orders').select('id, price, status, created_at').eq('organization_id', USER_PROFILE.organization_id);
        let expensesQuery = supabaseClient.from('expenses').select('amount, incurred_at').eq('organization_id', USER_PROFILE.organization_id);
        let accessoriesQuery = supabaseClient.from('order_accessories').select('price, quantity').eq('organization_id', USER_PROFILE.organization_id);

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('orders.shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes, accRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery,
            accessoriesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];
        const accessories = accRes.data || [];`;

const secondKpiNew = `async function loadKPIMetrics(shopId) {
    try {
        let paymentsQuery = supabaseClient.from('payments').select('amount, recorded_at, shop_id').is('deleted_at', null).eq('organization_id', USER_PROFILE.organization_id);
        let ordersQuery = supabaseClient.from('orders').select('id, price, status, created_at, shop_id').eq('organization_id', USER_PROFILE.organization_id);
        let expensesQuery = supabaseClient.from('expenses').select('amount, incurred_at, shop_id').eq('organization_id', USER_PROFILE.organization_id);
        let accessoriesQuery = supabaseClient.from('order_accessories').select('price, quantity, order_id');

        if (shopId !== 'all') {
            paymentsQuery = paymentsQuery.eq('shop_id', shopId);
            ordersQuery = ordersQuery.eq('shop_id', shopId);
            expensesQuery = expensesQuery.eq('shop_id', shopId);
        }

        // Execute queries
        const [paymentsRes, ordersRes, expensesRes, accRes] = await Promise.all([
            paymentsQuery,
            ordersQuery,
            expensesQuery,
            accessoriesQuery
        ]);

        const payments = paymentsRes.data || [];
        const orders = ordersRes.data || [];
        const expenses = expensesRes.data || [];
        
        const orderIds = new Set(orders.map(o => o.id));
        const accessories = (accRes.data || []).filter(a => orderIds.has(a.order_id));`;

function normalize(str) {
    return str.replace(/\r\n/g, '\n').trim();
}

const normContent = normalize(content);
const normFirstOld = normalize(firstKpiOld);

if (normContent.includes(normFirstOld)) {
    const regex = new RegExp(firstKpiOld.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/\s+/g, '\\s+'));
    content = content.replace(regex, firstKpiNew);
    console.log("Successfully updated first loadKPIMetrics function");
} else {
    console.log("First loadKPIMetrics target not found!");
}

const normSecondOld = normalize(secondKpiOld);
if (normContent.includes(normSecondOld)) {
    const regex = new RegExp(secondKpiOld.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&').replace(/\s+/g, '\\s+'));
    content = content.replace(regex, secondKpiNew);
    console.log("Successfully updated second loadKPIMetrics function");
} else {
    console.log("Second loadKPIMetrics target not found!");
}

fs.writeFileSync(filePath, content, 'utf8');
console.log("app.js updated successfully!");
