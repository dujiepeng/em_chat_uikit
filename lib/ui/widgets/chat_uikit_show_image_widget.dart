import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitShowImageWidget extends StatefulWidget {
  const ChatUIKitShowImageWidget({
    required this.message,
    this.onImageLongPressed,
    this.onImageTap,
    super.key,
  });

  final void Function(Message message)? onImageLongPressed;
  final void Function(Message message)? onImageTap;
  final Message message;

  @override
  State<ChatUIKitShowImageWidget> createState() =>
      _ChatUIKitShowImageWidgetState();
}

class _ChatUIKitShowImageWidgetState extends State<ChatUIKitShowImageWidget>
    with MessageObserver {
  late final Message message;

  final ValueNotifier<int> _progress = ValueNotifier(0);

  String? localPath;
  String? localThumbPath;
  String? remoteThumbPath;

  @override
  void initState() {
    super.initState();
    message = widget.message;
    ChatUIKit.instance.addObserver(this);
    checkFile();
  }

  void checkFile() {
    if (message.localPath?.isNotEmpty == true) {
      File file = File(message.localPath!);
      if (file.existsSync()) {
        localPath = message.localPath;
      } else {
        ChatUIKit.instance.downloadAttachment(message: message);
      }
    }

    if (localPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }

    if (message.thumbnailLocalPath?.isNotEmpty == true) {
      File file = File(message.thumbnailLocalPath!);
      if (file.existsSync()) {
        localThumbPath = message.thumbnailLocalPath;
      }
    }

    if (localThumbPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }

    if (message.thumbnailRemotePath?.isNotEmpty == true) {
      remoteThumbPath = message.thumbnailRemotePath;
    }

    if (remoteThumbPath?.isNotEmpty == true) {
      setState(() {});
      return;
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProgress(String msgId, int progress) {
    if (message.msgId == msgId) {
      _progress.value = progress;
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (message.msgId == msgId) {
      message = msg;
    }
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (message.msgId == msgId) {
      message = msg;
      checkFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (localPath?.isNotEmpty == true) {
      content = Image.file(File(localPath!));
    }

    if (content == null && localThumbPath?.isNotEmpty == true) {
      content = Image.file(File(localThumbPath!));
    }

    if (content == null && remoteThumbPath?.isNotEmpty == true) {
      content = Image.network(remoteThumbPath ?? '');
    }

    content ??= const Icon(Icons.broken_image, size: 58, color: Colors.white);

    content = InteractiveViewer(
      child: content,
    );
    content = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: content,
    );

    content = InkWell(
      onTap: () {
        if (widget.onImageTap != null) {
          widget.onImageTap!(message);
        }
      },
      onLongPress: () {
        if (widget.onImageLongPressed != null) {
          widget.onImageLongPressed!(message);
        }
      },
      child: content,
    );
    return content;
  }
}
