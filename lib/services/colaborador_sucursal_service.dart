import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import '../models/colaborador_sucursal_model.dart';
import '../models/sucursal_model.dart';
import '../services/auth_service.dart';

class ColaboradorSucursalService {
  final String baseUrl;
  final String endpoint = 'academiafarsiman/colaboradoressucursales';
  final AuthService? authService;

  ColaboradorSucursalService({
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

  Future<List<ColaboradorSucursal>> getAll() async {
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
        
        print('GetAll response status: ${response.statusCode}');
        print('GetAll response body: ${response.body}');
        
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          if (responseData['success'] == true) {
            final List<dynamic> colaboradoresSucursalesData = responseData['data'];
            
            return colaboradoresSucursalesData
                .map((item) => ColaboradorSucursal.fromJson(item))
                .toList();
          } else {
            throw Exception('Error en la respuesta: ${responseData['message']}');
          }
        } else {
          throw Exception('Failed to load colaboradores sucursales: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en getAll: $e');
      throw Exception('Error fetching colaboradores sucursales: $e');
    }
  }

  Future<ColaboradorSucursal> getById(int id) async {
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
        
        final response = await client.get(url, headers: headers);
        
        print('GetById response status: ${response.statusCode}');
        print('GetById response body: ${response.body}');
        
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          
          if (responseData['success'] == true) {
            return ColaboradorSucursal.fromJson(responseData['data']);
          } else {
            throw Exception('Error en la respuesta: ${responseData['message']}');
          }
        } else {
          throw Exception('Failed to load colaborador sucursal: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en getById: $e');
      throw Exception('Error fetching colaborador sucursal: $e');
    }
  }

  Future<Map<String, dynamic>> create(ColaboradorSucursalRequest dto) async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint');
        
        // Convertir el DTO a un mapa
        final dtoMap = dto.toJson();
        print('DTO Map: $dtoMap');
        
        // Crear el cuerpo de la solicitud
        final requestBody = json.encode(dtoMap);
        print('Request body: $requestBody');
        
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
              'colaboradorSucursal': responseData['data'] != null 
                  ? ColaboradorSucursal.fromJson(responseData['data']) 
                  : null,
              'message': responseData['message'] ?? 'Asignación creada exitosamente',
              'success': true
            };
          } else {
            return {
              'colaboradorSucursal': null,
              'message': responseData['message'] ?? 'Error al crear asignación',
              'success': false
            };
          }
        } else {
          return {
            'colaboradorSucursal': null,
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
        'colaboradorSucursal': null,
        'message': 'Error al crear asignación: $e',
        'success': false
      };
    }
  }

  Future<Map<String, dynamic>> update(int id, ColaboradorSucursalRequest dto) async {
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
              'colaboradorSucursal': responseData['data'] != null 
                  ? ColaboradorSucursal.fromJson(responseData['data']) 
                  : null,
              'message': responseData['message'] ?? 'Asignación actualizada exitosamente',
              'success': true
            };
          } else {
            return {
              'colaboradorSucursal': null,
              'message': responseData['message'] ?? 'Error al actualizar asignación',
              'success': false
            };
          }
        } else {
          return {
            'colaboradorSucursal': null,
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
        'colaboradorSucursal': null,
        'message': 'Error al actualizar asignación: $e',
        'success': false
      };
    }
  }

  Future<Map<String, dynamic>> setActive(int id, bool active) async {
    try {
      // Usar cliente inseguro para desarrollo
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint/$id?active=$active');
        
        // Crear los headers
        final headers = {
          'Content-Type': 'application/json',
        };
        
        if (authService != null && authService!.authToken != null) {
          headers['Authorization'] = 'Bearer ${authService!.authToken}';
        }
        
        // Realizar la solicitud
        final response = await client.patch(
          url,
          headers: headers,
        );
        
        print('SetActive response status: ${response.statusCode}');
        print('SetActive response body: ${response.body}');
        
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
              'colaboradorSucursal': responseData['data'] != null 
                  ? ColaboradorSucursal.fromJson(responseData['data']) 
                  : null,
              'message': responseData['message'] ?? 'Estado actualizado exitosamente',
              'success': true
            };
          } else {
            return {
              'colaboradorSucursal': null,
              'message': responseData['message'] ?? 'Error al actualizar estado',
              'success': false
            };
          }
        } else {
          return {
            'colaboradorSucursal': null,
            'message': 'Error: ${response.statusCode} - ${response.body}',
            'success': false
          };
        }
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error detallado en setActive: $e');
      return {
        'colaboradorSucursal': null,
        'message': 'Error al actualizar estado: $e',
        'success': false
      };
    }
  }
}

