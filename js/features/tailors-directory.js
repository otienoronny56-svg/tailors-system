// js/features/tailors-directory.js

let allTailorsData = [];
let allShopsData = [];
let currentViewingTailorId = null;

async function loadTailorsDirectoryPage() {
    const grid = document.getElementById('tailors-grid');
    if (!grid) return;
    
    grid.innerHTML = '<div style="text-align:center;padding:50px;color:#94a3b8;grid-column:1/-1;"><i class="fas fa-spinner fa-spin" style="font-size:2em;margin-bottom:15px;"></i><p>Loading tailors directory...</p></div>';
    
    try {
        if (typeof window.supabaseClient === 'undefined' || typeof USER_PROFILE === 'undefined' || !USER_PROFILE) {
            setTimeout(loadTailorsDirectoryPage, 800);
            return;
        }
        const orgId = USER_PROFILE.organization_id;

        const [{ data: shops }, { data: workers }, { data: managers }, { data: activeOrders }] = await Promise.all([
            window.supabaseClient.from('shops').select('id, name').eq('organization_id', orgId).order('name'),
            window.supabaseClient.from('workers').select('*').eq('organization_id', orgId).order('name'),
            window.supabaseClient.from('user_profiles').select('id, full_name, shop_id').eq('organization_id', orgId).eq('role', 'manager'),
            window.supabaseClient.from('orders').select('worker_id, additional_workers').eq('organization_id', orgId).lt('status', 4)
        ]);

        allShopsData = shops || [];
        
        let workloads = {};
        if (activeOrders) {
            activeOrders.forEach(o => {
                if (o.worker_id) {
                    workloads[o.worker_id] = (workloads[o.worker_id] || 0) + 1;
                }
                if (o.additional_workers && Array.isArray(o.additional_workers)) {
                    o.additional_workers.forEach(wId => {
                        workloads[wId] = (workloads[wId] || 0) + 1;
                    });
                }
            });
        }
        
        allTailorsData = (workers || []).map(w => {
            w.activeWorkload = workloads[w.id] || 0;
            return w;
        });

        // Populate shop filter
        const filterSelect = document.getElementById('tailor-shop-filter');
        if (filterSelect && filterSelect.options.length <= 1) {
            allShopsData.forEach(shop => {
                const opt = document.createElement('option');
                opt.value = shop.id;
                opt.textContent = shop.name;
                filterSelect.appendChild(opt);
            });
        }
        
        // Populate edit modal shop select
        const editShopSelect = document.getElementById('edit-tailor-shop');
        if (editShopSelect) {
            editShopSelect.innerHTML = allShopsData.map(s => `<option value="${s.id}">${s.name}</option>`).join('');
        }

        renderTailorsGrid();

        // Check if we need to auto-open a specific tailor from a dashboard link
        const urlParams = new URLSearchParams(window.location.search);
        const viewId = urlParams.get('view');
        if (viewId) {
            // Give it a tiny delay to ensure DOM is ready
            setTimeout(() => openTailorDetails(viewId), 200);
        }

    } catch (err) {
        console.error("Error loading tailors directory:", err);
        grid.innerHTML = `<div style="color:#ef4444;text-align:center;grid-column:1/-1;padding:30px;"><i class="fas fa-exclamation-triangle fa-2x"></i><p>Failed to load directory. Please refresh.</p></div>`;
    }
}

function filterTailors() {
    renderTailorsGrid();
}

