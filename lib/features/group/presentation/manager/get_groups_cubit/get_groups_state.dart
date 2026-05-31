part of 'get_groups_cubit.dart';

@immutable
sealed class GetGroupsState {}

final class GetGroupsInitial extends GetGroupsState {}

final class GetGroupsFailure extends GetGroupsState {
  final String errMessage;

  GetGroupsFailure({required this.errMessage});
}

final class GetGroupsSuccess extends GetGroupsState {
  final List<GroupEntity> groups;

  GetGroupsSuccess({required this.groups});
}

final class GetGroupsLoading extends GetGroupsState {}
