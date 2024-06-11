import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uresport/core/models/tournament.dart';

class MapWidget extends StatefulWidget {
  final List<Tournament> tournaments;

  const MapWidget({super.key, required this.tournaments});

  @override MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    setState(() {
      _markers.addAll(widget.tournaments.map((tournament) {
        return Marker(
          markerId: MarkerId(tournament.id.toString()),
          position: LatLng(tournament.latitude, tournament.longitude), // Utilisez latitude et longitude
          infoWindow: InfoWindow(
            title: tournament.name,
            snippet: tournament.location,
          ),
        );
      }).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Map'),
      ),
      body: GoogleMap(
        markers: _markers,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.close),
      ),
    );
  }
}
