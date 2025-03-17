import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/colaborador_model.dart';
import '../models/dropdown_models.dart';
import '../utils/alert_helper.dart';
import '../widgets/form_fields.dart';
import 'bloc/colaborador_bloc.dart';
import 'bloc/colaborador_event.dart';
import 'bloc/colaborador_state.dart';

class ColaboradorFormScreen extends StatefulWidget {
  final int? colaboradorId;

  const ColaboradorFormScreen({super.key, this.colaboradorId});

  @override
  State<ColaboradorFormScreen> createState() => _ColaboradorFormScreenState();
}

class _ColaboradorFormScreenState extends State<ColaboradorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _direccionController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  
  String? _sexo;
  Ciudad? _selectedCiudad;
  Rol? _selectedRol;
  Cargo? _selectedCargo;
  EstadoCivil? _selectedEstadoCivil;
  bool _activo = true;
  
  List<Ciudad> _ciudades = [];
  List<Rol> _roles = [];
  List<Cargo> _cargos = [];
  List<EstadoCivil> _estadosCiviles = [];
  
  @override
  void initState() {
    super.initState();
    context.read<ColaboradorBloc>().add(LoadDropdownData());
    
    _latitudController.text = "15.5000";
    _longitudController.text = "-88.0333";
  }
  
  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _dniController.dispose();
    _direccionController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final colaborador = CreatePersonaColaboradorDto(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        sexo: _sexo!,
        email: _emailController.text,
        documentoNacionalIdentificacion: _dniController.text,
        activo: _activo,
        estadoCivilId: _selectedEstadoCivil?.estadoCivilId,
        ciudadId: _selectedCiudad!.ciudadId,
        usuarioCrea: 1, 
        rolId: _selectedRol!.rolId,
        cargoId: _selectedCargo!.cargoId,
        direccion: _direccionController.text,
        latitud: double.parse(_latitudController.text),
        longitud: double.parse(_longitudController.text),
      );
      
      if (widget.colaboradorId != null) {
        context.read<ColaboradorBloc>().add(
          UpdateColaborador(widget.colaboradorId!, colaborador),
        );
      } else {
        context.read<ColaboradorBloc>().add(
          AddColaborador(colaborador),
        );
      }
      
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.colaboradorId != null ? 'Editar Colaborador' : 'Nuevo Colaborador'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ColaboradorBloc, ColaboradorState>(
        listener: (context, state) {
          if (state is ColaboradorError) {
            AlertHelper.showAlert(
              context: context,
              title: 'Error',
              message: state.message,
              isSuccess: false,
            );
          } else if (state is DropdownDataLoaded) {
            setState(() {
              _ciudades = state.ciudades;
              _roles = state.roles;
              _cargos = state.cargos;
              _estadosCiviles = state.estadosCiviles;
              
              if (_ciudades.isNotEmpty) _selectedCiudad = _ciudades.first;
              if (_roles.isNotEmpty) _selectedRol = _roles.first;
              if (_cargos.isNotEmpty) _selectedCargo = _cargos.first;
              if (_estadosCiviles.isNotEmpty) _selectedEstadoCivil = _estadosCiviles.first;
            });
          }
        },
        builder: (context, state) {
          if (state is ColaboradorLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
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
                            'Información Personal',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Nombre',
                                  hint: 'Ingrese su nombre',
                                  controller: _nombreController,
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El nombre es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Apellido',
                                  hint: 'Ingrese su apellido',
                                  controller: _apellidoController,
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El apellido es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown<String>(
                                  label: 'Sexo',
                                  hint: 'Seleccione su sexo',
                                  value: _sexo,
                                  items: const ['M', 'F'],
                                  getLabel: (item) => item == 'M' ? 'Masculino' : 'Femenino',
                                  onChanged: (value) {
                                    setState(() {
                                      _sexo = value;
                                    });
                                  },
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'El sexo es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomDropdown<EstadoCivil>(
                                  label: 'Estado Civil',
                                  hint: 'Seleccione su estado civil',
                                  value: _selectedEstadoCivil,
                                  items: _estadosCiviles,
                                  getLabel: (item) => item.nombre,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEstadoCivil = value;
                                    });
                                  },
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'El estado civil es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Email',
                            hint: 'Ingrese su email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El email es requerido';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Documento Nacional',
                            hint: 'Ingrese su DNI',
                            controller: _dniController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El documento es requerido';
                              }
                              if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Solo se permiten números';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                            'Información Laboral',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropdown<Rol>(
                                  label: 'Rol',
                                  hint: 'Seleccione rol',
                                  value: _selectedRol,
                                  items: _roles,
                                  getLabel: (item) => item.nombre,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRol = value;
                                    });
                                  },
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'El rol es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomDropdown<Cargo>(
                                  label: 'Cargo',
                                  hint: 'Seleccione cargo',
                                  value: _selectedCargo,
                                  items: _cargos,
                                  getLabel: (item) => item.nombre,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCargo = value;
                                    });
                                  },
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'El cargo es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomCheckbox(
                            label: 'Activo',
                            value: _activo,
                            onChanged: (value) {
                              setState(() {
                                _activo = value ?? true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                            'Ubicación',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomDropdown<Ciudad>(
                            label: 'Ciudad',
                            hint: 'Seleccione ciudad',
                            value: _selectedCiudad,
                            items: _ciudades,
                            getLabel: (item) => item.nombre,
                            onChanged: (value) {
                              setState(() {
                                _selectedCiudad = value;
                              });
                            },
                            isRequired: true,
                            validator: (value) {
                              if (value == null) {
                                return 'La ciudad es requerida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Dirección',
                            hint: 'Ingrese dirección',
                            controller: _direccionController,
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La dirección es requerida';
                              }
                              if (value.length > 500) {
                                return 'Máximo 500 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'Latitud',
                                  controller: _latitudController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La latitud es requerida';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Longitud',
                                  controller: _longitudController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  isRequired: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La longitud es requerida';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 48,
                                    color: Colors.white54,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Mapa no disponible',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ingrese las coordenadas manualmente',
                                    style: TextStyle(
                                      color: Colors.white70,
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
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

