import 'package:flutter/material.dart';
import '../../../controllers/nivel1_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';

class Nivel1Screen extends StatefulWidget {
  final int nivelInicial;

  const Nivel1Screen({super.key, required this.nivelInicial});

  @override
  State<Nivel1Screen> createState() => _Nivel1ScreenState();
}

class _Nivel1ScreenState extends State<Nivel1Screen> {
  late Nivel1Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Nivel1Controller(nivelInicial: widget.nivelInicial);
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

  @override
  Widget build(BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    final bool esPantallaAncha = ancho > 600;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final datosNivel = _controller.datosNivel;

        return Scaffold(
          backgroundColor: const Color(0xFF1E2638), // Fondo plano sólido de estilo oscuro
          appBar: AppBar(
            title: Text('Mezclas - Nivel ${datosNivel.level}'),
            backgroundColor: const Color(0xFF141824),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Flex(
                direction: esPantallaAncha ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Lado izquierdo: Instrucciones en tarjeta
                  SizedBox(
                    width: esPantallaAncha ? ancho * 0.45 : ancho,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3545),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF3F4B62), width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datosNivel.objective,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            datosNivel.instruction,
                            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24, width: 24),

                  // Lado derecho: Área de juego / Combinaciones y opciones
                  Column(
                    children: [
                      // Mostrar los canales combinados
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _construirCanal(_controller.colorSeleccionado1),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
                          ),
                          _construirCanal(_controller.colorSeleccionado2),
                        ],
                      ),
                      const SizedBox(height: 40),

                      const Text(
                        "Selecciona un color para mezclar:",
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // Opciones como botones 3D
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          Colors.red,
                          Colors.blue,
                          Colors.yellow,
                          Colors.green,
                          Colors.white
                        ].map((color) {
                          return GameButton(
                            width: 65,
                            height: 65,
                            borderRadius: 16,
                            backgroundColor: color,
                            shadowColor: _getShadowColor(color),
                            onTap: () {
                              _controller.seleccionarColor(
                                color,
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
                                          ? "Te has quedado sin vidas. ¡Rellena tus vidas para seguir jugando!"
                                          : "Esa mezcla no produce el color objetivo. ¡Prueba otra combinación!",
                                      onReintentar: () {
                                        if (livesLeft <= 0) {
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            _controller = Nivel1Controller(nivelInicial: widget.nivelInicial);
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
                            },
                            child: const SizedBox.shrink(),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _construirCanal(Color? color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF141824),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color != null ? const Color(0xFF00C897) : const Color(0xFF3F4B62),
          width: 2.5,
        ),
      ),
    );
  }
}
