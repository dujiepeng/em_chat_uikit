import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitTextMessageWidget extends StatelessWidget {
  const ChatUIKitTextMessageWidget({
    required this.message,
    this.style,
    super.key,
  });
  final TextStyle? style;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = message.direction == MessageDirection.RECEIVE;
    return Text(
      message.textContent,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                )
              : TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );
  }
}
