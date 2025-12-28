import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          map(),
        ],
      ),
    );
  }

  Widget map(){
    return FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(35.4358300, 7.1433300),
            initialZoom: 3.2,
            interactionOptions:
              const InteractionOptions(
                  flags: InteractiveFlag.doubleTapZoom |
                         InteractiveFlag.pinchZoom |
                         InteractiveFlag.drag
              ),
        ),
        children: [
          openStreetMapTileLayer,
        ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);