import 'package:flutter/material.dart';

class Nivel1Pantalla extends StatelessWidget {
  const Nivel1Pantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivel 1: Facil'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Caza el color Magenta!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Encuentra y presiona el objetivo correcto',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bloqueColor(context, Colors.blue, "Azul", false),
                _bloqueColor(context, Colors.pink, "Magenta", true),
                _bloqueColor(context, Colors.orange, "Naranja", false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloqueColor(BuildContext context, Color color, String nombre, bool esCorrecto) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(esCorrecto ? '¡Excelente! Capturaste el pigmento.' : 'Color incorrecto, intenta de nuevo.'),
            backgroundColor: esCorrecto ? Colors.green : Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
        if (esCorrecto) {
          Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 4))],
        ),
      ),
    );
  }
}