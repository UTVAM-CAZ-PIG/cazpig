import 'package:flutter/material.dart';

class Nivel2Pantalla extends StatefulWidget {
  final int nivelInicial;
  const Nivel2Pantalla({super.key, required this.nivelInicial});

  @override
  State<Nivel2Pantalla> createState() => _Nivel2PantallaState();
}

class _Nivel2PantallaState extends State<Nivel2Pantalla> {
  final List<Map<String, dynamic>> _nivelesBranding = [
    {"nivel": 1, "contexto": "TECNOLOGÍA Y SALUD", "brief": "El cliente exige proyectar alta confianza, seguridad institucional, estabilidad y lógica científica. ¿Qué matiz es el ideal?", "correcto": Colors.blue, "n": "Azul Corporativo"},
    {"nivel": 2, "contexto": "CADENA DE FAST FOOD", "brief": "Se busca activar el apetito inmediato de los consumidores de forma masiva y veloz. Selecciona el pigmento estimulante visceral:", "correcto": Colors.red, "n": "Rojo Impulsivo"},
    {"nivel": 3, "contexto": "LÍNEA DE PRODUCTOS ECO", "brief": "Identidad visual basada en la sustentabilidad, el desarrollo orgánico y el equilibrio natural. ¿Cuál es su color base?", "correcto": Colors.green, "n": "Verde Orgánico"},
    {"nivel": 4, "contexto": "BOUTIQUE DE LUJO EXCLUSIVO", "brief": "Diseño premium que busca representar elegancia absoluta, sofisticación, solemnidad y alto estatus económico sin distracciones.", "correcto": const Color(0xFF000000), "n": "Negro Absoluto"},
    {"nivel": 5, "contexto": "ESTUDIO CREATIVO O AGENCIA", "brief": "Se requiere comunicar innovación constante, juventud, diversión, dinamismo y un alto factor de asombro intelectual.", "correcto": Colors.orange, "n": "Naranja Innovación"},
    {"nivel": 6, "contexto": "MARCA INFANTIL Y JUGUETES", "brief": "El brief pide denotar diversión pura, energía radiante, optimismo, estímulo mental temprano y mucha luz ambiental.", "correcto": Colors.yellow, "n": "Amarillo Optimismo"},
    {"nivel": 7, "contexto": "PRODUCTOS DE CUIDADO FEMENINO", "brief": "Estética contemporánea orientada a la delicadeza, suavidad, romanticismo, calma afectiva y empatía visual.", "correcto": Colors.pink, "n": "Rosa Suavidad"},
    {"nivel": 8, "contexto": "SPA Y CENTRO DE MEDITACIÓN", "brief": "Identidad que busca inducir un estado de relajación mental absoluta, equilibrio espiritual, transmutación y paz.", "correcto": Colors.purple, "n": "Violeta Zen"},
    {"nivel": 9, "contexto": "LÍNEA DE MAQUILLAJE DERMATOLÓGICO", "brief": "Marca que ensalza la pureza, limpieza total, inocencia clínica, transparencia y minimalismo absoluto.", "correcto": Colors.white, "n": "Blanco Puro"},
    {"nivel": 10, "contexto": "EDITORIAL DE HISTORIA Y ARQUEOLOGÍA", "brief": "Se desea transmitir tradición ancestral, conexión con las raíces, calidez rústica y durabilidad en el tiempo.", "correcto": const Color(0xFF8B4513), "n": "Café Tradición"},
  ];

  late Map<String, dynamic> _datosNivel;
  late List<Map<String, dynamic>> _opciones;

  @override
  void initState() {
    super.initState();
    _datosNivel = _nivelesBranding.firstWhere((n) => n["nivel"] == widget.nivelInicial);
    
    _opciones = [
      {"color": _datosNivel["correcto"], "nombre": _datosNivel["n"]},
      {"color": Colors.blueGrey, "nombre": "Gris Neutro"},
      {"color": Colors.teal, "nombre": "Teal Alterno"},
      {"color": Colors.amber, "nombre": "Muestra Extra"}
    ]..shuffle();
  }

  void _validar(Color elegida) {
    bool correcto = elegida.value == _datosNivel["correcto"].value;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(correcto ? '¡Criterio correcto de marca! Brief aprobado. +100 XP' : 'Rechazado. Ese color altera el mensaje estratégico. -50 XP'),
      backgroundColor: correcto ? Colors.green : Colors.red,
    ));
    if (correcto) Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    int crossAxis = ancho > 600 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: Text('Modo Buscar - Nivel ${_datosNivel["nivel"]}'), backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
      body: Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.orange, width: 1), borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(_datosNivel["contexto"], style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Text(_datosNivel["brief"], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
                  ],
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2
              ),
              itemCount: _opciones.length,
              itemBuilder: (context, index) {
                final item = _opciones[index];
                return GestureDetector(
                  onTap: () => _validar(item["color"]),
                  child: Container(
                    decoration: BoxDecoration(color: item["color"], borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white30, width: 1.5)),
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(8),
                    child: Text(item["nombre"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, backgroundColor: Colors.black45)),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}