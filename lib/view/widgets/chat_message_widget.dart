import 'package:chat_ai/constants.dart';
import 'package:chat_ai/model/chat_message.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({
    super.key,
    required this.chatMessage,
  });
  final ChatMessage chatMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: chatMessage.type == ChatMessageType.bot
            ? botBackgroundColor
            : bodyBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: chatMessage.type == ChatMessageType.bot
                  ? const Color.fromRGBO(16, 163, 127, 1)
                  : null,
            ),
            child: chatMessage.type == ChatMessageType.bot
                ? Image.asset(
                    'assets/chat.png',
                  )
                : const Icon(Icons.person, color: kWhite),
          ),
          Expanded(
            child: Text(
              chatMessage.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: kWhite),
            ),
          ),
        ],
      ),
    );
  }
}
