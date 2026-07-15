import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/models/level_model.dart';
import 'package:pigmento/src/controllers/base_level_controller.dart';
import 'package:pigmento/src/controllers/level_generator.dart';

class Nivel1Controller extends BaseLevelController<MixLevelModel> {
  final int nivelInicial;
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;

  static const Color rojoCadmio = Color(0xFFE53935);
  static const Color azulCobalto = Color(0xFF1E88E5);
  static const Color amarilloCazador = Color(0xFFFFB300);
  static const Color verdeCazador = Color(0xFF43A047);

  Nivel1Controller({required this.nivelInicial}) : super(nivelInicial: nivelInicial) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as MixLevelModel;
  }

  bool esCorrecto = false;
  String nombreColorResultante = "Sin mezcla";

  @override
  bool get listoParaComprobar =>
      colorSeleccionado1 != null && colorSeleccionado2 != null;

  Color get colorResultante {
    if (colorSeleccionado1 == null || colorSeleccionado2 == null) {
      nombreColorResultante = "Sin mezcla";
      esCorrecto = false;
      return Colors.transparent;
    }

    final c1 = colorSeleccionado1!.value;
    final c2 = colorSeleccionado2!.value;

    // ROJO + AZUL = VIOLETA
    if ((c1 == rojoCadmio.value && c2 == azulCobalto.value) ||
        (c1 == azulCobalto.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Violeta";
      esCorrecto = true;
      return const Color(0xFF8E24AA);
    }

    // AZUL + AMARILLO = VERDE
    if ((c1 == azulCobalto.value && c2 == amarilloCazador.value) ||
        (c1 == amarilloCazador.value && c2 == azulCobalto.value)) {
      nombreColorResultante = "Verde";
      esCorrecto = false;
      return const Color(0xFF2E7D32);
    }

    // ROJO + AMARILLO = NARANJA
    if ((c1 == rojoCadmio.value && c2 == amarilloCazador.value) ||
        (c1 == amarilloCazador.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Naranja";
      esCorrecto = false;
      return const Color(0xFFEF6C00);
    }

    // ROJO + VERDE
    if ((c1 == rojoCadmio.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Café";
      esCorrecto = false;
      return const Color(0xFF6D4C41);
    }

    // AZUL + VERDE
    if ((c1 == azulCobalto.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == azulCobalto.value)) {
      nombreColorResultante = "Turquesa";
      esCorrecto = false;
      return const Color(0xFF00897B);
    }

    // AMARILLO + VERDE
    if ((c1 == amarilloCazador.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == amarilloCazador.value)) {
      nombreColorResultante = "Verde Lima";
      esCorrecto = false;
      return const Color(0xFF9CCC65);
    }

    nombreColorResultante = "Color desconocido";
    esCorrecto = false;

    return const Color(0xFF4E443C);
  }

  void seleccionarColor(Color color) {
    if (comprobado) return;

    if (colorSeleccionado1 == color) {
      colorSeleccionado1 = null;
      notifyListeners();
      return;
    }
    if (colorSeleccionado2 == color) {
      colorSeleccionado2 = null;
      notifyListeners();
      return;
    }

    if (colorSeleccionado1 == null) {
      colorSeleccionado1 = color;
    } else if (colorSeleccionado2 == null) {
      colorSeleccionado2 = color;
    }

    notifyListeners();
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado1 = null;
    colorSeleccionado2 = null;
    nombreColorResultante = "Sin mezcla";
    esCorrecto = false;
    notifyListeners();
  }

  @override
  bool comprobarResultado() {
    if (!listoParaComprobar) return false;

    comprobado = true;
    bool correcto = esCorrecto;

    if (!correcto) {
      comprobado = false;
    }

    notifyListeners();
    return correcto;
  }

  // ==================== PROCESAMIENTO AUTOMÁTICO Y NAVEGACIÓN ====================
  void comprobarResultadoAutomatico(BuildContext context) async {
    final _ = colorResultante; 

    comprobado = true;
    notifyListeners();

    if (esCorrecto) {
      try {
        AudioPlayer().play(AssetSource('audio/success.mp3'));
      } catch (e) {
        debugPrint("Error audio success: $e");
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
                Text("Síntesis Exitosa", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              "¡Espectacular! Has logrado estabilizar el pigmento Violeta. La fórmula es correcta.",
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
                  comprobarResultado();

                  // Se eliminó el 'await' porque el método retorna void síncrono
                  UserController().completarNivel(nivelInicial);

                  if (context.mounted) {
                    Navigator.of(dialogContext).pop(); // Cierra el modal flotante
                    Navigator.of(context).pop();      // Cierra la pantalla y vuelve al mapa
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
      try {
        AudioPlayer().play(AssetSource('audio/error.mp3'));
      } catch (e) {
        debugPrint("Error audio error: $e");
      }

      // Se eliminó el 'await' porque el método retorna void síncrono
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
                Text("Síntesis Fallida", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "La reacción generó un compuesto de tipo ($nombreColorResultante) en lugar de Violeta. Los reactivos se han volatilizado.",
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
                  comprobado = false;          
                  reiniciarSeleccion(); 
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("Reintentar Reacción", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}