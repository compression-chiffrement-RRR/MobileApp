import 'package:mobileappflutter/Modele/file_basic_information.dart';
import 'package:mobileappflutter/Modele/file_collaborator.dart';
import 'package:mobileappflutter/Modele/user.dart';
import 'package:mobileappflutter/Service/Data/collaborator_repository.dart';

abstract class CollaboratorServiceBase {
  Future<List<FileCollaborator>> getCollaborators(FileBasicInformation fileBasicInformation);

  Future<bool> addCollaborators({FileBasicInformation fileBasicInformation, List<User> collaborators});

  Future<bool> removeCollaborator({FileBasicInformation fileBasicInformation, User collaborator});
}

class CollaboratorService extends CollaboratorServiceBase {
  final CollaboratorRepository _collaboratorRepository = CollaboratorRepository();

  @override
  Future<List<FileCollaborator>> getCollaborators(FileBasicInformation fileBasicInformation) {
    return _collaboratorRepository.getCollaborators(fileBasicInformation.uuid);
  }

  @override
  Future<bool> addCollaborators({FileBasicInformation fileBasicInformation, List<User> collaborators}) {
    return _collaboratorRepository.addCollaborators(
        fileBasicInformation.uuid,
        collaborators.map((e) => e.uuid));
  }

  @override
  Future<bool> removeCollaborator({FileBasicInformation fileBasicInformation, User collaborator}) {
    return _collaboratorRepository.removeCollaborator(
        fileBasicInformation.uuid,
        collaborator.uuid);
  }
}