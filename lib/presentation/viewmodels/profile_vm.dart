import 'package:first_flutter/data/models/profile.dart';
import 'package:first_flutter/data/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';

class ProfileVM extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Profile? _profile;
  Profile? get profile => _profile;
  
  final IAuthenticationRepository _authenticationRepository;

  ProfileVM({required IAuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository {
      _authenticationRepository.addListener(() {
        // When the authentication repository changes (e.g., user logs in), load the profile
        loadProfile();
      });
    }

  Future<void> loadProfile() async {
    if (_authenticationRepository.user != null) {
      //Only load profile if user is logged in
      
      isLoading = true;
      error = null;
      try {
        _profile = await _authenticationRepository.loadProfile();
      } catch (e) {
        error = e.toString();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
