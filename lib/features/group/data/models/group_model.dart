import 'package:planova_app/features/group/data/models/group_item.dart';
import 'package:planova_app/features/group/domain/entities/Group_entity.dart';

class GroupModel {
  final String groupId;
  final String name;
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
  });

  factory GroupModel.fromJson(Json) {
    return GroupModel(
      groupId: Json['groupId'],
      name: Json['name'],
      createdByUid: Json['created_by_uid'],
      createdAt: Json['created_at'],
      colorHex: Json['color_hex'],
      memberUids: Json['member_uids'],
      status: Json['status'],
      type: Json['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'name': name,
      'created_by_uid': createdByUid,
      'created_at': createdAt,
      'color_hex': colorHex,
      'member_uids': memberUids,
      'status': status,
      'type': type,
    };
  }
}

extension GroupMapper on GroupModel {
  GroupEntity toEntity() {
    return GroupEntity(
      groupId: groupId,
      name: name,
      createdByUid: createdByUid,
      createdAt: createdAt,
      colorHex: colorHex,
      memberUids: memberUids,
      status: status,
      type: type,
    );
  }
}

extension GroupEntityMapper on GroupModel {
  GroupModel fromEntity() {
    return GroupModel(
      groupId: groupId,
      name: name,
      createdByUid: createdByUid,
      createdAt: createdAt,
      colorHex: colorHex,
      memberUids: memberUids,
      status: status,
      type: type,
    );
  }
}
