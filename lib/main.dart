// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/especie.dart';
import 'models/reminder.dart';
import 'services/seed_service.dart';
import 'ui/splash_screen.dart';    // ← Asegúrate de que esta línea esté presente
// import 'ui/root_screen.dart';  // ya no es el home directo

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EspecieAdapter());
  Hive.registerAdapter(ReminderAdapter());

  await Hive.openBox<Especie>('especiesbox');
  await Hive.openBox<Reminder>('remindersBox');

  await SeedService().seed();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color pastelOrange = Color(0xFFFFCC80);
  static const Color pastelBlue   = Color(0xFF81D4FA);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return MaterialApp(
      title: 'Natupedia',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        colorScheme: base.colorScheme
            .copyWith(primary: pastelBlue, secondary: pastelOrange),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.latoTextTheme(base.textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: pastelBlue,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: pastelBlue,
          unselectedItemColor: Colors.grey.shade600,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: pastelOrange,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: pastelBlue,
            side: BorderSide(color: pastelBlue),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: pastelBlue),
          ),
        ),
      ),
      home: const SplashScreen(),  // ← aquí sí existe SplashScreen
    );
  }
}
