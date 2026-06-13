// ==========================================
// 💬 MESSAGING & NOTIFICATIONS MODULE
// Extracted from app.js
// ==========================================

async function checkUnreadMessages() {
    if (typeof USER_PROFILE === 'undefined' || !USER_PROFILE || USER_PROFILE.role === 'client') return;

    try {
        let shopIds = [];
        if (USER_PROFILE.role === 'owner' || USER_PROFILE.role === 'superadmin') {
            const { data: shops } = await supabaseClient.from('shops').select('id').eq('organization_id', USER_PROFILE.organization_id);
            shopIds = shops ? shops.map(s => s.id) : [];
        } else if (USER_PROFILE.role === 'manager') {
            shopIds = [USER_PROFILE.shop_id];
        }

        if (shopIds.length === 0) return;

        const { data: inquiries } = await supabaseClient
            .from('marketplace_inquiries')
            .select('id')
            .in('shop_id', shopIds);
        
        const inquiryIds = inquiries ? inquiries.map(i => i.id) : [];
        if (inquiryIds.length === 0) return;

        const { data: messages } = await supabaseClient
            .from('messages')
            .select('created_at')
            .in('inquiry_id', inquiryIds.slice(0, 500)) // Safe limit
            .neq('sender_id', USER_PROFILE.id)
            .order('created_at', { ascending: false })
            .limit(1);

        if (messages && messages.length > 0) {
            const latestMsgTime = new Date(messages[0].created_at).getTime();
            const lastViewedStr = localStorage.getItem('last_inbox_view_' + USER_PROFILE.id);
            const lastViewedTime = lastViewedStr ? parseInt(lastViewedStr) : 0;
            
            const navMsg = document.getElementById('nav-messages');
            const navDropdown = document.getElementById('nav-clients-dropdown');
            
            if (latestMsgTime > lastViewedTime) {
                if (navMsg && !navMsg.querySelector('.msg-badge')) {
                    const badge = document.createElement('span');
                    badge.className = 'msg-badge';
                    badge.style.cssText = 'background:#ef4444; color:white; font-size:0.75em; padding:2px 6px; border-radius:10px; margin-left:6px; font-weight:bold; vertical-align:middle;';
                    badge.textContent = 'NEW';
                    navMsg.appendChild(badge);
                }
                if (navDropdown && !navDropdown.querySelector('.msg-badge-outer')) {
                    const outerBadge = document.createElement('span');
                    outerBadge.className = 'msg-badge-outer';
                    outerBadge.style.cssText = 'background:#ef4444; color:white; font-size:0.65em; width:8px; height:8px; border-radius:50%; margin-left:6px; display:inline-block; vertical-align:middle; animation: pulse 2s infinite;';
                    const spanEl = navDropdown.querySelector('span');
                    if (spanEl) spanEl.appendChild(outerBadge);
                }
            } else {
                if (navMsg) {
                    const badge = navMsg.querySelector('.msg-badge');
                    if (badge) badge.remove();
                }
                if (navDropdown) {
                    const outerBadge = navDropdown.querySelector('.msg-badge-outer');
                    if (outerBadge) outerBadge.remove();
                }
            }
        }
    } catch (err) {
        console.warn("Error checking unread messages:", err);
    }
}

