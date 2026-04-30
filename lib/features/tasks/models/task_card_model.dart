import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

class TaskCardModel {
  final String title;
  final String date;
  final bool isCompleted;
  final TaskPriority priority;

  TaskCardModel({
    required this.title,
    required this.date,
    this.isCompleted = false,
    this.priority = TaskPriority.low,
  });

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFE57373); 
      case TaskPriority.medium:
        return const Color(0xFFFFB74D); 
      case TaskPriority.low:
        return const Color(0xFF81C784); 
    }
  }
}
