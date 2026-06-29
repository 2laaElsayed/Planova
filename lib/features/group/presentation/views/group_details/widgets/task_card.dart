import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});

  final GroupTaskEntity task;
  final ValueChanged<bool> onToggle;

  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.high:
        return const Color(0xFFE57373);
      case TaskPriority.medium:
        return const Color(0xFFF2C14E);
      case TaskPriority.low:
        return const Color(0xFF7CB97C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(!task.isCompleted),
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? AppColors.kPrimary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: task.isCompleted
                      ? AppColors.kPrimary
                      : AppColors.kStroke,
                  width: 1.5,
                ),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kDarkBlue,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM d').format(task.dueDate),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.kColdGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _priorityColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
