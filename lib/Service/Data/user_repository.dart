import 'dart:io';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:mobileappflutter/Service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository extends BaseRepository {
  final AuthService _authService = AuthService();

  final String getCurrentUserUrl = "${BaseRepository.apiEndpoint}/api/account/me";
  final String createUserUrl = "${BaseRepository.apiEndpoint}/api/account";
  final String getUserUrl = "${BaseRepository.apiEndpoint}/api/account";
  final String modifyUserUrl = "${BaseRepository.apiEndpoint}/api/account";
  final String modifyUserPasswordUrl = "${BaseRepository.apiEndpoint}/api/account/password";
  final String deleteUserUrl = "${BaseRepository.apiEndpoint}/api/account";

  Future<User> getCurrentUser() async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get(getCurrentUserUrl, headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      User user = User.fromJson(jsonData);
      return user;
    }
    return null;
  }

  Future<User> getUserByUsername(String username) async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get("$getUserUrl?username=$username", headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      User user = User.fromJson(jsonData);
      return user;
    }
    return null;
  }

  Future<bool> createNewUser(
      String username, String email, String password) async {
    final body = jsonEncode(
        {"username": username, "email": email, "password": password});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString()
    };
    var res = await http.post(createUserUrl, body: body, headers: headers);
    if (res.statusCode == 201) return true;
    return false;
  }

  Future<bool> modifyUser(String username, String email) async {
    final body = jsonEncode({"username": username, "email": email});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken,
    };
    var res =
        await http.put(modifyUserUrl, body: body, headers: headers);
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> modifyUserPassword(String password) async {
    final body = jsonEncode({"password": password});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken,
    };
    var res = await http.put(modifyUserPasswordUrl,
        body: body, headers: headers);
    if (res.statusCode == 204) return true;
    return false;
  }

  Future<bool> deleteUser() async {
    Map<String, String> headers = {
      "Authorization": _authService.currentToken,
    };
    var res = await http.delete(deleteUserUrl, headers: headers);
    if (res.statusCode == 204) return true;
    return false;
  }
}
