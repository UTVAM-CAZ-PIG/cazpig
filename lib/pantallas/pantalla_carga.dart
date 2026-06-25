import 'package:flutter/material.dart';
import 'dart:async';
import 'registro_pantalla.dart';

class PantallaDeCarga extends StatefulWidget {
  const PantallaDeCarga({super.key});

  @override
  State<PantallaDeCarga> createState() => _PantallaDeCargaState();
}

class _PantallaDeCargaState extends State<PantallaDeCarga> {
  double progreso = 0.0;
  String mensaje = "Cargando texturas...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarSimulacionDeCarga();
    });
  }

  void _iniciarSimulacionDeCarga() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      setState(() {
        if (progreso < 1.0) {
          progreso += 0.01;
          
          if (progreso > 0.4 && progreso < 0.7) {
            mensaje = "Conectando al servidor...";
          } else if (progreso > 0.7) {
            mensaje = "Escondiendo los pigmentos secretos...";
          }
        } else {
          timer.cancel();
          _irAlMenuPrincipal();
        }
      });
    });
  }

  void _irAlMenuPrincipal() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegistroPantalla()),
    );
  }

  @override
  Widget build(BuildContext context) {
    int porcentaje = (progreso * 100).toInt();

    // --- DEGRADADO ESTILO "JUEGO DE OCA" ---
    // Definimos el degradado exacto para reutilizarlo en las letras y la barra
    final Gradient degradadoGlow = LinearGradient(
      colors: [
        Colors.amber.shade400,       // Amarillo/Dorado inicial
        Colors.orange.shade400,      // Naranja suave
        Colors.deepOrange.shade300,  // Tono rojizo intermedio (sustituto de Colors.coral)
        Colors.pinkAccent.shade100,  // Rosa vibrante
        Colors.purpleAccent.shade100 // Morado/Violeta final
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFFA2A2),
              Color(0xffFFF085),
              Color(0xffA4F4CF),
              Color(0xffB8E6FE),
              Color(0xffDAB2FF),
              Color(0xffFFCCD3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- IMAGEN PRINCIPAL ---
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/imagenes/icon1.png', 
                  width: 600, // Ajustado a un tamaño más prudente para que luzca bien junto a los textos
                  height: 600,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100, color: Colors.white54);
                  },
                ),
              ),
              const SizedBox(height: 40),
              
              // --- TEXTO DINÁMICO CON DEGRADADO Y EFECTO GLOW ---
              ShaderMask(
                shaderCallback: (bounds) => degradadoGlow.createShader(bounds),
                child: Text(
                  "$mensaje ($porcentaje%)",
                  style: TextStyle(
                    color: Colors.white, // Obligatorio blanco para que el ShaderMask pinte encima
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    shadows: [
                      // Sombra naranja/rosa difuminada para imitar el brillo de fondo (Glow)
                      Shadow(
                        blurRadius: 12.0,
                        color: Colors.orange.withOpacity(0.6),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // --- BARRA DE CARGA ADAPTADA ---
              Container(
                width: 300,
                height: 16, 
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // Sombra sutil en el fondo de la barra
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShaderMask(
                    shaderCallback: (bounds) => degradadoGlow.createShader(bounds),
                    // Con esto hacemos que la parte que se va llenando use el mismo degradado
                    blendMode: BlendMode.srcATop, 
                    child: LinearProgressIndicator(
                      value: progreso,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.25), // Contenedor de fondo translúcido suave
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}