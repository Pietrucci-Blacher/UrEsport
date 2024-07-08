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

class SetMapController extends MapEvent {
  final MapboxMap controller;

  const SetMapController(this.controller);

  @override
  List<Object> get props => [controller];
}
