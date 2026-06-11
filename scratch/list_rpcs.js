const https = require('https');
const fs = require('fs');

const configContent = fs.readFileSync('config.js', 'utf8');
const urlMatch = configContent.match(/supabaseUrl\s*:\s*['"]([^'"]+)['"]/);
const keyMatch = configContent.match(/serviceRoleKey\s*:\s*['"]([^'"]+)['"]/);

if (!urlMatch || !keyMatch) {
    console.error("Could not parse config.js for serviceRoleKey");
    process.exit(1);
}

const supabaseUrl = urlMatch[1];
const serviceRoleKey = keyMatch[1];

const urlObj = new URL(supabaseUrl);
const hostname = urlObj.hostname;

const options = {
    hostname: hostname,
    port: 443,
    path: '/rest/v1/',
    method: 'GET',
    headers: {
        'apikey': serviceRoleKey,
        'Authorization': `Bearer ${serviceRoleKey}`,
        'Accept': 'application/openapi+json'
    }
};

const req = https.request(options, (res) => {
    let data = '';
    res.on('data', (d) => { data += d; });
    res.on('end', () => {
        try {
            const spec = JSON.parse(data);
            const rpcPaths = Object.keys(spec.paths).filter(p => p.startsWith('/rpc/'));
            console.log("Found RPC paths:");
            console.log(rpcPaths.join('\n'));
        } catch (e) {
            console.error("Error:", e);
        }
    });
});
req.end();
