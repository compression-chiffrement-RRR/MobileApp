import 'package:mobileappflutter/Modele/unprocess_file.dart';

class TaskUnprocessFile {
  List<UnprocessFile> types;

  TaskUnprocessFile(this.types);

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