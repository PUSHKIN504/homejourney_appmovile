import 'dart:convert';
import 'dart:io';
import '../models/auth_models.dart';

class AuthService {
  final String baseUrl;
  final String endpoint = 'academiafarsiman/Usuarios';
  String? _authToken;

  AuthService({required this.baseUrl});

  String? get authToken => _authToken;

  HttpClient _createHttpClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = 
          ((X509Certificate cert, String host, int port) => true);
    return httpClient;
  }

  Future<AuthResponse> login(String username, String password) async {
    try {
      final httpClient = _createHttpClient();
      final request = await httpClient.postUrl(Uri.parse('$baseUrl/$endpoint/login'));
      request.headers.set('Content-Type', 'application/json');
      
      final body = json.encode({
        'username': username,
        'password': password,
      });
      request.write(body);
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      httpClient.close();
      
      final Map<String, dynamic> responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        if (responseData['token'] != null) {
          _authToken = responseData['token'];
        }
        
        return AuthResponse(
          success: true,
          message: 'Login exitoso',
          data: UsuarioConDetallesDto.fromJson(responseData),
        );
      } else if (response.statusCode == 401) {
        return AuthResponse.fromJson(responseData);
      } else {
        return AuthResponse(
          success: false,
          message: 'Error: ${response.statusCode} - ${responseData['message'] ?? 'Error desconocido'}',
          data: null,
        );
      }
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Error de conexión: $e',
        data: null,
      );
    }
  }
}

