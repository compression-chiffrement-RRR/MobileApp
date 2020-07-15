import 'dart:io';

import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:mobileappflutter/Service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendRepository extends BaseRepository {
  final AuthService _authService = AuthService();

  final String getMyFriendsUrl = "${BaseRepository.apiEndpoint}/api/friend";
  final String getPendingFriendsUrl = "${BaseRepository.apiEndpoint}/api/friend/pending";
  final String addFriendUrl = "${BaseRepository.apiEndpoint}/api/friend";
  final String confirmFriendUrl = "${BaseRepository.apiEndpoint}/api/friend/confirmFriend";
  final String ignoreFriendUrl = "${BaseRepository.apiEndpoint}/api/friend/ignoreFriend";
  final String deleteFriendUrl = "${BaseRepository.apiEndpoint}/api/friend";

  Future<List<User>> getMyFriends() async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get(getMyFriendsUrl, headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      List<User> users = [];
      for (var u in jsonData) {
        User user = User.fromJson(u);
        users.add(user);
      }
      return users;
    }
    return null;
  }

  Future<List<User>> getMyPendingFriends() async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get(getPendingFriendsUrl, headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      List<User> users = [];
      for (var u in jsonData) {
        User user = User.fromJson(u);
        users.add(user);
      }

      return users;
    }
    return null;
  }

  Future<bool> addFriend(String friendUuid) async {
    final body = jsonEncode({"friendUuid": friendUuid});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    print(body);
    var res = await http.post(addFriendUrl, headers: headers, body: body);
    print(res.body);
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> confirmFriend(String friendUuid) async {
    final body = jsonEncode({"friendUuid": friendUuid});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.post(confirmFriendUrl, headers: headers, body: body);
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> ignoreFriend(String friendUuid) async {
    final body = jsonEncode({"friendUuid": friendUuid});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.post(ignoreFriendUrl, headers: headers, body: body);
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> deleteFriend(String friendUuid) async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.delete(
        "$deleteFriendUrl?friendUuid=$friendUuid",
        headers: headers);
    print(res.body);
    if (res.statusCode == 204) return true;
    return false;
  }
}
