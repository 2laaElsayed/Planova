import 'package:flutter/material.dart';
import 'package:planova_app/features/tasks/models/task_card_model.dart';

class TaskCard extends StatelessWidget {
  final TaskCardModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24,
                height: 24,

                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? const Color(0xFF9BA3EB)
                      : Colors.white,

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: task.isCompleted
                        ? const Color(0xFF9BA3EB)
                        : Colors.grey[300]!,

                    width: 2,
                  ),
                ),

                child: task.isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    task.title,

                    style: TextStyle(
                      fontSize: 16,

                      fontWeight:
                          FontWeight.w500,

                      color:
                          const Color(0xFF2D2D2D),

                      decoration:
                          task.isCompleted
                              ? TextDecoration
                                  .lineThrough
                              : null,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [

                      Icon(
                        Icons.access_time,
                        size: 14,
                        color:
                            Colors.grey[400],
                      ),

                      const SizedBox(width: 4),

                      Text(
                        task.date,

                        style: TextStyle(
                          fontSize: 12,

                          color:
                              Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              Icons.outlined_flag,

              color: task.priorityColor
                  .withOpacity(0.7),

              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}