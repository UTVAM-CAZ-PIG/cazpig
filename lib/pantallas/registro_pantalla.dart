import 'package:flutter/material.dart';
import 'menu_pantalla.dart'; 

class RegistroPantalla extends StatefulWidget {
  const RegistroPantalla({super.key});

  @override
  State<RegistroPantalla> createState() => _RegistroPantallaState();
}

class _RegistroPantallaState extends State<RegistroPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _edadController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  void _intentarRegistro() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPrincipal(
            correo: _emailController.text,
            edad: _edadController.text,
          ),
        ), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reutilizamos el degradado colorido del juego para mantener la armonía
    final Gradient degradadoGlow = LinearGradient(
      colors: [
        Colors.amber.shade400,
        Colors.orange.shade400,
        Colors.deepOrange.shade300, // Tono rojizo intermedio (sustituto de Colors.coral)
        Colors.pinkAccent.shade100,
        Colors.purpleAccent.shade100
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Scaffold(
      body: Container(
        // Fondo degradado pastel idéntico a tu pantalla de carga
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- TÍTULO CON SHADERMASK (ESTILO GLOW) ---
                  ShaderMask(
                    shaderCallback: (bounds) => degradadoGlow.createShader(bounds),
                    child: const Text(
                      "Registro de Jugador",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.orangeAccent,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- TARJETA CONTENEDORA BLANCA TRANSLÚCIDA ---
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85), // Blanco suave que deja ver el fondo
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.palette_outlined, size: 50, color: Colors.deepOrange.shade300),
                        const SizedBox(height: 24),

                        // Campo Correo
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Correo Electrónico', Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingresa tu correo';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Correo inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Campo Edad
                        TextFormField(
                          controller: _edadController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Edad', Icons.cake_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingresa tu edad';
                            final edad = int.tryParse(value);
                            if (edad == null || edad <= 0 || edad > 120) return 'Edad inválida';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // --- BOTÓN LLAMATIVO CON DEGRADADO ---
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: degradadoGlow,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrange.shade300.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _intentarRegistro,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // Transparente para notar el degradado del contenedor
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text(
                              '¡Comenzar Aventura!', 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
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

  // --- DISEÑO DE LOS INPUTS COMPATIBLE CON EL FONDO BLANCO ---
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: Colors.deepOrange.shade300),
      filled: true,
      fillColor: Colors.grey.shade50, // Un fondo grisáceo muy sutil para los textfields
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300), 
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFF7F50), width: 2), 
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent), 
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2), 
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}