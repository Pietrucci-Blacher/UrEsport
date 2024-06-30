import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/shared/map/bloc/map_bloc.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';
import 'package:uresport/core/services/map_service.dart';
import 'dart:ui' as ui;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapWidget extends StatefulWidget {
  final List<Tournament> tournaments;

  const MapWidget({super.key, required this.tournaments});

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Tournament> _filteredTournaments = [];
  BitmapDescriptor? _customMarker;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  final List<String> _recentSearches = ["La Trésor", "Gymnase René Rousseau"];
  final PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _polylineCoordinates = [];
  Polyline? _polyline;

  @override
  void initState() {
    super.initState();
    _filteredTournaments = widget.tournaments;
    _loadCustomMarker();
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  void _loadCustomMarker() async {
    _customMarker = await _createCustomMarkerBitmap();
    setState(() {});
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 100.0;
    final Paint paint = Paint()..color = Colors.white;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr);
    const IconData iconData = Icons.emoji_events;
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size / 2,
        fontFamily: iconData.fontFamily,
        color: Colors.yellow,
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
          (size - textPainter.width) / 2,
          (size - textPainter.height) / 2,
        ));

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  void _filterTournaments(String query) {
    final filteredTournaments = widget.tournaments.where((tournament) {
      return tournament.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredTournaments = filteredTournaments;
    });
  }

  void _showTournamentDetails(Tournament tournament) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFFFF),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Image.network(
                        tournament.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tournament.location}\n${tournament.startDate} - ${tournament.endDate}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tournament.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton.icon(
                              onPressed: () {
                                _startDirections(tournament);
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Itinéraire'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _exportDirections(tournament);
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Exporter'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startDirections(Tournament tournament) async {
    final state = context.read<MapBloc>().state;
    if (state is MapLoaded) {
      context.read<MapBloc>().add(ShowDirections(
            LatLng(state.position.latitude, state.position.longitude),
            LatLng(tournament.latitude, tournament.longitude),
          ));

      final polylineResult = await _polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin:
              PointLatLng(state.position.latitude, state.position.longitude),
          destination: PointLatLng(tournament.latitude, tournament.longitude),
          mode: TravelMode.driving,
        ),
        googleApiKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,
      );

      if (polylineResult.points.isNotEmpty) {
        setState(() {
          _polylineCoordinates = polylineResult.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
          _polyline = Polyline(
            polylineId: const PolylineId('directions'),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 5,
          );
        });
      }
    }
  }

  void _exportDirections(Tournament tournament) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${tournament.latitude},${tournament.longitude}";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  void _startListening() async {
    bool available = await _speechToText.initialize(
      onStatus: (val) => setState(() {
        _isListening = val == 'listening';
      }),
      onError: (val) => setState(() {
        _isListening = false;
      }),
    );
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _searchController.text = val.recognizedWords;
              _filterTournaments(val.recognizedWords);
            });
          }
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        mapService: RepositoryProvider.of<MapService>(context),
      )..add(LoadMap(widget.tournaments, _showTournamentDetails)),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for a tournament',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                onPressed: () {
                  if (_isListening) {
                    _stopListening();
                  } else {
                    _startListening();
                  }
                },
              ),
            ),
            onChanged: (query) => _filterTournaments(query),
            onTap: () {
              setState(() {
                _searching = true;
              });
            },
          ),
          leading: _searching
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _searching = false;
                      _searchController.clear();
                    });
                  },
                )
              : null,
        ),
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state is MapLoaded) {
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                        state.position.latitude, state.position.longitude),
                    zoom: 14.0,
                  ),
                ),
              );
            } else if (state is DirectionsLoaded) {
              context.read<MapBloc>().add(
                  UpdateMarkers(widget.tournaments, _showTournamentDetails));
            }
          },
          builder: (context, state) {
            if (state is MapLoaded || state is DirectionsLoaded) {
              return Stack(
                children: [
                  GoogleMap(
                    markers: state is MapLoaded
                        ? state.mapMarkers.map((marker) {
                            return marker.copyWith(
                              iconParam: _customMarker ??
                                  BitmapDescriptor.defaultMarker,
                            );
                          }).toSet()
                        : (state as DirectionsLoaded).mapMarkers.map((marker) {
                            return marker.copyWith(
                              iconParam: _customMarker ??
                                  BitmapDescriptor.defaultMarker,
                            );
                          }).toSet(),
                    polylines: _polyline != null ? {_polyline!} : {},
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 2,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      context.read<MapBloc>().add(SetMapController(controller));
                      if (state is MapLoaded) {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(state.position.latitude,
                                  state.position.longitude),
                              zoom: 14.0,
                            ),
                          ),
                        );
                      }
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                  if (_searching)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => setState(() => _searching = false),
                        child: Container(
                          color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            _searchController.text.isEmpty
                                                ? _recentSearches.length
                                                : _filteredTournaments.length,
                                        itemBuilder: (context, index) {
                                          if (_searchController.text.isEmpty) {
                                            return ListTile(
                                              leading:
                                                  const Icon(Icons.history),
                                              title:
                                                  Text(_recentSearches[index]),
                                              onTap: () {
                                                _searchController.text =
                                                    _recentSearches[index];
                                                _filterTournaments(
                                                    _recentSearches[index]);
                                              },
                                            );
                                          } else {
                                            final tournament =
                                                _filteredTournaments[index];
                                            return ListTile(
                                              title: Text(tournament.name),
                                              onTap: () {
                                                _mapController?.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                    CameraPosition(
                                                      target: LatLng(
                                                          tournament.latitude,
                                                          tournament.longitude),
                                                      zoom: 14.0,
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  _searching = false;
                                                });
                                                _showTournamentDetails(
                                                    tournament);
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IgnorePointer(
                      ignoring: _searching,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'zoomInButton',
                              onPressed: () =>
                                  context.read<MapBloc>().add(ZoomIn()),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              child: const Icon(Icons.zoom_in),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton(
                              heroTag: 'zoomOutButton',
                              onPressed: () =>
                                  context.read<MapBloc>().add(ZoomOut()),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              child: const Icon(Icons.zoom_out),
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton(
                              heroTag: 'locationButton',
                              onPressed: () => context
                                  .read<MapBloc>()
                                  .add(CenterOnCurrentLocation()),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              child: const Icon(Icons.my_location),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is MapError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
