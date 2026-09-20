import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/review.dart';
import '../services/repositories/reviews_repository.dart';

class ReviewsProvider extends ChangeNotifier {
  final ReviewsRepository _repository;
  ReviewsProvider(this._repository);

  final Map<String, List<Review>> _cache = {};
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  List<Review> forPlace(String placeId) => _cache[placeId] ?? const [];

  Future<void> loadForPlace(String placeId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _cache[placeId] = await _repository.getReviewsForPlace(placeId);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submit({
    required String token,
    required String placeId,
    required int rating,
    required String comment,
    Uint8List? photoBytes,
  }) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      final review = await _repository.addReview(
        token: token,
        placeId: placeId,
        rating: rating,
        comment: comment,
        photoBytes: photoBytes,
      );
      _cache.putIfAbsent(placeId, () => []).insert(0, review);
      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
