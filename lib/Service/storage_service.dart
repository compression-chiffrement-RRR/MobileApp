import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final storage = FlutterSecureStorage();
  static final jwtKey = "jwt";

  Future<String> getJWToken() async {
    var jwt = await storage.read(key: jwtKey);
    if (jwt == null) return "";
    return jwt;
  }

  Future<void> writeJWToken(String token) async {
    await storage.write(key: jwtKey, value: token);
  }

  Future<void> removeJWToken() async {
    await storage.delete(key: jwtKey);
  }
}
