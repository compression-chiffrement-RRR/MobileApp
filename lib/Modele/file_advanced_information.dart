import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/file_process.dart';

class FileAdvancedInformation implements FileBasicInformation {
  @override
  String uuid;

  @override
  String uuidParent;

  @override
  String name;

  @override
  bool isTreated;

  @override
  bool isError;

  @override
  bool isTemporary;

  @override
  String creationDate;

  List<FileProcess> processes;

  FileAdvancedInformation(
      {this.uuid, this.uuidParent, this.name, this.isTreated, this.isError, this.isTemporary, this.processes, this.creationDate});

  factory FileAdvancedInformation.fromJson(Map<String, dynamic> json) {
    return FileAdvancedInformation(
        uuid: json["uuid"],
        uuidParent: json["uuidParent"],
        name: json["name"],
        isTreated: json["isTreated"],
        isError: json["isError"],
        isTemporary: json["isTemporary"],
        processes: json["processes"],
        creationDate: json["creationDate"]
    );
  }
}