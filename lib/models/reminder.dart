import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final int hour;

  @HiveField(4)
  final int minute;

  @HiveField(5)
  final int colorValue;    // ← Nuevo campo para el color de fondo

  Reminder({
    required this.id,
    required this.title,
    required this.message,
    required this.hour,
    required this.minute,
    required this.colorValue,
  });
}
