/// Coincide con el modelo `State` de la documentación (sección 4.4):
/// las 32 entidades federativas, catálogo fijo cargado por seed.
class PlaceState {
  final String id;
  final String name;

  const PlaceState({required this.id, required this.name});

  factory PlaceState.fromJson(Map<String, dynamic> json) {
    return PlaceState(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
    );
  }
}
