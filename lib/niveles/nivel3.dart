import 'package:flutter/material.dart';

class Nivel3Pantalla extends StatefulWidget {
  final int nivelInicial;

  const Nivel3Pantalla({
    super.key,
    required this.nivelInicial,
  });

  @override
  State<Nivel3Pantalla> createState() => _Nivel3PantallaState();
}

class _Nivel3PantallaState extends State<Nivel3Pantalla> {
  final List<Map<String, dynamic>> _nivelesDegradados = [
    {
      "nivel": 1,
      "secuencia": [
        Color(0xFFFFEBEE),
        Color(0xFFFFCDD2),
        Colors.transparent,
        Color(0xFFE57373)
      ],
      "correcto": Color(0xFFEF9A9A),
      "n": "Intermedio Claro Rosa"
    },
    {
      "nivel": 2,
      "secuencia": [
        Color(0xFFE3F2FD),
        Colors.transparent,
        Color(0xFF90CAF9),
        Color(0xFF64B5F6)
      ],
      "correcto": Color(0xFFBBDEFB),
      "n": "Intermedio Celeste"
    },
    {
      "nivel": 3,
      "secuencia": [
        Colors.black,
        Color(0xFF333333),
        Colors.transparent,
        Color(0xFF999999)
      ],
      "correcto": Color(0xFF666666),
      "n": "Paso de Gris Oscuro"
    },
    {
      "nivel": 4,
      "secuencia": [
        Color(0xFFE8F5E9),
        Color(0xFFC8E6C9),
        Color(0xFFA5D6A7),
        Colors.transparent
      ],
      "correcto": Color(0xFF81C784),
      "n": "Cierre Verde Claro"
    },
    {
      "nivel": 5,
      "secuencia": [
        Colors.yellow,
        Colors.transparent,
        Colors.orange,
        Colors.red
      ],
      "correcto": Color(0xFFFFB300),
      "n": "Transición de Cálidos"
    },
    {
      "nivel": 6,
      "secuencia": [
        Color(0xFF311B92),
        Color(0xFF4527A0),
        Colors.transparent,
        Color(0xFF5E35B1)
      ],
      "correcto": Color(0xFF512DA8),
      "n": "Paso Violeta Profundo"
    },
    {
      "nivel": 7,
      "secuencia": [
        Color(0xFFFFF8E1),
        Colors.transparent,
        Color(0xFFFFE082),
        Color(0xFFFFD54F)
      ],
      "correcto": Color(0xFFFFECB3),
      "n": "Crema a Amarillo"
    },
    {
      "nivel": 8,
      "secuencia": [
        Color(0xFF006064),
        Color(0xFF00838F),
        Colors.transparent,
        Color(0xFF00ACC1)
      ],
      "correcto": Color(0xFF0097A7),
      "n": "Degradado Cian Oceánico"
    },
    {
      "nivel": 9,
      "secuencia": [
        Color(0xFFF1F8E9),
        Color(0xFFDCEDC8),
        Colors.transparent,
        Color(0xFFAEDB97)
      ],
      "correcto": Color(0xFFC5E1A5),
      "n": "Escala de Tinte Lima"
    },
    {
      "nivel": 10,
      "secuencia": [
        Color(0xFF3E2723),
        Color(0xFF4E342E),
        Color(0xFF5D4037),
        Colors.transparent
      ],
      "correcto": Color(0xFF6D4C41),
      "n": "Tierra de Alta Densidad"
    },
  ];

  late Map<String, dynamic> _datosNivel;
  late List<Map<String, dynamic>> _opcionesMuestras;

  @override
  void initState() {
    super.initState();

    _datosNivel = _nivelesDegradados.firstWhere(
      (n) => n["nivel"] == widget.nivelInicial,
    );

    _opcionesMuestras = [
      {
        "color": _datosNivel["correcto"],
        "nombre": _datosNivel["n"],
      },
      {
        "color": Colors.grey.shade400,
        "nombre": "Distractor A",
      },
      {
        "color": Colors.purple.shade200,
        "nombre": "Distractor B",
      },
    ]..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    List<Widget> secuenciaWidgets =
        (_datosNivel["secuencia"] as List<Color>).map((color) {
      if (color.value == Colors.transparent.value) {
        return Container(
          width: ancho > 600 ? 90 : 65,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purple,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: const Icon(
            Icons.help_outline,
            color: Colors.purple,
            size: 30,
          ),
        );
      }

      return Container(
        width: ancho > 600 ? 90 : 65,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modo Degradado - Nivel ${_datosNivel["nivel"]}',
        ),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFF111111),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Card(
              color: Color(0xFF222222),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'EJERCICIO DE ESCALA TONAL\n\nIdentifica visualmente cuál de las muestras de abajo completa fluidamente la secuencia de transiciones sin romper la armonía.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: secuenciaWidgets,
            ),

            const Text(
              'SELECCIONA EL TONO DE REEMPLAZO CORRECTO',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _opcionesMuestras.map((opcion) {
                return GestureDetector(
                  onTap: () {
                    bool esCorrecto =
                        opcion["color"].value ==
                        _datosNivel["correcto"].value;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          esCorrecto
                              ? '¡Excelente ojo clínico! Degradado perfecto. +100 XP'
                              : 'Salto tonal muy brusco. Transición incorrecta. -50 XP',
                        ),
                        backgroundColor:
                            esCorrecto ? Colors.green : Colors.red,
                      ),
                    );

                    if (esCorrecto) {
                      Future.delayed(
                        const Duration(seconds: 2),
                        () => Navigator.pop(context),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: opcion["color"],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}