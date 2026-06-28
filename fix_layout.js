const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'views', 'superadmin', 'superadmin-dashboard.html');
let content = fs.readFileSync(filePath, 'utf8');

// 1. User info style
content = content.replace('<p id="user-info">Logged in as: Owner</p>', '<p id="user-info" style="padding: 10px 15px; font-size: 0.8em; color: #64748b;">Logged in as: Owner</p>');

// 2. Header and title area
const oldHeader = `<header>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                    <div>
                        <h1 style="margin: 0;">SaaS Control Centre</h1>
                        <p style="color: var(--brand-slate); font-size: 0.95em; font-weight: 500; margin-top: 5px;">Platform Health & Growth Monitoring</p>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <button onclick="toggleGuide('superadmin-guide')" class="small-btn" style="background: var(--card-bg); border: 1px solid var(--glass-border); color: var(--brand-navy); cursor: pointer;"><i class="fas fa-question-circle"></i> Guide</button>
                        <button onclick="location.reload()" class="small-btn" style="background: var(--card-bg); border: 1px solid var(--glass-border); color: var(--brand-navy); cursor: pointer;"><i class="fas fa-sync-alt"></i> Refresh</button>
                        
                          <button onclick="toggleTheme()" class="top-right-theme-toggle" title="Toggle Dark Mode"
                              style="background: transparent; border: 1px solid var(--glass-border, #e2e8f0); color: var(--brand-slate, #475569); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.05); transition: all 0.2s; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1em;"
                              onmouseover="this.style.background='var(--card-bg, #f8fafc)'; this.style.transform='translateY(-1px)'"
                              onmouseout="this.style.background='transparent'; this.style.transform='translateY(0)'">
                              <i class="fa-solid fa-moon theme-toggle-icon"></i>
                          </button>
                          <button onclick="handleLogout()" class="small-btn" style="background: #e11d48; color: white; border: none;">Logout</button>
                    </div>
                </div>`;
                
const newHeader = `<header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <div>
                    <h1 style="margin: 0; font-size: 1.8em !important; color: #0f172a !important;" class="dark-mode-text">SaaS Control Centre</h1>
                    <p id="dashboard-welcome-text" style="color: #64748b; font-size: 0.95em; font-weight: 500; margin-top: 5px;">Welcome back! Here is your platform overview.</p>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <button onclick="toggleGuide('superadmin-guide')" class="small-btn" style="background: #ffffff; border: 1px solid #e2e8f0; color: #475569; cursor: pointer;"><i class="fas fa-question-circle"></i> Guide</button>
                    <button onclick="location.reload()" class="small-btn" style="background: #ffffff; border: 1px solid #e2e8f0; color: #475569; cursor: pointer;"><i class="fas fa-sync-alt"></i> Refresh</button>
                    
                    <button onclick="toggleTheme()" class="top-right-theme-toggle" title="Toggle Dark Mode"
                        style="background: transparent; border: 1px solid #e2e8f0; color: #475569; width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; font-size: 1.1em;"
                        onmouseover="this.style.background='#f8fafc'; this.style.transform='translateY(-1px)'"
                        onmouseout="this.style.background='transparent'; this.style.transform='translateY(0)'">
                        <i class="fa-solid fa-moon theme-toggle-icon"></i>
                    </button>
                    <button onclick="handleLogout()" class="small-btn" style="background: #e11d48; color: white; border: none;">Logout</button>
                </div>
            </header>`;
            
content = content.replace(oldHeader, newHeader);

// 3. Fix guide banner
content = content.replace('<div class="dashboard-guide-banner" id="superadmin-guide" style="display: flex; margin-bottom: 25px;">', '<div class="dashboard-guide-banner stat-card" id="superadmin-guide" style="display: flex; margin-bottom: 25px; align-items: flex-start; gap: 15px;">');
content = content.replace('<h4>💡 SaaS Platform Control Centre Guide</h4>', '<h4 style="margin: 0 0 5px 0; color: #0f172a;" class="dark-mode-text">💡 SaaS Platform Control Centre Guide</h4>');

