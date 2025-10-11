// lib/ui/plant_list_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({Key? key}) : super(key: key);

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  String _searchTerm = '';
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  void _onSearchChanged(String term) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchTerm = term.toLowerCase());
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
      appBar: AppBar(title: const Text('Plantas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Buscar plantas',
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
                final allPlants = b.values
                    .where((e) => e.tipo.toLowerCase() == 'planta')
                    .toList();

                final filtered = _searchTerm.isEmpty
                    ? allPlants
                    : allPlants.where((e) {
                        final common = e.nombreComun.toLowerCase();
                        final sci = e.nombreCientifico.toLowerCase();
                        return common.contains(_searchTerm) ||
                            sci.contains(_searchTerm);
                      }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay plantas disponibles'));
                }

                return ListView.builder(
                  key: const PageStorageKey('plantList'),
                  itemCount: filtered.length,
                  itemExtent: 72,
                  itemBuilder: (_, i) {
                    final p = filtered[i];
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
                            builder: (_) =>
                                EspecieDetailScreen(especie: p),
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
