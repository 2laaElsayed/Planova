import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_router.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/avatar_square.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/members_stack.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/scope_badge.dart';

class GroupListCard extends StatelessWidget {
  const GroupListCard({super.key, required this.group});
  final GroupItem group;

  @override
  Widget build(BuildContext context) {
    final percent = (group.progress * 100).round();
    return GestureDetector(
      onTap: () => GoRouter.of(context).push(AppRouter.kGroupDetailsView),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E9F2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AvatarSquare(color: group.accent, text: group.title[0]),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 7,
                            color: group.life.dotColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            group.life.badge,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            group.lastSeen,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.kTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const Spacer(),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: group.progress,
                minHeight: 5,
                backgroundColor: const Color(0xFFEDF0F6),
                valueColor: AlwaysStoppedAnimation<Color>(group.accent),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                MembersStack(
                  initials: group.memberInitials,
                  extra: group.membersExtra,
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 15,
                  color: Colors.black38,
                ),
                const SizedBox(width: 3),
                Text(
                  '${group.comments}',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const Spacer(),
                ScopeBadge(scope: group.scope),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
