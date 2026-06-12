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
            port: 5432,
            database: 'postgres',
            user: `postgres.${projectRef}`,
            password: 'dummy_password',
            connectionTimeoutMillis: 2000,
            ssl: { rejectUnauthorized: false }
        });

        try {
            await client.connect();
            console.log(`Region ${region}: Connected!`);
            await client.end();
        } catch (e) {
            console.log(`Region ${region}: ${e.message}`);
        }
    }
}

check();
