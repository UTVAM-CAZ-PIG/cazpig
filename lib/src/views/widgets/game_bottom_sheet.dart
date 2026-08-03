import 'package:flutter/material.dart';
import '../../controllers/sound_manager.dart';

class GameBottomSheet {
  /// Alerta única de Victoria (Diseño oscuro centrado)
  static void mostrarVictoria({
    required BuildContext context,
    required int pigmentosGanados,
    String? datoCurioso,
    required VoidCallback onContinuar,
  }) {
    SoundManager().playSuccess();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2430), // Fondo oscuro
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF00C897), width: 1.5), // Borde verde
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C897),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Color(0xFF1E2430),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Síntesis Exitosa",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (datoCurioso != null && datoCurioso.isNotEmpty)
                      ? datoCurioso
                      : "¡Espectacular! Has logrado estabilizar el pigmento. La fórmula es correcta.",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3545),
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      onContinuar();
                    },
                    child: const Text(
                      "Siguiente Nivel",
                      style: TextStyle(
                        color: Color(0xFF00C897),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Alerta única de Derrota (Diseño oscuro centrado)
  static void mostrarDerrota({
    required BuildContext context,
    required String mensaje,
    required VoidCallback onReintentar,
    required VoidCallback onVolver,
  }) {
    SoundManager().playError();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2430), // Fondo oscuro
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFF5252), width: 1.5), // Borde rojo
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.science_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Síntesis Fallida",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  mensaje,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onVolver();
                      },
                      child: const Text(
                        "Volver al Mapa",
                        style: TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3545),
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        onReintentar();
                      },
                      child: const Text(
                        "Reintentar Reacción",
                        style: TextStyle(
                          color: Color(0xFFFF5252),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}