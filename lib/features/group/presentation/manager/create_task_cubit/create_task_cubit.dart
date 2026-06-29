import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_task_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_my_groups_usecase.dart';

part 'create_task_state.dart';

class CreateTaskCubit extends Cubit<CreateTaskState> {
  CreateTaskCubit({
    required this.createGroupTaskUseCase,
    required this.getMyGroupsUseCase,
  }) : super(CreateTaskInitial());

  final CreateGroupTaskUseCase createGroupTaskUseCase;
  final GetMyGroupsUseCase getMyGroupsUseCase;

  List<GroupEntity> availableGroups = [];

  Future<void> loadAvailableGroups() async {
    final result = await getMyGroupsUseCase.call();
    result.fold(
      (failure) => availableGroups = const [],
      (groups) => availableGroups = groups,
    );
  }

  Future<void> createTask({
    required String groupId,
    required String title,
    required String description,
    required TaskPriority priority,
    required DateTime dueDate,
    required String createdByUid,
  }) async {
    emit(CreateTaskLoading());

    final task = GroupTaskEntity(
      id: 'pending',
      groupId: groupId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isCompleted: false,
      createdByUid: createdByUid,
      createdAt: DateTime.now(),
    );

    final result = await createGroupTaskUseCase.call(task);

    result.fold(
      (failure) => emit(CreateTaskFailure(errMessage: failure.message)),
      (_) => emit(CreateTaskSuccess()),
    );
  }
}