import 'package:flutter/material.dart';
import '../../../controllers/nivel9_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel9Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel9Screen({super.key, required this.nivelInicial});

  Color _getShadowColor(Color color) {
    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      (color.r * 255.0 * 0.7).round().clamp(0, 255),
      (color.g * 255.0 * 0.7).round().clamp(0, 255),
      (color.b * 255.0 * 0.7).round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<HexLevelModel, Nivel9Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel9Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          children: [
            const Text(
              "CÓDIGO HEXADECIMAL OBJETIVO:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF141824),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2C3446), width: 1.5),
              ),
              child: Text(
                // Corregido: hexCode
                datosNivel.hexCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "SELECCIONA EL PIGMENTO CORRECTO:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: datosNivel.options.map((color) {
                final bool seleccionado = controller.colorSeleccionado == color;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: seleccionado ? const Color(0xFFFF9F1C) : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: GameButton(
                    width: 75,
                    height: 75,
                    borderRadius: 20,
                    backgroundColor: color,
                    shadowColor: _getShadowColor(color),
                    onTap: () {
                      controller.seleccionarColor(color);
                      controller.verificarYMostrarAlerta(context);
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "#${color.value.toRadixString(16).substring(2).toUpperCase()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}