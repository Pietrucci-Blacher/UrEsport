import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uresport/core/models/tournament.dart';

class MapWidget extends StatefulWidget {
  final List<Tournament> tournaments;

  const MapWidget({super.key, required this.tournaments});

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getCurrentLocation();
  }

  void _setMarkers() {
    setState(() {
      _markers.addAll(widget.tournaments.map((tournament) {
        return Marker(
          markerId: MarkerId(tournament.id.toString()),
          position: LatLng(tournament.latitude, tournament.longitude),
          infoWindow: InfoWindow(
            title: tournament.name,
            snippet: tournament.location,
          ),
        );
      }).toList());
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      return;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    final Position position = await _geolocatorPlatform.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  Future<void> _showLocationServiceDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Location services are disabled. Please enable them in your device settings.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation();
              },
            ),
          ],
        );
      },
    );
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _centerOnCurrentLocation() {
    if (_currentPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                _centerOnCurrentLocation();
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: _zoomIn,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.zoom_in),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: _zoomOut,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.zoom_out),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: _centerOnCurrentLocation,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
