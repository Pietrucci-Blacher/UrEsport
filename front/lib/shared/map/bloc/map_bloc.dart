import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
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

  MapBloc({required this.mapService}) : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateMarkers>(_onUpdateMarkers);
    on<ShowDirections>(_onShowDirections);
    on<ZoomIn>(_onZoomIn);
    on<ZoomOut>(_onZoomOut);
    on<CenterOnCurrentLocation>(_onCenterOnCurrentLocation);
    on<SetMapController>(_onSetMapController);
    on<Toggle3DView>(_onToggle3DView);
    on<MarkerTapped>(_onMarkerTapped); // Added for marker tap handling
    on<ExportDirections>(_onExportDirections); // Added for export directions
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

      final markers = event.tournaments
          .map((tournament) {
            final point =
                createPoint(tournament.longitude, tournament.latitude);
            if (point == null) return null;
            return PointAnnotationOptions(
              geometry: point,
              textField: tournament.name,
            );
          })
          .where((marker) => marker != null)
          .toList();

      emit(MapLoaded(
        position: currentPoint,
        tournaments: event.tournaments,
        mapMarkers: markers.cast<PointAnnotationOptions>(),
      ));

      mapService.flyTo(
        CameraOptions(center: currentPoint, zoom: 14.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) async {
    final markers = event.tournaments
        .map((tournament) {
          final point = createPoint(tournament.longitude, tournament.latitude);
          if (point == null) return null;
          return PointAnnotationOptions(
            geometry: point,
            textField: tournament.name,
          );
        })
        .where((marker) => marker != null)
        .toList();
    emit(MarkersUpdated(mapMarkers: markers.cast<PointAnnotationOptions>()));
  }

  void _onShowDirections(ShowDirections event, Emitter<MapState> emit) async {
    try {
      final polylinePoints =
          await mapService.getDirections(event.origin, event.destination);
      final points = polylinePoints.map((coords) {
        return Point(coordinates: Position(coords[1], coords[0]));
      }).toList();

      mapService.addPolyline(points); // Add polyline to map

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
    if (mapService.isMapInitialized()) {
      try {
        final currentLocation = await mapService.getCurrentLocation();
        final point = createPoint(
            currentLocation['longitude'], currentLocation['latitude']);
        if (point == null) {
          emit(const MapError('Invalid current location'));
          return;
        }
        mapService.flyTo(CameraOptions(center: point, zoom: 14.0),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      } catch (e) {
        emit(MapError(e.toString()));
      }
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
    await mapService.initializeMap(event.controller);
    emit(MapInitialized());
  }

  void _onExportDirections(
      ExportDirections event, Emitter<MapState> emit) async {
    try {
      final String gpxData = _generateGpx(event.polylinePoints);
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File gpxFile = File('$tempPath/itineraire.gpx');
      await gpxFile.writeAsString(gpxData);

      // Utiliser Share.shareXFiles au lieu de Share.shareFiles
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
