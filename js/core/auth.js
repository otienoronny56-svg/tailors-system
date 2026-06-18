// ==========================================
// ðŸ” AUTHENTICATION SYSTEM
// ==========================================

async function checkSession() {
    logDebug("Checking session...", null, 'info');

    try {
        const path = window.location.pathname;
        const { data: { session }, error: sessionError } = await supabaseClient.auth.getSession();
        const user = session?.user;
        if (sessionError || !user) {
            const isPublicPage = window.location.pathname.includes('index.html') || window.location.pathname.includes('login.html') || window.location.pathname.endsWith('/');
            if (!isPublicPage && window.location.pathname !== '/') {
                window.location.href = '/index.html';
            }
            return;
        }

        // [PERF] Try to load profile from sessionStorage first for instant navigation
        const cachedProfileData = sessionStorage.getItem('USER_PROFILE_' + user.id);
        if (cachedProfileData) {
            try {
                const tempProfile = JSON.parse(cachedProfileData);
                // If the cached profile is Pending, bypass cache to fetch the latest status from DB
                if (tempProfile && tempProfile.status !== 'Pending') {
                    USER_PROFILE = tempProfile;
                    logDebug("Loaded user profile from cache", null, 'info');
                }
            } catch(e) {}
        }

        if (!USER_PROFILE) {
        // Try to get profile from user_profiles table
        const { data: profile, error: profileError } = await supabaseClient
            .from('user_profiles')
            .select('*')
            .eq('id', user.id)
            .single();

        if (profileError || !profile) {
            if (profileError && profileError.code !== 'PGRST116') {
                logDebug("Profile lookup error", profileError, 'error');
                throw new Error("Profile Lookup Error: " + profileError.message);
            }
            // Fallback to workers table
            const { data: workerProfile, error: workerError } = await supabaseClient
                .from('workers')
                .select('*')
                .eq('id', user.id)
                .single();

            if (workerError || !workerProfile) {
                if (workerError && workerError.code !== 'PGRST116') {
                    logDebug("Worker lookup error", workerError, 'error');
                    throw new Error("Worker Lookup Error: " + workerError.message);
                }
                // No profile found anywhere.
                // If we are on the onboarding page, that is expected â€” let the user proceed.
                if (path.includes('tailor-onboarding')) {
                    logDebug("No profile yet â€” user is completing onboarding. Allowing.", null, 'info');
                    return;
                }
                
                // Redirect to role selection page if no profile exists
                logDebug("Profile not found. Redirecting to choose-role.html...", null, 'info');
                window.location.href = '/choose-role.html';
                return;
            } else {
                USER_PROFILE = {
                    ...workerProfile,
                    full_name: workerProfile.name,
                    role: 'manager'
                };
            }
        } else {
            USER_PROFILE = profile;
        }

        // [PERF] Cache the loaded profile
        if (USER_PROFILE) {
            sessionStorage.setItem('USER_PROFILE_' + user.id, JSON.stringify(USER_PROFILE));
        }
        } // End of if (!USER_PROFILE)

        // 🛑 NEW: Check for pending shop owner approval (Enforcement)
        if (USER_PROFILE.status === 'Pending' && USER_PROFILE.role === 'owner') {
            document.body.innerHTML = `
                <div style="height: 100vh; display: flex; align-items: center; justify-content: center; background: #060c18; font-family: 'Montserrat', sans-serif; color: white;">
                    <div style="text-align: center; background: rgba(17, 34, 64, 0.75); border: 1px solid rgba(212, 175, 55, 0.15); padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); max-width: 450px; backdrop-filter: blur(10px);">
                        <div style="font-size: 50px; color: #D4AF37; margin-bottom: 20px;"><i class="fas fa-store-slash"></i></div>
                        <h1 style="color: var(--brand-gold); margin-bottom: 15px; font-family: 'Playfair Display', serif;">Awaiting Admin Approval</h1>
                        <p style="color: var(--brand-slate); line-height: 1.6; margin-bottom: 25px;">
                            We are setting up your shop! ✂️<br>
                            Our team is currently verifying your shop details. We will notify you as soon as you are approved (usually within a few hours).
                        </p>
                        <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); padding: 15px; border-radius: 8px; margin-bottom: 25px; font-size: 0.95em; text-align: left;">
                            <strong style="color: var(--brand-gold);">Shop Owner:</strong> ${USER_PROFILE.full_name || ''}<br>
                            <strong style="color: var(--brand-gold);">Email:</strong> ${USER_PROFILE.email || ''}
                        </div>
                        <button onclick="supabaseClient.auth.signOut().then(() => { sessionStorage.clear(); location.href='/index.html'; })" class="small-btn" style="width: 100%; background: #ef4444; color: white; border: none; font-weight: bold; cursor: pointer; padding: 12px; border-radius: 8px; font-size: 1em;">Logout</button>
                    </div>
                </div>
            `;
            return;
        }

        // 🛑 NEW: Check for suspension (Enforcement)
        if (USER_PROFILE.status === 'Suspended') {
            document.body.innerHTML = `
                <div style="height: 100vh; display: flex; align-items: center; justify-content: center; background: #f8fafc; font-family: 'Inter', sans-serif;">
                    <div style="text-align: center; background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); max-width: 450px;">
                        <div style="font-size: 50px; color: #ef4444; margin-bottom: 20px;"><i class="fas fa-lock"></i></div>
                        <h1 style="color: #1e293b; margin-bottom: 15px;">Account Suspended</h1>
                        <p style="color: #64748b; line-height: 1.6; margin-bottom: 25px;">
                            Your access to the platform has been temporarily paused. This could be due to billing issues or a policy violation.
                        </p>
                        <div style="background: #f1f5f9; padding: 15px; border-radius: 8px; margin-bottom: 25px;">
                            <strong style="color: #334155;">Need help?</strong><br>
                            <a href="mailto:support@otima.com" style="color: var(--brand-navy); font-weight: 700;">support@otima.com</a>
                        </div>
                        <button onclick="supabaseClient.auth.signOut().then(() => location.href='/index.html')" class="small-btn" style="width: 100%; background: #ef4444; color: white;">Logout</button>
                    </div>
                </div>
            `;
            return;
        }

        // 🛑 NEW: Check for organization suspension (Enforcement)
        if (USER_PROFILE.organization_id && USER_PROFILE.role !== 'superadmin') {
            const cachedOrgStatus = sessionStorage.getItem('ORG_STATUS_' + USER_PROFILE.organization_id);
            let isOrgSuspended = cachedOrgStatus === 'Suspended';
            
            if (!cachedOrgStatus) {
                const { data: org, error: orgError } = await supabaseClient
                    .from('organizations')
                    .select('subscription_status')
                    .eq('id', USER_PROFILE.organization_id)
                    .single();
                if (!orgError && org) {
                    sessionStorage.setItem('ORG_STATUS_' + USER_PROFILE.organization_id, org.subscription_status);
                    isOrgSuspended = org.subscription_status === 'Suspended';
                }
            }

            if (isOrgSuspended) {
                document.body.innerHTML = `
                    <div style="height: 100vh; display: flex; align-items: center; justify-content: center; background: #060c18; font-family: 'Montserrat', sans-serif; color: white;">
                        <div style="text-align: center; background: rgba(17, 34, 64, 0.75); border: 1px solid rgba(212, 175, 55, 0.15); padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); max-width: 450px;">
                            <div style="font-size: 50px; color: #ef4444; margin-bottom: 20px;"><i class="fas fa-exclamation-triangle"></i></div>
                            <h1 style="color: var(--brand-gold); margin-bottom: 15px; font-family: 'Playfair Display', serif;">Workspace Suspended</h1>
                            <p style="color: var(--brand-slate); line-height: 1.6; margin-bottom: 25px;">
                                Your organization has been suspended. Please contact platform administration to reactivate your workspace.
                            </p>
                            <button onclick="supabaseClient.auth.signOut().then(() => { sessionStorage.clear(); location.href='/index.html'; })" class="small-btn" style="width: 100%; background: #ef4444; color: white; border: none; font-weight: bold; cursor: pointer;">Logout</button>
                        </div>
                    </div>
                `;
                return;
            }
        }

        // 🛑 NEW: Check for shop suspension (Enforcement)
        if (USER_PROFILE.shop_id && USER_PROFILE.role !== 'superadmin') {
            const cachedShopStatus = sessionStorage.getItem('SHOP_STATUS_' + USER_PROFILE.shop_id);
            let isShopSuspended = cachedShopStatus === 'Suspended';
            
            if (!cachedShopStatus) {
                const { data: shop, error: shopError } = await supabaseClient
                    .from('shops')
                    .select('status')
                    .eq('id', USER_PROFILE.shop_id)
                    .single();
                if (!shopError && shop) {
                    sessionStorage.setItem('SHOP_STATUS_' + USER_PROFILE.shop_id, shop.status || 'Active');
                    isShopSuspended = shop.status === 'Suspended';
                }
            }

            if (isShopSuspended) {
                document.body.innerHTML = `
                    <div style="height: 100vh; display: flex; align-items: center; justify-content: center; background: #060c18; font-family: 'Montserrat', sans-serif; color: white;">
                        <div style="text-align: center; background: rgba(17, 34, 64, 0.75); border: 1px solid rgba(212, 175, 55, 0.15); padding: 40px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); max-width: 450px;">
                            <div style="font-size: 50px; color: #ef4444; margin-bottom: 20px;"><i class="fas fa-store-alt-slash"></i></div>
                            <h1 style="color: var(--brand-gold); margin-bottom: 15px; font-family: 'Playfair Display', serif;">Shop Suspended</h1>
                            <p style="color: var(--brand-slate); line-height: 1.6; margin-bottom: 25px;">
                                Your specific shop has been suspended by administration. Please contact support.
                            </p>
                            <button onclick="supabaseClient.auth.signOut().then(() => { sessionStorage.clear(); location.href='/index.html'; })" class="small-btn" style="width: 100%; background: #ef4444; color: white; border: none; font-weight: bold; cursor: pointer;">Logout</button>
                        </div>
                    </div>
                `;
                return;
            }
        }

        logDebug(`User authenticated: ${USER_PROFILE.full_name} (${USER_PROFILE.role})`, USER_PROFILE, 'success');

        // Update UI
        const userInfoEl = document.getElementById('user-info');
        if (userInfoEl) {
            userInfoEl.innerHTML = `<i class="fas fa-user-circle" style="margin-right: 8px; color: var(--brand-gold);"></i> Welcome, ${USER_PROFILE.full_name}`;
        }

        // [FIX] Check for 'index.html', 'login.html', OR if the path is just '/' (root)
        // Also skip redirect logic entirely if we are on the tailor-onboarding page
        if (path.includes('tailor-onboarding')) {
            // On the onboarding page: if a COMPLETED profile already exists, redirect to their dashboard.
            // If status is Pending or incomplete, stay here and let them complete the form.
            if (USER_PROFILE && USER_PROFILE.status !== 'Pending' && USER_PROFILE.organization_id) {
                let redirectTo = '/views/admin/admin-dashboard.html';
                if (USER_PROFILE.role === 'client') redirectTo = '/views/client/client-dashboard.html';
                window.location.href = redirectTo;
            }
            return; // Always stop here â€” let the onboarding page handle itself
        }

        if (path.includes('index.html') || path.includes('login.html') || path === '/' || path.endsWith('/')) {
            let redirectTo = '/views/manager/manager-dashboard.html';
            if (USER_PROFILE.role === 'superadmin') redirectTo = '/views/superadmin/superadmin-dashboard.html';
            else if (USER_PROFILE.role === 'owner') redirectTo = '/views/admin/admin-dashboard.html';
            else if (USER_PROFILE.role === 'client') redirectTo = '/views/client/client-dashboard.html';
            
            window.location.href = redirectTo;
            return;
        }

        // Route based on role and page
        await routeToPage(path);
        
        // Update user activity status (Heartbeat)
        if (USER_PROFILE) {
            updateLastSeen();
        }

        // Final UI Updates
        updateSidebarBranding();
        
        // Start unread messages polling
        checkUnreadMessages();
        if (!window._inboxPollInterval) {
            window._inboxPollInterval = setInterval(checkUnreadMessages, 60000); // Check every minute
        }
        
        // Start GLOBAL Realtime Notification Listener
        setupGlobalNotificationListener();

    } catch (error) {
        logDebug("Session check error:", error, 'error');
        alert("Session error: " + error.message);
    }
}

