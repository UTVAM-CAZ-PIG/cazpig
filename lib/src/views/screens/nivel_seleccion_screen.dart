import 'package:flutter/material.dart';
import 'dart:math';
import '../../controllers/user_controller.dart';
import '../widgets/game_button.dart';
import 'gameplay/nivel1_screen.dart';
import 'gameplay/nivel2_screen.dart';
import 'gameplay/nivel3_screen.dart';
import 'gameplay/nivel4_screen.dart';
import 'dart:ui' as ui;

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
    // Calcular en qué fila está el nivel actual
    final activeLevel = _userController.currentUser.currentLevelReached;
    final int activeRow = _getRowForLevel(activeLevel);
    
    // Altura aproximada de cada fila es 180
    final double initialOffset = max(0.0, (activeRow - 1) * 180.0);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  // Función matemática para saber en qué fila cae un nivel (patrón 1-2-1-2)
  int _getRowForLevel(int level) {
    if (level <= 0) return 0;
    int blocks = (level - 1) ~/ 3;
    int remainder = (level - 1) % 3;
    return (blocks * 2) + (remainder == 0 ? 0 : 1);
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
              child: Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit:BoxFit.cover,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent, // Fondo transparente para ver el CustomPaint
              body: LayoutBuilder(
                builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              
              // Para 100 niveles en patrón 1, 2, 1, 2... necesitamos 67 filas + 1 Header
              const int totalRows = 68;

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 100, top: 20),
                itemCount: totalRows,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildSectionHeader();
                  }

                  final int rowIndex = index - 1; // Fila 0, 1, 2...
                  final bool isCenterRow = rowIndex % 2 == 0;
                  
                  // Calcular qué niveles van en esta fila
                  List<int> levelsInRow = [];
                  if (isCenterRow) {
                    int lvl = (rowIndex ~/ 2) * 3 + 1;
                    if (lvl <= 100) levelsInRow.add(lvl);
                  } else {
                    int lvl1 = (rowIndex ~/ 2) * 3 + 2;
                    int lvl2 = (rowIndex ~/ 2) * 3 + 3;
                    if (lvl1 <= 100) levelsInRow.add(lvl1);
                    if (lvl2 <= 100) levelsInRow.add(lvl2);
                  }


                  bool isLeftUnlocked=false;
                  bool isRightUnlocked=false;

                  if (isCenterRow){
                   if (levelsInRow.isNotEmpty){
                    int centerLevel = levelsInRow[0];
                    int leftTarget = centerLevel +1;
                    int rightTarget = centerLevel +2;

                    isLeftUnlocked = currentLevel >= leftTarget;
                    isRightUnlocked = currentLevel >= rightTarget;
                   }
                  }else{
                    if(levelsInRow.isNotEmpty){
                      int leftLevel = levelsInRow[0];
                      int centerTarget = leftLevel +2;

                      isLeftUnlocked = currentLevel >= centerTarget;
                      isRightUnlocked = currentLevel >= centerTarget;
                      

                    }
                  }

                  return SizedBox(
                    height: 180, // Altura fija por bloque
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Dibujar líneas de conexión hacia la SIGUIENTE fila
                        if (levelsInRow.isNotEmpty && levelsInRow.last < 100)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: BranchPainter(
                                  isCenterRow: isCenterRow,
                                  screenWidth: screenWidth,
                                  // Las líneas brillan si el nivel central de la fila ya fue superado
                                  isLeftUnlocked:isLeftUnlocked,
                                  isRightUnlocked:isRightUnlocked,
                                ),
                              ),
                            ),
                          ),

                        // 2. Colocar los botones de los niveles
                        Row(
                          mainAxisAlignment: isCenterRow 
                              ? MainAxisAlignment.center 
                              : MainAxisAlignment.spaceEvenly,
                          children: levelsInRow.map((levelNumber) {
                            return _buildLevelNode(levelNumber, currentLevel);
                          }).toList(),
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

  // --- El resto de tus métodos siguen igual (_buildSectionHeader, _mostrarCompraVidasDialog, etc.) ---
  // Añado aquí la lógica del nodo limpio para no saturar el build
  
  Widget _buildLevelNode(int levelNumber, int currentLevel) {
    final isCompleted = levelNumber < currentLevel;
    final isActive = levelNumber == currentLevel;
    final isLocked = levelNumber > currentLevel;
    final bool isChest = levelNumber % 5 == 0;

    // Colores
    final int levelType = levelNumber % 3;
    Color levelColor = Colors.teal;
    

    if (levelType == 1) {
      levelColor = const Color(0xFF00C897);
    } else if (levelType == 2) {
      levelColor = const Color(0xFFFF9F1C);
    } else {
 levelColor = const Color(0xFF9B5DE5);
     
    }

    if (isChest) {
      levelColor = const Color(0xFFFFD166); 
    }
    if (isCompleted && !isChest) {
      final int colorCompletado = levelNumber % 4;

      if (colorCompletado == 0) {
        levelColor = const Color(0xFF9E4747); // Azul cian vibrante pero suave
      } else if (colorCompletado == 1) {
        levelColor = const Color(0xFF4A708B); // Rosa sandía / fucsia claro
      } else if (colorCompletado == 2) {
        levelColor = const Color(0xFF5A7247); // Verde menta fresco (no neón)
      } else {
        levelColor = const Color(0xFF8B6375); // Violeta brillante
      }
    }
    if (isLocked) {
      levelColor = const Color(0xFF4E586E); 
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25), // Espacio para tooltips
          child:GestureDetector(
           onTap: isLocked
           ? null
           :(isChest ? () => _abrirCofre(context, levelNumber) : () => _iniciarDesafiodeNivel(context, levelNumber)),
           child:SizedBox(
            width:150,
            height:150,
           child: isChest
           ? Icon(isCompleted ? Icons.drafts_outlined : Icons.inventory_2_outlined,
           color:isLocked ? Colors.white60 : const Color(0xFF191D2B),
           size:40,
           )
           :Stack(
            alignment:Alignment.center,
            children:[
              ColorFiltered(colorFilter: ColorFilter.mode(levelColor,BlendMode.srcIn,),
              child:Image.asset(
                'assets/imagenes/sello.png',
                width:150,
                height:150,
                fit:BoxFit.contain,
              ),
              ),
              Text(
                '$levelNumber',
                style:TextStyle(
                  fontSize:42,
                  fontWeight:FontWeight.bold,
                  color:isLocked ? Colors.white60 : Colors.white,
                  shadows:[
                    Shadow(
                      color:Colors.black.withOpacity(0.5),
                      blurRadius:4,
                      offset:const Offset(0,2),
                    )
                  ],
                ),
              ),
            ],

           ),
          ),
        ), // 
        ),

        if (isActive)
          const Positioned(top: -25, child: FloatingTooltip()),
        if (!isChest)
          Positioned(
            bottom: isCompleted ? -15 : -12,
            child: _buildStars(isCompleted),
          ),
        if (isCompleted && !isChest)
          const Positioned(
            bottom: 5,
            right: -5,
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Color(0xFF58CC02),
              child: Icon(Icons.check, size: 14, color: Colors.white),
            ),
          ),
        if (isLocked)
          const Positioned(
            bottom: 5,
            right: -5,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: Color(0xFF2C3545),
              child: Icon(Icons.lock, size: 11, color: Colors.white60),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E2A).withOpacity(0.85), // Verde vibrante
        borderRadius: BorderRadius.circular(30),
        border:Border.all(
          color:const Color(0xFFFFD166).withOpacity(0.5),
          width:2
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
                   decoration:BoxDecoration(
                    color:const Color(0xFFFFD166).withOpacity(0.2),
                    borderRadius:BorderRadius.circular(10),
                  ),
               child:const Text(
                  "SECCIÓN 1 · UNIDAD 1",
                  style: TextStyle(
                    color: Color(0xFFFFD166),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Ruta de los Pigmentos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Supera mezclas, branding y degradados infinitos para coronarte maestro.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
          padding:const EdgeInsets.all(12),
          decoration:const BoxDecoration(
            color:Color(0xFFFFD166),
            shape:BoxShape.circle,
          ),
          child:const Icon(Icons.palette_rounded,color:Color(0xFF1E1E2A),size:36)
          ),
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
            Icons.star_rounded,
            size: 22,
            color: isCompleted ? const Color(0xFFFFD60A) : const Color(0xFF4A5568).withOpacity(0.7),
            
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
                color: Colors.white.withOpacity(0.05),
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



/// Pintor para dibujar las ramas de conexión entre filas
class BranchPainter extends CustomPainter {
  final bool isCenterRow;
  final double screenWidth;
  final bool isLeftUnlocked;
  final bool isRightUnlocked;

  BranchPainter({
    required this.isCenterRow,
    required this.screenWidth,
    required this.isLeftUnlocked,
    required this.isRightUnlocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBg = Paint()
      ..color = const Color(0xFF141824).withOpacity(0.5)
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paintLineLeft = Paint()
      ..color = isLeftUnlocked ? const Color(0XFFD4AF37): const Color(0xFF384256)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

      final paintLineRight = Paint()
      ..color = isRightUnlocked ? const Color(0XFFD4AF37) : const Color(0xFF384256)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;


      final double centerX = screenWidth / 2;
    // La separación debe coincidir con el MainAxisAlignment.spaceEvenly
    final double leftX = screenWidth * 0.25; 
    final double rightX = screenWidth * 0.75;
    
    final double startY = 60.0 + (75 / 2); // Centro del botón actual
    final double endY = 180.0 + 60.0 + (75 / 2); // Centro del botón en la SIGUIENTE fila

    final path1 = Path();
    final path2 = Path();

   
    if (isCenterRow) {
      // De Centro a Izquierda y Derecha (División)
      path1.moveTo(centerX, startY);
      path1.cubicTo(centerX, startY + 50, leftX, endY - 50, leftX, endY);

      path2.moveTo(centerX, startY);
      path2.cubicTo(centerX, startY + 50, rightX, endY - 50, rightX, endY);
    } else {
      // De Izquierda y Derecha al Centro (Convergencia)
      path1.moveTo(leftX, startY);
      path1.cubicTo(leftX, startY + 50, centerX, endY - 50, centerX, endY);

      path2.moveTo(rightX, startY);
      path2.cubicTo(rightX, startY + 50, centerX, endY - 50, centerX, endY);
    }

    // Dibujar sombras sólidas de fondo
    canvas.drawPath(path1, paintBg);
    canvas.drawPath(path2, paintBg);

    // Dibujar líneas punteadas principales
    _drawDashedPath(canvas, path1, paintLineLeft);
    _drawDashedPath(canvas, path2, paintLineRight);
  }

  // Función interna para crear el efecto punteado (Dotted Line)
  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dotSpacing = 14.0;  // Espacio entre puntos
    double distance = 0.0;

    paint.strokeWidth = 0;
    paint.style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
    ..color = Colors.black.withOpacity(0.3)
    ..style = PaintingStyle.fill;

    // Extrae las métricas del path para ir dibujando fragmentos
    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final ui.Tangent? tangent = pathMetric.getTangentForOffset(distance);
        if(tangent !=null){ 
          canvas.drawCircle(tangent.position + const Offset(0,2),4.5,shadowPaint);

          canvas.drawCircle(tangent.position,4.5,paint);
        }
        distance += dotSpacing;
      }
      distance = 0.0; // Resetear para la siguiente curva
    }
  }

  @override
  bool shouldRepaint(covariant BranchPainter oldDelegate) {
    return oldDelegate.isCenterRow != isCenterRow ||
           oldDelegate.screenWidth != screenWidth ||
           oldDelegate.isLeftUnlocked != isLeftUnlocked ||
           oldDelegate.isRightUnlocked != isRightUnlocked;
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
                  color: Colors.black.withOpacity(0.3),
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