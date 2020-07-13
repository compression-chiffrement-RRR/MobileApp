import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mobileappflutter/Modele/file_account.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:mobileappflutter/Service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

typedef void OnDownloadProgressCallback(int receivedBytes, int totalBytes);
typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class FileRepository extends BaseRepository {
  final AuthService _authService = AuthService();

  final String getFileInformationUrl = "${BaseRepository.apiEndpoint}/api/file";
  final String getAllFilesUrl = "${BaseRepository.apiEndpoint}/api/file";
  final String downloadFileUrl = "${BaseRepository.apiEndpoint}/api/file/download";
  final String deleteFileUrl = "${BaseRepository.apiEndpoint}/api/file";

  Future<FileAdvancedInformation> getFileInformation(String fileUuid) async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get("$getFileInformationUrl/$fileUuid", headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      FileAdvancedInformation fileAdvancedInformation = FileAdvancedInformation.fromJson(jsonData);
      return fileAdvancedInformation;
    }
    return null;
  }

  Future<FileAccount> getAllFiles() async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.get(getAllFilesUrl, headers: headers);
    if (res.statusCode == 200) {
      var jsonData = json.decode(res.body);
      FileAccount fileAccount = FileAccount.fromJson(jsonData);
      return fileAccount;
    }
    return null;
  }

  Future<bool> downloadFile(String fileUuid, String savePath, void Function(int, int) onReceiveProgress) async {
    Dio dio = Dio();

    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };

    dio.download(
      "$downloadFileUrl/$fileUuid",
      savePath,
      onReceiveProgress: onReceiveProgress,
      deleteOnError: true,
      options: Options(
        headers: headers
      )
    );
    return true;
  }

  Future<bool> deleteFile(String fileUuid) async {
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.delete("$deleteFileUrl/$fileUuid", headers: headers);
    if (res.statusCode == 204) return true;
    return false;
  }
}