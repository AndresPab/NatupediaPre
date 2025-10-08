// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService _instance =
      NotificationService._privateConstructor();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required tz.TZDateTime scheduledDate,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      null, // sin body
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'natupedia_channel',       // id del canal
          'Recordatorios',          // nombre visible
          channelDescription: 'Alertas de tareas',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) => _plugin.cancel(id);
}
