const fs = require('fs');
const path = require('path');

// 1. Fix admin-clients.html
const adminClientsPath = path.join(__dirname, 'admin-clients.html');
let adminHtml = fs.readFileSync(adminClientsPath, 'utf8');
adminHtml = adminHtml.replace('<body>`n    <div class="mobile-menu-btn"', '<body>\n    <div class="mobile-menu-btn"');
fs.writeFileSync(adminClientsPath, adminHtml);
console.log('Fixed admin-clients.html');

// 2. Fix app.js
const appJsPath = path.join(__dirname, 'app.js');
let appJs = fs.readFileSync(appJsPath, 'utf8');

const targetMeasurements = `        for (let k in m) {
            h += \`<div style="break-inside: avoid; margin-bottom: 15px;"><b>\${k} Details:</b><br>\`;
            for (let s in m[k]) {
                h += \`<span style="display:inline-block; min-width:80px; color:#475569;">\${s}:</span> <b>\${m[k][s]}"</b><br>\`;
            }
            h += '</div>';
        }`;

const replacementMeasurements = `        for (let k in m) {
            h += \`<div style="break-inside: avoid; margin-bottom: 15px; background: #f8fafc; padding: 12px; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <b style="color: var(--brand-navy); font-size: 0.9em; text-transform: uppercase; border-bottom: 2px solid var(--brand-gold); padding-bottom: 3px; display: inline-block; margin-bottom: 10px;">\${k} Details</b><br>\`;
            for (let s in m[k]) {
                h += \`<div style="display: flex; justify-content: space-between; border-bottom: 1px dashed #cbd5e1; padding: 6px 0;">
                        <span style="color:#64748b; font-size: 0.95em;">\${s}</span> 
                        <b style="color:var(--brand-navy); font-size: 0.95em;">\${m[k][s]}"</b>
                      </div>\`;
            }
            h += '</div>';
        }`;

appJs = appJs.replace(targetMeasurements, replacementMeasurements);

const targetModal = `        modal.style.display = 'block';

    } catch (error) {
        logDebug("Error viewing client details:", error, 'error');`;

const replacementModal = `        modal.style.display = 'flex';
        modal.style.alignItems = 'center';
        modal.style.justifyContent = 'center';
        content.style.maxHeight = '90vh';
        content.style.overflowY = 'auto';
        content.style.width = '600px';
        content.style.maxWidth = '95%';
        content.style.borderRadius = '12px';

    } catch (error) {
        logDebug("Error viewing client details:", error, 'error');`;

appJs = appJs.replace(targetModal, replacementModal);

fs.writeFileSync(appJsPath, appJs);
console.log('Fixed app.js safely');
