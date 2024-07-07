import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';

extension PointExtension on MapBloc {
  Point createPoint(double longitude, double latitude) {
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
  }

  void _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    print('_onLoadMap called');
    if (!mapService.isMapInitialized()) {
      emit(const MapError('Map is not initialized'));
      return;
    }
    try {
      print('Fetching current location...');
      final currentLocation = await mapService.getCurrentLocation();
      final currentPoint = createPoint(currentLocation['longitude']!.toDouble(),
          currentLocation['latitude']!.toDouble());
      final markers = event.tournaments.map((tournament) {
        return PointAnnotationOptions(
          geometry: createPoint(tournament.longitude, tournament.latitude),
          textField: tournament.name,
        );
      }).toList();
      emit(MapLoaded(
          position: currentPoint,
          tournaments: event.tournaments,
          mapMarkers: markers));
      print('Map loaded successfully');
    } catch (e) {
      print('Error loading map: $e');
      emit(MapError(e.toString()));
    }
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) async {
    print('_onUpdateMarkers called');
    final markers = event.tournaments.map((tournament) {
      return PointAnnotationOptions(
        geometry: createPoint(tournament.longitude, tournament.latitude),
        textField: tournament.name,
      );
    }).toList();
    emit(MarkersUpdated(mapMarkers: markers));
    print('Markers updated successfully');
  }

  void _onShowDirections(ShowDirections event, Emitter<MapState> emit) async {
    print('_onShowDirections called');
    try {
      final polylinePoints =
          await mapService.getDirections(event.origin, event.destination);
      emit(DirectionsLoaded(
          polylinePoints: polylinePoints, mapMarkers: const []));
      print('Directions loaded successfully');
    } catch (e) {
      print('Error loading directions: $e');
      emit(MapError(e.toString()));
    }
  }

  void _onZoomIn(ZoomIn event, Emitter<MapState> emit) {
    print('_onZoomIn called');
    // Implement zoom in logic
  }

  void _onZoomOut(ZoomOut event, Emitter<MapState> emit) {
    print('_onZoomOut called');
    // Implement zoom out logic
  }

  void _onCenterOnCurrentLocation(
      CenterOnCurrentLocation event, Emitter<MapState> emit) async {
    print('_onCenterOnCurrentLocation called');
    // Implement center on current location logic
  }

  void _onSetMapController(
      SetMapController event, Emitter<MapState> emit) async {
    print('Initializing map controller...');
    await mapService.initializeMap(event.controller);
    emit(MapInitialized());
    print('Map initialized');
  }
}
