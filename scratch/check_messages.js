const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function run() {
    try {
        console.log("=== INQUIRIES ===");
        const { data: inqs, error: inqErr } = await supabase
            .from('marketplace_inquiries')
            .select('*')
            .order('created_at', { ascending: false })
            .limit(5);
        if (inqErr) console.error("Inquiries error:", inqErr);
        else console.log(inqs);

        console.log("=== RECENT MESSAGES ===");
        const { data: msgs, error: msgErr } = await supabase
            .from('messages')
            .select('*')
            .order('created_at', { ascending: false })
            .limit(10);
        if (msgErr) console.error("Messages error:", msgErr);
        else console.log(msgs);

        console.log("=== USER PROFILES ===");
        const { data: profiles, error: profErr } = await supabase
            .from('user_profiles')
            .select('*')
            .limit(10);
        if (profErr) console.error("Profiles error:", profErr);
        else console.log(profiles);

    } catch (err) {
        console.error(err);
    }
}

run();
