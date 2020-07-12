import 'package:mobileappflutter/Modele/file_account.dart';
import 'package:mobileappflutter/Modele/file_advanced_information.dart';
import 'package:mobileappflutter/Service/Data/file_repository.dart';

abstract class FileServiceBase {
  Future<FileAdvancedInformation> getInformation(String fileUuid);
  Future<FileAccount> getAllFiles();
  Future<String> downloadFile(String fileUuid);
  Future<bool> deleteFile(String fileUuid);
}

class FileService extends FileServiceBase {
  final FileRepository _fileRepository = FileRepository();

  @override
  Future<FileAdvancedInformation> getInformation(String fileUuid) {
    return _fileRepository.getFileInformation(fileUuid);
  }

  @override
  Future<FileAccount> getAllFiles() {
    return _fileRepository.getAllFiles();
  }

  @override
  Future<String> downloadFile(String fileUuid) {
    return _fileRepository.downloadFile(fileUuid);
  }

  @override
  Future<bool> deleteFile(String fileUuid) {
    return _fileRepository.deleteFile(fileUuid);
  }
}