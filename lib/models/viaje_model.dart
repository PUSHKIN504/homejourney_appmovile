class ViajesdetallesCreateClusteredDto {
  final int colaboradorId;
  final double distanciakilometros;
  final double totalPagar;
  final int colaboradorSucursalId;
  final int monedaId;
  final double latitud;
  final double longitud;

  ViajesdetallesCreateClusteredDto({
    required this.colaboradorId,
    required this.distanciakilometros,
    required this.totalPagar,
    required this.colaboradorSucursalId,
    required this.monedaId,
    required this.latitud,
    required this.longitud,
  });

  factory ViajesdetallesCreateClusteredDto.fromJson(Map<String, dynamic> json) {
    return ViajesdetallesCreateClusteredDto(
      colaboradorId: json['colaboradorId'],
      distanciakilometros: json['distanciakilometros']?.toDouble() ?? 0.0,
      totalPagar: json['totalpagar']?.toDouble() ?? 0.0,
      colaboradorSucursalId: json['colaboradorsucursalId'],
      monedaId: json['monedaId'],
      latitud: json['latitud']?.toDouble() ?? 0.0,
      longitud: json['longitud']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colaboradorId': colaboradorId,
      'distanciakilometros': distanciakilometros,
      'totalpagar': totalPagar,
      'colaboradorsucursalId': colaboradorSucursalId,
      'monedaId': monedaId,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}

class ViajesCreateClusteredDto {
  final int sucursalId;
  final List<int> transportistaIds;
  final int estadoId;
  final String viajeHora;
  final DateTime viajeFecha;
  final int usuarioCrea;
  final int monedaId;

  ViajesCreateClusteredDto({
    required this.sucursalId,
    required this.transportistaIds,
    required this.estadoId,
    required this.viajeHora,
    required this.viajeFecha,
    required this.usuarioCrea,
    required this.monedaId,
  });

  factory ViajesCreateClusteredDto.fromJson(Map<String, dynamic> json) {
    return ViajesCreateClusteredDto(
      sucursalId: json['sucursalId'],
      transportistaIds: List<int>.from(json['transportistaIds']),
      estadoId: json['estadoId'],
      viajeHora: json['viajehora'],
      viajeFecha: DateTime.parse(json['viajefecha']),
      usuarioCrea: json['usuariocrea'],
      monedaId: json['monedaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sucursalId': sucursalId,
      'transportistaIds': transportistaIds,
      'estadoId': estadoId,
      'viajehora': viajeHora,
      'viajefecha': viajeFecha.toIso8601String(),
      'usuariocrea': usuarioCrea,
      'monedaId': 1,
    };
  }
}

class CreateViajesRequest {
  final ViajesCreateClusteredDto viajeclusteredDto;
  final List<List<ViajesdetallesCreateClusteredDto>> empleadosclusteredDto;

  CreateViajesRequest({
    required this.viajeclusteredDto,
    required this.empleadosclusteredDto,
  });

  factory CreateViajesRequest.fromJson(Map<String, dynamic> json) {
    return CreateViajesRequest(
      viajeclusteredDto: ViajesCreateClusteredDto.fromJson(json['viajeclusteredDto']),
      empleadosclusteredDto: (json['empleadosclusteredDto'] as List).map((e) => 
        (e as List).map((e2) => ViajesdetallesCreateClusteredDto.fromJson(e2)).toList()
      ).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viajeclusteredDto': viajeclusteredDto.toJson(),
      'empleadosclusteredDto': empleadosclusteredDto.map(
        (clusters) => clusters.map((empleado) => empleado.toJson()).toList()
      ).toList(),
    };
  }
}

