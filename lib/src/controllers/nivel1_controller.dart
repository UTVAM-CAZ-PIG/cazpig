import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'level_generator.dart';

class Nivel1Controller extends ChangeNotifier {
  final int nivelInicial;
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;

  late MixLevelModel datosNivel;

  Nivel1Controller({required this.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as MixLevelModel;
  }

  void seleccionarColor(Color color, {required Function(bool) onResult}) {
    if (colorSeleccionado1 == null) {
      colorSeleccionado1 = color;
      notifyListeners();
    } else if (colorSeleccionado2 == null) {
      colorSeleccionado2 = color;
      notifyListeners();
      _verificarMezcla(onResult);
    }
  }

  void _verificarMezcla(Function(bool) onResult) {
    Color c1 = datosNivel.color1;
    Color c2 = datosNivel.color2;

    bool correcto =
        (colorSeleccionado1?.value == c1.value &&
                colorSeleccionado2?.value == c2.value) ||
            (colorSeleccionado1?.value == c2.value &&
                colorSeleccionado2?.value == c1.value);

    onResult(correcto);

    if (!correcto) {
      colorSeleccionado1 = null;
      colorSeleccionado2 = null;
      notifyListeners();
    }
  }
}
