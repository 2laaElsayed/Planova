import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';
import 'package:planova_app/features/group/domain/usecases/Getgroup_tasks_stream_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_task_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_chat_messages_stream_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/send_group_message_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/toggle_task_completion_usecase.dart';

part 'group_details_state.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsState> {
  GroupDetailsCubit({
    required this.groupId,
    required this.getGroupTasksStreamUseCase,
    required this.createGroupTaskUseCase,
    required this.toggleTaskCompletionUseCase,
    required this.getChatMessagesStreamUseCase,
    required this.sendGroupMessageUseCase,
  }) : super(GroupDetailsInitial());

  final String groupId;
  final GetGroupTasksStreamUseCase getGroupTasksStreamUseCase;
  final CreateGroupTaskUseCase createGroupTaskUseCase;
  final ToggleTaskCompletionUseCase toggleTaskCompletionUseCase;
  final GetChatMessagesStreamUseCase getChatMessagesStreamUseCase;
  final SendGroupMessageUseCase sendGroupMessageUseCase;

  StreamSubscription? _tasksSub;
  StreamSubscription? _chatSub;

  List<GroupTaskEntity> _latestTasks = [];
  List<GroupMessageEntity> _latestMessages = [];

  List<GroupTaskEntity> get latestTasks => _latestTasks;
  List<GroupMessageEntity> get latestMessages => _latestMessages;

  void watchTasks() {
    _tasksSub?.cancel();
    emit(GroupTasksLoading());

    _tasksSub = getGroupTasksStreamUseCase.call(groupId).listen((either) {
      either.fold(
        (failure) => emit(GroupTasksError(errMessage: failure.message)),
        (tasks) {
          _latestTasks = tasks;
          emit(GroupTasksLoaded(tasks: tasks));
        },
      );
    });
  }

  void watchChat() {
    _chatSub?.cancel();
    emit(GroupChatLoading());

    _chatSub = getChatMessagesStreamUseCase.call(groupId).listen((either) {
      either.fold(
        (failure) => emit(GroupChatError(errMessage: failure.message)),
        (messages) {
          _latestMessages = messages;
          emit(GroupChatLoaded(messages: messages));
        },
      );
    });
  }

  Future<void> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
    required DateTime dueDate,
  }) async {
    emit(CreateGroupTaskLoading());

    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final task = GroupTaskEntity(
      id: 'pending',
      groupId: groupId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isCompleted: false,
      createdByUid: currentUid,
      createdAt: DateTime.now(),
    );

    final result = await createGroupTaskUseCase.call(task);

    result.fold(
      (failure) => emit(CreateGroupTaskFailure(errMessage: failure.message)),
      (_) => emit(CreateGroupTaskSuccess()),
    );
  }

  Future<void> toggleTask(String taskId, bool isCompleted) async {
    final result = await toggleTaskCompletionUseCase.call(
      groupId: groupId,
      taskId: taskId,
      isCompleted: isCompleted,
    );

    result.fold(
      (failure) => emit(GroupTasksError(errMessage: failure.message)),
      (_) {},
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final message = GroupMessageEntity(
      id: 'pending',
      senderId: user.uid,
      senderName: user.displayName ?? 'Member',
      message: text.trim(),
      timestamp: DateTime.now(),
    );

    final result = await sendGroupMessageUseCase.call(
      groupId: groupId,
      message: message,
    );

    result.fold(
      (failure) => emit(GroupChatError(errMessage: failure.message)),
      (_) {
      },
    );
  }

  @override
  Future<void> close() {
    _tasksSub?.cancel();
    _chatSub?.cancel();
    return super.close();
  }
}
