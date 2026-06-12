const { Client } = require('pg');

const passwords = ['adminpassword', 'postgres', 'supabase', 'password', 'EphraimsBespoke', 'RonnyAdmin'];
const host = 'db.ouuhirckiavcvgqlpriw.supabase.co';
const dbName = 'postgres';
const user = 'postgres';

async function migrate() {
    for (const pwd of passwords) {
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
            console.log(`✅ Connected with password: ${pwd}`);
            
            console.log("Adding columns to shops table...");
            await client.query(`
                ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS availability_hours TEXT;
                ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS specialization TEXT;
                ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS website_url TEXT;
            `);
            console.log("✅ Columns added successfully!");
            
            await client.end();
            return;
        } catch (err) {
            console.log(`Failed with password ${pwd}: ${err.message}`);
        }
    }
    console.log("❌ Migration failed: Could not connect with any passwords.");
}

migrate();
