import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  LatLng? _currentLocation;

  Future <void> _userCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location unavailable")),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentLocation!, 13);
  }

  AppBar _appBar(){
    return AppBar(
        title: Text('Map'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          map(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _userCurrentLocation,
        backgroundColor: const Color(0xFFB9471E),
        child: Icon(
            Icons.my_location,
            color: Colors.white,
            size: 30,
        ),
      ),
    );
  }

  Widget map(){
    return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
            initialCenter: _currentLocation ?? LatLng(35.4358300, 7.1433300),
            initialZoom: 3.2,
            maxZoom: 15,
            minZoom: 2,
            interactionOptions:
              const InteractionOptions(
                  flags: InteractiveFlag.doubleTapZoom |
                         InteractiveFlag.pinchZoom |
                         InteractiveFlag.drag
              ),
        ),
        children: [
          openStreetMapTileLayer,
          CurrentLocationLayer(
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.white,
                ),
              ),
              markerSize: Size(35, 35),
              markerDirection: MarkerDirection.heading
            ),
          ),
        ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);