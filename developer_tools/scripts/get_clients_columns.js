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

// Extract host and path
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
            if (spec.message) {
                console.error("Supabase Error fetching spec:");
                console.error("Message:", spec.message);
                console.error("Hint:", spec.hint);
                return;
            }
            console.log("Top-level keys in spec:", Object.keys(spec).join(', '));
            
            const defs = spec.definitions || (spec.components && spec.components.schemas);
            if (defs) {
                console.log("\nAll tables in spec:");
                console.log(Object.keys(defs).sort().join(', '));
                
                const clientKey = Object.keys(defs).find(k => k.toLowerCase() === 'clients');
                if (clientKey) {
                    const props = defs[clientKey].properties;
                    if (props) {
                        console.log(`\nColumns for '${clientKey}' table:`);
                        console.log(Object.keys(props).join(', '));
                    } else {
                        console.log(`\nNo properties found for '${clientKey}'`);
                    }
                } else {
                    console.log("\nTable 'clients' not found in definitions.");
                }
            } else {
                console.log("\nNo definitions/components found in spec.");
            }
        } catch (e) {
            console.error("Error parsing response:", e);
        }
    });
});

req.on('error', (e) => {
    console.error("Request error:", e);
});

req.end();
