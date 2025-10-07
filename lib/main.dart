import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/especie.dart';
import 'models/reminder.dart';
import 'services/seed_service.dart';
import 'ui/root_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EspecieAdapter());
  Hive.registerAdapter(ReminderAdapter());

  await Hive.openBox<Especie>('especiesbox');
  await Hive.openBox<Reminder>('remindersBox');

  print(
    "Hive cajas abiertas: "
    "especiesbox=${Hive.isBoxOpen('especiesbox')}, "
    "remindersBox=${Hive.isBoxOpen('remindersBox')}"
  );

  await SeedService().seed();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color pastelOrange = Color(0xFFFFCC80);
  static const Color pastelBlue = Color(0xFF81D4FA);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return MaterialApp(
      title: 'Natupedia',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          primary: pastelBlue,
          secondary: pastelOrange,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: pastelBlue,
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
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
        textTheme: GoogleFonts.latoTextTheme(base.textTheme),
      ),
      home: RootScreen(), // removed `const` so RootScreen is resolved at runtime
    );
  }
}
