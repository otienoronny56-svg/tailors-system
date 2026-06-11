const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function run() {
    const { data: clients, error } = await supabase
        .from('clients')
        .select('*')
        .eq('phone', '0745806488')
        .eq('organization_id', 'cc897dfc-dba5-473a-b9bc-ee1ab999cc44');
    if (error) {
        console.error("Error:", error);
    } else {
        console.log("Client record:", JSON.stringify(clients, null, 2));
    }
}

run();
