
// ==========================================
// 🪟 GLOBAL UI MODALS
// ==========================================
function showMngModal({ icon, title, text, buttons }) {
    const modal = document.getElementById('mng-modal');
    if (!modal) return;

    document.getElementById('mng-modal-icon').innerHTML = icon;
    document.getElementById('mng-modal-title').textContent = title;
    document.getElementById('mng-modal-text').textContent = text;
    
    const actions = document.getElementById('mng-modal-actions');
    actions.innerHTML = '';
    
    buttons.forEach(btn => {
        const b = document.createElement('button');
        b.className = 'small-btn';
        b.style.cssText = btn.style || '';
        b.innerHTML = btn.text;
        b.onclick = () => {
            if (btn.action) btn.action();
            if (!btn.keepOpen) hideMngModal();
        };
        actions.appendChild(b);
    });

    modal.classList.add('active');
}

function hideMngModal() {
    const modal = document.getElementById('mng-modal');
    if (modal) modal.classList.remove('active');
}
