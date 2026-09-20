import 'package:flutter/foundation.dart';

import '../models/category.dart';
import '../models/place.dart';
import '../models/state_model.dart';
import '../services/repositories/places_repository.dart';

class PlacesProvider extends ChangeNotifier {
  final PlacesRepository _repository;
  PlacesProvider(this._repository);

  bool isLoading = false;
  String? errorMessage;

  List<Place> places = [];
  List<PlaceCategory> categories = [];
  List<PlaceState> states = [];

  String? selectedCategoryId;
  String? selectedStateId;
  String searchQuery = '';

  Future<void> loadInitial() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      categories = await _repository.getCategories();
      states = await _repository.getStates();
      places = await _repository.getPlaces();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyFilters({String? categoryId, String? stateId, String? search}) async {
    selectedCategoryId = categoryId;
    selectedStateId = stateId;
    searchQuery = search ?? searchQuery;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      places = await _repository.getPlaces(
        categoryId: selectedCategoryId,
        stateId: selectedStateId,
        search: searchQuery,
      );
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => applyFilters(
        categoryId: selectedCategoryId,
        stateId: selectedStateId,
        search: searchQuery,
      );

  void clearFilters() {
    applyFilters(categoryId: null, stateId: null, search: '');
  }

  Place? findById(String id) {
    try {
      return places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Place> fetchDetail(String id) => _repository.getPlaceById(id);

  Future<List<Place>> fetchFeatured({int limit = 10}) => _repository.getFeatured(limit: limit);
}
