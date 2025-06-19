import 'dart:io';
import 'package:juegoflutter/Clase/Jugador.dart';
import 'package:juegoflutter/Clase/Pareja.dart';

class JuegoParejas {
  final int dimension;
  late final int dimensionUsada; // dimensión ajustada a par
  List<List<Pareja>> matriz = [];
  int intentos = 0;
  int fallos = 0;
  int puntaje = 0;
  Jugador jugador;
  late List<String> valoresDisponibles;

  JuegoParejas(this.dimension, this.jugador) {
    if (dimension > 20) throw Exception('Máximo 20x20');
    // Aquí ajustamos la dimensión para que sea par
    dimensionUsada = (dimension % 2 == 0) ? dimension : dimension + 1;
    _inicializarJuego();
  }

  void _inicializarJuego() {
    int totalPares = (dimensionUsada * dimensionUsada / 2).floor();

    valoresDisponibles = List.generate(totalPares, (i) => String.fromCharCode(65 + i));
    valoresDisponibles += valoresDisponibles; // duplicar para las parejas
    valoresDisponibles.shuffle();

    int counter = 0;
    matriz = List.generate(dimensionUsada, (i) {
      return List.generate(dimensionUsada, (j) {
        return Pareja(valoresDisponibles.removeLast(), counter++);
      });
    });

    intentos = 0;
    fallos = 0;
    puntaje = 0;
    jugador.intentos = 0;
    jugador.fallos = 0;
    jugador.puntaje = 0;
  }

  void reiniciar() {
    _inicializarJuego();
  }

  bool seleccionar(int x1, int y1, int x2, int y2) {
    intentos++;
    jugador.intentos++;
    final p1 = matriz[x1][y1];
    final p2 = matriz[x2][y2];

    if (p1.valor == p2.valor && !p1.descubierta && !p2.descubierta) {
      p1.descubierta = true;
      p2.descubierta = true;
      puntaje += 10;
      jugador.puntaje = puntaje;
      print('¡Pareja encontrada! +10 puntos');
      return true;
    } else {
      fallos++;
      jugador.fallos++;
      puntaje -= 5;
      if (puntaje < 0) puntaje = 0;
      jugador.puntaje = puntaje;
      print('Fallaste. -5 puntos');
      return false;
    }
  }

  bool juegoTerminado() {
    return matriz.expand((e) => e).every((p) => p.descubierta);
  }

  
}
