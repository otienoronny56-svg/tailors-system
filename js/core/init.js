
// ==========================================
// 🛡️ SYSTEM INITIALIZATION
// ==========================================
let supabaseClient = null;

try {
    if (typeof APP_CONFIG === 'undefined') {
        throw new Error("CRITICAL: 'config.js' is missing or has a syntax error.");
    }

    if (typeof window.supabase === 'undefined' || typeof window.supabase.createClient !== 'function') {
        throw new Error("CRITICAL: Supabase library failed to load.");
    }

    supabaseClient = window.supabase.createClient(APP_CONFIG.supabaseUrl, APP_CONFIG.supabaseKey);
    window.supabaseClient = supabaseClient;

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

const SHOP_CONTACT = (typeof APP_CONFIG !== 'undefined') ? APP_CONFIG.shopPhone : "";
const CURRENCY = (typeof APP_CONFIG !== 'undefined') ? APP_CONFIG.currencySymbol : "Ksh";

function getAdminClient() {
    if (!APP_CONFIG.serviceRoleKey) {
        console.error("❌ CRITICAL: Service Role Key missing in config.js");
        alert("Admin Error: You need the 'serviceRoleKey' in config.js to create users.");
        return null;
    }
    return window.supabase.createClient(APP_CONFIG.supabaseUrl, APP_CONFIG.serviceRoleKey, {
        auth: {
            persistSession: false,
            autoRefreshToken: false,
            detectSessionInUrl: false
        }
    });
}
