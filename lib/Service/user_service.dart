import 'package:flutter/material.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/user_repository.dart';

abstract class UserServiceBase {
  @protected
  User initialUser;
  @protected
  User stateUser;
  User get currentUser => stateUser;

  void setStateUser(User user) {
    stateUser = user;
  }

  void reset() {
    stateUser = initialUser;
  }

  Future<User> refreshCurrentUser();

  Future<User> getUserByUsername(String username);

  Future<bool> createUser({String username, String email, String password});

  Future<bool> updateUser({String username, String email});

  Future<bool> updatePasswordUser(String password);

  Future<bool> deleteUser();
}

class UserService extends UserServiceBase {
  static final UserService _instance = UserService._internal();
  static final UserRepository _userRepository = UserRepository();

  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    initialUser = null;
    stateUser = initialUser;
  }

  @override
  Future<User> refreshCurrentUser() async {
    User user = await _userRepository.getCurrentUser();
    setStateUser(user);
    return currentUser;
  }

  @override
  Future<User> getUserByUsername(String username) async {
    User user = await _userRepository.getUserByUsername(username);
    return user;
  }

  @override
  Future<bool> createUser({String username, String email, String password}) async {
    bool success = await _userRepository.createNewUser(username, email, password);
    return success;
  }

  @override
  Future<bool> updateUser({String username, String email}) async {
    bool success = await _userRepository.modifyUser(username, email);
    if (success) {
      await refreshCurrentUser();
    }
    return success;
  }

  @override
  Future<bool> updatePasswordUser(String password) async {
    bool success = await _userRepository.modifyUserPassword(password);
    return success;
  }

  @override
  Future<bool> deleteUser() async {
    bool success = await _userRepository.deleteUser();
    reset();
    return success;
  }
}