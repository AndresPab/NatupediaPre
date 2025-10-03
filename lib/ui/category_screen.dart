import 'package:flutter/material.dart';
import 'animal_list_screen.dart';
import 'plant_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores del theme
    final orange = Theme.of(context).colorScheme.secondary;
    final blue   = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Botón grande para Animales
            Expanded(
              child: CategoryCard(
                title: 'Animales',
                icon: Icons.pets,
                color: blue,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnimalListScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Botón grande para Plantas
            Expanded(
              child: CategoryCard(
                title: 'Plantas',
                icon: Icons.local_florist,
                color: orange,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PlantListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
