'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "7e448c16ddb6f1f1e4f060e67e42ec24",
"assets/assets/audio/ball.wav": "e36c6033484f65495133e2cc2170135d",
"assets/assets/audio/balloon.wav": "d325ae5e5ac5cb1eb0b095bc666ac2c5",
"assets/assets/audio/banana.wav": "2a6eff70bdb354ee88a55a0ec8ede551",
"assets/assets/audio/barrel.wav": "f0427403a00578bb979e894f9bc6653c",
"assets/assets/audio/bat.wav": "c4f566f864c8577d26c1dd9099f1f07f",
"assets/assets/audio/bicycle.wav": "b64e84697d8cdb85f2a8ae2c7c978ab9",
"assets/assets/audio/boar.wav": "25dfccf5464c76884f7556a2beb4e6bc",
"assets/assets/audio/book.wav": "40a2aa3735b1d3724a88016cd49825e3",
"assets/assets/audio/butterfly.wav": "1f039045c986c46d110f328f5b27358a",
"assets/assets/audio/cactus.wav": "c946b2058b02f3c4dbb2869947ea98da",
"assets/assets/audio/cake.wav": "3604ab13f15f5e49d6852bc0139bc63b",
"assets/assets/audio/camera.wav": "d037422ea78b07570ff5703cbd16728d",
"assets/assets/audio/candle.wav": "dd134fd744318bfa1e5cfd676a512251",
"assets/assets/audio/candy.wav": "518c2fa3e7f69da9ee186d9bb21e557c",
"assets/assets/audio/cat.wav": "f2c97b85d41b2a1818cc5443f47ae995",
"assets/assets/audio/cherries.wav": "c24efbc51d454ed24b6b9ac460f119e2",
"assets/assets/audio/cloud.wav": "e7116af83b7a072983b62d3030d49376",
"assets/assets/audio/clown.wav": "54a312438a782ec3cfb0d32d92a67b15",
"assets/assets/audio/coffee.wav": "483cb922ef5eecfac37e58a3d9222643",
"assets/assets/audio/cookie.wav": "60d209fd35b5c929e6753e79286f9ce2",
"assets/assets/audio/desktop.ini": "b3d53b0bcfe4c890bfc7b6e8e9d66125",
"assets/assets/audio/dog.wav": "c4b80ad417be683c29291b913bc8cd1f",
"assets/assets/audio/dolphin.wav": "cc974b826d87b4dfcc56964657ef08cb",
"assets/assets/audio/donut.wav": "25d8e791d5939919e4ff97d9c6eefc3b",
"assets/assets/audio/fish.wav": "e69600f6683cd11d89cca141f67330e5",
"assets/assets/audio/fist.wav": "16052ecb6fac141f6d0cf3477d2565fc",
"assets/assets/audio/flashlight.wav": "16563113419550eee83c61b9792e4630",
"assets/assets/audio/gift.wav": "afd599b25b4b46bb0775150b6362a72b",
"assets/assets/audio/guitar.wav": "65026aa049d9b7ff52cc75bf9891bba6",
"assets/assets/audio/key.wav": "d7bc5118560728c82a031f7066fdb9b3",
"assets/assets/audio/lightbulb.wav": "7da164a379af1d7b40c446cc5e5a4ba9",
"assets/assets/audio/microphone.wav": "6c14658d2cc1c4d1718abb5c5e868a36",
"assets/assets/audio/microscope.wav": "63a975bff5f25e3e899db0f9dbbdab12",
"assets/assets/audio/monkey.wav": "00f4c05e583f222599234c659a55b69f",
"assets/assets/audio/moon.wav": "99966091e6a78c36470d6da3a3136b2a",
"assets/assets/audio/mouse.wav": "e6d588e197f4d463d1af8d989d2151d8",
"assets/assets/audio/mouth.wav": "363a00a044c17bc247ca35522a3e1fa0",
"assets/assets/audio/pear.wav": "541f340dd5ea20afaf28cd60b9387539",
"assets/assets/audio/pencil.wav": "521fe7ebe29d22d77fce89496f502d3c",
"assets/assets/audio/pepper.wav": "89a30242b299d8f3dfc7d734e40d5d28",
"assets/assets/audio/phone.wav": "57b8e28b8acabe768b95bc543dae1a79",
"assets/assets/audio/printer.wav": "470ad5efebc5c272687b4028ea61cee3",
"assets/assets/audio/rainbow.wav": "c20456f59015720325d8a795cf48300d",
"assets/assets/audio/road.wav": "b4cb10df20322ddac24878348ea1cfe9",
"assets/assets/audio/robe.wav": "cee9b0dd8c2fad4500c86e92dad8ffe8",
"assets/assets/audio/rocket.wav": "8c335d302ca1f1b12e466292265bdb86",
"assets/assets/audio/ruler.wav": "9a5d22f2727ac2a356cd0c1b7cf05205",
"assets/assets/audio/seashell.wav": "5c8a0135fbbfc29e0ad773ed4b320b27",
"assets/assets/audio/sheep.wav": "c794dc34d695f0d7df6f6fc91b6d0c06",
"assets/assets/audio/shield.wav": "b3356cc268dae1c0286ee2fe9e6e0290",
"assets/assets/audio/ship.wav": "2398efbb99ece9b1da1d966a8268a272",
"assets/assets/audio/shoe.wav": "25ad8a43768f368e18108dfe0cda2bc5",
"assets/assets/audio/skate.wav": "82e1af89d5ac30f05b3b3757f472f8d7",
"assets/assets/audio/snake.wav": "b37dc6641eb173b232fca00d5c079b2c",
"assets/assets/audio/snowman.wav": "bca023af15c3a87436192f6644370dbc",
"assets/assets/audio/spoon.wav": "a6b9f08723885eaaa823da8f849c0906",
"assets/assets/audio/strawberry.wav": "87f80ee441237e74b46cf42b2c1d6848",
"assets/assets/audio/sunflower.wav": "3257a7a1b8e1bca50425874e32659321",
"assets/assets/audio/track.wav": "b461643bd861d9f8ff0f07d7da760414",
"assets/assets/audio/trophy.wav": "9a02bdbd2b1e382785b0c693cb7ab535",
"assets/assets/audio/truck.wav": "71fadb8b1658e6200fc5b8243943bbfa",
"assets/assets/audio/volcano.wav": "bfefdadc6c7f74cd205d092f6ff9ca4f",
"assets/assets/audio/watermelon.wav": "64f2b9b10528cba37a23e45d02086d24",
"assets/assets/vector/ball.svg": "6088b7be5e2c433a4ddd4d4052ea7587",
"assets/assets/vector/balloon.svg": "7d10410cd4fba4e76d69100f5b995855",
"assets/assets/vector/ballvector.svg": "6088b7be5e2c433a4ddd4d4052ea7587",
"assets/assets/vector/banana.svg": "6a755665c41827a17daa192a93cac506",
"assets/assets/vector/barrel.svg": "1c3da7b11eb6cd910c61fd658a9d66c1",
"assets/assets/vector/barrelvector.svg": "1c3da7b11eb6cd910c61fd658a9d66c1",
"assets/assets/vector/bat.svg": "2b02b606a870fcd6244f9d0b4f6b7057",
"assets/assets/vector/bicycle.svg": "af0ef75786387496ad0003a75ef30a55",
"assets/assets/vector/boar.svg": "75d1ec8d749344ae646c30af72020892",
"assets/assets/vector/boarvector.svg": "75d1ec8d749344ae646c30af72020892",
"assets/assets/vector/book.svg": "75f537e11e983251f388a493516d5ba3",
"assets/assets/vector/butterfly.svg": "f4af33281df12136ba8ae01f332f5306",
"assets/assets/vector/cactus.svg": "1c6cd698c10b397b5cea50207725717f",
"assets/assets/vector/cake.svg": "ac83d626ed055a12d3b9628d0535039d",
"assets/assets/vector/camera.svg": "07f86c67887154a74d6efe7af65aac1b",
"assets/assets/vector/candle.svg": "74ac0c67460c11d3f7a2605db5ef1920",
"assets/assets/vector/candlevector.svg": "74ac0c67460c11d3f7a2605db5ef1920",
"assets/assets/vector/candy.svg": "36eb031a885bb3237ceee7fc76b0a27b",
"assets/assets/vector/candyvector.svg": "36eb031a885bb3237ceee7fc76b0a27b",
"assets/assets/vector/cat.svg": "5d59131874adfb4198fa1776cdc77308",
"assets/assets/vector/cherries.svg": "a6e867a318e51ecfffebce1baf638f9b",
"assets/assets/vector/cloud.svg": "6e8797e43e8c7b758997fea56294cb44",
"assets/assets/vector/cloudvector.svg": "6e8797e43e8c7b758997fea56294cb44",
"assets/assets/vector/clown.svg": "c12b7465839d143cb760c9437a80529b",
"assets/assets/vector/clownvector.svg": "c12b7465839d143cb760c9437a80529b",
"assets/assets/vector/coffee.svg": "3fc66b1cce4334e429ee83a5c923a352",
"assets/assets/vector/cookie.svg": "caf10f16d8dec09caa886b65a0f3c4eb",
"assets/assets/vector/dog.svg": "08c4505f251bc82ebe02a9c1c9184847",
"assets/assets/vector/dolphin.svg": "f9fc1beb0e7e403707dcccac7cee84c3",
"assets/assets/vector/donut.svg": "4d90253c7701ee411458c3c89b175581",
"assets/assets/vector/fish.svg": "faf3c477570e51f63fe7d4962641a850",
"assets/assets/vector/fishvector.svg": "faf3c477570e51f63fe7d4962641a850",
"assets/assets/vector/fist.svg": "5bf43e1d1d7c62cc12b20f9f718e0dc2",
"assets/assets/vector/fistvector.svg": "5bf43e1d1d7c62cc12b20f9f718e0dc2",
"assets/assets/vector/flashlight.svg": "94f7a46c19cda464b2b0f8f3860900c7",
"assets/assets/vector/gift.svg": "0c28efc76b53c82f1d4c7d7aaa7b6ce5",
"assets/assets/vector/guitar.svg": "4c4a75c5429b2d4d6585ce19087f893a",
"assets/assets/vector/heart.svg": "2f0c096a71906fbec77a6ab4d1855f92",
"assets/assets/vector/key.svg": "9da1493f2a8cafceee1be8b799e717a9",
"assets/assets/vector/lightbulb.svg": "26e5f274601e32c672676fb32b009478",
"assets/assets/vector/microphone.svg": "dde430b0d8bef08ede8cb5ef9485cb4f",
"assets/assets/vector/microphonevector.svg": "dde430b0d8bef08ede8cb5ef9485cb4f",
"assets/assets/vector/microscope.svg": "00e633fa7b8311598537ffebb3a22064",
"assets/assets/vector/microscopevector.svg": "00e633fa7b8311598537ffebb3a22064",
"assets/assets/vector/monkey.svg": "ee6bd0a7c07e2a746e09fcc2d40d79ef",
"assets/assets/vector/moon.svg": "30448c9a9a3647c5a460c4ec2d7d7eec",
"assets/assets/vector/moonvector.svg": "30448c9a9a3647c5a460c4ec2d7d7eec",
"assets/assets/vector/mouse.svg": "9b65c09557db44b1816464f2edb45ac6",
"assets/assets/vector/mousevector.svg": "9b65c09557db44b1816464f2edb45ac6",
"assets/assets/vector/mouth.svg": "6696d101d01bf93d58ad5222ad05d5ec",
"assets/assets/vector/mouthvector.svg": "6696d101d01bf93d58ad5222ad05d5ec",
"assets/assets/vector/pear.svg": "c1f1df9286c0f92512b3de24152e58f0",
"assets/assets/vector/pearvector.svg": "c1f1df9286c0f92512b3de24152e58f0",
"assets/assets/vector/pencil.svg": "9ceae225c127d189b82482e8eb67ef3c",
"assets/assets/vector/pepper.svg": "a2175048f6034479c27469cb3f44424b",
"assets/assets/vector/phone.svg": "0c1386fb73a849861046ac2960a37081",
"assets/assets/vector/printer.svg": "3546ddaa7b730d2da139c4d52a89ab6b",
"assets/assets/vector/rainbow.svg": "900eec5f311c7e27c94b081cc3b06383",
"assets/assets/vector/road.svg": "9e2f6df212d8b9c99d9ea70249c6c1f1",
"assets/assets/vector/roadvector.svg": "9e2f6df212d8b9c99d9ea70249c6c1f1",
"assets/assets/vector/robe.svg": "85baa57f8475220d7760ffd96eeb3291",
"assets/assets/vector/robevector.svg": "85baa57f8475220d7760ffd96eeb3291",
"assets/assets/vector/rocket.svg": "32e1230f6c7b05ccd4341190e8e6459f",
"assets/assets/vector/ruler.svg": "39b1509b9bf16f89d222af37105515de",
"assets/assets/vector/seashell.svg": "dede5dd1fcc8e83dc8385dffb0d28ce7",
"assets/assets/vector/sheep.svg": "dc1a2dcf53ef0b1be006e2d605fec051",
"assets/assets/vector/sheepvector.svg": "dc1a2dcf53ef0b1be006e2d605fec051",
"assets/assets/vector/shield.svg": "8d7751e125a418a8a48e49787c093e66",
"assets/assets/vector/ship.svg": "59ba68fa165825a0df13b3410ba15fcd",
"assets/assets/vector/shipvector.svg": "59ba68fa165825a0df13b3410ba15fcd",
"assets/assets/vector/shoe.svg": "0902252df675e08fc87532e97e83188d",
"assets/assets/vector/shoevector.svg": "0902252df675e08fc87532e97e83188d",
"assets/assets/vector/skate.svg": "86cbf59b00ff21b80122d92fbe2a8a3c",
"assets/assets/vector/skatevector.svg": "86cbf59b00ff21b80122d92fbe2a8a3c",
"assets/assets/vector/snake.svg": "54980e439a3fd0b3f56048f37959642a",
"assets/assets/vector/snakevector.svg": "54980e439a3fd0b3f56048f37959642a",
"assets/assets/vector/snowman.svg": "b2bd83b37b2564885ebb5030f998f3b7",
"assets/assets/vector/spoon.svg": "ef3e19b38b03d8dac82c9358715efe0f",
"assets/assets/vector/spoonvector.svg": "ef3e19b38b03d8dac82c9358715efe0f",
"assets/assets/vector/strawberry.svg": "d338ab0c39173505ac2355b66562af1b",
"assets/assets/vector/sunflower.svg": "c6639d5b5355c6d98fc1be622e0636b2",
"assets/assets/vector/track.svg": "f27ae9f31dce5b34168e53397a58ba5a",
"assets/assets/vector/trackvector.svg": "f27ae9f31dce5b34168e53397a58ba5a",
"assets/assets/vector/trophy.svg": "d5dca3a5be07c2a5829edc1d10d5b0ff",
"assets/assets/vector/truck.svg": "c834006cd5eb27b678488eb453e0b95a",
"assets/assets/vector/truckvector.svg": "c834006cd5eb27b678488eb453e0b95a",
"assets/assets/vector/volcano.svg": "db69f5207d50c8ec4921fd90b1b9179a",
"assets/assets/vector/watermelon.svg": "c82d73fc81e4bb5cfac9a2bcc6cf4216",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "a5212d695f0ab3eb5170a35b96d0954d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"canvaskit/canvaskit.js": "62b9906717d7215a6ff4cc24efbd1b5c",
"canvaskit/canvaskit.wasm": "b179ba02b7a9f61ebc108f82c5a1ecdb",
"canvaskit/profiling/canvaskit.js": "3783918f48ef691e230156c251169480",
"canvaskit/profiling/canvaskit.wasm": "6d1b0fc1ec88c3110db88caa3393c580",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "3eb4669efa6e76ae46cb371106c2603d",
"/": "3eb4669efa6e76ae46cb371106c2603d",
"main.dart.js": "bc26e77bfb777e89ba66f6f9d4e700c9",
"manifest.json": "5c4e6201ac91c218433f368c55c02d3a",
"version.json": "1cb19acdb556177e2f0cb723fb9b845f"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
