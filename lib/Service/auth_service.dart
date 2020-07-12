import 'package:flutter/material.dart';
import 'package:mobileappflutter/Service/Data/auth_repository.dart';
import 'package:mobileappflutter/Service/storage_service.dart';

abstract class AuthServiceBase {
  @protected
  String initialToken;
  @protected
  String stateToken;
  String get currentToken => stateToken;

  void setStateToken(String token) {
    stateToken = token;
  }

  void reset() {
    stateToken = initialToken;
  }

  Future<String> getStoredToken();

  Future<String> getNewToken(String username, String password);

  Future<void> removeTokenStored();
}

class AuthService extends AuthServiceBase {
  static final AuthService _instance = AuthService._internal();
  static final StorageService _storageService = StorageService();
  static final AuthRepository _authRepository = AuthRepository();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    initialToken = null;
    stateToken = initialToken;
  }

  @override
  Future<String> getNewToken(String username, String password) async {
    String token = await _authRepository.getNewJwToken(username, password);
    await _storageService.writeJWToken(token);
    setStateToken(token);
    return currentToken;
  }

  @override
  Future<String> getStoredToken() async {
    String token = await _storageService.getJWToken();
    setStateToken(token);
    return currentToken;
  }

  @override
  Future<void> removeTokenStored() async {
    await _storageService.removeJWToken();
    reset();
  }
}