var cacheVersion = 1;
var cacheName = 'top-shot-engineering-' + cacheVersion;
var offlineHtmlFileName = 'offline.html';

var prefetchUrls = [
    'favicon.ico',
    'logos/logo-192.png',
    'logos/logo-512.png',
    'style.css',
    'manifest.webmanifest',
    offlineHtmlFileName
];

self.addEventListener('install', function (event) {
    console.log('ServiceWorker: install');
});

self.addEventListener('install', function (event) {
    console.log('ServiceWorker: install started...');

    self.skipWaiting();

    event.waitUntil(
        caches
            .open(cacheName)
            .then(function (cache) {
                return Promise
                    .all(prefetchUrls.map(function (prefetchUrl) {
                        return fetch(prefetchUrl)
                            .then(function (prefetchResponse) {
                                if (prefetchResponse.status >= 400) {
                                    throw Error('Request failed: ' + prefetchUrl);
                                }

                                return cache.put(prefetchUrl, prefetchResponse);
                            })
                            .catch(function (prefetchError) {
                                console.log(prefetchError);
                            })
                    }))
            }));
});

self.addEventListener('activate', function (event) {
    console.log('ServiceWorker: activate');
});

self.addEventListener('message', function (event) {
    console.log('ServiceWorker: message');
});

self.addEventListener('fetch', function (event) {

    if (event.request.mode === 'navigate') {
        event.respondWith(
            fetch(event.request)
            .catch(function (error) {
                console.log(error);
                return caches.open(cacheName)
                    .then(function (cache) {
                        return cache.match(offlineHtmlFileName);
                    });
            })
        );
    }
});
