import 'package:flutter/material.dart';
import '../../controllers/splash_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import 'registro_screen.dart';
import 'menu_principal_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Cargar progreso persistido antes de completar la simulación de carga
        await UserController().cargarProgresoLocal();
      } catch (e) {
        debugPrint("Error al cargar SharedPreferences: $e");
      }

      _controller.iniciarSimulacionDeCarga(
        onComplete: () {
          final user = UserController().currentUser;
          // Si el correo no es el por defecto (invitado), significa que ya se registró anteriormente
          final bool yaRegistrado = user.email != "invitado@correo.com";

          if (yaRegistrado) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPrincipalScreen(
                  correo: user.email,
                  edad: user.age,
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistroScreen()),
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.fondoPastel,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            int porcentaje = (_controller.progreso * 100).toInt();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/imagenes/icon1.png', 
                      width: 600, 
                      height: 600,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100, color: Colors.white54);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cargando... $porcentaje%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
