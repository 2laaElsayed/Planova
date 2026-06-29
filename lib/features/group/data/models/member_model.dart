import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planova_app/features/group/domain/entities/group_member_entity.dart';

class GroupMemberModel extends GroupMemberEntity {
  GroupMemberModel({
    required super.uid,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.role,
    required super.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  factory GroupMemberModel.fromMap(Map<String, dynamic> map, String docId) {
    return GroupMemberModel(
      uid: docId,
      name: map['name'] ?? 'Unknown Member',
      email: map['email'] ?? '',
      avatarUrl: map['avatar_url'],
      role: map['role'] ?? 'member',
      joinedAt: map['joinedAt'] != null 
          ? (map['joinedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  factory GroupMemberModel.fromMaps({
    required Map<String, dynamic> memberDoc,
    required Map<String, dynamic> userDoc,
    required String uid,
  }) {
    return GroupMemberModel(
      uid: uid,
      name: userDoc['name'] ?? 'Unknown Member',
      email: userDoc['email'] ?? '',
      avatarUrl: userDoc['avatar_url'],
      role: memberDoc['role'] ?? 'Member',
      joinedAt: memberDoc['joinedAt'] != null 
          ? (memberDoc['joinedAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}