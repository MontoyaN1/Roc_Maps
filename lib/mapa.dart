import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class MapaTiempoReal extends StatefulWidget {
  const MapaTiempoReal({super.key}); // Constructor constante añadido

  @override
  State<MapaTiempoReal> createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<MapaTiempoReal> {
  //CONTROL DE MAPA
  final MapController _mapController = MapController();
  //POSICION
  Position? _currentPosition;
  //POSICION EN TIEMPO REAL
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    //INICIAMOS SERVICIO DE LOCALIZACION
    _initLocationService();
  }

  @override
  void dispose() {
    //INICIAMOS POSICION EN TIEMPO REAL
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _initLocationService() async {
    //SERVICIO DISPONIBLE
    bool serviceEnabled;
    //PERMISO DE POSICION
    LocationPermission permission;

    //MIRAMOS SI EL SERVICIO ESTA DISPONIBLE, ASINCRONO
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      //SI ESTA DISPONIBLE EL SERVICIO ABRIMOS LA CONFIGURACION
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) return;
    }
    //PEDIMOS EL PERMISO
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //PERMISO DENEGADO
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        //HASTA QUE SE ACEPTE EL PERMISO
        return;
      }
    }

    try {
      //tOMAMOS LA POSICION
      _currentPosition = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          //DAMOS VALOR A LA POSICION, LATITUD Y LONGITUD
          _mapController.move(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            15,
          );
        });
      }
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
    }
    //ACTUALIZAMOS POSICION EN TIEMPO REAL
    _positionStream = Geolocator.getPositionStream().listen((
      Position position,
    ) {
      if (mounted) {
        setState(() {
          //DAMOS LA POSICION ACTUAL
          _currentPosition = position;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa con Ubicación en Tiempo Real'),
        automaticallyImplyLeading: false,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          //SI LA POSICION ES NULA POR FALTA DE PERMISOS O LOCALIZACION, SE MUESTRA POR DEFAULT CDMX
          initialCenter:
              _currentPosition != null
                  ? LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  )
                  : const LatLng(19.4326, -99.1332),
          initialZoom: 15,
        ),
        children: [
          //USAMOS OPENSTREETMAP COMO SERVICIO DE MAPAS
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap:
                    () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
