import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:planova_app/core/constants/app_colors.dart';
import 'package:planova_app/features/group/presentation/manager/group_details_cubit/group_details_cubit.dart';
import 'package:planova_app/features/group/presentation/views/group_details/widgets/chat_bubble.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key, required this.groupId});
  final String groupId;

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _lastMessageCount = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(GroupDetailsCubit cubit) {
    final text = _messageController.text.trim();

    if (text.isEmpty) return;

    cubit.sendMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final groupDetailsCubit = context.read<GroupDetailsCubit>();

    return Column(
      children: [
        Expanded(
          child: BlocConsumer<GroupDetailsCubit, GroupDetailsState>(
            listenWhen: (_, current) => current is GroupChatLoaded,
            listener: (context, state) {
              if (state is GroupChatLoaded &&
                  state.messages.length != _lastMessageCount) {
                _lastMessageCount = state.messages.length;
                _scrollToBottom();
              }
            },
            buildWhen: (_, current) =>
                current is GroupChatLoading ||
                current is GroupChatLoaded ||
                current is GroupChatError,
            builder: (context, state) {
              if (state is GroupChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GroupChatError) {
                return Center(
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (state is GroupChatLoaded) {
                final messages = state.messages;

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet. Say hello!",
                      style: TextStyle(
                        color: AppColors.kColdGrey,
                        fontSize: 13,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMine = message.isMine(currentUid);

                    final showSenderName =
                        !isMine &&
                        (index == 0 ||
                            messages[index - 1].senderId != message.senderId);

                    return ChatBubble(
                      message: message,
                      isMine: isMine,
                      showSenderName: showSenderName,
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),

        _buildComposer(groupDetailsCubit),
      ],
    );
  }

  Widget _buildComposer(GroupDetailsCubit cubit) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 50),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F6),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                      color: AppColors.kColdGrey,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(cubit),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
