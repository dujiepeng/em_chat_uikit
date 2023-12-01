import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitBadge extends StatelessWidget {
  const ChatUIKitBadge(this.count, {super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 1, 4, 2),
      constraints:
          const BoxConstraints(minWidth: 20, maxHeight: 20, minHeight: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
          fontSize: theme.font.labelSmall.fontSize,
          fontWeight: theme.font.labelSmall.fontWeight,
        ),
      ),
    );
  }
}
