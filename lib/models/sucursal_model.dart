class Sucursal {
  final int sucursalId;
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;
  final bool activo;
  final int? jefeId;

  Sucursal({
    required this.sucursalId,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    this.activo = true,
    this.jefeId,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      sucursalId: json['sucursalId'] ?? 0,
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      latitud: (json['latitud'] != null) ? double.parse(json['latitud'].toString()) : 0.0,
      longitud: (json['longitud'] != null) ? double.parse(json['longitud'].toString()) : 0.0,
      activo: json['activo'] ?? true,
      jefeId: json['jefeId'],
    );
  }
}

