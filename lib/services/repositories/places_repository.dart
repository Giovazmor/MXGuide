import '../../models/category.dart';
import '../../models/place.dart';
import '../../models/state_model.dart';

/// Contrato de lugares (documentación sección 5, /places, /categories, /states).
/// nearby/featured quedan listos para el Sprint 5 (geolocalización).
abstract class PlacesRepository {
  Future<List<PlaceCategory>> getCategories();
  Future<List<PlaceState>> getStates();
  Future<List<Place>> getPlaces({String? categoryId, String? stateId, String? search});
  Future<Place> getPlaceById(String id);
  Future<List<Place>> getFeatured({int limit = 10});
  Future<List<Place>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
    int limit = 20,
  });
}
