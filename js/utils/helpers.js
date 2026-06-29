
// ==========================================
// 🛠️ UTILITY FUNCTIONS
// ==========================================
window.logDebug = (msg, data = null, type = 'info') => {
    const timestamp = new Date().toLocaleTimeString();
    console.log(`[${timestamp}] ${type.toUpperCase()}: ${msg}`, data || '');
};

function formatCurrency(amount) {
    const num = parseFloat(amount) || 0;
    const symbol = (typeof CURRENCY !== 'undefined') ? CURRENCY : 'Ksh';
    return `${symbol} ${num.toLocaleString('en-US', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    })}`;
}

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

function escapeHTML(str) {
    if (!str) return '';
    return str.toString()
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
}

// ==========================================
// 📱 MODAL BACK-BUTTON HANDLER
// ==========================================
document.addEventListener('DOMContentLoaded', () => {
    // Watch for modal open/close to push/pop history states
    const observer = new MutationObserver((mutations) => {
        mutations.forEach(mutation => {
            if (mutation.attributeName === 'style') {
                const el = mutation.target;
                if (el.classList && el.classList.contains('modal')) {
                    const isVisible = el.style.display === 'block' || el.style.display === 'flex';
                    
                    if (isVisible && !el.dataset.modalOpen) {
                        // Modal just opened
                        el.dataset.modalOpen = 'true';
                        // Push dummy state to capture back button
                        history.pushState({ modalOpen: el.id || 'unnamed-modal' }, '');
                    } 
                    else if (!isVisible && el.dataset.modalOpen === 'true') {
                        // Modal just closed programmatically (e.g. X button)
                        el.dataset.modalOpen = 'false';
                        // If current history state is our dummy state, pop it to clean up history
                        if (history.state && history.state.modalOpen) {
                            history.back();
                        }
                    }
                }
            }
        });
    });

    // Attach observer to all existing modals
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        observer.observe(modal, { attributes: true, attributeFilter: ['style'] });
    });

    // Intercept hardware/browser back button
    window.addEventListener('popstate', (e) => {
        // If back button is pressed, history state pops. 
        // We find any open modals and forcefully close them.
        const openModals = document.querySelectorAll('.modal[data-modal-open="true"]');
        openModals.forEach(modal => {
            modal.style.display = 'none';
            modal.dataset.modalOpen = 'false';
        });
    });
});
