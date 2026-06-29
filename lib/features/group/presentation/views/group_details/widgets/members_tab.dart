import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_state.dart';
import 'package:planova_app/features/group/presentation/views/add_members_view.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/member_card.dart';

class MembersTab extends StatelessWidget {
  const MembersTab({super.key, required this.groupEntity});
  final GroupEntity groupEntity;

  @override
  Widget build(BuildContext context) {
    final groupMembersCubit = context.read<GroupMembersCubit>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Text(
                'Members',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kDarkBlue,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddMembersView(groupEntity: groupEntity),
                    ),
                  );
                  groupMembersCubit.fetchMembers(groupEntity.groupId);
                },
                child: const Row(
                  children: [
                    Icon(Icons.link, size: 14, color: AppColors.kColdGrey),
                    SizedBox(width: 4),
                    Text(
                      'Re-invite',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.kColdGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<GroupMembersCubit, GroupMembersState>(
            builder: (context, state) {
              if (state is GroupMembersLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GroupMembersFailure) {
                return Center(
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is GroupMembersSuccess) {
                final members = state.members;

                if (members.isEmpty) {
                  return const Center(
                    child: Text("No members found in this group."),
                  );
                }

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MemberCard(
                        initial: member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : 'M',
                        name: member.name,
                        role: member.role,
                        trailing: member.trailingType,
                        onDeletePressed: () {
                          groupMembersCubit.kickMember(
                            groupEntity.groupId,
                            member.uid,
                          );
                        },
                      ),
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
