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
import 'map_screen.dart';

class ColaboradorFormScreen extends StatefulWidget {
  final int? colaboradorId;

  const ColaboradorFormScreen({super.key, this.colaboradorId});

  @override
  State<ColaboradorFormScreen> createState() => _ColaboradorFormScreenState();
}

class _ColaboradorFormScreenState extends State<ColaboradorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _direccionController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  // Dropdown values
  String? _sexo;
  Ciudad? _selectedCiudad;
  Rol? _selectedRol;
  Cargo? _selectedCargo;
  EstadoCivil? _selectedEstadoCivil;
  bool _activo = true;

  // Flag para controlar si ya se cargaron los datos iniciales
  bool _dataInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Set default values for latitude and longitude
    _latitudController.text = "15.5000";
    _longitudController.text = "-88.0333";
    
    // Cargar datos de dropdown si no están disponibles
    _loadDropdownData();
  }

  void _loadDropdownData() {
    // Verificamos si ya tenemos los datos en el estado
    final state = context.read<ColaboradorBloc>().state;
    if (state is ColaboradorDataState) {
      if (state.ciudades == null || state.roles == null || 
          state.cargos == null || state.estadosCiviles == null) {
        context.read<ColaboradorBloc>().add(LoadDropdownData());
      } else {
        _initializeDropdownValues(state);
      }
    } else {
      // Si no tenemos un estado compuesto, cargamos los datos
      context.read<ColaboradorBloc>().add(LoadDropdownData());
    }
  }

  void _initializeDropdownValues(ColaboradorDataState state) {
    if (!_dataInitialized && state.ciudades != null && state.roles != null && 
        state.cargos != null && state.estadosCiviles != null) {
      setState(() {
        // Set defaults
        if (state.ciudades!.isNotEmpty) _selectedCiudad = state.ciudades!.first;
        if (state.roles!.isNotEmpty) _selectedRol = state.roles!.first;
        if (state.cargos!.isNotEmpty) _selectedCargo = state.cargos!.first;
        if (state.estadosCiviles!.isNotEmpty) _selectedEstadoCivil = state.estadosCiviles!.first;
        _sexo = 'M'; // Default value
        _dataInitialized = true;
      });
    }
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
      // Imprimir valores para depuración
      print('Nombre: ${_nombreController.text}');
      print('Apellido: ${_apellidoController.text}');
      print('Sexo: $_sexo');
      print('Email: ${_emailController.text}');
      print('DNI: ${_dniController.text}');
      print('Dirección: ${_direccionController.text}');
      print('Ciudad ID: ${_selectedCiudad?.ciudadId}');
      print('Rol ID: ${_selectedRol?.rolId}');
      print('Cargo ID: ${_selectedCargo?.cargoId}');
      print('Estado Civil ID: ${_selectedEstadoCivil?.estadoCivilId}');
      print('Latitud: ${_latitudController.text}');
      print('Longitud: ${_longitudController.text}');
      
      final colaborador = CreatePersonaColaboradorDto(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        sexo: _sexo!,
        email: _emailController.text,
        documentoNacionalIdentificacion: _dniController.text,
        activo: _activo,
        estadoCivilId: _selectedEstadoCivil?.estadoCivilId,
        ciudadId: _selectedCiudad!.ciudadId,
        usuarioCrea: 1, // Hardcoded for now
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

  void _openMapScreen() {
    // Obtener los valores actuales de latitud y longitud
    double latitude = double.tryParse(_latitudController.text) ?? 15.5000;
    double longitude = double.tryParse(_longitudController.text) ?? -88.0333;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLatitude: latitude,
          initialLongitude: longitude,
          onLocationSelected: (lat, lng, address) {
            setState(() {
              _latitudController.text = lat.toString();
              _longitudController.text = lng.toString();
              _direccionController.text = address;
            });
          },
        ),
      ),
    );
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
          if (state is ColaboradorDataState) {
            // Inicializar valores de dropdown cuando estén disponibles
            _initializeDropdownValues(state);
            
            // Mostrar error si existe
            if (state.errorMessage != null) {
              AlertHelper.showAlert(
                context: context,
                title: 'Error',
                message: state.errorMessage!,
                isSuccess: false,
              );
            }
          }
        },
        builder: (context, state) {
          // Determinar si estamos cargando
          bool isLoading = false;
          
          // Obtener listas de dropdown del estado
          List<Ciudad> ciudades = [];
          List<Rol> roles = [];
          List<Cargo> cargos = [];
          List<EstadoCivil> estadosCiviles = [];
          
          if (state is ColaboradorLoading) {
            isLoading = true;
          } else if (state is ColaboradorDataState) {
            isLoading = state.isLoading;
            
            // Asignar listas si están disponibles
            if (state.ciudades != null) ciudades = state.ciudades!;
            if (state.roles != null) roles = state.roles!;
            if (state.cargos != null) cargos = state.cargos!;
            if (state.estadosCiviles != null) estadosCiviles = state.estadosCiviles!;
          }
          
          if (isLoading && ciudades.isEmpty) {
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
                                  hint: 'Nombre',
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
                                  hint: 'Apellido',
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
                                  hint: 'Seleccione',
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
                                      return 'Sexo es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomDropdown<EstadoCivil>(
                                  label: 'Estado Civil',
                                  hint: 'Seleccione',
                                  value: _selectedEstadoCivil,
                                  items: estadosCiviles,
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
                                  items: roles,
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
                                  hint: 'Cargo',
                                  value: _selectedCargo,
                                  items: cargos,
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
                            items: ciudades,
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
                          GestureDetector(
                            onTap: _openMapScreen,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.map,
                                          size: 48,
                                          color: Colors.white54,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Seleccionar ubicación en el mapa',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Lat: ${_latitudController.text}, Lng: ${_longitudController.text}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.touch_app,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Tocar para abrir',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
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
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Guardar'),
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
