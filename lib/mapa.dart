import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rocmaps/alerta.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MapaTiempoReal extends StatefulWidget {
  const MapaTiempoReal({super.key});

  @override
  State<MapaTiempoReal> createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<MapaTiempoReal> {
  final FocusNode _searchFocus = FocusNode();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  Position? _currentPosition;
  LatLng? _searchedLocation;
  List<LatLng> _routePoints = [];
  StreamSubscription<Position>? _positionStream;

  Timer? _debounce;
  List<Map<String, dynamic>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  void _moveCamera(LatLng position, [double zoom = 15]) {
    _mapController.move(position, zoom);
  }

  Future<void> _initLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      _moveCamera(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      );

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(distanceFilter: 5),
      ).listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } catch (e) {
      debugPrint("Error al obtener ubicación: $e");
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

 final url = Uri.https(
  'nominatim.openstreetmap.org',
  '/search',
  {
    'q': query,
    'format': 'json',
    'addressdetails': '1',
    'limit': '5',
    'countrycodes': 'co', // 🇨🇴 SOLO Colombia
  },
);


      final response = await http.get(url, headers: {
        'User-Agent': 'RocMapsApp/1.0 (tu-email@example.com)',
      });

      if (response.statusCode == 200) {
        final List results = json.decode(response.body);
        setState(() {
          _suggestions = results.cast<Map<String, dynamic>>();
        });
      }
    });
  }

  void _onSuggestionTap(Map<String, dynamic> lugar) async {
    _searchController.text = lugar['display_name'];
    setState(() => _suggestions = []);

    final lat = double.parse(lugar['lat']);
    final lon = double.parse(lugar['lon']);
    final destino = LatLng(lat, lon);

    setState(() {
      _searchedLocation = destino;
    });

    _mapController.move(destino, 15);
    await _getRoute(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      destino,
    );
  }

Future<void> _getRoute(LatLng origen, LatLng destino) async {
  final String apiKey = "5b3ce3597851110001cf6248b264745665134b06ab91cafda502860c";
  final url = Uri.parse(
    'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${origen.longitude},${origen.latitude}&end=${destino.longitude},${destino.latitude}',
  );

  try {
    final response = await http.get(url);
    final data = json.decode(response.body);
    final coords = data['features'][0]['geometry']['coordinates'] as List;

    final List<LatLng> puntosRuta = coords
        .map((coord) => LatLng(coord[1] as double, coord[0] as double))
        .toList();

    setState(() {
      _routePoints = puntosRuta;
    });
  } catch (e) {
    debugPrint(" Error al obtener ruta: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo obtener la ruta")),
    );
  }
}


void _showGroupOptions() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text("¿Qué deseas hacer?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);        // Cierra el diálogo
              crearGrupo(context);           // Llama a la función de alerta.dart
            },
            child: const Text("Crear grupo"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí puedes poner unirseGrupo(context);
            },
            child: const Text("Unirse a grupo"),
          ),
        ],
      ),
    ),
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: ModalRoute.of(context)?.settings.name == '/chat',
      body: Stack(
        children: [
  FlutterMap(
  mapController: _mapController,
  options: MapOptions(
  initialCenter: _currentPosition != null
      ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      : const LatLng(4.5709, -74.2973),
  initialZoom: 6,
  minZoom: 5,
  maxZoom: 18,
  cameraConstraint: CameraConstraint.contain(
    bounds: LatLngBounds(
      const LatLng(-5.0, -81.0), // Suroeste de Colombia
      const LatLng(14.0, -66.0), // Noreste de Colombia
    ),
  ),
),


            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              if (_searchedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _searchedLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.flag, color: Colors.green, size: 36),
                    ),
                  ],
                ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 5,
                      color: Colors.green,
                    ),
                  ],
                ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocus,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: "Buscar lugar o dirección...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => _onSearchChanged(_searchController.text),
                      ),
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                 Container(
  margin: const EdgeInsets.only(top: 5),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: _suggestions.length,
    itemBuilder: (context, index) {
      final lugar = _suggestions[index];
      return ListTile(
        title: Text(
          lugar['display_name'] ?? '',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        onTap: () => _onSuggestionTap(lugar),
      );
    },
  ),
),

              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _mapController.move(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    15,
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: FloatingActionButton(
              onPressed: _showGroupOptions,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
