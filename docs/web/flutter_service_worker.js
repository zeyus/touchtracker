'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "585e99c52863f859b8dc724b34df45a4",
"assets/assets/audio/ball.wav": "06b5ac21e678f6c76b2970c6a8a33fa9",
"assets/assets/audio/balloon.wav": "63b65073dabf8675d021f1f78a851db2",
"assets/assets/audio/banana.wav": "e3213799bcdbab688ba26bfc588ee6a6",
"assets/assets/audio/barrel.wav": "b96f7d7c395f0debb40bd8cbd2dd72eb",
"assets/assets/audio/bat.wav": "24bf69164b4fe59cbb1304218f350f3e",
"assets/assets/audio/bicycle.wav": "c86e28438bd97bceb1139753aaeac5fd",
"assets/assets/audio/boar.wav": "486151876e804e23d34ea3d51f3b589c",
"assets/assets/audio/book.wav": "ac0adc8f74000f15e7941182ad9e46c7",
"assets/assets/audio/butterfly.wav": "ae6d078f0fd08f42ef42a1f5280536da",
"assets/assets/audio/cactus.wav": "e689ed37538db91c4fcf711c642a5b42",
"assets/assets/audio/cake.wav": "5278d44ded1f96b856d7b6eecdbe8d0a",
"assets/assets/audio/camera.wav": "b206e452b57e69625b88f7aaa5c5c2e4",
"assets/assets/audio/candle.wav": "b325634fd136c2b93230ddb043b268b5",
"assets/assets/audio/candy.wav": "c05bc2a0339887ba9566405f63d56115",
"assets/assets/audio/cat.wav": "10481bf37406d2d3657f9d4cd3b37052",
"assets/assets/audio/cherries.wav": "37a34c47c30ad2c135127912b5e5fcfc",
"assets/assets/audio/cloud.wav": "10a85b16edc74c3e137d3fe0ceb51df6",
"assets/assets/audio/clown.wav": "369626b346f43a833de8fc140fba4310",
"assets/assets/audio/coffee.wav": "723f501aecc5a98a71dcd724e575653b",
"assets/assets/audio/cookie.wav": "0d4a75953df64362d1d4267dba0f2667",
"assets/assets/audio/dog.wav": "bb20e3667948a450688396ab6cf22ff9",
"assets/assets/audio/dolphin.wav": "411e44e0987d2eca1baa93cd060db645",
"assets/assets/audio/donut.wav": "e1857c18a1e677409e48e9ab84f145e4",
"assets/assets/audio/fish.wav": "d534e635bf1696c45adc093428f529fb",
"assets/assets/audio/fist.wav": "00c825e481b947a8aa5edfc5d42c634c",
"assets/assets/audio/flashlight.wav": "f9ab2722a42f18badc43e9e3d8f3cb80",
"assets/assets/audio/gift.wav": "070218ca257759e4d3189d7457694e14",
"assets/assets/audio/guitar.wav": "648f2240353f54d3300eb196d0e71a47",
"assets/assets/audio/key.wav": "a54f6b0b513771348ac5b58476a1d5e3",
"assets/assets/audio/lightbulb.wav": "d4fe8395a448248cf9f80577ff7e3448",
"assets/assets/audio/microphone.wav": "88125391de4ed90c3a8c2e85328f42f0",
"assets/assets/audio/microscope.wav": "ab5d6dc04dcbf73a2cfa5eeb4ee6bd7f",
"assets/assets/audio/monkey.wav": "bc4b052a3d53cd3d3051eda2c382ed49",
"assets/assets/audio/moon.wav": "076989b87131c8cc337affe6f142951b",
"assets/assets/audio/mouse.wav": "0684293b6d5034866259c65c12a2aade",
"assets/assets/audio/mouth.wav": "066c2686656318215048c37030642455",
"assets/assets/audio/pear.wav": "32fab7eb956aa668ad1764c6d320d510",
"assets/assets/audio/pencil.wav": "2e7685e64a7180f1f6af639d5c9dea0e",
"assets/assets/audio/pepper.wav": "b1b56c1ae50d7f95ae2c4184d0b81f3d",
"assets/assets/audio/phone.wav": "9adf63d8941c95f3568ae48da3cca8f9",
"assets/assets/audio/printer.wav": "d95ad48df9e28c0957406b5a756ba528",
"assets/assets/audio/rainbow.wav": "f01d1dcb9ba43fe892c22f528bdc00a4",
"assets/assets/audio/road.wav": "30a424c1bc0bbd73a4b3a27e82254ed8",
"assets/assets/audio/robe.wav": "3b77642b00bdfaefbb286ff072372a5e",
"assets/assets/audio/rocket.wav": "4bc4fae328a042d9fd82b7c1e0455790",
"assets/assets/audio/ruler.wav": "53184a978e59c503deb8ff8b5114e8be",
"assets/assets/audio/seashell.wav": "e8f213ef11d772974a96efa62a01b2bd",
"assets/assets/audio/sheep.wav": "b56eea39a135f3cb7d8c80a921d1287c",
"assets/assets/audio/shield.wav": "ba9e6092bfa0319f64f8b9c6d4438c09",
"assets/assets/audio/ship.wav": "9483e445f54ef2acf4b926b9178495da",
"assets/assets/audio/shoe.wav": "dbae25e0ca755d321cc2e5d7daf83776",
"assets/assets/audio/skate.wav": "28c4fbb0a45af146a7936d3374645600",
"assets/assets/audio/snake.wav": "e292b4f8d5734de7f712f9da6eab3aaa",
"assets/assets/audio/snowman.wav": "60c1d4b3a6a36291882fe3ae936be4ff",
"assets/assets/audio/spoon.wav": "74887d6785e84d80bdd354c3e68170fd",
"assets/assets/audio/strawberry.wav": "1f3ff5124121d2ccf8928f140e338bb1",
"assets/assets/audio/sunflower.wav": "5c7785bfb2efebb3bb159187117ce832",
"assets/assets/audio/track.wav": "dd81e582b10edec7d2aad8c74c1a9c35",
"assets/assets/audio/trophy.wav": "bd6da5f2224860d15cc41c2fccbf7334",
"assets/assets/audio/truck.wav": "8de46a802f75491c40700b627225d34d",
"assets/assets/audio/volcano.wav": "b926c83d38cc70496338c9e3294d00b6",
"assets/assets/audio/watermelon.wav": "84a4d1ad9d4c679d9a7e8d31148409e5",
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
"assets/NOTICES": "2464b08ee88748bd26c8eed9812f356b",
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
"index.html": "0d75853a42dd1a711d2d8c4ef87ba9f4",
"/": "0d75853a42dd1a711d2d8c4ef87ba9f4",
"main.dart.js": "3475e9173e9cce7238e9d106a7fe91da",
"manifest.json": "5c4e6201ac91c218433f368c55c02d3a",
"version.json": "6ed2638345ed4ec0029f45887ecdba1c"
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
