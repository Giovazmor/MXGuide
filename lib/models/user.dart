/// Roles reales definidos en el backend (sección 7 de la documentación).
/// "Invitado" no es un rol guardado en BD: es simplemente la ausencia de
/// sesión (currentUser == null en AuthProvider).
enum UserRole { user, admin }

UserRole userRoleFromString(String? value) {
  return value == 'admin' ? UserRole.admin : UserRole.user;
}

class AppUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      role: userRoleFromString(json['role'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role.name,
      };
}
