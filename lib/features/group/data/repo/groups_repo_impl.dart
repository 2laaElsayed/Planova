import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/data/models/group_message_model.dart';
import 'package:planova_app/features/group/data/models/group_task_model.dart';
import 'package:planova_app/features/group/data/models/user_search_model.dart';
import 'package:planova_app/features/group/data/service/groups_firebase_service.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_member_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';

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
      (failure) => left(failure),
      (data) => right(data.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, UserSearchEntity>> searchUserByEmail(
    String email,
  ) async {
    final result = await firebaseService.searchUserByEmail(email);
    return result.fold(
      (failure) => left(failure),
      (model) => right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<GroupMemberEntity>>> getGroupMembers(
    String groupId,
  ) async {
    final result = await firebaseService.getGroupMembers(groupId);
    return result.fold(
      (failure) => left(failure),
      (models) => right(models.map((e) => e as GroupMemberEntity).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> removeMemberFromGroup(
    String groupId,
    String memberUid,
  ) async {
    return await firebaseService.removeMemberFromGroup(groupId, memberUid);
  }

  @override
  Future<Either<Failure, void>> addMemberToExistingGroup({
    required String groupId,
    required String uid,
    required String name,
    required String email,
    String? avatarUrl,
  }) async {
    return await firebaseService.addMemberToExistingGroup(
      groupId: groupId,
      uid: uid,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<Either<Failure, void>> createGroupTask(GroupTaskEntity task) async {
    final GroupTaskModel taskModel = task.toModel();
    return await firebaseService.createGroupTask(taskModel);
  }

  @override
  Future<Either<Failure, List<GroupTaskEntity>>> getGroupTasks(
    String groupId,
  ) async {
    final result = await firebaseService.getGroupTasks(groupId);
    return result.fold(
      (failure) => left(failure),
      (models) => right(models.map((e) => e as GroupTaskEntity).toList()),
    );
  }

  @override
  Stream<Either<Failure, List<GroupTaskEntity>>> streamGroupTasks(
    String groupId,
  ) {
    return firebaseService.streamGroupTasks(groupId).transform(
      StreamTransformer.fromHandlers(
        handleData: (models, sink) {
          sink.add(right(models.map((e) => e as GroupTaskEntity).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(left(Failure(error.toString())));
        },
      ),
    );
  }

  @override
  Future<Either<Failure, void>> toggleTaskCompletion({
    required String groupId,
    required String taskId,
    required bool isCompleted,
  }) async {
    return await firebaseService.toggleTaskCompletion(
      groupId: groupId,
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }

  @override
  Future<Either<Failure, void>> sendGroupMessage(
    GroupMessageEntity message, {
    required String groupId,
  }) async {
    final model = GroupMessageModel(
      id: message.id,
      senderId: message.senderId,
      senderName: message.senderName,
      message: message.message,
      timestamp: message.timestamp,
    );
    return await firebaseService.sendGroupMessage(model, groupId: groupId);
  }

  @override
  Stream<Either<Failure, List<GroupMessageEntity>>> getChatMessagesStream(
    String groupId,
  ) {
    return firebaseService.getChatMessagesStream(groupId).transform(
      StreamTransformer.fromHandlers(
        handleData: (models, sink) {
          sink.add(right(models.map((e) => e as GroupMessageEntity).toList()));
        },
        handleError: (error, stackTrace, sink) {
          sink.add(left(Failure(error.toString())));
        },
      ),
    );
  }
}