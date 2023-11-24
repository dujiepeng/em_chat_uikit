import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitConversationItem extends StatelessWidget {
  const ChatUIKitConversationItem(
    this.model, {
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final ConversationItemModel model;

  final void Function(ConversationItemModel model)? onTap;

  final void Function(ConversationItemModel model)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = InkWell(
      onTap: () {
        onTap?.call(model);
      },
      onLongPress: () {
        onLongPress?.call(model);
      },
    );

    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      height: model.itemHeight - 0.5,
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
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
