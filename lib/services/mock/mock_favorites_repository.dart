import '../repositories/favorites_repository.dart';

class MockFavoritesRepository implements FavoritesRepository {
  // token -> set de placeIds favoritos
  final Map<String, Set<String>> _favoritesByToken = {};

  @override
  Future<List<String>> getFavoritePlaceIds(String token) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _favoritesByToken[token]?.toList() ?? [];
  }

  @override
  Future<void> addFavorite(String token, String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favoritesByToken.putIfAbsent(token, () => <String>{}).add(placeId);
  }

  @override
  Future<void> removeFavorite(String token, String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favoritesByToken[token]?.remove(placeId);
  }
}
