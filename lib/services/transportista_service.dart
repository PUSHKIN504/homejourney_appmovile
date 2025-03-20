import 'dart:convert';
import 'dart:io';
import 'package:homejourney_appmovile/models/transportista_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'auth_service.dart';

class TransportistaService {
  final String baseUrl;
  final AuthService authService;
  
  TransportistaService({
    required this.baseUrl,
    required this.authService,
  });
  
  http.Client _createUnsafeClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return IOClient(httpClient);
  }
  
  Future<List<Transportista>> getTransportistas() async {
    final client = _createUnsafeClient();
    try {
      final url = Uri.parse('$baseUrl/academiafarsiman/transportistas');
      final headers = {
        'Content-Type': 'application/json',
        if (authService.authToken != null)
          'Authorization': 'Bearer ${authService.authToken}',
      };
      
      final response = await client.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((item) => Transportista.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener transportistas: ${response.body}');
      }
    } finally {
      client.close();
    }
  }
}
