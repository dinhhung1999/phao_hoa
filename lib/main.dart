import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/services/notification_service.dart';
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

  // Load custom warehouse names from Firestore (shared across all users)
  await AppConstants.loadWarehouseNames();

  runApp(const PhaoHoaApp());
}
