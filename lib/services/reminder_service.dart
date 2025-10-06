import 'package:hive/hive.dart';
import '../models/reminder.dart';

class ReminderService {
  static const _boxName = 'remindersBox';
  final Box<Reminder> _box = Hive.box<Reminder>(_boxName);

  List<Reminder> getAll() => _box.values.toList();

  int nextId() {
    final keys = _box.keys.cast<int>();
    return keys.isEmpty ? 1 : (keys.reduce((a, b) => a > b ? a : b) + 1);
  }

  Future<void> add(Reminder r) async {
    await _box.put(r.id, r);
    print('✅ Reminder added: ${r.id}, total now: ${_box.length}');
  }

  Future<void> remove(int id) async {
    await _box.delete(id);
    print('🗑️ Reminder deleted: $id, total now: ${_box.length}');
  }
}
