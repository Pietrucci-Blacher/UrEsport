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
      if (_mapboxMap != null) {
        final pointAnnotationManager =
            await _mapboxMap!.annotations.createPointAnnotationManager();
        for (var marker in markers) {
          if (marker != null) {
            await pointAnnotationManager.create(marker);
          }
        }
      }
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
    print('Début de _onCenterOnCurrentLocation');

    if (!mapService.isMapInitialized() || _mapboxMap == null) {
      print('La carte n\'est pas initialisée');
      emit(const MapError('La carte n\'est pas initialisée'));
      return;
    }

    try {
      print('Mise à jour des paramètres de localisation');
      await _mapboxMap!.location.updateSettings(
        LocationComponentSettings(
            enabled: true, pulsingEnabled: true, puckBearingEnabled: true),
      );

      print('Récupération de la couche de localisation');
      Layer? layer;
      if (Platform.isAndroid) {
        layer =
            await _mapboxMap!.style.getLayer("mapbox-location-indicator-layer");
      } else {
        layer = await _mapboxMap!.style.getLayer("puck");
      }

      if (layer is LocationIndicatorLayer) {
        var location = layer.location;
        if (location != null && location.length >= 2) {
          final lat = location[1];
          final lng = location[0];

          print('Coordonnées obtenues : lat=$lat, lng=$lng');

          if (lat != null &&
              lng != null &&
              lat >= -90 &&
              lat <= 90 &&
              lng >= -180 &&
              lng <= 180) {
            final currentPoint = Point(coordinates: Position(lng, lat));

            print('Centrage de la carte dans 500ms');
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mapService.isMapInitialized()) {
                try {
                  print('Tentative de flyTo');
                  _mapboxMap!.flyTo(
                    CameraOptions(center: currentPoint, zoom: 14.0),
                    MapAnimationOptions(duration: 2000, startDelay: 0),
                  );
                  print('flyTo réussi');
                  emit(MapCentered());
                } catch (e) {
                  print('Erreur lors de flyTo : $e');
                  try {
                    print('Tentative de setCamera');
                    _mapboxMap!.setCamera(
                      CameraOptions(center: currentPoint, zoom: 14.0),
                    );
                    print('setCamera réussi');
                    emit(MapCentered());
                  } catch (e) {
                    print('Erreur lors de setCamera : $e');
                    emit(MapError('Impossible de centrer la carte : $e'));
                  }
                }
              } else {
                print('La carte n\'est pas prête après le délai');
                emit(const MapError('La carte n\'est pas prête'));
              }
            });
          } else {
            print('Coordonnées invalides : lat=$lat, lng=$lng');
            emit(const MapError('Coordonnées invalides'));
          }
        } else {
          print('Données de localisation invalides');
          emit(const MapError('Données de localisation invalides'));
        }
      } else {
        print('Impossible d\'obtenir la couche de localisation');
        emit(const MapError('Impossible d\'obtenir la couche de localisation'));
      }
    } catch (e) {
      print('Erreur lors du centrage de la carte : $e');
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
