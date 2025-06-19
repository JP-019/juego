import 'dart:convert';
import 'dart:io';

import 'Jugador.dart'; // Importa la clase Jugador

class JsonRecordManager {
  final String filePath = r'juegoflutter\lib\records\records.json';

  // Crea el directorio necesario y devuelve la ruta del archivo JSON
  Future<File> _getFile() async {
    final file = File(filePath);

    // Crea los directorios si no existen
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    return file;
  }

  // Guarda un jugador en el archivo JSON
  Future<void> guardarJugador(Jugador jugador) async {
    try {
      final file = await _getFile();

      List<Jugador> jugadores = [];

      // Si el archivo existe, carga los jugadores existentes
      if (await file.exists()) {
        final contenido = await file.readAsString();
        if (contenido.isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(contenido);
          jugadores = jsonList.map((e) => Jugador.fromJson(e)).toList();
        }
      }

      // Agrega el nuevo jugador y guarda el archivo
      jugadores.add(jugador);
      final jsonString = jsonEncode(jugadores.map((j) => j.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error al guardar jugador: $e');
    }
  }

  // Lee todos los jugadores del archivo JSON
  Future<List<Jugador>> leerJugadores() async {
    try {
      final file = await _getFile();

      // Si el archivo no existe, devuelve una lista vacía
      if (!(await file.exists())) return [];

      final contenido = await file.readAsString();
      if (contenido.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(contenido);
      return jsonList.map((e) => Jugador.fromJson(e)).toList();
    } catch (e) {
      print('Error al leer jugadores: $e');
      return [];
    }
  }
}
