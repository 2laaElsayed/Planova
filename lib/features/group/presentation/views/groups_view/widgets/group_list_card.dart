import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_router.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/avatar_square.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/members_stack.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/scope_badge.dart';

class GroupListCard extends StatelessWidget {
  const GroupListCard({super.key, required this.group});
  final GroupEntity group;

  @override
  Widget build(BuildContext context) {
    final percent = 0;
    return GestureDetector(
      onTap: () =>
          GoRouter.of(context).push(AppRouter.kGroupDetailsView, extra: group),
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
                AvatarSquare(color: group.accentColor, text: group.name[0]),
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
                            color: group.status.dotColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            group.status.badge,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            group.createdAt.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.name,
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
                value: 0,
                minHeight: 5,
                backgroundColor: const Color(0xFFEDF0F6),
                valueColor: AlwaysStoppedAnimation<Color>(group.accentColor),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                MembersStack(
                  initials: group.memberUids,
                  extra: group.memberUids.length,
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 15,
                  color: Colors.black38,
                ),
                const SizedBox(width: 3),
                Text(
                  '0',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
                const Spacer(),
                ScopeBadge(scope: group.type),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
