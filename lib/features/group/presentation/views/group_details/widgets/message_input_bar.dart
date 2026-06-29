import 'package:flutter/material.dart';
import 'package:planova_app/core/constants/app_colors.dart';

class MessageInputBar extends StatelessWidget {
  const MessageInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kStroke),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F2F8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.attach_file,
              size: 16,
              color: AppColors.kColdGrey,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Type a message...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.kColdGrey),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.kPrimary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_rounded,
              size: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
