import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import 'chat_indicator.dart';
import '../../../data/services/chat_message.dart';

class ChatList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const ChatList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];

        // =====================
        // TYPING
        // =====================
        if (msg.type == 'typing') {
          return const Align(
            alignment: Alignment.centerLeft,
            child: ChatBubble(
              isUser: false,
              child: TypingIndicator(),
            ),
          );
        }

        // =====================
        // RESULT (chart + widget)
        // =====================
        if (msg.type == 'result') {
          return Align(
            alignment: Alignment.centerLeft,
            child: ChatBubble(
              isUser: false,
              child: msg.widget,
            ),
          );
        }

        // =====================
        // TEXT MESSAGE
        // =====================
        return ChatBubble(
          text: msg.text,
          isUser: msg.isUser,
        );
      },
    );
  }
}