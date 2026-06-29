import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planova_app/features/group/domain/entities/group_task_entity.dart';

class GroupTaskModel extends GroupTaskEntity {
  GroupTaskModel({
    required super.id,
    required super.groupId,
    required super.title,
    required super.description,
    required super.priority,
    required super.dueDate,
    required super.isCompleted,
    required super.createdByUid,
    required super.createdAt,
  });

  factory GroupTaskModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String groupId,
  ) {
    return GroupTaskModel(
      id: id,
      groupId: groupId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: TaskPriorityX.fromString(map['priority']),
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : DateTime.now(),
      isCompleted: map['isCompleted'] ?? false,
      createdByUid: map['createdByUid'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'createdByUid': createdByUid,
      'createdAt': createdAt,
    };
  }
}

extension GroupTaskEntityMapper on GroupTaskEntity {
  GroupTaskModel toModel() {
    return GroupTaskModel(
      id: id,
      groupId: groupId,
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdByUid: createdByUid,
      createdAt: createdAt,
    );
  }
}