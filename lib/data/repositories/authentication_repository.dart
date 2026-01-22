import 'package:first_flutter/data/models/profile.dart';
import 'package:first_flutter/data/models/user.dart';
import 'package:first_flutter/data/services/authentication_service.dart';
import 'package:flutter/material.dart';

abstract class IAuthenticationRepository extends ChangeNotifier{
  Future<User> validateLogin(String username, String password);

  Future<Profile> loadProfile();
  Future<User>? get user;
}

class AuthenticationRepository extends ChangeNotifier implements IAuthenticationRepository {
  AuthenticationRepository({required IAuthenticationService authenticationService})
    : _authenticationService = authenticationService;
  
  final IAuthenticationService _authenticationService;

  Future<User>? _user;
  @override
  Future<User>? get user => _user;

  @override
  Future<User> validateLogin(String username, String password) async {
    _user = _authenticationService.validateLogin(username, password);
    // After login, notify listeners about the change in user state
    await _user;
    notifyListeners();
    return _user!;
  }

  @override
  Future<Profile> loadProfile() async {

    if (_user == null) {
      throw Exception("User not logged in");
    }

    return _authenticationService.loadProfile(await _user!);
  }
}
