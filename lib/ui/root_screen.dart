import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'notifications_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  // Ahora primero va CategoryScreen, luego Notificaciones (Tareas)
  final List<Widget> _screens = const [
    CategoryScreen(),
    NotificationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Precache de AssetImages para evitar parones cuando se muestran por primera vez
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheImages();
    });
  }

  void _precacheImages() {
    const assets = [
      'assets/images/gato.png',
      'assets/images/perro.png',
      'assets/images/loro.png',
      'assets/images/caballo.png',
      'assets/images/conejo.png',
      'assets/images/pez_payaso.png',
      'assets/images/tortuga.png',
      'assets/images/camaleon.png',
      'assets/images/rosa.png',
      'assets/images/orquidea.png',
      'assets/images/albahaca.png',
      'assets/images/helecho.png',
      'assets/images/cactus.png',
      'assets/images/aloe_vera.png',
      'assets/images/girasol.png',
      'assets/images/tulipan.png',
      'assets/images/lavanda.png',
      'assets/images/menta.png',
      'asset/images/iguana.png',
      'asset/images/raton.png',
      'asset/images/gerbil.png',
      'asset/images/chichilla.png',
      'asset/images/goldfish.png',
      'asset/images/pez_betta.png',
      'asset/images/erizo.png',
      'asset/images/huron.png',
      'asset/images/periquito.png',
      'asset/images/canario.png',
      'asset/images/cobaya.png',
      'asset/images/hamster.png',
      'asset/images/ficus.png',
      'asset/images/bromelia.png',
      'asset/images/gardenia.png',
      'asset/images/jazmin.png',
      'asset/images/margarita.png',
      
      // añade aquí más rutas si agregas nuevos registros
    ];

    for (var path in assets) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            activeIcon: Icon(Icons.checklist_rtl_rounded),
            label: 'Tareas',
          ),
        ],
      ),
    );
  }
}
