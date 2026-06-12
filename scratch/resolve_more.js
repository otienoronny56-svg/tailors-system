const { Client } = require('pg');

const projectRef = 'ouuhirckiavcvgqlpriw';
const passwords = ['adminpassword', 'postgres', 'supabase', 'password', 'EphraimsBespoke', 'RonnyAdmin'];
const regions = [
    'ap-south-1', 'ap-southeast-3', 'eu-central-2', 'me-central-1', 'ap-northeast-3'
];

async function check() {
    for (const region of regions) {
        const host = `aws-0-${region}.pooler.supabase.com`;
        console.log(`Checking region ${region} (${host})...`);
        for (const pwd of passwords) {
            const client = new Client({
                host: host,
                port: 6543,
                database: 'postgres',
                user: `postgres.${projectRef}`,
                password: pwd,
                connectionTimeoutMillis: 3000,
                ssl: { rejectUnauthorized: false }
            });

            try {
                await client.connect();
                console.log(`✅ CONNECTED SUCCESSFULLY in region: ${region}!`);
                console.log(`Host: ${host}`);
                console.log(`Password: ${pwd}`);
                
                console.log("Running migration...");
                await client.query(`
                    ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS availability_hours TEXT;
                    ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS specialization TEXT;
                    ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS website_url TEXT;
                `);
                console.log("✅ Columns added successfully!");

                await client.end();
                return;
            } catch (e) {
                console.log(`Failed for ${region} with password ${pwd}: ${e.message}`);
            }
        }
    }
    console.log("❌ Could not connect to any of these poolers.");
}

check();
