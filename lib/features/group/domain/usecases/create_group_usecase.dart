import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class CreateGroupUsecase {
  final GroupsRepo repo;

  CreateGroupUsecase({required this.repo});
  Future<Either<Failure, void>> createGroup(GroupEntity group) async {
    return await repo.createGroup(group);
  }
}
