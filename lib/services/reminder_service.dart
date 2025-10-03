import 'package:hive/hive.dart';
import '../models/reminder.dart';

class ReminderService {
  static const _boxName = 'remindersBox';

  Future<Box<Reminder>> _openBox() =>
      Hive.openBox<Reminder>(_boxName);

  Future<List<Reminder>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<int> nextId() async {
    final box = await _openBox();
    final keys = box.keys.cast<int>();
    if (keys.isEmpty) return 1;
    return keys.reduce((a, b) => a > b ? a : b) + 1;
  }

  Future<void> add(Reminder reminder) async {
    final box = await _openBox();
    await box.put(reminder.id, reminder);
  }

  Future<void> remove(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
