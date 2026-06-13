
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
