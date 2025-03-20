import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/models/viaje_model.dart';
import '../../services/viaje_service.dart';
import '../../services/colaborador_sucursal_service.dart';
import '../../services/transportista_service.dart';
import '../../services/sucursal_service.dart';
import 'viaje_event.dart';
import 'viaje_state.dart';
import '../../login/bloc/login_bloc.dart';
import '../../login/bloc/login_state.dart';

class ViajeBloc extends Bloc<ViajeEvent, ViajeState> {
  final ViajeService _viajeService;
  final ColaboradorSucursalService _colaboradorSucursalService;
  final TransportistaService _transportistaService;
  final SucursalService _sucursalService;
  final LoginBloc _loginBloc;

  ViajeBloc({
    required ViajeService viajeService,
    required ColaboradorSucursalService colaboradorSucursalService,
    required TransportistaService transportistaService,
    required SucursalService sucursalService,
    required LoginBloc loginBloc,
  }) : 
    _viajeService = viajeService,
    _colaboradorSucursalService = colaboradorSucursalService,
    _transportistaService = transportistaService,
    _sucursalService = sucursalService,
    _loginBloc = loginBloc,
    super(const ViajeState()) {
    on<LoadColaboradoresEvent>(_onLoadColaboradores);
    on<LoadTransportistasEvent>(_onLoadTransportistas);
    on<LoadSucursalesEvent>(_onLoadSucursales);
    on<SelectColaboradoresEvent>(_onSelectColaboradores);
    on<SelectTransportistasEvent>(_onSelectTransportistas);
    on<NavigateToNextTabEvent>(_onNavigateToNextTab);
    on<NavigateToPreviousTabEvent>(_onNavigateToPreviousTab);
    on<ClusterEmployeesEvent>(_onClusterEmployees);
    on<CreateViajeEvent>(_onCreateViaje);
    on<UpdateFormFieldEvent>(_onUpdateFormField);
    on<ResetViajeStateEvent>(_onResetState);
  }


  Future<void> _onLoadColaboradores(
    LoadColaboradoresEvent event, 
    Emitter<ViajeState> emit
  ) async {
    emit(state.copyWith(status: ViajeStatus.loading));
    try {
      final colaboradores = await _colaboradorSucursalService.getAll();
      emit(state.copyWith(
        status: ViajeStatus.loaded,
        colaboradores: colaboradores,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Error al cargar colaboradores: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadTransportistas(
    LoadTransportistasEvent event, 
    Emitter<ViajeState> emit
  ) async {
    emit(state.copyWith(status: ViajeStatus.loading));
    try {
      final transportistas = await _transportistaService.getTransportistas();
      emit(state.copyWith(
        status: ViajeStatus.loaded,
        transportistas: transportistas,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Error al cargar transportistas: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadSucursales(
    LoadSucursalesEvent event, 
    Emitter<ViajeState> emit
  ) async {
    emit(state.copyWith(status: ViajeStatus.loading));
    try {
      final sucursales = await _sucursalService.getAll();
      emit(state.copyWith(
        status: ViajeStatus.loaded,
        sucursales: sucursales,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Error al cargar sucursales: ${e.toString()}',
      ));
    }
  }

  void _onSelectColaboradores(
    SelectColaboradoresEvent event, 
    Emitter<ViajeState> emit
  ) {
    emit(state.copyWith(
      selectedColaboradores: event.selectedColaboradores,
    ));
  }

  void _onSelectTransportistas(
    SelectTransportistasEvent event, 
    Emitter<ViajeState> emit
  ) {
    // Validar que el número de transportistas no exceda el número de clusters
    if (event.selectedTransportistas.length > state.clusteredEmployees.length) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Solo se pueden seleccionar ${state.clusteredEmployees.length} transportistas',
      ));
      return;
    }
    
    emit(state.copyWith(
      selectedTransportistas: event.selectedTransportistas,
      status: ViajeStatus.loaded,
      errorMessage: null,
    ));
  }

  void _onNavigateToNextTab(
    NavigateToNextTabEvent event, 
    Emitter<ViajeState> emit
  ) {
    emit(state.copyWith(
      currentTab: state.currentTab + 1,
    ));
  }

  void _onNavigateToPreviousTab(
    NavigateToPreviousTabEvent event, 
    Emitter<ViajeState> emit
  ) {
    if (state.currentTab > 0) {
      emit(state.copyWith(
        currentTab: state.currentTab - 1,
      ));
    }
  }

  Future<void> _onClusterEmployees(
    ClusterEmployeesEvent event, 
    Emitter<ViajeState> emit
  ) async {
    if (event.colaboradores.isEmpty) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Debe seleccionar al menos un colaborador',
      ));
      return;
    }

    emit(state.copyWith(status: ViajeStatus.loading));
    try {
      final userId = 1;
      final clusteredEmployees = await _viajeService.clusterEmployees(
        userId,
        event.colaboradores,
        event.distanceThreshold,
      );
      
      emit(state.copyWith(
        status: ViajeStatus.loaded,
        clusteredEmployees: clusteredEmployees,
        currentTab: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Error al agrupar colaboradores: ${e.toString()}',
      ));
    }
  }

  Future<void> _onCreateViaje(
    CreateViajeEvent event, 
    Emitter<ViajeState> emit
  ) async {
    if (state.selectedTransportistas.isEmpty) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Debe seleccionar al menos un transportista',
      ));
      return;
    }

    if (!state.isFormValid) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Complete los campos requeridos para el viaje',
      ));
      return;
    }

    emit(state.copyWith(status: ViajeStatus.loading));
    try {
      final userId = 1;
      final request = CreateViajesRequest(
        viajeclusteredDto: event.viajeDto,
        empleadosclusteredDto: [event.empleadosClusteredDto],
      );
      
      await _viajeService.createTripsFromClusters(userId, request);
      
      emit(state.copyWith(
        status: ViajeStatus.success,
        successMessage: 'Viaje(s) creado(s) correctamente',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ViajeStatus.error,
        errorMessage: 'Error al crear viajes: ${e.toString()}',
      ));
    }
  }

  void _onUpdateFormField(
    UpdateFormFieldEvent event, 
    Emitter<ViajeState> emit
  ) {
    switch (event.field) {
      case 'sucursalId':
        emit(state.copyWith(sucursalId: event.value));
        break;
      case 'viajeHora':
        emit(state.copyWith(viajeHora: event.value));
        break;
      case 'viajeFecha':
        emit(state.copyWith(viajeFecha: event.value));
        break;
      case 'monedaId':
        emit(state.copyWith(monedaId: event.value));
        break;
    }
  }

  void _onResetState(
    ResetViajeStateEvent event, 
    Emitter<ViajeState> emit
  ) {
    emit(const ViajeState());
  }
}

