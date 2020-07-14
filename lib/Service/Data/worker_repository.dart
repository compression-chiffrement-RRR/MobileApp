import 'package:http_parser/http_parser.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/task_process_file.dart';
import 'package:mobileappflutter/Modele/task_unprocess_file.dart';
import 'package:mobileappflutter/Service/Data/base_repository.dart';
import 'package:mobileappflutter/Service/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class WorkerRepository extends BaseRepository {
  final AuthService _authService = AuthService();

  final String uploadFileUrl = "${BaseRepository.apiEndpoint}/api/worker/uploadFile";
  final String unprocessFileUrl = "${BaseRepository.apiEndpoint}/api/worker/retrieveFile";

  Future<FileBasicInformation> uploadFile({TaskProcessFile task, String path, String filename}) async {
    String taskJson = json.encode(task);

    print(taskJson);

    Dio dio = new Dio();

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: filename),
      "tasks": MultipartFile.fromString(taskJson, contentType: new MediaType("application", "json"))
    });

    Map<String, String> headers = {
      "Authorization": _authService.currentToken
    };

    try {
      var res = await dio.post(uploadFileUrl, data: formData, options: Options(
          headers: headers,
          contentType: "multipart/form-data"
      ));
      if (res.statusCode == 202) {
        FileBasicInformation fileBasicInformation = FileBasicInformation.fromJson(res.data);
        return fileBasicInformation;
      }
    } on DioError catch(e) {
      if(e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else{
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<FileBasicInformation> unprocessFile(String fileUuid, TaskUnprocessFile taskUnprocessFile) async {
    final body = jsonEncode(taskUnprocessFile);
    print(body);
    Map<String, String> headers = {
      'Content-Type': ContentType.json.toString(),
      "Authorization": _authService.currentToken
    };
    var res = await http.post("$unprocessFileUrl/$fileUuid", headers: headers, body: body);
    if (res.statusCode == 202) {
      var jsonData = json.decode(res.body);
      FileBasicInformation fileBasicInformation = FileBasicInformation.fromJson(jsonData);
      return fileBasicInformation;
    }
    return null;
  }
}