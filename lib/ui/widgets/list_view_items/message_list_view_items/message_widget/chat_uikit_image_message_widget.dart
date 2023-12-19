import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

double maxImageWidth = 225;
double maxImageHeight = 300;

class ChatUIKitImageMessageWidget extends StatefulWidget {
  const ChatUIKitImageMessageWidget({required this.message, super.key});
  final Message message;

  @override
  State<ChatUIKitImageMessageWidget> createState() =>
      _ChatUIKitImageMessageWidgetState();
}

class _ChatUIKitImageMessageWidgetState
    extends State<ChatUIKitImageMessageWidget> with MessageObserver {
  late final Message message;
  bool downloading = false;

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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool left = message.direction == MessageDirection.RECEIVE;

    String? localPath = message.localPath;
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
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / aspectRatio;
      }
    } else {
      width = min(width, height * 10);
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / 10;
      }
    }

    Widget? content;
    if (thumbnailLocalPath?.isNotEmpty == true) {
      final file = File(thumbnailLocalPath!);
      bool exists = file.existsSync();
      if (exists) {
        content = Image.file(
          file,
          width: width,
          height: height,
          alignment: left ? Alignment.centerLeft : Alignment.centerRight,
          fit: width > height ? BoxFit.fitHeight : BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
        );
      }
    }

    if (content == null) {
      if (localPath?.isNotEmpty == true) {
        final file = File(localPath!);
        bool exists = file.existsSync();
        if (exists) {
          content = Image.file(
            file,
            width: width,
            height: height,
            alignment: left ? Alignment.centerLeft : Alignment.centerRight,
            fit: width > height ? BoxFit.fitHeight : BoxFit.fitWidth,
            filterQuality: FilterQuality.low,
          );
        }
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

    content = SizedBox(
      width: width,
      height: height,
      child: content,
    );
    return content;
  }

  void download() {
    if (downloading) return;
    downloading = true;
    ChatUIKit.instance.downloadThumbnail(message: message);
  }
}
