bool isSupported() => false;
String permission() => 'unsupported';
Future<bool> requestPermission() async => false;
bool isPageVisible() => true;
void show(
  String title,
  String body,
  String path,
  void Function(String)? onOpen,
) {}
