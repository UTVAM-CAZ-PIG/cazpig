import 'package:flutter/material.dart';
import 'package:pigmento/src/controllers/nivel5_controller.dart';
import 'package:pigmento/src/models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel5Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel5Screen({super.key, required this.nivelInicial});

  Color _getShadowColor(Color color) {
    return color.withValues(
      alpha: color.a * 0.8,
      red: color.r * 0.7,
      green: color.g * 0.7,
      blue: color.b * 0.7,
    );
  }

  String _colorToHex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<HarmonyLevelModel, Nivel5Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel5Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF161A22),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                datosNivel.instruction,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFF9F1C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "COLOR BASE OBJETIVO:",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: datosNivel.baseColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: datosNivel.baseColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _colorToHex(datosNivel.baseColor),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              datosNivel.baseColorName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "OPCIONES DE ARMONÍA:",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: datosNivel.options.map((color) {
                final bool seleccionado = controller.colorSeleccionado?.toARGB32() == color.toARGB32();

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
                    onTap: () => controller.seleccionarColor(color),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _colorToHex(color),
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