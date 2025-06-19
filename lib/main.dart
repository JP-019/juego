import 'package:flutter/material.dart';
import 'routes/routes.dart'; // Asegúrate de que esta ruta sea válida
import 'package:juegoflutter/Clase/Jugador.dart' as jugador;
import 'package:juegoflutter/Clase/record_managerjson.dart' as manager;


void main() async {
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego de Parejas',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.inicio, // Define la ruta inicial
      onGenerateRoute: AppRoutes.generarRuta, // Controla la generación de rutas
    );
  }
}

