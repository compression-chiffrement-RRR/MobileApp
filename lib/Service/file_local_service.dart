import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileLocalService {
  static final localStorage = getApplicationDocumentsDirectory();

  Future<File> saveFile(Uint8List bytes, String filename) async {
    String dir = (await getExternalStorageDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}