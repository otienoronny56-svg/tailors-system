
// ==========================================
// ⚙️ MASTER CONFIGURATION FILE
// ==========================================

const APP_CONFIG = {
    // === 1. CONTROL SWITCH (THE KILL SWITCH) ===
    // Options: "ACTIVE" (App works) or "SUSPENDED" (Shows Payment Screen)
    SYSTEM_STATUS: "ACTIVE",

    // === 2. PAYMENT & SUPPORT DETAILS (For the Lock Screen) ===
    billing: {
        mpesaNumber: "0745806488",
        tillNumber: "4056724",
        supportPhone: "0745806488"
    },

    // === 3. BRANDING IDENTITY ===
    appName: "GENTLEMAN STANDARD",
    appSubtitle: "BY RONNY",
    logoPath: "logo.png",

    // === 4. CONTACT DETAILS (For Receipts) ===
    shopPhone: "0721401495",
    currencySymbol: "Ksh",

    // === 5. BACKEND CONNECTION (Supabase) ===
    supabaseUrl: "https://nbksbimxyssfbgfxzcnc.supabase.co",
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ia3NiaW14eXNzZmJnZnh6Y25jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODAxMDIsImV4cCI6MjA4MjA1NjEwMn0.l2xwq7uVCFy9SWlYoKnlm11uotTNJxhi_1Z1dZYtxHg",
    serviceRoleKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5ia3NiaW14eXNzZmJnZnh6Y25jIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjQ4MDEwMiwiZXhwIjoyMDgyMDU2MTAyfQ.K0ZYLQ5lMstENBkfO3jOKDSuTqReGaRJybinr_17CTE"
};