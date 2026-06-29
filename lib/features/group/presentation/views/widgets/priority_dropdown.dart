
import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';

class PriorityDropdown extends StatelessWidget {
  const PriorityDropdown({required this.value, required this.onChanged});
  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TaskPriority>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: TaskPriority.values
              .map(
                (p) => DropdownMenuItem(
                  value: p,
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 14, color: AppColors.kPrimary),
                      const SizedBox(width: 6),
                      Text(p.label, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}



