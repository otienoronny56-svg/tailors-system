const { Client } = require('pg');

const projectRef = 'ouuhirckiavcvgqlpriw';
const regions = [
    'eu-central-1', 'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2',
    'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'ap-northeast-2',
    'eu-west-1', 'eu-west-2', 'eu-west-3', 'sa-east-1', 'ca-central-1', 'ap-south-1'
];

async function check() {
    for (const region of regions) {
        const host = `aws-0-${region}.pooler.supabase.com`;
        const client = new Client({
            host: host,
            port: 6543,
            database: 'postgres',
            user: `postgres.${projectRef}`,
            password: 'dummy_password_to_test_tenant_existence',
            connectionTimeoutMillis: 3000,
            ssl: { rejectUnauthorized: false }
        });

        try {
            await client.connect();
            console.log(`Region ${region}: Connected (unexpected!)`);
            await client.end();
        } catch (e) {
            console.log(`Region ${region}: ${e.message}`);
        }
    }
}

check();
