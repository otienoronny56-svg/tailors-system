
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
    appName: "OTIMA FASHION HOUSE",       
    appSubtitle: "BY RONNY",         
    logoPath: "logo.png",             

    // === 4. CONTACT DETAILS (For Receipts) ===
    shopPhone: "0721401495",       
    currencySymbol: "Ksh",            

    // === 5. BACKEND CONNECTION (Supabase) ===
    supabaseUrl: "https://jgvpwdlmxujeappsgxlw.supabase.co", 
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpndnB3ZGxteHVqZWFwcHNneGx3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODIyMDQsImV4cCI6MjA4MjA1ODIwNH0.vWYixKfxq6PxsxEvfLgIZRmNsXmKdvxdG-I6YaRYV-4",
    serviceRoleKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpndnB3ZGxteHVqZWFwcHNneGx3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjQ4MjIwNCwiZXhwIjoyMDgyMDU4MjA0fQ.UvndP35SqHwHBwpaaAmNVM9uK4AJW6NTtKu5mDSoszs"
};
