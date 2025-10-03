import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el plugin y las zonas horarias
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );
  }

  /// Muestra la notificación de bienvenida
  Future<void> showWelcome() async {
    const androidDetails = AndroidNotificationDetails(
      'natupedia_channel',
      'Natupedia Alerts',
      channelDescription: 'Notificaciones Natupedia',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      0,
      '¡Bienvenido a Natupedia!',
      'Explora animales y plantas offline.',
      details,
    );
  }

  /// Programa un recordatorio diario a la hora indicada
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    if (kIsWeb) return;

    final now = tz.TZDateTime.now(tz.local);
    var first = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (first.isBefore(now)) {
      first = first.add(const Duration(days: 1));
    }

    print('⏲️ [NotificationService] Scheduling daily alarm id=$id at $first');

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      id,
      alarmCallback,          // ← Ahora público
      startAt: first,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  /// Cancela la alarma y elimina la notificación pendiente
  Future<void> cancel(int id) async {
    if (!kIsWeb) {
      await AndroidAlarmManager.cancel(id);
    }
    await _plugin.cancel(id);
  }

  /// Callback expuesto para AlarmManager (debe ser público)
  @pragma('vm:entry-point')
  static Future<void> alarmCallback(int id) async {
    print('🔔 [NotificationService] Alarm callback triggered for id=$id');

    // Inicializa Hive en este isolate
    await Hive.initFlutter();
    Hive.registerAdapter(ReminderAdapter());
    final box = await Hive.openBox<Reminder>('remindersbox');
    final reminder = box.get(id);
    if (reminder == null) {
      print('⚠️ [NotificationService] No reminder found for id=$id');
      return;
    }

    // Inicializa el plugin de notificaciones en este isolate
    final flnp = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await flnp.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    print('🔔 [NotificationService] Showing notification for id=$id');

    const androidDetails = AndroidNotificationDetails(
      'natupedia_channel', 'Natupedia Alerts',
      channelDescription: 'Notificaciones Natupedia',
      importance: Importance.max, priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flnp.show(id, reminder.title, reminder.message, details);
  }
}