let _globalNotificationListener = null;
function setupGlobalNotificationListener() {
    if (!USER_PROFILE || _globalNotificationListener) return;

    if (!("Notification" in window)) return;

    // Only set up for roles that use messages
    if (USER_PROFILE.role !== 'owner' && USER_PROFILE.role !== 'client' && USER_PROFILE.role !== 'superadmin' && USER_PROFILE.role !== 'manager') return;

    // Build filter if needed (clients only care about messages to them)
    let filterString = '';
    if (USER_PROFILE.role === 'client') {
        filterString = `recipient_id=eq.${USER_PROFILE.id}`;
    }

    _globalNotificationListener = window.supabaseClient
        .channel('global-notifications-' + USER_PROFILE.id)
        .on('postgres_changes', {
            event: 'INSERT',
            schema: 'public',
            table: 'messages',
            ...(filterString ? { filter: filterString } : {})
        }, payload => {
            const newMsg = payload.new;
            
            // Ignore messages sent by ourselves
            if (newMsg.sender_id === USER_PROFILE.id) return;
            
            // For admins/managers, make sure the message is relevant
            if (USER_PROFILE.role !== 'client') {
                // To avoid spam, ensure it's not a message from another admin in the same org
                if (newMsg.sender_id === USER_PROFILE.organization_id) return;
            }

            // Immediately update the UI red dots anywhere in the app!
            if (typeof checkUnreadMessages === 'function') {
                checkUnreadMessages();
            }

            // Show OS Notification if page is hidden
            if (document.hidden && Notification.permission === 'granted') {
                const title = USER_PROFILE.role === 'client' ? "New Tailor Message" : "New Client Inquiry";
                const body = newMsg.message_text ? newMsg.message_text.substring(0, 50) + "..." : "You have a new message.";
                
                try {
                    const notif = new Notification(title + " - Tailors", {
                        body: body,
                        icon: '/assets/icon-192x192.png'
                    });
                    notif.onclick = function() {
                        window.focus();
                        this.close();
                        
                        // If not on messages page, redirect them
                        if (!window.location.pathname.includes('messages') && !window.location.pathname.includes('client-dashboard')) {
                            const msgLink = document.getElementById('nav-messages');
                            if (msgLink) msgLink.click();
                        }
                    };
                } catch(e) {
                    console.warn("Failed to show notification:", e);
                }
            }
        })
        .subscribe();
}

