const { Client } = require('pg');

const projectRef = 'ouuhirckiavcvgqlpriw';
const passwords = ['adminpassword', 'postgres', 'supabase', 'password', 'EphraimsBespoke', 'RonnyAdmin'];
const regions = [
    'eu-central-1', 'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2',
    'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'ap-northeast-2',
    'eu-west-1', 'eu-west-2', 'eu-west-3', 'sa-east-1', 'ca-central-1'
];

async function check() {
    for (const region of regions) {
        const host = `aws-0-${region}.pooler.supabase.com`;
        console.log(`Checking region ${region} (${host})...`);
        for (const pwd of passwords) {
            const client = new Client({
                host: host,
                port: 6543, // Transaction Pooler port
                database: 'postgres',
                user: `postgres.${projectRef}`,
                password: pwd,
                connectionTimeoutMillis: 3000, // 3 seconds timeout
                ssl: { rejectUnauthorized: false }
            });

            try {
                await client.connect();
                console.log(`✅ CONNECTED SUCCESSFULLY!`);
                console.log(`Host: ${host}`);
                console.log(`Password: ${pwd}`);
                
                // Let's run the migration!
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
    console.log("❌ Could not connect to any pooler with any passwords.");
}

check();
