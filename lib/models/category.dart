/// Coincide con el modelo `Category` de la documentación (sección 4.2):
/// id, name, icon. Relación muchos-a-muchos con Place vía PlaceCategory.
class PlaceCategory {
  final String id;
  final String name;
  final String icon;

  const PlaceCategory({
    required this.id,
    required this.name,
    this.icon = 'place',
  });

  factory PlaceCategory.fromJson(Map<String, dynamic> json) {
    return PlaceCategory(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? 'place',
    );
  }
}
