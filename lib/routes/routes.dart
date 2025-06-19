import 'package:flutter/material.dart';
import 'package:juegoflutter/pages/pantalla_inicio.dart';
import 'package:juegoflutter/pages/pantalla_juego.dart';
import 'package:juegoflutter/pages/pantalla_resumen.dart';

import '../Clase/JuegoParejas.dart';
import '../Clase/Jugador.dart';

class AppRoutes {
  static const String inicio = '/';
  static const String juego = '/juego';
  static const String resumen = '/resumen';

  static Route<dynamic> generarRuta(RouteSettings settings) {
    switch (settings.name) {
      case inicio:
        return MaterialPageRoute(builder: (_) => const PantallaInicio());

      case juego:
        final juego = settings.arguments as JuegoParejas;
        return MaterialPageRoute(
          builder: (_) => PantallaJuego(juego: juego),
        );

      case resumen:
      
        return MaterialPageRoute(
          builder: (_) => PantallaResumen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
