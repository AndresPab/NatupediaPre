import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';
import 'search_screen.dart'; // ← Importar la pantalla de búsqueda

class PlantListScreen extends StatelessWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Especie>('especiesbox');
    final plants = box.values
        .where((e) => e.tipo.toLowerCase() == 'planta')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(tipo: 'planta'),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: plants.isEmpty
            ? const Center(child: Text('No hay plantas disponibles'))
            : ListView.builder(
                itemCount: plants.length,
                itemBuilder: (_, i) {
                  final p = plants[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          p.imagePath,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(p.nombreComun),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EspecieDetailScreen(especie: p),
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
