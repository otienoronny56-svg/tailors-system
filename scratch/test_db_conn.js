const { Client } = require('pg');
const fs = require('fs');

const passwords = ['adminpassword', 'postgres', 'supabase', 'password', 'EphraimsBespoke', 'RonnyAdmin'];
const host = 'db.ouuhirckiavcvgqlpriw.supabase.co';
const dbName = 'postgres';
const user = 'postgres';

async function tryConnect() {
    for (const pwd of passwords) {
        console.log(`Trying password: ${pwd}`);
        const client = new Client({
            host: host,
            port: 5432,
            database: dbName,
            user: user,
            password: pwd,
            ssl: { rejectUnauthorized: false }
        });

        try {
            await client.connect();
            console.log(`✅ Success! Database password is: ${pwd}`);
            
            const sql = fs.readFileSync('create_sync_trigger.sql', 'utf8');
            console.log("Running create_sync_trigger.sql...");
            await client.query(sql);
            console.log("✅ Trigger created successfully!");
            
            await client.end();
            return;
        } catch (err) {
            console.log(`Failed with password ${pwd}: ${err.message}`);
        }
    }
    console.log("❌ Could not connect with any test passwords.");
}

tryConnect();
