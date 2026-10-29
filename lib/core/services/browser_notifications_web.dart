import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

bool isSupported() => globalContext.hasProperty('Notification'.toJS).toDart;

bool isPageVisible() => web.window.document.visibilityState == 'visible';

void show(
  String title,
  String body,
  String path,
  void Function(String)? onOpen,
) {
  if (!isSupported() || web.Notification.permission != 'granted') return;
  final notification = web.Notification(
    title,
    web.NotificationOptions(body: body, icon: '/icons/Icon-192.png'),
  );
  notification.onclick = ((web.Event _) {
    notification.close();
    onOpen?.call(path);
  }).toJS;
}
