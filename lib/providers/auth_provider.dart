import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/repositories/auth_repository.dart';

enum AuthStatus { guest, authenticating, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  AuthProvider(this._repository);

  AuthStatus status = AuthStatus.guest;
  AppUser? currentUser;
  String? token;
  String? errorMessage;

  bool get isLoggedIn => status == AuthStatus.authenticated && currentUser != null;

  Future<bool> login({required String email, required String password}) async {
    status = AuthStatus.authenticating;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.login(email: email, password: password);
      currentUser = result.user;
      token = result.token;
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    status = AuthStatus.authenticating;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.register(name: name, email: email, password: password);
      currentUser = result.user;
      token = result.token;
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    currentUser = null;
    token = null;
    status = AuthStatus.guest;
    notifyListeners();
  }
}
