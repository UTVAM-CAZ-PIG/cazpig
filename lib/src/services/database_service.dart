import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Asegúrate de que la ruta apunte a tu modelo

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Convierte TU UserModel a un Map compatible con Firestore
  Map<String, dynamic> _userToMap(UserModel user) {
    return {
      'email': user.email,
      'age': user.age,
      'xp': user.xp,
      'level': user.level,
      'currentLevelReached': user.currentLevelReached,
      'lives': user.lives,
      'streak': user.streak,
      'pigments': user.pigments,
      'isOffline': user.isOffline,
      'title': user.title,
      'badges': user.badges,
      'lastLogin': FieldValue.serverTimestamp(), // Se añade automáticamente al subirlo
    };
  }

  // Convierte lo que viene de Firestore de vuelta a TU UserModel
  UserModel _mapToUser(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      age: map['age'] ?? '',
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      currentLevelReached: map['currentLevelReached'] ?? 1,
      lives: map['lives'] ?? 5,
      streak: map['streak'] ?? 0,
      pigments: map['pigments'] ?? 0,
      isOffline: map['isOffline'] ?? false,
      title: map['title'] ?? '',
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  // 1. Guardar o actualizar el perfil principal del usuario (users/{uid})
  Future<void> saveUserProfile(String uid, UserModel user) async {
    try {
      await _db.collection('users').doc(uid).set(_userToMap(user), SetOptions(merge: true));
      print("¡Perfil de usuario sincronizado en Firestore!");
    } catch (e) {
      print("Error al guardar el perfil: $e");
    }
  }

  // 2. Obtener los datos del usuario desde Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return _mapToUser(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error al obtener el perfil: $e");
    }
    return null;
  }

  // 3. Guardar el resultado de una partida en la subcolección (users/{uid}/gameResults/{nivelId})
  Future<void> saveGameResult({
    required String uid,
    required int nivel,
    required bool completado,
    required int aciertos,
    required int errores,
    required int pigmentosGanados,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('gameResults')
          .doc('nivel_$nivel') 
          .set({
        'nivel': nivel,
        'completado': completado,
        'fecha': FieldValue.serverTimestamp(),
        'aciertos': aciertos,
        'errores': errores,
        'pigmentosGanados': pigmentosGanados,
      });
      print("¡Resultado del nivel $nivel registrado con éxito!");
    } catch (e) {
      print("Error al guardar resultado del juego: $e");
    }
  }
}