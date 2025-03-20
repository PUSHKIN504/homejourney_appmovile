class Transportista {
  final int transportistaId;
  final String nombre;
  final double tarifaporkilometro;
  final bool activo;

  Transportista({
    required this.transportistaId,
    required this.nombre,
    required this.tarifaporkilometro,
    this.activo = true,
  });

  factory Transportista.fromJson(Map<String, dynamic> json) {
    return Transportista(
      transportistaId: json['transportistaId'],
      nombre: json['nombre'],
      tarifaporkilometro: json['tarifaporkilometro']?.toDouble() ?? 0,
      activo: json['activo'] ?? true,
    );
  }
}

