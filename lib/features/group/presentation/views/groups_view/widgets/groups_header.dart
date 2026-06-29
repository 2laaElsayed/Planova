import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/presentation/views/groups_view/widgets/mode_button.dart';

class GroupsHeader extends StatelessWidget {
  final ViewMode mode;
  final Function(ViewMode) onModeChange;

  const GroupsHeader({
    super.key,
    required this.mode,
    required this.onModeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Groups',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppColors.kTextDark,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E9F2)),
          ),
          child: Row(
            children: [
              ModeButton(
                icon: Icons.grid_view_rounded,
                selected: mode == ViewMode.grid,
                onTap: () => onModeChange(ViewMode.grid),
              ),
              ModeButton(
                icon: Icons.view_list_rounded,
                selected: mode == ViewMode.list,
                onTap: () => onModeChange(ViewMode.list),
              ),
            ],
          ),
        ),
      ],
    );
  }
}