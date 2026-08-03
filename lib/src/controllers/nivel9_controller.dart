import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel9Controller extends BaseLevelController<HexLevelModel> {
  Color? colorSeleccionado;

  Nivel9Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as HexLevelModel;
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
    // Corregido: correctColor
    return colorSeleccionado!.value == datosNivel.correctColor.value;
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado = null;
    comprobado = false;
    notifyListeners();
  }

  void verificarYMostrarAlerta(BuildContext context) async {
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
                Text("¡Código Correcto!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "¡Excelente! Has encontrado el color correspondiente al código hexadecimal.",
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
                Icon(Icons.highlight_off, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text("Código Incorrecto", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "Ese no es el color que corresponde al código hexadecimal objetivo.",
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