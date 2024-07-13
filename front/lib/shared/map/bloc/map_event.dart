import 'package:equatable/equatable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:uresport/core/models/tournament.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class LoadMap extends MapEvent {
  final List<Tournament> tournaments;
  final Function(Tournament) onMarkerTapped;

  const LoadMap(this.tournaments, this.onMarkerTapped);

  @override
  List<Object> get props => [tournaments, onMarkerTapped];
}

class UpdateMarkers extends MapEvent {
  final List<Tournament> tournaments;
  final Function(Tournament) onMarkerTapped;

  const UpdateMarkers(this.tournaments, this.onMarkerTapped);

  @override
  List<Object> get props => [tournaments, onMarkerTapped];
}

class ShowDirections extends MapEvent {
  final Point origin;
  final Point destination;

  const ShowDirections(this.origin, this.destination);

  @override
  List<Object> get props => [origin, destination];
}

class ZoomIn extends MapEvent {}

class ZoomOut extends MapEvent {}

class CenterOnCurrentLocation extends MapEvent {}

class Toggle3DView extends MapEvent {}

class SetMapController extends MapEvent {
  final MapboxMap controller;

  const SetMapController(this.controller);

  @override
  List<Object> get props => [controller];
}

class MarkerTapped extends MapEvent {
  final Tournament tournament;

  const MarkerTapped(this.tournament);

  @override
  List<Object> get props => [tournament];
}

class ExportDirections extends MapEvent {
  final List<List<double>> polylinePoints;

  const ExportDirections(this.polylinePoints);

  @override
  List<Object> get props => [polylinePoints];
}
