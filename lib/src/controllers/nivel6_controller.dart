import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel6Controller extends BaseLevelController<BlindLevelModel> {
  Color? colorSeleccionado;

  Nivel6Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as BlindLevelModel;
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
    comprobado = true;
    notifyListeners();
    return colorSeleccionado!.value == datosNivel.correctColor.value;
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado = null;
    comprobado = false;
    notifyListeners();
  }

  // Matrices de color para filtros de Daltonismo (formato 4x5 de Flutter)
  List<double> get matrixFilter {
    if (datosNivel.blindType == "Protanopia") {
      return const [
        0.567, 0.433, 0.0,   0.0, 0.0,
        0.558, 0.442, 0.0,   0.0, 0.0,
        0.0,   0.242, 0.758, 0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    } else if (datosNivel.blindType == "Deuteranopia") {
      return const [
        0.625, 0.375, 0.0,   0.0, 0.0,
        0.7,   0.3,   0.0,   0.0, 0.0,
        0.0,   0.3,   0.7,   0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    } else {
      // Tritanopia (blue blindness)
      return const [
        0.95,  0.05,  0.0,   0.0, 0.0,
        0.0,   0.433, 0.567, 0.0, 0.0,
        0.0,   0.475, 0.525, 0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    }
  }

  // ==================== PROCESAMIENTO AUTOMÁTICO Y NAVEGACIÓN ====================
  void comprobarResultadoAutomatico(BuildContext context) async {
    if (!listoParaComprobar) return;

    final settings = GameSettingsController().settings;
    bool esCorrecto = comprobarResultado();

    if (esCorrecto) {
      if (settings.musicActive) {
        try {
          AudioPlayer().play(AssetSource('audio/success.mp3'));
        } catch (e) {
          debugPrint("Error audio success: $e");
        }
      }
      if (settings.vibrationActive) {
        HapticFeedback.mediumImpact();
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161A22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.greenAccent, width: 1.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 28),
                SizedBox(width: 12),
                Text("Análisis Exitoso", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "¡Perfecto! Has identificado el color accesible correcto superando la barrera de daltonismo.",
              style: TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  foregroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  UserController().completarNivel(nivelInicial);

                  if (context.mounted) {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pop();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("Siguiente Nivel", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );

    } else {
      if (settings.musicActive) {
        try {
          AudioPlayer().play(AssetSource('audio/error.mp3'));
        } catch (e) {
          debugPrint("Error audio error: $e");
        }
      }
      if (settings.vibrationActive) {
        HapticFeedback.mediumImpact();
      }

      UserController().restarVida();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161A22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.science_outlined, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text("Análisis Fallido", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "El tono seleccionado no coincide bajo el filtro de accesibilidad evaluado.",
              style: TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  reiniciarSeleccion();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("Reintentar Análisis", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}