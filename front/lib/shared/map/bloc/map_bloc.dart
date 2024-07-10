import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';

extension PointExtension on MapBloc {
  Point? createPoint(double? longitude, double? latitude) {
    if (longitude == null || latitude == null) return null;
    return Point(coordinates: Position(longitude, latitude));
  }
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService mapService;
  MapboxMap? _mapboxMap;

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
            return createPoint(loc['longitude'], loc['latitude']);
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

      if (_mapboxMap != null) {
        add(UpdateMarkers(event.tournaments, event.onMarkerTapped));
      }
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<String> _createMaterialIconAsBase64() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = ui.Size(48, 48);
    const iconData = Icons.location_on;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 48,
        fontFamily: iconData.fontFamily,
        color: Colors.red,
      ),
    );

    textPainter.layout();
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(xCenter, yCenter));

    final picture = pictureRecorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    return base64Encode(buffer);
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) async {
    if (_mapboxMap != null) {
      try {
        final pointAnnotationManager =
            await _mapboxMap!.annotations.createPointAnnotationManager();
        await pointAnnotationManager.deleteAll();

        final iconImage = await _createMaterialIconAsBase64();

        var options = <PointAnnotationOptions>[];
        for (var tournament in event.tournaments) {
          final point = Point(
              coordinates: Position(tournament.longitude, tournament.latitude));
          const iconSize = 1.5;
          options.add(PointAnnotationOptions(
            geometry: point,
            iconImage: 'data:image/png;base64,$iconImage',
            iconSize: iconSize,
            iconOffset: [0, -20],
            textField: tournament.name,
            textOffset: [0, 2],
            textColor: Colors.black.value,
            textSize: 12,
          ));
        }

        if (options.isNotEmpty) {
          final createdAnnotations =
              await pointAnnotationManager.createMulti(options);
          developer.log("Created ${createdAnnotations.length} annotations");
        }

        pointAnnotationManager.addOnPointAnnotationClickListener(
          PointAnnotationClickListener(event.tournaments, this),
        );

        emit(MarkersUpdated(mapMarkers: options));
      } catch (e) {
        developer.log("Error updating markers: $e");
        emit(MapError("Failed to update markers: $e"));
      }
    } else {
      developer.log("MapboxMap is null");
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
    developer.log('Début de _onCenterOnCurrentLocation');

    if (!mapService.isMapInitialized() || _mapboxMap == null) {
      developer.log('La carte n\'est pas initialisée');
      emit(const MapError('La carte n\'est pas initialisée'));
      return;
    }

    try {
      bool serviceEnabled;
      geo.LocationPermission permission;

      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        developer.log('Les services de localisation ne sont pas activés.');
        emit(const MapError(
            'Les services de localisation ne sont pas activés.'));
        return;
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          developer.log('Les permissions de localisation sont refusées.');
          emit(
              const MapError('Les permissions de localisation sont refusées.'));
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        developer
            .log('Les permissions de localisation sont refusées à jamais.');
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
        emit(MapCentered());
      }
    } catch (e) {
      developer.log('Erreur lors du centrage de la carte : $e');
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
}

class PointAnnotationClickListener implements OnPointAnnotationClickListener {
  final List tournaments;
  final MapBloc mapBloc;

  PointAnnotationClickListener(this.tournaments, this.mapBloc);

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final tournament = tournaments.firstWhere(
      (t) =>
          t.longitude == annotation.geometry.coordinates[0] &&
          t.latitude == annotation.geometry.coordinates[1],
    );
    mapBloc.add(MarkerTapped(tournament));
    return true;
  }
}
