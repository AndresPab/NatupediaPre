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
  final int colorValue;

  @HiveField(6)
  final bool completed;  // ← Nuevo campo para estado de completado

  Reminder({
    required this.id,
    required this.title,
    required this.message,
    required this.hour,
    required this.minute,
    required this.colorValue,
    this.completed = false,
  });

  Reminder copyWith({
    int? id,
    String? title,
    String? message,
    int? hour,
    int? minute,
    int? colorValue,
    bool? completed,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      colorValue: colorValue ?? this.colorValue,
      completed: completed ?? this.completed,
    );
  }
}
