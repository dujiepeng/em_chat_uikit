import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitCardMessageWidget extends StatelessWidget {
  const ChatUIKitCardMessageWidget({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
          child: ChatUIKitAvatar(
            avatarUrl: message.cardUserAvatar,
            size: 44,
          ),
        ),
        Expanded(
          child: Text(
            message.cardUserNickname ?? message.cardUserId!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor1
                  : theme.color.neutralColor98,
            ),
          ),
        )
      ],
    );

    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        Divider(
          height: 1,
          thickness: 0,
          color: theme.color.isDark
              ? theme.color.primaryColor9
              : theme.color.primaryColor8,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '联系人',
            style: TextStyle(
              fontWeight: theme.font.bodyExtraSmall.fontWeight,
              fontSize: theme.font.bodyExtraSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor3
                  : theme.color.neutralSpecialColor98,
            ),
          ),
        )
      ],
    );
    return content;
  }
}
