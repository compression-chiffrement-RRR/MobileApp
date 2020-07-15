import 'package:mobileappflutter/Modele/user.dart';

class FileCollaborator {
  String fileUuid;
  User user;
  bool pending;
  String creationDate;

  FileCollaborator({this.fileUuid, this.user, this.pending, this.creationDate});

  factory FileCollaborator.fromJson(Map<String, dynamic> json) {
    return FileCollaborator(
      fileUuid: json["userFileUuid"],
      user: User.fromJson(json["account"]),
      pending: json["pending"],
      creationDate: json["creationDate"]
    );
  }
}