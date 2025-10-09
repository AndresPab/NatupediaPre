// lib/services/notification_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._privateConstructor();
  static final NotificationService _instance =
      NotificationService._privateConstructor();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa los settings de Android y iOS y crea el canal en Android.
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      ),
    );

    // Crea el canal de notificaciones Android
    const channel = AndroidNotificationChannel(
      'natupedia_channel',
      'Recordatorios Natupedia',
      description: 'Alertas de tareas',
      importance: Importance.max,
    );

    final androidPlatform = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlatform != null) {
      await androidPlatform.createNotificationChannel(channel);
      debugPrint('✅ Canal natupedia_channel creado');
    }
  }

  /// Programa una notificación única en [scheduledDate].
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

    try {
      debugPrint('[🔔] Intentando agendar notificación $id a $scheduledDate');
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('[🔔] scheduleNotification completado para $id');
    } catch (e, stack) {
      debugPrint('[❌] Error en scheduleNotification: $e\n$stack');
    }
  }

  /// Cancela la notificación con [id].
  Future<void> cancelNotification(int id) =>
      _plugin.cancel(id);
}
