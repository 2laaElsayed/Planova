import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/data/models/group_model.dart' show GroupEntityUiX;
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_cubit.dart';
import 'package:planova_app/features/group/presentation/manager/group_member_cubit/group_members_state.dart';

class GroupTopInfo extends StatelessWidget {
  const GroupTopInfo({super.key, required this.groupEntity});
  final GroupEntity groupEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: groupEntity.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  groupEntity.name.isNotEmpty
                      ? groupEntity.name[0].toUpperCase()
                      : 'G',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDarkBlue,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupEntity.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 8, color: Color(0xFF7CB97C)),
                        const SizedBox(width: 4),
                        const Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7CB97C),
                          ),
                        ),
                        const SizedBox(width: 8),
                        BlocBuilder<GroupMembersCubit, GroupMembersState>(
                          builder: (context, state) {
                            final count = state is GroupMembersSuccess
                                ? state.members.length
                                : groupEntity.memberUids.length;
                            return Text(
                              '$count members',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.kColdGrey,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            groupEntity.description,
            style: const TextStyle(fontSize: 12, color: AppColors.kColdGrey),
          ),
        ],
      ),
    );
  }
}