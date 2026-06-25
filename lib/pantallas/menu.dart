import 'package:flutter/material.dart';

class MenuPantalla extends StatefulWidget {
  const MenuPantalla({super.key});

  @override
  State<MenuPantalla> createState() => _MenuPantallaState();
}

class _MenuPantallaState extends State<MenuPantalla> {
  bool _musicaActiva = true;
  bool _vibracionActiva = true;
  bool _notificaciones = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajustes del Juego', 
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.indigo)
            ),
            const SizedBox(height: 5),
            const Text(
              'Personaliza tu experiencia dentro de la app',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            
            _construirSeccionTitulo('SONIDO Y AUDIO'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Música de fondo', style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: const Text('Melodías ambientales de laboratorio'),
                    secondary: const Icon(Icons.music_note, color: Colors.indigo),
                    value: _musicaActiva,
                    onChanged: (bool value) {
                      setState(() => _musicaActiva = value);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Vibraciones', style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: const Text('Efectos táctiles al acertar o fallar'),
                    secondary: const Icon(Icons.vibration, color: Colors.indigo),
                    value: _vibracionActiva,
                    onChanged: (bool value) {
                      setState(() => _vibracionActiva = value);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            _construirSeccionTitulo('PREFERENCIAS GENERALES'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Alertas de Desafíos', style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: const Text('Recordatorios para cazar nuevos pigmentos'),
                    secondary: const Icon(Icons.notifications_active, color: Colors.indigo),
                    value: _notificaciones,
                    onChanged: (bool value) {
                      setState(() => _notificaciones = value);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.translate, color: Colors.indigo),
                    title: const Text('Idioma del juego'),
                    trailing: const Text('Español (ES)', style: TextStyle(color: Colors.grey)),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                'Cazadores de Pigmentos v1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1.2),
      ),
    );
  }
}