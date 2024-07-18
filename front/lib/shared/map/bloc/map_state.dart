import 'package:equatable/equatable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapInitialized extends MapState {}

class MapLoaded extends MapState {
  final Point position;
  final List<Tournament> tournaments;
  final List<Tournament> mapMarkers;

  const MapLoaded(
      {required this.position,
      required this.tournaments,
      required this.mapMarkers});

  @override
  List<Object?> get props => [position, tournaments, mapMarkers];
}

class DirectionsLoaded extends MapState {
  final List<List<double>> polylinePoints;
  final List<Tournament> mapMarkers;

  const DirectionsLoaded(
      {required this.polylinePoints, required this.mapMarkers});

  @override
  List<Object?> get props => [polylinePoints, mapMarkers];
}

class MarkersUpdated extends MapState {
  final List<Tournament> mapMarkers;

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

class MarkerTappedState extends MapState {
  final Tournament tournament;

  const MarkerTappedState({required this.tournament});

  @override
  List<Object?> get props => [tournament];
}

class DirectionsExported extends MapState {}

class MapCentered extends MapState {}
