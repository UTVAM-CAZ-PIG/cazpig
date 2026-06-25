import 'package:flutter/material.dart';
import '../niveles/nivel1.dart';
import '../niveles/nivel2.dart';
import '../niveles/nivel3.dart';

class PantallaProgreso extends StatelessWidget {
  final String modoJuego;
  const PantallaProgreso({super.key, required this.modoJuego});

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;
    int columnas = anchoPantalla > 900 ? 6 : (anchoPantalla > 600 ? 4 : 3);

    return Scaffold(
      appBar: AppBar(
        title: Text(modoJuego), 
        backgroundColor: Colors.indigo.shade800, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso: $modoJuego', 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 5),
            const Text(
              'Completa los 10 niveles académicos de esta categoría.', 
              style: TextStyle(color: Colors.grey)
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnas,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  int numeroNivel = index + 1;
                  Color colorRango = _obtenerColorPorModo(modoJuego);

                  return GestureDetector(
                    onTap: () => _mostrarIntroduccion(context, numeroNivel, modoJuego),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorRango.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$numeroNivel',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Text(
                            "DISPONIBLE",
                            style: TextStyle(fontSize: 9, color: Colors.white70, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _obtenerColorPorModo(String modo) {
    if (modo.contains("Combinar")) return Colors.teal;
    if (modo.contains("Buscar")) return Colors.orange;
    return Colors.purple;
  }

  void _mostrarIntroduccion(BuildContext context, int nivel, String modo) {
    String mision = "";
    String teoria = "";

    if (modo.contains("Combinar")) {
      mision = "Nivel $nivel: Mezclar los canales cromáticos primarios y secundarios correctos.";
      teoria = "Dominio de síntesis aditiva (RGB) y sustractiva (CMYK). Conforme subes de nivel, los requerimientos exigen neutralizaciones con blanco o negro.";
    } else if (modo.contains("Buscar")) {
      mision = "Nivel $nivel: Analizar el caso e identificar el color por su valor psicológico/armónico.";
      teoria = "Semiótica y Branding. Identifica contrastes simultáneos, colores complementarios e identidades de marca según el público objetivo.";
    } else {
      mision = "Nivel $nivel: Identificar el color faltante en la secuencia armónica.";
      teoria = "Escalas y Degradados. Evaluación de transiciones fluidas de matiz, luminosidad y saturación sin romper la progresión visual.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🔬 Preparación Académica: Nivel $nivel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivo de Diseño:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(mision),
            const SizedBox(height: 10),
            const Text('Fundamento Teórico:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(teoria),
            const SizedBox(height: 10),
            const Text('⚠️ Reglas de Evaluación:', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
            const Text('• Acierto: +100 XP\n• Error en Brief: -50 XP'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Widget pantallaDestino;
              
              if (modo.contains("Combinar")) {
                pantallaDestino = Nivel1Pantalla(nivelInicial: nivel);
              } else if (modo.contains("Buscar")) {
                pantallaDestino = Nivel2Pantalla(nivelInicial: nivel);
              } else {
                pantallaDestino = Nivel3Pantalla(nivelInicial: nivel);
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) => pantallaDestino));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            child: const Text('¡Iniciar Desafío!'),
          ),
        ],
      ),
    );
  }
}