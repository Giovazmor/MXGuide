import '../../models/category.dart';
import '../../models/place.dart';
import '../../models/state_model.dart';
import '../repositories/places_repository.dart';
import 'mock_data.dart';

class MockPlacesRepository implements PlacesRepository {
  @override
  Future<List<PlaceCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.categories;
  }

  @override
  Future<List<PlaceState>> getStates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.states;
  }

  @override
  Future<List<Place>> getPlaces({String? categoryId, String? stateId, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.places.where((place) {
      final matchesCategory =
          categoryId == null || place.categories.any((c) => c.id == categoryId);
      final matchesState = stateId == null || place.state?.id == stateId;
      final matchesSearch = search == null ||
          search.trim().isEmpty ||
          place.name.toLowerCase().contains(search.trim().toLowerCase());
      return matchesCategory && matchesState && matchesSearch;
    }).toList();
  }

  @override
  Future<Place> getPlaceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.places.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Lugar no encontrado'),
    );
  }

  @override
  Future<List<Place>> getFeatured({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = [...MockData.places]..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return sorted.take(limit).toList();
  }

  @override
  Future<List<Place>> getNearby({
    required double lat,
    required double lng,
    double radiusKm = 25,
    int limit = 20,
  }) async {
    // Placeholder para el Sprint 5: sin PostGIS aquí, solo regresamos la
    // curaduría ordenada por relevancia con una distancia simulada.
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = [...MockData.places]..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return sorted.take(limit).toList();
  }
}
