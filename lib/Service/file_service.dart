import 'package:mobileappflutter/Modele/file_account.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Service/Data/file_repository.dart';

abstract class FileServiceBase {
  Future<FileAdvancedInformation> getInformation(String fileUuid);
  Future<FileAccount> getAllFiles();
  Future<String> downloadFile(FileBasicInformation file);
  Future<bool> deleteFile(FileBasicInformation file);
}

class FileService extends FileServiceBase {
  final FileRepository _fileRepository = FileRepository();

  @override
  Future<FileAdvancedInformation> getInformation(String fileUuid) {
    return _fileRepository.getFileInformation(fileUuid);
  }

  @override
  Future<FileAccount> getAllFiles() async {
    FileAccount fileAccount = await _fileRepository.getAllFiles();
    return fileAccount;
  }

  @override
  Future<String> downloadFile(FileBasicInformation file) {
    return _fileRepository.downloadFile(file.uuid);
  }

  @override
  Future<bool> deleteFile(FileBasicInformation file) {
    return _fileRepository.deleteFile(file.uuid);
  }
}