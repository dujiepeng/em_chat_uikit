import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitNonsupportMessageWidget extends StatelessWidget {
  const ChatUIKitNonsupportMessageWidget({
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
      '不支持的消息类型',
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor7,
                )
              : TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor6,
                )),
    );

    return content;
  }
}
