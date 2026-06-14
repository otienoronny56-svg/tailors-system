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
        let query = supabaseClient.from('clients').select('*').eq('organization_id', USER_PROFILE.organization_id).order('name');

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
                <td>${formatDate(c.last_visit || c.created_at)}</td>
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
                    <div style="display: flex; justify-content: space-between; border-bottom: 2px solid #f1f5f9; padding-bottom: 12px; margin-bottom: 12px; align-items: center; flex-wrap: wrap; gap: 10px;">
                        <span style="font-weight: 800; color: var(--brand-navy); font-size: 1.1em; text-transform: uppercase; letter-spacing: 0.5px;">
                            <i class="fas fa-cut" style="margin-right: 8px; color: var(--brand-gold);"></i>${h.garment}
                        </span>
                        <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                            <span style="color: #64748b; font-size: 0.85em; background: #f1f5f9; padding: 2px 8px; border-radius: 4px; white-space: nowrap;">${formatDate(h.date)}</span>
                            <button class="small-btn" onclick="editClientMeasurement('${client.id}', ${index})" style="background: #f1f5f9; color: var(--brand-navy); border: none;">
                                <i class="fas fa-edit"></i>
                            </button>
                        </div>
                    </div>
                    <div class="history-measurements" style="font-size: 0.95em; line-height: 1.6; display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 10px;">
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
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 10px;">
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
                    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; border-bottom: 2px solid var(--brand-gold); padding-bottom: 5px; margin-bottom: 20px;">
                        <h3 style="font-size: 1.1em; color: var(--brand-navy); font-weight: 700; margin: 0;">Measurement History</h3>
                        <button class="small-btn" onclick="addNewMeasurementProfile('${client.id}')" style="background: var(--brand-navy); color: var(--brand-gold); border: none;">
                            <i class="fas fa-plus"></i> Add Garment
                        </button>
                    </div>
                    <div style="flex: 1; overflow-y: auto; padding-right: 5px;">
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

        const modalContent = modal.querySelector('.modal-content');
        if(modalContent) {
            modalContent.style.width = '100vw';
            modalContent.style.maxWidth = '100vw';
            modalContent.style.height = '100vh';
            modalContent.style.maxHeight = '100vh';
            modalContent.style.display = 'flex';
            modalContent.style.flexDirection = 'column';
            modalContent.style.padding = window.innerWidth <= 768 ? '20px 15px' : '40px 60px'; // Generous padding for desktop, smaller for mobile
            modalContent.style.borderRadius = '0';
            modalContent.style.margin = '0';
            modalContent.style.border = 'none';
            modalContent.style.boxShadow = 'none';
            modalContent.style.overflowY = 'auto';
        }

        modal.style.display = 'block';
        modal.style.padding = '0';
        modal.style.background = '#f8fafc'; // Solid background to act as a full page
        modal.style.zIndex = '99999'; // Ensure it covers everything including sidebar

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
        const form = document.getElementById('new-client-form');
        if (form) form.reset();
        const measContainer = document.getElementById('new-client-measurements-container');
        if (measContainer) measContainer.innerHTML = '';
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
                organization_id: USER_PROFILE.organization_id, // ☝️ Multi-tenant safe
                shop_id: USER_PROFILE.shop_id || null, // ☝️ Enforced for isolated viewing
                name,
                phone,
                notes,
                measurements_history: history,
                last_garment_type: garmentType || null,
                created_at: new Date().toISOString(),
                last_visit: new Date().toISOString()
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
 * Creates a brand new empty measurement profile for a client and opens it in edit mode
 */
window.addNewMeasurementProfile = async function(clientId) {
    try {
        const { data: client, error } = await supabaseClient
            .from('clients')
            .select('*')
            .eq('id', clientId)
            .single();

        if (error) throw error;

        let history = client.measurements_history || [];
        
        // Insert a completely fresh blank measurement profile
        history.unshift({
            date: new Date().toISOString(),
            garment: 'Suit',
            measurements: {}
        });

        // Commit new profile skeleton immediately
        const { error: updateError } = await supabaseClient
            .from('clients')
            .update({
                measurements_history: history,
                last_garment_type: 'Suit',
                last_visit: new Date().toISOString()
            })
            .eq('id', clientId);

        if (updateError) throw updateError;
        
        // Refresh UI and instantly throw the new item into the Edit mode
        await viewClientDetails(clientId);
        setTimeout(() => {
            editClientMeasurement(clientId, 0); 
        }, 150);

    } catch (e) {
        alert("Error adding garment profile: " + e.message);
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
                last_visit: new Date().toISOString()
            })
            .eq('id', clientId);

        if (updateError) throw updateError;
        viewClientDetails(clientId);
    } catch (error) {
        logDebug("Error saving measurement:", error, 'error');
        alert("Error saving measurement changes");
    }
}
