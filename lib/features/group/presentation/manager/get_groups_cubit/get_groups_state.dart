part of 'get_groups_cubit.dart';

@immutable
abstract class GetGroupsState {}

class GetGroupsInitial extends GetGroupsState {}

class GetGroupsLoading extends GetGroupsState {}

class GetGroupsSuccess extends GetGroupsState {
  final List<GroupEntity> groups;
  GetGroupsSuccess({required this.groups});
}

class GetGroupsFailure extends GetGroupsState {
  final String errMessage;
  GetGroupsFailure({required this.errMessage});
}