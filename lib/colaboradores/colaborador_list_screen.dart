import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/alert_helper.dart';
import 'bloc/colaborador_bloc.dart';
import 'bloc/colaborador_event.dart';
import 'bloc/colaborador_state.dart';
import 'colaborador_form_screen.dart';
import '../models/dropdown_models.dart';

class ColaboradorListScreen extends StatefulWidget {
  const ColaboradorListScreen({super.key});

  @override
  State<ColaboradorListScreen> createState() => _ColaboradorListScreenState();
}

class _ColaboradorListScreenState extends State<ColaboradorListScreen> {
  // Mapas para mostrar nombres en lugar de IDs
  Map<int, String> rolesMap = {};
  Map<int, String> cargosMap = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    
    // Primero cargamos los datos de los dropdowns
    context.read<ColaboradorBloc>().add(LoadDropdownData());
    
    // Luego cargamos los colaboradores
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
            MultiBlocListener(
              listeners: [
                BlocListener<ColaboradorBloc, ColaboradorState>(
                  listener: (context, state) {
                    if (state is DropdownDataLoaded) {
                      // Crear mapas para mostrar nombres en lugar de IDs
                      for (var rol in state.roles) {
                        rolesMap[rol.rolId] = rol.nombre;
                      }
                      for (var cargo in state.cargos) {
                        cargosMap[cargo.cargoId] = cargo.nombre;
                      }
                    }
                  },
                ),
                BlocListener<ColaboradorBloc, ColaboradorState>(
                  listener: (context, state) {
                    if (state is ColaboradorLoading) {
                      setState(() {
                        _isLoading = true;
                      });
                    } else {
                      setState(() {
                        _isLoading = false;
                      });
                      
                      if (state is ColaboradorError) {
                        AlertHelper.showAlert(
                          context: context,
                          title: 'Error',
                          message: state.message,
                          isSuccess: false,
                        );
                      } else if (state is ColaboradorAdded) {
                        AlertHelper.showAlert(
                          context: context,
                          title: 'Éxito',
                          message: 'Colaborador agregado correctamente',
                          isSuccess: true,
                        );
                      } else if (state is ColaboradorUpdated) {
                        AlertHelper.showAlert(
                          context: context,
                          title: 'Éxito',
                          message: 'Colaborador actualizado correctamente',
                          isSuccess: true,
                        );
                      } else if (state is ColaboradorDeleted) {
                        AlertHelper.showAlert(
                          context: context,
                          title: 'Éxito',
                          message: 'Colaborador eliminado correctamente',
                          isSuccess: true,
                        );
                      }
                    }
                  },
                ),
              ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Listado de Colaboradores',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<ColaboradorBloc, ColaboradorState>(
                          builder: (context, state) {
                            if (state is ColaboradorLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ColaboradoresLoaded) {
                              return state.colaboradores.isEmpty
                                  ? const Center(
                                      child: Text('No hay colaboradores registrados'),
                                    )
                                  : ListView.builder(
                                      itemCount: state.colaboradores.length,
                                      itemBuilder: (context, index) {
                                        final colaborador = state.colaboradores[index];
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
                                                Text('Rol: ${rolesMap[colaborador.rolId] ?? colaborador.rolId}'),
                                                Text('Cargo: ${cargosMap[colaborador.cargoId] ?? colaborador.cargoId}'),
                                                Text('Dirección: ${colaborador.direccion ?? ''}'),
                                              ],
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    // Navigate to edit screen
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ColaboradorFormScreen(
                                                          colaboradorId: colaborador.colaboradorId,
                                                        ),
                                                      ),
                                                    ).then((_) {
                                                      // Recargar datos cuando regrese
                                                      _loadData();
                                                    });
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    // Show confirmation dialog
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: const Text('Confirmar eliminación'),
                                                        content: const Text('¿Está seguro que desea eliminar este colaborador?'),
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
                                                              if (colaborador.colaboradorId != null) {
                                                                context.read<ColaboradorBloc>().add(
                                                                  DeleteColaborador(colaborador.colaboradorId!),
                                                                );
                                                              }
                                                            },
                                                            style: TextButton.styleFrom(
                                                              foregroundColor: Colors.red,
                                                            ),
                                                            child: const Text('Eliminar'),
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
                            } else {
                              return const Center(
                                child: Text('Error al cargar colaboradores. Intente nuevamente.'),
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

