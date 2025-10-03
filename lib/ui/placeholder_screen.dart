import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PlaceholderScreen extends StatefulWidget {
  const PlaceholderScreen({super.key});
  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  bool _online = true;
  late final Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((r) {
      final on = r != ConnectivityResult.none;
      if (on != _online) setState(() => _online = on);
    });
    _checkNow();
  }

  Future<void> _checkNow() async {
    final r = await _connectivity.checkConnectivity();
    setState(() => _online = r != ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Natupedia – Sprint 1'),
        backgroundColor: _online ? Colors.green : Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _online ? Icons.wifi : Icons.wifi_off,
              size: 64,
              color: _online ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _online ? 'Modo ONLINE' : 'Modo OFFLINE',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            const Text('Aquí irá tu contenido de prueba…'),
          ],
        ),
      ),
    );
  }
}
