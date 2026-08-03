import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel4Controller extends BaseLevelController<ContrastLevelModel> {
  late List<Color> opciones;
  Color? colorSeleccionado;

  Nivel4Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as ContrastLevelModel;
    opciones = List<Color>.from(datosNivel.options)..shuffle();
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
    bool correcto = colorSeleccionado!.value == datosNivel.correctTextColor.value;
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
              "¡Excelente elección! El contraste cumple perfectamente los estándares de legibilidad.",
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
              "El nivel de contraste seleccionado no ofrece suficiente legibilidad visual.",
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