'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "585e99c52863f859b8dc724b34df45a4",
"assets/assets/audio/ball.wav": "2b34468fdb067b216d2114931a062a7b",
"assets/assets/audio/balloon.wav": "42e7104fb2dfa9d54d219299af5d6e76",
"assets/assets/audio/banana.wav": "6dbf81d7b166e9c0cd8ccefff1e41cb6",
"assets/assets/audio/barrel.wav": "b25491ced11af80c567a24daa77c92d6",
"assets/assets/audio/bat.wav": "bc68e9dcc6aa65d8c33195cab8fca294",
"assets/assets/audio/bicycle.wav": "6be1ef6ca7f80c79b7e00f8060a0a0e8",
"assets/assets/audio/boar.wav": "f6992525fb906132572087037f70bc3e",
"assets/assets/audio/book.wav": "0d81b650da770aea11d50fdc27ba93c6",
"assets/assets/audio/butterfly.wav": "1041e4a9050bb0193cc48ac39db1fe72",
"assets/assets/audio/cactus.wav": "311d28b7cd55ff259ff02ec3c2975500",
"assets/assets/audio/cake.wav": "d0bde9f0932289f8a41d3a0cee4cb672",
"assets/assets/audio/camera.wav": "b1eba9109b71ffdf19da98f2ff8522d8",
"assets/assets/audio/candle.wav": "648317f5caa31974d5ea42da969d0657",
"assets/assets/audio/candy.wav": "f8c4353a2e82807818c050853fddf796",
"assets/assets/audio/cat.wav": "4c7d6bbfa44f83b83901c88cf3af064d",
"assets/assets/audio/cherries.wav": "05cf27886c780198f965a312f81f437c",
"assets/assets/audio/cloud.wav": "dd34966a4e6a35351b4c3a2b81ff2532",
"assets/assets/audio/clown.wav": "4ac5b4371d54458e6f9fe43a02bf39be",
"assets/assets/audio/coffee.wav": "12799fbb9c4e2f4d13f2156c9c57436a",
"assets/assets/audio/cookie.wav": "fbbc644de99a1aed4983c44eae3b3ced",
"assets/assets/audio/dog.wav": "c38b096c9788820d5646f6440375f16f",
"assets/assets/audio/dolphin.wav": "e1dc5d071ee2787754d3841fa5044fd6",
"assets/assets/audio/donut.wav": "d538f3b82976c6a695bc4f581efac66c",
"assets/assets/audio/fish.wav": "00d96fb779bf8516fae5c796034ece23",
"assets/assets/audio/fist.wav": "9c2be398fb847244f60e438a6ed0a749",
"assets/assets/audio/flashlight.wav": "8c9a9fc69f4e0867254ab5ec80d4a648",
"assets/assets/audio/gift.wav": "4297edc0a9e9cea22c0b61e4d66ffbbd",
"assets/assets/audio/guitar.wav": "b17cd3bb249fafb896ebfa125729c3f8",
"assets/assets/audio/key.wav": "decb506aa778c275eedae317ece1b321",
"assets/assets/audio/lightbulb.wav": "4d90d249b3e786b58706622d3abd9922",
"assets/assets/audio/microphone.wav": "53f723be55a453019e343fee356cce0c",
"assets/assets/audio/microscope.wav": "8318fca42f1a12eebb1fbe9cf38c5fd5",
"assets/assets/audio/monkey.wav": "7177f666590b852ab1b5e966ec67938c",
"assets/assets/audio/moon.wav": "3ae9fae6e7a3b0ed8f512b1d6222a476",
"assets/assets/audio/mouse.wav": "1b515fc5db52cd27d75ba0d7e9cab435",
"assets/assets/audio/mouth.wav": "5f150fdb44a787e98b7125300ca78e1a",
"assets/assets/audio/pear.wav": "9c620266b8dc5425196aeaa209a8745d",
"assets/assets/audio/pencil.wav": "942ae5782a03cebff1b77ecca960ddac",
"assets/assets/audio/pepper.wav": "51493298f48c9f5896d0f045eb1206f0",
"assets/assets/audio/phone.wav": "0af5c1475d73f5a15d66be70546d3aff",
"assets/assets/audio/printer.wav": "5a59c7a0e722670839c150c18416e98c",
"assets/assets/audio/rainbow.wav": "e94f87d2ab53c1d7674c85fb38ef69c4",
"assets/assets/audio/road.wav": "e55982a91ff31ce11b4fbcc86fe51f86",
"assets/assets/audio/robe.wav": "b812e85c9a01acc01b680df949d2c6b8",
"assets/assets/audio/rocket.wav": "0da4fd06011e2b40d06169d5dec6e231",
"assets/assets/audio/ruler.wav": "e2e0da3d69bbb764b22d042259be3f19",
"assets/assets/audio/seashell.wav": "6cb255fcb32e61a3697f1c268d485736",
"assets/assets/audio/sheep.wav": "10255b5392c4dcafe89a2fe3f260f876",
"assets/assets/audio/shield.wav": "379b2d7873b08ad4523bc468c497be97",
"assets/assets/audio/ship.wav": "47004763b0f8f7c8a1e747a3f69f48a4",
"assets/assets/audio/shoe.wav": "89cf429f58ad466f45417b62c5a16f7f",
"assets/assets/audio/skate.wav": "4635f16b261d5df69f43f32b7f438755",
"assets/assets/audio/snake.wav": "7093d8d99aa31225eba4789daa3925de",
"assets/assets/audio/snowman.wav": "dacf1682cb00ef871bdd73827846013f",
"assets/assets/audio/spoon.wav": "a9aeea9ccff1aa2f7238b5bd4d6caf89",
"assets/assets/audio/strawberry.wav": "30679d556efdb473c2e3e18e4e8f63fc",
"assets/assets/audio/sunflower.wav": "69ae97c971e470b630a2a41636a50249",
"assets/assets/audio/track.wav": "bf0299b2b77f647fe912e443eedf0ad0",
"assets/assets/audio/trophy.wav": "cf6b4e045f07cceb7e797e076ef4dddf",
"assets/assets/audio/truck.wav": "9e4ad8837ff4f35c17220de779ac546e",
"assets/assets/audio/volcano.wav": "82029c7004a81a02eca716fe0cf3f0fe",
"assets/assets/audio/watermelon.wav": "a52a6875c8c19defe2435d540480b210",
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
"assets/NOTICES": "42914d4e5ab4f6d46677551069d97498",
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
"index.html": "e140cebe2170ea50230dcb7d640ea832",
"/": "e140cebe2170ea50230dcb7d640ea832",
"main.dart.js": "fcc8c1dda1b2b74f279352f0a8e927a1",
"manifest.json": "5c4e6201ac91c218433f368c55c02d3a",
"version.json": "ca4235ab236cb9370ce42443634bdd59"
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
