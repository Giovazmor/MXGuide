import 'package:flutter/foundation.dart';

import '../services/repositories/favorites_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;
  FavoritesProvider(this._repository);

  bool isLoading = false;
  Set<String> favoritePlaceIds = {};

  bool isFavorite(String placeId) => favoritePlaceIds.contains(placeId);

  Future<void> load(String? token) async {
    if (token == null) {
      favoritePlaceIds = {};
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final ids = await _repository.getFavoritePlaceIds(token);
      favoritePlaceIds = ids.toSet();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggle(String token, String placeId) async {
    if (favoritePlaceIds.contains(placeId)) {
      favoritePlaceIds.remove(placeId);
      notifyListeners();
      await _repository.removeFavorite(token, placeId);
    } else {
      favoritePlaceIds.add(placeId);
      notifyListeners();
      await _repository.addFavorite(token, placeId);
    }
  }

  void clear() {
    favoritePlaceIds = {};
    notifyListeners();
  }
}
