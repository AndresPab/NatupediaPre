import 'package:hive/hive.dart';

part 'especie.g.dart';

@HiveType(typeId: 0)
class Especie {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tipo;

  @HiveField(2)
  final String nombreComun;

  @HiveField(3)
  final String nombreCientifico;

  @HiveField(4)
  final String infoGeneral;

  @HiveField(5)
  final String disclaimer;

  @HiveField(6)
  final String imagePath;

  @HiveField(7)
  final Map<String, dynamic> especificos;

  @HiveField(8)
  final List<String> alertas;

  Especie({
    required this.id,
    required this.tipo,
    required this.nombreComun,
    required this.nombreCientifico,
    required this.infoGeneral,
    required this.disclaimer,
    required this.imagePath,
    required this.especificos,
    required this.alertas,
  });

  factory Especie.fromJson(Map<String, dynamic> json) => Especie(
        id: json['id'] as String,
        tipo: json['tipo'] as String,
        nombreComun: json['nombreComun'] as String,
        nombreCientifico: json['nombreCientifico'] as String,
        infoGeneral: json['infoGeneral'] as String,
        disclaimer: (json['disclaimer'] as String?) ?? '',
        imagePath: json['imagePath'] as String,
        especificos: Map<String, dynamic>.from(json['especificos'] as Map),
        alertas: List<String>.from(json['alertas'] as List<dynamic>),
      );
}
