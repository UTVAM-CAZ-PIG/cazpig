import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel11Controller extends BaseLevelController<AtmosphereLevelModel> {
  List<Color>? paletaSeleccionada;

  Nivel11Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as AtmosphereLevelModel;
  }

  void seleccionarPaleta(List<Color> palette, BuildContext context) {
    if (comprobado) return;
    paletaSeleccionada = palette;
    notifyListeners();

    // Evaluación automática al seleccionar una paleta
    if (listoParaComprobar) {
      comprobarResultadoAutomatico(context);
    }
  }

  @override
  bool get listoParaComprobar => paletaSeleccionada != null;

  @override
  bool comprobarResultado() {
    if (paletaSeleccionada == null) return false;
    comprobado = true;
    notifyListeners();

    // Comprobar si los valores de color coinciden exactamente con la paleta correcta
    final List<int> correctValues = datosNivel.correctPalette.map((c) => c.value).toList();
    final List<int> selectedValues = paletaSeleccionada!.map((c) => c.value).toList();
    
    if (correctValues.length != selectedValues.length) return false;
    for (int i = 0; i < correctValues.length; i++) {
      if (correctValues[i] != selectedValues[i]) return false;
    }
    return true;
  }

  @override
  void reiniciarSeleccion() {
    paletaSeleccionada = null;
    comprobado = false;
    notifyListeners();
  }

  // ==================== PROCESAMIENTO AUTOMÁTICO Y ALERTAS ====================
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
                Icon(Icons.palette_outlined, color: Colors.greenAccent, size: 28),
                SizedBox(width: 12),
                Text("Atmósfera Lograda", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "¡Excelente elección! Has seleccionado la combinación cromática adecuada para recrear la atmósfera requerida.",
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
                Icon(Icons.palette_outlined, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text("Atmósfera Incorrecta", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "Esta paleta no genera la armonía croma/temperatura necesaria para esta atmósfera. Intenta con otra combinación.",
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