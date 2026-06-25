import 'package:flutter/material.dart';
import 'pantalla_progreso.dart'; // Crearemos esta pantalla a continuación

class NivelPantalla extends StatelessWidget {
  const NivelPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Modos de Juego',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 15),

        _cardModo(
          context,
          titulo: 'Combinar Colores',
          descripcion: 'Mezcla pigmentos base para crear colores nuevos.',
          icono: Icons.science,
          color: Colors.teal,
          disponible: true,
        ),
        _cardModo(
          context,
          titulo: 'Buscar Colores',
          descripcion: 'Encuentra el tono exacto escondido en el tablero.',
          icono: Icons.search,
          color: Colors.orange,
          disponible: true,
        ),
        _cardModo(
          context,
          titulo: 'Degradado de Colores',
          descripcion: 'Ordena las transiciones de color a la perfección.',
          icono: Icons.gradient,
          color: Colors.purple,
          disponible: true,
        ),

        const Divider(height: 40),
        
        // MÓDULO A FUTURO: MULTIJUGADOR
        _cardModo(
          context,
          titulo: 'Multijugador En Línea',
          descripcion: 'Compite en tiempo real con otros cazadores (Próximamente).',
          icono: Icons.public,
          color: Colors.grey,
          disponible: false,
        ),
      ],
    );
  }

  Widget _cardModo(BuildContext context, {
    required String titulo, 
    required String descripcion, 
    required IconData icono, 
    required Color color,
    required bool disponible
  }) {
    return Card(
      elevation: disponible ? 3 : 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: disponible ? Colors.white : Colors.grey.shade200,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(disponible ? 0.2 : 0.1),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: disponible ? Colors.black87 : Colors.black38
          )
        ),
        subtitle: Text(descripcion, style: TextStyle(color: disponible ? Colors.black54 : Colors.black38)),
        trailing: disponible 
            ? const Icon(Icons.arrow_forward_ios, size: 16) 
            : const Icon(Icons.lock, size: 16, color: Colors.grey),
        onTap: disponible ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PantallaProgreso(modoJuego: titulo)),
          );
        } : null,
      ),
    );
  }
}