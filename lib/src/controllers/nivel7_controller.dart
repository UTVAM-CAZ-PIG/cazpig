import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel7Controller extends BaseLevelController<RgbLevelModel> {
  double r = 128.0;
  double g = 128.0;
  double b = 128.0;

  Nivel7Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as RgbLevelModel;
  }

  void updateRed(double value) {
    if (comprobado) return;
    r = value;
    notifyListeners();
  }

  void updateGreen(double value) {
    if (comprobado) return;
    g = value;
    notifyListeners();
  }

  void updateBlue(double value) {
    if (comprobado) return;
    b = value;
    notifyListeners();
  }

  Color get currentColor => Color.fromARGB(255, r.toInt(), g.toInt(), b.toInt());

  double get similarity {
    final Color target = datosNivel.targetColor;
    final double dist = math.sqrt(
      math.pow(r - target.r * 255.0, 2) +
      math.pow(g - target.g * 255.0, 2) +
      math.pow(b - target.b * 255.0, 2)
    );
    return (100.0 - (dist / 441.67 * 100.0)).clamp(0.0, 100.0);
  }

  String get feedbackMessage {
    final double sim = similarity;
    if (sim >= 95) return "¡Color perfecto! Casi idéntico.";
    if (sim >= 87) return "¡Muy cerca! Excelente precisión.";
    if (sim >= 75) return "¡Tibio! Vas por muy buen camino.";
    if (sim >= 55) return "Templado. Sigue ajustando.";
    return "Frío. Ajusta los colores base.";
  }

  @override
  bool get listoParaComprobar => true;

  @override
  bool comprobarResultado() {
    comprobado = true;
    notifyListeners();

    final Color target = datosNivel.targetColor;
    
    // Distancia Euclidiana tridimensional
    final double dist = math.sqrt(
      math.pow(r - target.r * 255.0, 2) +
      math.pow(g - target.g * 255.0, 2) +
      math.pow(b - target.b * 255.0, 2)
    );

    // Si la distancia es menor a 55, se considera exitoso (tolerancia ampliada)
    return dist < 55.0;
  }

  @override
  void reiniciarSeleccion() {
    comprobado = false;
    notifyListeners();
  }

  // ==================== PROCESAMIENTO AUTOMÁTICO Y NAVEGACIÓN ====================
  void procesarComprobacion(BuildContext context) async {
    if (comprobado) return;

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
                Text("¡Mezcla Lograda!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "Lograste una similitud del ${similarity.toStringAsFixed(0)}%. La mezcla cromática RGB es precisa.",
              style: const TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
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
                Text("Mezcla Imprecisa", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "Tu porcentaje de similitud fue del ${similarity.toStringAsFixed(0)}%. Ajusta un poco más los canales R, G y B.",
              style: const TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
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
                  child: Text("Reintentar Mezcla", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}