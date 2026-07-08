import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'invalid-api-key':
        return 'Clave de API inválida para Firebase. Revisa firebase_options.dart.';
      case 'app-not-authorized':
        return 'La aplicación no está autorizada para usar este proyecto de Firebase.';
      case 'unauthorized-domain':
        return 'Dominio no autorizado. Añade el dominio (ej. localhost) en la consola de Firebase.';
      case 'operation-not-allowed':
        return 'Método de autenticación deshabilitado. Activa Email/Password en la consola de Firebase.';
      case 'user-not-found':
        return 'No existe una cuenta con este correo.';
      case 'wrong-password':
        return 'La contraseña es incorrecta.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'network-request-failed':
        return 'Sin conexión. Revisa tu red.';
      default:
        return 'Ocurrió un error al autenticar. Intenta de nuevo.';
    }
  }
}
