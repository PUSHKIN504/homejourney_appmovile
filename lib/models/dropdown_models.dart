class Ciudad {
  final int ciudadId;
  final String nombre;

  Ciudad({required this.ciudadId, required this.nombre});

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      ciudadId: json['ciudadId'],
      nombre: json['nombre'],
    );
  }
}

class Rol {
  final int rolId;
  final String nombre;

  Rol({required this.rolId, required this.nombre});

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      rolId: json['rolId'],
      nombre: json['nombre'],
    );
  }
}

class Cargo {
  final int cargoId;
  final String nombre;

  Cargo({required this.cargoId, required this.nombre});

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      cargoId: json['cargoId'],
      nombre: json['nombre'],
    );
  }
}

class EstadoCivil {
  final int estadoCivilId;
  final String nombre;

  EstadoCivil({required this.estadoCivilId, required this.nombre});

  factory EstadoCivil.fromJson(Map<String, dynamic> json) {
    return EstadoCivil(
      estadoCivilId: json['estadocivilId'],
      nombre: json['nombre'],
    );
  }
}

