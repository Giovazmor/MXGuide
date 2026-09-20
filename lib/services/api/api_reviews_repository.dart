import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../../models/review.dart';
import '../repositories/reviews_repository.dart';

/// Implementación real (documentación sección 5: GET /places/:id/reviews,
/// POST /reviews). El endpoint para subir la FOTO de una reseña de usuario
/// no está documentado todavía (solo el de PlaceImage vía admin/Cloudinary)
/// — por ahora este método ignora `photoBytes` al hablar con el backend
/// real. Ajusta cuando el equipo defina el endpoint de subida.
class ApiReviewsRepository implements ReviewsRepository {
  final http.Client _client;
  ApiReviewsRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  @override
  Future<List<Review>> getReviewsForPlace(String placeId) async {
    final response = await _client.get(_uri('/places/$placeId/reviews'));
    if (response.statusCode != 200) {
      throw Exception('No se pudieron cargar las reseñas (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Review> addReview({
    required String token,
    required String placeId,
    required int rating,
    required String comment,
    Uint8List? photoBytes,
  }) async {
    final response = await _client.post(
      _uri('/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'placeId': placeId, 'rating': rating, 'comment': comment}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('No se pudo enviar la reseña (${response.statusCode})');
    }
    return Review.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
