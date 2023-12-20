import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitReplyBar extends StatefulWidget {
  const ChatUIKitReplyBar({
    required this.message,
    this.onCancelTap,
    this.backgroundColor,
    this.title,
    this.subTitle,
    this.leading,
    this.trailing,
    super.key,
  });

  final Widget? title;
  final Widget? subTitle;
  final Widget? leading;
  final Widget? trailing;
  final Message message;
  final VoidCallback? onCancelTap;
  final Color? backgroundColor;

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

    List<Widget> children = [];
    if (widget.leading != null) {
      children.add(widget.leading!);
    }

    children.add(Expanded(child: content));

    if (widget.trailing != null) {
      children.add(widget.trailing!);
    } else {
      if (widget.message.bodyType == MessageType.IMAGE) {
        children.add(_imagePreview());
      } else if (widget.message.bodyType == MessageType.VIDEO) {
        children.add(_videoPreview());
      }
      children.add(
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
        ),
      );
    }

    content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);
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
    return widget.title ??
        RichText(
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
    if (widget.subTitle != null) {
      return widget.subTitle!;
    }

    if (widget.message.bodyType == MessageType.TXT) {
      return _textWidget(theme);
    } else if (widget.message.bodyType == MessageType.IMAGE) {
      return _imageWidget(theme);
    } else if (widget.message.bodyType == MessageType.VIDEO) {
      return _videoWidget(theme);
    } else if (widget.message.bodyType == MessageType.VOICE) {
      return _voiceWidget(theme);
    } else if (widget.message.bodyType == MessageType.FILE) {
      return _fileWidget(theme);
    } else if (widget.message.bodyType == MessageType.CUSTOM) {
      return _customWidget(theme);
    } else {
      return const SizedBox();
    }
  }

  Widget _textWidget(ChatUIKitTheme theme) {
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
  }

  Widget _imageWidget(ChatUIKitTheme theme) {
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
        Expanded(
          child: Text(
            "图片",
            style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor6,
            ),
          ),
        )
      ],
    );
  }

  Widget _videoWidget(ChatUIKitTheme theme) {
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
        Expanded(
          child: Text(
            "视频",
            style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor6,
            ),
          ),
        )
      ],
    );
  }

  Widget _voiceWidget(ChatUIKitTheme theme) {
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
        Expanded(
          child: RichText(
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
        ),
      ],
    );
  }

  Widget _fileWidget(ChatUIKitTheme theme) {
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
        Expanded(
            child: RichText(
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
        )),
      ],
    );
  }

  Widget _customWidget(ChatUIKitTheme theme) {
    if (widget.message.isCardMessage) {
      return Row(
        children: [
          Icon(
            Icons.person_sharp,
            color: theme.color.isDark
                ? theme.color.neutralColor95
                : theme.color.neutralColor3,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
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
                    text: widget.message.cardNickname ??
                        widget.message.cardUserId,
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
    }
    return Container();
  }

  Widget _imagePreview() {
    return () {
      Widget? content;
      if (widget.message.thumbnailLocalPath?.isNotEmpty == true) {
        File file = File(widget.message.thumbnailLocalPath!);
        if (file.existsSync()) {
          content = Image(
            image: ResizeImage(
              FileImage(file),
              width: 36,
              height: 36,
            ),
            gaplessPlayback: true,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low,
          );
        }
      }

      if (widget.message.thumbnailRemotePath?.isNotEmpty == true &&
          content == null) {
        content = Image(
          image: ResizeImage(
            NetworkImage(widget.message.thumbnailRemotePath!),
            width: 36,
            height: 36,
          ),
          gaplessPlayback: true,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.low,
        );
      }

      if (widget.message.localPath?.isNotEmpty == true && content == null) {
        File file = File(widget.message.localPath!);
        if (file.existsSync()) {
          content = Image(
            image: ResizeImage(
              FileImage(file),
              width: 36,
              height: 36,
            ),
            gaplessPlayback: true,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low,
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
    }();
  }

  Widget _videoPreview() {
    return () {
      Widget? content;
      if (widget.message.thumbnailLocalPath?.isNotEmpty == true) {
        File file = File(widget.message.thumbnailLocalPath!);
        if (file.existsSync()) {
          content = Image(
            image: ResizeImage(
              FileImage(file),
              width: 36,
              height: 36,
            ),
            gaplessPlayback: true,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low,
          );
        }
      }

      if (widget.message.thumbnailRemotePath?.isNotEmpty == true &&
          content == null) {
        content = Image(
          image: ResizeImage(
            NetworkImage(widget.message.thumbnailRemotePath!),
            width: 36,
            height: 36,
          ),
          gaplessPlayback: true,
          fit: BoxFit.fill,
          filterQuality: FilterQuality.low,
        );
      }

      final theme = ChatUIKitTheme.of(context);
      content ??= Center(
        child: ChatUIKitImageLoader.videoDefault(
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
    }();
  }
}
