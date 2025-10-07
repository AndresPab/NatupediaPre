// lib/ui/root_screen.dart

import 'package:flutter/material.dart';
import 'category_screen.dart';   // ← Importa tu archivo existente
import 'reminder_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  // Usa tu CategoryScreen y tu ReminderScreen
  static const List<Widget> _pages = [
    CategoryScreen(),
    ReminderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Tareas',
          ),
        ],
      ),
    );
  }
}
