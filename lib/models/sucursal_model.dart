class Sucursal {
  final int sucursalId;
  final String nombre;
  final String direccion;
  final double latitud;
  final double longitud;
  final bool activo;

  Sucursal({
    required this.sucursalId,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    this.activo = true,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      sucursalId: json['sucursalId'] ?? 0,
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      latitud: (json['latitud'] ?? 0).toDouble(),
      longitud: (json['longitud'] ?? 0).toDouble(),
      activo: json['activo'] ?? true,
    );
  }
}

