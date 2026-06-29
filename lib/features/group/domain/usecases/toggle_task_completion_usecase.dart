import 'package:dartz/dartz.dart';
import 'package:planova_app/core/errors/failure.dart';
import 'package:planova_app/features/group/domain/repos/groups_repo.dart';

class ToggleTaskCompletionUseCase {
  final GroupsRepo repo;

  ToggleTaskCompletionUseCase({required this.repo});

  Future<Either<Failure, void>> call({
    required String groupId,
    required String taskId,
    required bool isCompleted,
  }) async {
    return await repo.toggleTaskCompletion(
      groupId: groupId,
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }
}
