import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http show IOClient;
import '../models/colaborador_model.dart';
import '../models/dropdown_models.dart';
import '../services/auth_service.dart';

class ColaboradorService {
  final String baseUrl;
  final String endpoint = 'academiafarsiman/personascolaboradores';
  final AuthService? authService;

  ColaboradorService({
    required this.baseUrl,
    this.authService,
  });

  // Cliente HTTP personalizado que ignora la verificación de certificados
  // NOTA: Esto solo debe usarse en desarrollo, nunca en producción
  http.Client _createUnsafeClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    
    return http.IOClient(httpClient);
  }

  Future<List<ColaboradorGetAllDto>> getAll() async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint');
        
        // Crear los headers
        final headers = {
          'Content-Type': 'application/json',
        };
        
        if (authService != null && authService!.authToken != null) {
          headers['Authorization'] = 'Bearer ${authService!.authToken}';
        }
        
        final response = await client.get(url, headers: headers);
        
        
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          if (responseData['success'] == true) {
            final List<dynamic> colaboradoresData = responseData['data'];
            
            return colaboradoresData
                .map((item) => ColaboradorGetAllDto.fromJson(item))
                .toList();
          } else {
            throw Exception('Error en la respuesta: ${responseData['message']}');
          }
        } else {
          throw Exception('Failed to load colaboradores: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      throw Exception('Error fetching colaboradores: $e');
    }
  }

  Future<Map<String, dynamic>> create(CreatePersonaColaboradorDto dto) async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint');
        
        // Convertir el DTO a un mapa
        final dtoMap = dto.toJson();
        
        // Crear el cuerpo de la solicitud
        final requestBody = json.encode(dtoMap);
        
        // Crear los headers
        final headers = {
          'Content-Type': 'application/json',
        };
        
        if (authService != null && authService!.authToken != null) {
          headers['Authorization'] = 'Bearer ${authService!.authToken}';
        }
        
        // Realizar la solicitud
        final response = await client.post(
          url,
          headers: headers,
          body: requestBody,
        );
        
        print('Create response status: ${response.statusCode}');
        print('Create response body: ${response.body}');
        
        Map<String, dynamic> responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          print('Error decodificando respuesta: $e');
          responseData = {
            'success': false,
            'message': 'Error decodificando respuesta: ${response.body}',
            'data': null
          };
        }
        
        if (response.statusCode == 201 || response.statusCode == 200) {
          if (responseData['success'] == true) {
            return {
              'colaborador': responseData['data'] != null 
                  ? Colaborador.fromJson(responseData['data']) 
                  : null,
              'message': responseData['message'] ?? 'Colaborador creado exitosamente',
              'success': true
            };
          } else {
            return {
              'colaborador': null,
              'message': responseData['message'] ?? 'Error al crear colaborador',
              'success': false
            };
          }
        } else {
          return {
            'colaborador': null,
            'message': 'Error: ${response.statusCode} - ${response.body}',
            'success': false
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en create: $e');
      return {
        'colaborador': null,
        'message': 'Error al crear colaborador: $e',
        'success': false
      };
    }
  }

  Future<Map<String, dynamic>> update(int id, CreatePersonaColaboradorDto dto) async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint/$id');
        
        // Convertir el DTO a un mapa
        final dtoMap = dto.toJson();
        
        // Crear el cuerpo de la solicitud
        final requestBody = json.encode(dtoMap);
        
        // Crear los headers
        final headers = {
          'Content-Type': 'application/json',
        };
        
        if (authService != null && authService!.authToken != null) {
          headers['Authorization'] = 'Bearer ${authService!.authToken}';
        }
        
        // Realizar la solicitud
        final response = await client.put(
          url,
          headers: headers,
          body: requestBody,
        );
        
        print('Update response status: ${response.statusCode}');
        print('Update response body: ${response.body}');
        
        Map<String, dynamic> responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          print('Error decodificando respuesta: $e');
          responseData = {
            'success': false,
            'message': 'Error decodificando respuesta: ${response.body}',
            'data': null
          };
        }
        
        if (response.statusCode == 200) {
          if (responseData['success'] == true) {
            return {
              'colaborador': responseData['data'] != null 
                  ? Colaborador.fromJson(responseData['data']) 
                  : null,
              'message': responseData['message'] ?? 'Colaborador actualizado exitosamente',
              'success': true
            };
          } else {
            return {
              'colaborador': null,
              'message': responseData['message'] ?? 'Error al actualizar colaborador',
              'success': false
            };
          }
        } else {
          return {
            'colaborador': null,
            'message': 'Error: ${response.statusCode} - ${response.body}',
            'success': false
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en update: $e');
      return {
        'colaborador': null,
        'message': 'Error al actualizar colaborador: $e',
        'success': false
      };
    }
  }

  Future<Map<String, dynamic>> delete(int id) async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint/$id');
        
        // Crear los headers
        final headers = {
          'Content-Type': 'application/json',
        };
        
        if (authService != null && authService!.authToken != null) {
          headers['Authorization'] = 'Bearer ${authService!.authToken}';
        }
        
        // Realizar la solicitud
        final response = await client.delete(
          url,
          headers: headers,
        );
        
        print('Delete response status: ${response.statusCode}');
        print('Delete response body: ${response.body}');
        
        Map<String, dynamic> responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          print('Error decodificando respuesta: $e');
          responseData = {
            'success': false,
            'message': 'Error decodificando respuesta: ${response.body}',
            'data': null
          };
        }
        
        if (response.statusCode == 200) {
          if (responseData['success'] == true) {
            return {
              'success': true,
              'message': responseData['message'] ?? 'Colaborador eliminado exitosamente'
            };
          } else {
            return {
              'success': false,
              'message': responseData['message'] ?? 'Error al eliminar colaborador'
            };
          }
        } else {
          return {
            'success': false,
            'message': 'Error: ${response.statusCode} - ${response.body}'
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en delete: $e');
      return {
        'success': false,
        'message': 'Error al eliminar colaborador: $e'
      };
    }
  }

  Future<List<Ciudad>> getCiudades() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Ciudad(ciudadId: 1, nombre: 'San Pedro Sula'),
      Ciudad(ciudadId: 2, nombre: 'La Lima'),
    ];
  }

  Future<List<Rol>> getRoles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Rol(rolId: 1, nombre: 'Administrador'),
      Rol(rolId: 2, nombre: 'Colaborador'),
      Rol(rolId: 3, nombre: 'Supervisor'),
    ];
  }

  Future<List<Cargo>> getCargos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Cargo(cargoId: 1, nombre: 'Gerente'),
      Cargo(cargoId: 2, nombre: 'Asistente'),
      Cargo(cargoId: 3, nombre: 'Analista'),
    ];
  }

  Future<List<EstadoCivil>> getEstadosCiviles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      EstadoCivil(estadoCivilId: 1, nombre: 'Soltero'),
      EstadoCivil(estadoCivilId: 2, nombre: 'Casado'),
    ];
  }
}

