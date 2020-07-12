import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository extends BaseRepository {
  final String loginUrl = "${BaseRepository.apiEndpoint}/login";

  Future<String> getNewJwToken(String username, String password) async {
    final body = jsonEncode({"username": username,"password": password});
    Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8'};
    var res = await http.post(
        loginUrl,
        headers: headers,
        body: body
    );

    if(res.statusCode == 200) {
      return res.headers["authorization"];
    }
    return null;
  }
}