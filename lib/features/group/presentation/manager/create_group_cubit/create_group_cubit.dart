import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/domain/usecases/add_member_to_existing_group_usecase.dart';
import 'package:planova_app/features/group/domain/usecases/create_group_usecase.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit(this.createGroupUsecase, {this.addMemberToExistingGroupUsecase})
      : super(CreateGroupInitial());

  final CreateGroupUsecase createGroupUsecase;

  final AddMemberToExistingGroupUseCase? addMemberToExistingGroupUsecase;

  String groupName = '';
  String groupDescription = '';
  String colorHex = '#FFC1BE';
  final List<UserSearchEntity> invitedMembers = [];

  List<String> get invitedMemberUids =>
      invitedMembers.map((u) => u.uid).toList();

  void updateDetails({required String name, required String description}) {
    groupName = name;
    groupDescription = description;
  }

  void updateColor(String hex) {
    colorHex = hex;
  }
  void addMember(UserSearchEntity user) {
    if (invitedMembers.any((m) => m.uid == user.uid)) return;
    invitedMembers.add(user);
  }

  void removeInvitedMember(String uid) {
    invitedMembers.removeWhere((m) => m.uid == uid);
  }

  Future<void> createGroup(ScopeTab groupType) async {
    emit(CreateGroupLoading());

    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final returnedData = await createGroupUsecase.createGroup(
      GroupEntity(
        groupId: 'groupId',
        name: groupName,
        description: groupDescription,
        createdByUid: currentUid,
        createdAt: DateTime.now(),
        colorHex: colorHex,
        memberUids: invitedMemberUids,
        status: GroupLife.active,
        type: groupType,
      ),
    );

    returnedData.fold(
      (failure) => emit(CreateGroupFailure(errMessage: failure.message)),
      (_) => emit(CreateGroupSuccess()),
    );
  }
  Future<void> addMemberToExistingGroup({
    required String groupId,
    required UserSearchEntity user,
  }) async {
    final usecase = addMemberToExistingGroupUsecase;
    if (usecase == null) {
      emit(
        AddMemberFailure(
          errMessage:
              "AddMemberToExistingGroupUseCase was not provided to this cubit instance.",
        ),
      );
      return;
    }

    emit(AddMemberLoading());

    final result = await usecase.call(groupId: groupId, user: user);

    result.fold(
      (failure) => emit(AddMemberFailure(errMessage: failure.message)),
      (_) => emit(AddMemberSuccess(memberName: user.name)),
    );
  }
}