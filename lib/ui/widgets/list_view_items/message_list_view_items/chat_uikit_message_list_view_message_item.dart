import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitMessageListViewMessageItem extends StatelessWidget {
  const ChatUIKitMessageListViewMessageItem({
    required this.message,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.showAvatar = true,
    this.showNickname = true,
    this.messageWidget,
    this.avatarWidget,
    this.nicknameWidget,
    this.onNicknameTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onBubbleTap,
    this.onBubbleLongPressed,
    this.onBubbleDoubleTap,
    this.isLeft,
    this.isPlaying = false,
    super.key,
  });

  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final Message message;
  final bool showAvatar;
  final bool showNickname;
  final bool? isLeft;
  final Widget? messageWidget;
  final Widget? avatarWidget;
  final Widget? nicknameWidget;
  final bool isPlaying;

  final VoidCallback? onAvatarTap;
  final VoidCallback? onAvatarLongPressed;
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
    } else if (message.bodyType == MessageType.CUSTOM) {
      if (message.isCardMessage) {
        msgWidget = _buildCardMessage(context, message);
      }
    }
    msgWidget ??= const SizedBox();

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

    content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChatUIKitMessageStatusWidget(
          size: 16,
          statusType: () {
            if (message.status == MessageStatus.CREATE ||
                message.status == MessageStatus.PROGRESS) {
              return MessageStatusType.loading;
            } else if (message.status == MessageStatus.FAIL) {
              return MessageStatusType.fail;
            } else {
              if (message.hasDeliverAck) {
                return MessageStatusType.deliver;
              } else if (message.hasReadAck) {
                return MessageStatusType.read;
              }
              return MessageStatusType.succeed;
            }
          }(),
        ),
        const SizedBox(width: 4),
        Flexible(flex: 1, fit: FlexFit.loose, child: content),
      ],
    );

    if (showNickname) {
      content = Column(
        crossAxisAlignment:
            isLeft ?? left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _nickname(theme),
          content,
          SizedBox(
            height: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: isLeft ?? left
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              textDirection:
                  isLeft ?? left ? TextDirection.ltr : TextDirection.rtl,
              children: [
                const SizedBox(width: arrowWidth),
                Text(
                  ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                        context,
                        ChatUIKitTimeType.message,
                        message.serverTime,
                      ) ??
                      ChatUIKitTimeTool.getChatTimeStr(message.serverTime),
                  textDirection:
                      isLeft ?? left ? TextDirection.ltr : TextDirection.rtl,
                  style: TextStyle(
                      fontWeight: theme.font.bodySmall.fontWeight,
                      fontSize: theme.font.bodySmall.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralColor5
                          : theme.color.neutralColor7),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget avatar = _avatar(theme);
    avatar = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: avatar,
    );

    content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: isLeft ?? left ? TextDirection.ltr : TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(width: 8),
        Expanded(child: content),
      ],
    );

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

  Widget _buildCardMessage(BuildContext context, Message message) {
    return ChatUIKitCardMessageWidget(message: message);
  }

  Widget _avatar(ChatUIKitTheme theme) {
    Widget? content;
    if (!showAvatar) {
      content = const SizedBox();
    } else {
      content = avatarWidget;
      content ??= ChatUIKitAvatar(avatarUrl: message.avatarUrl);
    }

    content = InkWell(
      onTap: onAvatarTap,
      onLongPress: onAvatarLongPressed,
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
