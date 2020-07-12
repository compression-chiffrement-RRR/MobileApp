import 'package:mobileappflutter/Modele/file_basic_information.dart';

class FileAccount {
  List<FileBasicInformation> userFilesAuthor;
  List<FileBasicInformation> userFilesCollaborator;

  FileAccount({this.userFilesAuthor, this.userFilesCollaborator});

  factory FileAccount.fromJson(Map<String, dynamic> json) {
    return FileAccount(
        userFilesAuthor: json["userFilesAuthor"],
        userFilesCollaborator: json["userFilesCollaborator"]
    );
  }
}