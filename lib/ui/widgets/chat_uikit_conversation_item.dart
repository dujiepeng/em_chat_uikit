import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitConversationItem extends StatelessWidget {
  const ChatUIKitConversationItem(this.model, {this.highlightWord, super.key});
  final String? highlightWord;
  final ConversationItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
    );

    content = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: content),
        Container(
          height: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ],
    );

    return content;
  }
}
