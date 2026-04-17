import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phao_hoa/app.dart';
import 'package:phao_hoa/firebase_options.dart';
import 'package:phao_hoa/injection_container.dart';

/// Entry point riêng cho integration test.
/// Bỏ qua seed warehouses, migration, notifications
/// vì chúng cần auth hoặc native permissions.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firestore settings
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize DI
  await initDependencies();

  // Skip: seedDefaultWarehouses (cần auth)
  // Skip: loadWarehouseNames (cần auth)
  // Skip: migrateCorruptedStockFields (cần auth)
  // Skip: notifications (cần native permission)

  runApp(const PhaoHoaApp());
}
