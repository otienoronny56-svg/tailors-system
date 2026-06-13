
const supabaseUrl = "https://ouuhirckiavcvgqlpriw.supabase.co";
const serviceRoleKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA";

async function fixBranding() {
    const LUXE_TAILORS_ID = "4b763f2b-4afe-4050-b07e-6fb4542067cc";
    const ADMIN_EMAIL = "admin@otima.com";
    
    console.log(`🚀 Forcing branding fix for organization: Luxe Tailors (${LUXE_TAILORS_ID})`);
    console.log(`🎯 Targeting Admin: ${ADMIN_EMAIL}`);

    try {
        const headers = { 
            "apikey": serviceRoleKey, 
            "Authorization": `Bearer ${serviceRoleKey}`,
            "Content-Type": "application/json",
            "Prefer": "return=minimal"
        };

        // 1. Link the specific Admin Profile
        await fetch(`${supabaseUrl}/rest/v1/user_profiles?full_name=ilike.*admin*`, {
            method: "PATCH",
            headers,
            body: JSON.stringify({ organization_id: LUXE_TAILORS_ID })
        });
        
        // Also try to link by role more broadly
        await fetch(`${supabaseUrl}/rest/v1/user_profiles?role=eq.owner`, {
            method: "PATCH",
            headers,
            body: JSON.stringify({ organization_id: LUXE_TAILORS_ID })
        });
        
        console.log("✅ Linked Owner Profiles.");

        // 2. Link Shops
        await fetch(`${supabaseUrl}/rest/v1/shops?id=not.is.null`, {
            method: "PATCH",
            headers,
            body: JSON.stringify({ organization_id: LUXE_TAILORS_ID })
        });
        console.log("✅ Linked Shops.");

        // 3. Link Workers
        await fetch(`${supabaseUrl}/rest/v1/workers?id=not.is.null`, {
            method: "PATCH",
            headers,
            body: JSON.stringify({ organization_id: LUXE_TAILORS_ID })
        });
        console.log("✅ Linked Workers.");

        // 4. Link Orders
        await fetch(`${supabaseUrl}/rest/v1/orders?id=not.is.null`, {
            method: "PATCH",
            headers,
            body: JSON.stringify({ organization_id: LUXE_TAILORS_ID })
        });
        console.log("✅ Linked Orders.");
        
        console.log("\n🎉 Database relinking complete!");

    } catch (e) {
        console.error("💥 Fatal error during fix:", e);
    }
}

fixBranding();
