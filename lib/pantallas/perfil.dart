import 'package:flutter/material.dart';

class PerfilPantalla extends StatelessWidget {
  // 1. Agregamos el "?" para indicar que pueden ser nulos
  final String? correo;
  final String? edad;

  const PerfilPantalla({
    super.key,
    this.correo,
    this.edad,
  });

  @override
  Widget build(BuildContext context) {
    // 2. Creamos una variable segura: si es nulo, usa un texto genérico
    final String correoSeguro = correo ?? "invitado@correo.com";
    final String edadSegura = edad ?? "0";

    final Gradient degradadoGlow = LinearGradient(
      colors: [
        Colors.amber.shade400,
        Colors.orange.shade400,
        Colors.deepOrange.shade300, // Sustituto de Colors.coral
        Colors.pinkAccent.shade100,
        Colors.purpleAccent.shade100
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // --- AVATAR ---
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.shade300.withOpacity(0.3), // Sustituto de Colors.coral
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.deepOrange.shade300, // Sustituto de Colors.coral.shade300
                child: CircleAvatar(
                  radius: 51,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_rounded, size: 65, color: Colors.deepOrange.shade300), // Usamos deepOrange.shade300 para el icono
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- NOMBRE DEL JUGADOR ---
            const Text(
              'Elena Cruz', 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            
            // --- CORREO DEL JUGADOR (USANDO LA VARIABLE SEGURA) ---
            Text(
              correoSeguro, // <--- Cambiado aquí
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            // --- TARJETA PRINCIPAL: PUNTOS Y NIVEL ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 36),
                      const SizedBox(height: 6),
                      const Text('1,250 XP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Puntos Totales', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  Column(
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Colors.deepOrange.shade300, size: 36), // Usamos deepOrange.shade300 para el icono
                      const SizedBox(height: 6),
                      const Text('Nivel 5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Cazador Experto', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- SECCIÓN: VITRINA DE LOGROS ---
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => degradadoGlow.createShader(bounds),
                  child: const Text(
                    "Logros Desbloqueados",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildBadge(Icons.brush_rounded, "Primer Trazo", Colors.green.shade400),
                _buildBadge(Icons.local_fire_department_rounded, "Racha Color", Colors.orange.shade400),
                _buildBadge(Icons.auto_awesome_rounded, "Ojo Mágico", Colors.purple.shade400),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}