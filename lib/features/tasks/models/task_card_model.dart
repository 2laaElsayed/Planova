import 'package:flutter/material.dart';
import 'TaskModel.dart';

enum TaskPriority { Low, Medium, High }

class TaskCardModel {
  final String title;
  final String date;
  final bool isCompleted;
  final TaskPriority priority;

  TaskCardModel({
    required this.title,
    required this.date,
    this.isCompleted = false,
    required this.priority ,
  });

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.High:
        return const Color(0xFFE57373); 
      case TaskPriority.Medium:
        return const Color(0xFFFFB74D); 
      case TaskPriority.Low:
        return const Color(0xFF81C784); 
    }
  }
  factory TaskCardModel.fromTaskModel(TaskModel task) {
  return TaskCardModel(
    title: task.title,

    date:
        "${task.dueDate.day}/${task.dueDate.month}",

    isCompleted: task.status == 'done',

    priority: _mapPriority(task.priority),
  );
}
static TaskPriority _mapPriority(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return TaskPriority.High;

    case 'medium':
      return TaskPriority.Medium;

    case 'low':
    default:
      return TaskPriority.Low;
  }
}
}

