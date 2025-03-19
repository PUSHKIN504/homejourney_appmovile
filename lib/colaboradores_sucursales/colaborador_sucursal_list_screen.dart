import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/alert_helper.dart';
import 'bloc/colaborador_sucursal_bloc.dart';
import 'bloc/colaborador_sucursal_event.dart';
import 'bloc/colaborador_sucursal_state.dart';
import 'colaborador_sucursal_form_screen.dart';

class ColaboradorSucursalListScreen extends StatefulWidget {
  const ColaboradorSucursalListScreen({super.key});

  @override
  State<ColaboradorSucursalListScreen> createState() => _ColaboradorSucursalListScreenState();
}

class _ColaboradorSucursalListScreenState extends State<ColaboradorSucursalListScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() {
    context.read<ColaboradorSucursalBloc>().add(LoadColaboradoresSucursales());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignación de Sucursales'),
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
                    builder: (context) => const ColaboradorSucursalFormScreen(),
                  ),
                ).then((_) {
                  _loadData();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Nueva Asignación'),
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
            BlocListener<ColaboradorSucursalBloc, ColaboradorSucursalState>(
              listener: (context, state) {
                if (state is ColaboradorSucursalAdded) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorSucursalUpdated) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorSucursalStatusChanged) {
                  AlertHelper.showAlert(
                    context: context,
                    title: state.success ? 'Éxito' : 'Error',
                    message: state.message,
                    isSuccess: state.success,
                  );
                } else if (state is ColaboradorSucursalError) {
                  AlertHelper.showAlert(
                    context: context,
                    title: 'Error',
                    message: state.message,
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
                      const Text(
                        'Asignaciones de Colaboradores a Sucursales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<ColaboradorSucursalBloc, ColaboradorSucursalState>(
                          builder: (context, state) {
                            if (state is ColaboradorSucursalLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ColaboradorSucursalLoaded) {
                              final colaboradoresSucursales = state.colaboradoresSucursales;
                              
                              if (colaboradoresSucursales.isEmpty) {
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
                                        'No hay asignaciones registradas',
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
                              
                              return ListView.builder(
                                itemCount: colaboradoresSucursales.length,
                                itemBuilder: (context, index) {
                                  final asignacion = colaboradoresSucursales[index];
                                  
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(
                                        asignacion.nombreColaborador,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Sucursal: ${asignacion.nombreSucursal}'),
                                          Text('Distancia: ${asignacion.distanciaKilometro.toStringAsFixed(2)} km'),
                                          Row(
                                            children: [
                                              Icon(
                                                asignacion.activo ? Icons.check_circle : Icons.cancel,
                                                color: asignacion.activo ? Colors.green : Colors.red,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                asignacion.activo ? 'Activo' : 'Inactivo',
                                                style: TextStyle(
                                                  color: asignacion.activo ? Colors.green : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                         
                                          IconButton(
                                            icon: Icon(
                                              asignacion.activo ? Icons.toggle_on : Icons.toggle_off,
                                              color: asignacion.activo ? Colors.green : Colors.grey,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text(asignacion.activo ? 'Desactivar asignación' : 'Activar asignación'),
                                                  content: Text(
                                                    asignacion.activo
                                                        ? '¿Está seguro que desea desactivar esta asignación?'
                                                        : '¿Está seguro que desea activar esta asignación?'
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        context.read<ColaboradorSucursalBloc>().add(
                                                          SetActiveColaboradorSucursal(
                                                            id: asignacion.colaboradorSucursalId,
                                                            active: !asignacion.activo,
                                                          ),
                                                        );
                                                      },
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: asignacion.activo ? Colors.red : Colors.green,
                                                      ),
                                                      child: Text(asignacion.activo ? 'Desactivar' : 'Activar'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (state is ColaboradorSucursalError) {
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
                                      state.message,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ColaboradorSucursalFormScreen(),
            ),
          ).then((_) {
            _loadData();
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

