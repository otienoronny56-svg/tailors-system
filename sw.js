const CACHE_NAME = 'tailors-cache-v1019';
const urlsToCache = [
  '/',
  '/index.html',
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
  // VIOLENT CACHE CLEAR: Delete ANY old caches to immediately force new styles
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Violently deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  // Only handle GET requests with http/https schemes
  if (event.request.method !== 'GET' || !event.request.url.startsWith('http')) {
    return;
  }

  // AGGRESSIVE NETWORK FIRST STRATEGY for everything
  event.respondWith(
    fetch(event.request)
      .then(networkResponse => {
        // If we got a valid response, clone it and update the cache
        if (networkResponse && networkResponse.status === 200 && networkResponse.type === 'basic') {
          const responseToCache = networkResponse.clone();
          caches.open(CACHE_NAME)
            .then(cache => {
              cache.put(event.request, responseToCache);
            });
        }
        return networkResponse;
      })
      .catch(err => {
        // If network fails, gracefully fall back to the cache
        console.warn('Network fetch failed, falling back to cache for:', event.request.url, err);
        return caches.match(event.request, { ignoreSearch: true })
          .then(cachedResponse => {
            if (cachedResponse) return cachedResponse;
            return new Response('Network error occurred. Offline mode.', {
              status: 503,
              statusText: 'Service Unavailable',
              headers: new Headers({ 'Content-Type': 'text/plain' })
            });
          });
      })
  );
});
