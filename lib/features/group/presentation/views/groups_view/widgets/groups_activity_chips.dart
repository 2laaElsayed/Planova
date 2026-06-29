import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';

class GroupsActivityChips extends StatelessWidget {
  final ActivityFilter selected;
  final Function(ActivityFilter) onChange;

  const GroupsActivityChips({
    super.key,
    required this.selected,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, ActivityFilter value) {
      final isSelected = selected == value;

      return GestureDetector(
        onTap: () => onChange(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.kPrimary : const Color(0xFFEFF0F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        chip('All', ActivityFilter.all),
        chip('Active', ActivityFilter.active),
        chip('Completed', ActivityFilter.completed),
        chip('Archived', ActivityFilter.archived),
      ],
    );
  }
}
