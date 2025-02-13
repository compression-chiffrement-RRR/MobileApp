class FileBasicInformation {
  String uuid;
  String uuidParent;
  String name;
  bool isTreated;
  bool isError;
  bool isTemporary;
  String creationDate;

  DateTime creationDatetime;

  FileBasicInformation(
      {this.uuid, this.uuidParent, this.name, this.isTreated, this.isError, this.isTemporary, this.creationDate, this.creationDatetime}) {
    this.creationDatetime = DateTime.parse(this.creationDate).toLocal();
  }

  factory FileBasicInformation.fromJson(Map<String, dynamic> json) {
    return FileBasicInformation(
        uuid: json["uuid"],
        uuidParent: json["uuidParent"],
        name: json["name"],
        isTreated: json["isTreated"],
        isError: json["isError"],
        isTemporary: json["isTemporary"],
        creationDate: json["creationDate"]
    );
  }
}