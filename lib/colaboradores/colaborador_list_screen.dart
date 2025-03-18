import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homejourney_appmovile/models/dropdown_models.dart';
import '../utils/alert_helper.dart';
import 'bloc/colaborador_bloc.dart';
import 'bloc/colaborador_event.dart';
import 'bloc/colaborador_state.dart';
import 'colaborador_form_screen.dart';

class ColaboradorListScreen extends StatefulWidget {
  const ColaboradorListScreen({super.key});

  @override
  State<ColaboradorListScreen> createState() => _ColaboradorListScreenState();
}

class _ColaboradorListScreenState extends State<ColaboradorListScreen> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    // Solo cargamos datos si es la primera vez
    if (_isFirstLoad) {
      _loadData();
      _isFirstLoad = false;
    }
  }
  
  void _loadData() {
    // Cargamos ambos datos
    context.read<ColaboradorBloc>().add(LoadDropdownData());
    context.read<ColaboradorBloc>().add(LoadColaboradores());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Colaboradores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Recargar datos',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ColaboradorFormScreen(),
                  ),
                ).then((_) {
                  // Recargar datos cuando regrese de la pantalla de formulario
                  _loadData();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Colaborador'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocListener<ColaboradorBloc, ColaboradorState>(
              listener: (context, state) {
                if (state is ColaboradorAdded) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorUpdated) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorDeleted) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorDataState && state.errorMessage != null) {
                  AlertHelper.showAlert(
                    context: context,
                    title: 'Error',
                    message: state.errorMessage!,
                    isSuccess: false,
                  );
                }
              },
              child: const SizedBox.shrink(),
            ),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ColaboradorBloc, ColaboradorState>(
                        builder: (context, state) {
                          bool isLoading = false;
                          if (state is ColaboradorLoading) {
                            isLoading = true;
                          } else if (state is ColaboradorDataState) {
                            isLoading = state.isLoading;
                          }
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Listado de Colaboradores',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isLoading)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<ColaboradorBloc, ColaboradorState>(
                          builder: (context, state) {
                            if (state is ColaboradorLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ColaboradorDataState) {
                              // Si está cargando y no tenemos datos, mostramos el indicador
                              if (state.isLoading && state.colaboradores == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              
                              // Si tenemos un error y no hay datos, mostramos el error
                              if (state.errorMessage != null && state.colaboradores == null) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        state.errorMessage!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _loadData,
                                        child: const Text('Intentar nuevamente'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              // Si no tenemos datos (pero no hay error ni está cargando), mostramos mensaje vacío
                              if (state.colaboradores == null || state.colaboradores!.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.amber,
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No hay colaboradores registrados',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: _loadData,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Recargar datos'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              // Si tenemos datos, los mostramos
                              return ListView.builder(
                                itemCount: state.colaboradores!.length,
                                itemBuilder: (context, index) {
                                  final colaborador = state.colaboradores![index];
                                  
                                  // Obtener nombres de rol y cargo si están disponibles
                                  String rolNombre = '${colaborador.rolId}';
                                  String cargoNombre = '${colaborador.cargoId}';
                                  
                                  if (state.roles != null) {
                                    final rol = state.roles!.firstWhere(
                                      (r) => r.rolId == colaborador.rolId,
                                      orElse: () => Rol(rolId: colaborador.rolId!, nombre: 'Desconocido'),
                                    );
                                    rolNombre = rol.nombre;
                                  }
                                  
                                  if (state.cargos != null) {
                                    final cargo = state.cargos!.firstWhere(
                                      (c) => c.cargoId == colaborador.cargoId,
                                      orElse: () => Cargo(cargoId: colaborador.cargoId!, nombre: 'Desconocido'),
                                    );
                                    cargoNombre = cargo.nombre;
                                  }
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(
                                        '${colaborador.nombre ?? ''} ${colaborador.apellido ?? ''}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Rol: $rolNombre'),
                                          Text('Cargo: $cargoNombre'),
                                          Text('Dirección: ${colaborador.direccion ?? ''}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Estado no reconocido. Intente nuevamente.'),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

