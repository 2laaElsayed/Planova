import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';

class GroupMessageModel extends GroupMessageEntity {
  GroupMessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.message,
    required super.timestamp,
  });

  factory GroupMessageModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupMessageModel(
      id: id,
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? 'Unknown',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
    };
  }
}