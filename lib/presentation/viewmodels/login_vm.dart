import 'package:first_flutter/data/models/user.dart';
import 'package:first_flutter/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';

class LoginVM extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  User? _user;
  User? get user => _user;

  final IAuthenticationRepository _authenticationRepository;
  

  LoginVM({required IAuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository;

  Future<void> validateLogin(String username, String password) async {
    isLoading = true;
    error = null;
    try {
      _user = await _authenticationRepository.validateLogin(username, password);
    } catch (e) {
      error = e.toString();
      // Handle error if needed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
