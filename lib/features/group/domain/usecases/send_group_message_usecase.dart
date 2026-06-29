import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class SendGroupMessageUseCase {
  final GroupsRepo repo;

  SendGroupMessageUseCase({required this.repo});

  Future<Either<Failure, void>> call({
    required String groupId,
    required GroupMessageEntity message,
  }) async {
    return await repo.sendGroupMessage(message, groupId: groupId);
  }
}