import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/colaborador_service.dart';
import 'colaborador_event.dart';
import 'colaborador_state.dart';

class ColaboradorBloc extends Bloc<ColaboradorEvent, ColaboradorState> {
  final ColaboradorService _colaboradorService;

  ColaboradorBloc({required ColaboradorService colaboradorService})
      : _colaboradorService = colaboradorService,
        super(ColaboradorInitial()) {
    on<LoadColaboradores>(_onLoadColaboradores);
    on<AddColaborador>(_onAddColaborador);
    on<UpdateColaborador>(_onUpdateColaborador);
    on<DeleteColaborador>(_onDeleteColaborador);
    on<LoadDropdownData>(_onLoadDropdownData);
  }

  Future<void> _onLoadColaboradores(
      LoadColaboradores event, Emitter<ColaboradorState> emit) async {
    emit(ColaboradorLoading());
    try {
      final colaboradores = await _colaboradorService.getAll();
      emit(ColaboradoresLoaded(colaboradores));
    } catch (e) {
      print('Error en _onLoadColaboradores: ${e.toString()}');
      emit(ColaboradorError('Error al cargar colaboradores: ${e.toString()}'));
    }
  }

  Future<void> _onAddColaborador(
      AddColaborador event, Emitter<ColaboradorState> emit) async {
    // Guardamos el estado actual para restaurarlo en caso de error
    final currentState = state;
    
    emit(ColaboradorLoading());
    try {
      final colaborador = await _colaboradorService.create(event.colaborador);
      emit(ColaboradorAdded(colaborador));
      // Recargamos la lista después de agregar
      add(LoadColaboradores());
    } catch (e) {
      print('Error en _onAddColaborador: ${e.toString()}');
      // Si hay un error, mostramos el mensaje pero restauramos el estado anterior
      if (currentState is ColaboradoresLoaded) {
        emit(ColaboradorError('Error al agregar colaborador: ${e.toString()}'));
        emit(currentState);
      } else {
        emit(ColaboradorError('Error al agregar colaborador: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateColaborador(
      UpdateColaborador event, Emitter<ColaboradorState> emit) async {
    // Guardamos el estado actual para restaurarlo en caso de error
    final currentState = state;
    
    emit(ColaboradorLoading());
    try {
      final colaborador =
          await _colaboradorService.update(event.id, event.colaborador);
      emit(ColaboradorUpdated(colaborador));
      // Recargamos la lista después de actualizar
      add(LoadColaboradores());
    } catch (e) {
      print('Error en _onUpdateColaborador: ${e.toString()}');
      // Si hay un error, mostramos el mensaje pero restauramos el estado anterior
      if (currentState is ColaboradoresLoaded) {
        emit(ColaboradorError('Error al actualizar colaborador: ${e.toString()}'));
        emit(currentState);
      } else {
        emit(ColaboradorError('Error al actualizar colaborador: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDeleteColaborador(
      DeleteColaborador event, Emitter<ColaboradorState> emit) async {
    // Guardamos el estado actual para restaurarlo en caso de error
    final currentState = state;
    
    emit(ColaboradorLoading());
    try {
      final success = await _colaboradorService.delete(event.id);
      if (success) {
        emit(ColaboradorDeleted(event.id));
        // Recargamos la lista después de eliminar
        add(LoadColaboradores());
      } else {
        // Si no se pudo eliminar, restauramos el estado anterior
        if (currentState is ColaboradoresLoaded) {
          emit(ColaboradorError('No se pudo eliminar el colaborador'));
          emit(currentState);
        } else {
          emit(ColaboradorError('No se pudo eliminar el colaborador'));
        }
      }
    } catch (e) {
      print('Error en _onDeleteColaborador: ${e.toString()}');
      // Si hay un error, mostramos el mensaje pero restauramos el estado anterior
      if (currentState is ColaboradoresLoaded) {
        emit(ColaboradorError('Error al eliminar colaborador: ${e.toString()}'));
        emit(currentState);
      } else {
        emit(ColaboradorError('Error al eliminar colaborador: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadDropdownData(
      LoadDropdownData event, Emitter<ColaboradorState> emit) async {
    // No cambiamos el estado a loading para no interferir con la carga de colaboradores
    try {
      final ciudades = await _colaboradorService.getCiudades();
      final roles = await _colaboradorService.getRoles();
      final cargos = await _colaboradorService.getCargos();
      final estadosCiviles = await _colaboradorService.getEstadosCiviles();

      emit(DropdownDataLoaded(
        ciudades: ciudades,
        roles: roles,
        cargos: cargos,
        estadosCiviles: estadosCiviles,
      ));
    } catch (e) {
      print('Error en _onLoadDropdownData: ${e.toString()}');
      // No emitimos un estado de error para no interferir con la carga de colaboradores
    }
  }
}

