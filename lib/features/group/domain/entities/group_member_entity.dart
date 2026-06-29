import 'package:planova_app/features/group/presentation/views/group_details/groups_details_view.dart';

class GroupMemberEntity {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final DateTime joinedAt;

  GroupMemberEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });
  MemberTrailing get trailingType =>
      role.toLowerCase() == 'admin' ? MemberTrailing.admin : MemberTrailing.delete;
}