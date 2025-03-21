import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/colaborador_sucursal_model.dart';
import '../../services/colaborador_sucursal_service.dart';
import 'colaborador_sucursal_event.dart';
import 'colaborador_sucursal_state.dart';

class ColaboradorSucursalBloc extends Bloc<ColaboradorSucursalEvent, ColaboradorSucursalState> {
  final ColaboradorSucursalService _colaboradorSucursalService;

  ColaboradorSucursalBloc({required ColaboradorSucursalService colaboradorSucursalService})
      : _colaboradorSucursalService = colaboradorSucursalService,
        super(ColaboradorSucursalInitial()) {
    on<LoadColaboradoresSucursales>(_onLoadColaboradoresSucursales);
    on<AddColaboradorSucursal>(_onAddColaboradorSucursal);
    on<UpdateColaboradorSucursal>(_onUpdateColaboradorSucursal);
    on<SetActiveColaboradorSucursal>(_onSetActiveColaboradorSucursal);
  }

  Future<void> _onLoadColaboradoresSucursales(
      LoadColaboradoresSucursales event, Emitter<ColaboradorSucursalState> emit) async {
    emit(ColaboradorSucursalLoading());
    try {
      final colaboradoresSucursales = await _colaboradorSucursalService.getAll();
      emit(ColaboradorSucursalLoaded(colaboradoresSucursales));
    } catch (e) {
      emit(ColaboradorSucursalError('Error al cargar asignaciones: ${e.toString()}'));
    }
  }

  Future<void> _onAddColaboradorSucursal(
      AddColaboradorSucursal event, Emitter<ColaboradorSucursalState> emit) async {
    emit(ColaboradorSucursalLoading());
    try {
      final dto = ColaboradorSucursalRequest(
        colaboradorId: event.colaboradorId,
        sucursalId: event.sucursalId,
        distanciaKilometro: event.distanciaKilometro,
        usuarioCrea: event.usuarioCrea,
      );

      final result = await _colaboradorSucursalService.create(dto);
      
      emit(ColaboradorSucursalAdded(
        colaboradorSucursal: result['colaboradorSucursal'],
        message: result['message'],
        success: result['success'],
      ));
      
      if (result['success']) {
        add(LoadColaboradoresSucursales());
      }
    } catch (e) {
      emit(ColaboradorSucursalError('Error al agregar asignación: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateColaboradorSucursal(
      UpdateColaboradorSucursal event, Emitter<ColaboradorSucursalState> emit) async {
    emit(ColaboradorSucursalLoading());
    try {
      final dto = ColaboradorSucursalRequest(
        colaboradorSucursalId: event.id,
        colaboradorId: event.colaboradorId,
        sucursalId: event.sucursalId,
        distanciaKilometro: event.distanciaKilometro,
        usuarioCrea: 1, 
        usuarioModifica: event.usuarioModifica,
        fechaModifica: DateTime.now(),
      );

      final result = await _colaboradorSucursalService.update(event.id, dto);
      
      emit(ColaboradorSucursalUpdated(
        colaboradorSucursal: result['colaboradorSucursal'],
        message: result['message'],
        success: result['success'],
      ));
      
      if (result['success']) {
        add(LoadColaboradoresSucursales());
      }
    } catch (e) {
      emit(ColaboradorSucursalError('Error al actualizar asignación: ${e.toString()}'));
    }
  }

  Future<void> _onSetActiveColaboradorSucursal(
      SetActiveColaboradorSucursal event, Emitter<ColaboradorSucursalState> emit) async {
    emit(ColaboradorSucursalLoading());
    try {
      final result = await _colaboradorSucursalService.setActive(event.id, event.active);
      
      emit(ColaboradorSucursalStatusChanged(
        colaboradorSucursal: result['colaboradorSucursal'],
        message: result['message'],
        success: result['success'],
      ));
      
      if (result['success']) {
        add(LoadColaboradoresSucursales());
      }
    } catch (e) {
      emit(ColaboradorSucursalError('Error al cambiar estado: ${e.toString()}'));
    }
  }
}

