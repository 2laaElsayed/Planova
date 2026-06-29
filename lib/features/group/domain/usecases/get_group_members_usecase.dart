import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_member_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class GetGroupMembersUsecase {
  final GroupsRepo repo;
  GetGroupMembersUsecase({required this.repo});

  Future<Either<Failure, List<GroupMemberEntity>>> call(String groupId) async {
    return await repo.getGroupMembers(groupId);
  }
}