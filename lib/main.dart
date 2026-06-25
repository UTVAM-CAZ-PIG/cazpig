import 'package:flutter/material.dart';
import 'pantallas/pantalla_carga.dart'; // <-- O la ruta exacta donde guardaste este archivo

void main() {
  runApp(const CazadoresApp());
}

class CazadoresApp extends StatelessWidget {
  const CazadoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( // <-- Agrega const aquí si es posible
      debugShowCheckedModeBanner: false,
      title: 'Cazadores de Pigmentos',
      home: const PantallaDeCarga(), // <-- Debe apuntar directamente aquí
    );
  }
}