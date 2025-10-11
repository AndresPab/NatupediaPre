// lib/ui/animal_list_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({Key? key}) : super(key: key);

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String _searchTerm = '';
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  void _onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchTerm = term.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final box = Hive.box<Especie>('especiesBox');

    return Scaffold(
      appBar: AppBar(title: const Text('Animales')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar animales',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Especie>>(
              valueListenable: box.listenable(),
              builder: (_, b, __) {
                final allAnimals = b.values
                    .where((e) => e.tipo.toLowerCase() == 'animal')
                    .toList();
                final filtered = _searchTerm.isEmpty
                    ? allAnimals
                    : allAnimals.where((e) {
                        final common = e.nombreComun.toLowerCase();
                        final sci = e.nombreCientifico.toLowerCase();
                        return common.contains(_searchTerm) ||
                            sci.contains(_searchTerm);
                      }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                      child: Text('No hay animales disponibles'));
                }

                return ListView.builder(
                  key: const PageStorageKey('animalList'),
                  itemCount: filtered.length,
                  itemExtent: 72,
                  itemBuilder: (_, i) {
                    final a = filtered[i];
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
                            builder: (_) =>
                                EspecieDetailScreen(especie: a),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
