import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';
import 'search_screen.dart'; // ← Importar la pantalla de búsqueda

class AnimalListScreen extends StatelessWidget {
  const AnimalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Especie>('especiesbox');
    final animals = box.values
        .where((e) => e.tipo.toLowerCase() == 'animal')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animales'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(tipo: 'animal'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: animals.isEmpty
            ? const Center(child: Text('No hay animales disponibles'))
            : ListView.builder(
                itemCount: animals.length,
                itemBuilder: (_, i) {
                  final a = animals[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          a.imagePath,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(a.nombreComun),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EspecieDetailScreen(especie: a),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
