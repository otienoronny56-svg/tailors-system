const dns = require('dns');

dns.resolveCname('ouuhirckiavcvgqlpriw.supabase.co', (err, addresses) => {
    if (err) {
        console.error("Cname lookup failed:", err.message);
    } else {
        console.log("CNAMES:", addresses);
    }
});

dns.resolve4('ouuhirckiavcvgqlpriw.supabase.co', (err, addresses) => {
    if (err) {
        console.error("IPv4 lookup failed:", err.message);
    } else {
        console.log("IPs:", addresses);
        // Reverse lookup
        addresses.forEach(ip => {
            dns.reverse(ip, (err, hostnames) => {
                if (!err) {
                    console.log(`Reverse lookup for ${ip}:`, hostnames);
                }
            });
        });
    }
});
