import 'package:mobileappflutter/Modele/file_collaborator.dart';
import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:mobileappflutter/Service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CollaboratorRepository extends BaseRepository {
  final AuthService _authService = AuthService();

  final String getCollaboratorsUrl = "${BaseRepository.apiEndpoint}/api/file/share";
  final String addCollaboratorsUrl = "${BaseRepository.apiEndpoint}/api/file/share";
  final String removeCollaboratorsUrl = "${BaseRepository.apiEndpoint}/api/file/share";

  Future<List<FileCollaborator>> getCollaborators(String fileUuid) async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get("$getCollaboratorsUrl/$fileUuid", headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      List<FileCollaborator> fileCollaborators = new List();
      for (var u in jsonData) {
        FileCollaborator fileCollaborator = FileCollaborator.fromJson(u);
        fileCollaborators.add(fileCollaborator);
      }
      return fileCollaborators;
    }
    return null;
  }

  Future<bool> addCollaborators(String fileUuid, List<String> collaboratorsUuid) async {
    final body = jsonEncode({"collaboratorsUuid": collaboratorsUuid});
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken,
    };
    var res = await http.post("$addCollaboratorsUrl/$fileUuid",
        body: body, headers: headers);
    if (res.statusCode == 200) return true;
    return false;
  }

  Future<bool> removeCollaborator(String fileUuid, String collaboratorUuid) async {
    Map<String, String> headers = {
      "Authorization": _authService.currentToken,
    };
    var res = await http.delete("$removeCollaboratorsUrl/$fileUuid?collaboratorUuid=$collaboratorUuid", headers: headers);
    if (res.statusCode == 204) return true;
    return false;
  }
}