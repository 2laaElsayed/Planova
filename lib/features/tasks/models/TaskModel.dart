import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String taskId;
  final String title;
  final String description;
  final String priority;
  final String? groupId;
  final String taskType;
  final DateTime dueDate;
  final bool reminderEnabled;
  final String status;
  final String ownerUid;
  final DateTime createdAt;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.description,
    required this.priority,
    this.groupId,
    required this.taskType,
    required this.dueDate,
    required this.reminderEnabled,
    required this.status,
    required this.ownerUid,
    required this.createdAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TaskModel(
      taskId: data['task_id'] ?? doc.id,

      title: data['title'] ?? '',

      description: data['description'] ?? '',

      priority: data['priority'] ?? 'Medium',

      groupId: data['groupId'],

      taskType: data['task_type'] ?? 'Personal',

      dueDate:
          (data['due_date'] as Timestamp).toDate(),

      reminderEnabled:
          data['reminder_enabled'] ?? false,

      status: data['status'] ?? 'todo',

      ownerUid: data['owner_uid'] ?? '',

      createdAt:
          (data['created_at'] as Timestamp)
              .toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'task_id': taskId,

      'title': title,

      'description': description,

      'priority': priority,

      'groupId': groupId,

      'task_type': taskType,

      'due_date': Timestamp.fromDate(dueDate),

      'reminder_enabled': reminderEnabled,

      'status': status,

      'owner_uid': ownerUid,

      'created_at':
          Timestamp.fromDate(createdAt),
    };
  }

  TaskModel copyWith({
    String? taskId,
    String? title,
    String? description,
    String? priority,
    String? groupId,
    String? taskType,
    DateTime? dueDate,
    bool? reminderEnabled,
    String? status,
    String? ownerUid,
    DateTime? createdAt,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,

      title: title ?? this.title,

      description:
          description ?? this.description,

      priority: priority ?? this.priority,

      groupId: groupId ?? this.groupId,

      taskType: taskType ?? this.taskType,

      dueDate: dueDate ?? this.dueDate,

      reminderEnabled:
          reminderEnabled ??
              this.reminderEnabled,

      status: status ?? this.status,

      ownerUid: ownerUid ?? this.ownerUid,

      createdAt: createdAt ?? this.createdAt,
    );
  }
}