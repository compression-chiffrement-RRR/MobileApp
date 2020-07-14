import 'package:mobileappflutter/Modele/Enum/cipher_task_type.dart';
import 'package:mobileappflutter/Modele/Enum/compress_task_type.dart';

class ProcessFile {
  String name;
  String password;

  ProcessFile.fromCipher({CipherTaskType type}) {
    this.name = type.toString().split(".")[1];
    this.password = password;
  }

  ProcessFile.fromCompress({CompressTaskType type}) {
    this.name = type.toString().split(".")[1];
  }

  void setPassword(String password) {
    this.password = password;
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'password': password
      };
}