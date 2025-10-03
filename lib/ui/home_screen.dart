import 'package:flutter/material.dart';
import 'animal_list_screen.dart';
import 'plant_list_screen.dart';
import 'especie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Natupedia'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Animales'),
              Tab(text: 'Plantas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AnimalListScreen(),
            PlantListScreen(),
          ],
        ),
      ),
    );
  }
}
