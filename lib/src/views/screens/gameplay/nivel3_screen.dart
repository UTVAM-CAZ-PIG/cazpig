import 'package:flutter/material.dart';
import '../../../controllers/nivel3_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';

class Nivel3Screen extends StatefulWidget {
  final int nivelInicial;

  const Nivel3Screen({
    super.key,
    required this.nivelInicial,
  });

  @override
  State<Nivel3Screen> createState() => _Nivel3ScreenState();
}

class _Nivel3ScreenState extends State<Nivel3Screen> {
  late Nivel3Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Nivel3Controller(nivelInicial: widget.nivelInicial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getShadowColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      (color.red * 0.7).round(),
      (color.green * 0.7).round(),
      (color.blue * 0.7).round(),
    );
  }

  void _validar(Color elegida) {
    _controller.validarColor(
      elegida,
      onResult: (correcto) {
        if (correcto) {
          UserController().completarNivel(widget.nivelInicial);
          GameBottomSheet.mostrarVictoria(
            context: context,
            pigmentosGanados: 30,
            onContinuar: () {
              Navigator.pop(context);
            },
          );
        } else {
          UserController().restarVida();
          final livesLeft = UserController().currentUser.lives;
          GameBottomSheet.mostrarDerrota(
            context: context,
            mensaje: livesLeft <= 0
                ? "Te has quedado sin vidas. ¡Repón vidas en el mapa para seguir jugando!"
                : "Ese tono rompe la secuencia armónica del degradado. ¡Intenta de nuevo!",
            onReintentar: () {
              if (livesLeft <= 0) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _controller = Nivel3Controller(nivelInicial: widget.nivelInicial);
                });
              }
            },
            onVolver: () {
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    final datosNivel = _controller.datosNivel;

    List<Widget> secuenciaWidgets = datosNivel.sequence.map((color) {
      if (color.value == Colors.transparent.value) {
        return Container(
          width: ancho > 600 ? 90 : 65,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF141824),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF9B5DE5),
              width: 2.5,
            ),
          ),
          child: const Icon(
            Icons.help_outline_rounded,
            color: Color(0xFF9B5DE5),
            size: 32,
          ),
        );
      }

      return Container(
        width: ancho > 600 ? 90 : 65,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E2638), // Fondo oscuro plano sólido
      appBar: AppBar(
        title: Text('Degradados - Nivel ${datosNivel.level}'),
        backgroundColor: const Color(0xFF141824),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Banner del ejercicio de escala tonal
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3545),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF3F4B62), width: 2),
                ),
                child: const Column(
                  children: [
                    Text(
                      "EJERCICIO DE ESCALA TONAL",
                      style: TextStyle(
                        color: Color(0xFF9B5DE5),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Identifica cuál de las opciones de abajo completa fluidamente la secuencia de transiciones sin romper la armonía del degradado.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Fila de la secuencia con la incógnita
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: secuenciaWidgets,
              ),
              const SizedBox(height: 50),

              const Text(
                "SELECCIONA EL TONO DE REEMPLAZO CORRECTO:",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Opciones del degradado como botones 3D
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _controller.opcionesMuestras.map((opcion) {
                  final Color optionColor = opcion["color"];
                  return GameButton(
                    width: 70,
                    height: 70,
                    borderRadius: 20,
                    backgroundColor: optionColor,
                    shadowColor: _getShadowColor(optionColor),
                    onTap: () => _validar(optionColor),
                    child: const SizedBox.shrink(),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
