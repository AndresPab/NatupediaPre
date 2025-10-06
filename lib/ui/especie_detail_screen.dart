import 'package:flutter/material.dart';
import '../models/especie.dart';

class EspecieDetailScreen extends StatelessWidget {
  final Especie especie;
  const EspecieDetailScreen({super.key, required this.especie});

  static const Map<String, IconData> _iconMap = {
    'clasificacion': Icons.book,
    'dieta': Icons.eco,
    'pesoPromedio': Icons.straighten,
    'riego': Icons.opacity,
    'floracion': Icons.calendar_today,
    'altura': Icons.height,
    'tipsCuidado': Icons.handyman,
  };

  Color _textColorForBackground(Color bg) =>
      bg.computeLuminance() > 0.7 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toInt();
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(especie.nombreComun),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: RepaintBoundary(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: especie.id,
                child: Image.asset(
                  especie.imagePath,
                  height: 280,
                  fit: BoxFit.cover,
                  cacheHeight: 280,
                  cacheWidth: width,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      especie.nombreComun,
                      style: theme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      especie.nombreCientifico,
                      style: theme.titleMedium
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Descripción',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      especie.infoGeneral,
                      style: theme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    if (especie.alertas.isNotEmpty) ...[
                      Text(
                        'Alertas importantes',
                        style: theme.titleMedium
                            ?.copyWith(color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: especie.alertas.map((a) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.red.shade700,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      a,
                                      style: TextStyle(color: Colors.red.shade900),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    const Text(
                      'Detalles',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...especie.especificos.entries.map((entry) {
                      final key = entry.key;
                      final value = entry.value.toString();
                      final label =
                          '${key[0].toUpperCase()}${key.substring(1)}';
                      final icon = _iconMap[key] ?? Icons.info;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(icon, color: Colors.green.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '$label: $value',
                                style: theme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    if (especie.disclaimer.isNotEmpty) ...[
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Aviso',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        especie.disclaimer,
                        style: theme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
