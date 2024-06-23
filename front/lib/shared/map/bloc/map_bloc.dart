import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uresport/core/services/map_service.dart';
import 'package:uresport/shared/map/bloc/map_event.dart';
import 'package:uresport/shared/map/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService mapService;
  GoogleMapController? _mapController;
  BitmapDescriptor? trophyIcon;

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
    try {
      await _createCustomMarkerIcon();
      final currentPosition = await mapService.getCurrentLocation();
      final markers = event.tournaments.map((tournament) {
        return Marker(
          markerId: MarkerId(tournament.id.toString()),
          position: LatLng(tournament.latitude, tournament.longitude),
          onTap: () => event.onMarkerTapped(tournament),
          icon: trophyIcon!,
          infoWindow: InfoWindow(
            title: tournament.name,
          ),
        );
      }).toSet();
      emit(MapLoaded(position: currentPosition, tournaments: event.tournaments, mapMarkers: markers));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onUpdateMarkers(UpdateMarkers event, Emitter<MapState> emit) {
    final markers = event.tournaments.map((tournament) {
      return Marker(
        markerId: MarkerId(tournament.id.toString()),
        position: LatLng(tournament.latitude, tournament.longitude),
        onTap: () => event.onMarkerTapped(tournament),
        icon: trophyIcon!,
        infoWindow: InfoWindow(
          title: tournament.name,
        ),
      );
    }).toSet();
    emit(MarkersUpdated(mapMarkers: markers));
  }

  void _onShowDirections(ShowDirections event, Emitter<MapState> emit) async {
    final polylinePoints = await mapService.getDirections(event.origin, event.destination);
    emit(DirectionsLoaded(polylinePoints: polylinePoints, mapMarkers: const {}));
  }

  void _onZoomIn(ZoomIn event, Emitter<MapState> emit) {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _onZoomOut(ZoomOut event, Emitter<MapState> emit) {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _onCenterOnCurrentLocation(CenterOnCurrentLocation event, Emitter<MapState> emit) async {
    final currentPosition = await mapService.getCurrentLocation();
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  void _onSetMapController(SetMapController event, Emitter<MapState> emit) {
    _mapController = event.controller;
  }

  Future<void> _createCustomMarkerIcon() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 100.0;
    final Paint paint = Paint()..color = Colors.white;


    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);


    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    const IconData iconData = Icons.emoji_events;
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size / 2,
        fontFamily: iconData.fontFamily,
        color: Colors.yellow,
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
          (size - textPainter.width) / 2,
          (size - textPainter.height) / 2,
        ));

    final img = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    trophyIcon = BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }
}
