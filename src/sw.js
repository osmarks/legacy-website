var cacheName = "v1";
var offline = "/assets/offline.html"

self.addEventListener('install', function(event) {
    event.waitUntil(preLoad());
});

var preLoad = function() {
    console.log('Handling install');
    return caches.open(cacheName).then(function(cache) {
        console.log('Caching index & offline page.');
        return cache.addAll([offline, '/index.html']);
    });
}

self.addEventListener('fetch', function(event) {
    console.log('The service worker is serving the asset.');
    event.respondWith(checkResponse(event.request).catch(function() {
        return returnFromCache(event.request)}
    ));
    event.waitUntil(addToCache(event.request));
});

var checkResponse = function(request){
    return new Promise(function(fulfill, reject) {
        fetch(request).then(function(response){
            fulfill(response);
        }, reject)
    });
};

var addToCache = function(request){
    return caches.open(cacheName).then(function (cache) {
        return fetch(request).then(function (response) {
            console.log('Adding to cache: ' + response.url)
            return cache.put(request, response);
        });
    });
};

var returnFromCache = function(request){
    return caches.open(cacheName).then(function (cache) {
        return cache.match(request).then(function (matching) {
            if(!matching) {
                return cache.match(offline)
            } else {
                return matching
            }
        });
    });
};