import 'package:flutter/material.dart';
import 'dart:math';
import '../../controllers/user_controller.dart';
import '../widgets/game_button.dart';
import 'gameplay/nivel1_screen.dart';
import 'gameplay/nivel2_screen.dart';
import 'gameplay/nivel3_screen.dart';
import 'gameplay/nivel4_screen.dart';

class NivelSeleccionScreen extends StatefulWidget {
  const NivelSeleccionScreen({super.key});

  @override
  State<NivelSeleccionScreen> createState() => _NivelSeleccionScreenState();
}

class _NivelSeleccionScreenState extends State<NivelSeleccionScreen> {
  final UserController _userController = UserController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Scroll inicial automático al nivel activo del usuario (+1 para compensar el header)
    final activeLevel = _userController.currentUser.currentLevelReached;
    final double initialOffset = max(0.0, (activeLevel - 2) * 140.0);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _userController,
      builder: (context, child) {
        final currentLevel = _userController.currentUser.currentLevelReached;

        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 18, 17, 17),
                child: CustomPaint(
                  painter: FondoLiquidoPainter(),
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent, // Fondo transparente para ver el CustomPaint
              body: LayoutBuilder(
                builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;

              // Función que calcula la posición horizontal sinuosa de los nodos del mapa
              double getXOffset(int index) {
                // index va de 1 a 100
                return screenWidth / 2 + sin(index * 0.8) * (screenWidth * 0.23);
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 60),
                itemCount: 101, // 1 Header + 100 Niveles
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildSectionHeader();
                  }

                  final levelNumber = index; // Nivel 1 a 100
                  final isCompleted = levelNumber < currentLevel;
                  final isActive = levelNumber == currentLevel;
                  final isLocked = levelNumber > currentLevel;
                  final bool isChest = levelNumber % 5 == 0; // Cada 5 niveles hay un cofre de regalo

                  // Determinar el color base según el tipo de nivel
                  final int levelType = levelNumber % 3;
                  Color levelColor = Colors.teal;
                  Color levelShadow = Colors.teal.shade800;

                  if (levelType == 1) {
                    levelColor = const Color(0xFF00C897); // Verde azulado brillante
                    levelShadow = const Color(0xFF009673);
                  } else if (levelType == 2) {
                    levelColor = const Color(0xFFFF9F1C); // Naranja brillante
                    levelShadow = const Color(0xFFCC7F16);
                  } else {
                    levelColor = const Color(0xFF9B5DE5); // Morado neón
                    levelShadow = const Color(0xFF7B4AB5);
                  }

                  if (isChest) {
                    levelColor = const Color(0xFFFFD166); // Oro/Dorado para el cofre
                    levelShadow = const Color(0xFFD4AA3F);
                  }

                  // Si está completado, color verde esmeralda brillante
                  if (isCompleted && !isChest) {
                    levelColor = const Color.fromARGB(255, 70, 149, 9);
                    levelShadow = const Color.fromARGB(255, 48, 107, 6);
                  }

                  // Si está bloqueado, color gris
                  if (isLocked) {
                    levelColor = const Color(0xFF4E586E);
                    levelShadow = const Color(0xFF343B4A);
                  }

                  final double currentX = getXOffset(levelNumber);
                  final double nextX = getXOffset(levelNumber + 1);

                  return SizedBox(
                    height: 190, // Aumentamos la altura para dar más espacio
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Dibujar línea curva de conexión con el siguiente nivel
                        if (levelNumber < 100)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: PathPainter(
                                  x1: currentX,
                                  x2: nextX,
                                  unlocked: levelNumber < currentLevel,
                                  activeColor: levelColor,
                                ),
                              ),
                            ),
                          ),

                        // 2. Elemento interactivo (Nivel o Cofre)
                        Positioned(
                          left: currentX - 35, // Centrado para un botón de 70px de ancho
                          top: 25,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Contenedor para el efecto de brillo (glow)
                              Container(
                                decoration: BoxDecoration(
                                  shape: isChest ? BoxShape.rectangle : BoxShape.circle,
                                  borderRadius: isChest ? BorderRadius.circular(20) : null,
                                  boxShadow: isCompleted && !isChest
                                    ? [
                                        BoxShadow(
                                          color: levelColor.withOpacity(0.5),
                                          blurRadius: 12,
                                          spreadRadius: 2,
                                        ),
                                      ] 
                                    : null,
                                ),
                                child: GameButton(
                                  width: 70,
                                  height: 70,
                                  borderRadius: isChest ? 20 : 35,
                                  backgroundColor: levelColor,
                                  shadowColor: levelShadow,
                                  onTap: isChest ? () => _abrirCofre(context, levelNumber) : () => _iniciarDesafiodeNivel(context, levelNumber),
                                  enabled: !isLocked,
                                child: isChest
                                    ? Icon(
                                        isCompleted ? Icons.drafts_outlined : Icons.inventory_2_outlined,
                                        color: isLocked ? Colors.white60 : const Color(0xFF191D2B),
                                        size: 32,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: isLocked
                                                ? [const Color(0xFF5A667D), const Color(0xFF343B4A)]
                                                : [levelColor.withOpacity(0.6), levelColor],
                                            center: const Alignment(0.0, -0.2),
                                            radius: 0.8,
                                          ),
                                          border: Border.all(
                                            color: isLocked ? Colors.transparent : Colors.white.withOpacity(0.1),
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$levelNumber',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: isLocked ? Colors.white60 : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                ),
                              ),

                              // Tooltip flotante encima si es el nivel activo
                              if (isActive)
                                const Positioned(
                                  top: -45,
                                  child: FloatingTooltip(),
                                ),

                              // Tres estrellas debajo del nivel
                              if (!isChest)
                                Positioned(
                                  bottom: isCompleted ? -25 : -22, // Un poco más abajo si está completado
                                  child: _buildStars(isCompleted),
                                ),

                              // Checkmark si está completado
                              if (isCompleted && !isChest)
                                const Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Color(0xFF58CC02), // Verde vibrante
                                    child: Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                              // Candado si está bloqueado
                              if (isLocked)
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: CircleAvatar(
                                    radius: 11,
                                    backgroundColor: const Color(0xFF2C3545),
                                    child: const Icon(
                                      Icons.lock,
                                      size: 11,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 204, 2, 63), Color.fromARGB(255, 163, 2, 45)], // Verde vibrante
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SECCIÓN 1 · UNIDAD 1",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Ruta de los Pigmentos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Supera mezclas, branding y degradados infinitos para coronarte maestro.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.palette_rounded, color: Colors.white, size: 45),
        ],
      ),
    );
  }

  Widget _buildStars(bool isCompleted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (starIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Icon(
            Icons.star,
            size: 14,
            color: isCompleted ? const Color(0xFFFFD60A) : const Color(0xFF4A5568),
          ),
        );
      }),
    );
  }

  void _iniciarDesafiodeNivel(BuildContext context, int nivel) {
    if (_userController.currentUser.lives <= 0) {
      _mostrarCompraVidasDialog(context);
      return;
    }

    Widget pantallaDestino;
    int tipo = nivel % 4;

    if (tipo == 1) {
      pantallaDestino = Nivel1Screen(nivelInicial: nivel);
    } else if (tipo == 2) {
      pantallaDestino = Nivel2Screen(nivelInicial: nivel);
    } else if (tipo == 3) {
      pantallaDestino = Nivel3Screen(nivelInicial: nivel);
    } else {
      pantallaDestino = Nivel4Screen(nivelInicial: nivel);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pantallaDestino),
    );
  }

  void _mostrarCompraVidasDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          "❤️ Sin Vidas",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 70),
            SizedBox(height: 16),
            Text(
              "No tienes vidas suficientes para jugar. ¿Quieres reponer tus 5 vidas de inmediato?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              "Coste: 150 💎",
              style: TextStyle(color: Color(0xFF1CB0F6), fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              bool exito = _userController.comprarVidasConPigmentos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exito ? "¡Vidas recargadas al máximo!" : "No tienes suficientes pigmentos 💎"),
                  backgroundColor: exito ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B4B)),
            child: const Text("Comprar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _abrirCofre(BuildContext context, int nivel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1E2638),
        title: const Text(
          "🎁 Cofre de Recompensa",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFFFD166), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.redeem_rounded, color: Color(0xFFFFD166), size: 80),
            const SizedBox(height: 16),
            const Text(
              "¡Has alcanzado y abierto un cofre en tu camino cromático!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "+150 XP y +50 Pigmentos",
                style: TextStyle(color: Color(0xFF00C897), fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                _userController.completarNivel(nivel);
                Navigator.pop(context);
              },
              child: const Text(
                "¡Recibir Recompensa!",
                style: TextStyle(color: Color(0xFFFFD166), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FondoLiquidoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void dibujarParticula(double x, double y, double radio, Color color, [double glowSpread = 3.0]) {
      final paintGlow = Paint()
        ..color = color.withOpacity(0.4) // Brillo sutil
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSpread);

      final paintCore = Paint()..color = color.withOpacity(0.9);

      canvas.drawCircle(Offset(x, y), radio + glowSpread, paintGlow);
      canvas.drawCircle(Offset(x, y), radio, paintCore);
    }

    dibujarParticula(size.width * 0.15, size.height * 0.10, 4.0, Colors.cyanAccent);
    dibujarParticula(size.width * 0.85, size.height * 0.25, 2.5, Colors.cyan);
    dibujarParticula(size.width * 0.50, size.height * 0.90, 3.5, Colors.cyanAccent);
    dibujarParticula(size.width * 0.10, size.height * 0.60, 2.0, const Color(0xFF00C8D2));

    dibujarParticula(size.width * 0.75, size.height * 0.70, 5.0, Colors.amber, 8.0);
    dibujarParticula(size.width * 0.35, size.height * 0.40, 2.0, Colors.amberAccent);
    dibujarParticula(size.width * 0.90, size.height * 0.85, 3.0, Colors.orangeAccent);
    dibujarParticula(size.width * 0.45, size.height * 0.15, 2.0, Colors.amber);

    dibujarParticula(size.width * 0.20, size.height * 0.80, 4.5, Colors.pinkAccent);
    dibujarParticula(size.width * 0.80, size.height * 0.15, 3.0, const Color(0xFFD63384));
    dibujarParticula(size.width * 0.65, size.height * 0.55, 2.5, Colors.pink);
    dibujarParticula(size.width * 0.30, size.height * 0.90, 1.5, Colors.pinkAccent);

    dibujarParticula(size.width * 0.55, size.height * 0.30, 4.0, Colors.deepPurpleAccent);
    dibujarParticula(size.width * 0.05, size.height * 0.35, 3.0, Colors.purpleAccent);
    dibujarParticula(size.width * 0.70, size.height * 0.95, 2.0, Colors.purple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// Pintor para dibujar curvas Bezier sinuosas entre nodos adyacentes
class PathPainter extends CustomPainter {
  final double x1;
  final double x2;
  final bool unlocked;
  final Color activeColor;

  PathPainter({
    required this.x1,
    required this.x2,
    required this.unlocked,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Sombra/Base de la carretera
    final paintBg = Paint()
      ..color = const Color(0xFF141824)
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Línea del camino
    final paintLine = Paint()
      ..color = unlocked ? activeColor : const Color(0xFF384256)
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(x1, 60);

    // Curva Bezier cúbica orgánica que simula una carretera S
    final double controlY1 = 60 + 40;
    final double controlY2 = 60 + 100;
    path.cubicTo(x1, controlY1, x2, controlY2, x2, 160 + 60); // Ajustado a la nueva altura

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.x1 != x1 ||
        oldDelegate.x2 != x2 ||
        oldDelegate.unlocked != unlocked ||
        oldDelegate.activeColor != activeColor;
  }
}

/// Tooltip animado flotante
class FloatingTooltip extends StatefulWidget {
  const FloatingTooltip({super.key});

  @override
  State<FloatingTooltip> createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_controller.value * 6),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "¡JUGAR!",
              style: TextStyle(
                color: Color(0xFF191D2B),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(12, 6),
            painter: TrianglePainter(),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
