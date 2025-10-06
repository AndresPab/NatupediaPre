import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _titleCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _service = ReminderService();

  bool _showForm = false;
  List<Reminder> _list = [];
  TimeOfDay _pickedTime = TimeOfDay.now();

  // Paleta extensa y suave
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

  Color _selectedColor = const Color(0xFFFFCC80);

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    _list = await _service.getAll();
    setState(() {});
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

    final id = await _service.nextId();
    final reminder = Reminder(
      id: id,
      title: title,
      message: message,
      hour: _pickedTime.hour,
      minute: _pickedTime.minute,
      colorValue: _selectedColor.value,
    );
    await _service.add(reminder);

    _titleCtrl.clear();
    _msgCtrl.clear();
    setState(() {
      _showForm = false;
      _selectedColor = _availableColors.first;
    });
    await _loadList();
  }

  Future<void> _delete(Reminder r) async {
    await _service.remove(r.id);
    await _loadList();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Color _textColorForBackground(Color bg) {
    // Si la luminancia es alta, usar texto oscuro; si baja, texto claro
    return bg.computeLuminance() > 0.7 ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recordatorios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Lista de notas
            if (_list.isNotEmpty) ...[
              const Text('Tus Tareas', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (_, i) {
                    final r = _list[i];
                    final bg = Color(r.colorValue);
                    final textColor = _textColorForBackground(bg);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(r.title, style: TextStyle(color: textColor)),
                        subtitle: Text(
                          '${r.hour.toString().padLeft(2, '0')}:'
                          '${r.minute.toString().padLeft(2, '0')} ‧ ${r.message}',
                          style: TextStyle(color: textColor.withOpacity(0.9)),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: textColor),
                          onPressed: () => _delete(r),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              const Expanded(
                child: Center(child: Text('No tienes tareas pendientes')),
              ),
            ],

            const SizedBox(height: 12),

            // Formulario de nueva nota
            if (_showForm)
              _buildForm()
            else
              _buildAddButton(),
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

  Widget _buildForm() => Column(
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

          // Selector de color horizontal, scrollable y compacto
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final color = _availableColors[i];
                final isSelected = color == _selectedColor;
                final border = isSelected
                    ? Border.all(width: 3, color: Colors.grey.shade700)
                    : null;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: border,
                    ),
                    child: isSelected
                        ? Icon(Icons.check,
                            size: 20, color: _textColorForBackground(color))
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
        ],
      );
}
