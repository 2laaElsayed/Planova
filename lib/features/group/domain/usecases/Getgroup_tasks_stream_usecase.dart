import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class GetGroupTasksStreamUseCase {
  final GroupsRepo repo;

  GetGroupTasksStreamUseCase({required this.repo});

  Stream<Either<Failure, List<GroupTaskEntity>>> call(String groupId) {
    return repo.streamGroupTasks(groupId);
  }
}