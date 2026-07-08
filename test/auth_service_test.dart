import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pigmento/src/services/auth_service.dart';

void main() {
  group('AuthService', () {
    test('devuelve un mensaje claro para contraseña muy débil', () {
      final service = AuthService();
      final error = FirebaseAuthException(
        code: 'weak-password',
        message: 'The password provided is too weak.',
      );

      expect(service.getErrorMessage(error), 'La contraseña es muy débil.');
    });

    test('devuelve un mensaje claro para correo ya registrado', () {
      final service = AuthService();
      final error = FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'The account already exists for that email.',
      );

      expect(service.getErrorMessage(error), 'Este correo ya está registrado.');
    });
  });
}
