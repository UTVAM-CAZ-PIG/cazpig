import 'package:flutter/material.dart';

class MenuPantalla extends StatefulWidget {
  const MenuPantalla({super.key});

  @override
  State<MenuPantalla> createState() => _MenuPantallaState();
}

class _MenuPantallaState extends State<MenuPantalla> {
  bool _musicaActiva = true;
  bool _vibracionActiva = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ajustes ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Música de fondo'),
            secondary: const Icon(Icons.music_note),
            value: _musicaActiva,
            onChanged: (bool value) {
              setState(() {
                _musicaActiva = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Vibraciones'),
            secondary: const Icon(Icons.vibration),
            value: _vibracionActiva,
            onChanged: (bool value) {
              setState(() {
                _vibracionActiva = value;
              });
            },
          ),
        ],
      ),
    );
  }
}