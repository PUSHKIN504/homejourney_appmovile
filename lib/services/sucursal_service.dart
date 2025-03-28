import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import '../models/sucursal_model.dart';
import '../services/auth_service.dart';

class SucursalService {
  final String baseUrl;
  final String endpoint = 'academiafarsiman/sucursales';
  final AuthService? authService;

  SucursalService({
    required this.baseUrl,
    this.authService,
  });

  http.Client _createUnsafeClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    
    return http.IOClient(httpClient);
  }

  Future<List<Sucursal>> getAll() async {
    try {
      final client = _createUnsafeClient();
      
      try {
        final url = Uri.parse('$baseUrl/$endpoint');
        
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
            final List<dynamic> sucursalesData = responseData['data'];
            
            return sucursalesData
                .map((item) => Sucursal.fromJson(item))
                .toList();
          } else {
            throw Exception('Error en la respuesta: ${responseData['message']}');
          }
        } else {
          throw Exception('Failed to load sucursales: ${response.statusCode}');
        }
      } finally {
        client.close();
      }
    } catch (e) {
      throw Exception('Error fetching sucursales: $e');
    }
  }
}

