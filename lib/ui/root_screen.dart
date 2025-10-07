// lib/ui/root_screen.dart

import 'package:flutter/material.dart';
import '../main.dart'; // para acceder a themeNotifier
import 'category_screen.dart';
import 'reminder_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    CategoryScreen(),
    ReminderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Natupedia'),
        actions: [
          // Switch para alternar claro/oscuro
          Switch(
            value: isDark,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (v) {
              themeNotifier.value =
                  v ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
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
