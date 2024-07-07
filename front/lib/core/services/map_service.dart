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
    print('initializeMap called');
    _mapboxMap = map;
    print('Map initialized: $_mapboxMap');

    try {
      await _mapboxMap!.location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          pulsingEnabled: true,
        ),
      );
      print('Location settings updated');
    } catch (e) {
      print('Failed to update location settings: $e');
      throw Exception('Failed to update location settings');
    }
  }

  @override
  bool isMapInitialized() {
    print('isMapInitialized called, _mapboxMap: $_mapboxMap');
    return _mapboxMap != null;
  }

  @override
  Future<Map<String, double>> getCurrentLocation() async {
    print('getCurrentLocation called');
    if (!isMapInitialized()) {
      throw Exception('Map is not initialized');
    }
    final locationComponent = _mapboxMap!.location;
    final locationSettings = await locationComponent.getSettings();
    if (locationSettings.enabled ?? false) {
      final cameraState = await _mapboxMap!.getCameraState();
      final center = cameraState.center;
      print(
          'Current location: latitude=${center.coordinates[1]}, longitude=${center.coordinates[0]}');
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
    print('getDirections called');
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
      print('Directions retrieved successfully');
      return coordinates
          .map<List<double>>(
              (coord) => [coord[1] as double, coord[0] as double])
          .toList();
    } else {
      print('Failed to load directions, status code: ${response.statusCode}');
      throw Exception('Failed to load directions');
    }
  }
}
