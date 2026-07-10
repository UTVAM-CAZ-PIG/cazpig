import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/views/screens/splash_screen.dart';

void main() async {
  // Asegura que Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();

  // Conecta con Firebase de forma global
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CazadoresApp());
}

class CazadoresApp extends StatelessWidget {
  const CazadoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cazadores de Pigmentos',
      home: SplashScreen(),
    );
  }
}