import 'package:equatable/equatable.dart';
import 'package:homejourney_appmovile/models/colaborador_sucursal_model.dart';
import 'package:homejourney_appmovile/models/transportista_model.dart';
import 'package:homejourney_appmovile/models/viaje_model.dart';

abstract class ViajeEvent extends Equatable {
  const ViajeEvent();

  @override
  List<Object?> get props => [];
}

class LoadColaboradoresEvent extends ViajeEvent {}

class LoadTransportistasEvent extends ViajeEvent {}

class LoadSucursalesEvent extends ViajeEvent {}

class SelectColaboradoresEvent extends ViajeEvent {
  final List<ColaboradorSucursal> selectedColaboradores;

  const SelectColaboradoresEvent(this.selectedColaboradores);

  @override
  List<Object?> get props => [selectedColaboradores];
}

class SelectTransportistasEvent extends ViajeEvent {
  final List<Transportista> selectedTransportistas;

  const SelectTransportistasEvent(this.selectedTransportistas);

  @override
  List<Object?> get props => [selectedTransportistas];
}

class NavigateToNextTabEvent extends ViajeEvent {}

class NavigateToPreviousTabEvent extends ViajeEvent {}

class ClusterEmployeesEvent extends ViajeEvent {
  final List<ColaboradorSucursal> colaboradores;
  final double distanceThreshold;

  const ClusterEmployeesEvent(this.colaboradores, this.distanceThreshold);

  @override
  List<Object?> get props => [colaboradores, distanceThreshold];
}

class CreateViajeEvent extends ViajeEvent {
  final ViajesCreateClusteredDto viajeDto;
  final List<ViajesdetallesCreateClusteredDto> empleadosClusteredDto;

  const CreateViajeEvent(this.viajeDto, this.empleadosClusteredDto);

  @override
  List<Object?> get props => [viajeDto, empleadosClusteredDto];
}

class UpdateFormFieldEvent extends ViajeEvent {
  final String field;
  final dynamic value;

  const UpdateFormFieldEvent(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

class ResetViajeStateEvent extends ViajeEvent {}

