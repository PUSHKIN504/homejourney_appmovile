import 'package:equatable/equatable.dart';
import '../../models/colaborador_model.dart';
import '../../models/dropdown_models.dart';

abstract class ColaboradorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ColaboradorInitial extends ColaboradorState {}

class ColaboradorLoading extends ColaboradorState {}

class ColaboradoresLoaded extends ColaboradorState {
  final List<ColaboradorGetAllDto> colaboradores;

  ColaboradoresLoaded(this.colaboradores);

  @override
  List<Object?> get props => [colaboradores];
}

class ColaboradorError extends ColaboradorState {
  final String message;

  ColaboradorError(this.message);

  @override
  List<Object?> get props => [message];
}

class DropdownDataLoaded extends ColaboradorState {
  final List<Ciudad> ciudades;
  final List<Rol> roles;
  final List<Cargo> cargos;
  final List<EstadoCivil> estadosCiviles;

  DropdownDataLoaded({
    required this.ciudades,
    required this.roles,
    required this.cargos,
    required this.estadosCiviles,
  });

  @override
  List<Object?> get props => [ciudades, roles, cargos, estadosCiviles];
}

class ColaboradorAdded extends ColaboradorState {
  final Colaborador colaborador;

  ColaboradorAdded(this.colaborador);

  @override
  List<Object?> get props => [colaborador];
}

class ColaboradorUpdated extends ColaboradorState {
  final Colaborador colaborador;

  ColaboradorUpdated(this.colaborador);

  @override
  List<Object?> get props => [colaborador];
}

class ColaboradorDeleted extends ColaboradorState {
  final int id;

  ColaboradorDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

