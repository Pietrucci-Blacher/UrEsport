import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class IMapService {
  Future<Map<String, double>> getCurrentLocation();
  Future<List<List<double>>> getDirections(Point origin, Point destination);
  Future<void> initializeMap(MapboxMap map);
  bool isMapInitialized();
  Future<CameraState> getCameraState();
  void setCamera(CameraOptions options);
  void flyTo(CameraOptions options, MapAnimationOptions animationOptions);
  Future<Point?> getPuckPosition();
  void addPolyline(List<Point> points);
}

class MapService implements IMapService {
  final Dio dio;
  final String mapboxApiKey;
  MapboxMap? _mapboxMap;

  MapService({
    required this.dio,
    required this.mapboxApiKey,
  });

  @override
  Future<void> initializeMap(MapboxMap map) async {
    _mapboxMap = map;
    await _mapboxMap!.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: Colors.blue.value,
      ),
    );
  }

  @override
  bool isMapInitialized() {
    return _mapboxMap != null;
  }

  @override
  Future<Map<String, double>> getCurrentLocation() async {
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }
    final locationComponent = _mapboxMap!.location;
    final locationSettings = await locationComponent.getSettings();
    if (locationSettings.enabled ?? false) {
      final cameraState = await _mapboxMap!.getCameraState();
      final center = cameraState.center;
      return {
        'latitude': center.coordinates[1]!.toDouble(),
        'longitude': center.coordinates[0]!.toDouble(),
      };
    } else {
      throw Exception('Location is not enabled');
    }
  }

  @override
  Future<List<List<double>>> getDirections(
      Point origin, Point destination) async {
    final originPosition = origin.coordinates;
    final destinationPosition = destination.coordinates;

    final response = await dio.get(
      'https://api.mapbox.com/directions/v5/mapbox/driving/${originPosition[0]},${originPosition[1]};${destinationPosition[0]},${destinationPosition[1]}',
      queryParameters: {
        'geometries': 'geojson',
        'access_token': mapboxApiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      return coordinates
          .map<List<double>>(
              (coord) => [coord[1] as double, coord[0] as double])
          .toList();
    } else {
      throw Exception('Failed to load directions');
    }
  }

  @override
  Future<CameraState> getCameraState() async {
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }
    return await _mapboxMap!.getCameraState();
  }

  @override
  void setCamera(CameraOptions options) {
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }
    _mapboxMap!.setCamera(options);
  }

  @override
  void flyTo(CameraOptions options, MapAnimationOptions animationOptions) {
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }
    _mapboxMap!.flyTo(options, animationOptions);
  }

  @override
  Future<Point?> getPuckPosition() async {
    if (!isMapInitialized()) {
      return null;
    }

    final style = _mapboxMap!.style;
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await style.getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await style.getLayer("puck");
    }
    if (layer is LocationIndicatorLayer) {
      final location = layer.location;
      if (location != null && location.length >= 2) {
        final longitude = location[0];
        final latitude = location[1];
        if (longitude != null && latitude != null) {
          return Point(coordinates: Position(longitude, latitude));
        }
      }
    }
    return null;
  }

  @override
  void addPolyline(List<Point> points) {
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }

    final lineString = LineString(
      coordinates: points.map((point) => point.coordinates).toList(),
    );

    // Convert LineString to GeoJSON string
    final geoJson = jsonEncode({
      'type': 'Feature',
      'properties': {},
      'geometry': {
        'type': 'LineString',
        'coordinates': lineString.coordinates
            .map((coord) => [coord.lng, coord.lat])
            .toList(),
      }
    });

    final lineLayerId =
        'polyline-layer-${DateTime.now().millisecondsSinceEpoch}';
    final lineSourceId =
        'polyline-source-${DateTime.now().millisecondsSinceEpoch}';

    _mapboxMap!.style.addSource(GeoJsonSource(id: lineSourceId, data: geoJson));

    _mapboxMap!.style.addLayer(LineLayer(
      id: lineLayerId,
      sourceId: lineSourceId,
      lineColor: const Color(0xFFFF0000).value,
      lineWidth: 5.0,
    ));
  }
}
