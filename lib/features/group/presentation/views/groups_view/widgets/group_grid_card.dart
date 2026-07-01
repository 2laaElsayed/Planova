import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/core/constants/app_router.dart';
import 'package:planova_app/core/utils/date_time_extensions.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/data/models/group_model.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/avatar_square.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/members_stack.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/scope_badge.dart';

class GroupGridCard extends StatelessWidget {
  final GroupEntity group;
  const GroupGridCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kGroupDetailsView, extra: group);
      },
      child: Container(
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
                AvatarSquare(
                  color: group.accentColor,
                  text: group.name[0],
                  size: 28,
                ),
                const Spacer(),
                Icon(Icons.circle, size: 7, color: group.status.dotColor),
                const SizedBox(width: 4),
                Text(
                  group.status.badge,
                  style: TextStyle(
                    fontSize: 9,
                    color: group.status.dotColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              group.name,
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
              formatTimeAgo(group.createdAt),
              style: const TextStyle(fontSize: 10, color: Colors.black38),
            ),
            const SizedBox(height: 8),
            ScopeBadge(scope: group.type),

            const Spacer(),
            Row(
              children: [
                MembersStack(
                  initials: group.memberUids,
                  extra: group.memberUids.length,
                ),
                const Spacer(),
                const Icon(Icons.chevron_right_rounded, color: Colors.black38),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
