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
    if (state is ColaboradorDataState) {
      final currentState = state as ColaboradorDataState;
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
      
      try {
        final colaboradores = await _colaboradorService.getAll();
        emit(currentState.copyWith(
          colaboradores: colaboradores,
          isLoading: false,
        ));
      } catch (e) {
        print('Error en _onLoadColaboradores: ${e.toString()}');
        emit(currentState.copyWith(
          isLoading: false,
          errorMessage: 'Error al cargar colaboradores: ${e.toString()}',
        ));
      }
    } else {
      emit(ColaboradorLoading());
      try {
        final colaboradores = await _colaboradorService.getAll();
        emit(ColaboradorDataState(
          colaboradores: colaboradores,
          isLoading: false,
        ));
      } catch (e) {
        print('Error en _onLoadColaboradores: ${e.toString()}');
        emit(ColaboradorDataState(
          isLoading: false,
          errorMessage: 'Error al cargar colaboradores: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onLoadDropdownData(
      LoadDropdownData event, Emitter<ColaboradorState> emit) async {
    if (state is ColaboradorDataState) {
      final currentState = state as ColaboradorDataState;
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
      
      try {
        final ciudades = await _colaboradorService.getCiudades();
        final roles = await _colaboradorService.getRoles();
        final cargos = await _colaboradorService.getCargos();
        final estadosCiviles = await _colaboradorService.getEstadosCiviles();

        emit(currentState.copyWith(
          ciudades: ciudades,
          roles: roles,
          cargos: cargos,
          estadosCiviles: estadosCiviles,
          isLoading: false,
        ));
      } catch (e) {
        print('Error en _onLoadDropdownData: ${e.toString()}');
        emit(currentState.copyWith(
          isLoading: false,
          errorMessage: 'Error al cargar datos de formulario: ${e.toString()}',
        ));
      }
    } else {
      emit(ColaboradorLoading());
      try {
        final ciudades = await _colaboradorService.getCiudades();
        final roles = await _colaboradorService.getRoles();
        final cargos = await _colaboradorService.getCargos();
        final estadosCiviles = await _colaboradorService.getEstadosCiviles();

        emit(ColaboradorDataState(
          ciudades: ciudades,
          roles: roles,
          cargos: cargos,
          estadosCiviles: estadosCiviles,
          isLoading: false,
        ));
      } catch (e) {
        print('Error en _onLoadDropdownData: ${e.toString()}');
        emit(ColaboradorDataState(
          isLoading: false,
          errorMessage: 'Error al cargar datos de formulario: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onAddColaborador(
      AddColaborador event, Emitter<ColaboradorState> emit) async {
    final currentState = state;
    
    if (currentState is ColaboradorDataState) {
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
      
      try {
        final result = await _colaboradorService.create(event.colaborador);
        print('Resultado de crear colaborador: $result');
        
        emit(ColaboradorAdded(
          colaborador: result['colaborador'],
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onAddColaborador: ${e.toString()}');
        emit(currentState.copyWith(
          isLoading: false,
          errorMessage: 'Error al agregar colaborador: ${e.toString()}',
        ));
      }
    } else {
      emit(ColaboradorLoading());
      try {
        final result = await _colaboradorService.create(event.colaborador);
        print('Resultado de crear colaborador: $result');
        
        emit(ColaboradorAdded(
          colaborador: result['colaborador'],
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onAddColaborador: ${e.toString()}');
        emit(ColaboradorDataState(
          isLoading: false,
          errorMessage: 'Error al agregar colaborador: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onUpdateColaborador(
      UpdateColaborador event, Emitter<ColaboradorState> emit) async {
    final currentState = state;
    
    if (currentState is ColaboradorDataState) {
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
      
      try {
        final result = await _colaboradorService.update(event.id, event.colaborador);
        
        emit(ColaboradorUpdated(
          colaborador: result['colaborador'],
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onUpdateColaborador: ${e.toString()}');
        emit(currentState.copyWith(
          isLoading: false,
          errorMessage: 'Error al actualizar colaborador: ${e.toString()}',
        ));
      }
    } else {
      emit(ColaboradorLoading());
      try {
        final result = await _colaboradorService.update(event.id, event.colaborador);
        
        emit(ColaboradorUpdated(
          colaborador: result['colaborador'],
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onUpdateColaborador: ${e.toString()}');
        emit(ColaboradorDataState(
          isLoading: false,
          errorMessage: 'Error al actualizar colaborador: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onDeleteColaborador(
      DeleteColaborador event, Emitter<ColaboradorState> emit) async {
    final currentState = state;
    
    if (currentState is ColaboradorDataState) {
      emit(currentState.copyWith(isLoading: true, errorMessage: null));
      
      try {
        final result = await _colaboradorService.delete(event.id);
        
        emit(ColaboradorDeleted(
          id: event.id,
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onDeleteColaborador: ${e.toString()}');
        emit(currentState.copyWith(
          isLoading: false,
          errorMessage: 'Error al eliminar colaborador: ${e.toString()}',
        ));
      }
    } else {
      emit(ColaboradorLoading());
      try {
        final result = await _colaboradorService.delete(event.id);
        
        emit(ColaboradorDeleted(
          id: event.id,
          message: result['message'],
          success: result['success'],
        ));
        
        if (result['success']) {
          add(LoadColaboradores());
        }
      } catch (e) {
        print('Error en _onDeleteColaborador: ${e.toString()}');
        emit(ColaboradorDataState(
          isLoading: false,
          errorMessage: 'Error al eliminar colaborador: ${e.toString()}',
        ));
      }
    }
  }
}

