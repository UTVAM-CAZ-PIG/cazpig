import 'package:flutter/material.dart';
import '../../controllers/registro_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/game_button.dart';
import 'menu_principal_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegistroController();
  bool _isOffline = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _intentarRegistro() {
    if (_formKey.currentState!.validate()) {
      final user = _controller.registrarUsuario();
      UserController().inicializarUsuario(
        email: user.email,
        age: user.age,
        isOffline: _isOffline,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPrincipalScreen(
            correo: user.email,
            edad: user.age,
          ),
        ), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E272E),
              Color(0xFF6C5CE7),
              Color(0xFF00CE99),
              Color(0xFFFF6EC7),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
                    child: Text(
                      "Registro de Jugador",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3545).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.palette_outlined, size: 50, color: Colors.cyanAccent),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Correo Electrónico', Icons.email_outlined),
                          validator: _controller.validarEmail,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _controller.edadController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Edad', Icons.cake_outlined),
                          validator: _controller.validarEdad,
                        ),
                        const SizedBox(height: 20),

                        SwitchListTile(
                          title: const Text(
                            'Modo Offline',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          ),
                          subtitle: Text(
                            'Juega localmente guardando el progreso en el dispositivo',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                          secondary: const Icon(Icons.cloud_off_rounded, color: Colors.cyanAccent),
                          value: _isOffline,
                          onChanged: (bool value) {
                            setState(() => _isOffline = value);
                          },
                        ),
                        const SizedBox(height: 30),

                        GameButton(
                          backgroundColor: const Color(0xFF58CC02),
                          shadowColor: const Color(0xFF46A302),
                          onTap: _intentarRegistro,
                          child: const Text(
                            '¡Comenzar Aventura!', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: Colors.cyanAccent.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
