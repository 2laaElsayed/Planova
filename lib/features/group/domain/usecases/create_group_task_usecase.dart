import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class CreateGroupTaskUseCase {
  final GroupsRepo repo;

  CreateGroupTaskUseCase({required this.repo});

  Future<Either<Failure, void>> call(GroupTaskEntity task) async {
    return await repo.createGroupTask(task);
  }
}