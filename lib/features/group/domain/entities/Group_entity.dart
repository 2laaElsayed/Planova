import 'package:planova_app/features/group/data/models/group_item.dart';

class GroupEntity {
  final String groupId;
  final String name;
  final String description;
  final String createdByUid;
  final DateTime createdAt;
  final String colorHex;
  final List<String> memberUids;
  final GroupLife status;
  final ScopeTab type;

  GroupEntity({
    required this.groupId,
    required this.name,
    required this.description,
    required this.createdByUid,
    required this.createdAt,
    required this.colorHex,
    required this.memberUids,
    required this.status,
    required this.type,
  });
}