// 4. Fix metrics grid
const oldGrid = `<div class="metrics-grid" style="grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px;">
                    <div class="super-metric-card">
                        <span style="font-size: 0.8em; color: var(--brand-slate); font-weight: 700;">TOTAL ORGANIZATIONS</span>
                        <div style="font-size: 2.2em; font-weight: 800; color: var(--brand-white); margin: 5px 0;" id="total-orgs">...</div>
                        <div style="font-size: 0.75em; color: #10b981; font-weight: 600;"><i class="fas fa-arrow-up"></i> <span id="org-growth-text">...</span> from last month</div>
                    </div>
                    <div class="super-metric-card" style="border-bottom-color: var(--brand-gold);">
                        <span style="font-size: 0.8em; color: var(--brand-slate); font-weight: 700;">PROJECTED MRR</span>
                        <div style="font-size: 2.2em; font-weight: 800; color: var(--brand-white); margin: 5px 0;" id="projected-mrr">...</div>
                        <div style="font-size: 0.75em; color: var(--brand-slate); font-weight: 600;">Monthly Recurring Revenue</div>
                    </div>
                    <div class="super-metric-card" style="border-bottom-color: #10b981;">
                        <span style="font-size: 0.8em; color: var(--brand-slate); font-weight: 700;">ACTIVE PLATFORM USERS</span>
                        <div style="font-size: 2.2em; font-weight: 800; color: var(--brand-white); margin: 5px 0;" id="total-users">...</div>
                        <div style="font-size: 0.75em; color: var(--brand-slate); font-weight: 600;">Across all tenants</div>
                    </div>
                </div>
            </header>`;
            
const newGrid = `<div class="metrics-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px;">
                <div class="stat-card">
                    <h3>Total Organizations</h3>
                    <div style="font-size: 2.2em; font-weight: 700; color: #0f172a; margin: 10px 0;" id="total-orgs" class="dark-mode-text">...</div>
                    <div style="font-size: 0.8em; font-weight: 500; display: flex; align-items: center; gap: 5px;">
                        <span style="background: rgba(16, 185, 129, 0.1); color: #10b981; padding: 2px 8px; border-radius: 12px;"><i class="fas fa-arrow-up"></i> <span id="org-growth-text">...</span></span>
                        <span style="color: #64748b;">from last month</span>
                    </div>
                </div>
                <div class="stat-card">
                    <h3>Projected MRR</h3>
                    <div style="font-size: 2.2em; font-weight: 700; color: #0f172a; margin: 10px 0;" id="projected-mrr" class="dark-mode-text">...</div>
                    <div style="font-size: 0.8em; color: #64748b; font-weight: 500;">Monthly Recurring Revenue</div>
                </div>
                <div class="stat-card">
                    <h3>Active Platform Users</h3>
                    <div style="font-size: 2.2em; font-weight: 700; color: #0f172a; margin: 10px 0;" id="total-users" class="dark-mode-text">...</div>
                    <div style="font-size: 0.8em; color: #64748b; font-weight: 500;">Across all tenants</div>
                </div>
            </div>`;
content = content.replace(oldGrid, newGrid);

// 5. Fix Charts and the breaking div
const oldCharts = `<!-- SaaS Growth Pulse -->
            <div class="chart-container">
                <span class="pulse-label">SaaS Growth Pulse (Organization Sign-ups)</span>
                <div style="height: 300px; position: relative;">
                    <canvas id="growthPulseChart"></canvas>
                </div>
            </div>

            
            </div> <!-- Close grid for charts -->

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 30px; margin-top: 30px;">
                <!-- Subscription Distribution -->
                <div class="chart-container" style="flex: 1;">
                    <span class="pulse-label" style="display: block; font-weight: 600; color: var(--brand-slate); margin-bottom: 15px;">Subscription Tier Distribution</span>
                    <div style="height: 300px; position: relative; display: flex; align-items: center; justify-content: center;">
                        <canvas id="tierDistributionChart"></canvas>
                    </div>
                </div>
            </div>`;
            
const newCharts = `<!-- Dashboard Charts Grid -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 30px;">
                <!-- SaaS Growth Pulse -->
                <div class="stat-card chart-container">
                    <h3 style="margin: 0 0 15px 0;">SaaS Growth Pulse</h3>
                    <div style="height: 300px; position: relative; width: 100%;">
                        <canvas id="growthPulseChart"></canvas>
                    </div>
                </div>

                <!-- Subscription Distribution -->
                <div class="stat-card chart-container">
                    <h3 style="margin: 0 0 15px 0;">Subscription Tiers</h3>
                    <div style="height: 300px; position: relative; display: flex; align-items: center; justify-content: center; width: 100%;">
                        <canvas id="tierDistributionChart"></canvas>
                    </div>
                </div>
            </div>`;
            
content = content.replace(oldCharts, newCharts);

fs.writeFileSync(filePath, content);
console.log("Fixed dashboard layout securely.");
