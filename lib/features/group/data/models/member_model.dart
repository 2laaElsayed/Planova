class GroupMemberModel {
  final String userId;
  final String role;
  final DateTime joinedAt;

  GroupMemberModel({
    required this.userId,
    required this.role,
    required this.joinedAt,
  });
}
