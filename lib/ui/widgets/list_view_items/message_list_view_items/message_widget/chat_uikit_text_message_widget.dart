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
    Widget content = Text(
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

    if (message.isEdit) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: left ? TextDirection.ltr : TextDirection.rtl,
        children: [
          content,
          Text(
            '已编辑',
            style: TextStyle(
                fontWeight: theme.font.bodyExtraSmall.fontWeight,
                fontSize: theme.font.bodyExtraSmall.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralSpecialColor3
                    : theme.color.neutralSpecialColor98),
          )
        ],
      );
    }

    return content;
  }
}
