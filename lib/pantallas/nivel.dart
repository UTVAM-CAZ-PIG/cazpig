import 'package:flutter/material.dart';
import '../niveles/nivel1.dart';

class NivelPantalla extends StatelessWidget {
  const NivelPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecciona el Nivel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Nivel1Pantalla()),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.indigo,
                  child: Text('1', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
             
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Text('2', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Text('3', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}