import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class AddMemberToExistingGroupUseCase {
  final GroupsRepo repo;

  AddMemberToExistingGroupUseCase({required this.repo});

  Future<Either<Failure, void>> call({
    required String groupId,
    required UserSearchEntity user,
  }) async {
    return await repo.addMemberToExistingGroup(
      groupId: groupId,
      uid: user.uid,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
    );
  }
}