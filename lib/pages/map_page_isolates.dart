import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'firstPage.dart';
import 'package:flutter/foundation.dart';
import 'dart:isolate';
import 'dart:async';

void exploreAllIsolate(SendPort sendPort) async {
  final results = <String, dynamic>{};

  // Async queue: list of tasks
  final queue = [
    () async {
      try {
        final response = await http.get(Uri.http('10.0.2.2:8000', '/api/event/'));
        if (response.statusCode == 200) {
          results['events'] = jsonDecode(response.body);
        } else {
          results['events'] = [];
        }
      } catch (e) {
        debugPrint('Error fetching events in isolate: $e');
        results['events'] = [];
      }
    },
    () async {
      try {
        final response = await http.get(Uri.http('10.0.2.2:8000', '/api/person/country/'));
        if (response.statusCode == 200) {
          results['figures'] = jsonDecode(response.body);
        } else {
          results['figures'] = [];
        }
      } catch (e) {
        debugPrint('Error fetching figures in isolate: $e');
        results['figures'] = [];
      }
    },
  ];

  // Execute tasks sequentially (async queue)
  for (final task in queue) {
    await task();
  }

  // Send only JSON-serializable Map back to main isolate
  sendPort.send(results);
}

class MapPageIsolates extends StatefulWidget {
  const MapPageIsolates({super.key});

  @override
  State<MapPageIsolates> createState() => _MapPageState();
}

class _MapPageState extends State<MapPageIsolates> {
  final MapController _mapController = MapController();

  LatLng? _currentLocation;

  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 1;

  String baseUrl = 'http://10.0.2.2:8000';

  List<dynamic> _allEvents = [];
  List<dynamic> _allFigures = [];
  bool _isLoading = false;

  Future <void> _userCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
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

      if (!mounted) return;
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _mapController.move(_currentLocation!, 13);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    debugPrint('SEARCH QUERY: $query');
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
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
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Country not found")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error in search location: $e");
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _exploreAll() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a ReceivePort to get messages from the new isolate.
      final receivePort = ReceivePort();
      final sendPort = receivePort.sendPort;

      // Explicitly spawn a new isolate.
      // 'Isolate.spawn' creates and runs the 'exploreAllIsolate' function in a separate thread.
      final Isolate newIsolate = await Isolate.spawn(
        exploreAllIsolate,
        sendPort,
      );

      // Wait for the isolate to send back the results.
      final results = await receivePort.first as Map<String, dynamic>;

      // Clean up the isolate now that we have the results.
      newIsolate.kill(priority: Isolate.immediate);

      debugPrint('ALL EVENTS: ${results['events']}');
      debugPrint('ALL EVENTS LENGTH: ${results['events'].length}');
      debugPrint('ALL FIGURES: ${results['figures']}');
      debugPrint('ALL FIGURES LENGTH: ${results['figures'].length}');

      if (!mounted) return;
      setState(() {
        _allEvents = results['events'];
        _allFigures = results['figures'];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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