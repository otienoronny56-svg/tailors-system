const fs = require('fs');

const file = 'C:/Users/ronny/Desktop/tailors project/app.js';
let appJs = fs.readFileSync(file, 'utf8');

// 1. Fix formatMeasurements
const oldMeasurements = `        let h = '';
        for (let k in m) {
            h += \`<div style="break-inside: avoid; margin-bottom: 15px;"><b>\${k} Details:</b><br>\`;
            for (let s in m[k]) {
                h += \`<span style="display:inline-block; min-width:80px; color:#475569;">\${s}:</span> <b>\${m[k][s]}"</b><br>\`;
            }
            h += '</div>';
        }`;

const newMeasurements = `        let h = '';
        for (let k in m) {
            h += \`<div style="break-inside: avoid; margin-bottom: 15px; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <b style="color: var(--brand-navy); font-size: 0.9em; text-transform: uppercase; border-bottom: 2px solid var(--brand-gold); padding-bottom: 5px; display: inline-block; margin-bottom: 12px; width: 100%;">\${k} Details</b><br>\`;
            for (let s in m[k]) {
                h += \`<div style="display: flex; justify-content: space-between; border-bottom: 1px dashed #cbd5e1; padding: 6px 0;">
                        <span style="color:#64748b; font-size: 0.95em;">\${s}</span> 
                        <b style="color:var(--brand-navy); font-size: 0.95em;">\${m[k][s]}"</b>
                      </div>\`;
            }
            h += '</div>';
        }`;

appJs = appJs.replace(oldMeasurements, newMeasurements);

// 2. Fix Modal Display for full page style
// I will find the end of viewClientDetails string template:
//                 </div>
//             </div>
//         \`;
//
//         modal.style.display = 'block';

const oldModalDisplay = `                </div>
            </div>
        \`;

        modal.style.display = 'block';`;

const newModalDisplay = `                </div>
            </div>
        \`;

        const modalContent = modal.querySelector('.modal-content');
        if(modalContent) {
            modalContent.style.width = '90%';
            modalContent.style.maxWidth = '1000px';
            modalContent.style.height = '90vh';
            modalContent.style.display = 'flex';
            modalContent.style.flexDirection = 'column';
            modalContent.style.padding = '30px';
            
            const bodyContainer = modalContent.querySelector('#client-details-body').parentElement;
            if (bodyContainer) {
                bodyContainer.style.flex = '1';
                bodyContainer.style.overflowY = 'auto';
            }
        }

        modal.style.display = 'flex';
        modal.style.alignItems = 'center';
        modal.style.justifyContent = 'center';`;

appJs = appJs.replace(oldModalDisplay, newModalDisplay);

fs.writeFileSync(file, appJs);
console.log('Successfully patched formatMeasurements and modal display in app.js');
