import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitQuoteWidget extends StatefulWidget {
  const ChatUIKitQuoteWidget({
    required this.model,
    this.isLeft = false,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    super.key,
  });
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final QuoteModel model;
  final bool isLeft;
  @override
  State<ChatUIKitQuoteWidget> createState() => _ChatUIKitQuoteWidgetState();
}

class _ChatUIKitQuoteWidgetState extends State<ChatUIKitQuoteWidget> {
  late final QuoteModel model;
  Message? message;
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    if (fetched == false) {
      ChatUIKit.instance
          .loadMessage(messageId: widget.model.msgId)
          .then((value) {
        fetched = true;
        message = value;
        setState(() {});
      });
    }
    Widget content = FutureBuilder(
      future: ChatUIKit.instance.loadMessage(messageId: model.msgId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildContext(context, message: snapshot.data);
        } else {
          return _buildContext(context);
        }
      },
    );

    content = Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: content,
    );

    return content;
  }

  Widget _buildContext(BuildContext context, {Message? message}) {
    BorderRadiusGeometry? borderRadius;
    if (widget.bubbleStyle == ChatUIKitMessageListViewBubbleStyle.arrow) {
      borderRadius = const BorderRadius.all(Radius.circular(4));
    } else {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(widget.isLeft ? 12 : 16),
        bottomLeft: Radius.circular(widget.isLeft ? 4 : 16),
        topRight: Radius.circular(!widget.isLeft ? 12 : 16),
        bottomRight: Radius.circular(!widget.isLeft ? 4 : 16),
      );
    }

    final theme = ChatUIKitTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor2
            : theme.color.neutralColor95,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(8),
      child: () {
        if (message == null) {
          return _emptyWidget(theme);
        }

        MessageType type = model.msgType.getMessageType;

        switch (type) {
          case MessageType.TXT:
            return textWidget(theme, message);
          case MessageType.IMAGE:
            return imageWidget(theme, message);
          case MessageType.VIDEO:
            return videoWidget(theme, message);
          case MessageType.VOICE:
            return voiceWidget(theme, message);
          case MessageType.FILE:
            return fileWidget(theme, message);
          case MessageType.CUSTOM:
            return custom(theme, message);
          default:
        }
        return _unSupportWidget(theme);
      }(),
    );
  }

  Widget textWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname ?? message.from ?? '',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        Text(
          message.textContent,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor5,
            fontSize: theme.font.bodyMedium.fontSize,
            fontWeight: theme.font.bodyMedium.fontWeight,
          ),
        ),
      ],
    );

    return content;
  }

  Widget imageWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Icon(
            Icons.image_outlined,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor5,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            "图片",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
          ),
        )
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname ?? message.from ?? '',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: content,
        ),
        const SizedBox(width: 16),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Builder(
            builder: (context) {
              Widget? content;
              if (message.thumbnailRemotePath?.isNotEmpty == true) {
                content = Image(
                  gaplessPlayback: true,
                  image: ResizeImage(
                    NetworkImage(message.thumbnailRemotePath!),
                    width: 36,
                    height: 36,
                  ),
                  fit: BoxFit.fill,
                );
              }

              if (message.thumbnailLocalPath?.isNotEmpty == true &&
                  content == null) {
                File file = File(message.thumbnailLocalPath!);
                if (file.existsSync()) {
                  content = Image(
                    gaplessPlayback: true,
                    image: ResizeImage(
                      FileImage(file),
                      width: 36,
                      height: 36,
                    ),
                    fit: BoxFit.fill,
                  );
                }
              }

              if (message.localPath?.isNotEmpty == true) {
                File file = File(message.localPath!);
                if (file.existsSync()) {
                  content = Image(
                    gaplessPlayback: true,
                    image: ResizeImage(
                      FileImage(file),
                      width: 36,
                      height: 36,
                    ),
                    fit: BoxFit.fill,
                  );
                }
              }

              final theme = ChatUIKitTheme.of(context);
              content ??= Center(
                child: ChatUIKitImageLoader.imageDefault(
                  size: 24,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor7,
                ),
              );

              content = Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: theme.color.isDark
                        ? theme.color.neutralColor3
                        : theme.color.neutralColor8,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: theme.color.isDark
                        ? theme.color.neutralColor3
                        : theme.color.neutralColor8,
                  ),
                ),
                child: content,
              );

              return content;
            },
          ),
        ),
      ],
    );
    return content;
  }

  Widget videoWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.videoDefault(
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            "视频",
            style: TextStyle(
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
          ),
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname ?? message.from ?? '',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );
    bool hasLoad = true;

    Widget videoWidget = () {
      Widget? content;

      if (message.thumbnailLocalPath?.isNotEmpty == true) {
        File file = File(message.thumbnailLocalPath!);
        if (file.existsSync()) {
          content = Image(
            gaplessPlayback: true,
            image: ResizeImage(
              FileImage(file),
              width: 36,
              height: 36,
            ),
            fit: BoxFit.fill,
          );
        }
      }

      if (message.thumbnailRemotePath?.isNotEmpty == true && content == null) {
        content = Image(
          gaplessPlayback: true,
          image: ResizeImage(
            NetworkImage(message.thumbnailRemotePath!),
            width: 36,
            height: 36,
          ),
          fit: BoxFit.fill,
        );
      }

      final theme = ChatUIKitTheme.of(context);
      content ??= () {
        hasLoad = false;
        return Center(
          child: ChatUIKitImageLoader.videoDefault(
            size: 24,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        );
      }();
      content = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor8,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor8,
          ),
        ),
        child: content,
      );
      return content;
    }();

    content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: content,
        ),
        const SizedBox(width: 16),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              videoWidget,
              if (hasLoad)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 20,
                      color: theme.color.isDark
                          ? theme.color.neutralColor1
                          : theme.color.neutralColor98,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    return content;
  }

  Widget voiceWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          fit: FlexFit.loose,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
                  text: "${message.duration}''",
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
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname ?? message.from ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );
    return content;
  }

  Widget fileWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
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
        Flexible(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                  text: message.displayName,
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
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.nickname ?? message.from ?? '',
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );

    return content;
  }

  Widget custom(ChatUIKitTheme theme, Message message) {
    if (model.msgType == MessageType.CUSTOM.getString &&
        message.isCardMessage) {
      Widget content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_sharp,
            color: theme.color.isDark
                ? theme.color.neutralColor95
                : theme.color.neutralColor3,
            size: 16,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '联系人 ',
                    style: TextStyle(
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralColor6
                          : theme.color.neutralColor5,
                    ),
                  ),
                  TextSpan(
                    text: message.cardNickname ?? message.cardUserId,
                    style: TextStyle(
                      fontWeight: theme.font.bodyMedium.fontWeight,
                      fontSize: theme.font.bodyMedium.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralSpecialColor6
                          : theme.color.neutralSpecialColor5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.nickname ?? message.from ?? '',
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor5
                  : theme.color.neutralSpecialColor6,
              fontSize: theme.font.labelSmall.fontSize,
              fontWeight: theme.font.labelSmall.fontWeight,
            ),
          ),
          content,
        ],
      );

      return content;
    }
    return Container();
  }

  Widget _emptyWidget(ChatUIKitTheme theme) {
    return Text(
      '未找到原消息',
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
        fontSize: theme.font.bodyMedium.fontSize,
        fontWeight: theme.font.bodyMedium.fontWeight,
      ),
    );
  }

  Widget _unSupportWidget(ChatUIKitTheme theme) {
    return Text(
      '不支持的消息类型',
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
        fontSize: theme.font.bodyMedium.fontSize,
        fontWeight: theme.font.bodyMedium.fontWeight,
      ),
    );
  }
}
