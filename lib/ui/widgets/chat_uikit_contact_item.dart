import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/tools/chat_uikit_highlight_tool.dart';
import 'package:flutter/material.dart';

class ChatUIKitContactItem extends StatelessWidget {
  const ChatUIKitContactItem(this.model, {this.highlightWork, super.key});

  final String? highlightWork;
  final ContactItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget name = HighlightTool.highlightWidget(
      context,
      model.showName,
      searchKey: highlightWork,
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