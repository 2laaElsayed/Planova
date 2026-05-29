
import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/avatar_square.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/members_stack.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/scope_badge.dart';

class GroupGridCard extends StatelessWidget {
  final GroupItem group;
  const GroupGridCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E9F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarSquare(color: group.accent, text: group.title[0], size: 28),
              const Spacer(),
              Icon(Icons.circle, size: 7, color: group.life.dotColor),
              const SizedBox(width: 4),
              Text(
                group.life.badge,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            group.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.kTextDark,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Last active: ${group.lastSeen}',
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
          const SizedBox(height: 8),
          ScopeBadge(scope: group.scope),

          const Spacer(),
          Row(
            children: [
              MembersStack(
                initials: group.memberInitials,
                extra: group.membersExtra,
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ],
      ),
    );
  }
}
