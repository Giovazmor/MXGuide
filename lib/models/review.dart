import 'dart:typed_data';

/// Reseña de un lugar (documentación sección 4.7 — entidad opcional del
/// backend). La foto va como bytes locales por ahora: el contrato
/// documentado no define todavía un endpoint de subida de imágenes para
/// reseñas de usuario (solo para PlaceImage vía admin/Cloudinary) — queda
/// como TODO para cuando el equipo lo defina.
class Review {
  final String id;
  final String placeId;
  final String userId;
  final String userName;
  final int rating; // 1-5
  final String comment;
  final Uint8List? photoBytes;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.photoBytes,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'].toString(),
      placeId: json['placeId'].toString(),
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] as String? ?? 'Usuario',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