async function routeToPage(path) {
    if (!USER_PROFILE) return;

    // Superadmin pages
    if (USER_PROFILE.role === 'superadmin') {
        if (path.includes('superadmin-dashboard')) {
            await loadSuperadminDashboard();
        } else if (path.includes('superadmin-orgs')) {
            await loadOrganizations();
        } else if (path.includes('superadmin-users-list')) {
            await loadPlatformUsers();
        } else if (path.includes('superadmin-users')) {
            await loadAdminAccountScreen();
        }
        return;
    }

    // Owner pages
    if (USER_PROFILE.role === 'owner') {
        if (path.includes('manager') || path.includes('superadmin')) {
            window.location.href = '/views/admin/admin-dashboard.html';
            return;
        }

        if (path.includes('admin-dashboard')) {
            await loadAdminDashboard();
        } else if (path.includes('financial-overview')) {
            await loadAnalyticsDashboard();
        } else if (path.includes('admin-current-orders')) {
            await loadAdminOrders('current');
        } else if (path.includes('admin-orders') && !path.includes('admin-order-details') && !path.includes('admin-order-form')) {
            await loadAdminOrders('current');
        } else if (path.includes('admin-all-orders')) {
            await loadAdminOrders('all');
        } else if (path.includes('admin-expenses')) {
            await loadAdminExpensesScreen();
        } else if (path.includes('admin-inventory')) {
            await loadInventoryScreen();
        } else if (path.includes('admin-clients')) {
            loadClients();
        } else if (path.includes('admin-management')) {
            await loadAdminManagementScreen();
        } else if (path.includes('admin-order-details')) {
            await loadAdminOrderDetails();
        } else if (path.includes('admin-order-form')) {
            initAdminOrderForm();
        } else if (path.includes('admin-analytics')) {
            loadBIAnalytics();
        }
    }
    // Manager pages
    else {
        if (path.includes('admin-')) {
            window.location.href = '/views/manager/manager-dashboard.html';
            return;
        }

        if (path.includes('manager-dashboard')) {
            await loadOrders('open');
            await loadWorkerFilterDropdown();
            addRefreshButton();
        } else if (path.includes('all-orders')) {
            await loadOrders('all');
            await loadWorkerFilterDropdown();
            addRefreshButton();
        } else if (path.includes('worker-management')) {
            await loadWorkerScreen();
        } else if (path.includes('worker-assignments')) {
            await loadWorkerAssignments();
        } else if (path.includes('manager-inventory')) {
            await loadManagerInventoryScreen();
        } else if (path.includes('manager-listings')) {
            await loadManagerListingsScreen();
        } else if (path.includes('manager-messages')) {
            // Page handles its own init (inline script like admin-messages)
        } else if (path.includes('order-form')) {
            initOrderForm();
        } else if (path.includes('expenses')) {
            loadExpensesScreen();
        } else if (path.includes('order-details')) {
            await loadOrderDetailsScreen();
        }

    }
}

