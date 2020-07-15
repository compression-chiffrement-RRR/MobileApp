import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/task_process_file.dart';
import 'package:mobileappflutter/Modele/task_unprocess_file.dart';
import 'package:mobileappflutter/Service/Data/worker_repository.dart';

abstract class WorkerServiceBase {
  Future<FileBasicInformation> uploadFile({TaskProcessFile task, String path, String filename});
  Future<FileBasicInformation> unprocessFile({String fileUuid, TaskUnprocessFile taskUnprocessFile});
}

class WorkerService extends WorkerServiceBase {
  final WorkerRepository _workerRepository = WorkerRepository();

  @override
  Future<FileBasicInformation> uploadFile({TaskProcessFile task, String path, String filename, void Function(int, int) onSendProgress}) {
    return _workerRepository.uploadFile(task: task, path: path, filename: filename, onSendProgress: onSendProgress);
  }

  @override
  Future<FileBasicInformation> unprocessFile({String fileUuid, TaskUnprocessFile taskUnprocessFile}) {
    return _workerRepository.unprocessFile(fileUuid, taskUnprocessFile);
  }

}