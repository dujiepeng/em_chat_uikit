import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitFileMessageWidget extends StatelessWidget {
  const ChatUIKitFileMessageWidget({
    required this.message,
    this.titleStyle,
    this.subTitleStyle,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.icon,
    super.key,
  });
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Message message;
  final Widget? icon;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = message.direction == MessageDirection.RECEIVE;

    Widget title = Text(
      message.displayName ?? '',
      overflow: TextOverflow.ellipsis,
      style: titleStyle ??
          TextStyle(
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
    );
    Widget subTitle = Text(
      message.fileSize,
      overflow: TextOverflow.ellipsis,
      style: subTitleStyle ??
          TextStyle(
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralSpecialColor5
                : theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor95,
          ),
    );

    Widget fileIcon = ChatUIKitImageLoader.file(
        size: 32,
        color: theme.color.isDark
            ? theme.color.neutralColor6
            : theme.color.neutralColor7);
    fileIcon = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
              bubbleStyle == ChatUIKitMessageListViewBubbleStyle.arrow
                  ? 4
                  : 8)),
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor100),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      width: 44,
      height: 44,
      child: fileIcon,
    );

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, subTitle],
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: !left ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: content),
        const SizedBox(width: 12),
        icon ?? fileIcon
      ],
    );

    return content;
  }
}
