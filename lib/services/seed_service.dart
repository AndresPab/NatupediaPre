import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../models/especie.dart';

class SeedService {
  static const String _boxName = 'especiesBox';

  Future<void> seed() async {
    // Abre la caja y elimina todo su contenido
    final box = await Hive.openBox<Especie>(_boxName);
    await box.clear();

    // Carga y decodifica el JSON
    final raw = await rootBundle.loadString('assets/especies.json');
    final List<dynamic> data = json.decode(raw) as List<dynamic>;

    // Poblado
    for (final item in data) {
      final esp = Especie.fromJson(item as Map<String, dynamic>);
      await box.put(esp.id, esp);
    }
  }
}
