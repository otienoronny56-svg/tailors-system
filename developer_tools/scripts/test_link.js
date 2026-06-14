const pathname = '/views/admin/admin-orders.html';
const origin = 'https://tailors.co.ke';
const basePath = pathname.indexOf('/views/') > 0 
        ? pathname.substring(0, pathname.indexOf('/views/')) 
        : '';
console.log(`basePath: '${basePath}'`);
console.log(`URL: ${origin}${basePath}/views/client/track.html?id=123`);
