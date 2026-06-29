class GroupMessageEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  GroupMessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  bool isMine(String currentUid) => senderId == currentUid;
}