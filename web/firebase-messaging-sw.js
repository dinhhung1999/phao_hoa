/* Firebase Messaging runs separately from the Flutter app when the tab is closed. */
importScripts('https://www.gstatic.com/firebasejs/12.9.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.9.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCaqkAIQzhhFC3MRfMg5faNMfEkUacQgpc',
  authDomain: 'phao-hoa-92aee.firebaseapp.com',
  projectId: 'phao-hoa-92aee',
  storageBucket: 'phao-hoa-92aee.firebasestorage.app',
  messagingSenderId: '329063888564',
  appId: '1:329063888564:web:5098028d67d2daeb2349e1',
});

const messaging = firebase.messaging();
const allowedPaths = new Set([
  '/journal', '/inventory', '/catalog/products', '/catalog/customers',
  '/catalog/formulas', '/warehouses', '/settings',
]);

messaging.onBackgroundMessage((message) => {
  const data = message.data || {};
  const path = allowedPaths.has(data.path) ? data.path : '/journal';
  return self.registration.showNotification(data.title || 'Quản lý Kho Pháo Hoa', {
    body: data.body || 'Có cập nhật mới trong ứng dụng.',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: data.eventId || undefined,
    data: {path},
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const path = event.notification.data?.path || '/journal';
  const url = new URL(path, self.location.origin).href;
  event.waitUntil((async () => {
    const windows = await self.clients.matchAll({type: 'window', includeUncontrolled: true});
    for (const client of windows) {
      if (new URL(client.url).origin === self.location.origin) {
        await client.navigate(url);
        return client.focus();
      }
    }
    return self.clients.openWindow(url);
  })());
});
