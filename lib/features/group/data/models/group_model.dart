import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/group_entity.dart';

class GroupModel {
  final String groupId;
  final String name;
  final String description;
  final String createdByUid;
  final DateTime createdAt;
  final String colorHex;
  final List<String> memberUids;
  final GroupLife status;
  final ScopeTab type;

  GroupModel({
    required this.groupId,
    required this.name,
    required this.createdByUid,
    required this.createdAt,
    required this.colorHex,
    required this.memberUids,
    required this.status,
    required this.type,
    required this.description,
  });
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'],
      name: json['name'],
      description: json['description'],
      createdByUid: json['created_by_uid'],
      createdAt: (json['created_at'] as Timestamp).toDate(),
      colorHex: json['color_hex'],
      memberUids: List<String>.from(json['member_uids']),
      status: GroupLifeX.fromString(json['status'].toString().split('.').last),
      type: ScopeTab.values.firstWhere(
        (e) => e.name == json['type'].toString().split('.').last,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'created_by_uid': createdByUid,
      'created_at': createdAt,
      'color_hex': colorHex,
      'member_uids': memberUids,
      'status': status.toString(),
      'type': type.toString(),
    };
  }

  GroupModel copyWith({
    String? groupId,
    String? name,
    String? description,
    String? createdByUid,
    DateTime? createdAt,
    String? colorHex,
    List<String>? memberUids,
    GroupLife? status,
    ScopeTab? type,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      description: description ?? this.description,
      createdByUid: createdByUid ?? this.createdByUid,
      createdAt: createdAt ?? this.createdAt,
      colorHex: colorHex ?? this.colorHex,
      memberUids: memberUids ?? this.memberUids,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

extension GroupMapper on GroupModel {
  GroupEntity toEntity() {
    return GroupEntity(
      groupId: groupId,
      name: name,
      description: description,
      createdByUid: createdByUid,
      createdAt: createdAt,
      colorHex: colorHex,
      memberUids: memberUids,
      status: status,
      type: type,
    );
  }
}

extension GroupEntityMapper on GroupEntity {
  GroupModel toModel() {
    return GroupModel(
      groupId: groupId,
      name: name,
      description: description,
      createdByUid: createdByUid,
      createdAt: createdAt,
      colorHex: colorHex,
      memberUids: memberUids,
      status: status,
      type: type,
    );
  }
}

extension GroupEntityUiX on GroupEntity {
  Color get accentColor => Color(int.parse(colorHex.replaceFirst('#', '0xff')));
}
