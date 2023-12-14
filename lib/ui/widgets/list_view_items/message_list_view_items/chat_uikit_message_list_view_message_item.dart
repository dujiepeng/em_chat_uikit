import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitMessageListViewMessageItem extends StatelessWidget {
  const ChatUIKitMessageListViewMessageItem({
    required this.message,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.enableAvatar = true,
    this.enableNickname = true,
    this.messageWidget,
    this.avatarWidget,
    this.nicknameWidget,
    this.onNicknameTap,
    this.onAvatarTap,
    this.onBubbleTap,
    this.onBubbleLongPressed,
    this.onBubbleDoubleTap,
    this.isLeft,
    this.isPlaying = false,
    super.key,
  });

  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final Message message;
  final bool enableAvatar;
  final bool enableNickname;
  final bool? isLeft;
  final Widget? messageWidget;
  final Widget? avatarWidget;
  final Widget? nicknameWidget;
  final bool isPlaying;

  final VoidCallback? onAvatarTap;
  final VoidCallback? onNicknameTap;
  final VoidCallback? onBubbleTap;
  final VoidCallback? onBubbleLongPressed;
  final VoidCallback? onBubbleDoubleTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    bool left = message.direction == MessageDirection.RECEIVE;

    Widget? msgWidget = messageWidget;

    if (message.bodyType == MessageType.TXT) {
      msgWidget = _buildTextMessage(context, message);
    } else if (message.bodyType == MessageType.IMAGE) {
      msgWidget = _buildImageMessage(context, message);
    } else if (message.bodyType == MessageType.VOICE) {
      msgWidget = _buildVoiceMessage(context, message);
    } else if (message.bodyType == MessageType.VIDEO) {
      msgWidget = _buildVideoMessage(context, message);
    } else if (message.bodyType == MessageType.FILE) {
      msgWidget = _buildFileMessage(context, message);
    } else {
      msgWidget = const SizedBox();
    }

    Widget content;

    if (message.bodyType == MessageType.VIDEO ||
        message.bodyType == MessageType.IMAGE) {
      content = Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              bubbleStyle == ChatUIKitMessageListViewBubbleStyle.arrow
                  ? 4
                  : 16),
        ),
        child: msgWidget,
      );
    } else {
      content = ChatUIKitMessageListViewBubble(
        style: bubbleStyle,
        isLeft: isLeft ?? left,
        child: msgWidget,
      );
    }
    content = InkWell(
      onTap: onBubbleTap,
      onDoubleTap: onBubbleDoubleTap,
      onLongPress: onBubbleLongPressed,
      child: content,
    );

    if (enableNickname) {
      content = Column(
        crossAxisAlignment:
            isLeft ?? left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _nickname(theme),
          content,
        ],
      );
    }

    Widget avatar = _avatar(theme);

    // TODO: 状态widget
    content = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: isLeft ?? left ? TextDirection.ltr : TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(width: 8),
        Expanded(child: content),
        SizedBox(width: MediaQuery.of(context).size.width / 5 * 1)
      ],
    );

    content = SizedBox(width: 150, child: content);

    content = Container(
      margin: const EdgeInsets.only(top: 16, bottom: 2),
      child: content,
    );

    return content;
  }

  Widget _buildTextMessage(BuildContext context, Message message) {
    return ChatUIKitTextMessageWidget(message: message);
  }

  Widget _buildImageMessage(BuildContext context, Message message) {
    return ChatUIKitImageMessageWidget(message: message);
  }

  Widget _buildVoiceMessage(BuildContext context, Message message) {
    return ChatUIKitVoiceMessageWidget(
      message: message,
      playing: isPlaying,
    );
  }

  Widget _buildVideoMessage(BuildContext context, Message message) {
    return ChatUIKitVideoMessageWidget(message: message);
  }

  Widget _buildFileMessage(BuildContext context, Message message) {
    return ChatUIKitFileMessageWidget(
      message: message,
      bubbleStyle: bubbleStyle,
    );
  }

  Widget _avatar(ChatUIKitTheme theme) {
    Widget? content;
    if (!enableAvatar) {
      content = const SizedBox();
    } else {
      content = avatarWidget;
      content ??= ChatUIKitAvatar(avatarUrl: message.avatarUrl);
    }

    content = InkWell(
      onTap: onAvatarTap,
      child: content,
    );

    return content;
  }

  Widget _nickname(ChatUIKitTheme theme) {
    Widget content = Text(
      message.nickname ?? message.from ?? '',
      style: TextStyle(
          fontWeight: theme.font.labelExtraSmall.fontWeight,
          fontSize: theme.font.labelExtraSmall.fontSize,
          color: theme.color.isDark
              ? theme.color.neutralSpecialColor6
              : theme.color.neutralSpecialColor5),
    );

    content = InkWell(
      onTap: onNicknameTap,
      child: content,
    );

    return Padding(
      padding: const EdgeInsets.only(left: arrowWidth),
      child: content,
    );
  }
}
