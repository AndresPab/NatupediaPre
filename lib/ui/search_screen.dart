import 'package:flutter/material.dart';
import '../models/especie.dart';
import '../services/storage_service.dart';
import 'especie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String tipo;
  const SearchScreen({super.key, required this.tipo});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _storage = StorageService();
  final _controller = TextEditingController();
  List<Especie> _results = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String term) async {
    final list = await _storage.searchByTipo(widget.tipo, term);
    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    final placeholder = widget.tipo == 'animal' ? 'Buscar animales' : 'Buscar plantas';
    return Scaffold(
      appBar: AppBar(title: Text(placeholder)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: placeholder,
              border: const OutlineInputBorder(),
            ),
            onChanged: _search,
          ),
        ),
        Expanded(
          child: _results.isEmpty
              ? const Center(child: Text('No hay resultados'))
              : ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (ctx, i) {
                    final e = _results[i];
                    return ListTile(
                      leading: Hero(tag: e.id, child: Image.asset(e.imagePath, width: 48, height: 48)),
                      title: Text(e.nombreComun),
                      subtitle: Text(e.nombreCientifico),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EspecieDetailScreen(especie: e)),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
