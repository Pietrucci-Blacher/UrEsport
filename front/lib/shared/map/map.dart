import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_api_pro/mapbox_api_pro.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_bloc.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart'; // Assurez-vous d'importer l'écran des détails du tournoi

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
  late MapService mapService;
  final List<String> _recentSearches = ["La Trésor", "Gymnase René Rousseau"];
  bool _isListening = false;
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  late MapboxApi _directions;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _filteredTournaments = widget.tournaments;
    mapService = RepositoryProvider.of<MapService>(context);
    _initializeSpeechToText();
    _initializeNavigation();
  }

  void _initializeNavigation() {
    String? token = dotenv.env['SDK_REGISTRY_TOKEN'];
    if (token != null) {
      _directions = MapboxApi(
        accessToken: token,
      );
    } else {
      debugPrint('SDK_REGISTRY_TOKEN is null');
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  void _initializeSpeechToText() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
      onError: (errorNotification) =>
          debugPrint('Speech recognition error: $errorNotification'),
    );
    if (available) {
      debugPrint('Speech recognition initialized successfully');
    } else {
      debugPrint('Speech recognition not available');
    }
  }

  bool _isMapInitialized() {
    try {
      _mapboxMap.toString();
      return true;
    } catch (_) {
      return false;
    }
  }

  void _initializeMap() {
    String? accessToken = dotenv.env['SDK_REGISTRY_TOKEN'];
    if (accessToken != null) {
      MapboxOptions.setAccessToken(accessToken);
    } else {
      debugPrint('SDK_REGISTRY_TOKEN is null');
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'tournament_image_${tournament.id}',
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              tournament.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black54, Colors.transparent],
                              ),
                            ),
                            child: Text(
                              tournament.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // Informations générales
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Informations générales',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              _buildInfoRow(Icons.calendar_today,
                                  '${_formatDate(tournament.startDate)} - ${_formatDate(tournament.endDate)}'),
                              _buildInfoRow(
                                  Icons.location_on, tournament.location),
                              _buildInfoRow(Icons.person,
                                  'Organisateur: ${tournament.owner.firstname} ${tournament.owner.lastname}'),
                            ],
                          ),
                        ),
                      ),
                      // Description
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Description',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Text(tournament.description),
                            ],
                          ),
                        ),
                      ),
                      // Équipes participantes
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Équipes participantes',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              ...tournament.teams
                                  .map((team) => _buildTeamItem(team)),
                            ],
                          ),
                        ),
                      ),
                      // Boutons d'action
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Voir la fiche du tournoi'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                minimumSize: const ui.Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TournamentDetailsScreen(
                                      tournament: tournament,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.directions),
                              label: const Text('Obtenir l\'itinéraire'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                minimumSize: const ui.Size(double.infinity, 50),
                              ),
                              onPressed: () => _startDirections(tournament),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.share),
                              label: const Text('Exporter l\'itinéraire'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green,
                                minimumSize: const ui.Size(double.infinity, 50),
                              ),
                              onPressed: () => _exportDirections(tournament),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildTeamItem(Team team) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.group, color: Colors.grey, size: 18),
          const SizedBox(width: 10),
          Text(team.name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _startDirections(Tournament tournament) async {
    final state = context.read<MapBloc>().state;
    if (state is MapLoaded && _isMapInitialized()) {
      final currentLocation = await mapService.getCurrentLocation();

      final latitude = currentLocation['latitude'];
      final longitude = currentLocation['longitude'];

      if (latitude != null && longitude != null) {
        final response = await _directions.directions.request(
          coordinates: [
            [longitude, latitude],
            [tournament.longitude, tournament.latitude]
          ],
          profile: NavigationProfile.DRIVING,
          geometries: NavigationGeometries.GEOJSON,
        );

        final routes = response.routes;
        if (routes != null && routes.isNotEmpty) {
          final route = routes.first;
          final coordinates = route.geometry?.coordinates;
          if (coordinates != null) {
            final points = coordinates.map((coord) {
              return Point(coordinates: Position(coord[0], coord[1]));
            }).toList();

            if (points.isNotEmpty) {
              mapService.addPolyline(points);
            }
          }
        }
      }
    }
  }

  void _exportDirections(Tournament tournament) async {
    final mapBloc = context.read<MapBloc>();
    final state = mapBloc.state;

    if (state is DirectionsLoaded) {
      mapBloc.add(ExportDirections(state.polylinePoints));
    } else {
      final userLocation = await mapService.getCurrentLocation();
      final origin = Point(
          coordinates:
              Position(userLocation['longitude']!, userLocation['latitude']!));
      final destination = Point(
          coordinates: Position(tournament.longitude, tournament.latitude));
      final polylinePoints =
          await mapService.getDirections(origin, destination);

      if (!mounted) return;

      mapBloc.add(ExportDirections(polylinePoints));
    }
  }

  void _startListening() async {
    try {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          debugPrint('Speech recognition status: $val');
          if (mounted) {
            setState(() {
              _isListening = val == 'listening';
            });
          }
        },
        onError: (val) => debugPrint('Speech recognition error: $val'),
      );
      if (available) {
        if (mounted) {
          setState(() => _isListening = true);
        }
        await _speechToText.listen(
          onResult: (SpeechRecognitionResult result) {
            if (mounted) {
              setState(() {
                _searchController.text = result.recognizedWords;
                _filterTournaments(result.recognizedWords);
              });
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          listenOptions: stt.SpeechListenOptions(
            partialResults: true,
          ),
        );
      } else {
        debugPrint('Speech recognition not available');
      }
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
    }
  }

  void _stopListening() {
    if (mounted) {
      setState(() => _isListening = false);
    }
    _speechToText.stop();
  }

  void _centerOnCurrentLocation() async {
    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Les services de localisation ne sont pas activés.');
      return;
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        debugPrint('Les permissions de localisation sont refusées.');
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      debugPrint('Les permissions de localisation sont refusées à jamais.');
      return;
    }

    geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    final currentPoint = Point(
      coordinates: Position(
        position.longitude,
        position.latitude,
      ),
    );

    if (_isMapInitialized()) {
      _mapboxMap.flyTo(
        CameraOptions(center: currentPoint, zoom: 14.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
      debugPrint(
          "Camera moved to: Lat ${currentPoint.coordinates.lat}, Lon ${currentPoint.coordinates.lng}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(
        mapService: RepositoryProvider.of<MapService>(context),
      ),
      child: BlocConsumer<MapBloc, MapState>(
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
              debugPrint(
                  "Camera moved to: Lat ${state.position.coordinates.lat}, Lon ${state.position.coordinates.lng}");
            }
          } else if (state is DirectionsLoaded) {
            context
                .read<MapBloc>()
                .add(UpdateMarkers(widget.tournaments, _showTournamentDetails));
          } else if (state is MapInitialized) {
            context
                .read<MapBloc>()
                .add(LoadMap(widget.tournaments, _showTournamentDetails));
            context
                .read<MapBloc>()
                .add(UpdateMarkers(widget.tournaments, _showTournamentDetails));
            _centerOnCurrentLocation();
          } else if (state is MarkerTappedState) {
            _showTournamentDetails(state.tournament);
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        setState(() {
                          _searching = false;
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
            ),
            body: Stack(
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
                    controller.style.getStyleURI().then((_) {
                      debugPrint("Map style fully loaded");
                      context.read<MapBloc>().add(UpdateMarkers(
                          widget.tournaments, _showTournamentDetails));
                    });
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
                                      itemCount: _searchController.text.isEmpty
                                          ? _recentSearches.length
                                          : _filteredTournaments.length,
                                      itemBuilder: (context, index) {
                                        if (_searchController.text.isEmpty) {
                                          return ListTile(
                                            leading: const Icon(Icons.history),
                                            title: Text(_recentSearches[index]),
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
                                                debugPrint(
                                                    "Added test marker at Lat ${tournament.latitude}, Lon ${tournament.longitude}");
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
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            child: const Icon(Icons.zoom_in),
                          ),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            heroTag: 'zoomOutButton',
                            onPressed: () =>
                                context.read<MapBloc>().add(ZoomOut()),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            child: const Icon(Icons.zoom_out),
                          ),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            heroTag: 'locationButton',
                            onPressed: () => context
                                .read<MapBloc>()
                                .add(CenterOnCurrentLocation()),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            child: const Icon(Icons.my_location),
                          ),
                          const SizedBox(height: 10),
                          FloatingActionButton(
                            heroTag: 'toggle3DButton',
                            onPressed: () =>
                                context.read<MapBloc>().add(Toggle3DView()),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            child: const Icon(Icons.threed_rotation),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
