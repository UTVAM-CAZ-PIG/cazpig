import 'package:flutter/material.dart';
import '../../../controllers/nivel2_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';

class Nivel2Screen extends StatefulWidget {
  final int nivelInicial;
  const Nivel2Screen({super.key, required this.nivelInicial});

  @override
  State<Nivel2Screen> createState() => _Nivel2ScreenState();
}

class _Nivel2ScreenState extends State<Nivel2Screen> {
  late Nivel2Controller _controller;

  @override
  void initState() {
    super.initState();
    _controller = Nivel2Controller(nivelInicial: widget.nivelInicial);
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
                ? "Te has quedado sin vidas. ¡Repón tus vidas en el mapa para seguir!"
                : "Ese color no cumple el mensaje del brief estratégico. ¡Prueba de nuevo!",
            onReintentar: () {
              if (livesLeft <= 0) {
                Navigator.pop(context);
              } else {
                setState(() {
                  _controller = Nivel2Controller(nivelInicial: widget.nivelInicial);
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
    final ancho = MediaQuery.of(context).size.width;
    int crossAxis = ancho > 600 ? 4 : 2;
    final datosNivel = _controller.datosNivel;

    return Scaffold(
      backgroundColor: const Color(0xFF1E2638), // Fondo oscuro sólido
      appBar: AppBar(
        title: Text('Branding - Nivel ${datosNivel.level}'),
        backgroundColor: const Color(0xFF141824),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Panel del Brief estratégico
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3545),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF3F4B62), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      datosNivel.context.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFFF9F1C),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      datosNivel.brief,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Selecciona el color corporativo correcto:",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Opciones de marca como botones 3D
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxis,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                itemCount: _controller.opciones.length,
                itemBuilder: (context, index) {
                  final item = _controller.opciones[index];
                  final Color itemColor = item["color"];

                  return GameButton(
                    backgroundColor: itemColor,
                    shadowColor: _getShadowColor(itemColor),
                    borderRadius: 20,
                    onTap: () => _validar(itemColor),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item["nombre"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
