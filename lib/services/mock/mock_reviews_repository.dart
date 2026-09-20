import 'dart:math';
import 'dart:typed_data';

import '../../models/review.dart';
import '../repositories/reviews_repository.dart';

class MockReviewsRepository implements ReviewsRepository {
  final Map<String, List<Review>> _reviewsByPlace = {};

  @override
  Future<List<Review>> getReviewsForPlace(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _reviewsByPlace[placeId] ?? const [];
    return list.reversed.toList();
  }

  @override
  Future<Review> addReview({
    required String token,
    required String placeId,
    required int rating,
    required String comment,
    Uint8List? photoBytes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final userId = token.split(':').first;
    final review = Review(
      id: 'review-${Random().nextInt(999999)}',
      placeId: placeId,
      userId: userId,
      userName: userId == 'user-demo' ? 'Usuario Demo' : userId,
      rating: rating.clamp(1, 5),
      comment: comment,
      photoBytes: photoBytes,
      createdAt: DateTime.now(),
    );
    _reviewsByPlace.putIfAbsent(placeId, () => []).add(review);
    return review;
  }
}
