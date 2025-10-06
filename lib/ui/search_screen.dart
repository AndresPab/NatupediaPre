import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/especie.dart';
import 'especie_detail_screen.dart';

/// Parámetros para el isolate de búsqueda
class _FilterParams {
  final String tipo;
  final String term;
  _FilterParams(this.tipo, this.term);
}

/// Función que se ejecuta en isolate para filtrar sin bloquear UI
Future<List<Especie>> _searchIsolate(_FilterParams params) async {
  final box = Hive.box<Especie>('especiesbox');
  final lowerTerm = params.term.toLowerCase();
  return box.values.where((e) {
    return e.tipo.toLowerCase() == params.tipo &&
        (e.nombreComun.toLowerCase().contains(lowerTerm) ||
         e.nombreCientifico.toLowerCase().contains(lowerTerm));
  }).toList();
}

class SearchScreen extends StatefulWidget {
  final String tipo;
  const SearchScreen({super.key, required this.tipo});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();
  List<Especie> _results = [];
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Búsqueda inicial sin término
    _onSearchChanged('');
  }

  void _onSearchChanged(String term) {
    // Cancelar debounce anterior
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      // Usamos isolate para no bloquear UI
      final results = await compute<_FilterParams, List<Especie>>(
        _searchIsolate,
        _FilterParams(widget.tipo, term),
      );
      if (!mounted) return;
      setState(() {
        _results = results;
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
    super.build(context); // Para AutomaticKeepAliveClientMixin
    final placeholder =
        widget.tipo == 'animal' ? 'Buscar animales' : 'Buscar plantas';

    return Scaffold(
      appBar: AppBar(title: Text(placeholder)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: placeholder,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('No hay resultados'))
                : RepaintBoundary(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemExtent: 72,
                      itemBuilder: (ctx, i) {
                        final e = _results[i];
                        return ListTile(
                          leading: Hero(
                            tag: e.id,
                            child: Image.asset(
                              e.imagePath,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              cacheWidth: 100,
                              cacheHeight: 100,
                            ),
                          ),
                          title: Text(e.nombreComun),
                          subtitle: Text(e.nombreCientifico),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    EspecieDetailScreen(especie: e),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
