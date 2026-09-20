import '../core/constants/api_config.dart';
import 'api/api_auth_repository.dart';
import 'api/api_favorites_repository.dart';
import 'api/api_places_repository.dart';
import 'api/api_reviews_repository.dart';
import 'mock/mock_auth_repository.dart';
import 'mock/mock_favorites_repository.dart';
import 'mock/mock_places_repository.dart';
import 'mock/mock_reviews_repository.dart';
import 'repositories/auth_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/places_repository.dart';
import 'repositories/reviews_repository.dart';

/// Único lugar donde se decide si la app usa datos dummy o la API real.
/// Cambia ApiConfig.useMockData a false (y ajusta ApiConfig.baseUrl) para
/// conectar contra el backend de verdad, sin tocar ninguna pantalla.
class RepositoryFactory {
  static AuthRepository createAuthRepository() {
    return ApiConfig.useMockData ? MockAuthRepository() : ApiAuthRepository();
  }

  static PlacesRepository createPlacesRepository() {
    return ApiConfig.useMockData ? MockPlacesRepository() : ApiPlacesRepository();
  }

  static FavoritesRepository createFavoritesRepository() {
    return ApiConfig.useMockData ? MockFavoritesRepository() : ApiFavoritesRepository();
  }

  static ReviewsRepository createReviewsRepository() {
    return ApiConfig.useMockData ? MockReviewsRepository() : ApiReviewsRepository();
  }
}
