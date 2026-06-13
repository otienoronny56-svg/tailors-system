const https = require('https');

const SUPABASE_URL = 'https://ouuhirckiavcvgqlpriw.supabase.co';
const SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MzkxNjI0NSwiZXhwIjoyMDg5NDkyMjQ1fQ.yC10d9Lu9cNB0JALqr5WCLuWBblw_6at8vuy0MXSyWA';

const options = {
    hostname: 'ouuhirckiavcvgqlpriw.supabase.co',
    port: 443,
    path: '/rest/v1/',
    method: 'GET',
    headers: {
        'apikey': SERVICE_KEY,
        'Authorization': `Bearer ${SERVICE_KEY}`,
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
            console.error("Error parsing response:", e);
            console.log("Response text was:", data);
        }
    });
});
req.on('error', console.error);
req.end();
