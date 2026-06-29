enum TaskPriority { high, medium, low }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  static TaskPriority fromString(String? value) {
    switch (value) {
      case 'high':
        return TaskPriority.high;
      case 'low':
        return TaskPriority.low;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }
}

class GroupTaskEntity {
  final String id;
  final String groupId;
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime dueDate;
  final bool isCompleted;
  final String createdByUid;
  final DateTime createdAt;

  GroupTaskEntity({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
    required this.createdByUid,
    required this.createdAt,
  });

  GroupTaskEntity copyWith({bool? isCompleted}) {
    return GroupTaskEntity(
      id: id,
      groupId: groupId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdByUid: createdByUid,
      createdAt: createdAt,
    );
  }
}