import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/domain/entities/group_message_entity.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.showSenderName,
  });

  final GroupMessageEntity message;
  final bool isMine;
  final bool showSenderName;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? AppColors.kPrimary : const Color(0xFFF1F1F6);
    final textColor = isMine ? Colors.white : AppColors.kDarkBlue;
    final timeColor = isMine ? Colors.white70 : AppColors.kColdGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSenderName)
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kPrimary,
                ),
              ),
            ),
          Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(isMine ? 14 : 2),
                  bottomRight: Radius.circular(isMine ? 2 : 14),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(fontSize: 13.5, color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('h:mm a').format(message.timestamp),
                    style: TextStyle(fontSize: 9.5, color: timeColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}