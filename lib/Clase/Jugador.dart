class Jugador {
  String nombre;
  int record;
  int puntaje;
  int intentos;
  int fallos;

  Jugador({
    required this.nombre,
    this.record = 0,
    this.puntaje = 0,
    this.intentos = 0,
    this.fallos = 0,
  });

  // Serializa un Jugador a JSON
  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'record': record,
        'puntaje': puntaje,
        'intentos': intentos,
        'fallos': fallos,
      };

  // Crea un Jugador desde un JSON
  factory Jugador.fromJson(Map<String, dynamic> json) {
    return Jugador(
      nombre: json['nombre'] as String,
      record: json['record'] as int? ?? 0,
      puntaje: json['puntaje'] as int? ?? 0,
      intentos: json['intentos'] as int? ?? 0,
      fallos: json['fallos'] as int? ?? 0,
    );
  }
}
