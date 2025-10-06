import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';
import 'search_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final box = Hive.box<Especie>('especiesbox');
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
        child: ValueListenableBuilder<Box<Especie>>(
          valueListenable: box.listenable(),
          builder: (_, b, __) {
            final animals = b.values
                .where((e) => e.tipo.toLowerCase() == 'animal')
                .toList();
            if (animals.isEmpty) {
              return const Center(child: Text('No hay animales disponibles'));
            }
            return RepaintBoundary(
              child: ListView.builder(
                itemCount: animals.length,
                itemExtent: 72,
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
                          cacheWidth: 100,
                          cacheHeight: 100,
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
            );
          },
        ),
      ),
    );
  }
}
