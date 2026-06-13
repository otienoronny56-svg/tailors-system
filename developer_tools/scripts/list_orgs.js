
const supabaseUrl = "https://ouuhirckiavcvgqlpriw.supabase.co";
const serviceRoleKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA";

async function listOrgs() {
    const res = await fetch(`${supabaseUrl}/rest/v1/organizations?select=id,name`, {
        headers: { "apikey": serviceRoleKey, "Authorization": `Bearer ${serviceRoleKey}` }
    });
    const data = await res.json();
    console.log(JSON.stringify(data, null, 2));
}
listOrgs();
