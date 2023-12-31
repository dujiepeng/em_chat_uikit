import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/tools/chat_uikit_highlight_tool.dart';

import 'package:flutter/material.dart';

class ChatUIKitSearchItem extends StatelessWidget {
  final ChatUIKitProfile profile;
  final String? highlightWord;

  const ChatUIKitSearchItem({
    required this.profile,
    this.highlightWord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget name = HighlightTool.highlightWidget(
      context,
      profile.name ?? profile.id,
      searchKey: highlightWord,
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: profile.avatarUrl,
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
      height: 60 - 0.5,
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
