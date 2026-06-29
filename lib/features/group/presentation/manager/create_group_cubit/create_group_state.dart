part of 'create_group_cubit.dart';

@immutable
abstract class CreateGroupState {}

class CreateGroupInitial extends CreateGroupState {}

class CreateGroupLoading extends CreateGroupState {}

class CreateGroupSuccess extends CreateGroupState {}

class CreateGroupFailure extends CreateGroupState {
  final String errMessage;
  CreateGroupFailure({required this.errMessage});
}

class AddMemberLoading extends CreateGroupState {}

class AddMemberSuccess extends CreateGroupState {
  final String memberName;
  AddMemberSuccess({required this.memberName});
}

class AddMemberFailure extends CreateGroupState {
  final String errMessage;
  AddMemberFailure({required this.errMessage});
}
