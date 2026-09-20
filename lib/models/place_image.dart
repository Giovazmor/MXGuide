/// Coincide con el modelo `PlaceImage` de la documentación (sección 4.3):
/// id, placeId, url, order (orden de despliegue en la galería).
class PlaceImage {
  final String id;
  final String url;
  final int order;

  const PlaceImage({required this.id, required this.url, this.order = 0});

  factory PlaceImage.fromJson(Map<String, dynamic> json) {
    return PlaceImage(
      id: json['id'].toString(),
      url: json['url'] as String,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}
