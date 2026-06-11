const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl:\s*"([^"]+)"/);
const keyMatch = configContent.match(/serviceRoleKey:\s*"([^"]+)"/);

if (!urlMatch || !keyMatch) {
    console.error("Could not load config keys");
    process.exit(1);
}

const supabase = createClient(urlMatch[1], keyMatch[1]);

async function dumpRLSPolicies() {
    try {
        console.log("Fetching active tables and RLS configurations from Supabase pg_catalog...");
        
        // Execute SQL via a direct postgres function or using pg_catalog if we have an RPC, 
        // since we don't have a direct sql query endpoint, let's see if we can query pg_policies via RPC.
        // If there is no custom RPC, we can try running an RPC that executes SQL, or we can check what tables have RLS enabled
        // by executing a query on pg_catalog if we created a custom SQL executor function earlier.
        // Let's check if there is an RPC we can use, or let's create a custom function via a postgres migration and call it.
        // Wait, do we have an RPC that can execute SQL? Let's check check_db.js or list_users.js.
        
        // Let's see: we can query the database metadata by calling postgres RPCs. Let's see if we have one.
        const { data: rpcData, error: rpcError } = await supabase.rpc('execute_sql', {
            sql_query: "SELECT schemaname, tablename, rowsecurity FROM pg_tables WHERE schemaname = 'public';"
        });
        
        if (rpcError) {
            console.log("No 'execute_sql' RPC. Let's look for other custom SQL tools or create a temporary function.");
            // Let's check if we can run any other custom functions or check database schema.
            // Wait, we can see if we can create a postgres function to query policies!
            // Let's write a SQL script that creates a function to dump pg_policies, executes it, and then drops it.
            // Oh, we can't run arbitrary SQL unless we execute a migration or have an RPC. 
            // Wait, we can run a SQL migration by executing a SQL file using a script or the Supabase CLI if we have it? 
            // No, we don't have a terminal tool to connect to the database directly unless we use an external node script with pg library or postgres library!
            // Wait! Do we have a pg or postgres library in node_modules? Let's check package.json or node_modules.
        } else {
            console.table(rpcData);
        }
    } catch (err) {
        console.error("Error:", err.message);
    }
}

dumpRLSPolicies();
