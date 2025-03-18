import 'package:equatable/equatable.dart';
import '../../models/colaborador_model.dart';
import '../../models/dropdown_models.dart';

abstract class ColaboradorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ColaboradorInitial extends ColaboradorState {}

class ColaboradorLoading extends ColaboradorState {}

class ColaboradorDataState extends ColaboradorState {
  final List<ColaboradorGetAllDto>? colaboradores;
  final List<Ciudad>? ciudades;
  final List<Rol>? roles;
  final List<Cargo>? cargos;
  final List<EstadoCivil>? estadosCiviles;
  final bool isLoading;
  final String? errorMessage;

  ColaboradorDataState({
    this.colaboradores,
    this.ciudades,
    this.roles,
    this.cargos,
    this.estadosCiviles,
    this.isLoading = false,
    this.errorMessage,
  });

  ColaboradorDataState copyWith({
    List<ColaboradorGetAllDto>? colaboradores,
    List<Ciudad>? ciudades,
    List<Rol>? roles,
    List<Cargo>? cargos,
    List<EstadoCivil>? estadosCiviles,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ColaboradorDataState(
      colaboradores: colaboradores ?? this.colaboradores,
      ciudades: ciudades ?? this.ciudades,
      roles: roles ?? this.roles,
      cargos: cargos ?? this.cargos,
      estadosCiviles: estadosCiviles ?? this.estadosCiviles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        colaboradores,
        ciudades,
        roles,
        cargos,
        estadosCiviles,
        isLoading,
        errorMessage,
      ];
}

class ColaboradorAdded extends ColaboradorState {
  final Colaborador? colaborador;
  final String message;
  final bool success;

  ColaboradorAdded({
    this.colaborador,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [colaborador, message, success];
}

class ColaboradorUpdated extends ColaboradorState {
  final Colaborador? colaborador;
  final String message;
  final bool success;

  ColaboradorUpdated({
    this.colaborador,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [colaborador, message, success];
}

class ColaboradorDeleted extends ColaboradorState {
  final int id;
  final String message;
  final bool success;

  ColaboradorDeleted({
    required this.id,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [id, message, success];
}

