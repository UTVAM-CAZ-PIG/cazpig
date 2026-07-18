import 'package:flutter/material.dart';
import '../../controllers/game_settings_controller.dart';
import '../../theme/app_theme.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  final GameSettingsController _controller = GameSettingsController();

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
        final settings = _controller.settings;
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit:BoxFit.cover,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSettingsCard(
                      children: [
                        _buildSwitchTile(
                          title: 'Música de fondo',
                          subtitle: 'Melodías ambientales de laboratorio',
                          icon: Icons.music_note_rounded,
                          value: settings.musicActive,
                          onChanged: (value) => _controller.setMusicActive(value),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          title: 'Vibraciones',
                          subtitle: 'Efectos táctiles al acertar o fallar',
                          icon: Icons.vibration_rounded,
                          value: settings.vibrationActive,
                          onChanged: (value) => _controller.setVibrationActive(value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsCard(
                      children: [
                        _buildSwitchTile(
                          title: 'Alertas de Desafíos',
                          subtitle: 'Recordatorios para cazar nuevos pigmentos',
                          icon: Icons.notifications_active_rounded,
                          value: settings.notificationsActive,
                          onChanged: (value) => _controller.setNotificationsActive(value),
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          title: 'Idioma del juego',
                          icon: Icons.translate_rounded,
                          value: settings.language,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Cazadores de Pigmentos v1.0.0',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C3545).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade400)),
      secondary: Icon(icon, color: Colors.cyanAccent),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.cyanAccent,
      inactiveTrackColor: Colors.grey.shade800,
    );
  }

  Widget _buildInfoTile({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      onTap: () {}, // Placeholder for future functionality
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _construirSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        titulo,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1.2),
      ),
    );
  }
}

class FondoLiquidoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void dibujarParticula(double x, double y, double radio, Color color, [double glowSpread = 3.0]) {
      final paintGlow = Paint()
        ..color = color.withOpacity(0.4)
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
