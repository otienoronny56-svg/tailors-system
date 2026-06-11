const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
    "https://ouuhirckiavcvgqlpriw.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA"
);

async function run() {
    console.log("=== RLS Policies ===");
    const { data: policies, error: polErr } = await supabase
        .rpc('get_policies'); // If we have a helper, else query pg_policies
    if (polErr) {
        // Query pg_policies directly via SQL
        const { data: pgPol, error: pgErr } = await supabase.rpc('pg_eval', {
            sql: "SELECT tablename, policyname, permissive, roles, cmd, qual, with_check FROM pg_policies WHERE schemaname = 'public';"
        });
        if (pgErr) {
            // Try raw query or execute pg_policies using an anonymous code block
            const { data: rawData, error: rawErr } = await supabase.rpc('exec_sql', {
                sql: "SELECT tablename, policyname, cmd, qual, with_check FROM pg_policies WHERE schemaname = 'public';"
            });
            if (rawErr) {
                console.error("Could not fetch policies via exec_sql/pg_eval:", rawErr);
            } else {
                console.log(rawData);
            }
        } else {
            console.log(pgPol);
        }
    } else {
        console.log(policies);
    }
}

async function run2() {
    // If rpc doesn't exist, we can use a query that selects from pg_policies via standard sql execution helper if there is one
    // Let's list function definitions in public schema to find any sql helpers
    const { data: funcs, error: funcErr } = await supabase.rpc('get_functions', {});
    if (funcErr) {
        // let's run a generic sql executor if we have one. In communication_schema.sql or others there might be a helper.
        // Let's inspect communication_schema.sql or other SQL files in the workspace.
    }
}

run();
