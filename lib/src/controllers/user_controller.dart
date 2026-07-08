import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
// 1. IMPORTANTE: Importamos el servicio de la base de datos
import '../services/database_service.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  UserModel? _currentUser;
  
  // 2. Instanciamos el servicio de base de datos
  final DatabaseService _dbService = DatabaseService();

  UserModel get currentUser => _currentUser ?? UserModel.initial(email: "invitado@correo.com", age: "0");

  /// 3. MÉTODO AUXILIAR: Envía el estado actual a Firebase si no está offline
  Future<void> _sincronizarConFirebase() async {
    // Si el usuario es invitado, no tiene email real o está offline, no subimos nada
    if (_currentUser == null || currentUser.email == "invitado@correo.com" || currentUser.isOffline) return;
    
    try {
      // Usamos el email como identificador único para el documento en Firebase (limpiando caracteres especiales si es necesario)
      final String docId = currentUser.email.replaceAll('.', '_');
      
      await _dbService.saveUserProfile(docId, currentUser);
      print("¡Progreso de ${currentUser.email} sincronizado en Firebase!");
    } catch (e) {
      print("Error al sincronizar con Firebase: $e");
    }
  }

  /// Inicializa el usuario (después del login)
  void inicializarUsuario({required String email, required String age, required bool isOffline}) {
    _currentUser = UserModel.initial(email: email, age: age, isOffline: isOffline);
    _verificarRachaDiaria();
    guardarProgresoLocal();
    
    // 4. Sincronizamos con Firebase al iniciar sesión
    _sincronizarConFirebase();
    
    notifyListeners();
  }

  /// Carga los datos guardados en el almacenamiento local
  Future<void> cargarProgresoLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("cazpig_email")) {
      final email = prefs.getString("cazpig_email") ?? "";
      final age = prefs.getString("cazpig_age") ?? "";
      final xp = prefs.getInt("cazpig_xp") ?? 1250;
      final level = prefs.getInt("cazpig_level") ?? 5;
      final currentLevelReached = prefs.getInt("cazpig_current_level") ?? 1;
      final lives = prefs.getInt("cazpig_lives") ?? 5;
      final streak = prefs.getInt("cazpig_streak") ?? 5;
      final pigments = prefs.getInt("cazpig_pigments") ?? 591;
      final isOffline = prefs.getBool("cazpig_is_offline") ?? false;
      final title = prefs.getString("cazpig_title") ?? "Cazador Experto";
      final badges = prefs.getStringList("cazpig_badges") ?? ["Primer Trazo", "Racha Color", "Ojo Mágico"];

      _currentUser = UserModel(
        email: email,
        age: age,
        xp: xp,
        level: level,
        currentLevelReached: currentLevelReached,
        lives: lives,
        streak: streak,
        pigments: pigments,
        isOffline: isOffline,
        title: title,
        badges: badges,
      );

      // Checar vidas por tiempo al cargar
      _regenerarVidasPorTiempo();
      _verificarRachaDiaria();
      notifyListeners();
    }
  }

  /// Guarda los datos del usuario en SharedPreferences
  Future<void> guardarProgresoLocal() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cazpig_email", currentUser.email);
    await prefs.setString("cazpig_age", currentUser.age);
    await prefs.setInt("cazpig_xp", currentUser.xp);
    await prefs.setInt("cazpig_level", currentUser.level);
    await prefs.setInt("cazpig_current_level", currentUser.currentLevelReached);
    await prefs.setInt("cazpig_lives", currentUser.lives);
    await prefs.setInt("cazpig_streak", currentUser.streak);
    await prefs.setInt("cazpig_pigments", currentUser.pigments);
    await prefs.setBool("cazpig_is_offline", currentUser.isOffline);
    await prefs.setString("cazpig_title", currentUser.title);
    await prefs.setStringList("cazpig_badges", currentUser.badges);
  }

  /// Registra el fin de un nivel exitoso (+100 XP, +30 Pigmentos)
  void completarNivel(int nivel) async {
    _currentUser ??= UserModel.initial(email: "invitado@correo.com", age: "0");

    int nuevaXp = currentUser.xp + 100;
    int nuevosPigmentos = currentUser.pigments + 30;
    int nuevoNivel = (nuevaXp / 500).floor() + 1;
    
    String nuevoTitulo = "Cazador Novato";
    if (nuevoNivel >= 3 && nuevoNivel < 5) nuevoTitulo = "Cazador Intermedio";
    if (nuevoNivel >= 5 && nuevoNivel < 8) nuevoTitulo = "Cazador Experto";
    if (nuevoNivel >= 8) nuevoTitulo = "Maestro de Pigmentos";

    int nuevoNivelAlcanzado = currentUser.currentLevelReached;
    if (nivel == currentUser.currentLevelReached) {
      nuevoNivelAlcanzado = nivel + 1;
    }

    _currentUser = currentUser.copyWith(
      xp: nuevaXp,
      pigments: nuevosPigmentos,
      level: nuevoNivel,
      currentLevelReached: nuevoNivelAlcanzado,
      title: nuevoTitulo,
    );

    await guardarProgresoLocal();
    
    // 5. Sincronizamos con Firebase al completar el nivel para actualizar XP y nivel
    await _sincronizarConFirebase();
    
    // 6. Además guardamos el registro específico de esta partida en la subcolección
    if (!currentUser.isOffline && currentUser.email != "invitado@correo.com") {
      final String docId = currentUser.email.replaceAll('.', '_');
      await _dbService.saveGameResult(
        uid: docId,
        nivel: nivel,
        completado: true,
        aciertos: 5, // Puedes cambiarlo por variables dinámicas si tu vista las provee
        errores: 0,
        pigmentosGanados: 30,
      );
    }

    notifyListeners();
  }

  /// Restar 1 vida por respuesta incorrecta
  void restarVida() async {
    if (currentUser.lives > 0) {
      int nuevasVidas = currentUser.lives - 1;
      _currentUser = currentUser.copyWith(lives: nuevasVidas);

      final prefs = await SharedPreferences.getInstance();
      if (nuevasVidas == 4) {
        await prefs.setString("cazpig_last_life_loss", DateTime.now().toIso8601String());
      }
      await guardarProgresoLocal();
      _sincronizarConFirebase(); // Sincroniza la pérdida de vida
      notifyListeners();
    }
  }

  /// Restaura vidas al máximo
  void recuperarVidas() async {
    _currentUser = currentUser.copyWith(lives: 5);
    await guardarProgresoLocal();
    _sincronizarConFirebase();
    notifyListeners();
  }

  /// Compra vidas con pigmentos de la economía del juego
  bool comprarVidasConPigmentos() {
    if (currentUser.pigments >= 150) {
      _currentUser = currentUser.copyWith(
        lives: 5,
        pigments: currentUser.pigments - 150,
      );
      guardarProgresoLocal().then((_) => _sincronizarConFirebase());
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Calculates lives to regenerate based on elapsed time (5 mins per life)
  Future<void> _regenerarVidasPorTiempo() async {
    if (currentUser.lives >= 5) return;
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString("cazpig_last_life_loss");
    if (timeStr == null) return;

    final lastLoss = DateTime.parse(timeStr);
    final diff = DateTime.now().difference(lastLoss).inMinutes;

    int vidasARecuperar = (diff / 5).floor();
    if (vidasARecuperar > 0) {
      int nuevasVidas = (currentUser.lives + vidasARecuperar).clamp(0, 5);
      _currentUser = currentUser.copyWith(lives: nuevasVidas);
      
      if (nuevasVidas < 5) {
        final remanenteMinutos = diff % 5;
        final nuevaMarca = DateTime.now().subtract(Duration(minutes: remanenteMinutos));
        await prefs.setString("cazpig_last_life_loss", nuevaMarca.toIso8601String());
      } else {
        await prefs.remove("cazpig_last_life_loss");
      }
      await guardarProgresoLocal();
      _sincronizarConFirebase();
    }
  }

  /// Verifica y calcula las rachas consecutivas de juego diario.
  Future<void> _verificarRachaDiaria() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString("cazpig_last_login");
    final now = DateTime.now();

    if (lastLoginStr != null) {
      final lastLogin = DateTime.parse(lastLoginStr);
      final differenceInHours = now.difference(lastLogin).inHours;

      if (differenceInHours > 48) {
        _currentUser = currentUser.copyWith(streak: 0);
      } else if (differenceInHours >= 24) {
        _currentUser = currentUser.copyWith(streak: currentUser.streak + 1);
      }
    }

    await prefs.setString("cazpig_last_login", now.toIso8601String());
    await guardarProgresoLocal();
    _sincronizarConFirebase();
  }
}