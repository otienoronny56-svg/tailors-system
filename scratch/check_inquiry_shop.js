const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function run() {
    // Inquiry check
    const { data: inq, error: inqErr } = await supabase
        .from('marketplace_inquiries')
        .select('*, shops(*)')
        .eq('id', '9138a931-505d-4574-8897-5115f89c3c7a')
        .single();
    console.log("=== TARGET INQUIRY ===");
    console.log(inqErr || inq);

    // Tailor Ephraim shops
    const { data: shops, error: shopsErr } = await supabase
        .from('shops')
        .select('*')
        .eq('organization_id', 'cc897dfc-dba5-473a-b9bc-ee1ab999cc44');
    console.log("=== TAILOR SHOPS ===");
    console.log(shopsErr || shops);
}

run();
