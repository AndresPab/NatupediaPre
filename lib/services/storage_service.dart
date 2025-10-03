import 'package:hive/hive.dart';
import '../models/especie.dart';

class StorageService {
  static const _boxName = 'especiesBox';

  Future<List<Especie>> getAll() async {
    final box = await Hive.openBox<Especie>(_boxName);
    return box.values.toList();
  }

  Future<List<Especie>> searchByTipo(String tipo, String term) async {
    final all = await getAll();
    final q = term.toLowerCase();
    return all.where((e) {
      return e.tipo == tipo &&
             (e.nombreComun.toLowerCase().contains(q) ||
              e.nombreCientifico.toLowerCase().contains(q));
    }).toList();
  }
}
