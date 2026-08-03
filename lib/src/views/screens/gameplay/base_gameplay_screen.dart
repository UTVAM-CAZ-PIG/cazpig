import 'package:flutter/material.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';
import '../../../controllers/base_level_controller.dart';
import '../../../controllers/level_generator.dart';
import '../../../models/level_model.dart';

class BaseGameplayScreen<T extends LevelModel, C extends BaseLevelController<T>> extends StatefulWidget {
  final int nivel;
  final C Function(BuildContext context) controllerFactory;
  final Widget Function(BuildContext context, C controller) gameFieldBuilder;
  final Widget Function(BuildContext context, C controller)? instructionCardBuilder;
  final bool ocultarBotonComprobar; 

  const BaseGameplayScreen({
    super.key,
    required this.nivel,
    required this.controllerFactory,
    required this.gameFieldBuilder,
    this.instructionCardBuilder,
    this.ocultarBotonComprobar = true,
  });

  @override
  State<BaseGameplayScreen<T, C>> createState() => BaseGameplayScreenState<T, C>();
}

class BaseGameplayScreenState<T extends LevelModel, C extends BaseLevelController<T>> extends State<BaseGameplayScreen<T, C>> {
  late C _controller;
  bool _alertaAbierta = false;

  @override
  void initState() {
    super.initState();
    _inicializarControlador();
  }

  void _inicializarControlador() {
    _controller = widget.controllerFactory(context);
    _alertaAbierta = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Método público de comprobación único.
  void comprobar() {
    if (_alertaAbierta) return;
    _alertaAbierta = true;

    final bool correcto = _controller.comprobarResultado();

    if (correcto) {
      UserController().completarNivel(widget.nivel);
      final String fact = LevelGenerator.obtenerDatoCurioso(_controller.datosNivel);

      GameBottomSheet.mostrarVictoria(
        context: context,
        pigmentosGanados: 30,
        datoCurioso: fact,
        onContinuar: () {
          Navigator.of(context).pop(); // Regresa al mapa
        },
      );
    } else {
      UserController().restarVida();
      final livesLeft = UserController().currentUser.lives;
      final String mensajeError = _obtenerMensajeError(_controller.datosNivel);

      GameBottomSheet.mostrarDerrota(
        context: context,
        mensaje: livesLeft <= 0
            ? "Te has quedado sin vidas. ¡Repón vidas en el mapa!"
            : mensajeError,
        onReintentar: () {
          if (livesLeft > 0) {
            setState(() {
              _controller.dispose();
              _inicializarControlador(); // Reinicia el controlador limpiamente
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        onVolver: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    final bool esPantallaAncha = ancho > 600;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final datos = _controller.datosNivel;

        return Scaffold(
          backgroundColor: const Color(0xFF1E2638), 
          appBar: AppBar(
            title: Text('${datos.title} - Nivel ${datos.level}'),
            backgroundColor: const Color(0xFF141824),
            elevation: 0,
            actions: [
              ListenableBuilder(
                listenable: UserController(),
                builder: (context, child) {
                  final user = UserController().currentUser;
                  return Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${user.lives}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.diamond_rounded, color: Color(0xFF00C897), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${user.pigments}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Flex(
                    direction: esPantallaAncha ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.instructionCardBuilder != null
                            ? widget.instructionCardBuilder!(context, _controller)
                            : _buildDefaultInstructionCard(datos),
                      ),
                      const SizedBox(height: 24, width: 24),
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.gameFieldBuilder(context, _controller),
                      ),
                    ],
                  ),
                ),
              ),

              if (!widget.ocultarBotonComprobar)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF141824),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    child: GameButton(
                      backgroundColor: _controller.listoParaComprobar
                          ? const Color(0xFF58CC02)
                          : Colors.grey.shade600,
                      shadowColor: _controller.listoParaComprobar
                          ? const Color(0xFF46A302)
                          : Colors.grey.shade800,
                      enabled: _controller.listoParaComprobar,
                      onTap: comprobar,
                      child: const Text(
                        "COMPROBAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _obtenerMensajeError(LevelModel model) {
    if (model is ContrastLevelModel) return model.explanation;
    if (model is BlindLevelModel) return model.explanation;
    if (model is MixLevelModel) {
      return "Mezclar pigmentos físicos es sustractivo: busca qué dos reactivos combinados forman el tono objetivo.";
    }
    if (model is SearchLevelModel) {
      return "El tono solicitado responde a la psicología del color. Elige el matiz que exprese mejor la emoción del brief.";
    }
    if (model is GradientLevelModel) {
      return "El color correcto debe encajar de forma suave y progresiva en la escala cromática sin romper la gradación visual.";
    }
    if (model is HarmonyLevelModel) {
      return "La respuesta correcta debe formar la relación geométrica solicitada.";
    }
    if (model is RgbLevelModel) {
      return "El color resultante de tu mezcla difiere del objetivo. Ajusta los canales R, G y B.";
    }
    if (model is TempLevelModel) {
      return "¡Cuidado! Clasifica los cálidos en el frasco izquierdo y los fríos en el derecho.";
    }
    if (model is HexLevelModel) {
      return "El código hexadecimal #RRGGBB representa la intensidad del Rojo, Verde y Azul.";
    }
    if (model is AlbersLevelModel) return model.explanation;
    if (model is AtmosphereLevelModel) {
      return "La paleta correcta debe ser coherente con la temática y las emociones del brief cinematográfico.";
    }
    if (model is SaturationLevelModel) {
      return "El orden secuencial correcto debe ir de menor a mayor pureza.";
    }
    return "Esa no es la respuesta correcta. ¡Inténtalo de nuevo!";
  }

  Widget _buildDefaultInstructionCard(LevelModel datos) {
    String subtitle = "";
    String title = datos.title;

    if (datos is MixLevelModel) {
      subtitle = datos.objective;
      title = "OBJETIVO";
    }

    return Container(
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
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFFF9F1C),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            datos.instruction,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}