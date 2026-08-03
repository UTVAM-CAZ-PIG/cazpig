import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel3Controller extends BaseLevelController<GradientLevelModel> {
  late List<Map<String, dynamic>> opcionesMuestras;
  Color? colorSeleccionado;

  Nivel3Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as GradientLevelModel;
    
    final HSLColor correctHsl = HSLColor.fromColor(datosNivel.correctColor);
    
    double shift = (35.0 - nivelInicial * 0.35).clamp(7.0, 45.0);
    
    final Color d1 = correctHsl.withHue((correctHsl.hue + shift) % 360).toColor();
    final Color d2 = correctHsl.withHue((correctHsl.hue - shift + 360) % 360).toColor();

    opcionesMuestras = [
      {"color": datosNivel.correctColor, "nombre": "Correcto"},
      {"color": d1, "nombre": "Distractor A"},
      {"color": d2, "nombre": "Distractor B"},
    ]..shuffle();
  }

  @override
  bool get listoParaComprobar => colorSeleccionado != null;

  void seleccionarColor(Color color) {
    if (comprobado) return;
    colorSeleccionado = color;
    notifyListeners();
  }

  @override
  void reiniciarSeleccion() {
    if (comprobado) return;
    colorSeleccionado = null;
    notifyListeners();
  }

  @override
  bool comprobarResultado() {
    if (!listoParaComprobar) return false;
    comprobado = true;
    bool correcto = colorSeleccionado!.value == datosNivel.correctColor.value;
    notifyListeners();
    return correcto;
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
              "¡Espectacular! Has completado la secuencia armónica del degradado correctamente.",
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
              "El tono seleccionado rompe la gradación cromática de la secuencia.",
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
                  comprobado = false;
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