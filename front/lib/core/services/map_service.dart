import 'package:dio/dio.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class IMapService {
  Future<Map<String, double>> getCurrentLocation();
  Future<List<List<double>>> getDirections(Point origin, Point destination);
  Future<void> initializeMap(MapboxMap map);
  bool isMapInitialized();
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
}
