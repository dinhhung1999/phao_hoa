import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/services/notification_service.dart';
import 'data/datasources/inventory_remote_datasource.dart';
import 'data/datasources/warehouse_remote_datasource.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence for better connectivity
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize dependency injection
  await initDependencies();

  // Initialize notifications & schedule daily reminder from saved settings
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermission();

  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool('reminder_enabled') ?? true;
  if (enabled) {
    final hour = prefs.getInt('reminder_hour') ?? 20;
    final minute = prefs.getInt('reminder_minute') ?? 0;
    await notificationService.scheduleDailyReminder(
        hour: hour, minute: minute);
  }

  // Seed default warehouses if collection is empty (backward-compatible migration)
  try {
    await sl<WarehouseRemoteDatasource>().seedDefaultWarehouses();
  } catch (_) {
    // Non-critical — warehouses may already exist or user not yet authenticated
  }

  // Load warehouse keys/names into AppConstants for backward-compatible UI usage
  await AppConstants.loadWarehouseNames();

  // One-time migration: fix corrupted flat 'stock_by_location.xxx' fields
  // created by the old dot-notation bug in batch.set()+merge:true
  try {
    await sl<InventoryRemoteDatasource>().migrateCorruptedStockFields();
  } catch (_) {
    // Non-critical — app works with read-side recovery in fromFirestore
  }

  runApp(const PhaoHoaApp());
}

