// lib/ui/reminder_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder.dart';
import '../services/reminder_service.dart';        // ← import correcto
import '../services/notification_service.dart';    // ← import correcto

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _titleCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _service = ReminderService();             // ← ahora sí encuentra la clase
  bool _showForm = false;
  TimeOfDay _pickedTime = TimeOfDay.now();

  static const List<Color> _availableColors = [
    Color(0xFFFFF8E1),
    Color(0xFFFFF3E0),
    Color(0xFFFFE0B2),
    Color(0xFFFFDAB9),
    Color(0xFFFFCC80),
    Color(0xFFFFAB91),
    Color(0xFFFFCDD2),
    Color(0xFFF8BBD0),
    Color(0xFFE1BEE7),
    Color(0xFFD1C4E9),
    Color(0xFFC5CAE9),
    Color(0xFFBBDEFB),
    Color(0xFFB3E5FC),
    Color(0xFFB2EBF2),
    Color(0xFFB2DFDB),
    Color(0xFFC8E6C9),
    Color(0xFFDCEDC8),
    Color(0xFFF0F4C3),
    Color(0xFFFFF9C4),
    Color(0xFFFFE082),
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = _availableColors.isNotEmpty
        ? _availableColors.first
        : Colors.blue;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _pickedTime,
    );
    if (t != null) setState(() => _pickedTime = t);
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final message = _msgCtrl.text.trim();
    if (title.isEmpty || message.isEmpty) return;

    final id = _service.nextId();
    final r = Reminder(
      id: id,
      title: title,
      message: message,
      hour: _pickedTime.hour,
      minute: _pickedTime.minute,
      colorValue: _selectedColor.value,
      completed: false,
    );
    await _service.add(r);

    _titleCtrl.clear();
    _msgCtrl.clear();
    setState(() {
      _showForm = false;
      _selectedColor = _availableColors.first;
    });
  }

  Future<void> _delete(int id) async => _service.remove(id);

  Future<void> _toggleCompleted(int id, bool? val) async {
    if (val != null) await _service.toggleCompleted(id, val);
  }

  Future<void> _testNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    print('agendando notificacion');
    // Llamamos aquí SIN androidScheduleMode, tu NotificationService ya lo incluye
    await NotificationService().scheduleNotification(
      id: 999,
      title: 'Prueba en 5 s',
      body: 'Si la ves, funciona 👍',
      scheduledDate: now.add(const Duration(seconds: 5)),
    );
  }

  Color _textColorForBackground(Color bg) =>
      bg.computeLuminance() > 0.7 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<Box<Reminder>>(
                valueListenable:
                    Hive.box<Reminder>('remindersBox').listenable(),
                builder: (_, box, __) {
                  final items = box.values.toList();
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('No tienes tareas pendientes'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tus Tareas',
                          style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          key: const PageStorageKey('tareas'),
                          itemCount: items.length,
                          itemExtent: 80,
                          itemBuilder: (_, i) {
                            final r = items[i];
                            final bg = Color(r.colorValue);
                            final fg = _textColorForBackground(bg);
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: r.completed,
                                  onChanged: (v) =>
                                      _toggleCompleted(r.id, v),
                                ),
                                title: Text(
                                  r.title,
                                  style: TextStyle(
                                    color: fg,
                                    decoration: r.completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text(
                                  '${r.hour.toString().padLeft(2, '0')}:'
                                  '${r.minute.toString().padLeft(2, '0')} ‧ ${r.message}',
                                  style: TextStyle(
                                    color: fg.withOpacity(0.9),
                                    decoration: r.completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: fg),
                                  onPressed: () => _delete(r.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            if (_showForm)
              _buildForm()
            else
              Column(
                children: [
                  _buildAddButton(),
                  const SizedBox(height: 8),
                  
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() => ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Crear Tarea'),
        onPressed: () => setState(() => _showForm = true),
      );

  Widget _buildForm() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _msgCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Hora:'),
                const SizedBox(width: 12),
                Text(
                  '${_pickedTime.hour.toString().padLeft(2, '0')}:'
                  '${_pickedTime.minute.toString().padLeft(2, '0')}',
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _pickTime,
                  child: const Text('Seleccionar Hora'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Color:'),
            const SizedBox(height: 8),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _availableColors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final color = _availableColors[i];
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(width: 3, color: Colors.grey.shade700)
                            : null,
                      ),
                      child: isSelected
                          ? Icon(Icons.check,
                              size: 20,
                              color: _textColorForBackground(color))
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(onPressed: _save, child: const Text('Guardar')),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => setState(() => _showForm = false),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      );
}
