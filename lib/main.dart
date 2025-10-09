// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'services/notification_service.dart';
import 'services/seed_service.dart';
import 'models/especie.dart';
import 'models/reminder.dart';
import 'ui/splash_screen.dart';

/// ValueNotifier global que expone el ThemeMode activo.
final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive y registrar adaptadores
  await Hive.initFlutter();
  Hive.registerAdapter(EspecieAdapter());
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Especie>('especiesBox');
  await Hive.openBox<Reminder>('remindersBox');

  // Inicializar zonas horarias
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Bogota'));

  // Solicitar permisos en Android 13+ (API 33+) y Android 14
  final notifStatus = await Permission.notification.request();
  if (!notifStatus.isGranted) {
    // Opcional: mostrar diálogo explicando por qué necesita permisos
  }

  final alarmStatus = await Permission.scheduleExactAlarm.request();
  if (!alarmStatus.isGranted) {
    // Opcional: invitar al usuario a habilitar Alarmas Exactas en ajustes
  }

  // Inicializar el servicio de notificaciones
  await NotificationService().init();

  // Sembrar datos iniciales
  await SeedService().seed();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ThemeData.light()
        .colorScheme
        .copyWith(primary: const Color(0xFF81D4FA), secondary: const Color(0xFFFFCC80)),
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF81D4FA),
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF81D4FA),
      unselectedItemColor: Colors.grey.shade600,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFCC80),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF81D4FA),
        side: const BorderSide(color: Color(0xFF81D4FA)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF81D4FA)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark()
        .colorScheme
        .copyWith(primary: const Color(0xFF80CBC4), secondary: const Color(0xFFFFAB91)),
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF80CBC4),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade900,
      selectedItemColor: const Color(0xFF80CBC4),
      unselectedItemColor: Colors.grey.shade500,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFAB91),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF80CBC4),
        side: const BorderSide(color: Color(0xFF80CBC4)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF80CBC4)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Natupedia',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
