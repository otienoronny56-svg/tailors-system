const { Client } = require('pg');

const projectRef = 'ouuhirckiavcvgqlpriw';
const host = 'aws-0-eu-central-1.pooler.supabase.com';

async function check() {
    const client = new Client({
        host: host,
        port: 5432, // Session pooler or direct port
        database: 'postgres',
        user: `postgres.${projectRef}`,
        password: 'dummy_password',
        connectionTimeoutMillis: 3000,
        ssl: { rejectUnauthorized: false }
    });

    try {
        await client.connect();
        console.log("Connected!");
        await client.end();
    } catch (e) {
        console.log(`Error: ${e.message}`);
    }
}

check();
