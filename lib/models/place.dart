import 'category.dart';
import 'place_image.dart';
import 'state_model.dart';

/// Modelo de `Place` alineado al contrato documentado en
/// mxguide-backend-documentacion.md (secciones 4.1 y 5).
///
/// El backend real todavía no tiene código implementado (el ZIP que
/// compartiste solo trae la documentación de arquitectura, el código vive
/// en un submódulo aparte), así que algunos detalles de forma exacta del
/// JSON (el shape de "location" y si "state" viene anidado completo en el
/// detalle) están marcados como TODO: ajústalos cuando el equipo confirme
/// el contrato final contra el backend ya implementado.
class Place {
  final String id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String address;
  final String municipality;
  final PlaceState? state;
  final List<PlaceCategory> categories;
  final List<PlaceImage> images;
  final String? coverImage;
  final String? openingHours;
  final double? entryCost;
  final int relevanceScore;
  final bool isPublished;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  const Place({
    required this.id,
    required this.name,
    required this.shortDescription,
    this.longDescription = '',
    this.address = '',
    this.municipality = '',
    this.state,
    this.categories = const [],
    this.images = const [],
    this.coverImage,
    this.openingHours,
    this.entryCost,
    this.relevanceScore = 0,
    this.isPublished = true,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  String get coverImageUrl =>
      coverImage ??
      (images.isNotEmpty ? images.first.url : 'https://picsum.photos/seed/$id/800/600');

  String get primaryCategoryName =>
      categories.isNotEmpty ? categories.first.name : 'Sin categoría';

  bool get isFree => entryCost == null || entryCost == 0;

  bool get isCurated => relevanceScore >= 85;

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      longDescription: json['longDescription'] as String? ?? '',
      address: json['address'] as String? ?? '',
      municipality: json['municipality'] as String? ?? '',
      // TODO: confirmar si /places/:id siempre incluye "state" anidado.
      state: json['state'] is Map<String, dynamic>
          ? PlaceState.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      categories: _parseCategories(json['categories']),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => PlaceImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      coverImage: json['coverImage'] as String?,
      openingHours: json['openingHours']?.toString(),
      entryCost: (json['entryCost'] as num?)?.toDouble(),
      relevanceScore: (json['relevanceScore'] as num?)?.toInt() ?? 0,
      isPublished: json['isPublished'] as bool? ?? true,
      // TODO: confirmar el shape real de "location" (Geography Point) y
      // mapear lat/lng aquí cuando el backend lo exponga en el JSON.
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }

  /// GET /places/nearby regresa "categories" como lista de strings
  /// (ej. ["Arqueológico", "Histórico"]); el detalle probablemente regresa
  /// objetos completos {id, name, icon}. Soportamos ambos.
  static List<PlaceCategory> _parseCategories(dynamic raw) {
    if (raw is! List) return const [];
    return raw.map((item) {
      if (item is Map<String, dynamic>) return PlaceCategory.fromJson(item);
      return PlaceCategory(id: item.toString(), name: item.toString());
    }).toList();
  }
}
