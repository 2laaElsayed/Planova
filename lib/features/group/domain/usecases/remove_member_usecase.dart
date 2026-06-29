import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class RemoveMemberUsecase {
  final GroupsRepo repo;
  RemoveMemberUsecase({required this.repo});

  Future<Either<Failure, void>> call(String groupId, String memberUid) async {
    return await repo.removeMemberFromGroup(groupId, memberUid);
  }
}