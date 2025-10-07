import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'category_screen.dart';
import 'reminder_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  // Pantallas: primero categorías, luego tareas
  final List<Widget> _screens = const [
    CategoryScreen(),
    ReminderScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Precarga dinámica de imágenes justo después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  Future<void> _precacheImages() async {
    final box = Hive.box<Especie>('especiesbox');
    for (final especie in box.values) {
      await precacheImage(AssetImage(especie.imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            activeIcon: Icon(Icons.checklist_rtl_rounded),
            label: 'Tareas',
          ),
        ],
      ),
    );
  }
}
