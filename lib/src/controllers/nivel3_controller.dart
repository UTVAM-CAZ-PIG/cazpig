import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'level_generator.dart';

class Nivel3Controller extends ChangeNotifier {
  final int nivelInicial;

  late GradientLevelModel datosNivel;
  late List<Map<String, dynamic>> opcionesMuestras;

  Nivel3Controller({required this.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as GradientLevelModel;
    
    final HSLColor correctHsl = HSLColor.fromColor(datosNivel.correctColor);
    
    // Aumentar dificultad en niveles altos reduciendo la distancia de matiz
    double shift = (35.0 - nivelInicial * 0.35).clamp(7.0, 45.0);
    
    final Color d1 = correctHsl.withHue((correctHsl.hue + shift) % 360).toColor();
    final Color d2 = correctHsl.withHue((correctHsl.hue - shift + 360) % 360).toColor();

    opcionesMuestras = [
      {"color": datosNivel.correctColor, "nombre": "Correcto"},
      {"color": d1, "nombre": "Distractor A"},
      {"color": d2, "nombre": "Distractor B"},
    ]..shuffle();
  }

  void validarColor(Color color, {required Function(bool) onResult}) {
    bool correcto = color.value == datosNivel.correctColor.value;
    onResult(correcto);
  }
}
