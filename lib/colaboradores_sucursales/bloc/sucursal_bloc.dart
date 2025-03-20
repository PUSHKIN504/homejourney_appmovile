import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/sucursal_service.dart';
import 'sucursal_event.dart';
import 'sucursal_state.dart';

class SucursalBloc extends Bloc<SucursalEvent, SucursalState> {
  final SucursalService _sucursalService;

  SucursalBloc({required SucursalService sucursalService})
      : _sucursalService = sucursalService,
        super(SucursalInitial()) {
    on<LoadSucursales>(_onLoadSucursales);
  }

  Future<void> _onLoadSucursales(
      LoadSucursales event, Emitter<SucursalState> emit) async {
    emit(SucursalLoading());
    try {
      final sucursales = await _sucursalService.getAll();
      emit(SucursalLoaded(sucursales));
    } catch (e) {
      emit(SucursalError('Error al cargar sucursales: ${e.toString()}'));
    }
  }
}