async function handleLogin(e) {
    if (e) e.preventDefault();

    const email = document.getElementById('email')?.value;
    const password = document.getElementById('password')?.value;
    const loginBtn = document.getElementById('login-button');

    if (!email || !password) {
        alert("Please enter email and password");
        return;
    }

    // 1. UI Feedback
    if (loginBtn) {
        loginBtn.disabled = true;
        loginBtn.textContent = 'Signing in...';
    }

    try {
        // 2. Perform Auth
        const { error } = await supabaseClient.auth.signInWithPassword({ email, password });
        if (error) throw error;

        logDebug("Login successful, checking session profile...", null, 'success');

        // 3. Perform Session & Redirect Logic
        // We 'await' this so the button doesn't reset while the page is trying to change
        await checkSession();

    } catch (error) {
        logDebug("Login process error:", error, 'error');

        // Show the error directly on the screen for her
        const msgEl = document.getElementById('auth-message');
        if (msgEl) {
            msgEl.textContent = "âŒ Error: " + error.message;
            msgEl.style.display = "block";
            msgEl.style.color = "#ff4444";
        }

        if (loginBtn) {
            loginBtn.disabled = false;
            loginBtn.textContent = 'Sign In';
        }
    } finally {
        // Safety fallback: if 5 seconds pass and we haven't navigated, re-enable button
        setTimeout(() => {
            if (loginBtn && loginBtn.disabled) {
                loginBtn.disabled = false;
                loginBtn.textContent = 'Sign In';
            }
        }, 5000);
    }
}

async function handleLogout() {
    try {
        await supabaseClient.auth.signOut();
        USER_PROFILE = null; // Clear the memory!
        window.location.href = '/index.html';
    } catch (error) {
        alert("Logout error: " + error.message);
        // Force redirect anyway to break loops
        window.location.href = '/index.html';
    }
}
