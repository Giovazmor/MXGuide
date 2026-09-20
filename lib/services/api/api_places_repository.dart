import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../../models/category.dart';
import '../../models/place.dart';
import '../../models/state_model.dart';
import '../repositories/places_repository.dart';

/// Implementación real usando el backend NestJS (documentación sección 5,
/// GET /places, /places/:id, /places/featured, /places/nearby,
/// /categories, /states).
class ApiPlacesRepository implements PlacesRepository {
  final http.Client _client;
  ApiPlacesRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);
  }

  @override
  Future<List<PlaceCategory>> getCategories() async {
    final response = await _client.get(_uri('/categories'));
    _checkOk(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => PlaceCategory.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<PlaceState>> getStates() async {
    final response = await _client.get(_uri('/states'));
    _checkOk(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => PlaceState.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Place>> getPlaces({String? categoryId, String? stateId, String? search}) async {
    final query = <String, String>{};
    if (categoryId != null) query['category'] = categoryId;
    if (stateId != null) query['stateId'] = stateId;
    if (search != null && search.isNotEmpty) query['search'] = search;

    final response = await _client.get(_uri('/places', query));
    _checkOk(response);
    return _parsePlaceList(response.body);
  }

  @override
  Future<Place> getPlaceById(String id) async {
    final response = await _client.get(_uri('/places/$id'));
    _checkOk(response);
    return Place.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<List<Place>> getFeatured({int limit = 10}) async {
    final response = await _client.get(_uri('/places/featured', {'limit': '$limit'}));
    _checkOk(response);
    return _parsePlaceList(response.body);
  }

  @override
  Future<List<Place>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
    int limit = 20,
  }) async {
    final response = await _client.get(_uri('/places/nearby', {
      'lat': '$lat',
      'lng': '$lng',
      'radius': '$radiusKm',
      'limit': '$limit',
    }));
    _checkOk(response);
    return _parsePlaceList(response.body);
  }

  List<Place> _parsePlaceList(String body) {
    final decoded = jsonDecode(body);
    // GET /places es paginado (page, limit); soportamos tanto una lista
    // plana como { data: [...] } por si el backend envuelve la paginación.
    final list = decoded is Map<String, dynamic> ? decoded['data'] as List<dynamic> : decoded as List<dynamic>;
    return list.map((e) => Place.fromJson(e as Map<String, dynamic>)).toList();
  }

  void _checkOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error del servidor (${response.statusCode})');
    }
  }
}
