import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../repositories/favorites_repository.dart';

/// Implementación real usando el backend NestJS (documentación sección 5,
/// GET/POST /favorites, DELETE /favorites/:placeId — requiere JWT).
class ApiFavoritesRepository implements FavoritesRepository {
  final http.Client _client;
  ApiFavoritesRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  @override
  Future<List<String>> getFavoritePlaceIds(String token) async {
    final response = await _client.get(_uri('/favorites'), headers: _headers(token));
    if (response.statusCode != 200) {
      throw Exception('No se pudieron cargar los favoritos (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) {
      if (e is Map<String, dynamic>) return e['placeId'].toString();
      return e.toString();
    }).toList();
  }

  @override
  Future<void> addFavorite(String token, String placeId) async {
    final response = await _client.post(
      _uri('/favorites'),
      headers: _headers(token),
      body: jsonEncode({'placeId': placeId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('No se pudo agregar a favoritos (${response.statusCode})');
    }
  }

  @override
  Future<void> removeFavorite(String token, String placeId) async {
    final response = await _client.delete(_uri('/favorites/$placeId'), headers: _headers(token));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('No se pudo quitar de favoritos (${response.statusCode})');
    }
  }
}
