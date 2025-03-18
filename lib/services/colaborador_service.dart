import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

  HttpClient _createHttpClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = 
          ((X509Certificate cert, String host, int port) => true);
    return httpClient;
  }

  void _addAuthHeaders(HttpClientRequest request) {
    request.headers.set('Content-Type', 'application/json');
    
    if (authService != null && authService!.authToken != null) {
      request.headers.set('Authorization', 'Bearer ${authService!.authToken}');
    }
  }

  Future<List<ColaboradorGetAllDto>> getAll() async {
    try {
      final httpClient = _createHttpClient();
      final request = await httpClient.getUrl(Uri.parse('$baseUrl/$endpoint'));
      _addAuthHeaders(request);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();

      print('GetAll response: $responseBody');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(responseBody);
        
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
    } catch (e) {
      print('Error detallado en getAll: $e');
      throw Exception('Error fetching colaboradores: $e');
    }
  }

  Future<Map<String, dynamic>> create(CreatePersonaColaboradorDto dto) async {
    try {
      final httpClient = _createHttpClient();
      final request = await httpClient.postUrl(Uri.parse('$baseUrl/$endpoint'));
      _addAuthHeaders(request);
      
      request.write(json.encode(dto.toJson()));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();

      final Map<String, dynamic> responseData = json.decode(responseBody);
      print('Create response: $responseData');
      
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
          'message': 'Error: ${response.statusCode} - ${responseData['message'] ?? 'Error desconocido'}',
          'success': false
        };
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
      final httpClient = _createHttpClient();
      final request = await httpClient.putUrl(Uri.parse('$baseUrl/$endpoint/$id'));
      _addAuthHeaders(request);
      
      request.write(json.encode(dto.toJson()));
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();

      final Map<String, dynamic> responseData = json.decode(responseBody);
      print('Update response: $responseData');
      
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
          'message': 'Error: ${response.statusCode} - ${responseData['message'] ?? 'Error desconocido'}',
          'success': false
        };
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
      final httpClient = _createHttpClient();
      final request = await httpClient.deleteUrl(Uri.parse('$baseUrl/$endpoint/$id'));
      _addAuthHeaders(request);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();

      final Map<String, dynamic> responseData = json.decode(responseBody);
      print('Delete response: $responseData');
      
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
          'message': 'Error: ${response.statusCode} - ${responseData['message'] ?? 'Error desconocido'}'
        };
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

