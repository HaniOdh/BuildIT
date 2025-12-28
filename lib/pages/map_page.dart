import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'firstPage.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  LatLng? _currentLocation;

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 1;

  String baseUrl = 'http://10.0.2.2:8000';

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

  Future<void> _searchLocation(String query) async {
    debugPrint('SEARCH QUERY: $query');
    if (query.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
    );

    final response = await http.get(url, headers: {
      'User-Agent': 'flutter_app'
    });

    debugPrint('NOMINATIM STATUS: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);

        final LatLng searchedLocation = LatLng(lat, lon);

        _mapController.move(searchedLocation, 9);

        final events = await fetchEvents(country: query);

        debugPrint('EVENTS: $events');

        debugPrint('EVENTS LENGTH: ${events.length}');

        final figures = await fetchFigures(country: query);

        debugPrint('FIGURES: $figures');

        debugPrint('FIGURES LENGTH: ${figures.length}');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Country not found")),
        );
      }
    }
  }

  Future<void> _exploreAll() async{
    final AllEvents = await fetchAllEvents();

    debugPrint('ALL EVENTS: $AllEvents');

    debugPrint('ALL EVENTS LENGTH: ${AllEvents.length}');

    final AllFigures = await fetchAllFigures();

    debugPrint('ALL FIGURS: $AllFigures');

    debugPrint('ALL FIGURS LENGTH: ${AllFigures.length}');
  }

  Future<List<dynamic>> fetchEvents({required String country}) async {
    final uri = Uri.http(
      '10.0.2.2:8000',
      '/api/event/',
      {
        'Country': country
      },
    );

    debugPrint('BACKEND EVENT URL: $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  Future<List<dynamic>> fetchFigures({required String country}) async {
    final uri = Uri.http(
      '10.0.2.2:8000',
      '/api/person/country',
      {
        'Birth_Country': country
      },
    );

    debugPrint('BACKEND FIGURES URL: $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  Future<List<dynamic>> fetchAllEvents() async {
    final uri = Uri.http(
      '10.0.2.2:8000',
      '/api/event/'
    );

    debugPrint('BACKEND ALL EVENT URL: $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  Future<List<dynamic>> fetchAllFigures() async {
    final uri = Uri.http(
        '10.0.2.2:8000',
        '/api/person/country/'
    );

    debugPrint('BACKEND ALL FIGURES URL: $uri');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch events');
    }
  }

  AppBar _appBar(){
    return AppBar(
        title: Text('Map'),
    );
  }

  Widget searchBar(){
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(100),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _searchLocation,
        decoration: InputDecoration(
          hintText: "Search location...",
          prefixIcon: const Icon(
              Icons.search,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
                Icons.clear
            ),
            onPressed: () => _searchController.clear(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFE3E3E3)
        ),
      ),
    );
  }

  Widget bottomBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        if (_selectedIndex == index) {
          return;
        }
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FirstPage()),
          );
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          map(),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: searchBar(),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        FloatingActionButton(
          onPressed: _userCurrentLocation,
          backgroundColor: const Color(0xFFB9471E),
          child: Icon(
            Icons.my_location,
            color: Colors.white,
            size: 30,
          ),
        ),
          FloatingActionButton(
            heroTag: 'Explore',
            onPressed: _exploreAll,
            backgroundColor: const Color(0xFFB9471E),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(),
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