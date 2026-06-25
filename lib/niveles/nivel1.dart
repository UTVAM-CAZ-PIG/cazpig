import 'package:flutter/material.dart';

class Nivel1Pantalla extends StatefulWidget {
  final int nivelInicial;

  const Nivel1Pantalla({super.key, required this.nivelInicial});

  @override
  State<Nivel1Pantalla> createState() => _Nivel1PantallaState();
}

class _Nivel1PantallaState extends State<Nivel1Pantalla> {
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;

  final List<Map<String, dynamic>> _nivelesMezclas = [
    {"nivel": 1, "objetivo": "VIOLETA", "colorHex": const Color(0xFF7B1FA2), "instruccion": "Combina rojo + azul", "c1": Colors.red, "c2": Colors.blue},
    {"nivel": 2, "objetivo": "VERDE", "colorHex": const Color(0xFF388E3C), "instruccion": "Combina azul + amarillo", "c1": Colors.blue, "c2": Colors.yellow},
    {"nivel": 3, "objetivo": "NARANJA", "colorHex": const Color(0xFFF57C00), "instruccion": "Combina rojo + amarillo", "c1": Colors.red, "c2": Colors.yellow},
    {"nivel": 4, "objetivo": "ROSA", "colorHex": const Color(0xFFF48FB1), "instruccion": "Combina rojo + blanco", "c1": Colors.red, "c2": Colors.white},
    {"nivel": 5, "objetivo": "AZUL CLARO", "colorHex": const Color(0xFF81D4FA), "instruccion": "Combina azul + blanco", "c1": Colors.blue, "c2": Colors.white},
    {"nivel": 6, "objetivo": "VERDE CLARO", "colorHex": const Color(0xFFA5D6A7), "instruccion": "Combina verde + blanco", "c1": Colors.green, "c2": Colors.white},
    {"nivel": 7, "objetivo": "MORADO", "colorHex": const Color(0xFF6A1B9A), "instruccion": "Combina rojo + azul", "c1": Colors.red, "c2": Colors.blue},
    {"nivel": 8, "objetivo": "AMARILLO CLARO", "colorHex": const Color(0xFFFFF59D), "instruccion": "Combina amarillo + blanco", "c1": Colors.yellow, "c2": Colors.white},
    {"nivel": 9, "objetivo": "VERDE OSCURO", "colorHex": const Color(0xFF1B5E20), "instruccion": "Combina verde + azul", "c1": Colors.green, "c2": Colors.blue},
    {"nivel": 10, "objetivo": "ROSA PASTEL", "colorHex": const Color(0xFFFCE4EC), "instruccion": "Combina rojo + blanco", "c1": Colors.red, "c2": Colors.white},
  ];

  late Map<String, dynamic> _datosNivel;

  @override
  void initState() {
    super.initState();
    _datosNivel = _nivelesMezclas.firstWhere(
      (n) => n["nivel"] == widget.nivelInicial,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esPantallaAncha = ancho > 700;

    return Scaffold(
      appBar: AppBar(
        title: Text('Modo Mezclas - Nivel ${_datosNivel["nivel"]}'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF151515),
          padding: const EdgeInsets.all(24),
          child: Flex(
            direction: esPantallaAncha ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: esPantallaAncha ? ancho * 0.4 : ancho,
                child: Card(
                  color: const Color(0xFF222222),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _datosNivel["objetivo"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _datosNivel["instruccion"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20, width: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _construirCanal(colorSeleccionado1),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      _construirCanal(colorSeleccionado2),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Colors.red,
                      Colors.blue,
                      Colors.yellow,
                      Colors.green,
                      Colors.white
                    ].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (colorSeleccionado1 == null) {
                              colorSeleccionado1 = color;
                            } else if (colorSeleccionado2 == null) {
                              colorSeleccionado2 = color;
                              _verificarMezcla();
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: color,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCanal(Color? color) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal, width: 2),
      ),
    );
  }

  void _verificarMezcla() {
    Color c1 = _datosNivel["c1"];
    Color c2 = _datosNivel["c2"];

    bool correcto =
        (colorSeleccionado1?.value == c1.value &&
                colorSeleccionado2?.value == c2.value) ||
            (colorSeleccionado1?.value == c2.value &&
                colorSeleccionado2?.value == c1.value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correcto ? '¡Nivel Superado!' : 'Combinación incorrecta'),
        backgroundColor: correcto ? Colors.green : Colors.red,
      ),
    );

    if (correcto) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        colorSeleccionado1 = null;
        colorSeleccionado2 = null;
      });
    }
  }
}