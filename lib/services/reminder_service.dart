// lib/services/reminder_service.dart

import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder.dart';
import 'notification_service.dart';

class ReminderService {
  static const _boxName = 'remindersBox';
  final Box<Reminder> _box = Hive.box<Reminder>(_boxName);
  final _notifier = NotificationService();

  List<Reminder> getAll() => _box.values.toList();

  int nextId() {
    final keys = _box.keys.cast<int>();
    return keys.isEmpty ? 1 : (keys.reduce((a, b) => a > b ? a : b) + 1);
  }

  Future<void> add(Reminder r) async {
    await _box.put(r.id, r);
    // Programa la notificación
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      r.hour,
      r.minute,
    );
    // Si la hora ya pasó hoy, programa para mañana
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _notifier.scheduleNotification(
      id: r.id,
      title: r.title,
      scheduledDate: scheduled,
    );
  }

  Future<void> remove(int id) async {
    await _box.delete(id);
    // Cancela la notificación
    await _notifier.cancelNotification(id);
  }

  Future<void> toggleCompleted(int id, bool completed) async {
    final existing = _box.get(id);
    if (existing == null) return;
    final updated = existing.copyWith(completed: completed);
    await _box.put(id, updated);
    // Si lo completó antes de la hora, también cancelar notificación
    if (completed) {
      await _notifier.cancelNotification(id);
    }
  }
}
