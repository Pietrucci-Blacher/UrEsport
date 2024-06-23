import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoaded extends MapState {
  final Position position;
  final List<Tournament> tournaments;
  final Set<Marker> mapMarkers;

  const MapLoaded({required this.position, required this.tournaments, required this.mapMarkers});

  @override
  List<Object?> get props => [position, tournaments, mapMarkers];
}

class DirectionsLoaded extends MapState {
  final List<LatLng> polylinePoints;
  final Set<Marker> mapMarkers;

  const DirectionsLoaded({required this.polylinePoints, required this.mapMarkers});

  @override
  List<Object?> get props => [polylinePoints, mapMarkers];
}

class MarkersUpdated extends MapState {
  final Set<Marker> mapMarkers;

  const MarkersUpdated({required this.mapMarkers});

  @override
  List<Object?> get props => [mapMarkers];
}

class MapError extends MapState {
  final String error;

  const MapError(this.error);

  @override
  List<Object?> get props => [error];
}
