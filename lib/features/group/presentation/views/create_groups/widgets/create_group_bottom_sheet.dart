import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_router.dart';
import 'package:planova_app/core/constants/app_styles.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/views/create_groups/widgets/group_type_card.dart';

class CreateGroupBottomSheet extends StatelessWidget {
  const CreateGroupBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Create New Group',
            style: AppStyles.styleSemiBold18.copyWith(color: AppColors.black),
          ),
          const SizedBox(height: 20),

          GroupTypeCard(
            icon: Icons.people_outline_rounded,
            iconColor: AppColors.blue,
            iconBgColor: const Color(0xFFEDF0FF),
            title: 'Team Group',
            subtitle: 'Collaborate with members',
            onTap: () {
              GoRouter.of(context).pop();
              GoRouter.of(
                context,
              ).push(AppRouter.kCreateGroupView, extra: ScopeTab.team);
            },
          ),
          const SizedBox(height: 16),

          GroupTypeCard(
            icon: Icons.lock_outline_rounded,
            iconColor: AppColors.kPrimary,
            iconBgColor: const Color(0xFFF1F1FF),
            title: 'Personal Group',
            subtitle: 'Only visible to you',
            onTap: () {
              GoRouter.of(context).pop();
              GoRouter.of(
                context,
              ).push(AppRouter.kCreateGroupView, extra: ScopeTab.personal);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
