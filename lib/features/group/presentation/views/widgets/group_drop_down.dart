
import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class GroupDropDown extends StatelessWidget {
  const GroupDropDown({
    required this.isLocked,
    required this.lockedName,
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
  });

  final bool isLocked;
  final String? lockedName;
  final List groups;
  final String? selectedGroupId;
  final void Function(String groupId, String groupName) onChanged;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: isLocked ? const Color(0xFFF1F1F6) : AppColors.kWhite,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.kStroke),
    );

    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: decoration,
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 14, color: AppColors.kColdGrey),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                lockedName ?? 'Group',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppColors.kDarkBlue),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: decoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedGroupId,
          hint: const Text("Group", style: TextStyle(fontSize: 13)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: groups
              .map<DropdownMenuItem<String>>(
                (g) => DropdownMenuItem(
                  value: g.groupId as String,
                  child: Text(
                    g.name as String,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: (newId) {
            if (newId == null) return;
            final match = groups.firstWhere((g) => g.groupId == newId);
            onChanged(newId, match.name as String);
          },
        ),
      ),
    );
  }
}

