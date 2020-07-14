class FileProcess {
  String uuid;
  String processType;
  int order;

  FileProcess({this.uuid, this.processType, this.order});

  factory FileProcess.fromJson(Map<String, dynamic> json) {
    return FileProcess(
      uuid: json["uuid"],
      processType: json["processTaskType"],
      order: json["order"],
    );
  }
}