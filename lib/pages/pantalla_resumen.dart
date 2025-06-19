import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../routes/routes.dart';

class PantallaResumen extends StatefulWidget {
  const PantallaResumen({super.key});

  @override
  State<PantallaResumen> createState() => _PantallaResumenState();
}

class _PantallaResumenState extends State<PantallaResumen> {
  final String filePath =
      r'C:\Users\julio\Desktop\portafollio(1)\ppt-angular\juegoflutter\lib\records\records.json';
  List<Map<String, dynamic>> jugadores = [];

  @override
  void initState() {
    super.initState();
    _leerRegistros();
  }

  Future<void> _leerRegistros() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contenido = await file.readAsString();
        final List<dynamic> data = json.decode(contenido);
        setState(() {
          jugadores = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() {
          jugadores = [];
        });
      }
    } catch (e) {
      print('Error al leer el archivo: $e');
      setState(() {
        jugadores = [];
      });
    }
  }

  Future<void> _borrarRegistros() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.writeAsString('[]'); // Limpia el archivo con una lista vacía
        setState(() {
          jugadores = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los registros fueron borrados.')),
        );
      }
    } catch (e) {
      print('Error al borrar registros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos altura para el contenedor de la tabla
    final double alturaTabla =
        jugadores.length > 6 ? 300 : (jugadores.length * 50.0) + 70;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del Juego'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Jugadores',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            jugadores.isNotEmpty
                ? SizedBox(
                    height: alturaTabla,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: [
                          // Cabecera de la tabla
                          const TableRow(
                            decoration: BoxDecoration(
                              color: Color(0xFFE0E0E0),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Jugador',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Intentos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Fallos',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                  'Puntaje Final',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Filas de datos
                          ...jugadores.map((jugador) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    jugador['nombre'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    jugador['intentos'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    jugador['fallos'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    jugador['puntaje'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  )
                : const Text(
                    'No hay registros disponibles.',
                    style: TextStyle(fontSize: 18),
                  ),

            const SizedBox(height: 20),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.inicio,
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text('Volver al Inicio'),
                ),

                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _borrarRegistros,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Borrar Registros'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
