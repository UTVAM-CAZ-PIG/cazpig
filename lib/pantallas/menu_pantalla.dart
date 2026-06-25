import 'package:flutter/material.dart';
import 'perfil.dart';
import 'nivel.dart';
import 'menu.dart';

class MenuPrincipal extends StatefulWidget {
  final String correo;
  final String edad;

  const MenuPrincipal({
    super.key,
    required this.correo,
    required this.edad,
  });

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _currentIndex = 1; // Inicia en 'Jugar'

  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    // NOTA: Si necesitas usar "widget.correo" o "widget.edad" dentro de PerfilPantalla,
    // puedes pasárselos aquí, por ejemplo: PerfilPantalla(correo: widget.correo, edad: widget.edad)
    _paginas = [
      PerfilPantalla(correo:widget.correo, edad:widget.edad),
      const NivelPantalla(),  
      const MenuPantalla(),   
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Degradado característico del juego
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

    return Scaffold(
      // Mantenemos un fondo pastel muy suave detrás de las pantallas
      backgroundColor: const Color(0xffF6F9FF),
      
      // --- APP BAR REDISEÑADO (MÁS JUVENIL Y LIMPIO) ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => degradadoGlow.createShader(bounds),
          child: const Text(
            'Cazadores de Pigmentos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Colors.orangeAccent,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),

      // Cuerpo de la pantalla actual
      body: _paginas[_currentIndex],

      // --- BOTTOM NAVIGATION BAR FLOTANTE Y COLORIDA ---
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24), // Hace que flote despegada del suelo
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30), // Bordes súper redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.shade300.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10), // Sombra suave hacia abajo
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white, // Fondo blanco para la barra
            selectedItemColor: Colors.deepOrange.shade300, // Color alegre para la pestaña activa
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            type: BottomNavigationBarType.fixed, // Evita animaciones raras al cambiar
            elevation: 0, // Quitamos la línea rígida de arriba de la barra
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_rounded, size: 26),
                ),
                label: 'Perfil',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.videogame_asset_rounded, size: 28),
                ),
                label: 'Jugar',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.palette_rounded, size: 26), // Cambiado a paleta para combinar con "Ajustes/Menú"
                ),
                label: 'Menú',
              ),
            ],
          ),
        ),
      ),
    );
  }
}