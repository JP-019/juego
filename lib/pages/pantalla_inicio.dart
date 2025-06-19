import 'package:flutter/material.dart';
import '../Clase/JuegoParejas.dart';
import '../Clase/Jugador.dart';
import '../routes/routes.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tamanoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _iniciarJuego() {
    if (!_formKey.currentState!.validate()) return;

    final String nombre = _nombreController.text.trim();
    final int dimension = int.parse(_tamanoController.text);

    final jugador = Jugador(nombre: nombre);
    final juego = JuegoParejas(dimension, jugador);

    Navigator.pushNamed(
      context,
      AppRoutes.juego,
      arguments: juego,
    );
  }

  void _iniciarJuegorapido() {
    // No requiere validar formulario ni leer controles, es juego rápido fijo
    final jugador = Jugador(nombre: "Jugador Rápido");
    final juego = JuegoParejas(6, jugador); // Matriz 5x5 fija

    Navigator.pushNamed(
      context,
      AppRoutes.juego,
      arguments: juego,
    );
  }

  void _irAResumen() {
    Navigator.pushNamed(context, AppRoutes.resumen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Juego de Memoria',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del jugador',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _tamanoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Tamaño de la matriz (1 a 20)',
                        prefixIcon: Icon(Icons.grid_4x4),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final int? val = int.tryParse(value ?? '');
                        if (val == null || val <= 0 || val > 20) {
                          return 'Introduce un número entre 1 y 20';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _iniciarJuego,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          'Iniciar Juego',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _iniciarJuegorapido, // Aquí botón juego rápido
                        icon: const Icon(Icons.flash_on),
                        label: const Text(
                          'Juego rápido (6x6)',
                          style: TextStyle(fontSize: 18),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.indigo),
                          foregroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _irAResumen,
                        icon: const Icon(Icons.bar_chart),
                        label: const Text('Ver Resumen'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.indigo),
                          foregroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
