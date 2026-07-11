import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/progress_header.dart';
import 'perfil_screen.dart';
import 'nivel_seleccion_screen.dart';
import 'ajustes_screen.dart';

class MenuPrincipalScreen extends StatefulWidget {
  final String correo;
  final String edad;

  const MenuPrincipalScreen({
    super.key,
    required this.correo,
    required this.edad,
  });

  @override
  State<MenuPrincipalScreen> createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  int _currentIndex = 1; // Inicia en 'Jugar'
  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      PerfilScreen(correo: widget.correo, edad: widget.edad),
      const NivelSeleccionScreen(),  
      const AjustesScreen(),   
    ];
  }

  @override
  Widget build(BuildContext context) {
   return Container(
      // Usamos un color de fondo oscuro y consistente para toda la app.
      color: const Color(0xFF191D2B),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        extendBody: true, 
        body: _paginas[_currentIndex],
        bottomNavigationBar: AppNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
   );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_currentIndex == 1) {
      // En la pestaña de juego (mapa), mostramos el ProgressHeader
      return const ProgressHeader();
    }
    
    // Para Perfil (0) o Ajustes (2), mostramos un encabezado premium oscuro
    String titulo = "Cazadores de Pigmentos";
    if (_currentIndex == 2) titulo = "Ajustes de Juego";

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 18, 17, 17),
      elevation: 0,
      centerTitle: true,
      title: ShaderMask(
        shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
        child: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
