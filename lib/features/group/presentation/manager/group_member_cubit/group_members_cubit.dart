import 'package:bloc/bloc.dart';
import 'package:planova_app/features/group/domain/usecases/add_member_to_existing_group_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/get_group_members_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/remove_member_usecase.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_state.dart';


class GroupMembersCubit extends Cubit<GroupMembersState> {
  final GetGroupMembersUsecase getGroupMembersUsecase;
  final RemoveMemberUsecase removeMemberUsecase;

  GroupMembersCubit({
    required this.getGroupMembersUsecase,
    required this.removeMemberUsecase, required AddMemberToExistingGroupUseCase addMemberToExistingGroupUsecase,
  }) : super(GroupMembersInitial());

  Future<void> fetchMembers(String groupId) async {
    emit(GroupMembersLoading());
    final result = await getGroupMembersUsecase.call(groupId);
    result.fold(
      (failure) => emit(GroupMembersFailure(errMessage: failure.message)),
      (members) => emit(GroupMembersSuccess(members: members)),
    );
  }

  Future<void> kickMember(String groupId, String memberUid) async {
    final result = await removeMemberUsecase.call(groupId, memberUid);
    result.fold(
      (failure) => emit(GroupMembersFailure(errMessage: failure.message)),
      (_) {
        fetchMembers(groupId);
      },
    );
  }
}