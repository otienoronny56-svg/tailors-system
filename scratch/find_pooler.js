const dns = require('dns');

const regions = [
    'eu-central-1', 'us-east-1', 'us-east-2', 'us-west-1', 'us-west-2',
    'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'ap-northeast-2',
    'eu-west-1', 'eu-west-2', 'eu-west-3', 'sa-east-1', 'ca-central-1'
];

async function check() {
    for (const region of regions) {
        const host = `aws-0-${region}.pooler.supabase.com`;
        try {
            const ips = await new Promise((resolve, reject) => {
                dns.resolve4(host, (err, addresses) => {
                    if (err) reject(err);
                    else resolve(addresses);
                });
            });
            console.log(`Resolved: ${host} -> ${ips.join(', ')}`);
        } catch (e) {
            // ignore resolution failures
        }
    }
}

check();
