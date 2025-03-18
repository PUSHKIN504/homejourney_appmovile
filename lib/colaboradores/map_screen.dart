import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final Function(double latitude, double longitude, String address) onLocationSelected;

  const MapScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.onLocationSelected,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  LatLng? _selectedLocation;
  String _currentAddress = '';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.initialLatitude, widget.initialLongitude);
    _getAddressFromLatLng(_selectedLocation!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');

      final response = await http.get(url, headers: {
        'User-Agent': 'flutter_app',
      });

      if (response.statusCode == 200) {
        final results = jsonDecode(response.body);
        if (results.isNotEmpty) {
          final lat = double.parse(results[0]['lat']);
          final lon = double.parse(results[0]['lon']);
          final point = LatLng(lat, lon);
          
          // Mover el mapa a la nueva ubicación
          mapController.move(point, 15);
          _selectLocation(point);
          
          // Opcional: Mostrar el nombre del lugar encontrado
          _searchController.text = results[0]['display_name'].split(',')[0];
        } else {
          _showError('No se encontraron resultados');
        }
      } else {
        _showError('Error en la búsqueda');
      }
    } catch (e) {
      _showError('Error al buscar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _selectLocation(LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
    _getAddressFromLatLng(point);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    setState(() {
      _isLoading = true;
      _currentAddress = 'Obteniendo dirección...';
    });

    try {
      // Primero intentamos con Nominatim para obtener una dirección más detallada
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json');

      final response = await http.get(url, headers: {
        'User-Agent': 'flutter_app',
      });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result.containsKey('display_name')) {
          setState(() {
            _currentAddress = result['display_name'];
          });
          return;
        }
      }

      // Si Nominatim falla, usamos geocoding como respaldo
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        });
      } else {
        setState(() {
          _currentAddress = 'Dirección no encontrada';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Error al obtener la dirección: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Ubicación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.initialLatitude, widget.initialLongitude),
              initialZoom: 15,
              onTap: (tapPosition, point) {
                _selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              elevation: 4,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar dirección...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  suffixIcon: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            _searchLocation(_searchController.text.trim());
                          },
                        ),
                ),
                onSubmitted: (value) => _searchLocation(value.trim()),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Theme.of(context).cardColor.withOpacity(0.9),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dirección seleccionada:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentAddress,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedLocation != null)
                    Text(
                      'Latitud: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Longitud: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedLocation != null) {
                          widget.onLocationSelected(
                            _selectedLocation!.latitude,
                            _selectedLocation!.longitude,
                            _currentAddress,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Confirmar ubicación'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Centrar en la ubicación inicial
          mapController.move(
            LatLng(widget.initialLatitude, widget.initialLongitude),
            15,
          );
          _selectLocation(LatLng(widget.initialLatitude, widget.initialLongitude));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

