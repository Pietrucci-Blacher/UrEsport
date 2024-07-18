import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';

class CustomPointAnnotationClickListener
    extends OnPointAnnotationClickListener {
  final bool Function(PointAnnotation) onTap;

  CustomPointAnnotationClickListener({required this.onTap});

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    return onTap(annotation);
  }
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService mapService;
  MapboxMap? _mapboxMap;
  final Map<String, Tournament> _annotationIdToTournament = {};
  bool _isProcessingTap = false;
  Timer? _debounceTimer;

  MapBloc({required this.mapService}) : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateMarkers>(_onUpdateMarkers);
    on<ShowDirections>(_onShowDirections);
    on<ZoomIn>(_onZoomIn);
    on<ZoomOut>(_onZoomOut);
    on<CenterOnCurrentLocation>(_onCenterOnCurrentLocation);
    on<SetMapController>(_onSetMapController);
    on<Toggle3DView>(_onToggle3DView);
    on<MarkerTapped>(_onMarkerTapped);
    on<ExportDirections>(_onExportDirections);
  }

  void _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    if (!mapService.isMapInitialized()) {
      emit(const MapError('Map is not initialized'));
      return;
    }
    try {
      final puckPosition = await mapService.getPuckPosition();
      final currentPoint = puckPosition ??
          await mapService.getCurrentLocation().then((loc) {
            return Point(
                coordinates: Position(loc['longitude']!, loc['latitude']!));
          });

      if (currentPoint == null) {
        emit(const MapError('Invalid current location'));
        return;
      }

      emit(MapLoaded(
        position: currentPoint,
        tournaments: event.tournaments,
        mapMarkers: const [],
      ));

      mapService.flyTo(
        CameraOptions(center: currentPoint, zoom: 14.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
      debugPrint(
          "Camera moved to: Lat ${currentPoint.coordinates.lat}, Lon ${currentPoint.coordinates.lng}");

      if (_mapboxMap != null) {
        add(UpdateMarkers(event.tournaments, event.onMarkerTapped));
      }
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<Uint8List> _createCustomMarker(String name) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = ui.Size(200, 80);

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(10)),
        backgroundPaint);

    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.emoji_events.codePoint),
        style: TextStyle(
          fontSize: 40,
          color: Colors.yellow,
          fontFamily: Icons.emoji_events.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
        canvas, Offset(10, (size.height - iconPainter.height) / 2));

    final textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.width - 60);
    textPainter.paint(
        canvas, Offset(60, (size.height - textPainter.height) / 2));

    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) async {
    if (_mapboxMap != null) {
      try {
        final pointAnnotationManager =
            await _mapboxMap!.annotations.createPointAnnotationManager();
        await pointAnnotationManager.deleteAll();

        _annotationIdToTournament.clear();

        for (var tournament in event.tournaments) {
          final markerImage = await _createCustomMarker(tournament.name);

          final options = PointAnnotationOptions(
            geometry: Point(
                coordinates:
                    Position(tournament.longitude, tournament.latitude)),
            image: markerImage,
            iconSize: 1.0,
          );

          final annotation = await pointAnnotationManager.create(options);
          _annotationIdToTournament[annotation.id] = tournament;
        }

        final listener = CustomPointAnnotationClickListener(
          onTap: (PointAnnotation clickedAnnotation) {
            if (_isProcessingTap) return false;
            _isProcessingTap = true;

            _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 300), () {
              debugPrint('Annotation cliquée : ${clickedAnnotation.id}');
              final tournament =
                  _annotationIdToTournament[clickedAnnotation.id];
              if (tournament != null) {
                debugPrint(
                    'Annotation correcte cliquée : ${clickedAnnotation.id}');
                event.onMarkerTapped(tournament);
              }
              _isProcessingTap = false;
            });
            return true;
          },
        );

        pointAnnotationManager.addOnPointAnnotationClickListener(listener);

        emit(MarkersUpdated(mapMarkers: event.tournaments));
      } catch (e) {
        debugPrint("Error updating markers: $e");
        emit(MapError("Failed to update markers: $e"));
      }
    } else {
      debugPrint("MapboxMap is null");
      emit(const MapError("MapboxMap is not initialized"));
    }
  }

  void _onShowDirections(ShowDirections event, Emitter<MapState> emit) async {
    try {
      final polylinePoints =
          await mapService.getDirections(event.origin, event.destination);
      final points = polylinePoints.map((coords) {
        return Point(coordinates: Position(coords[1], coords[0]));
      }).toList();

      mapService.addPolyline(points);

      emit(DirectionsLoaded(
          polylinePoints: polylinePoints, mapMarkers: const []));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onZoomIn(ZoomIn event, Emitter<MapState> emit) async {
    if (mapService.isMapInitialized()) {
      final cameraState = await mapService.getCameraState();
      mapService.setCamera(CameraOptions(zoom: cameraState.zoom + 1));
    }
  }

  void _onZoomOut(ZoomOut event, Emitter<MapState> emit) async {
    if (mapService.isMapInitialized()) {
      final cameraState = await mapService.getCameraState();
      mapService.setCamera(CameraOptions(zoom: cameraState.zoom - 1));
    }
  }

  void _onCenterOnCurrentLocation(
      CenterOnCurrentLocation event, Emitter<MapState> emit) async {
    debugPrint('Début de _onCenterOnCurrentLocation');

    if (!mapService.isMapInitialized() || _mapboxMap == null) {
      debugPrint('La carte n\'est pas initialisée');
      emit(const MapError('La carte n\'est pas initialisée'));
      return;
    }

    try {
      bool serviceEnabled;
      geo.LocationPermission permission;

      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Les services de localisation ne sont pas activés.');
        emit(const MapError(
            'Les services de localisation ne sont pas activés.'));
        return;
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          debugPrint('Les permissions de localisation sont refusées.');
          emit(
              const MapError('Les permissions de localisation sont refusées.'));
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        debugPrint('Les permissions de localisation sont refusées à jamais.');
        emit(const MapError(
            'Les permissions de localisation sont refusées à jamais.'));
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

      if (_mapboxMap != null) {
        _mapboxMap!.flyTo(
          CameraOptions(center: currentPoint, zoom: 14.0),
          MapAnimationOptions(duration: 2000, startDelay: 0),
        );
        debugPrint(
            "Camera moved to: Lat ${currentPoint.coordinates.lat}, Lon ${currentPoint.coordinates.lng}");
        emit(MapCentered());
      }
    } catch (e) {
      debugPrint('Erreur lors du centrage de la carte : $e');
      emit(MapError('Erreur lors du centrage de la carte: ${e.toString()}'));
    }
  }

  void _onToggle3DView(Toggle3DView event, Emitter<MapState> emit) async {
    if (mapService.isMapInitialized()) {
      final cameraState = await mapService.getCameraState();
      final is3D = cameraState.pitch > 0 || cameraState.bearing > 0;
      mapService.setCamera(
          CameraOptions(pitch: is3D ? 0 : 60, bearing: is3D ? 0 : 80));
    }
  }

  void _onMarkerTapped(MarkerTapped event, Emitter<MapState> emit) async {
    final tournament = event.tournament;
    emit(MarkerTappedState(tournament: tournament));
  }

  void _onSetMapController(
      SetMapController event, Emitter<MapState> emit) async {
    _mapboxMap = event.controller;
    await mapService.initializeMap(event.controller);
    emit(MapInitialized());
    add(CenterOnCurrentLocation());
    if (state is MapLoaded) {
      add(LoadMap(
        (state as MapLoaded).tournaments,
        (tournament) => add(MarkerTapped(tournament)),
      ));
      add(UpdateMarkers((state as MapLoaded).tournaments,
          (tournament) => add(MarkerTapped(tournament))));
    }
  }

  void _onExportDirections(
      ExportDirections event, Emitter<MapState> emit) async {
    try {
      final String gpxData = _generateGpx(event.polylinePoints);
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File gpxFile = File('$tempPath/itineraire.gpx');
      await gpxFile.writeAsString(gpxData);

      await Share.shareXFiles([XFile(gpxFile.path)],
          text: 'Voici l\'itinéraire');
      emit(DirectionsExported());
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  String _generateGpx(List<List<double>> polylinePoints) {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<gpx version="1.1" creator="Mapbox">');
    buffer.writeln('<trk><trkseg>');
    for (var point in polylinePoints) {
      buffer.writeln('<trkpt lat="${point[0]}" lon="${point[1]}"></trkpt>');
    }
    buffer.writeln('</trkseg></trk>');
    buffer.writeln('</gpx>');
    return buffer.toString();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
