class Colaborador {
  final int colaboradorId;
  final int personaId;
  final int rolId;
  final int cargoId;
  final bool activo;
  final String direccion;
  final int usuarioCrea;
  final DateTime fechaCrea;
  final int? usuarioModifica;
  final DateTime? fechaModifica;
  final double? latitud;
  final double? longitud;

  Colaborador({
    required this.colaboradorId,
    required this.personaId,
    required this.rolId,
    required this.cargoId,
    required this.activo,
    required this.direccion,
    required this.usuarioCrea,
    required this.fechaCrea,
    this.usuarioModifica,
    this.fechaModifica,
    this.latitud,
    this.longitud,
  });

  factory Colaborador.fromJson(Map<String, dynamic> json) {
    return Colaborador(
      colaboradorId: json['colaboradorId'] ?? 0,
      personaId: json['personaId'] ?? 0,
      rolId: json['rolId'] ?? 0,
      cargoId: json['cargoId'] ?? 0,
      activo: json['activo'] ?? false,
      direccion: json['direccion'] ?? '',
      usuarioCrea: json['usuarioCrea'] ?? 0,
      fechaCrea: json['fechaCrea'] != null
          ? DateTime.parse(json['fechaCrea'])
          : DateTime.now(),
      usuarioModifica: json['usuarioModifica'],
      fechaModifica: json['fechaModifica'] != null
          ? DateTime.parse(json['fechaModifica'])
          : null,
      latitud: json['latitud']?.toDouble(),
      longitud: json['longitud']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colaboradorId': colaboradorId,
      'personaId': personaId,
      'rolId': rolId,
      'cargoId': cargoId,
      'activo': activo,
      'direccion': direccion,
      'usuarioCrea': usuarioCrea,
      'fechaCrea': fechaCrea.toIso8601String(),
      'usuarioModifica': usuarioModifica,
      'fechaModifica': fechaModifica?.toIso8601String(),
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}

class ColaboradorGetAllDto {
  final int? colaboradorId;
  final int? personaId;
  final String? nombre;
  final String? apellido;
  final int? rolId;
  final int? cargoId;
  final bool? activo;
  final String? direccion;
  final int? usuarioCrea;
  final DateTime? fechaCrea;
  final int? usuarioModifica;
  final DateTime? fechaModifica;
  final double? latitud;
  final double? longitud;
  final String? nombreCompleto;

  ColaboradorGetAllDto({
    this.colaboradorId,
    this.personaId,
    this.nombre,
    this.apellido,
    this.rolId,
    this.cargoId,
    this.activo,
    this.direccion,
    this.usuarioCrea,
    this.fechaCrea,
    this.usuarioModifica,
    this.fechaModifica,
    this.latitud,
    this.longitud,
    this.nombreCompleto,
  });

  factory ColaboradorGetAllDto.fromJson(Map<String, dynamic> json) {
    return ColaboradorGetAllDto(
      colaboradorId: json['colaboradorId'],
      personaId: json['personaId'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      rolId: json['rolId'],
      cargoId: json['cargoId'],
      activo: json['activo'],
      direccion: json['direccion'],
      usuarioCrea: json['usuarioCrea'],
      fechaCrea: json['fechaCrea'] != null
          ? DateTime.parse(json['fechaCrea'])
          : null,
      usuarioModifica: json['usuarioModifica'],
      fechaModifica: json['fechaModifica'] != null
          ? DateTime.parse(json['fechaModifica'])
          : null,
      latitud: json['latitud'],
      longitud: json['longitud'],
      nombreCompleto: json['nombreCompleto'],
    );
  }
}

class CreatePersonaColaboradorDto {
  final String nombre;
  final String apellido;
  final String sexo;
  final String email;
  final String documentoNacionalIdentificacion;
  final bool activo;
  final int? estadoCivilId;
  final int ciudadId;
  final int usuarioCrea;
  final int rolId;
  final int cargoId;
  final String direccion;
  final double latitud;
  final double longitud;

  CreatePersonaColaboradorDto({
    required this.nombre,
    required this.apellido,
    required this.sexo,
    required this.email,
    required this.documentoNacionalIdentificacion,
    required this.activo,
    this.estadoCivilId,
    required this.ciudadId,
    required this.usuarioCrea,
    required this.rolId,
    required this.cargoId,
    required this.direccion,
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toJson() {
    return {
      'Nombre': nombre,
      'Apelllido': apellido,
      'Sexo': sexo,
      'Email': email,
      'Documentonacionalidentificacion': documentoNacionalIdentificacion,
      'Activo': activo,
      'EstadocivilId': estadoCivilId,
      'CiudadId': ciudadId,
      'Usuariocrea': usuarioCrea,
      'RolId': rolId,
      'CargoId': cargoId,
      'Direccion': direccion,
      'Latitud': latitud,
      'Longitud': longitud,
    };
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }
}

