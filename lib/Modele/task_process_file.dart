import 'package:mobileappflutter/Modele/process_file.dart';

class TaskProcessFile {
  List<ProcessFile> types;

  TaskProcessFile(this.types);

  Map<String, dynamic> toJson() {
    if (types.length > 0) {
      return {
        'types': types.map((e) => e.toJson()).toList()
      };
    } else {
      return {
        'types': []
      };
    }
  }
}