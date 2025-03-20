import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/colaborador_model.dart';
import '../models/sucursal_model.dart';
import '../utils/alert_helper.dart';
import '../widgets/form_fields.dart';
import 'bloc/colaborador_sucursal_bloc.dart';
import 'bloc/colaborador_sucursal_event.dart';
import 'bloc/colaborador_sucursal_state.dart';
import '../colaboradores/bloc/colaborador_bloc.dart';
import '../colaboradores/bloc/colaborador_event.dart';
import '../colaboradores/bloc/colaborador_state.dart';
import 'bloc/sucursal_bloc.dart';
import 'bloc/sucursal_event.dart';
import 'bloc/sucursal_state.dart';

class ColaboradorSucursalFormScreen extends StatefulWidget {
  final int? asignacionId;

  const ColaboradorSucursalFormScreen({super.key, this.asignacionId});

  @override
  State<ColaboradorSucursalFormScreen> createState() => _ColaboradorSucursalFormScreenState();
}

class _ColaboradorSucursalFormScreenState extends State<ColaboradorSucursalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distanciaController = TextEditingController();

  ColaboradorGetAllDto? _selectedColaborador;
  Sucursal? _selectedSucursal;

  @override
  void initState() {
    super.initState();
    
    // Cargar colaboradores
    context.read<ColaboradorBloc>().add(LoadColaboradores());
    
    // Cargar sucursales
    context.read<SucursalBloc>().add(LoadSucursales());
    
    // Si es edición, cargar datos de la asignación
    if (widget.asignacionId != null) {
      // Aquí cargaríamos los datos de la asignación
    }
  }

  @override
  void dispose() {
    _distanciaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedColaborador == null) {
        AlertHelper.showAlert(
          context: context,
          title: 'Error',
          message: 'Debe seleccionar un colaborador',
          isSuccess: false,
        );
        return;
      }
      
      if (_selectedSucursal == null) {
        AlertHelper.showAlert(
          context: context,
          title: 'Error',
          message: 'Debe seleccionar una sucursal',
          isSuccess: false,
        );
        return;
      }
      
      final distancia = double.parse(_distanciaController.text);
      
      if (widget.asignacionId != null) {
        // Actualizar asignación existente
        context.read<ColaboradorSucursalBloc>().add(
          UpdateColaboradorSucursal(
            id: widget.asignacionId!,
            colaboradorId: _selectedColaborador!.colaboradorId!,
            sucursalId: _selectedSucursal!.sucursalId,
            distanciaKilometro: distancia,
            usuarioModifica: 1, // Hardcoded for now
          ),
        );
      } else {
        // Crear nueva asignación
        context.read<ColaboradorSucursalBloc>().add(
          AddColaboradorSucursal(
            colaboradorId: _selectedColaborador!.colaboradorId!,
            sucursalId: _selectedSucursal!.sucursalId,
            distanciaKilometro: distancia,
            usuarioCrea: 1, // Hardcoded for now
          ),
        );
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asignacionId != null ? 'Editar Asignación' : 'Nueva Asignación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ColaboradorSucursalBloc, ColaboradorSucursalState>(
        listener: (context, state) {
          if (state is ColaboradorSucursalError) {
            AlertHelper.showAlert(
              context: context,
              title: 'Error',
              message: state.message,
              isSuccess: false,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                          'Información de Asignación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Selector de Colaborador
                        BlocBuilder<ColaboradorBloc, ColaboradorState>(
                          builder: (context, state) {
                            List<ColaboradorGetAllDto> colaboradores = [];
                            bool isLoading = false;
                            
                            if (state is ColaboradorLoading) {
                              isLoading = true;
                            } else if (state is ColaboradorDataState) {
                              isLoading = state.isLoading;
                              if (state.colaboradores != null) {
                                colaboradores = state.colaboradores!;
                              }
                            }
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Colaborador',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isLoading)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<ColaboradorGetAllDto>(
                                  value: _selectedColaborador,
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione un colaborador',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                  ),
                                  items: colaboradores.map((colaborador) {
                                    return DropdownMenuItem<ColaboradorGetAllDto>(
                                      value: colaborador,
                                      child: Text('${colaborador.nombre} ${colaborador.apellido}'),
                                    );
                                  }).toList(),
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedColaborador = value;
                                          });
                                        },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'El colaborador es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Selector de Sucursal (ahora usando datos del API)
                        BlocBuilder<SucursalBloc, SucursalState>(
                          builder: (context, state) {
                            List<Sucursal> sucursales = [];
                            bool isLoading = false;
                            
                            if (state is SucursalLoading) {
                              isLoading = true;
                            } else if (state is SucursalLoaded) {
                              sucursales = state.sucursales;
                            } else if (state is SucursalError) {
                              // Mostrar error
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sucursal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error: ${state.message}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.read<SucursalBloc>().add(LoadSucursales());
                                    },
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              );
                            }
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Sucursal',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isLoading)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<Sucursal>(
                                  value: _selectedSucursal,
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione una sucursal',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                  ),
                                  items: sucursales.map((sucursal) {
                                    return DropdownMenuItem<Sucursal>(
                                      value: sucursal,
                                      child: Text(sucursal.nombre),
                                    );
                                  }).toList(),
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedSucursal = value;
                                          });
                                        },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'La sucursal es requerida';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Campo de distancia
                        CustomTextField(
                          label: 'Distancia (km)',
                          hint: 'Ingrese la distancia en kilómetros',
                          controller: _distanciaController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          isRequired: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La distancia es requerida';
                            }
                            try {
                              final distance = double.parse(value);
                              if (distance <= 0) {
                                return 'La distancia debe ser mayor a 0';
                              }
                            } catch (e) {
                              return 'Ingrese un número válido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(widget.asignacionId != null ? 'Actualizar' : 'Guardar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

