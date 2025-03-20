import 'dart:convert';
import 'dart:io';
import 'package:homejourney_appmovile/models/colaborador_sucursal_model.dart';
import 'package:homejourney_appmovile/models/viaje_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'auth_service.dart';

class ViajeService {
  final String baseUrl;
  final AuthService authService;
  
  ViajeService({
    required this.baseUrl,
    required this.authService,
  });

  http.Client _createUnsafeClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    return http.IOClient(httpClient);
  }
  
  Future<List<ViajesdetallesCreateClusteredDto>> clusterEmployees(
    int usuarioCrea,
    List<ColaboradorSucursal> employees,
    double distanceThreshold,
  ) async {
    final Map<String, String> queryParams = {
      'usuarioCrea': usuarioCrea.toString(),
      'distanceThreshold': distanceThreshold.toString(),
    };

    final Uri uri = Uri.parse('$baseUrl/api/viajesclustered/cluster-employees')
        .replace(queryParameters: queryParams);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',

    };

    final client = _createUnsafeClient();
    try {
      final response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(employees.map((e) => e.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final clusters = responseData[0] as List<dynamic>;
        return clusters
            .map((e) => ViajesdetallesCreateClusteredDto.fromJson(e))
            .toList();
      } else {
        throw Exception('Error al agrupar colaboradores: ${response.body}');
      }
    } finally {
      client.close();
    }
  }

  Future<void> createTripsFromClusters(
    int usuarioCrea,
    CreateViajesRequest request,
  ) async {
    final Map<String, String> queryParams = {
      'usuarioCrea': usuarioCrea.toString(),
    };

    final Uri uri = Uri.parse('$baseUrl/api/viajesclustered/create-trips-from-clusters')
        .replace(queryParameters: queryParams);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',

    };

    final client = _createUnsafeClient();
    try {
      final response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear viajes: ${response.body}');
      }
    } finally {
      client.close();
    }
  }
}
