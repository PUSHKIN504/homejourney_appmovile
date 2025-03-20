import 'package:equatable/equatable.dart';
import '../../models/sucursal_model.dart';

abstract class SucursalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SucursalInitial extends SucursalState {}

class SucursalLoading extends SucursalState {}

class SucursalLoaded extends SucursalState {
  final List<Sucursal> sucursales;

  SucursalLoaded(this.sucursales);

  @override
  List<Object?> get props => [sucursales];
}

class SucursalError extends SucursalState {
  final String message;

  SucursalError(this.message);

  @override
  List<Object?> get props => [message];
}

