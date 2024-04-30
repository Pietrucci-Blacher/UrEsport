import 'package:flutter/material.dart';
import 'package:uresport/auth/services/auth_service.dart';

class AuthServiceProvider with ChangeNotifier {
  IAuthService _authService;

  AuthServiceProvider(this._authService);

  IAuthService get authService => _authService;

  void setAuthService(IAuthService authService) {
    _authService = authService;
    notifyListeners();
  }
}
