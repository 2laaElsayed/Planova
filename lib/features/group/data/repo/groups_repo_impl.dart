import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';
import 'package:planova_app/features/group/data/service/groups_firebase_service.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class GroupsRepoImpl implements GroupsRepo {
  final GroupsFirebaseService firebaseService;

  GroupsRepoImpl(this.firebaseService);
  @override
  Future<Either<Failure, void>> createGroup(GroupEntity group) async {
    final groupModel = group.toModel();
    return await firebaseService.createGroup(groupModel);
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    final returnedData = await firebaseService.getGroups();
    return returnedData.fold(
      (errmessage) => Left(errmessage),
      (data) => right(data.map((e) => e.toEntity()).toList()),
    );
  }
}
