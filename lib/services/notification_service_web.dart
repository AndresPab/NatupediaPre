// lib/services/notification_service_web.dart

import 'package:flutter/material.dart';

class NotificationService {
  Future<void> init() async {}
  Future<void> showWelcome() async {}
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {}
  Future<void> cancel(int id) async {}
}
