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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Ciudad) return false;
    return ciudadId == other.ciudadId;
  }

  @override
  int get hashCode => ciudadId.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Rol) return false;
    return rolId == other.rolId;
  }

  @override
  int get hashCode => rolId.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Cargo) return false;
    return cargoId == other.cargoId;
  }

  @override
  int get hashCode => cargoId.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EstadoCivil) return false;
    return estadoCivilId == other.estadoCivilId;
  }

  @override
  int get hashCode => estadoCivilId.hashCode;
}
