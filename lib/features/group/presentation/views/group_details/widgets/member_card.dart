import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/presentation/views/group_details/groups_details_view.dart';

class MemberCard extends StatelessWidget {
  final String initial;
  final String name;
  final String role;
  final MemberTrailing trailing;
  final VoidCallback? onDeletePressed;

  const MemberCard({
    super.key,
    required this.initial,
    required this.name,
    required this.role,
    required this.trailing,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.kPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kDarkBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: const TextStyle(fontSize: 11, color: AppColors.kColdGrey),
                ),
              ],
            ),
          ),
          trailing == MemberTrailing.admin
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEBFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.kPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onDeletePressed,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.kColdGrey,
                  ),
                ),
        ],
      ),
    );
  }
}