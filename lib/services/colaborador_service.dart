import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/colaborador_model.dart';
import '../models/dropdown_models.dart';

class ColaboradorService {
  final String baseUrl;
  final String endpoint = 'academiafarsiman/personascolaboradores';
  
  ColaboradorService({required this.baseUrl});

  // Get all colaboradores
  Future<List<ColaboradorGetAllDto>> getAll() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          
          final List<dynamic> colaboradoresData = responseData['data'];
          print('Datos: $colaboradoresData');
          return colaboradoresData
              .map((item) => ColaboradorGetAllDto.fromJson(item))
              .toList();
        } else {
          throw Exception('Error en la respuesta: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load colaboradores: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching colaboradores: $e');
    }
  }

  // Create colaborador
  Future<Colaborador> create(CreatePersonaColaboradorDto dto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Verificar que la respuesta sea exitosa
        if (responseData['success'] == true) {
          // Acceder directamente a la propiedad 'data' que contiene el colaborador creado
          return Colaborador.fromJson(responseData['data']);
        } else {
          throw Exception('Error en la respuesta: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to create colaborador: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating colaborador: $e');
    }
  }

  // Update colaborador
  Future<Colaborador> update(int id, CreatePersonaColaboradorDto dto) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Verificar que la respuesta sea exitosa
        if (responseData['success'] == true) {
          // Acceder directamente a la propiedad 'data' que contiene el colaborador actualizado
          return Colaborador.fromJson(responseData['data']);
        } else {
          throw Exception('Error en la respuesta: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update colaborador: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating colaborador: $e');
    }
  }

  // Delete colaborador
  Future<bool> delete(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Verificar que la respuesta sea exitosa
        if (responseData['success'] == true) {
          // Acceder directamente a la propiedad 'data' que contiene el resultado de la eliminación
          return responseData['data'] as bool;
        } else {
          throw Exception('Error en la respuesta: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to delete colaborador: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting colaborador: $e');
    }
  }

  // Mock methods for dropdown data (in a real app, these would be API calls)
  Future<List<Ciudad>> getCiudades() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Ciudad(ciudadId: 1, nombre: 'San Pedro Sula'),
      Ciudad(ciudadId: 2, nombre: 'La Lima'),
    ];
  }

  Future<List<Rol>> getRoles() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Rol(rolId: 1, nombre: 'Administrador'),
      Rol(rolId: 2, nombre: 'Colaborador'),
      Rol(rolId: 3, nombre: 'Supervisor'),
    ];
  }

  Future<List<Cargo>> getCargos() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Cargo(cargoId: 1, nombre: 'Gerente'),
      Cargo(cargoId: 2, nombre: 'Asistente'),
      Cargo(cargoId: 3, nombre: 'Analista'),
    ];
  }

  Future<List<EstadoCivil>> getEstadosCiviles() async {
    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      EstadoCivil(estadoCivilId: 1, nombre: 'Soltero'),
      EstadoCivil(estadoCivilId: 2, nombre: 'Casado'),
    ];
  }
}

