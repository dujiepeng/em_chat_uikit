import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitCardMessageWidget extends StatelessWidget {
  const ChatUIKitCardMessageWidget({
    required this.message,
    this.forceLeft,
    super.key,
  });

  final Message message;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;

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
            maxLines: 1,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1
                  : theme.color.isDark
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
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralSpecialColor7
                      : theme.color.neutralSpecialColor5
                  : theme.color.isDark
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
