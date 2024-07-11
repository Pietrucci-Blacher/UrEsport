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
    if (!mapService.isMapInitialized()) {
      emit(const MapError('Map is not initialized'));
      return;
    }
    try {
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
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) async {
    final markers = event.tournaments.map((tournament) {
      return PointAnnotationOptions(
        geometry: createPoint(tournament.longitude, tournament.latitude),
        textField: tournament.name,
      );
    }).toList();
    emit(MarkersUpdated(mapMarkers: markers));
  }

  void _onShowDirections(ShowDirections event, Emitter<MapState> emit) async {
    final polylinePoints =
        await mapService.getDirections(event.origin, event.destination);
    emit(
        DirectionsLoaded(polylinePoints: polylinePoints, mapMarkers: const []));
  }

  void _onZoomIn(ZoomIn event, Emitter<MapState> emit) {
    // Implement zoom in logic
  }

  void _onZoomOut(ZoomOut event, Emitter<MapState> emit) {}

  void _onCenterOnCurrentLocation(
      CenterOnCurrentLocation event, Emitter<MapState> emit) async {}

  void _onSetMapController(
      SetMapController event, Emitter<MapState> emit) async {
    await mapService.initializeMap(event.controller);
    emit(MapInitialized());
  }
}
