import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/models/colaborador_sucursal_model.dart';
import 'package:homejourney_appmovile/models/transportista_model.dart';
import 'package:homejourney_appmovile/models/viaje_model.dart';
import 'package:intl/intl.dart';
import '../utils/alert_helper.dart';
import '../widgets/selectable_data_table.dart';
import 'bloc/viaje_bloc.dart';
import 'bloc/viaje_event.dart';
import 'bloc/viaje_state.dart';

class ViajesScreen extends StatefulWidget {
  const ViajesScreen({Key? key}) : super(key: key);

  @override
  State<ViajesScreen> createState() => _ViajesScreenState();
}

class _ViajesScreenState extends State<ViajesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    context.read<ViajeBloc>().add(LoadColaboradoresEvent());
    context.read<ViajeBloc>().add(LoadTransportistasEvent());
    context.read<ViajeBloc>().add(LoadSucursalesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViajeBloc, ViajeState>(
      listener: (context, state) {
        if (state.status == ViajeStatus.error && state.errorMessage != null) {
          AlertHelper.showAlert(
            context: context,
            title: 'Error',
            message: state.errorMessage!,
            isSuccess: false,
          );
        }
        
       if (state.status == ViajeStatus.success && state.successMessage != null) {
          AlertHelper.showAlert(
            context: context,
            title: 'Éxito',
            message: state.successMessage!,
            isSuccess: true,
          );
          context.read<ViajeBloc>().add(ResetViajeStateEvent());
        }
        
        if (state.currentTab != _tabController.index) {
          _tabController.animateTo(state.currentTab);
        }
        
        if (state.status == ViajeStatus.loaded && 
            state.clusteredEmployees.isNotEmpty && 
            state.currentTab == 1) {
          AlertHelper.showAlert(
            context: context,
            title: 'Información',
            message: 'Solo se pueden seleccionar ${state.clusteredEmployees.length} transportista(s)',
            isSuccess: true,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestión de Viajes'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'Seleccionar Colaboradores'),
                    Tab(text: 'Transportistas y Viaje'),
                  ],
                  onTap: (index) {
                    if (index != state.currentTab) {
                      _tabController.animateTo(state.currentTab);
                    }
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildColaboradoresTab(state),
                      _buildTransportistasViajeTab(state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColaboradoresTab(ViajeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Seleccione los colaboradores para el viaje',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: state.status == ViajeStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : SelectableDataTable<ColaboradorSucursal>(
                  data: state.colaboradores,
                  columns: const [
                    {'field': 'colaboradorSucursalId', 'label': 'ID', 'width': 50},
                    {'field': 'nombreColaborador', 'label': 'Nombre'},
                    {'field': 'distanciakilometro', 'label': 'Distancia (Km)'},
                  ],
                  selectedItems: state.selectedColaboradores,
                  onSelectionChanged: (selectedItems) {
                    print( selectedItems);
                    context.read<ViajeBloc>().add(
                          SelectColaboradoresEvent(selectedItems),
                        );
                  },
                  getValue: (item, field) {
                    switch (field) {
                      case 'colaboradorSucursalId':
                        return item.colaboradorSucursalId?.toString() ?? '';
                      case 'nombreColaborador':
                        return item.nombreColaborador ?? '';
                      case 'distanciakilometro':
                        return item.distanciakilometro?.toString() ?? '';
                      default:
                        return '';
                    }
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: state.status == ViajeStatus.loading
                    ? null
                    : () {
                        if (state.selectedColaboradores.isNotEmpty) {
                          context.read<ViajeBloc>().add(
                                ClusterEmployeesEvent(state.selectedColaboradores, 50.0),
                              );
                        } else {
                          AlertHelper.showAlert(
                            context: context,
                            title: 'Error',
                            message: 'Debe seleccionar al menos un colaborador',
                            isSuccess: false,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: state.status == ViajeStatus.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransportistasViajeTab(ViajeState state) {
    final timeOptions = _generateTimeOptions();
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Selección de Transportistas', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SelectableDataTable<Transportista>(
                  data: state.transportistas,
                  columns: const [
                    {'field': 'transportistaId', 'label': 'ID', 'width': 50},
                    {'field': 'nombre', 'label': 'Nombre'},
                    {'field': 'tarifaporkilometro', 'label': 'Tarifa Por Kilometro (LPS)'},
                  ],
                  selectedItems: state.selectedTransportistas,
                  onSelectionChanged: (selectedItems) {
                    context.read<ViajeBloc>().add(
                          SelectTransportistasEvent(selectedItems),
                        );
                  },
                  getValue: (item, field) {
                    switch (field) {
                      case 'transportistaId':
                        return item.transportistaId?.toString() ?? '';
                      case 'nombre':
                        return item.nombre ?? '';
                      case 'tarifaporkilometro':
                        return item.tarifaporkilometro?.toString() ?? '';
                      default:
                        return '';
                    }
                  },
                  maxSelections: state.clusteredEmployees.length,
                ),
                
                const SizedBox(height: 24),
                const Text('Información del Viaje', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Sucursal',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          value: state.sucursalId,
                          items: state.sucursales.map((sucursal) {
                            return DropdownMenuItem<int>(
                              value: sucursal.sucursalId,
                              child: Text(sucursal.nombre ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ViajeBloc>().add(
                                    UpdateFormFieldEvent('sucursalId', value),
                                  );
                            }
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Hora de Viaje',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                          value: state.viajeHora,
                          items: timeOptions.map((time) {
                            return DropdownMenuItem<String>(
                              value: time,
                              child: Text(time),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ViajeBloc>().add(
                                    UpdateFormFieldEvent('viajeHora', value),
                                  );
                            }
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: state.viajeFecha ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              context.read<ViajeBloc>().add(
                                    UpdateFormFieldEvent('viajeFecha', picked),
                                  );
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Fecha de Viaje',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                            ),
                            child: Text(
                              state.viajeFecha != null
                                  ? DateFormat('dd/MM/yyyy').format(state.viajeFecha!)
                                  : 'Seleccione fecha',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: state.status == ViajeStatus.loading
                    ? null
                    : () {
                        context.read<ViajeBloc>().add(NavigateToPreviousTabEvent());
                      },
                child: const Text('Atrás'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: state.status == ViajeStatus.loading
                    ? null
                    : () {
                        if (!state.isFormValid) {
                          AlertHelper.showAlert(
                            context: context,
                            title: 'Error',
                            message: 'Complete los campos requeridos',
                            isSuccess: false,
                          );
                          return;
                        }

                        if (state.selectedTransportistas.isEmpty) {
                          AlertHelper.showAlert(
                            context: context,
                            title: 'Error',
                            message: 'Debe seleccionar al menos un transportista',
                            isSuccess: false,
                          );
                          return;
                        }

                        final viajeDto = ViajesCreateClusteredDto(
                          sucursalId: state.sucursalId!,
                          transportistaIds: state.selectedTransportistas
                              .map((t) => t.transportistaId!)
                              .toList(),
                          estadoId: 4, 
                          viajeHora: state.viajeHora!,
                          viajeFecha: state.viajeFecha!,
                          usuarioCrea: 1, 
                          monedaId: state.monedaId,
                        );

                        final empleadosDto = state.clusteredEmployees;

                        context.read<ViajeBloc>().add(
                          CreateViajeEvent(viajeDto, empleadosDto),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: state.status == ViajeStatus.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Crear Viaje'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _generateTimeOptions() {
    final List<String> times = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        final String hourStr = hour.toString().padLeft(2, '0');
        final String minuteStr = minute.toString().padLeft(2, '0');
        times.add('$hourStr:$minuteStr:00');
      }
    }
    return times;
  }
}

