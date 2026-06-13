const https = require('https');

const options = {
    hostname: 'ouuhirckiavcvgqlpriw.supabase.co',
    port: 443,
    path: '/rest/v1/',
    method: 'GET',
    headers: {
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91dWhpcmNraWF2Y3ZncWxwcml3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MTYyNDUsImV4cCI6MjA4OTQ5MjI0NX0.l5diE9bfcRQo8ZSMsAx-alG89GFifGA11hA059zDhXM'
    }
};

const req = https.request(options, (res) => {
    console.log("Status:", res.statusCode);
    console.log("Headers:", JSON.stringify(res.headers, null, 2));
});
req.on('error', console.error);
req.end();
