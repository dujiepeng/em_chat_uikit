import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitVideoMessageWidget extends StatefulWidget {
  const ChatUIKitVideoMessageWidget({required this.message, super.key});
  final Message message;

  @override
  State<ChatUIKitVideoMessageWidget> createState() =>
      _ChatUIKitVideoMessageWidgetState();
}

class _ChatUIKitVideoMessageWidgetState
    extends State<ChatUIKitVideoMessageWidget> with MessageObserver {
  late final Message message;
  bool downloading = false;
  bool downloadError = false;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    message = widget.message;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (msgId == message.msgId) {
      downloading = false;
      setState(() {});
    }
  }

  @override
  void onError(String msgId, Message message, ChatError error) {
    if (msgId == message.msgId) {
      downloading = false;
      downloadError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = message.direction == MessageDirection.RECEIVE;
    String? thumbnailLocalPath = message.thumbnailLocalPath;
    double width = message.width;
    double height = message.height;
    double aspectRatio = width / height;

    if (aspectRatio < 0.1) {
      height = min(height, width * 10);
      if (height > maxImageHeight) {
        height = maxImageHeight;
        width = height / 10;
      }
    } else if (aspectRatio >= 0.1 && aspectRatio < 0.75) {
      if (height > maxImageHeight) {
        height = maxImageHeight;
        width = height * aspectRatio;
      }
    } else if (aspectRatio >= 0.75 && aspectRatio <= 1) {
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / aspectRatio;
      }
    } else if (aspectRatio > 1 && aspectRatio <= 10) {
      width = maxImageWidth;
      height = width / aspectRatio;
    } else {
      width = min(width, height * 10);
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / 10;
      }
    }

    if (maxImageWidth / width > maxImageHeight / height) {
      double ratio = maxImageWidth / width;
      width = maxImageWidth;
      height = height * ratio;
    } else {
      double ratio = maxImageHeight / height;
      height = maxImageHeight;
      width = width * ratio;
    }

    Widget? content;

    if (downloadError) {
      content = loadError(width, height);
      return content;
    }
    if (thumbnailLocalPath?.isNotEmpty == true) {
      final file = File(thumbnailLocalPath!);
      bool exists = file.existsSync();
      if (exists) {
        content = Image(
          image: ResizeImage(
            FileImage(file),
            width: width.toInt(),
            height: height.toInt(),
          ),
          gaplessPlayback: true,
          excludeFromSemantics: true,
          alignment: left ? Alignment.centerLeft : Alignment.centerRight,
          fit: width > height ? BoxFit.fitHeight : BoxFit.fitWidth,
          filterQuality: FilterQuality.low,
        );
      }
    }

    if (content == null) {
      download();
      content = SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    content = Stack(
      children: [
        content,
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.play_circle_outline,
              size: 64,
              color: theme.color.isDark
                  ? theme.color.neutralColor1
                  : theme.color.neutralColor98,
            ),
          ),
        ),
      ],
    );

    return content;
  }

  void download() {
    if (downloading) return;
    downloading = true;
    ChatUIKit.instance.downloadThumbnail(message: message);
    setState(() {});
  }

  Widget loadError(double width, double height) {
    final theme = ChatUIKitTheme.of(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor3
            : theme.color.neutralColor8,
      ),
      child: Center(
        child: ChatUIKitImageLoader.videoDefault(
          size: 64,
          color: theme.color.isDark
              ? theme.color.neutralColor5
              : theme.color.neutralColor7,
        ),
      ),
    );
  }
}
