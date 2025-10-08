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

  /// Inicializa los settings de Android y iOS
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  /// Programa una notificación única en [scheduledDate] (zona horaria local).
  Future<void> scheduleNotification({
    required int id,
    required String title,
    String? body,
    required tz.TZDateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'natupedia_channel',
      'Recordatorios Natupedia',
      channelDescription: 'Alertas de tareas',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      // Parametro obligatorio desde la v19:
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Si en el futuro necesitas recurrencia, puedes usar:
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancela la notificación con [id].
  Future<void> cancelNotification(int id) => _plugin.cancel(id);
}
