import 'package:equatable/equatable.dart';
import '../../models/colaborador_sucursal_model.dart';

abstract class ColaboradorSucursalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ColaboradorSucursalInitial extends ColaboradorSucursalState {}

class ColaboradorSucursalLoading extends ColaboradorSucursalState {}

class ColaboradorSucursalLoaded extends ColaboradorSucursalState {
  final List<ColaboradorSucursal> colaboradoresSucursales;

  ColaboradorSucursalLoaded(this.colaboradoresSucursales);

  @override
  List<Object?> get props => [colaboradoresSucursales];
}

class ColaboradorSucursalError extends ColaboradorSucursalState {
  final String message;

  ColaboradorSucursalError(this.message);

  @override
  List<Object?> get props => [message];
}

class ColaboradorSucursalAdded extends ColaboradorSucursalState {
  final ColaboradorSucursal? colaboradorSucursal;
  final String message;
  final bool success;

  ColaboradorSucursalAdded({
    this.colaboradorSucursal,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [colaboradorSucursal, message, success];
}

class ColaboradorSucursalUpdated extends ColaboradorSucursalState {
  final ColaboradorSucursal? colaboradorSucursal;
  final String message;
  final bool success;

  ColaboradorSucursalUpdated({
    this.colaboradorSucursal,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [colaboradorSucursal, message, success];
}

class ColaboradorSucursalStatusChanged extends ColaboradorSucursalState {
  final ColaboradorSucursal? colaboradorSucursal;
  final String message;
  final bool success;

  ColaboradorSucursalStatusChanged({
    this.colaboradorSucursal,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [colaboradorSucursal, message, success];
}

