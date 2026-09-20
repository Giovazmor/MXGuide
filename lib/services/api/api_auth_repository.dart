import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../../models/user.dart';
import '../repositories/auth_repository.dart';

/// Implementación real usando el backend NestJS (documentación sección 5,
/// /auth). El shape exacto de la respuesta de login/register (si el token
/// viene como "accessToken" o "token", y si el usuario viene anidado bajo
/// "user") no está confirmado todavía porque el backend no tiene código
/// implementado aún — ajusta cuando el equipo lo confirme.
class ApiAuthRepository implements AuthRepository {
  final http.Client _client;
  ApiAuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await _client.post(
      _uri('/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('No se pudo iniciar sesión (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseAuthResponse(data);
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('No se pudo crear la cuenta (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseAuthResponse(data);
  }

  @override
  Future<AppUser> me(String token) async {
    final response = await _client.get(
      _uri('/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Sesión inválida (${response.statusCode})');
    }
    return AppUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  AuthResponse _parseAuthResponse(Map<String, dynamic> data) {
    final userJson = data['user'] as Map<String, dynamic>? ?? data;
    final token = data['accessToken'] as String? ?? data['token'] as String? ?? '';
    return AuthResponse(user: AppUser.fromJson(userJson), token: token);
  }
}
