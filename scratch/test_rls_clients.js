const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MTYyNDUsImV4cCI6MjA4OTQ5MjI0NX0.l5diE9bfcRQo8ZSMsAx-alG89GFifGA11hA059zDhXM" // Anon key
);

async function run() {
    console.log("Signing in as Ephraim Omboto...");
    const { data: { session }, error: loginErr } = await supabase.auth.signInWithPassword({
        email: 'eigs2025@gmail.com',
        password: 'password' // We will check if 'password' or 'EphraimsBespoke' is the password. Let's try password first.
    });

    if (loginErr) {
        console.error("Login failed with 'password', trying 'EphraimsBespoke'...");
        const { data: { session: s2 }, error: loginErr2 } = await supabase.auth.signInWithPassword({
            email: 'eigs2025@gmail.com',
            password: 'EphraimsBespoke'
        });
        if (loginErr2) {
            console.error("Login with 'EphraimsBespoke' failed too:", loginErr2);
            return;
        }
        console.log("Logged in with 'EphraimsBespoke'!");
    } else {
        console.log("Logged in with 'password'!");
    }

    console.log("Querying clients using user session...");
    const { data: clients, error: selectErr } = await supabase
        .from('clients')
        .select('*');
    
    if (selectErr) {
        console.error("Error querying clients:", selectErr);
    } else {
        console.log("Successfully fetched clients:", clients);
    }
}

run();
