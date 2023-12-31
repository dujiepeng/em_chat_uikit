import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitContactItem extends StatelessWidget {
  const ChatUIKitContactItem(this.model, {super.key});

  final ContactItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle normalStyle = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor98
          : theme.color.neutralColor1,
      fontSize: theme.font.titleMedium.fontSize,
      fontWeight: theme.font.titleMedium.fontWeight,
    );

    Widget name = Text(
      model.showName,
      style: normalStyle,
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: model.avatarUrl,
      size: 40,
    );

    Widget content = Row(
      children: [
        avatar,
        const SizedBox(width: 12),
        name,
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      height: model.itemHeight - 0.5,
      color: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
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
