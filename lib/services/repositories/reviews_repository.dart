import 'dart:typed_data';

import '../../models/review.dart';

/// Contrato de reseñas (documentación sección 5: GET /places/:id/reviews,
/// POST /reviews — requiere auth). La subida de la foto junto a la reseña
/// no está documentada todavía; se mockea localmente mientras tanto.
abstract class ReviewsRepository {
  Future<List<Review>> getReviewsForPlace(String placeId);
  Future<Review> addReview({
    required String token,
    required String placeId,
    required int rating,
    required String comment,
    Uint8List? photoBytes,
  });
}
