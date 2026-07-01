import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'level_generator.dart';

class Nivel2Controller extends ChangeNotifier {
  final int nivelInicial;

  late SearchLevelModel datosNivel;
  late List<Map<String, dynamic>> opciones;

  Nivel2Controller({required this.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as SearchLevelModel;
    
    final HSLColor correctHsl = HSLColor.fromColor(datosNivel.correctColor);
    
    // A mayor nivel, los distractores tienen un tono más parecido al correcto (mayor dificultad)
    double shift = (40.0 - nivelInicial * 0.4).clamp(8.0, 45.0);
    
    final Color d1 = correctHsl.withHue((correctHsl.hue + shift) % 360).toColor();
    final Color d2 = correctHsl.withHue((correctHsl.hue - shift + 360) % 360).toColor();
    final Color d3 = correctHsl.withLightness((correctHsl.lightness > 0.5) 
        ? correctHsl.lightness - 0.25 
        : correctHsl.lightness + 0.25).toColor();

    opciones = [
      {"color": datosNivel.correctColor, "nombre": datosNivel.colorName},
      {"color": d1, "nombre": "Matiz Alterno A"},
      {"color": d2, "nombre": "Matiz Alterno B"},
      {"color": d3, "nombre": "Muestra Tonal C"},
    ]..shuffle();
  }

  void validarColor(Color color, {required Function(bool) onResult}) {
    bool correcto = color.value == datosNivel.correctColor.value;
    onResult(correcto);
  }
}
