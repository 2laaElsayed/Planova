part of 'group_details_cubit.dart';

@immutable
abstract class GroupDetailsState {}

class GroupDetailsInitial extends GroupDetailsState {}

class GroupTasksLoading extends GroupDetailsState {}

class GroupTasksLoaded extends GroupDetailsState {
  final List<GroupTaskEntity> tasks;
  GroupTasksLoaded({required this.tasks});

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  double get progress => tasks.isEmpty ? 0 : completedCount / tasks.length;
}

class GroupTasksError extends GroupDetailsState {
  final String errMessage;
  GroupTasksError({required this.errMessage});
}

class CreateGroupTaskLoading extends GroupDetailsState {}

class CreateGroupTaskSuccess extends GroupDetailsState {}

class CreateGroupTaskFailure extends GroupDetailsState {
  final String errMessage;
  CreateGroupTaskFailure({required this.errMessage});
}

class GroupChatLoading extends GroupDetailsState {}

class GroupChatLoaded extends GroupDetailsState {
  final List<GroupMessageEntity> messages;
  GroupChatLoaded({required this.messages});
}

class GroupChatError extends GroupDetailsState {
  final String errMessage;
  GroupChatError({required this.errMessage});
}