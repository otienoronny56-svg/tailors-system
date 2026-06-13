
// ==========================================
// 🌙 DARK MODE SYSTEM
// ==========================================
function initTheme() {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        document.body.classList.add('dark-mode');
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
initTheme();