function renderTailorsGrid() {
    const grid = document.getElementById('tailors-grid');
    if (!grid) return;

    const shopFilter = document.getElementById('tailor-shop-filter')?.value || 'all';
    const searchQuery = (document.getElementById('tailor-search')?.value || '').toLowerCase();

    let filtered = allTailorsData;
    if (shopFilter !== 'all') {
        filtered = filtered.filter(w => w.shop_id === shopFilter);
    }
    if (searchQuery) {
        filtered = filtered.filter(w => 
            w.name.toLowerCase().includes(searchQuery) || 
            (w.phone_number && w.phone_number.includes(searchQuery))
        );
    }

    if (filtered.length === 0) {
        grid.innerHTML = '<div style="text-align:center;padding:50px;color:#94a3b8;grid-column:1/-1;"><p>No tailors found matching your filters.</p></div>';
        return;
    }

    const shopMap = {};
    allShopsData.forEach(s => shopMap[s.id] = s.name);

    let tableHtml = `
    <div style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.04); border:1px solid #e2e8f0; overflow:hidden; grid-column: 1/-1;">
        <table style="width:100%; border-collapse:collapse; text-align:left;">
            <thead style="background:#f8fafc; border-bottom:2px solid #e2e8f0;">
                <tr>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase;">Tailor Name</th>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase; text-align:center;">Workload</th>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase;">Assigned Shop</th>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase;">Phone</th>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase;">Role</th>
                    <th style="padding:10px 15px; color:#64748b; font-size:0.85em; font-weight:700; text-transform:uppercase; text-align:right;">Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    tableHtml += filtered.map(w => {
        const initial = w.name ? w.name.substring(0, 2).toUpperCase() : 'T';
        const shopName = shopMap[w.shop_id] || 'Unassigned';
        const role = w.role || 'Tailor';
        const phone = w.phone_number || 'N/A';

        return `
        <tr onclick="openTailorDetails('${w.id}')" style="cursor:pointer; transition:background 0.2s; border-bottom:1px solid #f1f5f9;"
            onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
            
            <td style="padding:10px 15px;">
                <div style="display:flex; align-items:center; gap:12px;">
                    <div style="width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg, var(--brand-navy), #334155); display:flex; align-items:center; justify-content:center; color:var(--brand-gold); font-weight:800; font-size:0.9em; flex-shrink:0;">
                        ${initial}
                    </div>
                    <div>
                        <h3 style="margin:0; color:var(--brand-navy); font-size:1.05em; font-weight:700;">${w.name}</h3>
                    </div>
                </div>
            </td>
            
            <td style="padding:10px 15px; text-align:center;">
                <div style="display:inline-flex; align-items:center; justify-content:center; width:30px; height:30px; border-radius:50%; font-weight:700; font-size:0.85em; ${w.activeWorkload === 0 ? 'background:#f1f5f9; color:#64748b;' : w.activeWorkload < 4 ? 'background:#dcfce7; color:#16a34a;' : w.activeWorkload < 7 ? 'background:#fef3c7; color:#d97706;' : 'background:#fee2e2; color:#dc2626;'}">
                    ${w.activeWorkload}
                </div>
            </td>
            
            <td style="padding:10px 15px; color:#475569; font-size:0.95em;">
                <i class="fas fa-store-alt" style="color:var(--brand-gold); margin-right:6px;"></i> ${shopName}
            </td>
            
            <td style="padding:10px 15px; color:#475569; font-size:0.95em;">
                ${phone}
            </td>
            
            <td style="padding:10px 15px;">
                <span style="font-size:0.75em; color:white; background:#6366f1; padding:4px 10px; border-radius:20px; font-weight:600; white-space:nowrap;">${role}</span>
            </td>
            
            <td style="padding:10px 15px; text-align:right;">
                <i class="fas fa-chevron-right" style="color:#cbd5e1;"></i>
            </td>
            
        </tr>`;
    }).join('');

    tableHtml += `
            </tbody>
        </table>
    </div>`;

    grid.innerHTML = tableHtml;
}

async function openTailorDetails(workerId) {
    currentViewingTailorId = workerId;
    const tailor = allTailorsData.find(w => w.id === workerId);
    if (!tailor) return;

    const modal = document.getElementById('tailor-details-modal');
    modal.style.display = 'flex';
    
    // Set basic info
    const shopMap = {};
    allShopsData.forEach(s => shopMap[s.id] = s.name);
    
    document.getElementById('tdm-avatar').textContent = tailor.name.substring(0, 2).toUpperCase();
    document.getElementById('tdm-name').textContent = tailor.name;
    document.getElementById('tdm-role-shop').textContent = `${tailor.role || 'Tailor'} • ${shopMap[tailor.shop_id] || 'Unassigned Shop'}`;
    document.getElementById('tdm-phone').textContent = tailor.phone_number || 'N/A';
    
    document.getElementById('tdm-works-tbody').innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:#94a3b8;"><i class="fas fa-spinner fa-spin"></i> Loading assigned works...</td></tr>';
    
    // Fetch orders assigned to this worker
    try {
        const { data: orders, error } = await window.supabaseClient.from('orders')
            .select('*')
            .or(`worker_id.eq.${workerId},additional_workers.cs.["${workerId}"]`)
            .order('created_at', { ascending: false });

        if (error) throw error;

        let activeCount = 0;
        let readyCount = 0;

        if (!orders || orders.length === 0) {
            document.getElementById('tdm-works-tbody').innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:#94a3b8;">No orders currently assigned to this tailor.</td></tr>';
        } else {
            document.getElementById('tdm-works-tbody').innerHTML = orders.map(o => {
                // Status mapping based on global app logic
                let statusBadge = '';
                if (o.status < 4) {
                    activeCount++;
                    statusBadge = `<span style="background:#fef3c7;color:#d97706;padding:3px 8px;border-radius:20px;font-size:0.75em;font-weight:700;">In Production (S${o.status})</span>`;
                } else if (o.status === 4) {
                    readyCount++;
                    statusBadge = `<span style="background:#dcfce7;color:#16a34a;padding:3px 8px;border-radius:20px;font-size:0.75em;font-weight:700;">Ready (S4)</span>`;
                } else {
                    readyCount++; // Treat closed as completed work
                    statusBadge = `<span style="background:#f1f5f9;color:#64748b;padding:3px 8px;border-radius:20px;font-size:0.75em;font-weight:700;">Closed (S${o.status})</span>`;
                }

                return `
                <tr style="cursor:pointer; transition:background 0.2s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'" onclick="openReviewModal('${o.id}')">
                    <td style="padding:10px; border-bottom:1px solid #f1f5f9; font-size:0.85em; font-weight:700; color:var(--brand-navy);">#${o.id.substring(0,8)}</td>
                    <td style="padding:10px; border-bottom:1px solid #f1f5f9; font-size:0.85em; color:#475569;">${o.customer_name}</td>
                    <td style="padding:10px; border-bottom:1px solid #f1f5f9; font-size:0.85em; color:#475569;">${o.garment_type}</td>
                    <td style="padding:10px; border-bottom:1px solid #f1f5f9; font-size:0.85em;">${statusBadge}</td>
                </tr>`;
            }).join('');
        }
        
        document.getElementById('tdm-active-count').textContent = activeCount;
        document.getElementById('tdm-ready-count').textContent = readyCount;

    } catch (err) {
        console.error("Error fetching tailor orders:", err);
        document.getElementById('tdm-works-tbody').innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:#ef4444;"><i class="fas fa-exclamation-triangle"></i> Error loading works.</td></tr>';
    }
}

// Ensure the openAdminOrderModal exists, if it does it will be available from orders.js
// If not we might need to handle it. Since we included orders.js it should exist.

function editTailor() {
    if (!currentViewingTailorId) return;
    const tailor = allTailorsData.find(w => w.id === currentViewingTailorId);
    if (!tailor) return;

    document.getElementById('edit-tailor-name').value = tailor.name || '';
    document.getElementById('edit-tailor-phone').value = tailor.phone_number || '';
    document.getElementById('edit-tailor-role').value = tailor.role || 'Tailor';
    document.getElementById('edit-tailor-shop').value = tailor.shop_id || '';

    document.getElementById('edit-tailor-modal').style.display = 'flex';
}

async function saveTailorEdits() {
    if (!currentViewingTailorId) return;
    
    const newName = document.getElementById('edit-tailor-name').value.trim();
    const newPhone = document.getElementById('edit-tailor-phone').value.trim();
    const newRole = document.getElementById('edit-tailor-role').value.trim();
    const newShopId = document.getElementById('edit-tailor-shop').value;

    if (!newName) {
        alert("Name is required.");
        return;
    }

    try {
        const { error } = await window.supabaseClient.from('workers')
            .update({ 
                name: newName, 
                phone_number: newPhone, 
                role: newRole, 
                shop_id: newShopId 
            })
            .eq('id', currentViewingTailorId);
            
        if (error) throw error;
        
        alert("Tailor profile updated successfully.");
        document.getElementById('edit-tailor-modal').style.display = 'none';
        
        // Refresh data
        await loadTailorsDirectoryPage();
        openTailorDetails(currentViewingTailorId);

    } catch (err) {
        console.error("Error updating tailor:", err);
        alert("Failed to update tailor details. Check console.");
    }
}

async function fireTailor() {
    if (!currentViewingTailorId) return;
    const tailor = allTailorsData.find(w => w.id === currentViewingTailorId);
    if (!tailor) return;

    const activeOrdersCount = parseInt(document.getElementById('tdm-active-count').textContent) || 0;
    
    let confirmMsg = `Are you absolutely sure you want to terminate/fire ${tailor.name}? This will remove them from the system permanently.`;
    if (activeOrdersCount > 0) {
        confirmMsg += `\n\nWARNING: They currently have ${activeOrdersCount} ACTIVE assigned orders! Please reassign these works to another tailor before firing.`;
    }
    
    if (!confirm(confirmMsg)) return;

    try {
        const { error } = await window.supabaseClient.from('workers').delete().eq('id', currentViewingTailorId);
        if (error) throw error;

        alert(`${tailor.name} has been removed from the system.`);
        document.getElementById('tailor-details-modal').style.display = 'none';
        currentViewingTailorId = null;
        
        loadTailorsDirectoryPage();

    } catch (err) {
        console.error("Error deleting tailor:", err);
        alert("Failed to remove tailor. They may be referenced in completed orders which prevent deletion due to database constraints.");
    }
}

// Init
(function waitForProfile() {
    if (typeof USER_PROFILE !== 'undefined' && USER_PROFILE && window.supabaseClient) { 
        loadTailorsDirectoryPage(); 
    } else { 
        setTimeout(waitForProfile, 800); 
    }
})();
