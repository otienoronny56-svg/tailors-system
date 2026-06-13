const http = require('http');
const fs = require('fs');
const path = require('path');

http.createServer((req, res) => {
    const filePath = req.url === '/' ? 'get_id.html' : req.url.slice(1);
    if (fs.existsSync(filePath)) {
        res.end(fs.readFileSync(filePath));
    } else {
        res.statusCode = 404;
        res.end("Not found");
    }
}).listen(7777, () => {
    console.log("Server listening on port 7777");
});
