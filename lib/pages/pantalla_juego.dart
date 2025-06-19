import 'package:flutter/material.dart';
import 'package:juegoflutter/Clase/Jugador.dart' as jugador;
import 'package:juegoflutter/Clase/record_managerjson.dart' as manager;
import '../Clase/JuegoParejas.dart';
import '/routes/routes.dart';

class PantallaJuego extends StatefulWidget {
  final JuegoParejas juego;

  const PantallaJuego({super.key, required this.juego});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  int? seleccionadoX;
  int? seleccionadoY;
  Set<String> cartasAcertadas = {};
  Set<String> cartasFallidas = {};
  bool juegoTerminado = false;

  Future<void> _alSeleccionar(int x, int y) async {
    if (juegoTerminado) return;
    if (widget.juego.matriz[x][y].descubierta || (seleccionadoX == x && seleccionadoY == y)) return;

    if (seleccionadoX == null || seleccionadoY == null) {
      setState(() {
        seleccionadoX = x;
        seleccionadoY = y;
      });
      return;
    }

    final x1 = seleccionadoX!;
    final y1 = seleccionadoY!;
    final x2 = x;
    final y2 = y;

    final clave1 = '$x1-$y1';
    final clave2 = '$x2-$y2';

    final acierto = widget.juego.seleccionar(x1, y1, x2, y2);

    setState(() {
      if (acierto) {
        cartasAcertadas.addAll([clave1, clave2]);
      } else {
        cartasFallidas.addAll([clave1, clave2]);
      }
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    if (!acierto) {
      setState(() {
        cartasFallidas.removeAll([clave1, clave2]);
      });
    }

    setState(() {
      seleccionadoX = null;
      seleccionadoY = null;
    });

    if (widget.juego.juegoTerminado()) {
      setState(() {
        juegoTerminado = true;
      });

      // Guardar el récord antes de navegar
      final recordManager = manager.JsonRecordManager();
      await recordManager.guardarJugador(widget.juego.jugador);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.resumen,
          arguments: widget.juego.jugador,
        );
      });
    }
  }

  void _reiniciarJuego() {
    setState(() {
      widget.juego.reiniciar();
      cartasAcertadas.clear();
      cartasFallidas.clear();
      seleccionadoX = null;
      seleccionadoY = null;
      juegoTerminado = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimension = widget.juego.dimension;
    final size = MediaQuery.of(context).size;
    final cellSize = size.width / dimension - 16;

    return Scaffold(
      appBar: AppBar(
        title: Text('Jugador: ${widget.juego.jugador.nombre}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Puntaje: ${widget.juego.jugador.puntaje}')),
          )
        ],
      ),
      body: Column(
        children: [
          if (juegoTerminado) ...[
            Container(
              width: double.infinity,
              color: Colors.green.shade700,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'GANADOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Intenta de nuevo para empezar otra ronda!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _reiniciarJuego,
              child: const Text('Reiniciar Juego'),
            ),
            const Divider(thickness: 1, height: 20),
          ],
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: dimension * dimension,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dimension,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (_, index) {
                final x = index ~/ dimension;
                final y = index % dimension;
                final pareja = widget.juego.matriz[x][y];

                final clave = '$x-$y';
                final estaSeleccionada = (seleccionadoX == x && seleccionadoY == y);
                final fallo = cartasFallidas.contains(clave);
                final acierto = cartasAcertadas.contains(clave);
                final visible = pareja.descubierta || estaSeleccionada || fallo;

                Color bgColor;
                if (acierto) {
                  bgColor = Colors.green;
                } else if (fallo) {
                  bgColor = Colors.red;
                } else {
                  bgColor = visible ? Colors.indigo : Colors.grey;
                }

                return GestureDetector(
                  onTap: () => _alSeleccionar(x, y),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: cellSize,
                      maxHeight: cellSize,
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        visible ? pareja.valor : '?',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
