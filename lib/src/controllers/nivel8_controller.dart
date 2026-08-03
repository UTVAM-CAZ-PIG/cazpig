import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel8Controller extends BaseLevelController<TempLevelModel> {
  List<Color> available = [];
  List<Color> warm = [];
  List<Color> cold = [];

  Nivel8Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as TempLevelModel;
    available = List<Color>.from(datosNivel.allOptions);
  }

  void classifyColor(Color color, String zone, BuildContext context) {
    if (comprobado) return;
    
    // Remover de todas las listas
    available.remove(color);
    warm.remove(color);
    cold.remove(color);
    
    if (zone == "warm") {
      warm.add(color);
    } else if (zone == "cold") {
      cold.add(color);
    } else {
      available.add(color);
    }
    notifyListeners();

    // Evaluación automática cuando todos los pigmentos han sido clasificados
    if (listoParaComprobar) {
      comprobarResultadoAutomatico(context);
    }
  }

  @override
  bool get listoParaComprobar => available.isEmpty;

  @override
  bool comprobarResultado() {
    comprobado = true;
    notifyListeners();

    // Comprobar que todos los colocados en warm estén realmente en warmColors
    final List<int> correctWarmValues = datosNivel.warmColors.map((c) => c.value).toList();
    final List<int> correctColdValues = datosNivel.coldColors.map((c) => c.value).toList();

    for (var c in warm) {
      if (!correctWarmValues.contains(c.value)) return false;
    }
    for (var c in cold) {
      if (!correctColdValues.contains(c.value)) return false;
    }
    return true;
  }

  @override
  void reiniciarSeleccion() {
    available = List<Color>.from(datosNivel.allOptions);
    warm.clear();
    cold.clear();
    comprobado = false;
    notifyListeners();
  }

  // ==================== PROCESAMIENTO AUTOMÁTICO Y NAVEGACIÓN ====================
  void comprobarResultadoAutomatico(BuildContext context) async {
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
                Text("Clasificación Correcta", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "¡Excelente! Has separado correctamente los pigmentos según su temperatura cromática en zonas cálidas y frías.",
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
                Icon(Icons.thermostat_outlined, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text("Clasificación Errónea", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "Uno o más pigmentos no corresponden a la temperatura asignada. Revisa bien sus subtonos.",
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
                  child: Text("Reintentar", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}