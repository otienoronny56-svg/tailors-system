const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve all static files from the project root
app.use(express.static(path.join(__dirname), {
    etag: true,
    lastModified: true,
}));

// Fallback: serve index.html for root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
    console.log(`\n✅ Stitch & Styles Kenya server running at: http://localhost:${PORT}`);
    console.log(`   Home:      http://localhost:${PORT}/index.html`);
    console.log(`   Login:     http://localhost:${PORT}/login.html`);
    console.log(`   Marketplace: http://localhost:${PORT}/views/client/marketplace.html\n`);
});
