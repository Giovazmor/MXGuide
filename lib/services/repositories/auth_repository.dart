import '../../models/user.dart';

class AuthResponse {
  final AppUser user;
  final String token;
  const AuthResponse({required this.user, required this.token});
}

/// Contrato de autenticación (documentación sección 5, /auth):
/// POST /auth/register, POST /auth/login, GET /auth/me.
abstract class AuthRepository {
  Future<AuthResponse> login({required String email, required String password});
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  });
  Future<AppUser> me(String token);
}
