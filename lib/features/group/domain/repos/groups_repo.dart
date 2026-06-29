import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_member_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';

abstract class GroupsRepo {
  Future<Either<Failure, void>> createGroup(GroupEntity group);
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  Future<Either<Failure, UserSearchEntity>> searchUserByEmail(String email);
  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(
    String groupId,
  );
  Future<Either<Failure, void>> removeMemberFromGroup(
    String groupId,
    String memberUid,
  );
  Future<Either<Failure, void>> addMemberToExistingGroup({
    required String groupId,
    required String uid,
    required String name,
    required String email,
    String? avatarUrl,
  });
  Future<Either<Failure, void>> createGroupTask(GroupTaskEntity task);
  Future<Either<Failure, List<GroupTaskEntity>>> getGroupTasks(String groupId);
  Stream<Either<Failure, List<GroupTaskEntity>>> streamGroupTasks(
    String groupId,
  );
  Future<Either<Failure, void>> toggleTaskCompletion({
    required String groupId,
    required String taskId,
    required bool isCompleted,
  });
  Future<Either<Failure, void>> sendGroupMessage(
    GroupMessageEntity message, {
    required String groupId,
  });
  Stream<Either<Failure, List<GroupMessageEntity>>> getChatMessagesStream(
    String groupId,
  );
}
