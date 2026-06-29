import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/widgets/custom_text_field.dart';
import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';
import 'package:planova_app/features/group/presentation/manager/create_group_cubit/create_group_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/search_user_cubit/search_user_cubit.dart';
import 'package:planova_app/features/group/presentation/views/edit_groups/widgets/preview_card.dart';
class MembersBody extends StatefulWidget {
  const MembersBody({
    super.key,
    required this.selectedColor,
    required this.name,
    this.groupId,
  });

  final Color selectedColor;
  final String name;
  final String? groupId;
  @override
  State<MembersBody> createState() => _MembersBodyState();
}

class _MembersBodyState extends State<MembersBody> {
  final TextEditingController _emailController = TextEditingController();

  bool get _isExistingGroupFlow => widget.groupId != null;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleFoundUser(BuildContext context, UserSearchEntity user) {
    final createGroupCubit = context.read<CreateGroupCubit>();

    if (_isExistingGroupFlow) {
      createGroupCubit.addMemberToExistingGroup(
        groupId: widget.groupId!,
        user: user,
      );
      _emailController.clear();
      context.read<SearchUserCubit>().reset();
    } else {
      if (createGroupCubit.invitedMemberUids.contains(user.uid)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.logoutRed,
            content: Text("This user is already in the invite list."),
          ),
        );
        return;
      }
      createGroupCubit.addMember(user);
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: widget.selectedColor,
          content: Text("Added ${user.name} to the invite list"),
        ),
      );
      context.read<SearchUserCubit>().reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CreateGroupCubit, CreateGroupState>(
          builder: (context, state) {
            final createCubit = context.read<CreateGroupCubit>();
            final totalMembersCount = createCubit.invitedMemberUids.length + 1;

            return PreviewCard(
              color: widget.selectedColor,
              subtitle: "$totalMembersCount members",
              name: widget.name.isEmpty ? "Group Name" : widget.name,
            );
          },
        ),
        const SizedBox(height: 30),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Invite Members",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2366),
            ),
          ),
        ),
        const SizedBox(height: 10),
        BlocConsumer<SearchUserCubit, SearchUserState>(
          listener: (context, state) {
            if (state is SearchUserSuccess) {
              _handleFoundUser(context, state.user);
            }
            if (state is SearchUserFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.logoutRed,
                  content: Text(state.errMessage),
                ),
              );
            }
          },
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Enter Member Email",
                    controller: _emailController,

                    onchange: (value) {},
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<CreateGroupCubit, CreateGroupState>(
                  builder: (context, createState) {
                    final isAdding = createState is AddMemberLoading;
                    final isSearching = state is SearchUserLoading;
                    final isBusy = isAdding || isSearching;

                    return GestureDetector(
                      onTap: isBusy
                          ? null
                          : () {
                              context.read<SearchUserCubit>().searchUser(
                                _emailController.text,
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isBusy
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.add, color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Invited List Preview",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_isExistingGroupFlow)
          BlocBuilder<CreateGroupCubit, CreateGroupState>(
            builder: (context, state) {
              if (state is AddMemberSuccess) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "✓ ${state.memberName} added to the group",
                    style: const TextStyle(
                      color: Color(0xFF7CB97C),
                      fontSize: 13,
                    ),
                  ),
                );
              }
              if (state is AddMemberFailure) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        else
          Expanded(
            child: BlocBuilder<CreateGroupCubit, CreateGroupState>(
              builder: (context, state) {
                final invitedMembers = context
                    .read<CreateGroupCubit>()
                    .invitedMembers;

                if (invitedMembers.isEmpty) {
                  return const Center(
                    child: Text(
                      "No members invited yet.",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: invitedMembers.length,
                  itemBuilder: (context, index) {
                    final user = invitedMembers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: widget.selectedColor.withOpacity(
                            0.3,
                          ),
                          child: Icon(
                            Icons.person,
                            color: widget.selectedColor,
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          user.email,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: AppColors.logoutRed,
                          ),
                          onPressed: () {
                            context
                                .read<CreateGroupCubit>()
                                .removeInvitedMember(user.uid);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
