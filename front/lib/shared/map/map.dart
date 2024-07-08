import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_bloc.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';

class TournamentMapWidget extends StatefulWidget {
  final List<Tournament> tournaments;

  const TournamentMapWidget({super.key, required this.tournaments});

  @override
  TournamentMapWidgetState createState() => TournamentMapWidgetState();
}

class TournamentMapWidgetState extends State<TournamentMapWidget> {
  late MapboxMap _mapboxMap;
  bool _searching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Tournament> _filteredTournaments = [];
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  final List<String> _recentSearches = ["La Trésor", "Gymnase René Rousseau"];

  @override
  void initState() {
    super.initState();
    _filteredTournaments = widget.tournaments;
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  bool _isMapInitialized() {
    try {
      _mapboxMap.toString();
      return true;
    } catch (_) {
      return false;
    }
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
    if (state is MapLoaded && _isMapInitialized()) {
      context.read<MapBloc>().add(ShowDirections(
            state.position,
            Point(
              coordinates: Position(tournament.longitude, tournament.latitude),
            ),
          ));
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
              if (_isMapInitialized()) {
                _mapboxMap.flyTo(
                  CameraOptions(
                    center: state.position,
                    zoom: 14.0,
                  ),
                  MapAnimationOptions(duration: 2000, startDelay: 0),
                );
              }
            } else if (state is DirectionsLoaded) {
              context.read<MapBloc>().add(
                  UpdateMarkers(widget.tournaments, _showTournamentDetails));
            }
          },
          builder: (context, state) {
            if (state is MapLoaded || state is DirectionsLoaded) {
              return Stack(
                children: [
                  MapWidget(
                    cameraOptions: CameraOptions(
                      center: Point(coordinates: Position(0.0, 0.0)),
                      zoom: 2.0,
                    ),
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    onMapCreated: (MapboxMap controller) {
                      _mapboxMap = controller;
                      context.read<MapBloc>().add(SetMapController(controller));
                      if (state is MapLoaded) {
                        controller.flyTo(
                          CameraOptions(
                            center: state.position,
                            zoom: 14.0,
                          ),
                          MapAnimationOptions(duration: 2000, startDelay: 0),
                        );
                      }
                    },
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
                                                if (_isMapInitialized()) {
                                                  _mapboxMap.flyTo(
                                                    CameraOptions(
                                                      center: Point(
                                                        coordinates: Position(
                                                          tournament.longitude,
                                                          tournament.latitude,
                                                        ),
                                                      ),
                                                      zoom: 14.0,
                                                    ),
                                                    MapAnimationOptions(
                                                        duration: 2000,
                                                        startDelay: 0),
                                                  );
                                                  setState(() {
                                                    _searching = false;
                                                  });
                                                  _showTournamentDetails(
                                                      tournament);
                                                }
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
