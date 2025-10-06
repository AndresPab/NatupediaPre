import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';
import 'search_screen.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final box = Hive.box<Especie>('especiesbox');
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
        child: ValueListenableBuilder<Box<Especie>>(
          valueListenable: box.listenable(),
          builder: (_, b, __) {
            final plants = b.values
                .where((e) => e.tipo.toLowerCase() == 'planta')
                .toList();
            if (plants.isEmpty) {
              return const Center(child: Text('No hay plantas disponibles'));
            }
            return RepaintBoundary(
              child: ListView.builder(
                itemCount: plants.length,
                itemExtent: 72,
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
                          cacheWidth: 100,
                          cacheHeight: 100,
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
            );
          },
        ),
      ),
    );
  }
}
