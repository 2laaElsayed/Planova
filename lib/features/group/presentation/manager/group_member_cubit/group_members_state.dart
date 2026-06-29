import 'package:flutter/material.dart';
import 'package:planova_app/features/group/domain/entities/group_member_entity.dart';


@immutable
abstract class GroupMembersState {}

class GroupMembersInitial extends GroupMembersState {}

class GroupMembersLoading extends GroupMembersState {}

class GroupMembersSuccess extends GroupMembersState {
  final List<GroupMemberEntity> members;
  GroupMembersSuccess({required this.members});
}

class GroupMembersFailure extends GroupMembersState {
  final String errMessage;
  GroupMembersFailure({required this.errMessage});
}