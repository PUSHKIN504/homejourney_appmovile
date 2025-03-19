class ColaboradorSucursal {
  final int colaboradorSucursalId;
  final int colaboradorId;
  final int sucursalId;
  final double distanciaKilometro;
  final bool activo;
  final int usuarioCrea;
  final DateTime fechaCrea;
  final int? usuarioModifica;
  final DateTime? fechaModifica;
  final String nombreColaborador;
  final String nombreSucursal;
  final double latitud;
  final double longitud;

  ColaboradorSucursal({
    required this.colaboradorSucursalId,
    required this.colaboradorId,
    required this.sucursalId,
    required this.distanciaKilometro,
    required this.activo,
    required this.usuarioCrea,
    required this.fechaCrea,
    this.usuarioModifica,
    this.fechaModifica,
    this.nombreColaborador = '',
    this.nombreSucursal = '',
    this.latitud = 0,
    this.longitud = 0,
  });

  factory ColaboradorSucursal.fromJson(Map<String, dynamic> json) {
    return ColaboradorSucursal(
      colaboradorSucursalId: json['colaboradorsucursalId'] ?? 0,
      colaboradorId: json['colaboradorId'] ?? 0,
      sucursalId: json['sucursalId'] ?? 0,
      distanciaKilometro: (json['distanciaKilometro'] ?? 0).toDouble(),
      activo: json['activo'] ?? false,
      usuarioCrea: json['usuarioCrea'] ?? 0,
      fechaCrea: json['fechaCrea'] != null 
          ? DateTime.parse(json['fechaCrea']) 
          : DateTime.now(),
      usuarioModifica: json['usuarioModifica'],
      fechaModifica: json['fechaModifica'] != null 
          ? DateTime.parse(json['fechaModifica']) 
          : null,
      nombreColaborador: json['nombreColaborador'] ?? '',
      nombreSucursal: json['nombreSucursal'] ?? '',
      latitud: (json['latitud'] ?? 0).toDouble(),
      longitud: (json['longitud'] ?? 0).toDouble()
    );
  }
}

class ColaboradorSucursalRequest {
  final int colaboradorSucursalId;
  final int colaboradorId;
  final int sucursalId;
  final double distanciaKilometro;
  final bool activo;
  final int usuarioCrea;
  final DateTime fechaCrea;
  final int? usuarioModifica;
  final DateTime? fechaModifica;

  ColaboradorSucursalRequest({
    this.colaboradorSucursalId = 0,
    required this.colaboradorId,
    required this.sucursalId,
    required this.distanciaKilometro,
    this.activo = true,
    required this.usuarioCrea,
    DateTime? fechaCrea,
    this.usuarioModifica,
    this.fechaModifica,
  }) : this.fechaCrea = fechaCrea ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'ColaboradorsucursalId': colaboradorSucursalId,
      'ColaboradorId': colaboradorId,
      'SucursalId': sucursalId,
      'DistanciaKilometro': distanciaKilometro,
      'Activo': activo,
      'UsuarioCrea': usuarioCrea,
      'FechaCrea': fechaCrea.toIso8601String(),
      'UsuarioModifica': usuarioModifica,
      'FechaModifica': fechaModifica?.toIso8601String(),
    };
  }
}

