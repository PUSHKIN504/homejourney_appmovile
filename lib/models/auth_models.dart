class UsuarioLoginRequest {
  final String username;
  final String password;

  UsuarioLoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class UsuarioConDetallesDto {
  final int? usuarioId;
  final String? username;
  final String? nombre;
  final String? apellido;
  final String? email;
  final String? token;
  final bool? activo;
  final int? rolId;
  final String? rolNombre;

  UsuarioConDetallesDto({
    this.usuarioId,
    this.username,
    this.nombre,
    this.apellido,
    this.email,
    this.token,
    this.activo,
    this.rolId,
    this.rolNombre,
  });

  factory UsuarioConDetallesDto.fromJson(Map<String, dynamic> json) {
    return UsuarioConDetallesDto(
      usuarioId: json['usuarioId'],
      username: json['username'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      token: json['token'],
      activo: json['activo'],
      rolId: json['rolId'],
      rolNombre: json['rolNombre'],
    );
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final UsuarioConDetallesDto? data;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UsuarioConDetallesDto.fromJson(json['data']) : null,
    );
  }
}

