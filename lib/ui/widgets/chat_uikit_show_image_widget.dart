import 'dart:io';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitShowImageWidget extends StatefulWidget {
  const ChatUIKitShowImageWidget({
    required this.message,
    this.onLongPressed,
    this.onTap,
    this.onError,
    this.onProgress,
    this.onSuccess,
    super.key,
  });

  final void Function(Message message)? onLongPressed;
  final void Function(Message message)? onTap;
  final void Function(ChatError error)? onError;
  final void Function(int progress)? onProgress;
  final VoidCallback? onSuccess;

  final Message message;

  @override
  State<ChatUIKitShowImageWidget> createState() =>
      _ChatUIKitShowImageWidgetState();
}

class _ChatUIKitShowImageWidgetState extends State<ChatUIKitShowImageWidget>
    with MessageObserver {
  Message? message;

  String? localPath;
  String? localThumbPath;
  String? remoteThumbPath;

  final ValueNotifier<int> _progress = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    message = widget.message;
    ChatUIKit.instance.addObserver(this);
    checkFile();
  }

  void checkFile() {
    if (message!.localPath?.isNotEmpty == true) {
      File file = File(message!.localPath!);
      if (file.existsSync()) {
        localPath = message!.localPath;
      } else {
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          ChatUIKit.instance.downloadAttachment(message: message!);
        });
      }
    }

    if (localPath?.isNotEmpty == true) {
      safeSetState(() {});
      return;
    }

    if (message!.thumbnailLocalPath?.isNotEmpty == true) {
      File file = File(message!.thumbnailLocalPath!);
      if (file.existsSync()) {
        localThumbPath = message!.thumbnailLocalPath;
      }
    }

    if (localThumbPath?.isNotEmpty == true) {
      safeSetState(() {});
      return;
    }

    if (message!.thumbnailRemotePath?.isNotEmpty == true) {
      remoteThumbPath = message!.thumbnailRemotePath;
    }

    if (remoteThumbPath?.isNotEmpty == true) {
      safeSetState(() {});
      return;
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProgress(String msgId, int progress) {
    if (message!.msgId == msgId) {
      _progress.value = progress;
      widget.onProgress?.call(progress);
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (message!.msgId == msgId) {
      message = msg;
      widget.onError?.call(error);
    }
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (message!.msgId == msgId) {
      message = msg;
      widget.onSuccess?.call();
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
        if (widget.onTap != null) {
          widget.onTap!(message!);
        }
      },
      onLongPress: () {
        if (widget.onLongPressed != null) {
          widget.onLongPressed!(message!);
        }
      },
      child: content,
    );

    return content;
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
