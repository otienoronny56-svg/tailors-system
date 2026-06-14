const CACHE_NAME = 'tailors-cache-v3';
const urlsToCache = [
  '/',
  '/index.html',
  '/styles.css?v=20260614',
  '/app.js',
  '/logo.png'
];

self.addEventListener('install', event => {
  self.skipWaiting(); // Force the waiting service worker to become the active service worker.
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(self.clients.claim()); // Claim control immediately for the current page
});

self.addEventListener('fetch', event => {
  // Only handle GET requests with http/https schemes
  if (event.request.method !== 'GET' || !event.request.url.startsWith('http')) {
    return;
  }

  event.respondWith(
    caches.match(event.request, { ignoreSearch: true })
      .then(response => {
        if (response) {
          return response;
        }
        return fetch(event.request).catch(err => {
          console.warn('Service Worker fetch failed for:', event.request.url, err);
          // Return a network error response instead of rejecting the promise
          return new Response('Network error occurred', {
            status: 503,
            statusText: 'Service Unavailable',
            headers: new Headers({ 'Content-Type': 'text/plain' })
          });
        });
      })
  );
});
