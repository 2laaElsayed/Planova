import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class GetMyGroupsUseCase {
  final GroupsRepo repo;

  GetMyGroupsUseCase({required this.repo});

  Future<Either<Failure, List<GroupEntity>>> call() async {
    return await repo.getGroups();
  }
}