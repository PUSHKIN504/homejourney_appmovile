import 'package:equatable/equatable.dart';
import 'package:homejourney_appmovile/models/colaborador_sucursal_model.dart';
import 'package:homejourney_appmovile/models/sucursal_model.dart';
import 'package:homejourney_appmovile/models/transportista_model.dart';
import 'package:homejourney_appmovile/models/viaje_model.dart';

enum ViajeStatus { initial, loading, loaded, success, error }

class ViajeState extends Equatable {
  final ViajeStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<ColaboradorSucursal> colaboradores;
  final List<ColaboradorSucursal> selectedColaboradores;
  final List<Transportista> transportistas;
  final List<Transportista> selectedTransportistas;
  final List<Sucursal> sucursales;
  final int currentTab;
  final List<ViajesdetallesCreateClusteredDto> clusteredEmployees;
  
  final int? sucursalId;
  final String? viajeHora;
  final DateTime? viajeFecha;
  final int monedaId;

  const ViajeState({
    this.status = ViajeStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.colaboradores = const [],
    this.selectedColaboradores = const [],
    this.transportistas = const [],
    this.selectedTransportistas = const [],
    this.sucursales = const [],
    this.currentTab = 0,
    this.clusteredEmployees = const [],
    this.sucursalId,
    this.viajeHora,
    this.viajeFecha,
    this.monedaId = 1,
  });

  ViajeState copyWith({
    ViajeStatus? status,
    String? errorMessage,
    String? successMessage,
    List<ColaboradorSucursal>? colaboradores,
    List<ColaboradorSucursal>? selectedColaboradores,
    List<Transportista>? transportistas,
    List<Transportista>? selectedTransportistas,
    List<Sucursal>? sucursales,
    int? currentTab,
    List<ViajesdetallesCreateClusteredDto>? clusteredEmployees,
    int? sucursalId,
    String? viajeHora,
    DateTime? viajeFecha,
    int? monedaId,
  }) {
    return ViajeState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      colaboradores: colaboradores ?? this.colaboradores,
      selectedColaboradores: selectedColaboradores ?? this.selectedColaboradores,
      transportistas: transportistas ?? this.transportistas,
      selectedTransportistas: selectedTransportistas ?? this.selectedTransportistas,
      sucursales: sucursales ?? this.sucursales,
      currentTab: currentTab ?? this.currentTab,
      clusteredEmployees: clusteredEmployees ?? this.clusteredEmployees,
      sucursalId: sucursalId ?? this.sucursalId,
      viajeHora: viajeHora ?? this.viajeHora,
      viajeFecha: viajeFecha ?? this.viajeFecha,
      monedaId: monedaId ?? this.monedaId,
    );
  }

  bool get isFormValid => 
    sucursalId != null && 
    viajeHora != null && 
    viajeFecha != null;

  @override
  List<Object?> get props => [
    status, 
    errorMessage, 
    successMessage,
    colaboradores, 
    selectedColaboradores, 
    transportistas, 
    selectedTransportistas, 
    sucursales, 
    currentTab, 
    clusteredEmployees,
    sucursalId,
    viajeHora,
    viajeFecha,
    monedaId,
  ];
}

