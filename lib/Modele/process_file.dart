import 'package:mobileappflutter/Modele/Enum/cipher_task_type.dart';
import 'package:mobileappflutter/Modele/Enum/compress_task_type.dart';

class ProcessFile {
  String name;
  String password;

  ProcessFile.fromCipher({CipherTaskType type, String password}) {
    this.name = type.toString();
    this.password = password;
  }

  ProcessFile.fromCompress({CompressTaskType type, String password}) {
    this.name = type.toString();
    this.password = password;
  }
}