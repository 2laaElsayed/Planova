import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class GetChatMessagesStreamUseCase {
  final GroupsRepo repo;

  GetChatMessagesStreamUseCase({required this.repo});

  Stream<Either<Failure, List<GroupMessageEntity>>> call(String groupId) {
    return repo.getChatMessagesStream(groupId);
  }
}