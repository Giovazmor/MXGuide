import 'dart:math';

import '../../models/user.dart';
import '../repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  // Simula una "base de datos" de usuarios en memoria.
  final Map<String, _MockAccount> _accounts = {
    'demo@mxguide.com': _MockAccount(
      password: '123456',
      user: const AppUser(
        id: 'user-demo',
        email: 'demo@mxguide.com',
        name: 'Usuario Demo',
        role: UserRole.user,
      ),
    ),
  };

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final account = _accounts[email.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw Exception('Correo o contraseña incorrectos');
    }
    return AuthResponse(user: account.user, token: _generateToken(account.user.id));
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      throw Exception('Ya existe una cuenta con ese correo');
    }
    final user = AppUser(
      id: 'user-${_accounts.length + 1}',
      email: normalizedEmail,
      name: name.trim(),
      role: UserRole.user,
    );
    _accounts[normalizedEmail] = _MockAccount(password: password, user: user);
    return AuthResponse(user: user, token: _generateToken(user.id));
  }

  @override
  Future<AppUser> me(String token) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final userId = token.split(':').first;
    final account = _accounts.values.firstWhere(
      (a) => a.user.id == userId,
      orElse: () => throw Exception('Sesión inválida'),
    );
    return account.user;
  }

  String _generateToken(String userId) {
    final rand = Random().nextInt(999999);
    return '$userId:mock-token-$rand';
  }
}

class _MockAccount {
  final String password;
  final AppUser user;
  _MockAccount({required this.password, required this.user});
}
