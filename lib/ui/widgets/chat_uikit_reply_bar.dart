import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitReplyBar extends StatefulWidget {
  const ChatUIKitReplyBar({
    required this.message,
    this.onCancelTap,
    super.key,
  });

  final Message message;
  final VoidCallback? onCancelTap;

  @override
  State<ChatUIKitReplyBar> createState() => _ChatUIKitReplyBarState();
}

class _ChatUIKitReplyBarState extends State<ChatUIKitReplyBar> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title(theme),
        const SizedBox(height: 4),
        subTitle(theme),
      ],
    );

    content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: content),
        if (widget.message.bodyType == MessageType.IMAGE ||
            widget.message.bodyType == MessageType.VIDEO)
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FadeInImage(
              width: 36,
              height: 36,
              placeholder: const NetworkImage(''),
              placeholderFit: BoxFit.fill,
              placeholderErrorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.red,
                );
              },
              image: NetworkImage(widget.message.thumbnailRemotePath!),
              fit: BoxFit.fill,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: InkWell(
            onTap: () {
              if (widget.onCancelTap != null) {
                widget.onCancelTap!();
              }
            },
            child: Icon(
              Icons.cancel,
              size: 20,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
            ),
          ),
        )
      ],
    );

    content = Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
      color: theme.color.isDark
          ? theme.color.neutralColor2
          : theme.color.neutralColor9,
      child: content,
    );

    return content;
  }

  Widget title(ChatUIKitTheme theme) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '正在回复 ',
            style: TextStyle(
              fontWeight: theme.font.bodySmall.fontWeight,
              fontSize: theme.font.bodySmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5,
            ),
          ),
          TextSpan(
            text: widget.message.nickname ?? widget.message.from!,
            style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5,
            ),
          ),
        ],
      ),
    );
  }

  Widget subTitle(ChatUIKitTheme theme) {
    if (widget.message.bodyType == MessageType.TXT) {
      return Text(
        widget.message.textContent,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: theme.font.bodySmall.fontWeight,
          fontSize: theme.font.bodySmall.fontSize,
          color: theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor5,
        ),
      );
    } else if (widget.message.bodyType == MessageType.IMAGE ||
        widget.message.bodyType == MessageType.VIDEO) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: Icon(
              Icons.image_outlined,
              size: 16,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor6,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            widget.message.bodyType == MessageType.IMAGE ? "图片" : "视频",
            style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor6,
            ),
          ),
        ],
      );
    } else if (widget.message.bodyType == MessageType.VOICE) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: ChatUIKitImageLoader.bubbleVoice(2,
                color: theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor5),
          ),
          const SizedBox(width: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '语音 ',
                  style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
                TextSpan(
                  text: "${widget.message.duration}''",
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (widget.message.bodyType == MessageType.FILE) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: ChatUIKitImageLoader.file(
                size: 32,
                color: theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor7),
          ),
          const SizedBox(width: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '附件 ',
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
                TextSpan(
                  text: widget.message.displayName,
                  style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
