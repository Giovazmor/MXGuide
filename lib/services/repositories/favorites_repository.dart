/// Contrato de favoritos (documentación sección 5, /favorites — requiere auth).
abstract class FavoritesRepository {
  Future<List<String>> getFavoritePlaceIds(String token);
  Future<void> addFavorite(String token, String placeId);
  Future<void> removeFavorite(String token, String placeId);
}
