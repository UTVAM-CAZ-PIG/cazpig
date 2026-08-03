import 'package:flutter/material.dart';
import 'package:pigmento/src/models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel5Controller extends BaseLevelController<HarmonyLevelModel> {
  Color? colorSeleccionado;

  Nivel5Controller({required super.nivelInicial}) {
    final modelo = LevelGenerator.generarNivel(nivelInicial);

    if (modelo is HarmonyLevelModel) {
      datosNivel = modelo;
    } else {
      // Fallback de seguridad si el level generator no devolvió HarmonyLevelModel
      datosNivel = HarmonyLevelModel(
        level: nivelInicial,
        instruction: "Para el color base 'Amarillo Optimismo', selecciona su ARMONÍA ANÁLOGA:",
        baseColor: const Color(0xFFFFB300),
        baseColorName: "Amarillo Optimismo",
        harmonyType: "Análogo",
        correctColor: const Color(0xFFCBFF00),
        options: const [
          Color(0xFFFFEB3B),
          Color(0xFFFF00CB),
          Color(0xFFCBFF00),
          Color(0xFF00FF34),
        ],
      );
    }
  }

  void seleccionarColor(Color color) {
    if (comprobado) return;
    colorSeleccionado = color;
    notifyListeners();
  }

  @override
  bool get listoParaComprobar => colorSeleccionado != null;

  @override
  bool comprobarResultado() {
    if (colorSeleccionado == null) return false;
    
    final esCorrecto = colorSeleccionado!.toARGB32() == datosNivel.correctColor.toARGB32();
    comprobado = true;
    notifyListeners();
    return esCorrecto;
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado = null;
    comprobado = false;
    notifyListeners();
  }
}